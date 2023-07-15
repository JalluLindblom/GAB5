event_inherited();

if (!instance_exists(Trial)) {
    return;
}

render_rectangle(x1, y1, x2, y2, COLOR.white, 0.25, false);

menu.render(CommonMenuController, mouse_xx, mouse_yy, x1, y1, x2, y2);