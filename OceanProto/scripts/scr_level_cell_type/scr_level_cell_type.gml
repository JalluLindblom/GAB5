
function initialize_level_cell_types()
{
    CALL_ONLY_ONCE
    
    global.allLevelCellTypes = [];                  /// @is {LevelCellType[]}
    global.levelCellTypesByChar = ds_map_create();  /// @is {ds_map<string, LevelCellType>}
    
    globalvar LCT_empty; /// @is {LevelCellType}
    LCT_empty = new LevelCellType(
        " ",
        true,
        function(level/*: Level*/, cell/*: TerrainCell*/) {
            // do nothing
        }
    );
    
    globalvar LCT_hole; /// @is {LevelCellType}
    LCT_hole = new LevelCellType(
        "x",
        false,
        function(level/*: Level*/, cell/*: TerrainCell*/) {
            // do nothing
        }
    );
    
    globalvar LCT_rock; /// @is {LevelCellType}
    LCT_rock = new LevelCellType(
        "r",
        false,
        function(level/*: Level*/, cell/*: TerrainCell*/) {
            if (!Trial.is_auto_run) {
                var xx = cell.room_rect.get_center_x();
                var yy = cell.room_rect.get_center_y();
                var rock = instance_create_layer(xx, yy, "Instances", obj_rock);
                var seed = cell.cy * 999 + cell.cx;
                var rng = new Rng(seed);
                rock.initialize(level, rng);
                cell.is_rock = true;
            }
        }
    );
    
    globalvar LCT_human_random; /// @is {LevelCellType}
    LCT_human_random = new LevelCellType(
        "h",
        true,
        function(level/*: Level*/, cell/*: TerrainCell*/) {
            var human_ai = instance_create_layer(cell.room_rect.get_center_x(), cell.room_rect.get_center_y(), "Instances", obj_human_ai);
            human_ai.human_ai_initialize(undefined);
        }
    );
    
    global.all_typed_human_ai_level_cell_types = []; /// @is {LevelCellType[]}
    for (var type_number = 0; type_number <= 9; ++type_number) {
        array_push(global.all_typed_human_ai_level_cell_types, new LevelCellType(
            string(type_number),
            true,
            method({ type_number: type_number }, function(level/*: Level*/, cell/*: TerrainCell*/) {
                var human_ai = instance_create_layer(cell.room_rect.get_center_x(), cell.room_rect.get_center_y(), "Instances", obj_human_ai);
                human_ai.human_ai_initialize(type_number);
            })
        ));
    }
    
    globalvar LCT_player; /// @is {LevelCellType}
    LCT_player = new LevelCellType(
        "p",
        true,
        function(level/*: Level*/, cell/*: TerrainCell*/) {
            instance_create_layer(cell.room_rect.get_center_x(), cell.room_rect.get_center_y(), "Instances", obj_human_player);
        }
    );
    
    globalvar LCT_monster; /// @is {LevelCellType}
    LCT_monster = new LevelCellType(
        "m",
        true,
        function(level/*: Level*/, cell/*: TerrainCell*/) {
            instance_create_layer(cell.room_rect.get_center_x(), cell.room_rect.get_center_y(), "Instances", obj_monster);
        }
    );
    
    globalvar LCT_food; /// @is {LevelCellType}
    LCT_food = new LevelCellType(
        "f",
        true,
        function(level/*: Level*/, cell/*: TerrainCell*/) {
            instance_create_layer(cell.room_rect.get_center_x(), cell.room_rect.get_center_y(), "Instances", obj_food);
        }
    );
    
    globalvar LCT_sand; /// @is {LevelCellType}
    LCT_sand = new LevelCellType(
        "s",
        true,
        function(level/*: Level*/, cell/*: TerrainCell*/) {
            cell.is_sand = true;
            if (!Trial.is_auto_run) {
                var xx = cell.room_rect.get_center_x();
                var yy = cell.room_rect.get_center_y();
                var foliage = instance_create_layer(xx, yy, "Instances", obj_foliage);
                var seed = cell.cy * 999 + cell.cx;
                var rng = new Rng(seed);
                foliage.initialize(level, rng);
                cell.is_rock = true;
            }
        }
    );
}

function LevelCellType(_character/*: string*/, _is_traversable/*: bool*/, _dump_callback/*: (function<Level, TerrainCell, void>)*/) constructor
{
    character = _character;             /// @is {string}
    is_traversable = _is_traversable;   /// @is {bool}
    dump_callback = _dump_callback;     /// @is {function<Level, TerrainCell, void>}
    
    array_push(global.allLevelCellTypes, self);
    global.levelCellTypesByChar[? character] = self;
}
