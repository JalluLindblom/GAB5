
/// @typedef {ds_map} ds_set

#macro ds_type_set ds_type_map

/// @param {ds_set} set
/// @param {any} value
/// @returns {bool}
function ds_set_exists(set, value)
{
    return ds_map_exists(set, value);
}

/// @returns {ds_set}
function ds_set_create()
{
    return ds_map_create();
}

/// @param {ds_set} set
/// @param {any} value
function ds_set_add(set, value)
{
    ds_map_add(set, value, 0);
}

/// @param {ds_set} set
function ds_set_clear(set)
{
    ds_map_clear(set);
}

/// @param {ds_set} set
/// @param {ds_set} source
function ds_set_copy(set, source)
{
    ds_map_copy(set, source);
}

/// @param {ds_set} set
/// @param {any} value
function ds_set_delete(set, value)
{
    ds_map_delete(set, value);
}

/// @param {ds_set} set
/// @returns {bool}
function ds_set_empty(set)
{
    return ds_map_empty(set);
}

/// @param {ds_set} set
/// @returns {int}
function ds_set_size(set)
{
    return ds_map_size(set);
}

/// @param {ds_set} set
/// @returns {any}
function ds_set_find_first(set)
{
    return ds_map_find_first(set);
}

/// @param {ds_set} set
/// @returns {any}
function ds_set_find_last(set)
{
    return ds_map_find_last(set);
}

/// @param {ds_set} set
/// @param {any} value
/// @returns {any}
function ds_set_find_next(set, value)
{
    return ds_map_find_next(set, value);
}

/// @param {ds_set} set
/// @param {any} value
/// @returns {any}
function ds_set_find_previous(set, value)
{
    return ds_map_find_previous(set, value);
}

/// @param {ds_set} set
/// @param {Array?} array = undefined
/// @returns {Array?}
function ds_set_values_to_array(set, array = undefined)
{
    return (array != undefined) ? ds_map_keys_to_array(set, array) : ds_map_keys_to_array(set);
}

/// @param {ds_set} set
/// @param {string} str
/// @param {bool?} legacy = undefined
function ds_set_read(set, str, legacy = undefined)
{
    return (legacy != undefined) ? ds_map_read(set, str, legacy) : ds_map_read(set, str);
}

/// @param {ds_set} set
/// @returns {string}
function ds_set_write(set)
{
    return ds_map_write(set);
}

/// @param {ds_set} set
function ds_set_destroy(set)
{
    ds_map_destroy(set);
}
