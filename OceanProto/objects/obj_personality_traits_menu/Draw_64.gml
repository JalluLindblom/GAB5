event_inherited();

if (!initialized) {
    return;
}

draw_set_alpha(1);

var width = menu_x2 - menu_x1;
var offset_x = animated_relative_offset_x * (width + 100);
var x1 = menu_x1 + offset_x;
var y1 = menu_y1;
var x2 = menu_x2 + offset_x;
var y2 = menu_y2;

draw_nine_slice(spr_ui_panel, 0, x1 - padding, y1 - padding, x2 - padding, y2 - padding, 0, c_white, 1);

if (!frozen) {
	menu.render(CommonMenuController, menu_mouse_x, menu_mouse_y, x1, y1, x2, y2);
}
else {
	if (!sprite_exists(frozen_sprite)) {
		var surf_w = menu_x2 - menu_x1;
		var surf_h = menu_y2 - menu_y1;
		var surf = surface_create(surf_w, surf_h);
		if (surface_exists(surf)) {
			surface_set_target(surf);
			menu.step(CommonMenuController, menu_mouse_x, menu_mouse_y, 0, 0, surf_w, surf_h);
			menu.render(CommonMenuController, menu_mouse_x, menu_mouse_y, 0, 0, surf_w, surf_h);
			surface_reset_target();
			frozen_sprite = sprite_create_from_surface(surf, 0, 0, surf_w, surf_h, false, false, 0, 0);
			surface_free(surf);
		}
	}
	if (sprite_exists(frozen_sprite)) {
		draw_sprite_ext(frozen_sprite, 0, x1, y1, 1, 1, 0, c_white, 1);
	}
}

var info_is_open = instance_exists(info_menu);
var info_spr = info_is_open ? spr_info_button_up : spr_info_button_up;
var alpha = info_hovered ? 1.0 : 0.5;
draw_sprite_ext(info_spr, 0, info_x1 + offset_x, info_y1, 1, 1, 0, c_white, alpha);

if (DEBUG_MODE && Debugs.show_trait_data) {
    var str = personality_traits_print_data(traits);
    var table_scribble = scribble(str)
        .starting_format(FontConsoleSmall, COLOR.white)
        .align(fa_left, fa_top);
    var origin_x = menu_x1 - 62;
    var origin_y = menu_y2 + 5;
    var x1 = origin_x + table_scribble.get_left() - 10;
    var y1 = origin_y + table_scribble.get_top() - 10;
    var x2 = origin_x + table_scribble.get_right() + 10;
    var y2 = origin_y + table_scribble.get_bottom() + 10;
    render_rectangle(x1, y1, x2, y2, COLOR.black, 0.75, false);
    table_scribble.draw(origin_x, origin_y);
}
