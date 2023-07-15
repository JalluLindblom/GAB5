event_inherited();

var num_windows = ds_list_size(window_list);

var topmost_hovered_window = noone;
for (var i = 0; i < num_windows; ++i) {
    var window = window_list[| i];
    if (instance_exists(window) && window.hovered) {
        topmost_hovered_window = window;
        break;
    }
}
for (var i = num_windows - 1; i >= 0; --i) {
    var window = window_list[| i];
    if (surface_exists(window.surface)) {
        var alpha = 0.25;
        if (window == topmost_hovered_window) alpha = 0.5;
        if (window.active) alpha = 1;
        draw_surface_ext(window.surface, window.window_bbox.x1, window.window_bbox.y1, 1, 1, 0, c_white, alpha);
    }
}
