
function gizmos_set_target_layer(layer_id_or_name/*: layer|string*/)
{
    var lay = layer_id_or_name;
    if (is_string(layer_id_or_name)) {
        lay = layer_get_id(layer_id_or_name);
    }
    with (obj_gizmos) {
        if (!ds_map_exists(_drawers_per_layer, lay) || !instance_exists(_drawers_per_layer[? lay])) {
            var drawer = instance_create_layer(0, 0, lay, __obj_gdt_gizmos_drawer);
            drawer.gizmos = id;
            _drawers_per_layer[? lay] = drawer;
        }
        _target_drawer = _drawers_per_layer[? lay];
    }
}
