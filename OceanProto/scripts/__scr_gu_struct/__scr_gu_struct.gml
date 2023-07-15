
function struct_shallow_cloned(struct)
{
    var keys = variable_struct_get_names(struct);
    var n = array_length(keys);
    var clone = {};
    for (var i = 0; i < n; ++i) {
        var key = keys[@ i];
        var value = variable_struct_get(struct, key);
        variable_struct_set(clone, key, value);
    }
    return clone;
}

/// Deep clones the given struct. This concerns inner structs and arrays.
function struct_deep_cloned(struct/*: struct*/) /*-> struct*/
{
	var clonedStruct = {};
	struct_deep_clone(struct, clonedStruct);
	return clonedStruct;
}

/// Deep clones the given source struct into the given destination struct.
/// This concerns inner structs and arrays.
/// 
/// NOTE: This implementation does not check for reference loops, so it will
///       get stuck in an infinite loop if there are any!
function struct_deep_clone(sourceStruct/*: struct*/, destStruct/*: struct*/)
{
	var names = variable_struct_get_names(sourceStruct);
	var numNames = array_length(names);
	for (var i = 0; i < numNames; ++i) {
		var name = names[@ i];
		var value = sourceStruct[$ name];
		if (is_struct(value)) {
			destStruct[$ name] = struct_deep_cloned(value);
		}
		else if (is_array(value)) {
			destStruct[$ name] = array_deep_cloned(value);
		}
		else {
			destStruct[$ name] = value;
		}
	}
}

function struct_is_of_type(struct/*: any*/, typeName/*: string*/) /*-> bool*/
{
	if (is_undefined(struct)) {
		return false;
	}
	if (!is_struct(struct)) {
		return false;
	}
	var actualTypeName = instanceof(struct);
	return is_string(actualTypeName) && actualTypeName == typeName;
}

/// @desc Adds every missing variable from base to struct.
/// @param {struct} target Struct where missing variables are added to.
/// @param {struct} base Struct which has all the variables.
function struct_fill_missing_variables(target, base)
{
	var desiredAttributeNames = variable_struct_get_names(base);
	// Go through every desired attribute in base struct.
	for(var i = 0; i < array_length(desiredAttributeNames); i++)
	{
		var attributeName = desiredAttributeNames[i];
		// Check if attribute exists in target.
		if (!variable_struct_exists(target, attributeName))
		{
			// Add the attribute if it didn't already exists in the target.
			variable_struct_set(target, attributeName, variable_struct_get(base, attributeName));
		}
	}
}

/// Gets the value under the given key from the given struct.
/// Returns the default value if there is no value under that key OR if there is a value
/// but it is not of the requested type.
function struct_get_of_type(struct/*: struct*/, name/*: string*/, type/*: string*/, defaultValue/*: any*/) /*-> any*/
{
	if (variable_struct_exists(struct, name)) {
	    var value = struct[$ name];
	    if (typeof(value) == type) {
	        return value;
	    }
	}
	return defaultValue;
}

function struct_deep_equals(struct1/*: struct*/, struct2/*: struct*/) /*-> bool*/
{
	if (struct1 == struct2) {
		return true;
	}
	
	var names1 = variable_struct_get_names(struct1);
	var names2 = variable_struct_get_names(struct2);
	var namesLen1 = array_length(names1);
	var namesLen2 = array_length(names2);
	if (namesLen1 != namesLen2) {
		return false;
	}
	for (var i = 0; i < namesLen1; ++i) {
		var name = names1[i];
		if (!variable_struct_exists(struct2, name)) {
			return false;
		}
		var value1 = struct1[$ name];
		var value2 = struct2[$ name];
		if (typeof(value1) != typeof(value2)) {
			return false;
		}
		if (is_array(value1)) {
			if (!array_deep_equals(value1, value2)) {
				return false;
			}
		}
		else if (is_struct(value1)) {
			if (!struct_deep_equals(value1, value2)) {
				return false;
			}
		}
		else {
			if (value1 != value2) {
				return false;
			}
		}
	}
	return true;
}

function struct_from_ds_map(map/*: ds_map*/, out_struct/*: struct?*/ = undefined) /*-> struct*/
{
	var struct = out_struct ?? {};
	for (var key = ds_map_find_first(map); key != undefined; key = ds_map_find_next(map, key)) {
		if (is_string(key)) {
			struct[$ key] = map[? key];
		}
	}
	return struct;
}

function struct_to_ds_map(struct/*: struct*/, out_map/*: ds_map?*/ = undefined) /*-> ds_map*/
{
	var map = out_map ?? ds_map_create();
    var names = variable_struct_get_names(struct);
    for (var i = 0, len = array_length(names); i < len; ++i) {
        var name = names[@ i];
        map[? name] = struct[$ name];
    }
    return map;
}
