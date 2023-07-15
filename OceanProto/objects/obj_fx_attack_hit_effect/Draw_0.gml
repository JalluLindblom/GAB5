event_inherited();

var set_shader = (life_timer % 6 < 3);
if (set_shader) {
    set_color_shader(c_white);
}
draw_self();
if (set_shader) {
    shader_reset();
}

if (initial_flash_timer > 0) {
    set_color_shader(c_white);
    draw_sprite_ext(sprite_index, image_index, x, y, 2, 2, image_angle, image_blend, 1);
    shader_reset();
}
