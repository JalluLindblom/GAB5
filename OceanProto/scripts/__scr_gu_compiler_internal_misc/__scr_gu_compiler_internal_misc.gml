
function __gml_array_reduce(array/*: Array*/, reduceFunction/*: (function<any, any, any>)*/, initialValue/*: any*/) /*-> any*/
{
	var value = initialValue;
	var len = array_length(array);
	for (var i = 0; i < len; i++) {
		value = reduceFunction(value, array[i]);
	}
	return value;
}

function __gml_string_pad_right(str/*: string*/, length/*: number*/, separator/*: string*/ = " ") /*-> string*/
{
	str = string(str);
	if (string_length(separator) == 0) {
		separator = " ";
	}
	while (string_length(str) < length) {
		str += separator;
	}
	return str;
}

function __gml_string_starts_with(str/*: string*/, substr/*: string*/) /*-> bool*/
{
	var substr_len = string_length(substr);
	if (substr_len == 0) {
		return true;
	}
	return string_copy(str, 1, substr_len) == substr;
}

function __gml_string_ends_with(str/*: string*/, substr/*: string*/) /*-> bool*/
{
	var substr_len = string_length(substr);
	if (substr_len == 0) {
		return true;
	}
	var str_len = string_length(str);
	return string_copy(str, 1 + str_len - substr_len, substr_len) == substr;
}

function __gml_array_map(array/*: Array*/, mapFunction/*: (function<any, int, any>|function<any, any>)*/)
{
	for (var i = 0, len = array_length(array); i < len; i++) {
		var originalValue = array[i];
		var newValue = mapFunction(originalValue, i);
		array[i] = newValue;
	}
}

function __gml_array_mapped(array/*: Array*/, mapFunction/*: (function<any, int, any>|function<any, any>)*/) /*-> Array*/
{
	var newArray = __gml_array_copied(array);
	__gml_array_map(newArray, mapFunction);
	return newArray;
}

function __gml_array_copied(array/*: Array*/) /*-> Array*/
{
	var copyArray = array_create(array_length(array));
	array_copy(copyArray, 0, array, 0, array_length(array));
	return copyArray;
}

function execute_function_with_array_of_args(func, arguments)
{
    var n = array_length(arguments);
    switch (n)
    {
        case 0: return func();
        case 1: return func(arguments[@ 0]);
        case 2: return func(arguments[@ 0], arguments[@ 1]);
        case 3: return func(arguments[@ 0], arguments[@ 1], arguments[@ 2] );
        case 4: return func(arguments[@ 0], arguments[@ 1], arguments[@ 2], arguments[@ 3]);
        case 5: return func(arguments[@ 0], arguments[@ 1], arguments[@ 2], arguments[@ 3], arguments[@ 4]);
        case 6: return func(arguments[@ 0], arguments[@ 1], arguments[@ 2], arguments[@ 3], arguments[@ 4], arguments[@ 5]);
        case 7: return func(arguments[@ 0], arguments[@ 1], arguments[@ 2], arguments[@ 3], arguments[@ 4], arguments[@ 5], arguments[@ 6]);
        case 8: return func(arguments[@ 0], arguments[@ 1], arguments[@ 2], arguments[@ 3], arguments[@ 4], arguments[@ 5], arguments[@ 6], arguments[@ 7]);
        case 9: return func(arguments[@ 0], arguments[@ 1], arguments[@ 2], arguments[@ 3], arguments[@ 4], arguments[@ 5], arguments[@ 6], arguments[@ 7], arguments[@ 8]);
        case 10: return func(arguments[@ 0], arguments[@ 1], arguments[@ 2], arguments[@ 3], arguments[@ 4], arguments[@ 5], arguments[@ 6], arguments[@ 7], arguments[@ 8], arguments[@ 9]);
        case 11: return func(arguments[@ 0], arguments[@ 1], arguments[@ 2], arguments[@ 3], arguments[@ 4], arguments[@ 5], arguments[@ 6], arguments[@ 7], arguments[@ 8], arguments[@ 9], arguments[@ 10]);
        case 12: return func(arguments[@ 0], arguments[@ 1], arguments[@ 2], arguments[@ 3], arguments[@ 4], arguments[@ 5], arguments[@ 6], arguments[@ 7], arguments[@ 8], arguments[@ 9], arguments[@ 10], arguments[@ 11]);
        case 13: return func(arguments[@ 0], arguments[@ 1], arguments[@ 2], arguments[@ 3], arguments[@ 4], arguments[@ 5], arguments[@ 6], arguments[@ 7], arguments[@ 8], arguments[@ 9], arguments[@ 10], arguments[@ 11], arguments[@ 12]);
        case 14: return func(arguments[@ 0], arguments[@ 1], arguments[@ 2], arguments[@ 3], arguments[@ 4], arguments[@ 5], arguments[@ 6], arguments[@ 7], arguments[@ 8], arguments[@ 9], arguments[@ 10], arguments[@ 11], arguments[@ 12], arguments[@ 13]);
        case 15: return func(arguments[@ 0], arguments[@ 1], arguments[@ 2], arguments[@ 3], arguments[@ 4], arguments[@ 5], arguments[@ 6], arguments[@ 7], arguments[@ 8], arguments[@ 9], arguments[@ 10], arguments[@ 11], arguments[@ 12], arguments[@ 13], arguments[@ 14]);
        default: return func(arguments[@ 0], arguments[@ 1], arguments[@ 2], arguments[@ 3], arguments[@ 4], arguments[@ 5], arguments[@ 6], arguments[@ 7], arguments[@ 8], arguments[@ 9], arguments[@ 10], arguments[@ 11], arguments[@ 12], arguments[@ 13], arguments[@ 14]);
    }
    return undefined;
};
