
function CreatureSprites() constructor
{
    idle    = -1;       /// @is {sprite}
    walk    = -1;       /// @is {sprite}
    stand   = -1;       /// @is {sprite}
    attack  = -1;       /// @is {sprite}
    duck    = -1;       /// @is {sprite}
    hurt    = -1;       /// @is {sprite}
    exchange    = -1;   /// @is {sprite}
    dead    = -1;       /// @is {sprite}
    
    static set = function(
        _idle/*: sprite*/,
        _walk/*: sprite*/,
        _stand/*: sprite*/,
        _attack/*: sprite*/,
        _duck/*: sprite*/,
        _hurt/*: sprite*/,
        _exchange/*: sprite*/,
        _dead/*: sprite*/
    )
    {
        idle        = _idle;
        walk        = _walk;
        stand       = _stand;
        attack      = _attack;
        duck        = _duck;
        hurt        = _hurt;
        exchange    = _exchange;
        dead        = _dead;
    }
}

function creature_create_death_animation(creature/*: obj_creature*/) /*-> obj_creature_death_animation*/
{
    if (Trial.is_auto_run) {
        return noone;
    }
    var death = instance_create_depth(creature.x, creature.y, creature.depth, obj_creature_death_animation);
    death.initialize(creature);
    return death;
}

enum CREATURE_FIGHT_ACTION
{
    hit,
    miss,
    flee,
}

enum CREATURE_EXCHANGE_ACTION
{
    give,
    take,
}

/// Gets the last time (tick number) when one or the other of these two creatures
/// has attacked the other. If neither has attacked the other, returns undefined.
function creatures_get_last_attack_time(creature1/*: obj_creature*/, creature2/*: obj_creature*/) /*-> int?*/
{
    var time1 = ds_map_exists(creature1.attack_times_per_creature, creature2) ? creature1.attack_times_per_creature[? creature2] : undefined;
    var time2 = ds_map_exists(creature2.attack_times_per_creature, creature1) ? creature2.attack_times_per_creature[? creature1] : undefined;
    
    if (time1 == undefined && time2 == undefined) {
        // Neither have ever attacked each other.
        return undefined;
    }
    else if (time1 == undefined) {
        // Creature 2 has attacked creature 1 but creature 1 hasn't attacked creature 2.
        return time2;
    }
    else if (time2 == undefined) {
        // Creature 1 has attacked creature 2 but creature 2 hasn't attacked creature 1.
        return time1;
    }
    else {
        // Both creatures have attacked each other.
        return max(time1, time2);
    }
}


// entity id string
function EID(entity/*: instance*/, use_scribble_colors/*: bool*/ = true) /*-> string*/
{
    var type_name = "UNKNOWN";
    var color_str = undefined;
    if (instance_exists(entity)) {
        if (object_is_ancestor_or_child(entity.object_index, obj_entity)) {
            type_name = "Entity";
            if (object_is_ancestor_or_child(entity.object_index, obj_human_player)) {
                type_name = "Player";
            }
            else if (object_is_ancestor_or_child(entity.object_index, obj_human)) {
                type_name = "Human";
            }
            else if (object_is_ancestor_or_child(entity.object_index, obj_monster)) {
                type_name = "Monster";
            }
            else if (object_is_ancestor_or_child(entity.object_index, obj_food)) {
                type_name = "Food";
            }
        }
        if (use_scribble_colors) {
            var hue = get_debug_hue_for_instance(entity);
            var color = make_color_hsv(hue, 180, 255);
            color_str = "#" + color_to_rgb_hexadecimal_string(color);
        }
    }
    if (color_str != undefined) {
        return "[" + color_str + "]" + type_name + "(" + string(real(entity)) + ")" + "[/c]";
    }
    else {
        return type_name + "(" + string(real(entity)) + ")";
    }
}

function creature_is_within_attack_range(attacker/*: obj_creature*/, target/*: obj_creature*/) /*-> bool*/
{
    return point_distance(attacker.x, attacker.y, target.x, target.y) <= attacker.attack_range;
}
