
function HumanAction() constructor
{
    type = /*#cast*/ undefined;  /// @is {HumanActionType}
    
    // virtual
    static tick = function(human/*: obj_human*/, tick_number/*: int*/, tick_rng/*: Rng*/) /*-> bool*/
    {
        return false;
    }
    
    // virtual
    static equals = function(other_action/*: HumanAction*/) /*-> bool*/
    {
        return false;
    }
    
    static debug_string = function(use_scribble_colors/*: bool*/) /*-> string*/
    {
        var str = type.debug_name;
        var names = variable_struct_get_names(self);
        for (var i = 0, len = array_length(names); i < len; ++i) {
            var name = names[i];
            var value = self[$ name];
            var is_instance = (typeof(value) == "number") || (typeof(value) == "ref");
            if (value == noone) {
                str += " noone";
            }
            else if (is_instance && instance_exists(value)) {
                str += " " + EID(value, use_scribble_colors);
            }
        }
        return str;
    }
}

function human_actions_equal(action1/*: HumanAction*/, action2/*: HumanAction*/) /*-> bool*/
{
    if (action1.type != action2.type) {
        return false;
    }
    return action1.equals(action2);
}

function HA_ApproachFood(
    _target_food/*: obj_food*/
) : HumanAction() constructor
{
    type = HAT_approach_food; // override
    
    target_food = _target_food; /// @is {obj_food}
    
    // override
    static tick = function(human/*: obj_human*/, tick_number/*: int*/, tick_rng/*: Rng*/) /*-> bool*/
    {
        if (!instance_exists(target_food)) {
            return false;
        }
        var target_cell = Trial.terrain.cell_at_room(target_food.x, target_food.y);
        creature_approach(human, target_cell, human.get_movement_speed());
        if (point_distance(human.x, human.y, target_food.x, target_food.y) < CSIZE / 2) {
            instance_destroy(target_food);
            var energy_gain = Configs.human_energy_gain_eat_food;
            human.energy += energy_gain;
            human.energy = min(human.energy, human.energy_max);
            if (!Trial.is_auto_run) {
                Trial.log_event(EID(human) + " ate food and gained " + string(energy_gain) + " energy for it.");
                var is_player = object_is_ancestor(human.object_index, obj_human_player);
                sfx_world_play(snd_eat_food, is_player, random_range(0.8, 1.2));
                sfx_world_play(snd_emote_heart_up, is_player, random_range(0.8, 1.2));
            }
            return false;
        }
        return true;
    }
    
    // override
    static equals = function(other_action/*: HA_ApproachFood*/) /*-> bool*/
    {
        return (target_food == other_action.target_food);
    }
}

function HA_ApproachMonster(
    _target_monster/*: obj_monster*/
) : HumanAction() constructor
{
    type = HAT_approach_monster; // override
    
    target_monster = _target_monster; /// @is {obj_monster}
    
    // override
    static tick = function(human/*: obj_human*/, tick_number/*: int*/, tick_rng/*: Rng*/) /*-> bool*/
    {
        if (!instance_exists(target_monster)) {
            return false;
        }
        
        if (point_distance(human.x, human.y, target_monster.x, target_monster.y) > human.sight_range) {
            // Too far away, stop now.
            return false;
        }
        
        var is_adjacent_to_target = abs(floor(human.x / CSIZE) - floor(target_monster.x / CSIZE)) <= 1 && abs(floor(human.y / CSIZE) - floor(target_monster.y / CSIZE)) <= 1;
        if (is_adjacent_to_target) {
            // Already reached the target, stop now.
            return false;
        }
        
        var target_cell = creature_find_pathfinding_adjacent_target_cell(human, Trial.terrain.cell_at_room(target_monster.x, target_monster.y));
        creature_approach(human, target_cell, human.get_movement_speed());
        return true;
    }
    
    // override
    static equals = function(other_action/*: HA_ApproachMonster*/) /*-> bool*/
    {
        return (target_monster == other_action.target_monster);
    }
}

function HA_ApproachHuman(
    _target_human/*: obj_human*/
) : HumanAction() constructor
{
    type = HAT_approach_human; // override
    
    target_human = _target_human; /// @is {obj_human}
    
    // override
    static tick = function(human/*: obj_human*/, tick_number/*: int*/, tick_rng/*: Rng*/) /*-> bool*/
    {
        if (!instance_exists(target_human)) {
            return false;
        }
        
        if (point_distance(human.x, human.y, target_human.x, target_human.y) > human.sight_range) {
            // Too far away, stop now.
            return false;
        }
        
        var is_adjacent_to_target = abs(floor(human.x / CSIZE) - floor(target_human.x / CSIZE)) <= 1 && abs(floor(human.y / CSIZE) - floor(target_human.y / CSIZE)) <= 1;
        if (is_adjacent_to_target) {
            // Already reached the target, stop now.
            return false;
        }
        
        var target_cell = creature_find_pathfinding_adjacent_target_cell(human, Trial.terrain.cell_at_room(target_human.x, target_human.y));
        creature_approach(human, target_cell, human.get_movement_speed());
        return true;
    }
    
    // override
    static equals = function(other_action/*: HA_ApproachHuman*/) /*-> bool*/
    {
        return (target_human == other_action.target_human);
    }
}

function HA_AvoidMonster(
    _target_monster/*: obj_monster*/
) : HumanAction() constructor
{
    type = HAT_avoid_monster; // override
    
    target_monster = _target_monster; /// @is {obj_monster}
    
    target_cell = undefined;            /// @is {TerrainCell?}
    tick_at_last_target_cell_find = 0;  /// @is {int}
    
    // override
    static tick = function(human/*: obj_human*/, tick_number/*: int*/, tick_rng/*: Rng*/) /*-> bool*/
    {
        if (!instance_exists(target_monster)) {
            return false;
        }
        if (point_distance(human.x, human.y, target_monster.x, target_monster.y) > human.sight_range) {
            return false;
        }
        
        // Search for a new target cell if either 1. we don't have one yet or 2. it's been long enough since the last time we searched for one
        if (target_cell == undefined || tick_number - tick_at_last_target_cell_find > 60) {
            target_cell = creature_find_pathfinding_avoiding_target_cell(human, target_monster.x, target_monster.y);
            tick_at_last_target_cell_find = tick_number;
        }
        
        creature_approach(human, target_cell, human.get_movement_speed());
        return true;
    }
    
    // override
    static equals = function(other_action/*: HA_AvoidMonster*/) /*-> bool*/
    {
        return (target_monster == other_action.target_monster);
    }
}

function HA_AvoidHuman(
    _target_human/*: obj_human*/
) : HumanAction() constructor
{
    type = HAT_avoid_human; // override
    
    target_human = _target_human; /// @is {obj_human}
    
    target_cell = undefined;            /// @is {TerrainCell?}
    tick_at_last_target_cell_find = 0;  /// @is {int}
    
    // override
    static tick = function(human/*: obj_human*/, tick_number/*: int*/, tick_rng/*: Rng*/) /*-> bool*/
    {
        if (!instance_exists(target_human)) {
            return false;
        }
        if (point_distance(human.x, human.y, target_human.x, target_human.y) > human.sight_range) {
            return false;
        }
        
        // Search for a new target cell if either 1. we don't have one yet or 2. it's been long enough since the last time we searched for one
        if (target_cell == undefined || tick_number - tick_at_last_target_cell_find > 60) {
            target_cell = creature_find_pathfinding_avoiding_target_cell(human, target_human.x, target_human.y);
            tick_at_last_target_cell_find = tick_number;
        }
        
        creature_approach(human, target_cell, human.get_movement_speed());
        return true;
    }
    
    // override
    static equals = function(other_action/*: HA_AvoidHuman*/) /*-> bool*/
    {
        return (target_human == other_action.target_human);
    }
}

function HA_AttackMonster(
    _target_monster/*: obj_monster*/
) : HumanAction() constructor
{
    type = HAT_attack_monster; // override
    
    target_monster = _target_monster;   /// @is {obj_monster}
    
    first_tick_done = false;    /// @is {bool}
    
    // override
    static tick = function(human/*: obj_human*/, tick_number/*: int*/, tick_rng/*: Rng*/) /*-> bool*/
    {
        if (!instance_exists(target_monster)) {
            return false;
        }
        if (!first_tick_done) {
            // Reset attack cooldown timer on the first tick of this action so that an attack can
            // be done immediately when starting a new attack action.
            first_tick_done = true;
            human.attack_cooldown_timer = 0;
        }
        if (!creature_is_within_attack_range(human, target_monster)) {
            return false;
        }
        if (human.can_attack_creature(target_monster)) {
            var fight_action = human.attack_creature(target_monster, tick_number, tick_rng);
            if (fight_action == CREATURE_FIGHT_ACTION.flee) {
                human.stop_equal_actions(self);
                human.force_start_action(new HA_AvoidMonster(target_monster));
            }
        }
        return true;
    }
    
    // override
    static equals = function(other_action/*: HA_AttackMonster*/) /*-> bool*/
    {
        return (target_monster == other_action.target_monster);
    }
}

function HA_AttackHuman(
    _target_human/*: obj_human*/
) : HumanAction() constructor
{
    type = HAT_attack_human; // override
    
    target_human = _target_human; /// @is {obj_human}
    
    first_tick_done = false;    /// @is {bool}
    
    // override
    static tick = function(human/*: obj_human*/, tick_number/*: int*/, tick_rng/*: Rng*/) /*-> bool*/
    {
        if (!instance_exists(target_human)) {
            return false;
        }
        if (!first_tick_done) {
            // Reset attack cooldown timer on the first tick of this action so that an attack can
            // be done immediately when starting a new attack action.
            first_tick_done = true;
            human.attack_cooldown_timer = 0;
        }
        if (!creature_is_within_attack_range(human, target_human)) {
            return false;
        }
        if (human.can_attack_creature(target_human)) {
            var fight_action = human.attack_creature(target_human, tick_number, tick_rng);
            if (fight_action == CREATURE_FIGHT_ACTION.flee) {
                human.stop_equal_actions(self);
                human.force_start_action(new HA_AvoidHuman(target_human));
            }
        }
        return true;
    }
    
    // override
    static equals = function(other_action/*: HA_AttackHuman*/) /*-> bool*/
    {
        return (target_human == other_action.target_human);
    }
}

function HA_ExchangeWithHuman(
    _target_human/*: obj_human*/
) : HumanAction() constructor
{
    type = HAT_exchange_with_human; // override
    
    target_human = _target_human; /// @is {obj_human}
    
    first_tick_done = false;    /// @is {bool}
    
    // override
    static tick = function(human/*: obj_human*/, tick_number/*: int*/, tick_rng/*: Rng*/) /*-> bool*/
    {
        if (!instance_exists(target_human)) {
            return false;
        }
        
        var is_adjacent_to_target = abs(floor(human.x / CSIZE) - floor(target_human.x / CSIZE)) <= 1 && abs(floor(human.y / CSIZE) - floor(target_human.y / CSIZE)) <= 1;
        if (!is_adjacent_to_target) {
            // Too far from target - stop now.
            return false;
        }
        
        if (!first_tick_done) {
            first_tick_done = true;
            // On the first tick see if the target would like to immediately respond to the exchange.
            var target_current_action = target_human.get_current_action();
            var is_already_exchanging_with_me = (target_current_action != undefined)
                                             && (target_current_action.type == type)
                                             && (target_current_action.target_human == human);
            if (!is_already_exchanging_with_me) {
                if (tick_rng.rng_random(100) < target_human.exchange_back_chance) {
                    target_human.force_start_action(new HA_ExchangeWithHuman(human));
                }
            }
        }
        
        var involves_player = object_is_ancestor_or_child(human.object_index, obj_human_player) || object_is_ancestor_or_child(target_human.object_index, obj_human_player);
        
        if (!Trial.is_auto_run && involves_player && !fx_creature_has_speech_bubble(human, spr_emote_hand_waving)) {
            var dir = point_direction(human.x, human.y, target_human.x, target_human.y);
            fx_create_speech_bubble(human, spr_emote_hand_waving, false, dir);
        }
        
        var targets_current_action = target_human.get_current_action() /*#as HA_ExchangeWithHuman*/;
        var target_is_exchanging_with_me = (targets_current_action != undefined)
                                        && (targets_current_action.type == HAT_exchange_with_human)
                                        && (targets_current_action.target_human == human);
        if (target_is_exchanging_with_me && real(human.id) < real(target_human.id)) {
            if (human.can_exchange_with_human(target_human)) {
                if (!Trial.is_auto_run && involves_player) {
                    fx_creature_clear_speech_bubbles(human);
                    fx_creature_clear_speech_bubbles(target_human);
                    var dir = point_direction(human.x, human.y, target_human.x, target_human.y);
                    fx_create_speech_bubble(human, spr_emote_hand_waving, false, dir);
                    fx_create_speech_bubble(target_human, spr_emote_hand_waving, false, dir + 180);
                }
                human.exchange_with_human(target_human, tick_number, tick_rng);
            }
        }
        return true;
    }
    
    // override
    static equals = function(other_action/*: HA_ExchangeWithHuman*/) /*-> bool*/
    {
        return (target_human == other_action.target_human);
    }
}

function HA_Explore(_target_cell/*: TerrainCell?*/) : HumanAction() constructor
{
    type = HAT_explore; // override
    
    target_cell = _target_cell; /// @is {TerrainCell?}
    
    // override
    static tick = function(human/*: obj_human*/, tick_number/*: int*/, tick_rng/*: Rng*/) /*-> bool*/
    {
        creature_approach(human, target_cell, human.get_movement_speed());
        // Keep going until human reaches the target cell.
        var human_cell = Trial.terrain.cell_at_room(human.x, human.y);
        return (human_cell != target_cell);
    }
    
    // override
    static equals = function(other_action/*: HA_Explore*/) /*-> bool*/
    {
        return (target_cell == other_action.target_cell);
    }
}
