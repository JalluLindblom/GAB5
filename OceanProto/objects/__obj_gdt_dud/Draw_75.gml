event_inherited();

var str = "";
var num_lines = array_length(_lines);
if (top_to_bottom) {
    for (var i = 0; i < num_lines; ++i) {
        str += _lines[i] + "\n";
    }
}
else {
    for (var i = num_lines - 1; i >= 0; --i) {
        str += _lines[i] + "\n";
    }
}

var gw = display_get_gui_width();
var gh = display_get_gui_height();
var xx = 0;
var yy = 0;
switch (anchor) {
    case DUD_ANCHOR.TopLeft:      xx = 0;      yy = 0;      break;
    case DUD_ANCHOR.TopCenter:    xx = gw / 2; yy = 0;      break;
    case DUD_ANCHOR.TopRight:     xx = gw - 1; yy = 0;      break;
    case DUD_ANCHOR.MiddleLeft:   xx = 0;      yy = gh / 2; break;
    case DUD_ANCHOR.MiddleCenter: xx = gw / 2; yy = gh / 2; break;
    case DUD_ANCHOR.MiddleRight:  xx = gw - 1; yy = gh / 2; break;
    case DUD_ANCHOR.BottomLeft:   xx = 0;      yy = gh - 1; break;
    case DUD_ANCHOR.BottomCenter: xx = gw / 2; yy = gh - 1; break;
    case DUD_ANCHOR.BottomRight:  xx = gw - 1; yy = gh - 1; break;
}
xx = round(xx + offset_x);
yy = round(yy + offset_y);

var prev_alpha = draw_get_alpha();
var prev_color = draw_get_color();
var prev_halign = draw_get_halign();
var prev_valign = draw_get_valign();
var prev_font = draw_get_font();

draw_set_alpha(alpha);
draw_set_color(color);
draw_set_halign(halign);
draw_set_valign(valign);
draw_set_font(font);

draw_text(xx, yy, str);

draw_set_alpha(prev_alpha);
draw_set_color(prev_color);
draw_set_halign(prev_halign);
draw_set_valign(prev_valign);
draw_set_font(prev_font);

array_resize(_lines, 0);
