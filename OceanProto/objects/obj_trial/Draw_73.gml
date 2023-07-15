event_inherited();

// When playing non-auto run but game speed is infinite,
// cover the level with the background color to hide all the action.
var is_infinite_speed = (game_speed < 0);
if (!is_auto_run && is_infinite_speed && state >= TRIAL_STATE.running) {
    var x1 = 0;
    var y1 = 0;
    var x2 = terrain.width * CSIZE;
    var y2 = terrain.height * CSIZE;
    var color_str = Configs.level_background_color;
    var color = color_from_hexadecimal_string(string_remove_prefix(color_str, "#"));
    render_rectangle(x1, y1, x2, y2, color, 1.0, false);
}