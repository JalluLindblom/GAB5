event_inherited();

if (ds_exists(_drawers_per_layer, ds_type_map)) {
    ds_map_destroy(_drawers_per_layer);
    _drawers_per_layer = -1;
}
