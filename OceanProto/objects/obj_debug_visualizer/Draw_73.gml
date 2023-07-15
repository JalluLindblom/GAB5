event_inherited();

if (!instance_exists(Trial)) {
    return;
}

if (Debugs.show_pathfinding) {
    
    for (var i = 0, len = instance_number(obj_creature); i < len; ++i) {
        var creature = instance_find(obj_creature, i);
        if (object_is_ancestor_or_child(creature.object_index, obj_human)) {
            var human = /*#cast*/ creature /*#as obj_human*/;
            var current_action = human.get_current_action() /*#as HumanAction*/;
            if (ds_map_exists(global._creature_paths_map, creature)) {
                _draw_path(creature, global._creature_paths_map[? creature]);
            }
        }
        else if (ds_map_exists(global._creature_paths_map, creature)) {
            _draw_path(creature, global._creature_paths_map[? creature]);
        }
        var cell = Trial.terrain.cell_at_room(creature.x, creature.y) /*#as TerrainCell*/;
        if (cell != undefined) {
            var rr = cell.room_rect;
            render_rectangle(rr.x1, rr.y1, rr.x2, rr.y2, COLOR.white, 0.5, false);
        }
    }
    
    for (var cx = 0; cx <= Trial.terrain.width; ++cx) {
        var x1 = cx * CSIZE;
        var y1 = 0;
        var x2 = x1;
        var y2 = Trial.terrain.height * CSIZE;
        render_line(x1, y1, x2, y2, 2, COLOR.white, 0.5);
    }
    for (var cy = 0; cy <= Trial.terrain.height; ++cy) {
        var x1 = 0;
        var y1 = cy * CSIZE;
        var x2 = Trial.terrain.width * CSIZE;
        var y2 = y1;
        render_line(x1, y1, x2, y2, 2, COLOR.white, 0.5);
    }
    
}

if (Debugs.show_sight_ranges) {
    for (var i = 0, len = instance_number(obj_human); i < len; ++i) {
        var human = instance_find(obj_human, i);
        render_circle(round(human.x), round(human.y), round(human.sight_range), COLOR.white, 1.0, true);
    }
    for (var i = 0, len = instance_number(obj_monster); i < len; ++i) {
        var monster = instance_find(obj_monster, i);
        render_circle(round(monster.x), round(monster.y), round(monster.sight_range), COLOR.white, 1.0, true);
    }
}

if (Debugs.show_exploration_ranges) {
    for (var i = 0, len = instance_number(obj_human); i < len; ++i) {
        var human = instance_find(obj_human, i);
        render_circle(round(human.x), round(human.y), round(human.exploration_range), COLOR.gray, 1.0, true);
    }
    for (var i = 0, len = instance_number(obj_monster); i < len; ++i) {
        var monster = instance_find(obj_monster, i);
        render_circle(round(monster.x), round(monster.y), round(monster.exploration_range), COLOR.gray, 1.0, true);
    }
}

if (Debugs.show_attack_ranges) {
    for (var i = 0, len = instance_number(obj_creature); i < len; ++i) {
        var creature = instance_find(obj_creature, i);
        render_circle(round(creature.x), round(creature.y), round(creature.attack_range), COLOR.red, 1.0, true);
    }
}

var num_entities = instance_number(obj_entity);
for (var i = 0; i < num_entities; ++i) {
    var entity = instance_find(obj_entity, i);
    
    if (object_is_ancestor_or_child(entity.object_index, obj_rock, obj_foliage, obj_obstacles_renderer_layer)) {
        continue;
    }
    
    var str = "";
    
    if (Debugs.show_ids) {
        str += EID(entity, true) + "\n";
    }
    
    var show_actions = (Debugs.show_player_actions && object_is_ancestor_or_child(entity.object_index, obj_human_player))
                    || (Debugs.show_human_actions && object_is_ancestor_or_child(entity.object_index, obj_human_ai));
    if (show_actions) {
        var human = /*#cast*/ entity /*#as obj_human*/;
        var num_actions = array_length(human.actions_in_memory);
        for (var j = 0; j < num_actions; ++j) {
            var action = human.actions_in_memory[j];
            str += string(j + 1) + ": " + action.debug_string(true) + "\n";
        }
    }
    
    var xx = round(entity.x);
    var yy = round(entity.y + 5);
    
    if (Debugs.show_energies && object_is_ancestor(entity.object_index, obj_creature)) {
        var creature = /*#cast*/ entity /*#as obj_creature*/;
        str = string(creature.energy) + "/" + string(creature.energy_max) + "\n" + str;
        yy -= 26;
    }
    
    scribble(str)
        .starting_format(FontConsoleBoldOutlined, COLOR.white)
        .align(fa_center, fa_top)
        .draw(xx, yy);
}
