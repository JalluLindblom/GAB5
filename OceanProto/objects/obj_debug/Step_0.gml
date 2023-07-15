event_inherited();

if (keyboard_check(vk_control) && keyboard_check_pressed(ord("D"))) {
    debugToolsVisible = !debugToolsVisible;
    gizmos.visible              = debugToolsVisible;
    dud.visible                 = debugToolsVisible;
    visualizer.visible          = debugToolsVisible;
    debug_menu.visible          = debugToolsVisible;
    time_control_menu.visible   = debugToolsVisible;
    fps_meter.visible           = debugToolsVisible;
}
