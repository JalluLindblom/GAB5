
/// An object pool for structs.
/// Child classes should implement creation and replacing methods
/// for specific structs.
function StructPool() constructor
{
    num_expired = 0;
    expired = [];
    live = [];
    
    /// @param ...rest
    static _create = function() // virtual
    {
        return undefined;
    }
    
    /// @param {any} oldStruct
    /// @param ...rest
    static _replace = function() // virtual
    {
        // Do nothing by default
    }
    
    /// @param ...arguments
    static create_new = function()
    {
        if (num_expired > 0) {
            var old = expired[num_expired - 1];
            --num_expired;
            _replace(old, argument0, argument1, argument2, argument3, argument4, argument5, argument6, argument7, argument8, argument9, argument10, argument11, argument12, argument13, argument14, argument15);
            array_push(live, old);
            return old;
        }
        else {
            var brand_new = _create(argument0, argument1, argument2, argument3, argument4, argument5, argument6, argument7, argument8, argument9, argument10, argument11, argument12, argument13, argument14, argument15);
            array_push(live, brand_new);
            return brand_new;
        }
    }
    
    static expire_all = function()
    {
        array_copy(expired, num_expired, live, 0, array_length(live));
        num_expired += array_length(live);
        array_resize(live, 0);
    }
}

/// Makes a struct pool with the given creation and replacing methods.
/// Alternative to writing a new StructPool inheriting class.
/// 
/// @param create   Function that creates a new struct.
/// @param replace  Function that replaces a struct with a new one.
function make_struct_pool(create, replace)
{
    var pool = new StructPool();
    pool._create = create;
    pool._replace = replace;
    return pool;
}
