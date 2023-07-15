event_inherited();

line_scribbles = [];    /// @is {__scribble_class_element[]}
needs_redraw = false;   /// @is {bool}
surface = -1;           /// @is {surface}
animated_offset_x = 0;  /// @is {number}
animated_offset_y = 0;  /// @is {number}

println = function(line/*: string*/)
{
    var lines = string_split(line, "\n");
    for (var i = 0, len = array_length(lines); i < len; ++i) {
        var line_scribble = scribble(lines[i])
            .starting_format(FontTerminalOutlined, #dddddd)
            .align(fa_left, fa_bottom);
        array_push(line_scribbles, line_scribble);
        animated_offset_y += line_scribble.get_height();
    }
    while (array_length(line_scribbles) > 70) {
        array_delete(line_scribbles, 0, 1);
    }
    needs_redraw = true;
}