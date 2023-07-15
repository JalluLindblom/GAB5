event_inherited();

if (statics_changed) {
    statics_surface_needs_redraw = true;
    statics_changed = false;
}

if (instance_exists(Trial) && Trial.is_auto_run) {
    visible = false;
    return;
}

visible = (room == rm_trial);