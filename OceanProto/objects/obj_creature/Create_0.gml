event_inherited();

enum CREATURE_ANIMATION
{
    attack,
    miss_attack,
    duck,
    hurt,
    exchange,
}

creature_sprites = new CreatureSprites(); /// @is {CreatureSprites}

draw_outline = false;   /// @is {bool}

// (shadows are rendered by obj_entity_shadow_renderer)
shadow_radius = 32; /// @is {number}

energy_max = 5;             /// @is {number}
energy = energy_max;        /// @is {number}
energy_previous = energy;   /// @is {number}

image_xscale = choose(1, -1);

animated_xscale = image_xscale; /// @is {number}
animated_yscale = image_yscale; /// @is {number}

x_on_previous_tick = x; /// @is {number}
y_on_previous_tick = y; /// @is {number}
x_on_current_tick = x;  /// @is {number}
y_on_current_tick = y;  /// @is {number}

time_spend_standing = 0;    /// @is {number}

animation = undefined;          /// @is {CREATURE_ANIMATION?}
animation_timer = 0;            /// @is {number}
animation_time = 0;             /// @is {number}
animation_direction = 0;        /// @is {number}
attack_animation_offset_x = 0;  /// @is {number}
attack_animation_offset_y = 0;  /// @is {number}

attack_cooldown_timer = 0;      /// @is {number}

attack_range = CSIZE * (sqrt(2) + 0.25);   /// @is {number}

/// An event that is invoked when this creature has been attacked
/// by another creature.
/// Event parameters:
/// {obj_creature} attacker_creature
/// {CREATURE_FIGHT_ACTION} fight_action
/// {int} tick_number
/// {Rng} tick_rng
got_attacked_event = new Event();   /// @is {Event}

// A map where the key is another creature and the value is the time (tick number)
// when this creature attacked that creature the last time. If this creature hasn't
// attacked a creature even once, there is no key for that creature in this map.
attack_times_per_creature = ds_map_create();    /// @is {ds_map<obj_creature, int>}

/// Invoked when current energy value is different from previous energy value on a tick.
/// Event parameters: (none)
energy_changed_event = new Event(); /// @is {Event}

/// Invoked when start_animation() is called.
/// Event parameters:
/// {CREATURE_ANIMATION} animation
/// {number} time
/// {number} direction
animation_started_event = new Event();  /// @is {Event}

/// Sampler of CREATURE_FIGHT_ACTION weights.
/// Child objects should fill this.
fight_action_sampler = new WeightedRandomSampler(); /// @is {WeightedRandomSampler}

/// Overwritten by child objects:
first_attack_damage  = 1.0; /// @is {number}
normal_attack_damage = 1.0; /// @is {number}
attacker_energy_gain = 1.0; /// @is {number}

_creature_initialize = function(_energy_max/*: number*/, _starting_energy/*: number*/)
{
    energy_max = _energy_max;
    energy = _starting_energy;
    energy_previous = energy;
}

Trial.ticker.on_tick(id, function(tick_number/*: int*/, tick_rng/*: Rng*/) {
    
    if (energy <= 0) {
        instance_destroy();
        return;
    }
    
    if (attack_cooldown_timer > 0) {
        attack_cooldown_timer -= 1;
    }
    
    if (energy != energy_previous) {
        energy_changed_event.invoke();
    }
    
    energy_previous = energy;
    
    x_on_previous_tick = x_on_current_tick;
    y_on_previous_tick = y_on_current_tick;
    x_on_current_tick = x;
    y_on_current_tick = y;
});

can_attack_creature = function(target_creature/*: obj_creature*/) /*-> bool*/
{
    // target creature doesn't actually matter?
    return attack_cooldown_timer <= 0;
}

// Deals one fight action towards the target creature.
// If it's a hit or miss, that will be fully handled within this function and you
// won't need to worry about the return value.
// If it's a flee (which you can find out from the return value), the caller
// (human or monster) needs to deal with that themselves.
attack_creature = function(target_creature/*: obj_creature*/, tick_number/*: int*/, tick_rng/*: Rng*/) /*-> CREATURE_FIGHT_ACTION*/
{
    var target_energy_previous = target_creature.energy;
    
    var last_attack_time = creatures_get_last_attack_time(id, target_creature);
    var combat_fadeoff_time = max(id.get_attack_cooldown_as_ticks(), target_creature.get_attack_cooldown_as_ticks()) + 60;
    var is_first_attack_of_combat = (last_attack_time == undefined) || (tick_number - last_attack_time > combat_fadeoff_time);
    
    var i_am_player = object_is_ancestor_or_child(object_index, obj_human_player);
    var target_is_player = object_is_ancestor_or_child(target_creature.object_index, obj_human_player);
    var i_am_human = object_is_ancestor_or_child(object_index, obj_human);
    
    var fight_action = fight_action_sampler.get(CREATURE_FIGHT_ACTION.flee, tick_rng);
    switch (fight_action) {
        case CREATURE_FIGHT_ACTION.hit: {
            var damage_amount = is_first_attack_of_combat ? first_attack_damage : normal_attack_damage;
            target_creature.energy -= damage_amount;
            var heal_amount = damage_amount * attacker_energy_gain;
            energy += heal_amount;
            energy = min(energy, energy_max);
            
            if (!Trial.is_auto_run) {
                var msg = EID(id) + " hit " + EID(target_creature) + " for " + string(damage_amount) + " damage and healed " + string(heal_amount);
                msg += is_first_attack_of_combat ? " (first attacker's benefit)." : ".";
                Trial.log_event(msg);
                id.start_animation(CREATURE_ANIMATION.attack, 10, point_direction(x, y, target_creature.x, target_creature.y));
                target_creature.start_animation(CREATURE_ANIMATION.hurt, 20, point_direction(target_creature.x, target_creature.y, x, y));
                var fx_x = (target_creature.bbox_left + target_creature.bbox_right) / 2 + random_range(-5, 5);
                var fx_y = (target_creature.bbox_top + target_creature.bbox_bottom) / 2 + random_range(-5, 5);
                var fx = fx_create_attack_hit_effect(fx_x, fx_y);
                
                var snd = choose(snd_punch_1, snd_punch_2);
                sfx_world_play(snd, i_am_player || target_is_player, random_range(0.8, 1.2));
            }
            break;
        }
        case CREATURE_FIGHT_ACTION.miss: {
            if (!Trial.is_auto_run) {
                var msg = EID(id) + " tried to attack " + EID(target_creature) + " but missed.";
                Trial.log_event(msg);
                id.start_animation(CREATURE_ANIMATION.miss_attack, 20, point_direction(x, y, target_creature.x, target_creature.y));
                target_creature.start_animation(CREATURE_ANIMATION.duck, 10, point_direction(target_creature.x, target_creature.y, x, y));
                
                var snd = choose(
                    snd_woosh_1,
                    snd_woosh_2,
                    snd_woosh_3,
                    snd_woosh_4,
                    snd_woosh_5,
                    snd_woosh_6,
                    snd_woosh_7,
                );
                sfx_world_play(snd, i_am_player || target_is_player, random_range(0.7, 1.4));
            }
            break;
        }
        case CREATURE_FIGHT_ACTION.flee: {
            if (!Trial.is_auto_run) {
                var msg = EID(id) + " flees from a fight with " + EID(target_creature) + ".";
                Trial.log_event(msg);
            }
            break;
        }
    }
    attack_times_per_creature[? target_creature] = tick_number;
    attack_cooldown_timer = get_attack_cooldown_as_ticks();
    
    target_creature.got_attacked_event.invoke(id, fight_action, tick_number, tick_rng);
    
    if (target_creature.energy <= 0 && target_energy_previous > 0) {
        
        // Target died just now. Gain energy (maybe).
        
        var energy_gain = 0;
        if (i_am_human) {
            // Gain energy from killing someone.
            var target_is_human = object_is_ancestor_or_child(target_creature.object_index, obj_human);
            energy_gain = target_is_human ? Configs.human_energy_gain_kill_human : Configs.human_energy_gain_kill_monster;
        }
        if (energy_gain != 0) {
            energy += energy_gain;
            energy = min(energy, energy_max);
        }
        if (!Trial.is_auto_run) {
            Trial.log_event(EID(id) + " killed " + EID(target_creature) + " and gained " + string(energy_gain) + " energy for it.");
        }
    }
    
    return fight_action;
}

get_attack_cooldown_as_ticks = function() /*-> int*/
{
    return ceil((1 / Configs.attack_frequency) * 60);
}

start_animation = function(_animation/*: CREATURE_ANIMATION*/, _time/*: number*/, _direction/*: number*/)
{
    if (Trial.is_auto_run) {
        return;
    }
    animation = _animation;
    animation_timer = 0;
    animation_time = _time;
    animation_direction = _direction;
    switch (_animation) {
        case CREATURE_ANIMATION.attack:
        case CREATURE_ANIMATION.miss_attack: {
            attack_animation_offset_x += lengthdir_x(30, _direction);
            attack_animation_offset_y += lengthdir_y(30, _direction);
            break;
        }
    }
    
    animation_started_event.invoke(_animation, _time, _direction);
}