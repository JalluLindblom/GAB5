
enum GUI_WINDOW_DRAGGABLE
{
    top_left,
    top,
    top_right,
    right,
    bottom_right,
    bottom,
    bottom_left,
    left,
    window,
}

function create_window() /*-> __obj_gdt_window*/
{
    var window = instance_create_depth(0, 0, 0, __obj_gdt_window);
    return window;
}

function __get_window_manager() /*-> __obj_gdt_window_manager*/
{
    static manager = noone;
    if (!instance_exists(__obj_gdt_window_manager)) {
        manager = instance_create_depth(0, 0, 0, __obj_gdt_window_manager);
    }
    return manager;
    
}

function _serialize_debug_gui_window(gui_window/*: __obj_gdt_window*/) /*-> string*/
{
    var json = {
        wx1: gui_window.windowed_bbox.x1,
        wy1: gui_window.windowed_bbox.y1,
        wx2: gui_window.windowed_bbox.x2,
        wy2: gui_window.windowed_bbox.y2,
        serialized_properties: gui_window.serialized_properties,
    };
    
    return base64_encode(json_stringify(json));
}

function _deserialize_debug_gui_window(gui_window/*: __obj_gdt_window*/, gui_window_serialized/*: string*/)
{
    var json;
    try {
        json = json_parse(base64_decode(gui_window_serialized));
    }
    catch (_) {
        return;
    }
    
    if (variable_struct_exists(json, "wx1")) {
        gui_window.windowed_bbox.x1 = json.wx1;
    }
    if (variable_struct_exists(json, "wy1")) {
        gui_window.windowed_bbox.y1 = json.wy1;
    }
    if (variable_struct_exists(json, "wx2")) {
        gui_window.windowed_bbox.x2 = json.wx2;
    }
    if (variable_struct_exists(json, "wy2")) {
        gui_window.windowed_bbox.y2 = json.wy2;
    }
    
    gui_window.serialized_properties = StructGetOfType(json, "serialized_properties", "struct", {});
    
}

function activate_debug_gui_window(_window/*: __obj_gdt_window*/)
{
    __get_window_manager()._activate_window(_window);
}

function load_and_save_debug_window_state_in_file(window/*: __obj_gdt_window*/, owner_instance/*: instance*/, filename/*: string*/)
{
    ini_open(filename);
    var serialized_window = ini_read_string("s", "s", "");
    ini_close();
    if (serialized_window != "") {
        _deserialize_debug_gui_window(window, serialized_window);
    }
    var owner_object_name = object_get_name(owner_instance.object_index);
    var manager = __get_window_manager();
    if (!__window_array_contains(manager.window_state.open_windows, owner_object_name)) {
        array_push(manager.window_state.open_windows, owner_object_name);
    }
    window.on_cleanup(method({ filename: filename, owner_object_name: owner_object_name }, function(gui_window) {
        var str = _serialize_debug_gui_window(gui_window);
        ini_open(filename);
        ini_write_string("s", "s", str);
        ini_close();
        __window_array_remove_all(__get_window_manager().window_state.open_windows, owner_object_name);
    }));
}
