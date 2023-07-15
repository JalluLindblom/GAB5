
function _MenuEntryDefinitionFunction(
    _label/*: string*/,
    _callback/*: (function<MENU_RETURN>)*/,
    _check_enabled/*: (function<bool>)?*/ = undefined
) : MenuEntryDefinition(_check_enabled) constructor
{
    label = _label;         /// @is {string}
    callback = _callback;   /// @is {function<MENU_RETURN>}
    
    label_scribble = scribble(label) /// @is {__scribble_class_element}
    	.starting_format(style.font_name, c_white)
        .align(fa_center, fa_top);
    label_scribble_height = label_scribble.get_height(); /// @is {number}
    
    // override
    static _is_interactable_type_virtual = function() /*-> bool*/
    {
        return true;
    }
    
    // override
    static _initialize_virtual = function(entry/*: MenuEntry*/)
    {
    }
    
    // override
    static _step_virtual = function(entry/*: MenuEntry*/, controller/*: MenuController*/, mouse_xx/*: number*/, mouse_yy/*: number*/, has_controls/*: bool*/, x1/*: number*/, yy/*: number*/, x2/*: number*/) /*-> MENU_RETURN*/
    {
        if (has_controls && is_enabled()) {
            var can_click = controller.is_mouse_enabled() && point_in_rectangle(mouse_xx, mouse_yy, x1, yy, x2, yy + _get_height_virtual(entry, x2 - x1));
            if (can_click) {
                controller.set_cursor(MENU_CURSOR.pointy);
            }
            var can_press = controller.is_keyboard_enabled();
            if ((can_press && controller.check_pressed(MENU_INPUT_VERB.select)) || (can_click && mouse_check_button_pressed(mb_left))) {
                return callback();
            }
        }
        return MENU_RETURN.void;
    }
    
    // override
    static _render_virtual = function(entry/*: MenuEntry*/, controller/*: MenuController*/, mouse_xx/*: number*/, mouse_yy/*: number*/, has_controls/*: bool*/, x1/*: number*/, yy/*: number*/, x2/*: number*/)
    {
        var color = has_controls ? COLOR.gray : COLOR.black;
        if (!is_enabled()) {
        	color = #a0a0a0;
        }
        label_scribble
        	.blend(color, 1)
            .draw(round(mean(x1, x2)), yy);
    }
    
    // override
    static _get_height_virtual = function(entry/*: MenuEntry*/, width/*: number*/) /*-> number*/
    {
        return label_scribble_height - 2;
    }
    
    // override
    static _cleanup_virtual = function(entry/*: MenuEntry*/)
    {
    }
}

function _MenuEntryDefinitionSubMenu(
    _label/*: string*/,
    _menu/*: MenuDefinition*/,
    _check_enabled/*: (function<bool>)?*/ = undefined
) : MenuEntryDefinition(_check_enabled) constructor
{
    label = _label; /// @is {string}
    menu = _menu;   /// @is {MenuDefinition}
    
    label_scribble = scribble(label + " ->") /// @is {__scribble_class_element}
        .starting_format(style.font_name, c_white)
        .align(fa_center, fa_top);
    label_scribble_height = label_scribble.get_height(); /// @is {number}
    
    // override
    static _is_interactable_type_virtual = function() /*-> bool*/
    {
        return true;
    }
    
    // override
    static _initialize_virtual = function(entry/*: MenuEntry*/)
    {
    }
    
    // override
    static _step_virtual = function(entry/*: MenuEntry*/, controller/*: MenuController*/, mouse_xx/*: number*/, mouse_yy/*: number*/, has_controls/*: bool*/, x1/*: number*/, yy/*: number*/, x2/*: number*/) /*-> MENU_RETURN*/
    {
        if (has_controls) {
            menu_show_prompt(entry, MENU_INPUT_VERB.select, MENU_TEXT.select);
            if (is_enabled()) {
                var can_click = controller.is_mouse_enabled() && point_in_rectangle(mouse_xx, mouse_yy, x1, yy, x2, yy + _get_height_virtual(entry, x2 - x1));
                if (can_click) {
                    controller.set_cursor(MENU_CURSOR.pointy);
                }
                var can_press = controller.is_keyboard_enabled();
                if ((can_press && controller.check_pressed(MENU_INPUT_VERB.select)) || (can_click && mouse_check_button_pressed(mb_left))) {
                    return MENU_RETURN.open_sub_menu;
                }
            }
        }
        return MENU_RETURN.void;
    }
    
    // override
    static _render_virtual = function(entry/*: MenuEntry*/, controller/*: MenuController*/, mouse_xx/*: number*/, mouse_yy/*: number*/, has_controls/*: bool*/, x1/*: number*/, yy/*: number*/, x2/*: number*/)
    {
        var color = has_controls ? COLOR.gray : COLOR.black;
        if (!is_enabled()) {
        	color = #a0a0a0;
        }
        label_scribble
        	.blend(color, 1)
            .draw(round(mean(x1, x2)), yy);
    }
    
    // override
    static _get_height_virtual = function(entry/*: MenuEntry*/, width/*: number*/) /*-> number*/
    {
        return label_scribble_height - 2;
    }
    
    // override
    static _cleanup_virtual = function(entry/*: MenuEntry*/)
    {
    }
}

function _MenuEntryDefinitionText(
    _labelOrLabels/*: string|string[]*/,
    _is_heading/*: bool*/,
    _is_sub_heading/*: bool*/,
    _check_enabled/*: (function<bool>)?*/ = undefined
) : MenuEntryDefinition(_check_enabled) constructor
{
    labels = is_array(_labelOrLabels) ? array_copied(_labelOrLabels) : [ _labelOrLabels ];   /// @is {string[]}
    
    // These two are exclusive. Heading wins subheading.
    is_heading = _is_heading;         /// @is {bool}
    is_sub_heading = _is_sub_heading;   /// @is {bool}
    
    label_scribbles = []; /// @is {__scribble_class_element[]}
    
    max_label_scribble_height = 0; /// @is {number}
    
    previous_width = 0; /// @is {number}
    
    // override
    static _is_interactable_type_virtual = function() /*-> bool*/
    {
        return false;
    }
    
    // override
    static _initialize_virtual = function(entry/*: MenuEntry*/)
    {
    }
    
    // override
    static _step_virtual = function(entry/*: MenuEntry*/, controller/*: MenuController*/, mouse_xx/*: number*/, mouse_yy/*: number*/, has_controls/*: bool*/, x1/*: number*/, yy/*: number*/, x2/*: number*/) /*-> MENU_RETURN*/
    {
        return MENU_RETURN.void;
    }
    
    // override
    static _render_virtual = function(entry/*: MenuEntry*/, controller/*: MenuController*/, mouse_xx/*: number*/, mouse_yy/*: number*/, has_controls/*: bool*/, x1/*: number*/, yy/*: number*/, x2/*: number*/)
    {
    	var width = x2 - x1;
    	
    	if (array_length(label_scribbles) != array_length(labels) || width != previous_width) {
    		array_resize(label_scribbles, array_length(labels));
    		max_label_scribble_height = 0;
    		for (var i = 0, len = array_length(labels); i < len; ++i) {
		        var label = labels[i];
		        if (is_heading) {
		            label = "[pin_center]" + label + "[/]";
		        }
		        var text_color = style.label_color;
		        if (is_heading) {
		            text_color = style.heading_text_color;
		        }
		        else if (is_sub_heading) {
		            text_color = style.sub_heading_text_color;
		        }
		        label_scribbles[i] = scribble(label)
	                .wrap(width)
	                .starting_format(style.font_name, text_color)
	                .align(fa_left, fa_top);
				var height = label_scribbles[i].get_height();
				max_label_scribble_height = max(max_label_scribble_height, height);
		    }
    	}
    	
        for (var i = 0, len = array_length(label_scribbles); i < len; ++i) {
            var label_scribble = label_scribbles[i];
            label_scribble.draw(x1, yy);
        }
        
        previous_width = width;
    }
    
    // override
    static _get_height_virtual = function(entry/*: MenuEntry*/, width/*: number*/) /*-> number*/
    {
		return max_label_scribble_height;
    }
    
    // override
    static _cleanup_virtual = function(entry/*: MenuEntry*/)
    {
    }
}

function _MenuEntryDefinitionSpacer(
    _height/*: number*/,
    _check_enabled/*: (function<bool>)?*/ = undefined
) : MenuEntryDefinition(_check_enabled) constructor
{
    height = _height;           /// @is {number}
    var char_height = scribble("M").starting_format(style.font_name, 0).get_height();
    total_height = (char_height - 2) * height; /// @is {number}
    
    // override
    static _is_interactable_type_virtual = function() /*-> bool*/
    {
        return false;
    }
    
    // override
    static _initialize_virtual = function(entry/*: MenuEntry*/)
    {
    }
    
    // override
    static _step_virtual = function(entry/*: MenuEntry*/, controller/*: MenuController*/, mouse_xx/*: number*/, mouse_yy/*: number*/, has_controls/*: bool*/, x1/*: number*/, yy/*: number*/, x2/*: number*/) /*-> MENU_RETURN*/
    {
        return MENU_RETURN.void;
    }
    
    // override
    static _render_virtual = function(entry/*: MenuEntry*/, controller/*: MenuController*/, mouse_xx/*: number*/, mouse_yy/*: number*/, has_controls/*: bool*/, x1/*: number*/, yy/*: number*/, x2/*: number*/)
    {
    }
    
    // override
    static _get_height_virtual = function(entry/*: MenuEntry*/, width/*: number*/) /*-> number*/
    {
        return total_height;
    }
    
    // override
    static _cleanup_virtual = function(entry/*: MenuEntry*/)
    {
    }
}

function _MenuEntryDefinitionBoolean(
    _label/*: string*/,
    _getter/*: (function<bool>)*/,
    _setter/*: (function<bool, MENU_RETURN>)*/,
    _formatter/*: (function<bool, string>)*/,
    _check_enabled/*: (function<bool>)?*/ = undefined
) : MenuEntryDefinition(_check_enabled) constructor
{
    label = _label;         /// @is {string}
    getter = _getter;       /// @is {function<bool>}
    setter = _setter;       /// @is {function<bool, MENU_RETURN>}
    formatter = _formatter; /// @is {function<bool, string>}
    
    label_scribble = scribble(label, "_MenuEntryDefinitionBoolean__label__" + label) /// @is {__scribble_class_element}
	    .starting_format(style.font_name, c_white)
	    .align(fa_left, fa_top);
	label_scribble_height = label_scribble.get_height(); /// @is {number}
	value_scribble	= undefined;	/// @is {__scribble_class_element?}
	value			= undefined;	/// @is {bool?}
    
    // override
    static _is_interactable_type_virtual = function() /*-> bool*/
    {
        return true;
    }
    
    // override
    static _initialize_virtual = function(entry/*: MenuEntry*/)
    {
    }
    
    // override
    static _step_virtual = function(entry/*: MenuEntry*/, controller/*: MenuController*/, mouse_xx/*: number*/, mouse_yy/*: number*/, has_controls/*: bool*/, x1/*: number*/, yy/*: number*/, x2/*: number*/) /*-> MENU_RETURN*/
    {
        if (has_controls) {
            menu_show_prompt(entry, MENU_INPUT_VERB.select, MENU_TEXT.toggle);
            if (is_enabled()) {
                var can_click = controller.is_mouse_enabled() && point_in_rectangle(mouse_xx, mouse_yy, x1, yy, x2, yy + _get_height_virtual(entry, x2 - x1));
                if (can_click) {
                    controller.set_cursor(MENU_CURSOR.pointy);
                }
                var can_press = controller.is_keyboard_enabled();
                if ((can_press && controller.check_pressed(MENU_INPUT_VERB.select)) || (can_click && mouse_check_button_pressed(mb_left))) {
                    return setter(!getter());
                }
            }
        }
        
        return MENU_RETURN.void;
    }
    
    // override
    static _render_virtual = function(entry/*: MenuEntry*/, controller/*: MenuController*/, mouse_xx/*: number*/, mouse_yy/*: number*/, has_controls/*: bool*/, x1/*: number*/, yy/*: number*/, x2/*: number*/)
    {
    	var prev_value = value;
        value = getter();
        if (value != prev_value) {
        	value_scribble = scribble(formatter(value), "_MenuEntryDefinitionBoolean__value__" + label)
	            .starting_format(style.font_name, c_white)
	            .align(fa_right, fa_top);
        }
        
		label_scribble
			.blend(has_controls ? COLOR.gray : COLOR.black, 1)
			.draw(x1, yy);
        if (value_scribble != undefined) {
        	value_scribble
        		.blend(has_controls ? COLOR.gray : COLOR.black, 1)
        		.draw(x2, yy);
        }
    }
    
    // override
    static _get_height_virtual = function(entry/*: MenuEntry*/, width/*: number*/) /*-> number*/
    {
        return label_scribble_height - 2;
    }
    
    // override
    static _cleanup_virtual = function(entry/*: MenuEntry*/)
    {
    }
}

function _MenuEntryDefinitionFloat(
    _label/*: string*/,
    _min_value/*: number*/,
    _max_value/*: number*/,
    _increment/*: number*/,
    _getter/*: (function<number>)*/,
    _setter/*: (function<number, MENU_RETURN>)*/,
    _formatter/*: (function<number, string>)*/,
    _check_enabled/*: (function<bool>)?*/ = undefined
) : MenuEntryDefinition(_check_enabled) constructor
{
    label = _label;         /// @is {string}
    min_value = _min_value;   /// @is {number}
    max_value = _max_value;   /// @is {number}
    increment = _increment;           /// @is {number}
    getter = _getter;       /// @is {function<number>}
    setter = _setter;       /// @is {function<number, MENU_RETURN>}
    formatter = _formatter; /// @is {function<number, string>}
    
    label_scribble = scribble(label);    /// @is {__scribble_class_element}
    
    // override
    static _is_interactable_type_virtual = function() /*-> bool*/
    {
        return true;
    }
    
    // override
    static _initialize_virtual = function(entry/*: MenuEntry*/)
    {
    }
    
    // override
    static _step_virtual = function(entry/*: MenuEntry*/, controller/*: MenuController*/, mouse_xx/*: number*/, mouse_yy/*: number*/, has_controls/*: bool*/, x1/*: number*/, yy/*: number*/, x2/*: number*/) /*-> MENU_RETURN*/
    {
        var can_press = controller.is_keyboard_enabled();
        if (can_press && has_controls) {
            menu_show_prompt(entry, MENU_INPUT_VERB.left, "");
            menu_show_prompt(entry, MENU_INPUT_VERB.right, MENU_TEXT.adjust);
            if (is_enabled()) {
                if (controller.check_pressed(MENU_INPUT_VERB.right) || controller.check_repeated(MENU_INPUT_VERB.right)) {
                    return setter(min(getter() + increment, max_value));
                }
                else if (controller.check_pressed(MENU_INPUT_VERB.left) || controller.check_repeated(MENU_INPUT_VERB.left)) {
                    return setter(max(getter() - increment, min_value));
                }
            }
        }
        return MENU_RETURN.void;
    }
    
    // override
    static _render_virtual = function(entry/*: MenuEntry*/, controller/*: MenuController*/, mouse_xx/*: number*/, mouse_yy/*: number*/, has_controls/*: bool*/, x1/*: number*/, yy/*: number*/, x2/*: number*/)
    {
        var label_color = is_enabled() ? style.label_color : style.disabled_color;
        var value_color = is_enabled() ? style.value_color : style.disabled_color;
        
        label_scribble
            .starting_format(style.font_name, label_color)
            .align(fa_left, fa_top)
            .draw(x1, yy);
        
        var value_str = formatter(getter());
        scribble(value_str)
            .starting_format(style.font_name, value_color)
            .align(fa_right, fa_top)
            .draw(x2, yy);
    }
    
    // override
    static _get_height_virtual = function(entry/*: MenuEntry*/, width/*: number*/) /*-> number*/
    {
        return label_scribble.starting_format(style.font_name, 0).get_height() - 2;
    }
    
    // override
    static _cleanup_virtual = function(entry/*: MenuEntry*/)
    {
    }
}

function _MenuEntryDefinitionChoice(
    _label/*: string*/,
    _getter/*: (function<any>)*/,
    _setter/*: (function<any, MENU_RETURN>)*/,
    _choices/*: Array*/,
    _formatter/*: (function<any, int, string>)*/,
    _check_enabled/*: (function<bool>)?*/ = undefined
) : MenuEntryDefinition(_check_enabled) constructor
{
    label = _label;         /// @is {string}
    getter = _getter;       /// @is {function<any>}
    setter = _setter;       /// @is {function<any, MENU_RETURN>}
    choices = _choices;     /// @is {Array}
    formatter = _formatter; /// @is {function<any, int, string>}
    
    label_scribble = scribble(label);    /// @is {__scribble_class_element}
    
    dropdown_menu_is_open = false; /// @is {bool}
    
    dropdown_menu = undefined;   /// @is {Menu}
    dX1 = 0;                    /// @is {number}
    dY1 = 0;                    /// @is {number}
    dX2 = 0;                    /// @is {number}
    dY2 = 0;                    /// @is {number}
    
    // override
    static _is_interactable_type_virtual = function() /*-> bool*/
    {
        return true;
    }
    
    // override
    static _initialize_virtual = function(entry/*: MenuEntry*/)
    {
    }
    
    // override
    static _step_virtual = function(entry/*: MenuEntry*/, controller/*: MenuController*/, mouse_xx/*: number*/, mouse_yy/*: number*/, has_controls/*: bool*/, x1/*: number*/, yy/*: number*/, x2/*: number*/) /*-> MENU_RETURN*/
    {
        if (dropdown_menu != undefined) {
            var dd_width = 0;
            var choiceEntries = dropdown_menu.body.entries;
            for (var i = 0, len = array_length(choiceEntries); i < len; ++i) {
                var w = (/*#cast*/ choiceEntries[i].menu_entry_definition /*#as _MenuEntryDefinitionFunction*/).label_scribble.get_width();
                dd_width = max(dd_width, w);
            }
            dd_width += 10;
            var dd_height = dropdown_menu.get_total_content_height(dd_width);
            dX1 = floor(x2 - dd_width);
            dY1 = floor(yy);
            dX2 = ceil(x2);
            dY2 = ceil(yy + dd_height);
            
            var close = false;
            if (controller.is_mouse_enabled()) {
                if (!point_in_rectangle(mouse_xx, mouse_yy, dX1, dY1, dX2, dY2) && mouse_check_button_pressed(mb_left)) {
                    close = true;
                }
                if (mouse_check_button_pressed(mb_right)) {
                    close = true;
                }
            }
            if (close) {
                dropdown_menu.free();
                dropdown_menu = undefined;
            }
        }
        
        if (has_controls) {
            if (dropdown_menu != undefined) {
                var retVal = dropdown_menu.step(controller, mouse_xx, mouse_yy, dX1, dY1, dX2, dY2);
                switch (retVal) {
                    case MENU_RETURN.void: {
                        return MENU_RETURN.controlling;
                    }
                    case MENU_RETURN.back:
                    case MENU_RETURN.close_menu: {
                        dropdown_menu.free();
                        dropdown_menu = undefined;
                        return MENU_RETURN.controlling;
                    }
                    default: {
                        return retVal;
                    }
                }
            }
            else {
                if (is_enabled()) {
                    var can_click = controller.is_mouse_enabled() && point_in_rectangle(mouse_xx, mouse_yy, x1, yy, x2, yy + _get_height_virtual(entry, x2 - x1));
                    if (can_click) {
                        controller.set_cursor(MENU_CURSOR.pointy);
                    }
                    var can_press = controller.is_keyboard_enabled();
                    if (can_press) {
                        menu_show_prompt(entry, MENU_INPUT_VERB.select, MENU_TEXT.change);
                        if (controller.check_pressed(MENU_INPUT_VERB.select) || (can_click && mouse_check_button_pressed(mb_left))) {
                            dropdown_menu = _choice_menu_create_dropdown(self);
                        }
                    }
                }
            }
        }
        return MENU_RETURN.void;
    }
    
    // override
    static _render_virtual = function(entry/*: MenuEntry*/, controller/*: MenuController*/, mouse_xx/*: number*/, mouse_yy/*: number*/, has_controls/*: bool*/, x1/*: number*/, yy/*: number*/, x2/*: number*/)
    {
        var label_color = is_enabled() ? style.label_color : style.disabled_color;
        var value_color = is_enabled() ? style.value_color : style.disabled_color;
        
        label_scribble
            .starting_format(style.font_name, label_color)
            .align(fa_left, fa_top)
            .draw(x1, yy);
        
        if (dropdown_menu != undefined) {
            draw_rectangle_color(dX1, dY1, dX2, dY2, style.colorDullLightBrown, style.colorDullLightBrown, style.colorDullLightBrown, style.colorDullLightBrown, false);
            draw_rectangle_color(dX1 + 1, dY1 + 1, dX2 - 1, dY2 - 1, style.colorBlack, style.colorBlack, style.colorBlack, style.colorBlack, false);
            dropdown_menu.render(controller, mouse_xx, mouse_yy, dX1, dY1, dX2, dY2);
        }
        else {
            var choice_value = getter();
            var choice_index = array_first_index_of(choices, choice_value);
            var value_str = formatter(choice_value, choice_index);
            var value_scribble = scribble(value_str)
                .starting_format(style.font_name, value_color)
                .align(fa_right, fa_top)
                .padding(0, 0, 5, 0);
            var left = min(x2 - 85, value_scribble.get_left(x2) - 2);
            var top = value_scribble.get_top(yy) + 2;
            var right = x2;
            var bot = value_scribble.get_bottom(yy) - 2;
            draw_rectangle_color(left - 1, top - 1, right + 1, bot + 1, style.colorDullLightBrown, style.colorDullLightBrown, style.colorDullLightBrown, style.colorDullLightBrown, false);
            draw_rectangle_color(left, top, right, bot, style.colorBlack, style.colorBlack, style.colorBlack, style.colorBlack, false);
            value_scribble.draw(x2, yy);
        }
    }
    
    // override
    static _get_height_virtual = function(entry/*: MenuEntry*/, width/*: number*/) /*-> number*/
    {
        return label_scribble.starting_format(style.font_name, 0).get_height() - 2;
    }
    
    // override
    static _cleanup_virtual = function(entry/*: MenuEntry*/)
    {
        if (dropdown_menu != undefined) {
            dropdown_menu.free();
            dropdown_menu = undefined;
        }
    }
}

function _choice_menu_create_dropdown(entry_def/*: _MenuEntryDefinitionChoice*/) /*-> Menu*/
{
    var body_entries = /*#cast*/ [] /*#as MenuEntryDefinition[]*/;
    var num_choices = array_length(entry_def.choices);
    array_resize(body_entries, num_choices);
    for (var i = 0; i < num_choices; ++i) {
        var choice = entry_def.choices[i];
        var c = {
            choice: choice,
            entry_def: entry_def,
        };
        var label = "[pin_right]" + entry_def.formatter(choice) + "[/]";
        body_entries[i] = ME_function(label, method(c, function() {
            entry_def.dropdown_menu.free();
            entry_def.dropdown_menu = undefined;
            return entry_def.setter(choice);
        }));
    }
    
    var def = new MenuDefinition([], body_entries, []);
    var menu = def.create_instance() /*#as Menu*/;
    menu.body.set_active_entry(array_first_index_of(entry_def.choices, entry_def.getter()));
    return menu;
}

function _MenuEntryDefinitionSlider(
    _label/*: string*/,
    _min_value/*: number*/,
    _max_value/*: number*/,
    _increment/*: number*/,
    _getter/*: (function<number>)*/,
    _setter/*: (function<number, MENU_RETURN>)*/,
    _formatter/*: (function<number, string>)*/,
    _check_enabled/*: (function<bool>)?*/ = undefined
) : MenuEntryDefinition(_check_enabled) constructor
{
    label = _label;         /// @is {string}
    min_value = _min_value;   /// @is {number}
    max_value = _max_value;   /// @is {number}
    increment = _increment;           /// @is {number}
    getter = _getter;       /// @is {function<number>}
    setter = _setter;       /// @is {function<number, MENU_RETURN>}
    formatter = _formatter; /// @is {function<number, string>}
    
    slider_x1 = 0;                   /// @is {number}
    slider_x2 = 0;                   /// @is {number}
    slider_y = 0;                    /// @is {number}
    handle_x = 0;                    /// @is {number}
    handle_y = 0;                    /// @is {number}
    animated_handle_x = undefined;    /// @is {number}
    animated_handle_y = undefined;    /// @is {number}
    dragging_slider = false;         /// @is {bool}
    hovering_slider = false;         /// @is {bool}
    drag_offset_x = 0;                /// @is {number}
    
    label_scribble = scribble(label) /// @is {__scribble_class_element}
        .starting_format(style.font_name, c_white)
        .align(fa_left, fa_top);
    
    // override
    static _is_interactable_type_virtual = function() /*-> bool*/
    {
        return true;
    }
    
    // override
    static _initialize_virtual = function(entry/*: MenuEntry*/)
    {
    }
    
    // override
    static _step_virtual = function(entry/*: MenuEntry*/, controller/*: MenuController*/, mouse_xx/*: number*/, mouse_yy/*: number*/, has_controls/*: bool*/, x1/*: number*/, yy/*: number*/, x2/*: number*/) /*-> MENU_RETURN*/
    {
        var value = getter();
        
        if (!mouse_check_button(mb_left) || !has_controls || !controller.is_mouse_enabled()) {
            dragging_slider = false;
        }
        
        if (dragging_slider) {
            controller.set_cursor(MENU_CURSOR.draggy);
            var new_value = __menu_normalize_number(mouse_xx + drag_offset_x, slider_x1, slider_x2, min_value, max_value);
            new_value = clamp(new_value, min_value, max_value);
            setter(new_value);
        }
        
        var height = _get_height_virtual(entry, x2 - x1);
        var slider_width = 150;
        slider_x1 = floor(x2 - slider_width);
        slider_x2 = floor(slider_x1 + slider_width);
        slider_y = floor(yy + height / 2 + 1);
        handle_x = floor(slider_x1 + (slider_width - 1) * (value / (max_value - min_value)));
        handle_y = floor(slider_y - 1);
        
        if (animated_handle_x == undefined) animated_handle_x = handle_x;
        if (animated_handle_y == undefined) animated_handle_y = handle_y;
        animated_handle_x += (handle_x - animated_handle_x) * 0.6;
        animated_handle_y = handle_y;
        
        hovering_slider = false;
        
        if (dragging_slider) {
            return MENU_RETURN.controlling;
        }
        
        if (has_controls) {
            
            if (is_enabled()) {
                
                var mouse_enabled = controller.is_mouse_enabled();
                var keyboard_enabled = controller.is_keyboard_enabled();
                
                menu_show_prompt(entry, MENU_INPUT_VERB.left, "");
                menu_show_prompt(entry, MENU_INPUT_VERB.right, MENU_TEXT.adjust);
                
                if (mouse_enabled) {
                    if (point_in_rectangle(mouse_xx, mouse_yy, slider_x1 - 3, slider_y - 7, slider_x2 + 3, slider_y + 6)) {
                        hovering_slider = true;
                        controller.set_cursor(MENU_CURSOR.pointy);
                        if (mouse_check_button_pressed(mb_left)) {
                            dragging_slider = true;
                            drag_offset_x = 0;
                        }
                    }
                }
                
                if (keyboard_enabled && !dragging_slider) {
                    var add = 0;
                    if (controller.check_pressed(MENU_INPUT_VERB.right) || controller.check_repeated(MENU_INPUT_VERB.right)) {
                        add = increment;
                    }
                    else if (controller.check_pressed(MENU_INPUT_VERB.left) || controller.check_repeated(MENU_INPUT_VERB.left)) {
                        add = -increment;
                    }
                    if (add != 0) {
                        var new_value = clamp(value + add, min_value, max_value);
                        return setter(new_value);
                    }
                }
            }
        }
        return MENU_RETURN.void;
    }
    
    // override
    static _render_virtual = function(entry/*: MenuEntry*/, controller/*: MenuController*/, mouse_xx/*: number*/, mouse_yy/*: number*/, has_controls/*: bool*/, x1/*: number*/, yy/*: number*/, x2/*: number*/)
    {
    	var enabled = is_enabled();
        var label_color = enabled ? style.label_color : style.disabled_color;
        var value_color = enabled ? style.value_color : style.disabled_color;
        
        label_scribble
        	.blend(label_color, 1)
            .draw(x1, yy);
        
        draw_line_width_color(slider_x1, slider_y, slider_x2, slider_y, 2, style.colorDullLightBrown, style.colorDullLightBrown);
        draw_line_width_color(slider_x1, slider_y, animated_handle_x, slider_y, 4, value_color, value_color);
        
        var hh = (hovering_slider || dragging_slider) ? 10 : 8;
        var hw = dragging_slider ? 4 : 2;
        var hx1 = animated_handle_x;
        var hy1 = animated_handle_y - hh / 2;
        var hx2 = animated_handle_x;
        var hy2 = animated_handle_y + hh / 2 + 1;
        draw_line_width_color(hx1, hy1 - 1, hx2, hy2 + 1, hw + 2, style.colorBlack, style.colorBlack);
        draw_line_width_color(hx1, hy1, hx2, hy2, hw, value_color, value_color);
        
        var value_str = formatter(getter());
        scribble(value_str)
            .starting_format(style.font_name, value_color)
            .align(fa_right, fa_top)
            .draw(slider_x1 - 2, yy);
    }
    
    // override
    static _get_height_virtual = function(entry/*: MenuEntry*/, width/*: number*/) /*-> number*/
    {
        return label_scribble.starting_format(style.font_name, 0).get_height() - 2;
    }
    
    // override
    static _cleanup_virtual = function(entry/*: MenuEntry*/)
    {
    }
}

function _MenuEntryDefinitionDiscreteSlider(
    _label/*: string*/,
    _options/*: number[]*/,
    _getter/*: (function<number>)*/,
    _setter/*: (function<number, MENU_RETURN>)*/,
    _formatter/*: (function<number, string>)?*/,
    _check_has_keyboard_control/*: (function<_MenuEntryDefinitionDiscreteSlider, bool>)*/,
    _check_enabled/*: (function<bool>)?*/ = undefined
) : MenuEntryDefinition(_check_enabled) constructor
{
    label = _label;                         /// @is {string}
    options = array_sorted(_options, true); /// @is {number[]}
    getter = _getter;                       /// @is {function<number>}
    setter = _setter;                       /// @is {function<number, MENU_RETURN>}
    formatter = _formatter;                 /// @is {function<number, string>?}
    check_has_keyboard_control = _check_has_keyboard_control;   /// @is {function<_MenuEntryDefinitionDiscreteSlider, bool>}
    
    slider_x1 = 0;                      /// @is {number}
    slider_x2 = 0;                      /// @is {number}
    slider_y = 0;                       /// @is {number}
    handle_x = 0;                       /// @is {number}
    handle_y = 0;                       /// @is {number}
    animated_handle_x = /*#cast*/ undefined; /// @is {number}
    animated_handle_y = /*#cast*/ undefined; /// @is {number}
    animated_handle_x_previous = /*#cast*/ undefined;    /// @is {number}
    animated_handle_y_previous = /*#cast*/ undefined;    /// @is {number}
    dragging_slider = false;            /// @is {bool}
    hovering_slider = false;            /// @is {bool}
    drag_offset_x = 0;                  /// @is {number}
    animated_handle_scale = 0.0;        /// @is {number}
    animated_text_offset_x = 0.0;       /// @is {number}
    animated_text_offset_y = 0.0;       /// @is {number}
    has_keyboard_control = false;       /// @is {bool}
    has_been_interacted_with = false;   /// @is {bool}
    
    label_scribble = scribble(label);   /// @is {__scribble_class_element}
    label_scribble
        .starting_format(FontJosefinSans, c_white)
        .align(fa_center, fa_top);
	
	option_prompt_scribbles = array_create(array_length(options));	/// @is {__scribble_class_element[]}
	for (var i = 0; i < array_length(option_prompt_scribbles); ++i) {
		option_prompt_scribbles[i] = scribble(string(i + 1))
            .starting_format(FontJosefinSansSmallBold, #555555)
            .align(fa_center, fa_top);
	}
    
    // override
    static _is_interactable_type_virtual = function() /*-> bool*/
    {
        return true;
    }
    
    // override
    static _initialize_virtual = function(entry/*: MenuEntry*/)
    {
    }
    
    // override
    static _step_virtual = function(entry/*: MenuEntry*/, controller/*: MenuController*/, mouse_xx/*: number*/, mouse_yy/*: number*/, has_controls/*: bool*/, x1/*: number*/, yy/*: number*/, x2/*: number*/) /*-> MENU_RETURN*/
    {
        
        has_keyboard_control = check_has_keyboard_control(self);
        
        var value = getter();
        
        var num_options = array_length(options);
        
        var value_index = -1;
        var min_difference = -1;
        for (var i = 0, len = array_length(options); i < len; ++i) {
            var option = options[i];
            var difference = abs(option - value);
            if (min_difference < 0 || difference < min_difference) {
                min_difference = difference;
                value_index = i;
            }
        }
        if (value != options[value_index]) {
            value = options[value_index];
            setter(value);
        }
        
        if (!mouse_check_button(mb_left) || !has_controls || !controller.is_mouse_enabled()) {
            dragging_slider = false;
        }
        
        if (dragging_slider) {
            controller.set_cursor(MENU_CURSOR.draggy);
            value_index = __menu_normalize_number(mouse_xx + drag_offset_x, slider_x1, slider_x2, 0, num_options - 1);
            value_index = clamp(round(value_index), 0, num_options - 1);
            var new_value = options[value_index];
            setter(new_value);
            if (!has_been_interacted_with || new_value != value) {
                sfx_ui_play(snd_trait_slider);
            }
            has_been_interacted_with = true;
        }
        else if (has_keyboard_control) {
            for (var i = 0, len = array_length(options); i < len; ++i) {
                var key1 = ord(string(i + 1));
                var key2 = get_numpad_key(i + 1);
                if (keyboard_check_pressed(key1) || keyboard_check_pressed(key2)) {
                    keyboard_clear(key1);
                    keyboard_clear(key2);
                    value_index = i;
                    var new_value = options[value_index];
                    setter(new_value);
                    if (!has_been_interacted_with) {
                        sfx_ui_play(snd_trait_slider);
                    }
                    has_been_interacted_with = true;
                    break;
                }
            }
        }
        
        var slider_width = (x2 - x1) - 60;
        slider_x1 = floor((x2 - x1) / 2 - slider_width / 2);
        slider_x2 = floor(slider_x1 + slider_width);
        slider_y = floor(yy + 50);
        handle_x = floor(slider_x1 + (slider_width - 1) * (value_index / (num_options - 1)));
        handle_y = floor(slider_y - 1);
        
        if (dragging_slider) {
            var diff = sign(mouse_xx - handle_x) * max(0, abs(mouse_xx - handle_x) - 40);
            handle_x += sign(diff) * sqrt(abs(diff));
            handle_x = clamp(handle_x, slider_x1, slider_x2);
            handle_y += 5;
        }
        
        if (animated_handle_x == undefined) animated_handle_x = handle_x;
        if (animated_handle_y == undefined) animated_handle_y = handle_y;
        
        animated_handle_x_previous = animated_handle_x;
        animated_handle_y_previous = animated_handle_y;
        
        animated_handle_x += (handle_x - animated_handle_x) * 0.9;
        animated_handle_y += (handle_y - animated_handle_y) * 0.9;
        
        var target_animated_text_offset_x = 0.0;
        var target_animated_text_offset_y = 0.0;
        var target_handle_scale = 0.7;
        if (hovering_slider || dragging_slider) {
            target_handle_scale = 0.85;
            //target_animated_text_offset_y = -3;
        }
        animated_handle_scale += (target_handle_scale - animated_handle_scale) * 0.75;
        animated_text_offset_x += (target_animated_text_offset_x - animated_text_offset_x) * 0.75;
        animated_text_offset_y += (target_animated_text_offset_y - animated_text_offset_y) * 0.75;
        
        hovering_slider = false;
        
        if (dragging_slider) {
            return MENU_RETURN.controlling;
        }
        
        if (has_controls && is_enabled()) {
            var mouse_enabled = controller.is_mouse_enabled();
            var keyboard_enabled = controller.is_keyboard_enabled();
            
            menu_show_prompt(entry, MENU_INPUT_VERB.left, "");
            menu_show_prompt(entry, MENU_INPUT_VERB.right, MENU_TEXT.adjust);
            
            if (mouse_enabled) {
                if (point_in_rectangle(mouse_xx, mouse_yy, slider_x1 - 15, slider_y - 16, slider_x2 + 15, slider_y + 14)) {
                    hovering_slider = true;
                    controller.set_cursor(MENU_CURSOR.pointy);
                    if (mouse_check_button_pressed(mb_left)) {
                        dragging_slider = true;
                        drag_offset_x = 0;
                    }
                }
            }
        }
        return MENU_RETURN.void;
    }
    
    // override
    static _render_virtual = function(entry/*: MenuEntry*/, controller/*: MenuController*/, mouse_xx/*: number*/, mouse_yy/*: number*/, has_controls/*: bool*/, x1/*: number*/, yy/*: number*/, x2/*: number*/)
    {
        
        var enabled = is_enabled();
        
        var text_x = round(mean(x1, x2) + animated_text_offset_x);
        var text_y = round(yy + 5 + animated_text_offset_y);
        var text_color = #555555;
        if (hovering_slider || dragging_slider) {
            text_color = #000000;
        }
		label_scribble.blend(text_color, 1).draw(text_x, text_y);
        
        if (Configs.trait_menu_slider_is_triangle) {
            draw_sprite_ext(spr_slider_triangle, 0, slider_x1, slider_y, 1, 1, 0, c_white, 1);
        }
        else {
            var slider_xscale = (slider_x2 - slider_x1) / sprite_get_width(spr_slider_horizontal);
            var slider_yscale = 1;
            draw_sprite_ext(spr_slider_horizontal, 0, slider_x1, slider_y, slider_xscale, slider_yscale, 0, c_white, 1);
        }
        
        var draw_prompts = (Configs.show_keyboard_prompts && has_keyboard_control && enabled);
        
        for (var i = 0, len = array_length(options); i < len; ++i) {
            var tick_x = lerp(slider_x1, slider_x2, i / (len - 1));
            var tick_y = slider_y - 1;
            draw_sprite_ext(spr_slider_end, 0, tick_x, tick_y, 0.6, 0.6, 0, #666666, 1);
            if (draw_prompts) {
				option_prompt_scribbles[i].draw(tick_x, tick_y + 3);
            }
        }
        
        if (has_been_interacted_with) {
			var handle_sprite = enabled ? spr_slider_handle_up : spr_slider_handle_up_disabled;
            draw_sprite_ext(handle_sprite, 0, round(animated_handle_x), round(animated_handle_y), animated_handle_scale, animated_handle_scale, 0, c_white, 1);
        }
        
        if (formatter != undefined) {
        	var value_str = formatter(getter());
	        scribble(value_str)
	            .starting_format(FontJosefinSans, #AAAAAA)
	            .align(fa_right, fa_top)
	            .draw(slider_x1 - 2, yy);
        }
    }
    
    // override
    static _get_height_virtual = function(entry/*: MenuEntry*/, width/*: number*/) /*-> number*/
    {
        return 60;
    }
    
    // override
    static _cleanup_virtual = function(entry/*: MenuEntry*/)
    {
    }
}

function _MenuEntryDefinitionButton(
    _label/*: string*/,
    _callback/*: (function<MENU_RETURN>)*/,
    _check_enabled/*: (function<bool>)?*/ = undefined
) : MenuEntryDefinition(_check_enabled) constructor
{
    label = _label;         /// @is {string}
    callback = _callback;   /// @is {function<MENU_RETURN>}
    
    label_scribble = scribble(label) /// @is {__scribble_class_element}
    	.starting_format(style.font_name, c_white)
        .align(fa_center, fa_middle);
    
    is_hovered = false;         /// @is {bool}
    is_clicked_down = false;    /// @is {bool}
    
    // override
    static _is_interactable_type_virtual = function() /*-> bool*/
    {
        return true;
    }
    
    // override
    static _initialize_virtual = function(entry/*: MenuEntry*/)
    {
    }
    
    // override
    static _step_virtual = function(entry/*: MenuEntry*/, controller/*: MenuController*/, mouse_xx/*: number*/, mouse_yy/*: number*/, has_controls/*: bool*/, x1/*: number*/, yy/*: number*/, x2/*: number*/) /*-> MENU_RETURN*/
    {
        var enabled = is_enabled();
        
        is_hovered = false;
        if (has_controls && enabled) {
            var can_click = point_in_rectangle(mouse_xx, mouse_yy, x1, yy, x2, yy + _get_height_virtual(entry, x2 - x1));
            if (can_click) {
                is_hovered = true;
                controller.set_cursor(MENU_CURSOR.pointy);
                if (mouse_check_button(mb_left)) {
                    if (!is_clicked_down) {
                        sfx_ui_play(snd_button_down);
                    }
                    is_clicked_down = true;
                }
                else if (mouse_check_button_released(mb_left) && is_clicked_down) {
                    is_clicked_down = false;
                    sfx_ui_play(snd_button_up);
                    return callback();
                }
                else {
                    is_clicked_down = false;
                }
            }
        }
        else if (!mouse_check_button(mb_left)) {
            is_clicked_down = false;
        }
        
        if (!is_clicked_down && enabled) {
            var key = vk_space;
            if (keyboard_check_pressed(key)) {
                keyboard_clear(key);
                sfx_ui_play(snd_button_up);
                return callback();
            }
        }
        return MENU_RETURN.void;
    }
    
    // override
    static _render_virtual = function(entry/*: MenuEntry*/, controller/*: MenuController*/, mouse_xx/*: number*/, mouse_yy/*: number*/, has_controls/*: bool*/, x1/*: number*/, yy/*: number*/, x2/*: number*/)
    {
        var enabled = is_enabled();
        
        var button_down_sprite = enabled ? spr_button_green_down : spr_button_gray_down;
        var button_up_sprite = enabled ? spr_button_green_up : spr_button_gray_up;
        
        var height = _get_height_virtual(entry, x2 - x1);
        var spr = is_clicked_down ? button_down_sprite : button_up_sprite;
        var button_width = 200;
        var button_x1 = round(mean(x1, x2) - button_width / 2);
        var button_y1 = yy;
        var button_x2 = round(button_x1 + button_width);
        var button_y2 = yy + height;
        if (is_clicked_down) {
            button_y1 += 4;
        }
        
        var alpha = enabled ? 1.0 : 0.75;
        draw_nine_slice(spr, 0, button_x1, button_y1, button_x2, button_y2, 0, c_white, alpha);
        
        var text_x = round(mean(button_x1, button_x2));
        var text_y = round(button_y1 + 17);
        var text_color = is_hovered ? #3f6f28 : #284519;
        label_scribble
        	.blend(text_color, alpha)
        	.draw(text_x, text_y);
        
        if (Configs.show_keyboard_prompts && enabled) {
            var prompt_x = round((button_x1 + button_x2) / 2);
            var prompt_y = round(button_y2 - 2);
            scribble("SPACE")
                .starting_format(FontJosefinSansSmallBold, #555555)
                .align(fa_center, fa_top)
                .draw(prompt_x, prompt_y);
        }
    }
    
    // override
    static _get_height_virtual = function(entry/*: MenuEntry*/, width/*: number*/) /*-> number*/
    {
        return 35;
    }
    
    // override
    static _cleanup_virtual = function(entry/*: MenuEntry*/)
    {
    }
}
