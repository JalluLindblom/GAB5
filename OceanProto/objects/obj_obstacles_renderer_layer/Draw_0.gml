event_inherited();

var surf = renderer.surface;
if (surface_exists(surf)) {
    var xx = x;
    var yy = y - renderer.layer_vertical_padding;
    draw_surface_part_ext(surf, surf_rect.x1, surf_rect.y1, surf_rect.get_width(), surf_rect.get_height(), xx, yy, 1, 1, c_white, 1);
}
