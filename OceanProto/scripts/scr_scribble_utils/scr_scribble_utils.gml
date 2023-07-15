
/// A customized version of scribble_font_bake_outline_4dir.
/// This version doesn't create padding around the glyphs.
function scribble_custom_font_bake_outline(source_font_name/*: string*/, new_font_name/*: string*/, outline_color/*: int*/, smooth/*: bool*/, texture_size/*: number?*/ = undefined)
{
    static u_vOutlineColor = shader_get_uniform(__shd_scribble_bake_outline_4dir, "u_vOutlineColor");
    
    shader_set(__shd_scribble_bake_outline_4dir);
    var red   = color_get_red(outline_color) / 255;
    var green = color_get_green(outline_color) / 255;
    var blue  = color_get_blue(outline_color) / 255;
    shader_set_uniform_f(u_vOutlineColor, red, green, blue);
    shader_reset();

    scribble_font_bake_shader(source_font_name, new_font_name, __shd_scribble_bake_outline_4dir, 0, 1, 1, 1, 1, 0, smooth, texture_size);
}
