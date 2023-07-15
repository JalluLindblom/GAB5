
enum PROMISE_STATE
{
    pending,
    fulfilled,
    rejected,
}

/// This interface and implementation closely mimics how JavaScript Promises work.
/// Whereas JavaScript's promise executors are ran at the earliest in the next event loop,
/// these promises' executors are ran by __obj_gu_promise_event_loop at its next step event.
function Promise(_executor/*: (function<(function<any, void>), (function<any, void>), void>)*/) constructor
{
    executor = _executor;           /// @is {(function<(function<any, void>|function<void>), (function<any, void>|function<void>), void>)}
    state = PROMISE_STATE.pending;  /// @is {PROMISE_STATE}
    value = undefined;              /// @is {any}
    reason = undefined;             /// @is {any}
    resolve_callbacks = [];         /// @is {Array<(function<any, void>)>}
    reject_callbacks = [];          /// @is {Array<(function<any, void>)>}
    
    debug_callstack = undefined;    /// @is {Array<string>?}
    if (global.__promises_debug_enabled) {
        debug_callstack = debug_get_callstack();
    }
    
    /// Adds fulfillment and rejection handlers to this promise.
    /// Returns a new promise that resolves with the return value of
    /// either handler or rejects with the error thrown by either handler.
    static and_then = function(_on_fulfilled/*: (function<any, void>|function<void>)*/, _on_rejected/*: (function<any, void>|function<void>)*/ = undefined) /*-> Promise*/
    {
        static _default_on_rejected = function(error) {
            throw error;
        };
        if (is_undefined(_on_rejected)) {
            _on_rejected = _default_on_rejected;
        }
        
        var new_promise = new Promise(function() {});
        if (state == PROMISE_STATE.pending) {
            _add_resolve_callback(_on_fulfilled, new_promise);
            _add_reject_callback(_on_rejected, new_promise);
        }
        else if (state == PROMISE_STATE.fulfilled) {
            try {
                var result = _on_fulfilled(value);
                if (struct_is_of_type(result, "Promise")) {
                    array_push(result.resolve_callbacks, new_promise._fulfill);
                    array_push(result.reject_callbacks, new_promise._reject);
                }
                else {
                    new_promise._fulfill(result);
                }
            }
            catch (_exception) {
                new_promise._reject(string(_exception));
            };
        }
        else if (state == PROMISE_STATE.rejected) {
            try {
                var result = _on_rejected(reason);
                if (struct_is_of_type(result, "Promise")) {
                    array_push(result.resolve_callbacks, new_promise._fulfill);
                    array_push(result.reject_callbacks, new_promise._reject);
                }
                else {
                    new_promise._fulfill(result);
                }
            }
            catch (_exception) {
                new_promise._reject(string(_exception));
            };
        }
        return new_promise;
    }
    
    /// Adds a rejection handler to this promise.
    /// Returns a new promise that resolves to the return value of
    /// the rejection handler if it's called or to the original fulfillment
    /// value if the original promise is resolved instead.
    static and_catch = function(_on_rejected/*: (function<any, void>)*/) /*-> Promise*/
    {
        static _on_fulfilled = function(value) {
            return value;
        };
        return and_then(_on_fulfilled, _on_rejected);
    }
    
    static and_finally = function(_on_settled)
    {
        throw "Not implemented yet.";
    }
    
    static _add_resolve_callback = function(_on_fulfilled/*: (function<any, void>)*/, _new_promise/*: (function<any, void>)*/)
    {
        array_push(resolve_callbacks, method({_on_fulfilled: _on_fulfilled, _new_promise: _new_promise}, function(_value) {
            try {
                var result = _on_fulfilled(_value);
                if (struct_is_of_type(result, "Promise")) {
                    array_push(result.resolve_callbacks, _new_promise._fulfill);
                    array_push(result.reject_callbacks, _new_promise._reject);
                }
                else {
                    _new_promise._fulfill(result);
                }
            }
            catch (_exception) {
                _new_promise._reject(string(_exception));
            };
        }));
    }
    
    static _add_reject_callback = function(_on_rejected/*: (function<any, void>)*/, _new_promise/*: (function<any, void>)*/)
    {
        array_push(reject_callbacks, method({_on_rejected: _on_rejected, _new_promise: _new_promise}, function(_reason) {
            try {
                var result = _on_rejected(_reason);
                if (struct_is_of_type(result, "Promise")) {
                    array_push(result.resolve_callbacks, _new_promise._fulfill);
                    array_push(result.reject_callbacks, _new_promise._reject);
                }
                else {
                    _new_promise._fulfill(result);
                }
            }
            catch (_exception) {
                _new_promise._reject(string(_exception));
            };
        }));
    }
    
    static _execute = function()
    {
        try {
            executor(self._fulfill, self._reject);
        }
        catch (_exception) {
            _reject(string(_exception));
        }
    }
    
    function _fulfill(_value/*: any*/)
    {
        if (state == PROMISE_STATE.pending) {
            state = PROMISE_STATE.fulfilled;
            value = _value;
            for (var i = 0, len = array_length(resolve_callbacks); i < len; ++i) {
                var cb = resolve_callbacks[@ i];
                cb(_value);
            }
        }
    }
    
    function _reject(_reason/*: any*/)
    {
        if (state == PROMISE_STATE.pending) {
            state = PROMISE_STATE.rejected;
            reason = _reason;
            for (var i = 0, len = array_length(reject_callbacks); i < len; ++i) {
                var cb = reject_callbacks[@ i];
                cb(_reason);
            }
        }
    }
    
    if (global.__promises_delayed_execution) {
        ds_queue_enqueue(__get_promise_event_loop().queue, self);
    }
    else {
        _execute();
        // Check for rejected promises with no catchers
        if (state == PROMISE_STATE.rejected && array_length(reject_callbacks) == 0 && global.__promises_uncaught_reject_handler != undefined) {
            global.__promises_uncaught_reject_handler(self);
        }
    }
    
}


function promise_resolve(value/*: any*/ = undefined) /*-> Promise*/
{
    var executor = method({ value: value }, function(resolve, reject) {
        resolve(value);
    });
    return new Promise(executor);
}

function promise_reject(reason/*: any*/ = undefined) /*-> Promise*/
{
    var executor = method({ reason: reason }, function(resolve, reject) {
        reject(reason);
    });
    return new Promise(executor);
}

function promise_all(promises/*: Promise[]*/) /*-> Promise*/
{
    if (array_length(promises) == 0) {
        return promise_resolve([]);
    }
    
    return new Promise(method({ promises: promises }, function (_resolve, _reject) {
        var state = {
            num_of_resolved: 0,
            rejected: false,
            values_array: array_create(array_length(promises)),
            resolve: _resolve,
            reject: _reject
        };
        for (var i = 0, len = array_length(promises); i < len; ++i) {
            var promise = promises[@ i];
            promise
                .and_then(method({ state: state, i: i }, function(value) {
                    if (!state.rejected) {
                        state.values_array[@ i] = value;
                        state.num_of_resolved += 1;
                        if (state.num_of_resolved >= array_length(state.values_array)) {
                            state.resolve(state.values_array);
                        }
                    }
                }))
                .and_catch(method({ state: state }, function(reason) {
                    state.rejected = true;
                    state.reject(reason);
                }));
        } 
    }));
}

function promise_any(promises/*: Promise[]*/) /*-> Promise*/
{
    return new Promise(method({ promises: promises }, function (_resolve, _reject) {
        var state = {
            num_of_rejected: 0,
            resolved: false,
            reasons_array: array_create(array_length(promises)),
            resolve: _resolve,
            reject: _reject
        };
        for (var i = 0, len = array_length(promises); i < len; ++i) {
            var promise = promises[@ i];
            promise
                .and_then(method({ state: state }, function(value) {
                    state.resolved = true;
                    state.resolve(value);
                }))
                .and_catch(method({ state: state, i: i }, function(reason) {
                    if (!state.resolved) {
                        state.reasons_array[@ i] = reason;
                        state.num_of_rejected += 1;
                        if (state.num_of_rejected >= array_length(state.reasons_array)) {
                            state.reject(state.reasons_array);
                        }
                    }
                }));
        } 
    }));
}

function promise_race(promises/*: Promise[]*/) /*-> Promise*/
{
    return new Promise(method({ promises: promises }, function (resolve, reject) {
        for (var i = 0, len = array_length(promises); i < len; ++i) {
            var promise = promises[@ i];
            promise.and_then(resolve).and_catch(reject);
        }
    }));
}

function promise_all_settled(promises/*: Promise[]*/) /*-> Promise*/
{
    return new Promise(method({ promises: promises }, function (_resolve, _reject) {
        var numPromises = array_length(promises);
        var state = {
            results: array_create(numPromises),
            num_of_non_settled: numPromises,
            resolve: _resolve,
            reject: _reject
        };
        for (var i = 0, len = array_length(promises); i < len; ++i) {
            var promise = promises[@ i];
            promise.and_then(method({ state: state, i: i }, function(_value) {
                state.results[@ i] = {
                    status: "fulfilled",
                    value: _value
                };
                state.num_of_non_settled -= 1;
                if (state.num_of_non_settled <= 0) {
                    state.resolve(state.results);
                }
            }))
            .and_catch(method({ state: state, i: i }, function(_reason) {
                state.results[@ i] = {
                    status: "rejected",
                    reason: _reason
                };
                state.num_of_non_settled -= 1;
                if (state.num_of_non_settled <= 0) {
                    state.resolve(state.results);
                }
            }));
        }
    }));
}

function promises_set_uncaught_handler(handler/*: (function<Promise, void>)*/)
{
    global.__promises_uncaught_reject_handler = handler;
}

function promises_enable_debug(enabled/*: bool*/)
{
    global.__promises_debug_enabled = enabled;
}

function promises_enable_delayed_execution(enabled/*: bool*/)
{
    global.__promises_delayed_execution = enabled;
}

function promises_is_promise(promise/*: any*/) /*-> bool*/
{
    return (promise != undefined) && is_struct(promise) && (instanceof(promise) == "Promise");
}

global.__promises_uncaught_reject_handler = undefined;  /// @is {function<Promise, void>?}
global.__promises_debug_enabled = false;                /// @is {bool}
global.__promises_delayed_execution = false;            /// @is {bool}

function __get_promise_event_loop() /*-> __obj_gu_promise_event_loop*/
{
    if (!instance_exists(__obj_gu_promise_event_loop)) {
        instance_create_depth(0, 0, 0, __obj_gu_promise_event_loop);
    }
    return instance_find(__obj_gu_promise_event_loop, 0);
}