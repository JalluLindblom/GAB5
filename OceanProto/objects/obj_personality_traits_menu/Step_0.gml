event_inherited();

if (!initialized) {
    return;
}

var gui_width = display_get_gui_width();
var gui_height = display_get_gui_height();

var menu_width = 400;
var menu_height = 600;

menu_mouse_x = device_mouse_x_to_gui(0);
menu_mouse_y = device_mouse_y_to_gui(0);
menu_x1 = round(gui_width - 75 - menu_width + padding);
menu_y1 = round(gui_height / 2 - menu_height / 2 - 100 + padding);
if (DEBUG_MODE && Debugs.show_trait_data) {
    menu_y1 = round(10 + padding);
}
menu_x2 = round(menu_x1 + menu_width - padding);
menu_y2 = round(menu_y1 + menu_height - padding);

if (!closing && !frozen) {
    menu.step(CommonMenuController, menu_mouse_x, menu_mouse_y, menu_x1, menu_y1, menu_x2, menu_y2);
}

var is_infinite_speed = (Configs.game_speed < 0);
if (is_infinite_speed) {
    // Don't animate the menu when in infinite speed mode.
    animated_relative_offset_x = 0;
    if (closing) {
        instance_destroy();
        return;
    }
}
else {
    if (closing) {
        animated_relative_offset_x += (1.0 - animated_relative_offset_x) * 0.25;
        if (abs(animated_relative_offset_x - 1.0) < 0.1) {
            instance_destroy();
            return;
        }
    }
    else {
        animated_relative_offset_x += (0.0 - animated_relative_offset_x) * 0.25;
    }
}

var info_w = sprite_get_width(spr_info_button_up);
var info_h = sprite_get_height(spr_info_button_up);
info_x1 = menu_x2 - 30 - info_w;
info_y1 = menu_y1 + 10;
info_x2 = info_x1 + info_w;
info_y2 = info_y1 + info_h;

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);
info_hovered = !closing && point_in_rectangle(mx, my, info_x1, info_y1, info_x2, info_y2);

if (info_hovered) {
    cursor_set(cr_handpoint);
    if (mouse_check_button_pressed(mb_left)) {
        // Toggle info menu
		if (instance_exists(info_menu)) {
			info_menu = destroy_instance(info_menu);
		}
		else {
			var menu_def = make_instructions_menu();
			info_menu = create_popup_menu(menu_def, 750);
			info_menu.halign = fa_left;
			info_menu.valign = fa_middle;
		}
    }
}

if (closing && instance_exists(info_menu)) {
	info_menu.closing = true;
}

if (DEBUG_MODE && Debugs.show_trait_data) {
    // Update the parameters constantly so that we can see the
    // debug visualizers and whatnot update in real time.
    for (var i = 0, len = instance_number(obj_human_player); i < len; ++i) {
        var player = instance_find(obj_human_player, i);
        player.set_traits(traits);
    }
}