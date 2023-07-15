event_inherited();


bg_color = $111111;                     /// @is {int}
inactive_border_color = $000000;        /// @is {int}
active_border_color = $DDDDDD;          /// @is {int}
window_bbox = new __window_Rect(0, 0, 0, 0);    /// @is {__window_Rect}
content_bbox = new __window_Rect(0, 0, 0, 0);   /// @is {__window_Rect}
dragging_something = false;             /// @is {bool}
dragged_thing = -1;                     /// @is {GUI_WINDOW_DRAGGABLE|number}
mx_offset = 0;                          /// @is {number}
my_offset = 0;                          /// @is {number}
content_surface = -1;                   /// @is {surface}
active = false;                         /// @is {bool}
hovered = false;                        /// @is {bool}
content_offset_x = 0;                   /// @is {number}
content_offset_y = 0;                   /// @is {number}
content_drawer = /*#cast*/ undefined;        /// @is {function<void>}

function initialize(x1/*: number*/, y1/*: number*/, x2/*: number*/, y2/*: number*/, _content_drawer/*: (function<void>)*/)
{
    window_bbox.x1 = x1;
    window_bbox.y1 = y1;
    window_bbox.x2 = x2;
    window_bbox.y2 = y2;
    content_bbox.copy_from(window_bbox);
    content_drawer = _content_drawer;
}

// These properties will be saved and loaded if the window is serialized and deserialized.
// By default this contains no properties but you can add custom properties as you wish
// as long as it's trivially serializable (json) data.
serialized_properties = {};  /// @is {struct}

/// Event parameters:
/// {__obj_gdt_window} window
/// {bool} active
active_changed_event = new __window_Event();    /// @is {__window_Event}
/// Event parameters:
/// {__obj_gdt_window} window
closed_event = new __window_Event();            /// @is {__window_Event}
/// Event parameters:
/// {__obj_gdt_window} window
cleanup_event = new __window_Event();           /// @is {__window_Event}
/// Event parameters:
/// {__obj_gdt_window} window
content_resize_event = new __window_Event();    /// @is {__window_Event}

function set_active(_active/*: bool*/)
{
    var prevActive = active;
    active = _active;
    if (active != prevActive) {
        active_changed_event.invoke(id, active);
    }
}

function _draw(alpha/*: number*/)
{
    var c1 = bg_color;
    var c2 = active ? active_border_color : inactive_border_color;
    
    var prev_alpha = draw_get_alpha();
    draw_set_alpha(alpha);
    draw_rectangle_color(window_bbox.x1, window_bbox.y1, window_bbox.x2, window_bbox.y2, c1, c1, c1, c1, false);
    draw_rectangle_color(window_bbox.x1, window_bbox.y1, window_bbox.x2, window_bbox.y2, c2, c2, c2, c2, true);
    draw_set_alpha(prev_alpha);
    
    draw_surface_ext(content_surface, content_bbox.x1, content_bbox.y1, 1, 1, 0, c_white, 1);
}

__get_window_manager()._add_window(id);