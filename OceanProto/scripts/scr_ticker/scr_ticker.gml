
function Ticker() constructor
{
    rng = /*#cast*/ undefined;   /// @is {Rng}
    handlers = [];          /// @is {_TickHandler[]}
    spent_ticks = 0;        /// @is {int}
    
    static initialize = function(rng_seed/*: number*/)
    {
        rng = new Rng(rng_seed);
    }
    
    static on_tick = function(instance/*: instance*/, callback/*: (function<int, Rng, void>)*/)
    {
        array_push(handlers, new _TickHandler(instance, callback));
    }
    
    static reset = function()
    {
        array_resize(handlers, 0);
    }
    
    static tick = function()
    {
        for (var i = 0, len = array_length(handlers); i < len; ++i) {
            var handler = handlers[i];
            if (!instance_exists(handler.instance)) {
                array_delete(handlers, i, 1);
                --i;
                --len;
            }
            else {
                handler.callback(spent_ticks, rng);
            }
        }
        ++spent_ticks;
    }
    
    static free = function()
    {
        array_resize(handlers, 0);
    }
}

function _TickHandler(_instance/*: instance*/, _callback/*: (function<int, Rng, void>)*/) constructor
{
    instance = _instance;   /// @is {instance}
    callback = _callback;   /// @is {function<int, Rng, void>}
}
