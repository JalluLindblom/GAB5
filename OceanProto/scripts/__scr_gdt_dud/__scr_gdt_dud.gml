
/// @param {any} value
function dud_show_text(value)
{
    with (__obj_gdt_dud) {
        array_push(_lines, string(value));
    }
}

enum DUD_ANCHOR
{
    TopLeft,
    TopCenter,
    TopRight,
    MiddleLeft,
    MiddleCenter,
    MiddleRight,
    BottomLeft,
    BottomCenter,
    BottomRight,
}