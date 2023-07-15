
function initialize_creature_pathfinding()
{
    CALL_ONLY_ONCE
    
    global._creature_targets_map = ds_map_create(); /// @is {ds_map<obj_creature, TerrainCell?>}
    global._creature_paths_map = ds_map_create(); /// @is {ds_map<obj_creature, PfPathElement[]>}
}

function creature_approach(creature/*: obj_creature*/, target_cell/*: TerrainCell?*/, movement_speed/*: number*/)
{
    if (!ds_map_exists(global._creature_targets_map, creature)) {
        global._creature_targets_map[? creature] = undefined;
    }
    if (global._creature_targets_map[? creature] != target_cell) {
        global._creature_targets_map[? creature] = target_cell;
        if (target_cell != undefined) {
            var start_x = creature.x;
            var start_y = creature.y;
            var goal_x = target_cell.cx * CSIZE;
            var goal_y = target_cell.cy * CSIZE;
            global._creature_paths_map[? creature] = creature_find_path(start_x, start_y, goal_x, goal_y);
        }
        else {
            global._creature_paths_map[? creature] = [];
        }
    }
    var path = global._creature_paths_map[? creature];
    creature_follow_path(creature, path, movement_speed);
}

function creature_follow_path(creature/*: obj_creature*/, path/*: PfPathElement[]*/, movement_speed/*: number*/)
{
    if (array_length(path) <= 0) {
        return;
    }
    
    var next_cell = path[0].node;
    
    var next_x = next_cell.room_rect.get_center_x();
    var next_y = next_cell.room_rect.get_center_y();
    var dis = point_distance(creature.x, creature.y, next_x, next_y);
    if (dis > movement_speed) {
        var dir = point_direction(creature.x, creature.y, next_x, next_y);
        creature.x += lengthdir_x(movement_speed, dir);
        creature.y += lengthdir_y(movement_speed, dir);
    }
    else {
        creature.x = next_x;
        creature.y = next_y;
        array_delete(path, 0, 1);
    }
}

function creature_find_path(start_x/*: number*/, start_y/*: number*/, goal_x/*: number*/, goal_y/*: number*/) /*-> PfPathElement[]*/
{
    var start_cell = Trial.terrain.cell_at_room(start_x, start_y);
    var goal_cell = Trial.terrain.cell_at_room(goal_x, goal_y);
    var get_heuristic = euclidean_distance_between_terrain_cells;
    
    var get_neighbors = function(cell/*: TerrainCell*/, neighbors/*: PfNeighbor[]*/, neighbor_pool/*: StructPool*/) {
        
        static offsets = [
            { xx: -1, yy: 0  },
            { xx: 1,  yy: 0  },
            { xx: 0,  yy: 1  },
            { xx: 0,  yy: -1 },
        ];
        static num_offsets = array_length(offsets);
        
        // Don't look for neighbors at all when we're on the very edges of the terrain.
        // This is an optimization so that we don't have to do this many times in a loop.
        // This does have the drawback that there's effectively an invisible padding to the
        // terrain's dimensions in regards of pathfinding.
        if (cell.cx <= 0 || cell.cy <= 0 || cell.cx >= Trial.terrain.width || cell.cy >= Trial.terrain.height) {
            return 0;
        }
        
        var num_neighbors = 0;
        for (var i = 0; i < num_offsets; ++i) {
            var offset = offsets[i];
            var cx = cell.cx + offset.xx;
            var cy = cell.cy + offset.yy;
            var neighbor_cell = Trial.terrain.cells[cy][cx];
            if (neighbor_cell.is_traversable) {
                var cost = euclidean_distance_between_terrain_cells(cell, neighbor_cell);
                neighbors[num_neighbors++] = neighbor_pool.create_new(neighbor_cell, cost, undefined);
            }
        }
        return num_neighbors;
    };
    
    var options = undefined;
    var only_find_full_path = true;
    var path = find_path(start_cell, goal_cell, get_heuristic, get_neighbors, options, only_find_full_path);
    
    if (path == undefined) {
        return [];
    }
    
    // Post process the path: make non-grid-aligned short cuts between path nodes
    // if there are no solid cells between them.
    for (var i = 0, len = array_length(path); i < len; ++i) {
        var c1 = path[i].node;
        var j = i + 2;
        var num_of_deletable_path_nodes = 0;
        for (; j < len; ++j) {
            var c2 = path[j].node;
            var is_free = !terrain_cells_colliding_between_cells(Trial.terrain, c1, c2, undefined);
            if (is_free) {
                ++num_of_deletable_path_nodes;
            }
        }
        if (num_of_deletable_path_nodes > 0) {
            array_delete(path, i + 1, num_of_deletable_path_nodes);
            len -= num_of_deletable_path_nodes;
        }
    }
    
    return path;
}

function creature_find_pathfinding_adjacent_target_cell(creature/*: obj_creature*/, target_cell/*: TerrainCell*/) /*-> TerrainCell*/
{
    if (target_cell.cx <= 0 || target_cell.cx >= Trial.terrain.width - 1 || target_cell.cy <= 0 || target_cell.cy >= Trial.terrain.height - 1) {
        return target_cell;
    }
    
    static offsets = [
        { xx: -1, yy: 0  },
        { xx: -1, yy: -1 },
        { xx: 1,  yy: 0  },
        { xx: 1,  yy: 1  },
        { xx: 0,  yy: 1  },
        { xx: 1,  yy: 1  },
        { xx: 0,  yy: -1 },
        { xx: -1, yy: -1 },
    ];
    static num_offsets = array_length(offsets);
    var min_distance = -1;
    var min_index = -1;
    for (var i = 0; i < num_offsets; ++i) {
        var offset = offsets[i];
        var cx = target_cell.cx + offset.xx;
        var cy = target_cell.cy + offset.yy;
        var distance = point_distance(creature.x, creature.y, cx * CSIZE, cy * CSIZE);
        if (min_index < 0 || distance < min_distance) {
            min_distance = distance;
            min_index = i;
        }
    }
    if (min_index < 0) {
        return target_cell;
    }
    var min_offset = offsets[min_index];
    return Trial.terrain.cells[target_cell.cy + min_offset.yy][target_cell.cx + min_offset.xx];
}

function creature_find_pathfinding_avoiding_target_cell(creature/*: obj_creature*/, avoided_x/*: number*/, avoided_y/*: number*/) /*-> TerrainCell*/
{
    var creature_cx = floor(creature.x / CSIZE);
    var creature_cy = floor(creature.y / CSIZE);
    
    static offsets = undefined;
    static num_offsets = undefined;
    if (offsets == undefined) {
        offsets = [];
        for (var xx = -4; xx <= 4; ++xx) {
            for (var yy = -4; yy <= 4; ++yy) {
                if (xx == 0 && yy == 0) {
                    continue;
                }
                array_push(offsets, { xx: xx, yy: yy });
            }
        }
        num_offsets = array_length(offsets);
    } 
    
    var avoided_cx = floor(avoided_x / CSIZE);
    var avoided_cy = floor(avoided_y / CSIZE);
    
    var max_distance = -1;
    var max_index = -1;
    for (var i = 0; i < num_offsets; ++i) {
        var offset = offsets[i];
        var cx = creature_cx + offset.xx;
        var cy = creature_cy + offset.yy;
        if (cx < 0 || cx >= Trial.terrain.width || cy < 0 || cy >= Trial.terrain.height) {
            continue;
        }
        if (!Trial.terrain.cells[cy][cx].is_traversable) {
            continue;
        }
        var distance = point_distance(avoided_cx, avoided_cy, cx, cy);
        if (max_index < 0 || distance > max_distance) {
            max_distance = distance;
            max_index = i;
        }
    }
    if (max_index < 0) {
        return Trial.terrain.cells[creature_cy][creature_cx];
    }
    var max_offset = offsets[max_index];
    return Trial.terrain.cells[creature_cy + max_offset.yy][creature_cx + max_offset.xx];
}
