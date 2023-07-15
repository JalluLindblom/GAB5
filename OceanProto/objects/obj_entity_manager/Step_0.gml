event_inherited();

if (!instance_exists(Trial) || Trial.terrain == undefined || Trial.is_auto_run) {
    return;
}

var min_depth = layer_get_depth(layer_get_id("InstancesAbove"));
var max_depth = layer_get_depth(layer_get_id("Instances"));

var min_y = 0;
var max_y = Trial.terrain.height * CSIZE;

with (obj_entity) {
    var amount = 1.0 - ((y - min_y) / max_y);
    depth = clamp(lerp(min_depth, max_depth, amount), min_depth, max_depth);
}
with (obj_obstacles_renderer_layer) {
    var amount = 1.0 - ((y + CSIZE / 2 - min_y) / max_y);
    depth = clamp(lerp(min_depth, max_depth, amount), min_depth, max_depth);
}
