event_inherited();

if (cursor != undefined) {
    window_set_cursor(cursor);
    cursor = undefined;
}
else {
    window_set_cursor(cr_default);
}
