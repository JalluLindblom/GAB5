event_inherited();

var surf_width = content_bbox.get_width();
var surf_height = content_bbox.get_height();

if (!surface_exists(content_surface)) {
    content_surface = surface_create(surf_width, surf_height);
}
else if (surface_get_width(content_surface) != surf_width || surface_get_height(content_surface) != surf_height) {
    surface_resize(content_surface, surf_width, surf_height);
}

surface_set_target(content_surface);
draw_clear_alpha(c_black, 0);
content_drawer();
surface_reset_target();