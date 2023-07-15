event_inherited();

var gui_width = display_get_gui_width();
var gui_height = display_get_gui_height();

var width = 800;
var height = 40;

var x1 = round(gui_width / 2 - width / 2);
var y1 = round(gui_height - 20 - height);
var x2 = round(x1 + width);
var y2 = round(y1 + height);

var xscale = (x2 - x1) / sprite_get_width(spr_hud_time_bar);
var yscale = (y2 - y1) / sprite_get_height(spr_hud_time_bar);
draw_sprite_ext(spr_hud_time_bar, 0, x1, y1, xscale, yscale, 0, c_white, 1);

var t = clamp(trial.ticker.spent_ticks / trial.max_ticks, 0, 1);

if (t > 0) {
    x1 = x1 + 5;
    y1 = y1 + 5;
    x2 = x2 - 5;
    y2 = y2 - 5;
    render_rectangle(x1, y1, lerp(x1, x2, t), y2, #83c4e4, 1.0, false);
    render_rectangle(x1, y1, lerp(x1, x2, t), lerp(y1, y2, 0.5), #a7d3e8, 1.0, false);
}
