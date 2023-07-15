event_inherited();

draw_set_alpha(1);
draw_set_halign(fa_right);
draw_set_valign(fa_top);
draw_set_font(fnt_r644);

var xx = display_get_gui_width() - 5;
var yy = 20;

var str = string(round(fps_average)) + "\n" + string(round(fps_real_average));

draw_set_color(COLOR.black);
var x1 = xx - string_width(str) - 5;
var y1 = yy - 2;
var x2 = xx + 2;
var y2 = yy + string_height(str);
draw_rectangle(x1, y1, x2, y2, false);

draw_set_color(COLOR.green);
if (fps_average < 30) {
	draw_set_color(COLOR.red);
}
else if (fps_real_average <= 60) {
	draw_set_color(COLOR.yellow);
}

draw_text(xx, yy, str);
