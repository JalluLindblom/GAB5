event_inherited();

statics_changed         = false;    /// @is {bool}
surface_needs_redraw    = false;    /// @is {bool}
surface                 = -1;       /// @is {surface}

layers = []; /// @is {obj_obstacles_renderer_layer[]}

layer_vertical_padding = CSIZE * 0.65; /// @is {number}