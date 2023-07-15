
function cursor_set(cursor/*: window_cursor*/)
{
    if (!instance_exists(obj_cursor)) {
        instance_create_depth(0, 0, 0, obj_cursor);
    }
    obj_cursor.cursor = cursor;
}
