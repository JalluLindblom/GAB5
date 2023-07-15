
function set_outer_outline_color_shader(texture/*: texture*/, color/*: int*/)
{
    static u_texelSize = shader_get_uniform(shd_outer_outline_color, "u_texelSize");
    static u_color = shader_get_uniform(shd_outer_outline_color, "u_color");
    shader_set(shd_outer_outline_color);
    shader_set_uniform_f(u_texelSize, texture_get_texel_width(texture), texture_get_texel_height(texture));
    var r = color_get_red(color) / 255.0;
    var g = color_get_green(color) / 255.0;
    var b = color_get_blue(color) / 255.0;
    shader_set_uniform_f(u_color, r, g, b);
}

function set_inner_outline_color_shader(texture/*: texture*/, color/*: int*/, onlyOutline/*: bool*/ = false)
{
    static u_texelSize = shader_get_uniform(shd_inner_outline_color, "u_texelSize");
    static u_textureUvTopLeft = shader_get_uniform(shd_inner_outline_color, "u_textureUvTopLeft");
    static u_textureUvBottomRight = shader_get_uniform(shd_inner_outline_color, "u_textureUvBottomRight");
    static u_color = shader_get_uniform(shd_inner_outline_color, "u_color");
    static u_onlyOutline = shader_get_uniform(shd_inner_outline_color, "u_onlyOutline");
    shader_set(shd_inner_outline_color);
    shader_set_uniform_f(u_texelSize, texture_get_texel_width(texture), texture_get_texel_height(texture));
    var uvs = texture_get_uvs(texture);
    shader_set_uniform_f(u_textureUvTopLeft, uvs[0], uvs[1]);
    shader_set_uniform_f(u_textureUvBottomRight, uvs[2], uvs[3]);
    var r = color_get_red(color) / 255.0;
    var g = color_get_green(color) / 255.0;
    var b = color_get_blue(color) / 255.0;
    shader_set_uniform_f(u_color, r, g, b);
    shader_set_uniform_i(u_onlyOutline, onlyOutline ? 1 : 0);
}

function set_color_shader(color/*: int*/)
{
    static u_color = shader_get_uniform(shd_color, "u_color");
    shader_set(shd_color);
    shader_set_uniform_i(u_color, color);
}

function render_shadow(xx/*: number*/, yy/*: number*/, radius/*: number*/)
{
    var x1 = xx - radius;
    var y1 = yy - radius / 2;
    var x2 = xx + radius;
    var y2 = yy + radius / 2;
    var color = COLOR.black;
    var prev_alpha = draw_get_alpha();
    draw_set_alpha(0.33);
    draw_ellipse_color(x1, y1, x2, y2, color, color, false);
    draw_set_alpha(prev_alpha);
}

function render_line(x1/*: number*/, y1/*: number*/, x2/*: number*/, y2/*: number*/, width/*: number*/, color/*: int*/, alpha/*: number*/)
{
    var len = point_distance(x1, y1, x2, y2);
    var dir = point_direction(x1, y1, x2, y2);
    draw_sprite_ext(spr_pixel, 0, x1, y1, len, width, dir, color, alpha);
}

function render_circle(xx/*: number*/, yy/*: number*/, radius/*: number*/, color/*: int*/, alpha/*: number*/, outline/*: bool*/)
{
    var prev_alpha = draw_get_alpha();
    draw_set_alpha(alpha);
    draw_circle_color(xx, yy, radius, color, color, outline);
    draw_set_alpha(prev_alpha);
}

function render_ellipse(x1/*: number*/, y1/*: number*/, x2/*: number*/, y2/*: number*/, color/*: int*/, alpha/*: number*/, outline/*: bool*/)
{
    var prev_alpha = draw_get_alpha();
    draw_set_alpha(alpha);
    draw_ellipse_color(x1, y1, x2, y2, color, color, outline);
    draw_set_alpha(prev_alpha);
}

function render_rectangle(x1/*: number*/, y1/*: number*/, x2/*: number*/, y2/*: number*/, color/*: int*/, alpha/*: number*/, outline/*: bool*/)
{
    if (outline) {
        var prev_alpha = draw_get_alpha();
        draw_set_alpha(alpha);
        draw_rectangle_color(x1, y1, x2, y2, color, color, color, color, outline);
        draw_set_alpha(prev_alpha);
    }
    else {
        draw_sprite_ext(spr_pixel, 0, x1, y1, (x2 - x1), (y2 - y1), 0, color, alpha);
    }
}

function draw_nine_slice(spr/*: sprite*/, img/*: number*/, x1/*: number*/, y1/*: number*/, x2/*: number*/, y2/*: number*/, rot/*: number*/, col/*: int*/, alpha/*: number*/)
{
    var xscale = (x2 - x1) / sprite_get_width(spr);
    var yscale = (y2 - y1) / sprite_get_height(spr);
    draw_sprite_ext(spr, img, x1, y1, xscale, yscale, rot, col, alpha);
}

function draw_sprite_outlined(sprite/*: sprite*/, subimg/*: number*/, xx/*: number*/, yy/*: number*/, xscale/*: number*/, yscale/*: number*/, rot/*: number*/, col/*: int*/, alpha/*: number*/, outline_color/*: int*/, outline_thickness/*: number*/)
{
    set_color_shader(outline_color);
    var t = outline_thickness;
    draw_sprite_ext(sprite, subimg, xx - t, yy, xscale, yscale, rot, col, alpha);
    draw_sprite_ext(sprite, subimg, xx + t, yy, xscale, yscale, rot, col, alpha);
    draw_sprite_ext(sprite, subimg, xx, yy - t, xscale, yscale, rot, col, alpha);
    draw_sprite_ext(sprite, subimg, xx, yy + t, xscale, yscale, rot, col, alpha);
    shader_reset();
    draw_sprite_ext(sprite, subimg, xx, yy, xscale, yscale, rot, col, alpha);
}
