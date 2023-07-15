
function DebugSettings() constructor
{
    show_pathfinding        = true; /// @is {bool}
    show_sight_ranges       = true; /// @is {bool}
    show_exploration_ranges = true; /// @is {bool}
    show_attack_ranges      = true; /// @is {bool}
    show_player_actions     = true; /// @is {bool}
    show_human_actions      = true; /// @is {bool}
    show_ids                = true; /// @is {bool}
    show_energies           = true; /// @is {bool}
    show_log                = true; /// @is {bool}
    show_trait_data         = true; /// @is {bool}
    custom_config           = "";   /// @is {string}
    lang                    = "en"; /// @is {string}
	dev_session_user_id		= "test_user";	/// @is {string}
}

#macro _DEBUG_SETTINGS_FILENAME "debug/debug_settings.json"

function save_active_debug_settings()
{
    _save_debug_settings_to_file(Debugs, _DEBUG_SETTINGS_FILENAME);
}

function load_active_debug_settings()
{
    Debugs = _load_debug_settings_from_file(_DEBUG_SETTINGS_FILENAME);
    if (Debugs == undefined) {
        Debugs = new DebugSettings();
    }
}

function _load_debug_settings_from_file(filename/*: string*/) /*-> DebugSettings?*/
{
    if (!file_exists(filename)) {
        return undefined;
    }
    var json_struct = file_read_json(filename) /*#as struct*/;
    if (json_struct == undefined) {
        return undefined;
    }
    if (typeof(json_struct) != "struct") {
        return undefined;
    }
    
    var compiler = new GmlCompiler();
    
    var settings = new DebugSettings();
    var names = variable_struct_get_names(settings);
    for (var i = 0, len = array_length(names); i < len; ++i) {
        var name = names[i];
        if (!variable_struct_exists(json_struct, name)) {
            continue;
        }
        var value = json_struct[$ name];
        var value_type = typeof(value);
        var expected_type = typeof(settings[$ name]);
        if (value_type != expected_type) {
            if (expected_type == "bool") {
                try {
                    value = bool(value);
                }
                catch (err) {
                    continue;
                }
            }
            else {
                continue;
            }
        }
        settings[$ name] = value;
    }
    
    return settings;
}

function _save_debug_settings_to_file(settings/*: DebugSettings*/, filename/*: string*/) /*-> bool*/
{
    try {
        file_write_json(filename, settings);
        return true;
    }
    catch (err) {
        return false;
    }
}
