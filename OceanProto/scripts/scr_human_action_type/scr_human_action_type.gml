
function HumanActionType(_debug_name/*: string*/) constructor
{
    debug_name = _debug_name;   /// @is {string}
    
    // virtual
    static try_initiate = function(human/*: obj_human*/, tick_rng/*: Rng*/) /*-> HumanAction?*/
    {
        return undefined;
    }
    
    // virtual
    static get_weight = function(personality_traits/*: PersonalityTraits*/, energy_level/*: number*/) /*-> number*/
    {
        return 1.0;
    }
}

function _HAT_ApproachFood() : HumanActionType("Approach Food") constructor
{
    // override
    static try_initiate = function(human/*: obj_human*/, tick_rng/*: Rng*/) /*-> HumanAction?*/
    {
        if (human.energy > human.energy_max - Configs.human_energy_gain_eat_food) {
            // Eating the food would get your energy over the max - don't bother.
            return undefined;
        }
        var food = human.choose_action_target(obj_food, Configs.target_weight_approach_food, tick_rng) /*#as obj_food*/;
        if (!instance_exists(food)) {
            return undefined;
        }
        return new HA_ApproachFood(food);
    }
    
    // override
    static get_weight = function(personality_traits/*: PersonalityTraits*/, energy_level/*: number*/) /*-> number*/
    {
        return Configs.weight_approach_food(personality_traits, energy_level);
    }
}

function _HAT_ApproachMonster() : HumanActionType("Approach Monster") constructor
{
    // override
    static try_initiate = function(human/*: obj_human*/, tick_rng/*: Rng*/) /*-> HumanAction?*/
    {
        var target_monster = human.choose_action_target(obj_monster, Configs.target_weight_approach_monster, tick_rng) /*#as obj_monster*/;
        if (!instance_exists(target_monster)) {
            return undefined;
        }
        var is_adjacent_to_target = abs(floor(human.x / CSIZE) - floor(target_monster.x / CSIZE)) <= 1 && abs(floor(human.y / CSIZE) - floor(target_monster.y / CSIZE)) <= 1;
        if (is_adjacent_to_target) {
            // Already adjacent to target - no need to approach anymore.
            return undefined;
        }
        return new HA_ApproachMonster(target_monster);
    }
    
    // override
    static get_weight = function(personality_traits/*: PersonalityTraits*/, energy_level/*: number*/) /*-> number*/
    {
        return Configs.weight_approach_monster(personality_traits, energy_level);
    }
}

function _HAT_ApproachHuman() : HumanActionType("Approach Human") constructor
{
    // override
    static try_initiate = function(human/*: obj_human*/, tick_rng/*: Rng*/) /*-> HumanAction?*/
    {
        var other_human = human.choose_action_target(obj_human, Configs.target_weight_approach_human, tick_rng) /*#as obj_human*/;
        if (!instance_exists(other_human)) {
            return undefined;
        }
        var is_adjacent_to_target = abs(floor(human.x / CSIZE) - floor(other_human.x / CSIZE)) <= 1 && abs(floor(human.y / CSIZE) - floor(other_human.y / CSIZE)) <= 1;
        if (is_adjacent_to_target) {
            // Already adjacent to target - no need to approach anymore.
            return undefined;
        }
        return new HA_ApproachHuman(other_human);
    }
    
    // override
    static get_weight = function(personality_traits/*: PersonalityTraits*/, energy_level/*: number*/) /*-> number*/
    {
        return Configs.weight_approach_human(personality_traits, energy_level);
    }
}

function _HAT_AvoidMonster() : HumanActionType("Avoid Monster") constructor
{
    // override
    static try_initiate = function(human/*: obj_human*/, tick_rng/*: Rng*/) /*-> HumanAction?*/
    {
        var monster = human.choose_action_target(obj_monster, Configs.target_weight_avoid_monster, tick_rng) /*#as obj_monster*/;
        if (instance_exists(monster)) {
            return new HA_AvoidMonster(monster);
        }
        return undefined;
    }
    
    // override
    static get_weight = function(personality_traits/*: PersonalityTraits*/, energy_level/*: number*/) /*-> number*/
    {
        return Configs.weight_avoid_monster(personality_traits, energy_level);
    }
}

function _HAT_AvoidHuman() : HumanActionType("Avoid Human") constructor
{
    // override
    static try_initiate = function(human/*: obj_human*/, tick_rng/*: Rng*/) /*-> HumanAction?*/
    {
        var other_human = human.choose_action_target(obj_human, Configs.target_weight_avoid_human, tick_rng) /*#as obj_human*/;
        if (instance_exists(other_human)) {
            return new HA_AvoidHuman(other_human);
        }
        return undefined;
    }
    
    // override
    static get_weight = function(personality_traits/*: PersonalityTraits*/, energy_level/*: number*/) /*-> number*/
    {
        return Configs.weight_avoid_human(personality_traits, energy_level);
    }
}

function _HAT_AttackMonster() : HumanActionType("Attack Monster") constructor
{
    // override
    static try_initiate = function(human/*: obj_human*/, tick_rng/*: Rng*/) /*-> HumanAction?*/
    {
        // TODO: Should prioritize a monster that we've been previously attacking?
        for (var i = 0, len = instance_number(obj_monster); i < len; ++i) {
            var monster = instance_find(obj_monster, i);
            if (creature_is_within_attack_range(human, monster)) {
                return new HA_AttackMonster(monster);
            }
        }
        return undefined;
    }
    
    // override
    static get_weight = function(personality_traits/*: PersonalityTraits*/, energy_level/*: number*/) /*-> number*/
    {
        return Configs.weight_attack_monster(personality_traits, energy_level);
    }
}

function _HAT_AttackHuman() : HumanActionType("Attack Human") constructor
{
    // override
    static try_initiate = function(human/*: obj_human*/, tick_rng/*: Rng*/) /*-> HumanAction?*/
    {
        // TODO: Should prioritize a human that we've been previously attacking?
        for (var i = 0, len = instance_number(obj_human); i < len; ++i) {
            var other_human = instance_find(obj_human, i);
            if (other_human == human) {
                continue;
            }
            if (creature_is_within_attack_range(human, other_human)) {
                return new HA_AttackHuman(other_human);
            }
        }
        return undefined;
    }
    
    // override
    static get_weight = function(personality_traits/*: PersonalityTraits*/, energy_level/*: number*/) /*-> number*/
    {
        return Configs.weight_attack_human(personality_traits, energy_level);
    }
}

function _HAT_ExchangeWithHuman() : HumanActionType("Exchange") constructor
{
    // override
    static try_initiate = function(human/*: obj_human*/, tick_rng/*: Rng*/) /*-> HumanAction?*/
    {
        var has_max_energy = human.energy >= human.energy_max;
        // TODO: Should prioritize a human that we've been previously exchanging with?
        for (var i = 0, len = instance_number(obj_human); i < len; ++i) {
            var other_human = instance_find(obj_human, i);
            if (other_human == human) {
                // don't exchange with yourself
                continue;
            }
            if (has_max_energy && other_human.energy >= other_human.energy_max) {
                // don't exchange if both humans already have max energy
                continue;
            }
            var is_adjacent_to_target = abs(floor(human.x / CSIZE) - floor(other_human.x / CSIZE)) <= 1 && abs(floor(human.y / CSIZE) - floor(other_human.y / CSIZE)) <= 1;
            if (is_adjacent_to_target) {
                return new HA_ExchangeWithHuman(other_human);
            }
        }
        return undefined;
    }
    
    // override
    static get_weight = function(personality_traits/*: PersonalityTraits*/, energy_level/*: number*/) /*-> number*/
    {
        return Configs.weight_exchange_with_human(personality_traits, energy_level);
    }
}

function _HAT_Explore() : HumanActionType("Explore") constructor
{
    // override
    static try_initiate = function(human/*: obj_human*/, tick_rng/*: Rng*/) /*-> HumanAction?*/
    {
        // Don't initiate a new exploration action if there's already one in memory.
        for (var i = 0, len = array_length(human.actions_in_memory); i < len; ++i) {
            if (human.actions_in_memory[i].type == self) {
                return undefined;
            }
        }
        
        var target_cell = human_find_exploration_pathfinding_target(human, tick_rng);
        return new HA_Explore(target_cell);
    }
    
    // override
    static get_weight = function(personality_traits/*: PersonalityTraits*/, energy_level/*: number*/) /*-> number*/
    {
        return Configs.weight_explore(personality_traits, energy_level);
    }
}

function initialize_human_action_types()
{
    CALL_ONLY_ONCE
    
    global.all_human_action_types = []; /// @is {HumanActionType[]}
    
    globalvar HAT_approach_food;        /// @is {HumanActionType}
    HAT_approach_food = new _HAT_ApproachFood();
    array_push(global.all_human_action_types, HAT_approach_food);
    
    globalvar HAT_approach_monster;     /// @is {HumanActionType}
    HAT_approach_monster = new _HAT_ApproachMonster();
    array_push(global.all_human_action_types, HAT_approach_monster);
    
    globalvar HAT_approach_human;       /// @is {HumanActionType}
    HAT_approach_human = new _HAT_ApproachHuman();
    array_push(global.all_human_action_types, HAT_approach_human);
    
    globalvar HAT_avoid_monster;        /// @is {HumanActionType}
    HAT_avoid_monster = new _HAT_AvoidMonster();
    array_push(global.all_human_action_types, HAT_avoid_monster);
    
    globalvar HAT_avoid_human;          /// @is {HumanActionType}
    HAT_avoid_human = new _HAT_AvoidHuman();
    array_push(global.all_human_action_types, HAT_avoid_human);
    
    globalvar HAT_attack_monster;       /// @is {HumanActionType}
    HAT_attack_monster = new _HAT_AttackMonster();
    array_push(global.all_human_action_types, HAT_attack_monster);
    
    globalvar HAT_attack_human;         /// @is {HumanActionType}
    HAT_attack_human = new _HAT_AttackHuman();
    array_push(global.all_human_action_types, HAT_attack_human);
    
    globalvar HAT_exchange_with_human;  /// @is {HumanActionType}
    HAT_exchange_with_human = new _HAT_ExchangeWithHuman();
    array_push(global.all_human_action_types, HAT_exchange_with_human);
    
    globalvar HAT_explore;              /// @is {HumanActionType}
    HAT_explore = new _HAT_Explore();
    array_push(global.all_human_action_types, HAT_explore);
    
}

