event_inherited();

var xx = round(x);
var yy = round(y);

if (sprite_exists(sprite_index)) {
    // Draw an outline.
    var t = 1;
    draw_sprite_ext(sprite_index, image_index, xx + 1, yy, image_xscale, image_yscale, 0, c_black, 1);
    draw_sprite_ext(sprite_index, image_index, xx - 1, yy, image_xscale, image_yscale, 0, c_black, 1);
    draw_sprite_ext(sprite_index, image_index, xx, yy + 1, image_xscale, image_yscale, 0, c_black, 1);
    draw_sprite_ext(sprite_index, image_index, xx, yy - 1, image_xscale, image_yscale, 0, c_black, 1);
    
    draw_sprite_ext(sprite_index, image_index, xx, yy, image_xscale, image_yscale, 0, c_white, 1);
}

var content_x = round(xx);
var content_y = round(yy - 22 * image_yscale);
draw_sprite_ext(content_sprite, 0, content_x, content_y, image_xscale, image_yscale, 0, c_white, 1);
