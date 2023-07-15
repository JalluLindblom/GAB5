event_inherited();

var radius = 42;
if (point_distance(x, y, target_entity.x, target_entity.y) < 1) {
    radius += sin(current_time / 100) * 2;
}
var x1 = round(x - radius);
var y1 = round(y - radius / 2);
var x2 = round(x + radius);
var y2 = round(y + radius / 2);
draw_nine_slice(sprite_index, 0, x1, y1, x2, y2, image_angle, image_blend, image_alpha);
