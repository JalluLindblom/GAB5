event_inherited();

var xx = round(x + fixed_draw_offset_x);
var yy = round(y + fixed_draw_offset_y);

// Draw an outline.
set_color_shader(COLOR.black);
var t = 2;
draw_sprite_ext(sprite_index, image_index, xx - t, yy,     image_xscale, image_yscale, image_angle, image_blend, image_alpha);
draw_sprite_ext(sprite_index, image_index, xx + t, yy,     image_xscale, image_yscale, image_angle, image_blend, image_alpha);
draw_sprite_ext(sprite_index, image_index, xx,     yy - t, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
draw_sprite_ext(sprite_index, image_index, xx,     yy + t, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
shader_reset();

draw_sprite_ext(sprite_index, image_index, xx, yy, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
