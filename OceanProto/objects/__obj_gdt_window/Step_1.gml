event_inherited();

// Hacky fix for stopping dragging... Sometimes it would get stuck dragging
// even if you weren't holding left mouse button anymore. Don't know why. But this fixed it.
if (!mouse_check_button(mb_left)) {
    dragging_something = false;
    dragged_thing = -1;
}