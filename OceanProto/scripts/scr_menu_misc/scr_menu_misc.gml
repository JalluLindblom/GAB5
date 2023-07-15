
enum MENU_RETURN
{
    void,
    back,
    close_menu,
    open_sub_menu,
    reload_menu,
    controlling,
}

enum MENU_INPUT_VERB
{
    select,
    back,
    left,
    up,
    right,
    down,
}

enum MENU_TEXT
{
    back,
    select,
    toggle,
    adjust,
    change,
}

enum MENU_CURSOR
{
    pointy,
    draggy,
}

function MenuStyling(
    _label_color/*: int*/,
    _disabled_color/*: int*/,
    _value_color/*: int*/,
    _heading_text_color/*: int*/,
    _sub_heading_text_color/*: int*/,
    _font_name/*: string*/
) constructor
{
    label_color             = _label_color;             /// @is {int}
    disabled_color          = _disabled_color;          /// @is {int}
    value_color             = _value_color;             /// @is {int}
    heading_text_color      = _heading_text_color;      /// @is {int}
    sub_heading_text_color  = _sub_heading_text_color;  /// @is {int}
    font_name               = _font_name;               /// @is {string}
    
    // TODO
    colorDullLightBrown     = #908080;                  /// @is {int}
    colorBlack              = #262425;                  /// @is {int}
    
    static copy_from = function(other_style/*: MenuStyling*/)
    {
        var names = variable_struct_get_names(self);
        for (var i = 0, len = array_length(names); i < len; ++i) {
            var name = names[i];
            self[$ name] = other_style[$ name];
        }
    }
}

function MenuController() constructor
{
    // virtual
    static check_pressed = function(verb/*: MENU_INPUT_VERB*/) /*-> bool*/
    {
        return false;
    }
    
    // virtual
    static check_repeated = function(verb/*: MENU_INPUT_VERB*/) /*-> bool*/
    {
        return false;
    }
    
    // virtual
    static is_mouse_enabled = function() /*-> bool*/
    {
        return false;
    }
    
    // virtual
    static is_keyboard_enabled = function() /*-> bool*/
    {
        return false;
    }
    
    // virtual
    static set_cursor = function(cursor/*: MENU_CURSOR*/)
    {
    }
}

function menu_show_prompt(menu/*: Menu*/, verb/*: MENU_INPUT_VERB*/, text_id/*: MENU_TEXT*/)
{
    // TODO
}

function __menu_clamp_lerp(value/*: number*/, min_value/*: number*/, max_value/*: number*/, amount/*: number*/) /*-> number*/
{
	var clampedValue = clamp(value, min_value, max_value);
	return lerp(value, clampedValue, amount);
}

function __menu_normalize_number(value/*: number*/, min_value/*: number*/, max_value/*: number*/, v1/*: number*/, v2/*: number*/) /*-> number*/
{
    return lerp(v1, v2, (value - min_value) / (max_value - min_value));
}
