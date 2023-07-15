event_inherited();

var headers = /*#cast*/ [
] /*#as MenuEntryDefinition[]*/;

var callback = function() {
    save_active_debug_settings();
    return MENU_RETURN.void;
};

var bodies = /*#cast*/ [
    ME_sub_heading("Debug settings"),
    ME_field_bool("Pathfinding",        Debugs, "show_pathfinding", callback),
    ME_field_bool("Sight ranges",       Debugs, "show_sight_ranges", callback),
    ME_field_bool("Exploration ranges", Debugs, "show_exploration_ranges", callback),
    ME_field_bool("Attack ranges",      Debugs, "show_attack_ranges", callback),
    ME_field_bool("Player actions",     Debugs, "show_player_actions", callback),
    ME_field_bool("Human actions",      Debugs, "show_human_actions", callback),
    ME_field_bool("IDs",                Debugs, "show_ids", callback),
    ME_field_bool("Energies",           Debugs, "show_energies", callback),
    ME_field_bool("Trait data",         Debugs, "show_trait_data", callback),
    ME_field_bool("Log",                Debugs, "show_log", callback),
    ME_spacer(0.5),
    ME_text("Press Ctrl+D to hide debug tools", false, false),
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