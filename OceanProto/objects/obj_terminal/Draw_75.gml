event_inherited();

var gui_width = display_get_gui_width();
var gui_height = display_get_gui_height();

var surf_width = gui_width;
var surf_height = gui_height;
if (!surface_exists(surface)) {
    surface = surface_create(surf_width, surf_height);
    needs_redraw = true;
}
else if (surface_get_width(surface) != surf_width || surface_get_height(surface) != surf_height) {
    surface_resize(surface, surf_width, surf_height);
    needs_redraw = true;
}

if (needs_redraw) {
    surface_set_target(surface);
    draw_clear_alpha(c_black, 0);
    
    var xx = 5;
    var yy = gui_height - 60;
    for (var i = array_length(line_scribbles) - 1; i >= 0; --i) {
        var line_scribble = line_scribbles[i];
        line_scribble.draw(xx, yy);
        yy -= line_scribble.get_height();
    }
    
    surface_reset_target();
    needs_redraw = false;
}

var surf_x = round(animated_offset_x);
var surf_y = round(animated_offset_y);
draw_surface_ext(surface, surf_x, surf_y, 1, 1, 0, c_white, 1);