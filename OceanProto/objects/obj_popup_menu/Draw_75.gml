event_inherited();

draw_set_alpha(1);

var height = animated_relative_height * (menu_y2 - menu_y1);
var menu_center_y = (menu_y1 + menu_y2) / 2;

var x1 = round(menu_x1);
var y1 = round(menu_center_y - height / 2);
var x2 = round(menu_x2);
var y2 = round(y1 + height);

draw_nine_slice(spr_ui_panel, 0, x1 - padding, y1 - padding, x2 + padding, y2 + padding, 0, c_white, 1);

menu.render(CommonMenuController, menu_mouse_x, menu_mouse_y, x1, y1, x2, y2);
