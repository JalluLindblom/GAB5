event_inherited();

// Only execute the promises that are already in the queue.
// If those promise executors spawn more promises, those won't be executed on this loop.
var n = ds_queue_size(queue);
for (var i = 0; i < n; ++i) {
    
    var promise = ds_queue_dequeue(queue);
    promise._execute();
    
    // Check for rejected promises with no catchers
    if (promise.state == PROMISE_STATE.rejected && array_length(promise.reject_callbacks) == 0 && global.__promises_uncaught_reject_handler != undefined) {
        global.__promises_uncaught_reject_handler(promise);
    }
}
