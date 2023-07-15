
/// @desc   Constructs a new iterable using the given iterator.
///         The iterator should have Get and MoveNext methods defined.
/// @param {struct} iterator
function Iterable(_iterator) constructor
{
    iterator = _iterator;
    
    /// @desc   Returns a new iterable whose elements are the results
    ///         of invoking the mapping function on the original element.
    /// @param {function(element, index)=>mappedElement} mapFunc
    /// @return {Iterable} A new iterable
    static map = function(_mapFunc)
    {
        return new Iterable({
            it: iterator,
            mapFunc: _mapFunc,
            index: -1,
            Get: function() {
                return mapFunc(it.Get(), index);
            },
            MoveNext: function() {
                if (it.MoveNext()) {
                    ++index;
                    return true;
                }
                return false;
            }
        });
    }
    
    /// @desc   Returns a new iterable that produces the elements of the original
    ///         iterable only if the pass the given filter function.
    /// @param {function(element, index)=>bool} filterFunc
    /// @param {bool} inverse=false If true, the filter function's return value is inversed.
    /// @return {Iterable} A new iterable
    static filter = function(_filterFunc, _inversed)
    {
        if (is_undefined(_inversed)) {
            _inversed = false;
        }
        return new Iterable({
            it: iterator,
            filterFunc: _filterFunc,
            inversed: _inversed,
            index: -1,
            Get: iterator.Get,
            MoveNext: function() {
                while (true) {
                    if (!it.MoveNext()) {
                        return false;
                    }
                    ++index;
                    var filterResult = filterFunc(Get(), index);
                    if (inversed) {
                        filterResult = !filterResult;
                    }
                    if (filterResult) {
                        return true;
                    }
                }
            }
        });
    }
    
    /// @desc   Applies the given accumulation function (reduce function) to all
    ///         the elements of this iterable and returns the final result.
    /// @param {function(accumulator, element, index)=>value}   reduceFunc
    /// @param {*}                                              initialValue
    /// @return {*} The final value.
    static reduce = function(_reduceFunc, _initialValue)
    {
        var accumulator = _initialValue;
        var index = 0;
        while (iterator.MoveNext()) {
            accumulator = _reduceFunc(accumulator, iterator.Get(), index++);
        }
        return accumulator;
    }
    
    static map_to_var = function(variableName)
    {
        var mapFunc = method({ variableName: variableName }, function(structOrInstance) {
            return is_struct(structOrInstance)
                ? variable_struct_get(structOrInstance, variableName)
                : variable_instance_get(structOrInstance, variableName);
        });
        return self.map(mapFunc);
    }
    
    /// @desc   Checks if all the elements fulfill the given condition function.
    /// @param {function(element)=>bool} conditionFunc
    /// @return {bool}
    static all_fulfill = function(_conditionFunc)
    {
        while (iterator.MoveNext()) {
            if (!_conditionFunc(iterator.Get())) {
                return false;
            }
        }
        return true;
    }
    
    /// @desc   Checks if all the elements equal to the given value.
    /// @param {*} value
    /// @return {bool}
    static all_eq = function(_value)
    {
        while (iterator.MoveNext()) {
            if (iterator.Get() != _value) {
                return false;
            }
        }
        return true;
    }
    
    /// @desc   Checks if any of the elements fulfill the given condition function.
    /// @param {function(element)=>bool} conditionFunc
    /// @return {bool}
    static any = function(_conditionFunc)
    {
        while (iterator.MoveNext()) {
            if (_conditionFunc(iterator.Get())) {
                return true;
            }
        }
        return false;
    }
    
    /// @desc   Checks if any of the elements equal to the given value.
    /// @param {*} value
    /// @return {bool}
    static any_eq = function(_value)
    {
        while (iterator.MoveNext()) {
            if (iterator.Get() == _value) {
                return true;
            }
        }
        return false;
    }
    
    /// @desc   Checks if none of the elements fulfill the given condition function.
    /// @param {function(element)=>bool} conditionFunc
    /// @return {bool}
    static none = function(_conditionFunc)
    {
        while (iterator.MoveNext()) {
            if (_conditionFunc(iterator.Get())) {
                return false;
            }
        }
        return true;
    }
    
    /// @desc   Checks if none of the elements equal to the given value.
    /// @param {*} value
    /// @return {bool}
    static none_eq = function(_value)
    {
        while (iterator.MoveNext()) {
            if (iterator.Get() == _value) {
                return false;
            }
        }
        return true;
    }
    
    /// @desc   Creates an iterable that produces at most the first
    ///         given number of elements from this iterable.
    /// @return {Iterable} A new iterable.
    static take = function(number)
    {
        return new Iterable({
            it: iterator,
            taken: 0,
            number: number,
            Get: iterator.Get,
            MoveNext: function() {
                if (taken++ >= number) {
                    return false;
                }
                return it.MoveNext();
            }
        });
    }
    
    /// @desc   Creates an iterable that produces the elements from the original
    ///         iterable while they fulfill the condition function.
    /// @param {function(element)=>bool} conditionFunc
    /// @return {Iterable} A new iterable.
    static take_while = function(_conditionFunc)
    {
        return new Iterable({
            it: iterator,
            condFunc: _conditionFunc,
            i: 0,
            Get: iterator.Get,
            MoveNext: function() {
                return it.MoveNext() && condFunc(it.Get(), i++);
            }
        });
    }
    
    /// @desc   Creates an iterable that produces the elements from the original
    ///         iterable starting after the Nth element of the original iterable.
    /// @param {number} number
    /// @return {Iterable} A new iterable.
    static skip = function(number)
    {
        return new Iterable({
            it: iterator,
            skipped: 0,
            number: number,
            Get: iterator.Get,
            MoveNext: function() {
                while (skipped++ < number) {
                    it.MoveNext();
                }
                return it.MoveNext();
            }
        });
    }
    
    /// @desc   Creates an iterable that produces the elements from the original
    ///         iterable starting from the first element that passes the given
    ///         condition function.
    /// @param {function(element)=>bool} conditionFunc
    /// @return {Iterable} A new iterable.
    static skip_while = function(_conditionFunc)
    {
        return new Iterable({
            it: iterator,
            condFunc: _conditionFunc,
            i: 0,
            skipped: false,
            Get: iterator.Get,
            MoveNext: function() {
                while (!skipped && it.MoveNext()) {
                    if (!condFunc(it.Get(), i++)) {
                        skipped = true;
                        return true;
                    }
                }
                return it.MoveNext();
            }
        });
    }
    
    /// @desc   Returns the first element of this iterable or the default value
    ///         if this iterable is empty.
    /// @param {any} defaultValue = undefined
    /// @param {(function<any, bool>)?} conditionFunc = undefined
    /// @return {any} The first element.
    static first = function(_defaultValue = undefined, _conditionFunc = undefined)
    {
        if (is_undefined(_conditionFunc)) {
            return iterator.MoveNext() ? iterator.Get() : _defaultValue;
        }
        else {
            while (iterator.MoveNext()) {
                var value = iterator.Get();
                if (_conditionFunc(value)) {
                    return value;
                }
            }
            return _defaultValue;
        }
    }
    
    /// @desc   Returns the element of the minimum value using the "<" operator against elements.
    ///         The comparison is performed on the transformed value of the element.
    ///         If no transformation function is given, the elements are compared directly.
    ///         If this iterable is empty, returns the default value.
    /// @param {*}                      defaultValue
    /// @param {function(element)=>*}   (optional)transformFunc
    /// @return {*} The minimum element.
    static min_value = function(_defaultValue)
    {
        var _transformFunc = argument_count >= 2 ? argument[1] : undefined;
        if (is_undefined(_transformFunc)) {
            var minValue = undefined;
            while (iterator.MoveNext()) {
                var value = iterator.Get();
                if (is_undefined(minValue) || value < minValue) {
                    minValue = value;
                }
            }
            return is_undefined(minValue) ? _defaultValue : minValue;
        }
        else {
            var minValue = undefined;
            var minTransformedValue = undefined;
            while (iterator.MoveNext()) {
                var value = iterator.Get();
                var transformedValue = _transformFunc(value);
                if (is_undefined(minTransformedValue) || transformedValue < minTransformedValue) {
                    minValue = value;
                    minTransformedValue = transformedValue;
                }
            }
            return is_undefined(minValue) ? _defaultValue : minValue;
        }
    }
    
    /// @desc   Returns the element of the maximum value using the ">" operator against elements.
    ///         The comparison is performed on the transformed value of the element.
    ///         If no transformation function is given, the elements are compared directly.
    ///         If this iterable is empty, returns the default value.
    /// @param {*}                      defaultValue
    /// @param {function(element)=>*}   (optional)transformFunc
    /// @return {*} The maximum element.
    static max_value = function(_defaultValue)
    {
        var _transformFunc = argument_count >= 2 ? argument[1] : undefined;
        if (is_undefined(_transformFunc)) {
            var maxValue = undefined;
            while (iterator.MoveNext()) {
                var value = iterator.Get();
                if (is_undefined(maxValue) || value > maxValue) {
                    maxValue = value;
                }
            }
            return is_undefined(maxValue) ? _defaultValue : maxValue;
        }
        else {
            var maxValue = undefined;
            var maxTransformedValue = undefined;
            while (iterator.MoveNext()) {
                var value = iterator.Get();
                var transformedValue = _transformFunc(value);
                if (is_undefined(maxTransformedValue) || transformedValue > maxTransformedValue) {
                    maxValue = value;
                    maxTransformedValue = transformedValue;
                }
            }
            return is_undefined(maxValue) ? _defaultValue : maxValue;
        }
    }
    
    /// @desc   Executes the given function on each element of this iterable.
    /// @param {function(element)=>void} func
    static for_each = function(_func)
    {
        var i = 0;
        while (iterator.MoveNext()) {
            _func(iterator.Get(), i++);
        }
    }
    
    /// @desc   Creates a new iterable that produces the elements of this iterable
    ///         and then the elements of the given second iterable.
    /// @param {Iterable} secondIterable
    /// @return {Iterable} A new iterable
    static concat = function(_secondIterable)
    {
        return new Iterable({
            firstIt: iterator,
            secondIt: _secondIterable.iterator,
            activeIt: iterator,
            Get: function() {
                return activeIt.Get();
            },
            MoveNext: function() {
                var res = activeIt.MoveNext();
                if (!res && activeIt == firstIt) {
                    activeIt = secondIt;
                    res = secondIt.MoveNext();
                }
                return res;
            }
        });
    }
    
    /// @desc   Creates an array containing the elements of this iterable.
    /// @return {*[]}
    static create_array = function()
    {
        var array = [];
        while (iterator.MoveNext()) {
            array_push(array, iterator.Get());
        }
        return array;
    }
    
    /// @desc   Adds the elements of this iterable to the given ds_list.
    /// @param {ds_list} list
    static add_to_list = function(_list)
    {
        while (iterator.MoveNext()) {
            ds_list_add(_list, iterator.Get());
        }
    }
    
    /// @desc   Enqueues the elements of this iterable to the given ds_queue.
    /// @param {ds_queue} queue
    static enqueue_to_queue = function(_queue)
    {
        while (iterator.MoveNext()) {
            ds_queue_enqueue(_queue, iterator.Get());
        }
    }
    
    /// @desc   Pushes the elements of this iterable to the given ds_stack.
    /// @param {ds_stack} stack
    static push_to_stack = function(_stack)
    {
        while (iterator.MoveNext()) {
            ds_stack_push(_stack, iterator.Get());
        }
    }
}

/// @desc   Creates an iterable that produces the elements of the given array.
/// @param {*[]} array
/// @return {Iterable} A new iterable.
function array_iterable(_array)
{
    return new Iterable({
        array: _array,
        index: -1,
        Get: function() {
            return array[@ index];
        },
        MoveNext: function() {
            if (index < array_length(array) - 1) {
                ++index;
                return true;
            }
            return false;
        }
    });
}

/// @desc   Creates an iterable that produces the elements of the
///         given array in reverse order.
/// @param {*[]} array
/// @return {Iterable} A new iterable.
function array_reverse_iterable(_array)
{
    return new Iterable({
        array: _array,
        index: array_length(_array),
        Get: function() {
            return array[@ index];
        },
        MoveNext: function() {
            if (index > 0) {
                --index;
                return true;
            }
            return false;
        }
    });
}

/// @desc   Creates an iterable that produces the elements of the given ds_list.
/// @param {ds_list} list
/// @return {Iterable} A new iterable.
function list_iterable(_list)
{
    return new Iterable({
        list: _list,
        index: -1,
        Get: function() {
            return list[| index];
        },
        MoveNext: function() {
            if (index < ds_list_size(list) - 1) {
                ++index;
                return true;
            }
            return false;
        }
    });
}

/// @desc   Creates an iterable that produces the elements of the
///         given ds_list in reverse order.
/// @param {ds_list} list
/// @return {Iterable} A new iterable.
function list_reverse_iterable(_list)
{
    return new Iterable({
        list: _list,
        index: ds_list_size(_list),
        Get: function() {
            return list[| index];
        },
        MoveNext: function() {
            if (index > 0) {
                --index;
                return true;
            }
            return false;
        }
    });
}

/// @desc   Creates an iterable that produces the keys of the given ds_map.
/// @param {ds_map} map
/// @return {Iterable} A new iterable
function map_keys_iterable(_map)
{
    return new Iterable({
        map: _map,
        key: undefined,
        initiated: false,
        Get: function() {
            return key;
        },
        MoveNext: function() {
            if (!initiated) {
                key = ds_map_find_first(map);
                initiated = true;
                return !is_undefined(key);
            }
            else {
                key = ds_map_find_next(map, key);
                return !is_undefined(key);
            }
        }
    });
}

/// @desc   Creates an iterable that produces the values of the given ds_map.
/// @param {ds_map} map
/// @return {Iterable} A new iterable
function map_values_iterable(_map)
{
    return new Iterable({
        map: _map,
        key: undefined,
        initiated: false,
        Get: function() {
            return map[? key];
        },
        MoveNext: function() {
            if (!initiated) {
                key = ds_map_find_first(map);
                initiated = true;
                return !is_undefined(key);
            }
            else {
                key = ds_map_find_next(map, key);
                return !is_undefined(key);
            }
        }
    });
}

/// @desc   Creates an iterable that produces the keys and values of the given ds_map.
///         The elements are structs with "key" and "value" fields.
/// @param {ds_map} map
/// @return {Iterable} A new iterable
function map_key_value_pairs_iterable(_map)
{
    return new Iterable({
        map: _map,
        key: undefined,
        initiated: false,
        Get: function() {
            return {
                key: key,
                value: map[? key]
            };
        },
        MoveNext: function() {
            if (!initiated) {
                key = ds_map_find_first(map);
                initiated = true;
                return !is_undefined(key);
            }
            else {
                key = ds_map_find_next(map, key);
                return !is_undefined(key);
            }
        }
    });
}

/// @desc   Creates an iterable that produces the keys (names) of the given struct.
/// @param {struct} struct
/// @return {Iterable} A new iterable.
function struct_keys_iterable(_struct)
{
    return array_iterable(variable_struct_get_names(_struct));
}

/// @desc   Creates an iterable that produces the values of the given struct.
/// @param {struct} struct
/// @return {Iterable} A new iterable.
function struct_values_iterable(_struct)
{
    return struct_keys_iterable(_struct)
        .map(method({ s: _struct}, function(key) {
            return variable_struct_get(s, key);
        }));
}

/// @desc   Creates an iterable that produces the keys (names) and values of the given struct.
///         The elements are structs with "key" and "value" fields.
/// @param {struct} struct
/// @return {Iterable} A new iterable
function struct_key_value_pairs_iterable(_struct)
{
    return struct_keys_iterable(_struct)
        .map(method({ s: _struct}, function(key) {
            return { key: key, value: variable_struct_get(s, key) };
        }));
}

/// @desc   Creates an iterable that produces values starting from the given first
///         value and ending with the given last value. The value is accumulated
///         using the "++" operator on the last value.
/// @param {*} first
/// @param {*} last
/// @return {Iterable} A new iterable
function range_iterable(_first, _last)
{
    return new Iterable({
        first: _first,
        last: _last,
        current: undefined,
        Get: function() {
            return current;
        },
        MoveNext: function() {
            if (current == undefined) {
                current = first;
                return true;
            }
            if (current++ < last) {
                return true;
            }
        }
    });
}

/// @desc   Creates an iterable that produces values starting from the given first
///         value and ending with the given last value. The value is accumulated
///         using the "--" operator on the last value.
/// @param {*} first
/// @param {*} last
/// @return {Iterable} A new iterable
function range_descending_iterable(_first, _last)
{
    return new Iterable({
        first: _first,
        last: _last,
        current: undefined,
        Get: function() {
            return current;
        },
        MoveNext: function() {
            if (current == undefined) {
                current = first;
                return true;
            }
            if (current-- > last) {
                return true;
            }
        }
    });
}

/// @desc   Creates an iterable that produces only the given value.
/// @param {*} value
/// @return {Iterable} A new iterable
function one_iterable(_value)
{
    return new Iterable({
        value: _value,
        initiated: false,
        Get: function() {
            if (initiated) {
                return value;
            }
            throw "Not initiated.";
        },
        MoveNext: function() {
            if (initiated) {
                return false;
            }
            initiated = true;
            return true;
        }
    });
}

/// @desc   Creates an iterable that produces no elements.
/// @return {Iterable} A new iterable.
function empty_iterable()
{
    return new Iterable({
        MoveNext: function() { return false; },
        Get: function() { throw "Empty iterable contains nothing."; }
    });
}
