event_inherited();

if (current_time > current_time_at_create && room_start_event_called && callback != undefined) {
    callback();
    instance_destroy();
    return;
}
