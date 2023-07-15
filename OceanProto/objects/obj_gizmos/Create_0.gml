event_inherited();

default_alpha = 1;          /// @is {number}
default_color = c_white;    /// @is {int}
default_halign = fa_left;   /// @is {horizontal_alignment}
default_valign = fa_top;    /// @is {vertical_alignment}
default_font = -1;          /// @is {font}

_drawers_per_layer = ds_map_create();   /// @is {ds_map<layer, __obj_gdt_gizmos_drawer>}
_target_drawer = noone;                 /// @is {__obj_gdt_gizmos_drawer}