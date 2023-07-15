
enum __GIZMOS_DRAW_COMMAND
{
    DRAW_LINE,
    DRAW_LINE_COLOR,
    DRAW_CIRCLE,
    DRAW_RECTANGLE,
    DRAW_TRIANGLE,
    DRAW_TEXT,
    DRAW_SPRITE,
    DRAW_SET_COLOR,
    DRAW_SET_ALPHA,
    DRAW_SET_HALIGN,
    DRAW_SET_VALIGN,
    DRAW_SET_FONT,
}

function __gizmos_push_draw_command(command_type/*: __GIZMOS_DRAW_COMMAND*/) /*-> struct*/
{
    with (obj_gizmos) {
        if (instance_exists(_target_drawer)) {
            var command = { type: command_type };
            array_push(_target_drawer._draw_commands, command);
            return command;
        }
    }
    static dummy_command = {};
    return dummy_command;
}
