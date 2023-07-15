
/// @returns {Promise}
function wait_condition(condition/*: function<bool>*/)
{
    return new Promise(method({ condition: condition }, function(resolve, reject) {
        var waiter = instance_create_depth(0, 0, 0, obj_condition_waiter);
		waiter.condition = condition;
        waiter.callback = resolve;
    }));
}
