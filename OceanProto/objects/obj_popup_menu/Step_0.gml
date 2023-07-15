event_inherited();

var gui_width = display_get_gui_width();
var gui_height = display_get_gui_height();

var height = ceil(menu_height ?? menu.get_total_content_height(menu_width));

menu_mouse_x = device_mouse_x_to_gui(0);
menu_mouse_y = device_mouse_y_to_gui(0);

switch (halign) {
	case fa_left: {
		menu_x1 = 10 + padding;
		break;
	}
	case fa_center: {
		menu_x1 = floor(gui_width / 2 - menu_width / 2) + padding;
		break;
	}
	case fa_right: {
		menu_x1 = gui_width - 10 - menu_width + padding;
		break;
	}
}
switch (valign) {
	case fa_top: {
		menu_y1 = 10 + padding;
		break;
	}
	case fa_middle: {
		menu_y1 = floor(gui_height * 0.5 - height / 2) + padding;
		break;
	}
	case fa_bottom: {
		menu_y1 = gui_height - 10 - height + padding;
		break;
	}
}

menu_x2 = ceil(menu_x1 + menu_width);
menu_y2 = ceil(menu_y1 + height);

if (!closing) {
    var ret = menu.step(CommonMenuController, menu_mouse_x, menu_mouse_y, menu_x1, menu_y1, menu_x2, menu_y2);
    if (ret == MENU_RETURN.close_menu) {
        closing = true;
        return;
    }
}

if (closing) {
    animated_relative_height += (0.0 - animated_relative_height) * 0.5;
    if (abs(animated_relative_height - 0.0) < 0.1) {
        instance_destroy();
        return;
    }
}
else {
    animated_relative_height += (1.0 - animated_relative_height) * 0.5;
}