event_inherited();

if (current_time > current_time_at_create) {
    callback();
    instance_destroy();
    return;
}
