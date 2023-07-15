
function Event() constructor
{
    handlers = [];      /// @is {function[]}
    once_handlers = []; /// @is {function[]}
    
    /// Adds a new handler function to this event.
    /// This handler will be called every time whenever this event is invoked.
    /// @param {function} handler
    /// @returns {function} The handler that was given as an argument.
    static listen = function(handler)
    {
        array_push(handlers, handler);
        return handler;
    }
    
    /// Removes a handler from this event that was previously added with listen().
    /// @param {function} handler
    /// @return {bool} True iff the handler was removed. False if it's not a listener and couldn't be removed.
    static remove_listener = function(handler)
    {
        for (var i = 0, len = array_length(handlers); i < len; ++i) {
            if (handlers[i] == handler) {
                array_delete(handlers, i, 1);
                return true;
            }
        }
        return false;
    }
    
    /// Removes all listeners from this event.
    static clear = function()
    {
        array_resize(handlers, 0);
        array_resize(once_handlers, 0);
    }
    
    /// @param {function} handler
    /// @returns {bool}
    static has_listener = function(handler)
    {
        return array_contains(handlers, handler) || array_contains(once_handlers, handler);
    }
    
    /// Adds a new handler function to this event that will be called only once
    /// the next time that this event is invoked. Then this handler is removed.
    /// @param {function} handler
    /// @returns {function} The handler that was given as an argument.
    static once = function(handler)
    {
        array_push(once_handlers, handler);
        return handler;
    }
    
    /// Adds a new handler function to this event that resolves the returned event.
    /// @returns {Promise} A promise that resolves when when this event is invoked the next time.
    static once_promise = function()
    {
        return new Promise(function(resolve, reject) {
            self.once(resolve);
        });
    }
    
    /// @returns {bool} True iff this event currently has any listeners.
    static has_listeners = function()
    {
        return array_length(handlers) > 0 || array_length(once_handlers) > 0;
    }
    
    /// Invokes this event, calling all its handlers with the arguments
    /// that are given to this function.
    /// @param ...args
    static invoke = function(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15)
    {
        var num_handlers = array_length(handlers);
        var num_once_handlers = array_length(once_handlers);
        if (num_handlers > 0 || num_once_handlers > 0) {
            for (var i = 0; i < num_handlers; ++i) {
                handlers[i](arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15);
            }
            for (var i = 0; i < num_once_handlers; ++i) {
                once_handlers[i](arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15);
            }
            array_resize(once_handlers, 0);
        }
    }
}
