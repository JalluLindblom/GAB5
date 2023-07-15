event_inherited();

_creature_initialize(Configs.human_energy_max, Configs.human_starting_energy);

personality_traits = new PersonalityTraits(0, 0, 0, 0, 0);  /// @is {PersonalityTraits}
actions_in_memory = [];                                 /// @is {HumanAction[]}
action_choose_timer = 0;                                /// @is {number}
exchange_cooldown_timer = 0;                            /// @is {number}
constant_energy_loss_timer = 0;                         /// @is {number}

// These values and samplers will be filled when personality traits are set.
exchange_action_sampler = new WeightedRandomSampler();  /// @is {WeightedRandomSampler}
action_sampler = new WeightedRandomSampler();           /// @is {WeightedRandomSampler}
sight_range = 0;                                        /// @is {number}
counter_attack_chance_against_human = 0;                /// @is {number}
counter_attack_chance_against_monster = 0;              /// @is {number}
exploration_range = 0;                                  /// @is {number}
exchange_back_chance = 0;                               /// @is {number}

// Weight of each action type. Recalculated any time any of the parameters are changed.
action_weights = ds_map_create();       /// @is {ds_map<HumanActionType, number>}
// Movement speed per each action type. Recalculated any time any of the parameters are changed.
action_move_speeds = ds_map_create();   /// @is {ds_map<HumanActionType, number>}

got_attacked_event.listen(function(attacker_creature/*: obj_creature*/, fight_action/*: CREATURE_FIGHT_ACTION*/, tick_number/*: int*/, tick_rng/*: Rng*/) {
    
    if (fight_action == CREATURE_FIGHT_ACTION.flee) {
        // If the attacker just fled, don't do anything.
        return;
    }
    
    var attacker_is_human = object_is_ancestor_or_child(attacker_creature.object_index, obj_human);
    var counter_attack_chance = attacker_is_human ? counter_attack_chance_against_human : counter_attack_chance_against_monster;
    if (tick_rng.rng_random(100) < counter_attack_chance) {
        // Attack back.
        if (object_is_ancestor_or_child(attacker_creature.object_index, obj_monster)) {
            // Being attacked by a monster.
            force_start_action(new HA_AttackMonster(/*#cast*/ attacker_creature /*#as obj_monster*/));
        }
        else if (object_is_ancestor_or_child(attacker_creature.object_index, obj_human)) {
            // Being attacked by a human.
            force_start_action(new HA_AttackHuman(/*#cast*/ attacker_creature /*#as obj_human*/));
        }
        else {
            // There shouldn't be any other creatures than monsters and humans...
        }
        Trial.log_event(EID(id) + " starts to attack back when " + EID(attacker_creature) + " attacked them.");
    }
});

set_traits = function(_traits/*: PersonalityTraits*/)
{
    personality_traits = personality_traits_copied(_traits);
    
    re_evaluate_from_configs();
}

re_evaluate_from_configs = function()
{
    var energy_level = energy / energy_max;
    
    exchange_action_sampler.clear();
    exchange_action_sampler.add(CREATURE_EXCHANGE_ACTION.give, Configs.exchange_give_weight(personality_traits, energy_level));
    exchange_action_sampler.add(CREATURE_EXCHANGE_ACTION.take, Configs.exchange_take_weight(personality_traits, energy_level));
    if (exchange_action_sampler.total_weight <= 0) {
        log_error("The total weight of exchange actions (give & take) is zero or negative! This will cause problems.");
    }
    
    ds_map_clear(action_weights);
    action_sampler.clear();
    for (var i = 0, len = array_length(global.all_human_action_types); i < len; ++i) {
        var action_type = global.all_human_action_types[i];
        var weight = action_type.get_weight(personality_traits, energy_level);
        action_weights[? action_type] = weight;
        action_sampler.add(action_type, weight);
    }
    if (action_sampler.total_weight <= 0) {
        log_error("The total weight of actions is zero or negative! This will cause problems.");
    }
    
    fight_action_sampler.clear();
    fight_action_sampler.add(CREATURE_FIGHT_ACTION.hit, Configs.human_fight_hit_weight(personality_traits, energy_level));
    fight_action_sampler.add(CREATURE_FIGHT_ACTION.miss, Configs.human_fight_miss_weight(personality_traits, energy_level));
    fight_action_sampler.add(CREATURE_FIGHT_ACTION.flee, Configs.human_fight_flee_weight(personality_traits, energy_level));
    if (fight_action_sampler.total_weight <= 0) {
        log_error("The total weight of fight actions (hit, miss, flee) is zero or negative! This will cause problems.");
    }
    
    ds_map_clear(action_move_speeds);
    action_move_speeds[? HAT_approach_food]         = Configs.move_speed_approach_food(personality_traits, energy_level);
    action_move_speeds[? HAT_approach_monster]      = Configs.move_speed_approach_monster(personality_traits, energy_level);
    action_move_speeds[? HAT_approach_human]        = Configs.move_speed_approach_human(personality_traits, energy_level);
    action_move_speeds[? HAT_avoid_monster]         = Configs.move_speed_avoid_monster(personality_traits, energy_level);
    action_move_speeds[? HAT_avoid_human]           = Configs.move_speed_avoid_human(personality_traits, energy_level);
    action_move_speeds[? HAT_attack_monster]        = Configs.move_speed_attack_monster(personality_traits, energy_level);
    action_move_speeds[? HAT_attack_human]          = Configs.move_speed_attack_human(personality_traits, energy_level);
    action_move_speeds[? HAT_exchange_with_human]   = Configs.move_speed_exchange_with_human(personality_traits, energy_level);
    action_move_speeds[? HAT_explore]               = Configs.move_speed_explore(personality_traits, energy_level);
    
    sight_range                             = Configs.human_sight_range(personality_traits, energy_level);
    exploration_range                       = Configs.human_exploration_range(personality_traits, energy_level);
    counter_attack_chance_against_human     = Configs.human_counter_attack_chance_against_human(personality_traits, energy_level);
    counter_attack_chance_against_monster   = Configs.human_counter_attack_chance_against_monster(personality_traits, energy_level);
    exchange_back_chance                    = Configs.exchange_back_chance(personality_traits, energy_level);
    
    first_attack_damage		= Configs.human_first_attack_damage(personality_traits, energy_level);
	normal_attack_damage	= Configs.human_normal_attack_damage(personality_traits, energy_level);
	attacker_energy_gain	= Configs.human_attacker_energy_gain(personality_traits, energy_level);
}

get_movement_speed = function() /*-> number*/
{
    var action = array_length(actions_in_memory) > 0 ? actions_in_memory[0] : undefined;
    if (action == undefined) {
        return 0;
    }
    var spd = action_move_speeds[? action.type];
    if (Trial.terrain.cell_at_room(x, y).is_sand) {
        spd *= Configs.human_sand_move_speed_multiplier;
    }
    return spd;
}

get_current_action = function() /*-> HumanAction?*/
{
    return array_length(actions_in_memory) > 0 ? actions_in_memory[0] : undefined;
}

choose_action_target = function(object/*: object*/, evaluator/*: (function<PersonalityTraits, number, number, number>)*/, rng/*: Rng*/) /*-> instance*/
{
	static distances = [];
	
	var num_instances = instance_number(object);
	
	if (array_length(distances) < num_instances) {
		array_resize(distances, num_instances);
	}
	
	var min_distance = /*#cast*/ undefined /*#as number*/;
	var max_distance = /*#cast*/ undefined /*#as number*/;
	
	for (var i = 0; i < num_instances; ++i) {
		distances[i] = undefined;
		var inst = instance_find(object, i);
		if (inst == id) {
			continue;
		}
		var distance = point_distance(x, y, inst.x, inst.y);
		if (distance > sight_range) {
			continue;
		}
		distances[i] = distance;
		if (min_distance == undefined || distance < min_distance) {
			min_distance = distance;
		}
		if (max_distance == undefined || distance > max_distance) {
			max_distance = distance;
		}
	}
	
	var energy_level = energy / energy_max;
	
	static sampler = new WeightedRandomSampler();
	sampler.clear();
	
	for (var i = 0; i < num_instances; ++i) {
		var inst = instance_find(object, i);
		var distance = distances[i];
		if (distance == undefined) {
			continue;
		}
		var normalized_distance = (min_distance == max_distance) ? 0.0 : inv_lerp(min_distance, max_distance, distance);
		var weight = evaluator(personality_traits, energy_level, normalized_distance);
		sampler.add(inst, weight);
	}
	
	return sampler.get(noone, rng);
}

can_exchange_with_human = function(target_human/*: obj_human*/) /*-> bool*/
{
    return exchange_cooldown_timer <= 0 && target_human.exchange_cooldown_timer <= 0;
}

exchange_with_human = function(target_human/*: obj_human*/, tick_number/*: int*/, tick_rng/*: Rng*/)
{
    var cha = exchange_action_sampler.get(undefined, tick_rng) /*#as CREATURE_EXCHANGE_ACTION*/;                 // my exchange action
    var opp = target_human.exchange_action_sampler.get(undefined, tick_rng) /*#as CREATURE_EXCHANGE_ACTION*/;    // opponent's (target's) exchange action
    
    // for brevity:
    var give = CREATURE_EXCHANGE_ACTION.give;
    var take = CREATURE_EXCHANGE_ACTION.take;
    var coll_gain    = Configs.exchange_collaboration_energy_gain;
    var ripped_gain  = Configs.exchange_being_ripped_off_energy_gain;
    var ripping_gain = Configs.exchange_ripping_off_energy_gain;
	
	var capture = {
		me: id,
		target_human: target_human,
		coll_gain: coll_gain,
		ripped_gain: ripped_gain,
		ripping_gain: ripping_gain,
	};
    
    var log_msg = "";
    if (!Trial.is_auto_run) {
        log_msg = "Exchange: " + EID(id) + " " + (cha == give ? "gives" : "takes") + " and " + EID(target_human) + " " + (opp == give ? "gives" : "takes") + ". ";
    }
    
    var dir_towards_target = point_direction(x, y, target_human.x, target_human.y);
    
    // Is one of the parties the player?
    var im_player = object_is_ancestor_or_child(object_index, obj_human_player);
    var target_is_player = object_is_ancestor_or_child(target_human.object_index, obj_human_player);
    var involves_player = im_player || target_is_player;
    
    var do_effects = involves_player && !Trial.is_auto_run;
    
    start_animation(CREATURE_ANIMATION.exchange, 30, dir_towards_target);
    target_human.start_animation(CREATURE_ANIMATION.exchange, 30, dir_towards_target + 180);
    
    if (do_effects) {
        fx_create_speech_bubble(id, (cha == give) ? spr_emote_hand_right : spr_emote_knife, false, dir_towards_target);
        fx_create_speech_bubble(target_human, (opp == give) ? spr_emote_hand_right : spr_emote_knife, false, dir_towards_target + 180);
    }
    
    var energy_prev = energy;
    var target_energy_prev = target_human.energy;
    
    if (cha == give && opp == give) {
        // Collaboration
		var me_energy_func     = method(capture, function() { if (instance_exists(me)) me.energy += coll_gain; });
		var target_energy_func = method(capture, function() { if (instance_exists(target_human)) target_human.energy += coll_gain; });
        if (!Trial.is_auto_run) {
            log_msg += "Both gain " + string(coll_gain) + " energy.";
        }
        if (do_effects) {
            fx_create_speech_bubble(id, spr_emote_heart, true, dir_towards_target, false, me_energy_func);
            fx_create_speech_bubble(target_human, spr_emote_heart, true, dir_towards_target + 180, false, target_energy_func);
        }
		else {
			me_energy_func();
			target_energy_func();
		}
    }
    else if (cha == give && opp == take) {
        // Being ripped off by target
		var me_energy_func     = method(capture, function() { if (instance_exists(me)) me.energy += ripped_gain; });
		var target_energy_func = method(capture, function() { if (instance_exists(target_human)) target_human.energy += ripping_gain; });
        if (!Trial.is_auto_run) {
            log_msg += EID(id) + " gains " + string(ripped_gain) + ", " + EID(target_human) + " gains " + string(ripping_gain) + " energy.";
        }
        if (do_effects) {
            fx_create_speech_bubble(id, spr_emote_heart_broken, true, dir_towards_target, false, me_energy_func);
            fx_create_speech_bubble(target_human, spr_emote_heart, true, dir_towards_target + 180, false, target_energy_func);
        }
		else {
			me_energy_func();
			target_energy_func();
		}
    }
    else if (cha == take && opp == give) {
        // Ripping off target
		var me_energy_func     = method(capture, function() { if (instance_exists(me)) me.energy += ripping_gain; });
		var target_energy_func = method(capture, function() { if (instance_exists(target_human)) target_human.energy += ripped_gain; });
        if (!Trial.is_auto_run) {
            log_msg += EID(id) + " gains " + string(ripping_gain) + ", " + EID(target_human) + " gains " + string(ripped_gain) + " energy.";
        }
        if (do_effects) {
            fx_create_speech_bubble(id, spr_emote_heart, true, dir_towards_target, false, me_energy_func);
            fx_create_speech_bubble(target_human, spr_emote_heart_broken, true, dir_towards_target + 180, false, target_energy_func);
        }
		else {
			me_energy_func();
			target_energy_func();
		}
    }
    else if (cha == take && opp == take) {
        // Conflict
        
        var delay = 30;
        
        action_choose_timer = delay + 2;
        exchange_cooldown_timer = delay + 2;
        wait_ticks(Trial, id, delay).and_then(method(capture, function() {
            if (!instance_exists(target_human) || !instance_exists(me)) {
                return;
            }
            me.stop_actions_of_type(HAT_exchange_with_human);
            me.force_start_action(new HA_AttackHuman(target_human));
            // Move into attack range with the target.
            if (point_distance(me.x, me.y, target_human.x, target_human.y) > me.attack_range) {
                var dir = point_direction(target_human.x, target_human.y, me.x, me.y);
                me.x = target_human.x + lengthdir_x(me.attack_range - 1, dir);
                me.y = target_human.y + lengthdir_y(me.attack_range - 1, dir);
            }
        })).and_catch(function(err) { show_message(err); });
        
        target_human.action_choose_timer = delay + 2;
        target_human.exchange_cooldown_timer = delay + 2;
        wait_ticks(Trial, target_human, delay).and_then(method(capture, function() {
            if (!instance_exists(target_human) || !instance_exists(me)) {
                return;
            }
            target_human.stop_actions_of_type(HAT_exchange_with_human);
            target_human.force_start_action(new HA_AttackHuman(me));
            // Move into attack range with the target.
            if (point_distance(target_human.x, target_human.y, me.x, me.y) > target_human.attack_range) {
                var dir = point_direction(me.x, me.y, target_human.x, target_human.y);
                target_human.x = me.x + lengthdir_x(target_human.attack_range - 1, dir);
                target_human.y = me.y + lengthdir_y(target_human.attack_range - 1, dir);
            }
        })).and_catch(function(err) { show_message(err); });
        
        if (!Trial.is_auto_run) {
            log_msg += "Conflict ensues.";
        }
    }
    else {
        // Not a possible combination?
    }
    
    if (!Trial.is_auto_run) {
        Trial.log_event(log_msg);
    }
    
    energy = min(energy, energy_max);
    target_human.energy = min(target_human.energy, target_human.energy_max);
    
    if (do_effects && involves_player) {
        if ((im_player && energy < energy_prev) || (target_is_player && target_human.energy < target_energy_prev)) {
            Trial.hud.energy_hud.flash();
        }
    }
    
    exchange_cooldown_timer = get_exchange_cooldown_as_ticks();
    target_human.exchange_cooldown_timer = target_human.get_exchange_cooldown_as_ticks();
}

get_action_choose_cooldown_as_ticks = function() /*-> int*/
{
    return ceil((1 / Configs.action_update_frequency) * 60);
}

get_exchange_cooldown_as_ticks = function() /*-> int*/
{
    return ceil((1 / Configs.exchange_frequency) * 60);
}

function stop_equal_actions(stopped_action/*: HumanAction*/)
{
    for (var i = 0, len = array_length(actions_in_memory); i < len; ++i) {
        if (human_actions_equal(actions_in_memory[i], stopped_action)) {
            array_delete(actions_in_memory, i, 1);
            --i;
            --len;
        }
    }
}

function stop_actions_of_type(action_type/*: HumanActionType*/)
{
    for (var i = 0, len = array_length(actions_in_memory); i < len; ++i) {
        if (actions_in_memory[i].type == action_type) {
            array_delete(actions_in_memory, i, 1);
            --i;
            --len;
        }
    }
}

function force_start_action(started_action/*: HumanAction*/)
{
    if (array_length(actions_in_memory) > 0 && human_actions_equal(actions_in_memory[0], started_action)) {
        // The given action is equal with the already current action, so don't do anything.
        return;
    }
    stop_equal_actions(started_action);
    array_insert(actions_in_memory, 0, started_action);
    
    // Reset the timer so we don't choose a new one too soon after this.
    action_choose_timer = get_action_choose_cooldown_as_ticks();
}

// Need to re-evaluate configs when energy changes, because energy level
// is one of the parameters used in configs.
energy_changed_event.listen(re_evaluate_from_configs);

Trial.ticker.on_tick(id, function(tick_number/*: int*/, tick_rng/*: Rng*/) {
    
    if (exchange_cooldown_timer > 0) {
        exchange_cooldown_timer -= 1;
    }
    
    if (constant_energy_loss_timer < ceil((1 / Configs.human_constant_energy_loss_frequency) * 60)) {
        constant_energy_loss_timer += 1;
    }
    else {
        constant_energy_loss_timer = 0;
        energy -= Configs.human_constant_energy_loss_amount;
    }
    
    if (action_choose_timer > 0) {
        action_choose_timer -= 1;
    }
    else {
        action_choose_timer = get_action_choose_cooldown_as_ticks();
        
        // Sample a new action from the list of actions.
        var action_types = /*#cast*/ [] /*#as HumanActionType[]*/;
        var num_action_types = action_sampler.get_ordered_array(action_types, tick_rng);
        var new_action = /*#cast*/ undefined /*#as HumanAction?*/;
        for (var i = 0; i < num_action_types; ++i) {
            var action_type = action_types[i];
            var tentative_new_action = action_type.try_initiate(id, tick_rng) /*#as HumanAction*/;
            if (tentative_new_action != undefined) {
                new_action = tentative_new_action;
                break;
            }
        }
        
        if (new_action != undefined) {
            
            // Found a new doable action. Let's see if it could be accepted
            // as the new current action.
            
            if (array_length(actions_in_memory) <= 0) {
                // There are currently no actions in memory.
                // => The new action is immediately accepted.
                actions_in_memory[0] = new_action;
            }
            else {
                // There are actions in memory already.
                // => The new action will only be accepted if its weight beats
                //    the currently active (memory at index 0) action's weight.
                //    The currently active action's weight in this comparison
                //    is modified (i.e. probably increased) based on trial
                //    parameters as per the configs.
                var new_action_weight = action_weights[? new_action.type];
                var current_action = actions_in_memory[0];
                var energy_level = energy / energy_max;
                var current_action_weight = Configs.current_action_weight_modifier(personality_traits, energy_level, action_weights[? current_action.type]);
                var sampler = new WeightedRandomSampler();
                sampler.add(new_action, new_action_weight);
                sampler.add(current_action, current_action_weight);
                if (sampler.get(undefined, tick_rng) == new_action) {
                    // The new action does beat the current action, so it will now be accepted.
                    // Find out if an equal action is already in memory, and if so, simply
                    // move that to the front of action memory (thus making it the active one).
                    // If there is no equal action in memory, insert the new action to the front of action memory.
                    var existing_equal_action_index = -1;
                    for (var j = 0, len = array_length(actions_in_memory); j < len; ++j) {
                        var action_in_memory = actions_in_memory[j];
                        if (human_actions_equal(action_in_memory, new_action)) {
                            existing_equal_action_index = j;
                            break;
                        }
                    }
                    if (existing_equal_action_index >= 0) {
                        var existing_equal_action = actions_in_memory[existing_equal_action_index];
                        array_delete(actions_in_memory, existing_equal_action_index, 1);
                        array_insert(actions_in_memory, 0, existing_equal_action);
                    }
                    else {
                        array_insert(actions_in_memory, 0, new_action);
                    }
                }
            }
        }
    }
    
    // Cap the number if actions in memory.
    if (array_length(actions_in_memory) > Configs.num_memory_slots) {
        array_delete(actions_in_memory, Configs.num_memory_slots, array_length(actions_in_memory) - Configs.num_memory_slots);
    }
    
    if (array_length(actions_in_memory) > 0) {
        // Tick the current action.
        var current_action = actions_in_memory[0];
        var can_continue = current_action.tick(id, tick_number, tick_rng);
        if (!can_continue) {
            array_delete(actions_in_memory, 0, 1);
        }
    }
});