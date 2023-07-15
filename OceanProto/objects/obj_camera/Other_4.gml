event_inherited();

if (room == rm_trial) {
    var back_id = layer_background_get_id("Background");
    var color_str = Configs.level_background_color;
    var color = color_from_hexadecimal_string(string_remove_prefix(color_str, "#"));
    layer_background_blend(back_id, color);
}
