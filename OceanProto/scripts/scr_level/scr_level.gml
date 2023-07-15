
#macro CSIZE 64

function Level(_name/*: string?*/, _cells/*: LevelCell[][]*/) constructor
{
    name = _name;                   /// @is {string?}
    cells = _cells;                 /// @is {LevelCell[][]}
    
    width = 0;                      /// @is {int}
    height = array_length(cells);   /// @is {int}
    
    // Find the widest row and set that as the width of the level.
    for (var cy = 0; cy < height; ++cy) {
        var row = cells[cy];
        var row_width = array_length(row);
        width = max(width, row_width);
    }
    
    // Make sure all rows are as wide as the level is.
    for (var cy = 0; cy < height; ++cy) {
        var row = cells[cy];
        var row_width = array_length(row);
        for (var cx = row_width; cx < width; ++cx) {
            row[cx] = new LevelCell(cx, cy, LCT_empty);
        }
    }
}

function LevelCell(_cx/*: int*/, _cy/*: int*/, _type/*: LevelCellType*/) constructor
{
    cx = _cx;       /// @is {int}
    cy = _cy;       /// @is {int}
    type = _type;   /// @is {LevelCellType}
}

function level_load_from_file(filename/*: string*/) /*-> Level?*/
{
    var lines = file_read_text_lines(filename);
    if (lines == undefined) {
        log_error("Failed to read level from file \"" + string(filename) + "\".");
        return undefined;
    }
    
    var level_height = array_length(lines);
    var level_width = 0;
    for (var i = 0; i < level_height; ++i) {
        level_width = max(level_width, string_length(lines[i]));
    }
    
    var level_cells = /*#cast*/ array_create(level_height, undefined) /*#as LevelCell[][]*/;
    for (var cy = 0; cy < level_height; ++cy) {
        var row = /*#cast*/ array_create(level_width, undefined) /*#as LevelCell[]*/;
        level_cells[cy] = row;
        var line = lines[cy];
        for (var cx = 0; cx < level_width; ++cx) {
            var char = (cx < string_length(line)) ? string_char_at(line, cx + 1) : " ";
            var cell_type = ds_map_exists(global.levelCellTypesByChar, char) ? global.levelCellTypesByChar[? char] : undefined;
            if (cell_type != undefined) {
                row[cx] = new LevelCell(cx, cy, cell_type);
            }
            else {
                row[cx] = new LevelCell(cx, cy, LCT_empty);
                log_warning("Failed to parse level cell from string \"" + char + "\".");
            }
        }
    }
    
    var name = file_path_get_stem(filename);
    return new Level(name, level_cells);
}

function level_write_to_file(level/*: Level*/, filename/*: string*/) /*-> bool*/
{
    var level_str_buf = buffer_create(1024, buffer_grow, 1);
    var lw = level.width;
    var lh = level.height;
    var cells = level.cells;
    for (var cy = 0; cy < lh; ++cy) {
        var row = cells[cy];
        for (var cx = 0; cx < lw; ++cx) {
            var cell = row[cx];
            buffer_write(level_str_buf, buffer_text, cell.type.character);
        }
        buffer_write(level_str_buf, buffer_text, "\n");
    }
    buffer_seek(level_str_buf, buffer_seek_start, 0);
    var success = false;
    try {
        buffer_save(level_str_buf, filename);
        success = true;
    }
    catch (err) {
    }
    buffer_delete(level_str_buf);
    return success;
}

function level_dump(level/*: Level*/, is_auto_run/*: bool*/) /*-> Terrain*/
{
    var terrain = _level_generate_terrain(level);
    if (!is_auto_run) {
        _terrain_dump_tiles(terrain);
    }
    return terrain;
}

function level_cell_dump(level/*: Level*/, level_cell/*: LevelCell*/) /*-> TerrainCell*/
{
    var terrain_cell = new TerrainCell(level_cell.cx, level_cell.cy, level_cell.type.is_traversable);
    level_cell.type.dump_callback(level, terrain_cell);
    return terrain_cell;
}

function level_get_num_cells_of_type(level/*: Level*/, cell_type/*: LevelCellType*/) /*-> int*/
{
    var n = 0;
    for (var cy = 0; cy < level.height; ++cy) {
        var row = level.cells[cy];
        for (var cx = 0; cx < level.width; ++cx) {
            var cell = row[cx];
            if (cell.type == cell_type) {
                ++n;
            }
        }
    }
    return n;
}

function level_get_num_cells_of_types(level/*: Level*/, cell_types/*: LevelCellType[]*/) /*-> int*/
{
    var n = 0;
    for (var i = 0, len = array_length(cell_types); i < len; ++i) {
        n += level_get_num_cells_of_type(level, cell_types[i]);
    }
    return n;
}

function _level_generate_terrain(level/*: Level*/) /*-> Terrain*/
{
    var w = level.width;
    var h = level.height;
    var terrain_cells = /*#cast*/ array_create(h, undefined) /*#as TerrainCell[][]*/;
    for (var cy = 0; cy < h; ++cy) {
        var terrain_cells_row = array_create(w, /*#cast*/ undefined);
        terrain_cells[cy] = terrain_cells_row;
        var level_cells_row = level.cells[cy];
        for (var cx = 0; cx < w; ++cx) {
            terrain_cells_row[cx] = level_cell_dump(level, level_cells_row[cx]);
        }
    }
    var terrain = new Terrain();
    terrain.cells = terrain_cells;
    terrain.width = w;
    terrain.height = h;
    
    return terrain;
}

function _terrain_dump_tiles(terrain/*: Terrain*/)
{
    _terrain_dump_ground_tiles(terrain);
}

function _terrain_dump_ground_tiles(terrain/*: Terrain*/)
{
    var w = terrain.width;
    var h = terrain.height;
    var ts = GTS_Grass;
    
    var tile_layer = layer_get_id("Ground");
    var tilemap = layer_tilemap_create(tile_layer, 0, 0, ts_general, w, h);
    for (var cx = 1; cx < w - 1; ++cx) {
        for (var cy = 1; cy < h - 1; ++cy) {
            
            var cell = terrain.cells[cy][cx];
            if (!cell.should_have_ground_tile()) {
                continue;
            }
            
            var left      = terrain.cells[cy    ][cx - 1].should_have_ground_tile();
            var right     = terrain.cells[cy    ][cx + 1].should_have_ground_tile();
            var top       = terrain.cells[cy - 1][cx    ].should_have_ground_tile();
            var bot       = terrain.cells[cy + 1][cx    ].should_have_ground_tile();
            var top_left  = terrain.cells[cy - 1][cx - 1].should_have_ground_tile();
            var top_right = terrain.cells[cy - 1][cx + 1].should_have_ground_tile();
            var bot_left  = terrain.cells[cy + 1][cx - 1].should_have_ground_tile();
            var bot_right = terrain.cells[cy + 1][cx + 1].should_have_ground_tile();
            
            var tile_index = ts.island;
            if (!left && right && !top && bot) {
                tile_index = bot_right ? ts.top_left : ts.bridge_corner_top_left;
            }
            else if (left && right && !top && bot) {
                tile_index = ts.top_mid;
            }
            else if (left && !right && !top && bot) {
                tile_index = bot_left ? ts.top_right : ts.bridge_corner_top_right;
            }
            else if (!left && right && top && bot) {
                tile_index = ts.mid_left;
            }
            else if (left && !right && top && bot) {
                tile_index = ts.mid_right;
            }
            else if (!left && right && top && !bot) {
                tile_index = top_right ? ts.bot_left : ts.bridge_corner_bot_left;
            }
            else if (left && right && top && !bot) {
                tile_index = ts.bot_mid;
            }
            if (left && !right && top && !bot) {
                tile_index = top_left ? ts.bot_right : ts.bridge_corner_bot_right;
            }
            else if (!left && right && !top && !bot) {
                tile_index = ts.bridge_hor_left;
            }
            else if (left && right && !top && !bot) {
                tile_index = ts.bridge_hor_mid;
            }
            else if (left && !right && !top && !bot) {
                tile_index = ts.bridge_hor_right;
            }
            else if (!left && !right && !top && bot) {
                tile_index = ts.bridge_ver_top;
            }
            else if (!left && !right && top && bot) {
                tile_index = ts.bridge_ver_mid;
            }
            else if (!left && !right && top && !bot) {
                tile_index = ts.bridge_ver_bot;
            }
            else if (left && right && top && bot) {
                if (!top_left) {
                    tile_index = ts.corner_bot_right;
                }
                else if (!top_right) {
                    tile_index = ts.corner_bot_left;
                }
                else if (!bot_left) {
                    tile_index = ts.corner_top_right;
                }
                else if (!bot_right) {
                    tile_index = ts.corner_top_left;
                }
                else {
                    tile_index = ts.mid_mid;
                }
            }
            
            var tile_data = tilemap_get(tilemap, cx, cy);
            tile_data = tile_set_index(tile_data, tile_index);
            tilemap_set(tilemap, tile_data, cx, cy);
        }
    }
}
