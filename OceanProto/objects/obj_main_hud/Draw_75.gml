event_inherited();

var volume_is_on = audio_get_master_gain(0) > 0;
var volume_spr = volume_is_on ? spr_volume_on : spr_volume_off;
var alpha = volume_hovered ? 1.0 : 0.5;
draw_sprite_ext(volume_spr, 0, volume_x1, volume_y1, 1, 1, 0, c_white, alpha);
