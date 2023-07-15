event_inherited();

if (text == undefined) {
    return;
}

var gui_width = display_get_gui_width();
var gui_height = display_get_gui_height();

var xx = round(gui_width / 2);
var yy = round(gui_height / 2);

var scrib = scribble(text)
    .starting_format(FontConsoleMediumBoldOutlined, COLOR.white)
    .align(fa_center, fa_middle);

var x1 = xx - 30 + scrib.get_left();
var y1 = yy - 10 + scrib.get_top();
var x2 = xx + 30 + scrib.get_right();
var y2 = yy + 10 + scrib.get_bottom();
render_rectangle(x1, y1, x2, y2, COLOR.black, 0.75, false);

scrib.draw(xx, yy);
