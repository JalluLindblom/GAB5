event_inherited();

// Initialization alarm.

// Load window state.
var window_state_in_file = __window_file_read_json(window_state_filename) /*#as struct*/;
if (window_state_in_file != undefined) {
    window_state = window_state_in_file;
    for (var i = 0, len = array_length(window_state.open_windows); i < len; ++i) {
        var object_name = window_state.open_windows[i] /*#as string*/;
        var objectIndex = asset_get_index(object_name);
        if (object_exists(objectIndex)) {
            if (!instance_exists(objectIndex)) {
                instance_create_depth(0, 0, 0, objectIndex);
            }
        }
    }
}