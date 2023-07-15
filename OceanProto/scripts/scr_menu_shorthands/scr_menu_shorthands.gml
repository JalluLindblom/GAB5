
function ME_function(
    label/*: string*/,
    callback/*: (function<MENU_RETURN>)*/,
    check_enabled/*: (function<bool>)?*/ = undefined
) /*-> _MenuEntryDefinitionFunction*/
{
    return new _MenuEntryDefinitionFunction(label, callback, check_enabled);
}
    
function ME_sub_menu(
    label/*: string*/,
    menu/*: MenuDefinition*/,
    check_enabled/*: (function<bool>)?*/ = undefined
) /*-> _MenuEntryDefinitionSubMenu*/
{
    return new _MenuEntryDefinitionSubMenu(label, menu, check_enabled);
}

function ME_text(
    label_or_labels/*: string|string[]*/,
    is_heading/*: bool*/,
    is_sub_heading/*: bool*/,
    check_enabled/*: (function<bool>)?*/ = undefined
) /*-> _MenuEntryDefinitionText*/
{
    return new _MenuEntryDefinitionText(label_or_labels, is_heading, is_sub_heading, check_enabled);
}

function ME_spacer(
    height/*: number*/,
    check_enabled/*: (function<bool>)?*/ = undefined
) /*-> _MenuEntryDefinitionSpacer*/
{
    return new _MenuEntryDefinitionSpacer(height, check_enabled);
}

function ME_boolean(
    label/*: string*/,
    getter/*: (function<bool>)*/,
    setter/*: (function<bool, MENU_RETURN>)*/,
    formatter/*: (function<bool, string>)*/,
    check_enabled/*: (function<bool>)?*/ = undefined
) /*-> _MenuEntryDefinitionBoolean*/
{
    return new _MenuEntryDefinitionBoolean(label, getter, setter, formatter, check_enabled);
}

function ME_float(
    label/*: string*/,
    min_value/*: number*/,
    max_value/*: number*/,
    increment/*: number*/,
    getter/*: (function<number>)*/,
    setter/*: (function<number, MENU_RETURN>)*/,
    formatter/*: (function<number, string>)*/,
    check_enabled/*: (function<bool>)?*/ = undefined
) /*-> _MenuEntryDefinitionFloat*/
{
    return new _MenuEntryDefinitionFloat(label, min_value, max_value, increment, getter, setter, formatter, check_enabled);
}

function ME_choice(
    label/*: string*/,
    getter/*: (function<any>)*/,
    setter/*: (function<any, MENU_RETURN>)*/,
    choices/*: Array*/,
    formatter/*: (function<any, int, string>)*/,
    check_enabled/*: (function<bool>)?*/ = undefined
) /*-> _MenuEntryDefinitionChoice*/
{
    return new _MenuEntryDefinitionChoice(label, getter, setter, choices, formatter, check_enabled);
}

function ME_slider(
    label/*: string*/,
    min_value/*: number*/,
    max_value/*: number*/,
    increment/*: number*/,
    getter/*: (function<number>)*/,
    setter/*: (function<number, MENU_RETURN>)*/,
    formatter/*: (function<number, string>)*/,
    check_enabled/*: (function<bool>)?*/ = undefined
) /*-> _MenuEntryDefinitionSlider*/
{
    return new _MenuEntryDefinitionSlider(label, min_value, max_value, increment, getter, setter, formatter, check_enabled);
}

function ME_discrete_slider(
    label/*: string*/,
    options/*: number[]*/,
    getter/*: (function<number>)*/,
    setter/*: (function<number, MENU_RETURN>)*/,
    formatter/*: (function<number, string>)?*/,
    check_has_keyboard_control/*: (function<_MenuEntryDefinitionDiscreteSlider, bool>)*/,
    check_enabled/*: (function<bool>)?*/ = undefined
) /*-> _MenuEntryDefinitionDiscreteSlider*/
{
    return new _MenuEntryDefinitionDiscreteSlider(label, options, getter, setter, formatter, check_has_keyboard_control, check_enabled);
}

function ME_button(
    label/*: string*/,
    callback/*: (function<MENU_RETURN>)*/,
    check_enabled/*: (function<bool>)?*/ = undefined
) /*-> _MenuEntryDefinitionButton*/
{
    return new _MenuEntryDefinitionButton(label, callback, check_enabled);
}

function ME_back(label/*: string*/) /*-> MenuEntryDefinition*/
{
    return ME_function(label, function() {
        return MENU_RETURN.back;
    }, undefined);
}





function ME_field_bool(
    label/*: string*/,
    struct_or_instance/*: struct|instance*/,
    field_name/*: string*/,
    callback/*: (function<MENU_RETURN>)?*/ = undefined
) /*-> _MenuEntryDefinitionBoolean*/
{
    var c = {
        struct_or_instance: struct_or_instance,
        field_name: field_name,
        callback: callback,
        is_instance: !is_struct(struct_or_instance),
    };
    return ME_boolean(
        label,
        method(c, function() {
            return struct_or_instance[$ field_name];
        }),
        method(c, function(value/*: bool*/) {
            struct_or_instance[$ field_name] = value;
            return (callback != undefined) ? callback() : MENU_RETURN.void;
        }),
        function(value/*: bool*/) {
            return value ? "[[x]" : "[[ ]";
        }
    );
}

function ME_field_percent(
    label/*: string*/,
    struct_or_instance/*: struct|instance*/,
    field_name/*: string*/,
    increment/*: number*/,
    callback/*: (function<MENU_RETURN>)?*/ = undefined
) /*-> _MenuEntryDefinitionFloat*/
{
    var c = { struct_or_instance: struct_or_instance, field_name: field_name, callback: callback };
    return ME_float(
        label,
        0,
        1,
        increment,
        method(c, function() {
            return struct_or_instance[$ field_name];
        }),
        method(c, function(value/*: number*/) {
            struct_or_instance[$ field_name] = value;
            return (callback != undefined) ? callback() : MENU_RETURN.void;
        }),
        method(c, function(value/*: number*/) {
            var percent_str = string(round(value * 100)) + "%";
            var left_str  = (value > 0) ? "<-" : "[DullLightBrown]<-[/c]";
            var right_str = (value < 1) ? "->" : "[DullLightBrown]->[/c]";
            return left_str + string_pad_left(percent_str, 5) + " " + right_str;
        })
    );
}

function ME_field_slider(
    label/*: string*/,
    struct_or_instance/*: struct|instance*/,
    field_name/*: string*/,
    min_value/*: number*/,
    max_value/*: number*/,
    increment/*: number*/,
    callback/*: (function<MENU_RETURN>)?*/ = undefined
) /*-> _MenuEntryDefinitionSlider*/
{
    var c = {
        struct_or_instance: struct_or_instance,
        field_name: field_name,
        callback: callback
    };
    return ME_slider(
        label,
        min_value,
        max_value,
        increment,
        method(c, function() {
            return struct_or_instance[$ field_name];
        }),
        method(c, function(value/*: number*/) {
            struct_or_instance[$ field_name] = value;
            return (callback != undefined) ? callback() : MENU_RETURN.void;
        }),
        method(c, function(value/*: number*/) {
            return "";
        })
    );
}

function ME_field_discrete_slider(
    label/*: string*/,
    struct_or_instance/*: struct|instance*/,
    field_name/*: string*/,
    options/*: number[]*/,
    check_has_keyboard_control/*: (function<_MenuEntryDefinitionDiscreteSlider, bool>)*/,
    callback/*: (function<MENU_RETURN>)?*/ = undefined,
	check_enabled/*: (function<bool>)?*/ = undefined
) /*-> _MenuEntryDefinitionDiscreteSlider*/
{
    var c = {
        struct_or_instance: struct_or_instance,
        field_name: field_name,
        callback: callback
    };
    return ME_discrete_slider(
        label,
        options,
        method(c, function() {
            return struct_or_instance[$ field_name];
        }),
        method(c, function(value/*: number*/) {
            struct_or_instance[$ field_name] = value;
            return (callback != undefined) ? callback() : MENU_RETURN.void;
        }),
        undefined,
        check_has_keyboard_control,
		check_enabled
    );
}

function ME_field_choice(
    label/*: string*/,
    struct_or_instance/*: struct|instance*/,
    field_name/*: string*/,
    choices/*: Array*/,
    formatter/*: (function<any, int, string>)*/,
    callback/*: (function<MENU_RETURN>)?*/ = undefined,
    check_enabled/*: (function<bool>)?*/ = undefined
) /*-> _MenuEntryDefinitionChoice*/
{
    var c = { struct_or_instance: struct_or_instance, field_name: field_name, callback: callback };
    return ME_choice(
        label,
        method(c, function() {
            return struct_or_instance[$ field_name];
        }),
        method(c, function(value/*: any*/) {
            struct_or_instance[$ field_name] = value;
            return (callback != undefined) ? callback() : MENU_RETURN.void;
        }),
        choices,
        formatter,
        check_enabled
    );
}

function ME_heading(label/*: string*/) /*-> _MenuEntryDefinitionText*/
{
    return ME_text(label, true, false);
}

function ME_sub_heading(label/*: string*/) /*-> _MenuEntryDefinitionText*/
{
    return ME_text(label, false, true);
}
