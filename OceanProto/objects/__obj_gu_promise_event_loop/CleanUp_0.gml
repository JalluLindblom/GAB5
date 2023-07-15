event_inherited();

if (ds_exists(queue, ds_type_queue)) {
    ds_queue_destroy(queue);
    queue = -1;
}
