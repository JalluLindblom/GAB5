event_inherited();

draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_font(fnt_courier_new_small_bold);

var title_str = LANG("Hud_TotalScore");
var xx = round(10 + string_width(title_str) / 2);
var yy = 10;
var color = COLOR.white;
var alpha = 1.0;
draw_text_color(xx, yy, title_str, color, color, color, color, alpha);

var score_str = string(animated_score);
yy += string_height(title_str);
draw_set_font(fnt_courier_new_medium_bold);
draw_text_color(xx, yy, score_str, color, color, color, color, alpha);
