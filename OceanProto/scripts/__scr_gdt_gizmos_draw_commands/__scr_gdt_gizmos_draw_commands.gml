
function gizmos_draw_line(x1/*: number*/, y1/*: number*/, x2/*: number*/, y2/*: number*/)
{
    var command = __gizmos_push_draw_command(__GIZMOS_DRAW_COMMAND.DRAW_LINE);
    command.x1 = x1;
    command.y1 = y1;
    command.x2 = x2;
    command.y2 = y2;
}

function gizmos_draw_line_color(x1/*: number*/, y1/*: number*/, x2/*: number*/, y2/*: number*/, col1/*: int*/, col2/*: int*/)
{
    var command = __gizmos_push_draw_command(__GIZMOS_DRAW_COMMAND.DRAW_LINE_COLOR);
    command.x1 = x1;
    command.y1 = y1;
    command.x2 = x2;
    command.y2 = y2;
    command.col1 = col1;
    command.col2 = col2;
}

function gizmos_draw_circle(x/*: number*/, y/*: number*/, radius/*: number*/, outline/*: bool*/)
{
    var command = __gizmos_push_draw_command(__GIZMOS_DRAW_COMMAND.DRAW_CIRCLE);
    command.x = x;
    command.y = y;
    command.radius = radius;
    command.outline = outline;
}

function gizmos_draw_rectangle(x1/*: number*/, y1/*: number*/, x2/*: number*/, y2/*: number*/, outline/*: bool*/)
{
    var command = __gizmos_push_draw_command(__GIZMOS_DRAW_COMMAND.DRAW_RECTANGLE);
    command.x1 = x1;
    command.y1 = y1;
    command.x2 = x2;
    command.y2 = y2;
    command.outline = outline;
}

function gizmos_draw_triangle(x1/*: number*/, y1/*: number*/, x2/*: number*/, y2/*: number*/, x3/*: number*/, y3/*: number*/, outline/*: bool*/)
{
    var command = __gizmos_push_draw_command(__GIZMOS_DRAW_COMMAND.DRAW_TRIANGLE);
    command.x1 = x1;
    command.y1 = y1;
    command.x2 = x2;
    command.y2 = y2;
    command.x3 = x3;
    command.y3 = y3;
    command.outline = outline;
}

function gizmos_draw_text(x/*: number*/, y/*: number*/, string/*: string*/)
{
    var command = __gizmos_push_draw_command(__GIZMOS_DRAW_COMMAND.DRAW_TEXT);
    command.x = x;
    command.y = y;
    command.string = string;
}

function gizmos_draw_sprite(sprite/*: sprite*/, subimg/*: number*/, x/*: number*/, y/*: number*/)
{
    var command = __gizmos_push_draw_command(__GIZMOS_DRAW_COMMAND.DRAW_SPRITE);
    command.sprite = sprite;
    command.subimg = subimg;
    command.x = x;
    command.y = y;
}

function gizmos_draw_set_color(color/*: int*/)
{
    var command = __gizmos_push_draw_command(__GIZMOS_DRAW_COMMAND.DRAW_SET_COLOR);
    command.color = color;
}

function gizmos_draw_set_alpha(alpha/*: number*/)
{
    var command = __gizmos_push_draw_command(__GIZMOS_DRAW_COMMAND.DRAW_SET_ALPHA);
    command.alpha = alpha;
}

function gizmos_draw_set_halign(halign/*: horizontal_alignment*/)
{
    var command = __gizmos_push_draw_command(__GIZMOS_DRAW_COMMAND.DRAW_SET_HALIGN);
    command.halign = halign;
}

function gizmos_draw_set_valign(valign/*: vertical_alignment*/)
{
    var command = __gizmos_push_draw_command(__GIZMOS_DRAW_COMMAND.DRAW_SET_VALIGN);
    command.valign = valign;
}

function gizmos_draw_set_font(font/*: font*/)
{
    var command = __gizmos_push_draw_command(__GIZMOS_DRAW_COMMAND.DRAW_SET_FONT);
    command.font = font;
}
