event_inherited();

var gui_width = display_get_gui_width();
var gui_height = display_get_gui_height();

mouse_xx = device_mouse_x_to_gui(0);
mouse_yy = device_mouse_y_to_gui(0);
x1 = 5;
y1 = 85;
x2 = 240;
y2 = y1 + menu.get_total_content_height(x2 - x1);

if (visible) {
    menu.step(CommonMenuController, mouse_xx, mouse_yy, x1, y1, x2, y2);
}