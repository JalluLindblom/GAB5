event_inherited();

if (instance_exists(Trial) && Trial.is_auto_run) {
    return;
}

if (room == rm_trial) {
    
    layer = layer_get_id("Shadows");
    
    if (layer_get_fx(layer) == -1) {
        layer_clear_fx(layer);
        var fx = fx_create("_filter_large_blur");
        fx_set_single_layer(fx, true);
        fx_set_parameter(fx, "g_Radius", 2);
        layer_set_fx(layer, fx);
    }
}