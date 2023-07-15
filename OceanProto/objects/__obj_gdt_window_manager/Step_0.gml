event_inherited();

if (mouse_check_button_pressed(mb_left)) {
    var hovered_window = noone;
    var num_windows = ds_list_size(window_list);
    for (var i = 0; i < num_windows; ++i) {
        var window = window_list[| i];
        if (instance_exists(window) && (window.hovered || window.dragging_something)) {
            hovered_window = window;
            break;
        }
    }
    _activate_window(hovered_window);
}