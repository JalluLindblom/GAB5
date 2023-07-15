event_inherited();

menu = /*#cast*/ undefined;          /// @is {Menu}
done_callback = /*#cast*/ undefined; /// @is {function<PersonalityTraits, void>}
traits = /*#cast*/ undefined;        /// @is {PersonalityTraits}

done_callback_called = false;	/// @is {bool}

menu_mouse_x = 0;       /// @is {number}
menu_mouse_y = 0;       /// @is {number}
menu_x1 = 0;            /// @is {number}
menu_y1 = 0;            /// @is {number}
menu_x2 = 0;            /// @is {number}
menu_y2 = 0;            /// @is {number}

animated_relative_offset_x = 1; /// @is {number}

initialized = false;    /// @is {bool}

padding = 10;       /// @is {number}
closing = false;    /// @is {bool}

info_x1 = 0;          /// @is {number}
info_y1 = 0;          /// @is {number}
info_x2 = 0;          /// @is {number}
info_y2 = 0;          /// @is {number}
info_hovered = false; /// @is {bool}

info_menu = noone;	/// @is {obj_popup_menu}

// When all settings have been set, the menu will be "frozen", i.e. the menu won't
// update or render anymore, but instead a frozen image of its last state is drawn.
// This is implemented purely for optimization purposes.
frozen			= false;	/// @is {bool}
frozen_sprite	= -1;		/// @is {sprite}

initialize = function(_traits/*: PersonalityTraits*/, _header_text/*: string*/, _done_callback/*: (function<PersonalityTraits, void>)*/)
{
    traits = _traits;
    done_callback = _done_callback;
    
    var callback = method({ id: id }, function() {
        if (!Configs.leave_traits_menu_open_when_playing && !id.closing) {
            id.closing = true;
        }
		if (!id.done_callback_called) {
			done_callback_called = true;
			id.done_callback(id.traits);
		}
		id.frozen = true;
    });
    menu = make_personality_traits_menu(traits, _header_text, callback).create_instance();
    
    initialized = true;
    
    sfx_ui_play(snd_trait_menu_open);
}