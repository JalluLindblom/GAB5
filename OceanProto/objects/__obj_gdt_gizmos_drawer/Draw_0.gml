event_inherited();

if (array_length(_draw_commands) > 0) {
    
    var prev_color = draw_get_color();
    var prev_alpha = draw_get_alpha();
    var prev_halign = draw_get_halign();
    var prev_valign = draw_get_valign();
    var prev_font = draw_get_font();
    
    draw_set_alpha(gizmos.default_alpha);
    draw_set_color(gizmos.default_color);
    draw_set_halign(gizmos.default_halign);
    draw_set_valign(gizmos.default_valign);
    draw_set_font(gizmos.default_font);
    
    for (var i = 0, len = array_length(_draw_commands); i < len; ++i) {
        var c = _draw_commands[i];
        switch (c.type) {
            case __GIZMOS_DRAW_COMMAND.DRAW_LINE:         draw_line(c.x1, c.y1, c.x2, c.y2); break;
            case __GIZMOS_DRAW_COMMAND.DRAW_LINE_COLOR:   draw_line_color(c.x1, c.y1, c.x2, c.y2, c.col1, c.col2); break;
            case __GIZMOS_DRAW_COMMAND.DRAW_CIRCLE:       draw_circle(c.x, c.y, c.radius, c.outline); break;
            case __GIZMOS_DRAW_COMMAND.DRAW_RECTANGLE:    draw_rectangle(c.x1, c.y1, c.x2, c.y2, c.outline); break;
            case __GIZMOS_DRAW_COMMAND.DRAW_TRIANGLE:     draw_triangle(c.x1, c.y1, c.x2, c.y2, c.x3, c.y3, c.outline); break;
            case __GIZMOS_DRAW_COMMAND.DRAW_TEXT:         draw_text(c.x, c.y, c.string); break;
            case __GIZMOS_DRAW_COMMAND.DRAW_SPRITE:       draw_sprite(c.sprite, c.subimg, c.x, c.y); break;
            case __GIZMOS_DRAW_COMMAND.DRAW_SET_COLOR:    draw_set_color(c.color); break;
            case __GIZMOS_DRAW_COMMAND.DRAW_SET_ALPHA:    draw_set_alpha(c.alpha); break;
            case __GIZMOS_DRAW_COMMAND.DRAW_SET_HALIGN:   draw_set_halign(c.halign); break;
            case __GIZMOS_DRAW_COMMAND.DRAW_SET_VALIGN:   draw_set_valign(c.valign); break;
            case __GIZMOS_DRAW_COMMAND.DRAW_SET_FONT:     draw_set_font(c.font); break;
        }
    }
    
    array_resize(_draw_commands, 0);
    
    draw_set_color(prev_color);
    draw_set_alpha(prev_alpha);
    draw_set_halign(prev_halign);
    draw_set_valign(prev_valign);
    draw_set_font(prev_font);
    
}
