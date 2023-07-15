event_inherited();

menu        = /*#cast*/ undefined;   /// @is {Menu}
menu_width  = /*#cast*/ undefined;   /// @is {number}
menu_height = undefined;        /// @is {number?}

menu_mouse_x = 0;       /// @is {number}
menu_mouse_y = 0;       /// @is {number}
menu_x1 = 0;            /// @is {number}
menu_y1 = 0;            /// @is {number}
menu_x2 = 0;            /// @is {number}
menu_y2 = 0;            /// @is {number}

halign = fa_center;	/// @is {horizontal_alignment}
valign = fa_middle;	/// @is {vertical_alignment}

padding = 10;   /// @is {number}

closing = false;                /// @is {bool}
animated_relative_height = 0.0; /// @is {number}

initialize = function(menu_definition/*: MenuDefinition*/, width/*: number*/, height/*: number?*/)
{
    menu = menu_definition.create_instance();
    menu_width = ceil(width);
    menu_height = height;
    
    sfx_ui_play(snd_popup_menu_open);
}