
function Menu(_menu_definition/*: MenuDefinition*/) constructor
{
    menu_definition = _menu_definition;   /// @is {MenuDefinition}
    
    header  = new _MenuSection(self, false, menu_definition.header_entries);  /// @is {_MenuSection}
    body    = new _MenuSection(self, true, menu_definition.body_entries);     /// @is {_MenuSection}
    footer  = new _MenuSection(self, false, menu_definition.footer_entries);  /// @is {_MenuSection}
    sections = [    /// @is {_MenuSection[]}
        header,
        body,
        footer,
    ];
    
    header_rect  = new Rect(0, 0, 0, 0);    /// @is {Rect}
    body_rect    = new Rect(0, 0, 0, 0);    /// @is {Rect}
    footer_rect  = new Rect(0, 0, 0, 0);    /// @is {Rect}
    
    opened_sub_menu = undefined;  /// @is {Menu}
    
    surface = -1;               /// @is {surface}
    
    static step = function(controller/*: MenuController*/, mouse_xx/*: number*/, mouse_yy/*: number*/, x1/*: number*/, y1/*: number*/, x2/*: number*/, y2/*: number*/) /*-> MENU_RETURN*/
    {
        // If a sub menu has been opened, update that instead.
        if (opened_sub_menu != undefined) {
            var subMenuReturnValue = opened_sub_menu.step(controller, mouse_xx, mouse_yy, x1, y1, x2, y2);
            switch (subMenuReturnValue) {
                case MENU_RETURN.void: {
                    // do nothing
                    break;
                }
                case MENU_RETURN.back: {
                    opened_sub_menu.free();
                    opened_sub_menu = undefined;
                    break;
                }
                case MENU_RETURN.close_menu: {
                    // Pass this return value forward to the parent menu.
                    return subMenuReturnValue;
                }
                case MENU_RETURN.open_sub_menu: {
                    // doesn't need to be handled here
                    break;
                }
                case MENU_RETURN.reload_menu: {
                    // Pass this return value forward to the parent menu.
                    return subMenuReturnValue;
                }
                case MENU_RETURN.controlling: {
                    // doesn't need to be handled here
                    break;
                }
            }
            return MENU_RETURN.void;
        }
        
        mouse_xx -= x1;
        mouse_yy -= y1;
        x2 -= x1;
        y2 -= y1;
        x1 = 0;
        y1 = 0;
        
        var width = x2 - x1;
        var header_height = header.get_content_height(width);
        var footer_height = footer.get_content_height(width);
        
        header_rect.set(x1, y1, x2, y1 + header_height);
        body_rect.set(x1, y1 + header_height, x2, y2 - footer_height);
        footer_rect.set(x1, y2 - footer_height, x2, y2);
        
        var header_ret_val = header.step(controller, mouse_xx, mouse_yy, header_rect.x1, header_rect.y1, header_rect.x2, header_rect.y2);
        var body_ret_val   = body.step(controller, mouse_xx, mouse_yy, body_rect.x1, body_rect.y1, body_rect.x2, body_rect.y2);
        var footer_ret_val = footer.step(controller, mouse_xx, mouse_yy, footer_rect.x1, footer_rect.y1, footer_rect.x2, footer_rect.y2);
        
        switch (body_ret_val) {
            case MENU_RETURN.void: {
                var can_press = controller.is_keyboard_enabled();
                if (can_press) {
                    menu_show_prompt(self, MENU_INPUT_VERB.back, MENU_TEXT.back);
                    if (controller.check_pressed(MENU_INPUT_VERB.back)) {
                        return MENU_RETURN.back;
                    }
                }
                break;
            }
            case MENU_RETURN.open_sub_menu: {
                open_sub_menu_at_active_body_entry();
                return MENU_RETURN.void;
            }
        }
        
        return body_ret_val;
    }
    
    static render = function(controller/*: MenuController*/, mouse_xx/*: number*/, mouse_yy/*: number*/, x1/*: number*/, y1/*: number*/, x2/*: number*/, y2/*: number*/)
    {
        // If a sub menu has been opened, render that instead.
        if (opened_sub_menu != undefined) {
            
            // Our surfaces can be freed for now, for the sake of optimization. If we didn't free them here,
            // we'd have whole useless (invisible) surfaces per every sub menu as we go deeper into them.
            surface = destroy_surface(surface);
            header.surface  = destroy_surface(header.surface);
            body.surface    = destroy_surface(body.surface);
            footer.surface  = destroy_surface(footer.surface);
            
            opened_sub_menu.render(controller, mouse_xx, mouse_yy, x1, y1, x2, y2);
            return;
        }
        
        var surf_width = ceil(x2 - x1);
        var surf_height = ceil(y2 - y1);
        if (surf_width <= 1 || surf_height <= 1) {
            return;
        }
        
        mouse_xx -= x1;
        mouse_yy -= y1;
        
        surface = __create_or_resize_surface_if_needed(surface, surf_width, surf_height);
        surface_set_target(surface);
        var prev_blendenable = gpu_get_blendenable();
        gpu_set_blendenable(false);
        draw_clear_alpha(c_black, 0);
        
        header.render(controller, mouse_xx, mouse_yy, header_rect.x1, header_rect.y1);
        body.render(controller, mouse_xx, mouse_yy, body_rect.x1, body_rect.y1);
        footer.render(controller, mouse_xx, mouse_yy, footer_rect.x1, footer_rect.y1);
        
        gpu_set_blendenable(prev_blendenable);
        surface_reset_target();
        
        draw_surface_ext(surface, x1, y1, 1, 1, 0, c_white, 1);
    }
    
    static get_total_content_height = function(width/*: number*/) /*-> number*/
    {
        var header_height = header.get_content_height(width);
        var body_height = body.get_content_height(width);
        var footer_height = footer.get_content_height(width);
        return header_height + body_height + footer_height;
    }
    
    static open_sub_menu_at_active_body_entry = function() /*-> bool*/
    {
        // TODO: This is a janky way of figuring out if the entry has a sub menu under it that could be opened.
        var active_body_entry = body.entries[body.active_entry_index];
        if (instanceof(active_body_entry.menu_entry_definition) == "_MenuEntryDefinitionSubMenu") {
            var med_sub_menu = /*#cast*/ active_body_entry.menu_entry_definition /*#as _MenuEntryDefinitionSubMenu*/;
            if (opened_sub_menu != undefined) {
                opened_sub_menu.free();
            }
            opened_sub_menu = med_sub_menu.menu.create_instance();
            return true;
        }
        return false;
    }
    
    /// Pushes the index of the active body entry into the given array
    /// and recursively calls this with the currently opened sub menu (if one is currently opened).
    static get_recursive_active_body_entry_indices = function(out_indices/*: int[]*/)
    {
        array_push(out_indices, body.active_entry_index);
        if (opened_sub_menu != undefined) {
            opened_sub_menu.get_recursive_active_body_entry_indices(out_indices);
        }
    }
    
    static free = function()
    {
        menu_definition.free_event.invoke();
        if (opened_sub_menu != undefined) {
            opened_sub_menu.free();
            opened_sub_menu = undefined;
        }
        surface = destroy_surface(surface);
        for (var i = 0, len = array_length(sections); i < len; ++i) {
            sections[i].free();
        }
    }
}

function _MenuSection(_menu/*: Menu*/, _interactive/*: bool*/, _entry_definitions/*: MenuEntryDefinition[]*/) constructor
{
    menu = _menu;               /// @is {Menu}
    interactive = _interactive; /// @is {bool}
    
    active_entry_index = -1;      /// @is {int}
    entries = [];               /// @is {MenuEntry[]}
    surface = -1;               /// @is {surface}
    surface_width = 0;           /// @is {number}
    surface_height = 0;          /// @is {number}
    
    entry_rects = [];            /// @is {Rect[]}
    
    // The offset at which the contents are rendered.
    // Used for scrolling through the content.
    draw_offset_x = 0;            /// @is {number}
    draw_offset_y = 0;            /// @is {number}
    animated_draw_offset_x = 0;    /// @is {number}
    animated_draw_offset_y = 0;    /// @is {number}
    
    scroll_bar_visible = false;   /// @is {bool}
    scroll_bar_x1 = 0;            /// @is {number}
    scroll_bar_y1 = 0;            /// @is {number}
    scroll_bar_x2 = 0;            /// @is {number}
    scroll_bar_y2 = 0;            /// @is {number}
    
    mouse_previous_x = 0;         /// @is {number}
    mouse_previous_y = 0;         /// @is {number}
    
    last_active_entry_return_value = MENU_RETURN.void;  /// @is {MENU_RETURN}
    
    var num_entries = array_length(_entry_definitions);
    array_resize(entries, num_entries);
    array_resize(entry_rects, num_entries);
    for (var i = 0; i < num_entries; ++i) {
        var entry_def = _entry_definitions[i];
        var entry = entry_def.create_instance(menu);
        entries[i] = entry;
        entry_rects[i] = new Rect(0, 0, 0, 0);
    }
    
    static get_content_height = function(width/*: number*/) /*-> number*/
    {
        var total_height = 0;
        for (var i = 0, len = array_length(entries); i < len; ++i) {
            total_height += entries[i].get_height(width);
        }
        return total_height;
    }
    
    static set_active_entry = function(entry_index/*: int*/) /*-> bool*/
    {
        if (entry_index < 0 || entry_index >= array_length(entries)) {
            return false;
        }
        active_entry_index = entry_index;
        return true;
    }
    
    static step = function(controller/*: MenuController*/, mouse_xx/*: number*/, mouse_yy/*: number*/, x1/*: number*/, y1/*: number*/, x2/*: number*/, y2/*: number*/) /*-> MENU_RETURN*/
    {
        mouse_xx -= x1;
        mouse_yy -= y1;
        
        x1 = round(x1);
        y1 = round(y1);
        x2 = round(x2);
        y2 = round(y2);
        
        if (interactive) {
            var num_entries = array_length(entries);
            if (active_entry_index < 0 || active_entry_index >= num_entries) {
                // Set the first interactable entry that we can find as the active one.
                for (var i = 0; i < num_entries; ++i) {
                    if (entries[i].menu_entry_definition.is_interactable_type()) {
                        active_entry_index = i;
                        break;
                    }
                }
            }
        }
        
        last_active_entry_return_value = MENU_RETURN.void;
        
        surface_width    = round(x2 - x1);
        var content_height = get_content_height(surface_width);
        surface_height = round(y2 - y1);
        
        scroll_bar_visible = (content_height > surface_height);
        
        // Update the scroll bar.
        if (scroll_bar_visible) {
            scroll_bar_x1 = round(x2 - 12);
            scroll_bar_y1 = round(y1);
            scroll_bar_x2 = round(x2);
            scroll_bar_y2 = round(scroll_bar_y1 + surface_height * (surface_height / content_height));
            var bar_add_y = -animated_draw_offset_y * (surface_height / content_height);
            bar_add_y = clamp(bar_add_y, 0, surface_height - (scroll_bar_y2 - scroll_bar_y1) - 2);
            scroll_bar_y1 += round(bar_add_y);
            scroll_bar_y2 += round(bar_add_y);
        }
        
        // Clamp the offsets so that you can't overscroll.
        draw_offset_x = __menu_clamp_lerp(draw_offset_x, 0, surface_width, 0.5);
        draw_offset_y = __menu_clamp_lerp(draw_offset_y, -max(0, content_height - surface_height), 0, 0.5);
        
        // Animate the offset smoothly. This animated value is what is actually used when drawing.
        animated_draw_offset_x += (draw_offset_x - animated_draw_offset_x) * 0.5;
        animated_draw_offset_y += (draw_offset_y - animated_draw_offset_y) * 0.5;
        
        // Update entry bboxes.
        var entry_width = round(surface_width - (scroll_bar_x2 - scroll_bar_x1) - 10);
        var entry_y = 0;
        for (var i = 0, len = array_length(entries); i < len; ++i) {
            var entry = entries[i];
            var h = floor(entry.get_height(entry_width));
            entry_rects[i].set(5, entry_y, entry_width - 5, entry_y + h);
            entry_y += h;
        }
        
        // Update entries.
        var num_entries = array_length(entries);
        for (var i = 0; i < num_entries; ++i) {
            var entry = entries[i];
            var bbox = entry_rects[i];
            var ex1 = floor(animated_draw_offset_x + bbox.x1);
            var ex2 = floor(ex1 + bbox.get_width());
            var ey = floor(animated_draw_offset_y + bbox.y1);
            if (i == active_entry_index) {
                last_active_entry_return_value = entry.step(controller, mouse_xx, mouse_yy, interactive, ex1, ey, ex2);
            }
            else {
                entry.step(controller, mouse_xx, mouse_yy, false, ex1, ey, ex2);
            }
        }
        
        if (last_active_entry_return_value != MENU_RETURN.void) {
            return last_active_entry_return_value;
        }
        
        if (interactive) {
            
            var keyboard_enabled = controller.is_keyboard_enabled();
            var mouse_enabled = controller.is_mouse_enabled();
            
            // Scroll with the mouse wheel.
            if (content_height > surface_height && mouse_enabled) {
                if (mouse_wheel_down()) {
                    draw_offset_y -= 50;
                }
                if (mouse_wheel_up()) {
                    draw_offset_y += 50;
                }
            }
            
            // Navigate between entries with the mouse.
            var mouse_is_in_visible_area = point_in_rectangle(mouse_xx, mouse_yy, 0, 0, surface_width, surface_height);
            if (mouse_enabled && mouse_is_in_visible_area) {
                var mouse_has_moved = (mouse_xx != mouse_previous_x || mouse_yy != mouse_previous_y);
                if (mouse_has_moved) {
                    for (var i = 0, len = array_length(entry_rects); i < len; ++i) {
                        if (!entries[i].menu_entry_definition.is_interactable_type()) {
                            continue;
                        }
                        var rect = entry_rects[i];
                        if (point_in_rectangle(mouse_xx - animated_draw_offset_x, mouse_yy - animated_draw_offset_y, rect.x1, rect.y1, rect.x2, rect.y2)) {
                            active_entry_index = i;
                            break;
                        }
                    }
                }
                else if (active_entry_index >= 0 && active_entry_index < num_entries) {
                    var rect = entry_rects[active_entry_index];
                    if (!point_in_rectangle(mouse_xx - animated_draw_offset_x, mouse_yy - animated_draw_offset_y, rect.x1, rect.y1, rect.x2, rect.y2)) {
                        active_entry_index = -1;
                    }
                }
            }
            else if (!keyboard_enabled) {
                active_entry_index = -1;
            }
                
            mouse_previous_x = mouse_xx;
            mouse_previous_y = mouse_yy;
            
            if (keyboard_enabled) {
                // Navigate between entries with keys.
                var navigatedWithKey = false;
                if (controller.check_pressed(MENU_INPUT_VERB.down) || controller.check_repeated(MENU_INPUT_VERB.down)) {
                    var hoveredEntryIndex = active_entry_index;
                    for (var i = hoveredEntryIndex + 1; i < num_entries; ++i) {
                        var entry = entries[i];
                        if (entry.menu_entry_definition.is_interactable_type()) {
                            set_active_entry(i);
                            navigatedWithKey = true;
                            break;
                        }
                    }
                }
                if (controller.check_pressed(MENU_INPUT_VERB.up) || controller.check_repeated(MENU_INPUT_VERB.up)) {
                    var hoveredEntryIndex = active_entry_index;
                    for (var i = hoveredEntryIndex - 1; i >= 0; --i) {
                        var entry = entries[i];
                        if (entry.menu_entry_definition.is_interactable_type()) {
                            set_active_entry(i);
                            navigatedWithKey = true;
                            break;
                        }
                    }
                }
                // Scroll the active entry into view when navigating with keys.
                if (navigatedWithKey) {
                    var padding = 20;
                    var bbox = entry_rects[active_entry_index];
                    var min_value = min(0, -bbox.y1 + padding);
                    var max_value = max(-(content_height - surface_height), -(bbox.y2 - surface_height) - padding);
                    draw_offset_y = clamp(draw_offset_y, min_value, max_value);
                }
            }
        }
        
        return MENU_RETURN.void;
    }
    
    static render = function(controller/*: MenuController*/, mouse_xx/*: number*/, mouse_yy/*: number*/, xx/*: number*/, yy/*: number*/)
    {
        if (surface_width <= 1 || surface_height <= 1) {
            return;
        }
        
        mouse_xx -= xx;
        mouse_yy -= yy;
        
        // render the content into a surface with scrolling offsets taken into account.
        surface = __create_or_resize_surface_if_needed(surface, surface_width, surface_height);
        var prev_target_surface = surface_get_target();
        if (prev_target_surface >= 0 && prev_target_surface != application_surface) {
            surface_reset_target();
        }
        surface_set_target(surface);
        var prev_blendenable = gpu_get_blendenable();
        gpu_set_blendenable(true);
        draw_clear_alpha(c_black, 0);
        var visible_x1 = -animated_draw_offset_x;
        var visible_y1 = -animated_draw_offset_y - 5;
        var visible_x2 = -animated_draw_offset_x + surface_width;
        var visible_y2 = -animated_draw_offset_y + surface_height + 5;
        // First render all but the active entry.
        for (var i = 0, len = array_length(entries); i < len; ++i) {
            if (i == active_entry_index) {
                continue;
            }
            var bbox = entry_rects[i];
            if (rectangle_in_rectangle(bbox.x1, bbox.y1, bbox.x2, bbox.y2, visible_x1, visible_y1, visible_x2, visible_y2) == 0) {
                // If the entry is not currently in view, don't bother rendering it.
                continue;
            }
            _render_entry(i, controller, mouse_xx, mouse_yy);
        }
        // Finally render the active entry on top (even if it isn't in view!)
        if (active_entry_index >= 0 && active_entry_index < array_length(entries)) {
            _render_entry(active_entry_index, controller, mouse_xx, mouse_yy);
        }
        gpu_set_blendenable(prev_blendenable);
        surface_reset_target();
        if (prev_target_surface >= 0 && prev_target_surface != application_surface) {
            surface_set_target(prev_target_surface);
        }
        
        // Draw the surface.
        draw_surface_ext(surface, xx, yy, 1, 1, 0, c_white, 1);
        
        if (scroll_bar_visible) {
            // Draw the scroll bar.
            var style = CommonMenuStyle; // TODO
            draw_roundrect_color_ext(scroll_bar_x1 + 1, scroll_bar_y1 + 1, scroll_bar_x2 - 2, scroll_bar_y2 - 1, 4, 4, style.colorDullLightBrown, style.colorDullLightBrown, false);
        }
    }
    
    static _render_entry = function(i/*: int*/, controller/*: MenuController*/, mouse_xx/*: number*/, mouse_yy/*: number*/)
    {
        var entry = entries[i];
        var bbox = entry_rects[i];
        var entry_has_controls = (i == active_entry_index) && (last_active_entry_return_value != MENU_RETURN.controlling);
        var ex1 = floor(animated_draw_offset_x + bbox.x1);
        var ex2 = floor(ex1 + bbox.get_width());
        var ey = floor(animated_draw_offset_y + bbox.y1);
        entry.render(controller, mouse_xx, mouse_yy, entry_has_controls, ex1, ey, ex2);
    }
    
    static free = function()
    {
        for (var i = 0, len = array_length(entries); i < len; ++i) {
            entries[i].free();
        }
        array_resize(entries, 0);
        active_entry_index = -1;
        
        surface = destroy_surface(surface);
    }
}

function __create_or_resize_surface_if_needed(surface/*: surface*/, width/*: number*/, height/*: number*/)
{
    if (!surface_exists(surface)) {
        surface = surface_create(width, height);
    }
    else if (surface_get_width(surface) != width || surface_get_height(surface) != height) {
        surface_resize(surface, width, height);
    }
    return surface;
}
