event_inherited();

var gui_width = display_get_gui_width();
var gui_height = display_get_gui_height();

var vol_w = sprite_get_width(spr_volume_off);
var vol_h = sprite_get_height(spr_volume_off);
volume_x1 = gui_width - 30 - vol_w;
volume_y1 = gui_height - 30 - vol_h;
volume_x2 = volume_x1 + vol_w;
volume_y2 = volume_y1 + vol_h;

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);
volume_hovered = point_in_rectangle(mx, my, volume_x1, volume_y1, volume_x2, volume_y2);

if (volume_hovered) {
    cursor_set(cr_handpoint);
    if (mouse_check_button_pressed(mb_left)) {
        // Toggle master gain
        var master_gain = audio_get_master_gain(0);
        if (master_gain > 0) {
            audio_set_master_gain(0, 0);
        }
        else {
            audio_set_master_gain(0, 1);
        }
    }
}
