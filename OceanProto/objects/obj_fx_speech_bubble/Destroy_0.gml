event_inherited();

if (next_bubbles_queue != undefined && array_length(next_bubbles_queue) > 0 && instance_exists(attached_creature)) {
    var new_bubble = instance_create_layer(x, y, layer, obj_fx_speech_bubble);
    var queue_entry = next_bubbles_queue[0];
    new_bubble.initialize(attached_creature, queue_entry.content_sprite, queue_entry.no_bubble, queue_entry.dir, queue_entry.infinite, queue_entry.create_callback);
    if (array_length(next_bubbles_queue) > 1) {
        new_bubble.next_bubbles_queue = array_sliced(next_bubbles_queue, 1, array_length(next_bubbles_queue) - 1);
        new_bubble.life_timer += 30;
    }
}