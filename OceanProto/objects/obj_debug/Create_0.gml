event_inherited();

global.scream_log_errors = true;

if (os_browser == browser_not_a_browser) {
    if (asset_get_index("obj_gmlive") != -1) {
        instance_create_depth(0, 0, 0, obj_gmlive);
    }
}

gizmos  = instance_create_depth(0, 0, 0, obj_gizmos);       /// @is {obj_gizmos}
dud     = instance_create_depth(0, 0, 0, __obj_gdt_dud);    /// @is {__obj_gdt_dud}

visualizer          = instance_create_depth(0, 0, 0, obj_debug_visualizer);         /// @is {obj_debug_visualizer}
debug_menu          = instance_create_depth(0, 0, 0, obj_debug_menu);               /// @is {obj_debug_menu}
time_control_menu   = instance_create_depth(0, 0, 0, obj_debug_time_control_menu);  /// @is {obj_debug_time_control_menu}
fps_meter           = instance_create_depth(0, 0, 0, obj_debug_fps_meter);          /// @is {obj_debug_fps_meter}

debugToolsVisible = true; /// @is {bool}