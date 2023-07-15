event_inherited();

if (!instance_exists(player)) {
    return;
}

var gui_width = display_get_gui_width();
var gui_height = display_get_gui_height();

var set_shader = (damage_flash_timer > 0) && (damage_flash_timer % 4 < 2);

var shake = (damage_flash_timer > 0);

var base_scale = 0.5;
var base_width = (sprite_get_width(spr_heart_empty) + 10) * base_scale;
var x1 = round(gui_width / 2 - player.energy_max * base_width / 2);
var y1 = round(gui_height - 70);

if (set_shader) {
    set_color_shader(COLOR.white);
}
for (var i = 0; i < player.energy_max; ++i) {
    var xx = x1 + (i + 0.5) * base_width;
    var yy = y1;
    if (shake) {
        xx += irandom_range(-3, 3);
        yy += irandom_range(-3, 3);
    }
    var scale = (shake && i < animated_energy) ? base_scale * 1.2 : base_scale;
    draw_sprite_ext(spr_heart_empty, 0, xx, yy, scale, scale, 0, c_white, 1);
    if ((i + 1) <= animated_energy) {
        draw_sprite_ext(spr_heart_full, 0, xx, yy, scale, scale, 0, c_white, 1);
    }
    else if (i == floor(animated_energy)) {
        var w = sprite_get_width(spr_heart_full) * frac(animated_energy);
        var h = sprite_get_height(spr_heart_full);
        yy -= sprite_get_yoffset(spr_heart_full) * scale;
        xx -= sprite_get_xoffset(spr_heart_full) * scale;
        draw_sprite_part_ext(spr_heart_full, 0, 0, 0, w, h, xx, yy, scale, scale, c_white, 1);
    }
}
if (set_shader) {
    shader_reset();
}
