event_inherited();

_creature_initialize(Configs.monster_energy_max, Configs.monster_starting_energy);

creature_sprites.set(
    spr_spider_idle,
    spr_spider_walk,
    spr_spider_idle,
    spr_spider_attack,
    spr_spider_idle,
    spr_spider_idle,
    spr_spider_idle,
    spr_spider_dead
);

shadow_radius = 32;

draw_outline = true;

target_creature = noone;                /// @is {obj_creature}
target_food = noone;                    /// @is {obj_food}
target_cell_around_food = undefined;    /// @is {TerrainCell?}
target_food_cell_timer = 0;             /// @is {number}
exploration_timer = 0;                  /// @is {number}
target_explore_cell = undefined;        /// @is {TerrainCell?}

movement_speed              = Configs.monster_movement_speed;               /// @is {number}
exploration_movement_speed  = Configs.monster_exploration_movement_speed;   /// @is {number}
sight_range                 = Configs.monster_sight_range;                  /// @is {number}
exploration_range           = Configs.monster_exploration_range;            /// @is {number}

fight_action_sampler.clear();
fight_action_sampler.add(CREATURE_FIGHT_ACTION.hit, Configs.monster_fight_hit_weight);
fight_action_sampler.add(CREATURE_FIGHT_ACTION.miss, Configs.monster_fight_miss_weight);
fight_action_sampler.add(CREATURE_FIGHT_ACTION.flee, Configs.monster_fight_flee_weight);
if (fight_action_sampler.total_weight <= 0) {
    log_error("The total weight of fight actions (hit, miss, flee) is zero or negative! This will cause problems.");
}

first_attack_damage     = Configs.monster_first_attack_damage;
normal_attack_damage    = Configs.monster_normal_attack_damage;
attacker_energy_gain    = Configs.monster_attacker_energy_gain;

Trial.ticker.on_tick(id, function(tick_number/*: int*/, tick_rng/*: Rng*/) {
    
    if (energy <= 0) {
        instance_destroy();
        return;
    }
    
    if (!instance_exists(target_food)) {
        target_food = instance_nearest(x, y, obj_food);
    }
    
    var move_speed_multiplier = Trial.terrain.cell_at_room(x, y).is_sand ? Configs.monster_sand_move_speed_multiplier : 1.0;
    
    if (instance_exists(target_creature)) {
        
        var can_see_target = point_distance(x, y, target_creature.x, target_creature.y) < sight_range;
        if (can_see_target) {
            
            // Approach the target.
            var target_cell = creature_find_pathfinding_adjacent_target_cell(id, Trial.terrain.cell_at_room(target_creature.x, target_creature.y));
            creature_approach(id, target_cell, movement_speed * move_speed_multiplier);
            
            // Attack the target.
            if (can_attack_creature(target_creature) && creature_is_within_attack_range(id, target_creature)) {
                var fight_action = attack_creature(target_creature, tick_number, tick_rng);
                if (fight_action == CREATURE_FIGHT_ACTION.flee) {
                    // TODO: Should monsters flee?
                }
            }
        }
        else {
            // Can't see the target (anymore) - forget it.
            target_creature = noone;
        }
    }
    else {
        // Find a target creature within range.
        var candidate_target_creature = instance_nearest(x, y, obj_human);
        if (instance_exists(candidate_target_creature) && point_distance(x, y, candidate_target_creature.x, candidate_target_creature.y) < sight_range) {
            target_creature = candidate_target_creature;
        }
        
        if (!instance_exists(target_creature)) {
            if (instance_exists(target_food)) {
                // Didn't find a suitable target creature? Wander around food then.
                if (target_food_cell_timer > 0) {
                    target_food_cell_timer -=1;
                }
                else {
                    target_food_cell_timer = tick_rng.rng_irandom_range(120, 240);
                    target_cell_around_food = find_pathfinding_target_around_food(target_food, tick_rng);
                }
                if (target_cell_around_food != undefined) {
                    creature_approach(id, target_cell_around_food, exploration_movement_speed * move_speed_multiplier);
                }
            }
            else {
                if (exploration_timer > 0) {
                    exploration_timer -=1;
                }
                else {
                    exploration_timer = tick_rng.rng_irandom_range(120, 240);
                    target_explore_cell = find_exploring_pathfinding_target(tick_rng);
                }
                if (target_explore_cell != undefined) {
                    creature_approach(id, target_explore_cell, exploration_movement_speed * move_speed_multiplier);
                }
            }
        }
    }
});

find_pathfinding_target_around_food = function(food/*: obj_food*/, tick_rng/*: Rng*/) /*-> TerrainCell?*/
{
    var food_cx = floor(food.x / CSIZE);
    var food_cy = floor(food.y / CSIZE);
    var cx1 = clamp(food_cx - 3, 0, Trial.terrain.width - 1);
    var cy1 = clamp(food_cy - 3, 0, Trial.terrain.height - 1);
    var cx2 = clamp(food_cx + 3, 0, Trial.terrain.width - 1);
    var cy2 = clamp(food_cy + 3, 0, Trial.terrain.height - 1);
    var tcells = Trial.terrain.cells;
    static candidate_cells = [];
    var num_candidate_cells = 0;
    for (var cx = cx1; cx <= cx2; ++cx) {
        for (var cy = cy1; cy <= cy2; ++cy) {
            var cell = tcells[cy][cx];
            if (!cell.is_traversable) {
                continue;
            }
            candidate_cells[num_candidate_cells++] = cell;
        }
    }
    if (num_candidate_cells <= 0) {
        return undefined;
    }
    return tick_rng.rng_array_get_random(candidate_cells, 0, num_candidate_cells);
}

find_exploring_pathfinding_target = function(tick_rng/*: Rng*/) /*-> TerrainCell?*/
{
    var me_cx = floor(x / CSIZE);
    var me_cy = floor(y / CSIZE);
    var cell_sight_radius = floor(exploration_range / CSIZE);
    var cx1 = clamp(me_cx - cell_sight_radius, 0, Trial.terrain.width - 1);
    var cy1 = clamp(me_cy - cell_sight_radius, 0, Trial.terrain.height - 1);
    var cx2 = clamp(me_cx + cell_sight_radius, 0, Trial.terrain.width - 1);
    var cy2 = clamp(me_cy + cell_sight_radius, 0, Trial.terrain.height - 1);
    var tcells = Trial.terrain.cells;
    static candidate_cells = [];
    var num_candidate_cells = 0;
    for (var cx = cx1; cx <= cx2; ++cx) {
        for (var cy = cy1; cy <= cy2; ++cy) {
            if (point_distance(me_cx, me_cy, cx, cy) > cell_sight_radius) {
                continue;
            }
            var cell = tcells[cy][cx];
            if (!cell.is_traversable) {
                continue;
            }
            candidate_cells[num_candidate_cells++] = cell;
        }
    }
    if (num_candidate_cells <= 0) {
        return undefined;
    }
    return tick_rng.rng_array_get_random(candidate_cells, 0, num_candidate_cells);
}
