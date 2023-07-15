event_inherited();

enabled = false;    /// @is {bool}
game_speed = 1.0;   /// @is {number}

var headers = /*#cast*/ [
] /*#as MenuEntryDefinition[]*/;

var check_trial_exists = function() { return instance_exists(Trial); };

var bodies = /*#cast*/ [
    ME_sub_heading("Game speed"),
    ME_slider(
        " ",
        0.0,
        10.0,
        0.1,
        function() { return game_speed; },
        function(value/*: number*/) { game_speed = value; return MENU_RETURN.void; },
        function(value/*: number*/) { return string(floor(value * 100)) + "%"; },
        check_trial_exists
    ),
    ME_field_bool("Enabled", id, "enabled"),
    ME_function("0%",       function() { game_speed = 0.0;      return MENU_RETURN.void; }),
    ME_function("50%",      function() { game_speed = 0.5;      return MENU_RETURN.void; }),
    ME_function("100%",     function() { game_speed = 1.0;      return MENU_RETURN.void; }),
    ME_function("200%",     function() { game_speed = 2.0;      return MENU_RETURN.void; }),
    ME_function("1000%",    function() { game_speed = 10.0;     return MENU_RETURN.void; }),
    ME_function("10000%",   function() { game_speed = 100.0;    return MENU_RETURN.void; }),
    ME_function("Infinite", function() { game_speed = -1;       return MENU_RETURN.void; }),
] /*#as MenuEntryDefinition[]*/;

var footers = /*#cast*/ [
] /*#as MenuEntryDefinition[]*/;

menu = new Menu(new MenuDefinition(headers, bodies, footers));  /// @is {Menu}

mouse_xx = 0;   /// @is {number}
mouse_yy = 0;   /// @is {number}
x1 = 0;         /// @is {number}
y1 = 0;         /// @is {number}
x2 = 0;         /// @is {number}
y2 = 0;         /// @is {number}