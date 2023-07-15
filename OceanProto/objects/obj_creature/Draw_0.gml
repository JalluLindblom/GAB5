event_inherited();

if (Trial.is_auto_run) {
    return;
}

var xx = x;
var yy = y;

if (animation == CREATURE_ANIMATION.hurt) {
    xx += irandom_range(-2, 2);
    yy += irandom_range(-2, 2);
}

xx += attack_animation_offset_x + fixed_draw_offset_x;
yy += attack_animation_offset_y + fixed_draw_offset_y;

xx = round(xx);
yy = round(yy);

if (draw_outline) {
    set_color_shader(COLOR.black);
    var t = 2;
    draw_sprite_ext(sprite_index, image_index, xx - t, yy,     image_xscale, image_yscale, image_angle, image_blend, image_alpha);
    draw_sprite_ext(sprite_index, image_index, xx + t, yy,     image_xscale, image_yscale, image_angle, image_blend, image_alpha);
    draw_sprite_ext(sprite_index, image_index, xx,     yy - t, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
    draw_sprite_ext(sprite_index, image_index, xx,     yy + t, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
    shader_reset();
}

var set_hurt_shader = false;
if ((animation == CREATURE_ANIMATION.hurt) && ((animation_timer % 4) < 2)) {
    set_hurt_shader = true;
}

if (set_hurt_shader) {
    set_color_shader(COLOR.red);
}
draw_sprite_ext(sprite_index, image_index, xx, yy, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
if (set_hurt_shader) {
    shader_reset();
}