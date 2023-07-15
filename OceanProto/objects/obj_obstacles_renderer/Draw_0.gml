event_inherited();

if ((surface_needs_redraw || !surface_exists(surface)) && instance_exists(Trial)) {
    
    surface_needs_redraw = false;
    
    var layer_width = Trial.terrain.width * CSIZE;
    var layer_height = CSIZE + layer_vertical_padding * 2;
    
    var surf_width = layer_width;
    var surf_height = Trial.terrain.height * layer_height;
    surface = __create_or_resize_surface_if_needed(surface, surf_width, surf_height);
    
    for (var i = 0, len = array_length(layers); i < len; ++i) {
        destroy_instance(layers[i]);
    }
    layers = [];
    for (var i = 0, len = Trial.terrain.height; i < len; ++i) {
        var xx = 0;
        var yy = i * CSIZE;
        layers[i] = instance_create_depth(xx, yy, 0, obj_obstacles_renderer_layer);
        var x1 = 0;
        var y1 = i * layer_height;
        var x2 = layer_width;
        var y2 = y1 + layer_height;
        var rect = new Rect(x1, y1, x2, y2);
        layers[i].initialize(id, rect);
    }
    
    surface_set_target(surface);
    draw_clear_alpha(c_black, 0);
    var instances = find_instances_of_objects([obj_foliage, obj_rock]);
    for (var i = 0, len = array_length(instances); i < len; ++i) {
        var inst = instances[i];
        var cell = Trial.terrain.cell_at_room(inst.x, inst.y) /*#as TerrainCell*/;
        var layer_index = floor(cell.cy);
        if (layer_index >= 0 && layer_index < array_length(layers)) {
            var rlayer = layers[layer_index];
            var xx = inst.x;
            var yy = inst.y * (layer_height / CSIZE);
            inst.draw(xx, yy);
        }
    }
    
    surface_reset_target();
}