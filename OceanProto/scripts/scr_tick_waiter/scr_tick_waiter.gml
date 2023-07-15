
function wait_ticks(trial/*: obj_trial*/, instance/*: instance*/, num_ticks/*: int*/) /*-> Promise*/
{
    var capture = {
        trial: trial,
        instance: instance,
        num_ticks: num_ticks,
    };
    return new Promise(method(capture, function(resolve, reject) {
        var waiter = instance_create_depth(0, 0, 0, obj_tick_waiter);
        waiter.initialize(trial, instance, num_ticks, resolve);
    }));
}
