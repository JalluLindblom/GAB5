
/// Creates a new array with any number of elements
/// @param ...
function array_create_with() /*-> Array*/
{
	var array = array_create(argument_count);
	for(var i = 0; i < argument_count; ++i) {
		// Add every item to array
		array[i] = argument[i];
	}
	return array;
}

/// Swaps two elements at different indices.
function array_swap(array/*: Array*/, index1/*: int*/, index2/*: int*/)
{
	if (index1 != index2) {
		var element1 = array[index1];
		array[index1] = array[index2];
		array[index2] = element1;
	}
}

/// @returns True if array contains value, otherwise false.
function array_contains(array/*: Array*/, value/*: any*/) /*-> bool*/
{
	var len = array_length(array);
	for (var i = 0; i < len; ++i) {
	    if (value == array[i]) {
	        return true;
	    }
	}
	return false;	
}

/// @returns A random element from array.
function array_get_random(array/*: Array*/, start_index/*: int*/ = 0, length/*: int*/ = undefined) /*-> any*/
{
	if (length == undefined) length = array_length(array);
	length = min(length, array_length(array) - start_index);
	return array[irandom_range(start_index, start_index + length - 1)];
}

/// @returns A random element from array while also removing it.
function array_pop_random(array/*: Array*/, start_index/*: int*/ = 0, length/*: int*/ = undefined) /*-> any*/
{
	if (length == undefined) length = array_length(array);
	length = min(length, array_length(array) - start_index);
	var index = irandom(irandom_range(start_index, start_index + length - 1));
	var value = array[index];
	array_delete(array, index, 1);
	return value;
}

/// Shuffles the array.
function array_shuffle(array/*: Array*/, start_index/*: int*/ = 0, length/*: int*/ = array_length(array) - start_index)
{
	var end_len = start_index + length;
	var last_index = end_len - 1;
	for (var i = start_index; i < end_len; ++i) {
		var random_pos = irandom_range(i, last_index);
		var e1 = array[i];
		array[i] = array[random_pos];
		array[random_pos] = e1;
	}
}

/// @returns {Array} A shuffled copy of the given array without modifying the original.
function array_shuffled(array/*: Array*/, start_index/*: int*/ = 0, length/*: int*/ = array_length(array) - start_index)
{
	var new_array = array_copied(array);
	array_shuffle(new_array, start_index, length);
	return new_array;
}

/// Applies the given function to every element in the array.
/// Modifies the original array.
function array_map(array/*: Array*/, mapFunction/*: (function<any, int, any>|function<any, any>)*/)
{
	for (var i = 0, len = array_length(array); i < len; i++) {
		var originalValue = array[i];
		var newValue = mapFunction(originalValue, i);
		array[i] = newValue;
	}
}

/// Makes a copy of the given array where the mapping function is applied to every element in it.
/// Does not modify the original array.
/// @returns The new mapped array.
function array_mapped(array/*: Array*/, mapFunction/*: (function<any, int, any>|function<any, any>)*/) /*-> Array*/
{
	var newArray = array_copied(array);
	array_map(newArray, mapFunction);
	return newArray;
}

/// Filters out array elements which don't satisfy the filter function condition.
///	Modifies the given array.
function array_filter(array/*: Array*/, filter_function/*: (function<any, bool>)|(function<any, int, bool>)*/)
{
	var len = array_length(array);
	var new_array = array_create(len);
	var new_array_size = 0;
	for (var i = 0; i < len; ++i) {
		var value = array[i];
		if (filter_function(value, i)) {
			new_array[new_array_size++] = value;
		}
	}
	if (new_array_size != len) {
		array_resize(array, new_array_size);
	}
	array_copy(array, 0, new_array, 0, new_array_size);
}

/// Makes a copy of the given array but doesn't include elements that
/// don't satisfy the filter function condition.
/// Does not modify the original array.
/// @returns The new filtered array.
function array_filtered(array/*: Array*/, filter_function/*: (function<any, bool>)|(function<any, int, bool>)*/) /*-> Array*/
{
	var len = array_length(array);
	var new_array = array_create(len);
	var new_array_size = 0;
	for (var i = 0; i < len; ++i) {
		var value = array[i];
		if (filter_function(value, i)) {
			new_array[new_array_size++] = value;
		}
	}
	if (new_array_size != len) {
		array_resize(new_array, new_array_size);
	}
	return new_array;
}

/// Applies a rolling computation to sequential pairs of values in the given array.
function array_reduce(array/*: Array*/, reduceFunction/*: (function<any, any, any>)*/, initialValue/*: any*/) /*-> any*/
{
	var value = initialValue;
	var len = array_length(array);
	for (var i = 0; i < len; i++) {
		value = reduceFunction(value, array[i]);
	}
	return value;
}

function array_sum(array/*: any[]*/) /*-> any*/
{
	var sum = 0;
	var len = array_length(array);
	for (var i = 0; i < len; ++i) {
		sum += array[i];
	}
	return sum;
}

/// Reverses the elements of the given array.
function array_reverse(array/*: Array*/)
{
	var len = array_length(array);
	var halfLen = floor(len / 2);
	for(var i = 0; i < halfLen; i++) {
		var index2 = len - 1 - i;
		var e1 = array[i];
		array[i] = array[index2];
		array[index2] = e1;
	}
}

/// Creates a copy of the given array and reverses the elements of that new array.
///	The original array is not modified.
function array_reversed(array/*: Array*/) /*-> Array*/
{
	var newArray = array_copied(array);
	array_reverse(newArray);
	return newArray;
}

/// Tests whether any (one or more) of the elements in the array pass the given predicate function.
/// @returns True iff any of the elements pass the predicate function.
function array_any(array/*: Array*/, predicate/*: (function<any, bool>)*/) /*-> bool*/
{
	var len = array_length(array);
	for (var i = 0; i < len; ++i) {
		if (predicate(array[i])) {
			return true;
		}
	}
	return false;
}

/// Tests whether any (one or more) of the elements in the array equal to the given value.
/// @returns True iff any of the elements equal to the given value.
function array_any_eq(array/*: Array*/, value/*: any*/) /*-> bool*/
{
	var len = array_length(array);
	for (var i = 0; i < len; ++i) {
		if (array[i] == value) {
			return true;
		}
	}
	return false;
}

/// Tests whether all of the elements in the array pass the given predicate function.
/// @returns True iff all of the elements pass the predicate function.
function array_all(array/*: Array*/, predicate/*: (function<any, bool>)*/) /*-> bool*/
{
	var len = array_length(array);
	for (var i = 0; i < len; ++i) {
		if (!predicate(array[i])) {
			return false;
		}
	}
	return true;
}

/// Tests whether all of the elements in the array equal to the given value.
/// @returns True iff all of the elements equal to the given value.
function array_all_eq(array/*: Array*/, value/*: any*/) /*-> bool*/
{
	var n = array_length(array);
	for (var i = 0; i < n; ++i) {
		if (array[i] != value) {
			return false;
		}
	}
	return true;
}

/// Tests whether none of the elements in the array pass the given predicate function.
/// @returns True iff none of the elements pass the predicate function.
function array_none(array/*: Array*/, predicate/*: (function<any, bool>)*/) /*-> bool*/
{
	var len = array_length(array);
	for (var i = 0; i < len; ++i) {
		if (predicate(array[i])) {
			return false;
		}
	}
	return true;
}

/// Tests whether none of the elements in the array equal to the given value.
/// @returns True iff none of the elements equal to the given value.
function array_none_eq(array/*: Array*/, value/*: any*/) /*-> bool*/
{
	var len = array_length(array);
	for (var i = 0; i < len; ++i) {
		if (array[i] == value) {
			return false;
		}
	}
	return true;
}

/// Performs the given function on every element in the array starting from the first element.
function array_for_each(array/*: Array*/, func/*: (function<any, void>)*/)
{
	var len = array_length(array);
	for (var i = 0; i < len; ++i) {
		func(array[i]);
	}
}

/// Finds the index of the first element that equals to the given value.
/// @returns The index of the found element or -1 if none was found.
function array_first_index_of(array/*: Array*/, value/*: any*/) /*-> int*/
{
	var len = array_length(array);
	for (var i = 0; i < len; ++i) {
		if (array[i] == value) {
			return i;
		}
	}
	return -1;
}

/// Finds the index of the last element that equals to the given value.
/// @returns The index of the found element or -1 if none was found.
function array_last_index_of(array/*: Array*/, value/*: any*/) /*-> int*/
{
	for (var i = array_length(array) - 1; i >= 0; --i) {
		if (array[i] == value) {
			return i;
		}
	}
	return -1;
}

/// Creates a copy of the given array.
/// @returns The copied array.
function array_copied(array/*: Array*/) /*-> Array*/
{
	var copyArray = array_create(array_length(array));
	array_copy(copyArray, 0, array, 0, array_length(array));
	return copyArray;
}

/// Creates a shallow copy of a portion of the given array.
/// Does not modify the original array.
function array_sliced(array/*: Array*/, startIndex/*: int*/, length/*: int*/) /*-> Array*/
{
	var slicedArray = [];
	array_copy(slicedArray, 0, array, startIndex, length);
	return slicedArray;
}

/// Returns the element of the minimum value using the "<" operator against elements.
/// The comparison is performed on the transformed value of the element.
/// If no transformation function is given, the elements are compared directly.
/// If this array is empty, returns the default value.
/// @returns {*} The minimum element.
function array_min(array/*: Array*/, defaultValue/*: any*/ = undefined, transformFunc/*: (function<any, any>)*/ = undefined) /*-> any*/
{
	var minValue = undefined;
	var minTransformedValue = undefined /*#as any*/;
	var len = array_length(array);
	for (var i = 0; i < len; ++i) {
		var value = array[i];
		var transformedValue = value;
		if (transformFunc != undefined) {
			transformedValue = transformFunc(value);
		}
		if (minTransformedValue == undefined || transformedValue < minTransformedValue) {
			minValue = value;
			minTransformedValue = transformedValue;
		}
	}
	return (minValue != undefined) ? minValue : defaultValue;
}

/// Returns the element of the maximum value using the ">" operator against elements.
/// The comparison is performed on the transformed value of the element.
/// If no transformation function is given, the elements are compared directly.
/// If this array is empty, returns the default value.
/// @returns The maximum element.
function array_max(array, defaultValue/*: any*/ = undefined, transformFunc/*: (function<any, any>)*/ = undefined) /*-> any*/
{
	var maxValue = undefined;
	var maxTransformedValue = undefined /*#as any*/;
	var len = array_length(array);
	for (var i = 0; i < len; ++i) {
		var value = array[i];
		var transformedValue = value;
		if (transformFunc != undefined) {
			transformedValue = transformFunc(value);
		}
		if (maxTransformedValue == undefined || transformedValue > maxTransformedValue) {
			maxValue = value;
			maxTransformedValue = transformedValue;
		}
	}
	return (maxValue != undefined) ? maxValue : defaultValue;
}

/// Pushes all the values of the second array to the end of the first array.
function array_append(destArray/*: Array*/, srcArray/*: Array*/) /*-> void*/
{
	array_copy(destArray, array_length(destArray), srcArray, 0, array_length(srcArray));
}

/// Creates a new array that contains all the given arrays
/// appended one after the other.
/// @param ...arrays
function arrays_appended() /*-> Array*/
{
	var totalArray = [];
	for (var i = 0; i < argument_count; ++i) {
		var array = argument[i];
		array_copy(totalArray, array_length(totalArray), array, 0, array_length(array));
	}
	return totalArray;
}

/// Creates a new array that contains all the elements
/// of the given arrays in one flat array.
function arrays_flattened(arrays/*: Array[]*/) /*-> Array*/
{
	var size = 0;
	for (var i = 0, len = array_length(arrays); i < len; ++i) {
		size += array_length(arrays[i]);
	}
	var total_array = array_create(size);
	var k = 0;
	for (var i = 0, len = array_length(arrays); i < len; ++i) {
		var array = arrays[i];
		var len2 = array_length(array);
		array_copy(total_array, k, array, 0, len2);
		k += len2;
	}
	return total_array;
}

/// Same as array_push but only takes one value argument and returns that value.
function array_push_get(array/*: Array*/, value/*: any*/) /*-> any*/
{
	array_push(array, value);
	return value;
}

/// Removes the first element that equals to the given value.
function array_remove_first_of(array/*: Array*/, value/*: any*/)
{
	// TODO: Tests
	var len = array_length(array);
	for (var i = 0; i < len; ++i) {
		if (array[i] == value) {
			array_delete(array, i, 1);
			return;
		}
	}
}

/// Removes all elements that equal to the given value.
/// @returns The number of elements that were removed.
function array_remove_all(array/*: Array*/, value/*: any*/) /*-> number*/
{
	// TODO: Tests
	var n = 0;
	var len = array_length(array);
	for (var i = 0; i < len; ++i) {
		if (array[i] == value) {
			array_delete(array, i, 1);
			--i;
			--len;
			++n;
		}
	}
	return n;
}

/// Checks if two arrays contain a common element.
function arrays_contain_common_element(array1/*: Array*/, array2/*: Array*/) /*-> bool*/
{
	var len1 = array_length(array1);
	var len2 = array_length(array2);
	for (var i = 0; i < len1; ++i) {
		var element1 = array1[i];
		for (var j = 0; j < len2; ++j) {
			var element2 = array2[j];
			if (element1 == element2) {
				return true;
			}
		}
	}
	return false;
}

/// Creates an array with numbers that range from the given min (inclusive) and max (inclusive) values
/// with the given step inverval.
function array_range(minValue/*: number*/, maxValue/*: number*/, step/*: number*/ = 1) /*-> number[]*/
{
	if (maxValue < minValue) {
		return [];
	}
	
	var values = array_create(floor((maxValue - minValue) / step));
	var i = 0;
	for (var value = minValue; value <= maxValue; value += step) {
		values[i++] = value;
	}
	return values;
}

function array_remove_duplicates(array/*: Array*/)
{
	var len = array_length(array);
	for (var i = 0; i < len; ++i) {
		var value = array[i];
		for (var j = 0; j < i; ++j) {
			if (value == array[j]) {
				array_delete(array, i, 1);
				--i;
				--len;
				break;
			}
		}
	}
}

function array_to_chunks(array/*: Array*/, chunkSize/*: int*/) /*-> Array<Array>*/
{
	var len = array_length(array);
	if (chunkSize <= 0 || len <= 0) {
		return [];
	}
	var chunks = [];
	var n = 0;
	for (var i = 0; i < len; i += chunkSize) {
		var chunk = [];
		array_copy(chunk, 0, array, i, chunkSize);
		chunks[n++] = chunk;
	}
	return chunks;
}

function array_sorted(array/*: Array*/, sortTypeOrFunction/*: bool|(function<any, any, number>)*/) /*-> Array*/
{
	var copyArray = array_copied(array);
	array_sort(copyArray, sortTypeOrFunction);
	return copyArray;
}

/// Removes the element at the given index.
/// Moves all values on its right side one index to the left.
/// Assigns the given fillingValue to the last index of the array, because that one doesn't have anything on its right to copy from.
/// The size of the array is not changed.
function array_shift_left(array/*: Array*/, index/*: int*/, fillingValue/*: any*/)
{
	var len = array_length(array);
	for (var i = index; i < len - 1; ++i) {
		array[i] = array[i + 1];
	}
	if (len > 0) {
		array[len - 1] = fillingValue;
	}
}

function array_deep_equals(array1/*: Array*/, array2/*: Array*/) /*-> bool*/
{
	if (array1 == array2) {
		return true;
	}
	
	var len1 = array_length(array1);
	var len2 = array_length(array2);
	if (len1 != len2) {
		return false;
	}
	for (var i = 0; i < len1; ++i) {
		var value1 = array1[i];
		var value2 = array2[i];
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

/// Deep clones the given array. This concerns inner structs and arrays.
/// NOTE: This implementation does not check for reference loops, so it will
///       get stuck in an infinite loop if there are any!
function array_deep_cloned(array/*: Array*/) /*-> Array*/
{
	var len = array_length(array);
	var clonedArray = array_create(len);
	array_copy(clonedArray, 0, array, 0, len);
	for (var i = 0; i < len; ++i) {
		var value = clonedArray[i];
		if (is_struct(value)) {
			clonedArray[i] = struct_deep_cloned(value);
		}
		else if (is_array(value)) {
			clonedArray[i] = array_deep_cloned(value);
		}
	}
	return clonedArray;
}
