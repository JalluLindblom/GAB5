event_inherited();

_draw_path = function(instance/*: instance*/, path/*: PfPathElement[]*/)
{
    static _line = function(x1/*: number*/, y1/*: number*/, x2/*: number*/, y2/*: number*/, color/*: int*/)
    {
        render_line(x1, y1, x2, y2, 5.0, color, 1.0);
    }
    
    var path_len = array_length(path);
    if (path_len <= 0) {
        return;
    }
    
    var line_hue = get_debug_hue_for_instance(instance);
    var line_color = make_color_hsv(line_hue, 180, 255);
    
    var x1 = instance.x;
    var y1 = instance.y;
    for (var i = 0; i < path_len; ++i) {
        var cell = path[i].node;
        var x2 = cell.cx * CSIZE + CSIZE / 2;
        var y2 = cell.cy * CSIZE + CSIZE / 2;
        _line(x1, y1, x2, y2, line_color);
        x1 = x2;
        y1 = y2;
        scribble(string(path_len - i))
            .starting_format(FontConsoleBoldOutlined, COLOR.white)
            .align(fa_center, fa_middle)
            .draw(x2, y2);
    }
}