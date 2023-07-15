event_inherited();

window_state_filename = "debug/window_states.json";   /// @is {string}
window_state = {                                     /// @is {struct}
    open_windows: [],
};                                   

// The list of existing windows in order of depth.
// The active window is always the first one.
window_list = ds_list_create();      /// @is {ds_list<__obj_gdt_window>}

// Window list sorted by ID
windows_by_id_list = ds_list_create(); /// @is {ds_list<__obj_gdt_window>}

// Adds a new window to the list. Called only by __obj_gdt_window.
function _add_window(window/*: __obj_gdt_window*/) /*-> bool*/
{
    if (!ds_exists(window_list, ds_type_list)) {
        return false;
    }
    if (ds_list_find_index(window_list, window) < 0) {
        ds_list_add(window_list, window);
        _window_list_changed();
        return true;
    }
    return false;
}

// Removes a window from the list. Called only by __obj_gdt_window.
function _remove_window(window/*: __obj_gdt_window*/) /*-> bool*/
{
    if (!ds_exists(window_list, ds_type_list)) {
        return false;
    }
    var index = ds_list_find_index(window_list, window);
    if (index >= 0) {
        ds_list_delete(window_list, index);
        _window_list_changed();
        return true;
    }
    return false;
}

function _window_list_changed() /*-> bool*/
{
    if (!ds_exists(windows_by_id_list, ds_type_list)) {
        return false;
    }
    ds_list_clear(windows_by_id_list);
    ds_list_copy(windows_by_id_list, window_list);
    ds_list_sort(windows_by_id_list, true);
    return true;
}

function _activate_window(_window/*: __obj_gdt_window*/)
{
     if (instance_exists(_window)) {
        var index = ds_list_find_index(window_list, _window);
        if (index >= 0) {
            ds_list_delete(window_list, index);
            ds_list_insert(window_list, 0, _window);
            _window_list_changed();
        }
        _window.set_active(true);
    }
    for (var i = 0; i < ds_list_size(window_list); ++i) {
        if (window_list[| i] != _window) {
            window_list[| i].set_active(false);
        }
    }
}

alarm[0] = 1; // Initialization alarm.