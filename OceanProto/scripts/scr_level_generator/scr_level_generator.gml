
function generate_level(width/*: int*/, height/*: int*/, num_monsters/*: int*/, num_foods/*: int*/, num_humans/*: int*/, num_sand/*: int*/, rng/*: Rng*/) /*-> Level?*/
{
    for (var i = 0; i < 999; ++i) {
        var level = _try_generate_level(width, height, num_monsters, num_foods, num_humans, num_sand, rng);
        if (level != undefined) {
            return level;
        }
    }
    return undefined;
}

function _try_generate_level(width/*: int*/, height/*: int*/, num_monsters/*: int*/, num_foods/*: int*/, num_humans/*: int*/, num_sand/*: int*/, rng/*: Rng*/) /*-> Level?*/
{
    var level_cells = _levgen_create_level_base(width, height, rng);
    
    var hole_perlin_gen = new PerlinGeneratorCpu2d(32, rng);
    for (var cy = 0; cy < height; ++cy) {
        var row = level_cells[cy];
        for (var cx = 0; cx < width; ++cx) {
            if (hole_perlin_gen.get(cx / 4, cy / 4) > 0.65) {
                var cell = row[cx];
                cell.type = LCT_hole;
            }
        }
    }
    
    // Make it roundish
    var center_x = width / 2;
    var center_y = height / 2;
    var level_roundness_radius = max(width, height) / 2 - 1;
    for (var cy = 0; cy < height; ++cy) {
        var row = level_cells[cy];
        for (var cx = 0; cx < width; ++cx) {
            if (point_distance(center_x, center_y, cx, cy) >= level_roundness_radius) {
                row[cx].type = LCT_hole;
            }
        }
    }
    
    var some_modified = true;
    while (some_modified) {
        some_modified = false;
        for (var cy = 1; cy < height - 1; ++cy) {
            var row = level_cells[cy];
            for (var cx = 1; cx < width - 1; ++cx) {
                var cell = row[cx];
                var ct = cell.type;
                if (ct == LCT_empty) {
                    var num_hor_neighbors = (level_cells[cy][cx - 1].type == ct) + (level_cells[cy][cx + 1].type == ct);
                    var num_ver_neighbors = (level_cells[cy - 1][cx].type == ct) + (level_cells[cy + 1][cx].type == ct);
                    if (num_hor_neighbors == 0 || num_ver_neighbors == 0) {
                        some_modified = true;
                        cell.type = LCT_hole;
                    }
                }
                else if (ct == LCT_hole) {
                    var num_hor_neighbors = (level_cells[cy][cx - 1].type == ct) + (level_cells[cy][cx + 1].type == ct);
                    var num_ver_neighbors = (level_cells[cy - 1][cx].type == ct) + (level_cells[cy + 1][cx].type == ct);
                    if (num_hor_neighbors == 0 || num_ver_neighbors == 0) {
                        some_modified = true;
                        cell.type = LCT_empty;
                    }
                }
            }
        }
    }
    
    _levgen_generate_sand(level_cells, width, height, num_sand, rng);
    
    if (!_levgen_check_terrain_validity(level_cells, width, height)) {
        return undefined;
    }
    
    // Replace inner holes with rocks instead
    for (var cy = 0; cy < height; ++cy) {
        var row = level_cells[cy];
        for (var cx = 0; cx < width; ++cx) {
            var cell = row[cx];
            if (cell.type == LCT_hole && point_distance(center_x, center_y, cx, cy) < level_roundness_radius) {
                cell.type = LCT_rock;
            }
        }
    }
    
    var level_cells_flat = /*#cast*/ arrays_flattened(level_cells) /*#as LevelCell[]*/;
    var empty_cells = /*#cast*/ array_filtered(level_cells_flat, function(cell/*: LevelCell*/) {
        return cell.type == LCT_empty;
    }) /*#as LevelCell[]*/;
    var empty_cells_deck = random_deck_from_array(empty_cells);
    
    if (!_levgen_spawn_player(level_cells_flat, width, height, rng)) {
        return undefined;
    }
    _levgen_spawn_things(empty_cells_deck, LCT_monster, num_monsters, rng);
    _levgen_spawn_things(empty_cells_deck, LCT_food, num_foods, rng);
    // TODO: This only generates the random human type!
    _levgen_spawn_things(empty_cells_deck, LCT_human_random, num_humans, rng);
    
    return new Level(undefined, level_cells);
}

function _levgen_generate_sand(level_cells/*: LevelCell[][]*/, width/*: int*/, height/*: int*/, num_sand/*: int*/, rng/*: Rng*/)
{
    var level_cells_flat = /*#cast*/ arrays_flattened(level_cells) /*#as LevelCell[]*/;
    var empty_cells = /*#cast*/ array_filtered(level_cells_flat, function(cell/*: LevelCell*/) {
        return cell.type == LCT_empty;
    }) /*#as LevelCell[]*/;
    var empty_cells_deck = random_deck_from_array(empty_cells);
    
    // Don't try to generate more sand than there is room for it.
    num_sand = min(num_sand, array_length(empty_cells));
    
    var num_clusters = 3;
    
    var num_placed_sand = 0;
    for (var i = 0; i < num_clusters && num_placed_sand < num_sand - 1; ++i) {
        var cell = empty_cells_deck.draw_one(rng) /*#as LevelCell*/;
        cell.type = LCT_sand;
        ++num_placed_sand;
    }
    
    var all_cells_deck = random_deck_from_array(level_cells_flat);
    while (num_placed_sand < num_sand - 1) {
        var cell = all_cells_deck.draw_one(rng);
        if (cell.type != LCT_empty) {
            continue;
        }
        var cx = cell.cx;
        var cy = cell.cy;
        if ((cx > 0          && level_cells[cy][cx - 1].type == LCT_sand)
         || (cx < width - 1  && level_cells[cy][cx + 1].type == LCT_sand)
         || (cy > 0          && level_cells[cy - 1][cx].type == LCT_sand)
         || (cy < height - 1 && level_cells[cy + 1][cx].type == LCT_sand)
        ) {
            cell.type = LCT_sand;
            ++num_placed_sand;
        }
    }
}

function _levgen_check_terrain_validity(level_cells/*: LevelCell[][]*/, width/*: int*/, height/*: int*/) /*-> bool*/
{
    // First find any solid ground cell from the level.
    var any_traversable_cell = undefined /*#as LevelCell?*/;
    var num_traversable_cells = 0;
    for (var cy = 0; cy < height; ++cy) {
        var row = level_cells[cy];
        for (var cx = 0; cx < width; ++cx) {
            var cell = row[cx];
            if (cell.type.is_traversable) {
                any_traversable_cell = cell;
                ++num_traversable_cells;
            }
        }
    }
    
    if (any_traversable_cell == undefined) {
        // Couldn't even find a single traversable cell - can't possibly be a valid level.
        return false;
    }
    
    // Flood fill from the traversable cell and see that the fill covers all the traversable cells that we found previously.
    // If it does cover all of them, this means that the level is continous (a single fully connected island).
    var n = _levgen_flood_fill_traversable_cells(level_cells, width, height, any_traversable_cell);
    return (n == num_traversable_cells);
}

/// Flood fill traverse traversable cells starting from the given cell (assumed to be traversable itself).
/// @returns The number of traversed cells.
function _levgen_flood_fill_traversable_cells(level_cells/*: LevelCell[][]*/, width/*: int*/, height/*: int*/, starting_cell/*: LevelCell*/) /*-> int*/
{
    // Dijkstra-like algorithm.
    
    var open_set = /*#cast*/ ds_priority_create() /*#as ds_priority<LevelCell>*/;
    var g_score = /*#cast*/ ds_map_create() /*#as ds_map<LevelCell, number>*/;
    var traversed_cells = ds_set_create();
    
    g_score[? starting_cell] = 0;
    ds_priority_add(open_set, starting_cell, 0);
    ds_set_add(traversed_cells, starting_cell);
    
    while (!ds_priority_empty(open_set)) {
        var min_f = ds_priority_find_priority(open_set, ds_priority_find_min(open_set));
        var current = ds_priority_delete_min(open_set);
        var current_g = g_score[? current];
        static neighbors = array_create(4) /*#as LevelCell[]*/;
        var num_neighbors = 0;
        if (current.cx > 0) {
            neighbors[num_neighbors++] = level_cells[current.cy][current.cx - 1]; // left
        }
        if (current.cy > 0) {
            neighbors[num_neighbors++] = level_cells[current.cy - 1][current.cx]; // top
        }
        if (current.cx < width - 2) {
            neighbors[num_neighbors++] = level_cells[current.cy][current.cx + 1]; // right
        }
        if (current.cy < height - 2) {
            neighbors[num_neighbors++] = level_cells[current.cy + 1][current.cx]; // bot
        }
        for (var i = 0; i < num_neighbors; ++i) {
            var neighbor = neighbors[i];
            if (!neighbor.type.is_traversable) {
                continue;
            }
            ds_set_add(traversed_cells, neighbor);
            var tentative_g = current_g + 1;
            if (!ds_map_exists(g_score, neighbor) || tentative_g < g_score[? neighbor]) {
                g_score[? neighbor] = tentative_g;
                if (ds_priority_find_priority(open_set, neighbor) == undefined) {
                    ds_priority_add(open_set, neighbor, tentative_g);
                }
            }
        }
    }
    
    var n = ds_set_size(traversed_cells);
    ds_priority_destroy(open_set);
    ds_map_destroy(g_score);
    ds_set_destroy(traversed_cells);
    return n;
}

function _levgen_spawn_player(level_cells/*: LevelCell[]*/, level_width/*: int*/, level_height/*: int*/, rng/*: Rng*/) /*-> bool*/
{
    var center_x = level_width / 2;
    var center_y = level_height / 2;
    
    level_cells = rng.rng_array_shuffled(level_cells);
    var num_cells = array_length(level_cells);
    for (var radius = 2; radius < 999999; radius += 1) {
        for (var i = 0; i < num_cells; ++i) {
            var cell = level_cells[i];
            if (cell.type != LCT_empty) {
                continue;
            }
            if (point_distance(center_x, center_y, cell.cx, cell.cy) > radius) {
                continue;
            }
            cell.type = LCT_player;
            return true;
        }
    }
    return false;
}

function _levgen_create_level_base(width/*: int*/, height/*: int*/, rng/*: Rng*/) /*-> LevelCell[][]*/
{
    var level_cells = /*#cast*/ array_create(height, undefined) /*#as LevelCell[][]*/;
    for (var cy = 0; cy < height; ++cy) {
        var row = array_create(width, /*#cast*/ undefined);
        level_cells[cy] = row;
        var is_vert_edge = (cy == 0) || (cy >= height - 1);
        for (var cx = 0; cx < width; ++cx) {
            var is_hori_edge = (cx == 0) || (cx >= width - 1);
            // Line the level with "hole" but otherwise the default cell type is "ground".
            var cell_type = (is_hori_edge || is_vert_edge) ? LCT_hole : LCT_empty;
            row[cx] = new LevelCell(cx, cy, cell_type);
        }
    }
    return level_cells;
}

function _levgen_spawn_things(cells_deck/*: RandomDeck*/, cell_type/*: LevelCellType*/, n/*: int*/, rng/*: Rng*/)
{
   for (var i = 0; i < n; ++i) {
        var spawn_cell = undefined;
        repeat (cells_deck.get_size()) {
            var cell = cells_deck.draw_one(rng) /*#as LevelCell*/;
            if (cell.type == LCT_empty) {
                spawn_cell = cell;
                break;
            }
        }
        if (spawn_cell == undefined) {
            break;
        }
        spawn_cell.type = cell_type;
    } 
}
