event_inherited();

trial = /*#cast*/ undefined;     /// @is {obj_trial}
instance = /*#cast*/ undefined;  /// @is {instance}
ticks = /*#cast*/ undefined;     /// @is {int}
callback = /*#cast*/ undefined;  /// @is {function<void>}

callback_done = false;      /// @is {bool}

initialize = function(_trial/*: obj_trial*/, _instance/*: instance*/, _num_ticks/*: int*/, _callback/*: (function<void>)*/)
{
    trial = _trial;
    instance = _instance;
    ticks = _num_ticks;
    callback = _callback;
    
    trial.ticker.on_tick(instance, function(tick_number/*: int*/, tick_rng/*: Rng*/) {
        if (callback_done) {
            return;
        }
        ticks -= 1;
        if (ticks <= 0) {
            callback();
            callback_done = true;
            instance_destroy();
        }
    });
}