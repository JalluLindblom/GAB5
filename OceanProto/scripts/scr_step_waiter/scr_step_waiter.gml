
/// @returns {Promise}
function wait_one_step()
{
    return new Promise(function(resolve, reject) {
        var waiter = instance_create_depth(0, 0, 0, obj_step_waiter);
        waiter.callback = resolve;
    });
}
