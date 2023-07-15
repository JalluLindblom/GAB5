event_inherited();

if (hovered && active) {
    if (mouse_wheel_down()) {
        content_offset_y -= 40;
    }
    if (mouse_wheel_up()) {
        content_offset_y += 40;
    }
}
content_offset_x = min(0, content_offset_x);
content_offset_y = min(0, content_offset_y);

var cursor = cr_default;
if (active) {
    switch (dragged_thing) {
        case GUI_WINDOW_DRAGGABLE.top_left:
        case GUI_WINDOW_DRAGGABLE.bottom_right: {
            cursor = cr_size_nwse;
            break;
        }
        case GUI_WINDOW_DRAGGABLE.top_right:
        case GUI_WINDOW_DRAGGABLE.bottom_left: {
            cursor = cr_size_nesw;
            break;
        }
        case GUI_WINDOW_DRAGGABLE.top:
        case GUI_WINDOW_DRAGGABLE.bottom: {
            cursor = cr_size_ns;
            break;
        }
        case GUI_WINDOW_DRAGGABLE.left:
        case GUI_WINDOW_DRAGGABLE.right: {
            cursor = cr_size_we;
            break;
        }
        case GUI_WINDOW_DRAGGABLE.window: {
            cursor = cr_size_all;
            break;
        }
    }
}

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

hovered = point_in_rectangle(mx, my, window_bbox.x1, window_bbox.y1, window_bbox.x2, window_bbox.y2);

if (window_bbox.x1 < 0) {
    window_bbox.align_left(0);
}
if (display_get_gui_width() > 50) {
    window_bbox.x2 = max(10, min(window_bbox.x1 + (window_bbox.get_width()), window_bbox.x1 + display_get_gui_width()));
}
if (window_bbox.x2 > display_get_gui_width()) {
    window_bbox.align_right(display_get_gui_width());
}
if (window_bbox.y1 < 0) {
    window_bbox.align_top(0);
}
if (display_get_gui_height() > 50) {
    window_bbox.y2 = max(10, min(window_bbox.y1 + (window_bbox.get_height()), window_bbox.y1 + display_get_gui_height()));
}
if (window_bbox.y2 > display_get_gui_height()) {
    window_bbox.align_bottom(display_get_gui_height());
}