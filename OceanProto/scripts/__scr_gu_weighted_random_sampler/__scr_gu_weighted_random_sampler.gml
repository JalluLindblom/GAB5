
function WeightedRandomSampler() constructor
{
	elements = [];      /// @is {__WRS_WeightValuePair[]}
	total_weight = 0;   /// @is {number}
	
	static add = function(element/*: any*/, weight/*: number*/)
	{
	    if (weight <= 0) {
	        return;
	    }
		var pair = new __WRS_WeightValuePair(weight, element);
		array_push(elements, pair);
		total_weight += pair.weight;
	}
	
	static add_sampler = function(sampler/*: WeightedRandomSampler*/, weight/*: number*/)
	{
	    if (weight <= 0) {
	        return;
	    }
		var pair = new __WRS_WeightValuePair(weight, sampler, true);
		array_push(elements, pair);
		total_weight += pair.weight;
	}
	
	static get = function(default_value/*: any*/ = undefined, rng/*: Rng?*/ = undefined) /*-> any*/
	{
	    if (total_weight <= 0) {
	        return default_value;
	    }
	    
		var pos = (rng != undefined) ? rng.rng_random(total_weight) : random(total_weight);
		var element = default_value;
		var current_weight = 0;
		var num_elements = array_length(elements);
		for (var i = 0; i < num_elements && pos > current_weight; i++) {
			var pair = elements[i];
			element = pair.value_is_sampler ? pair.value.get(rng) : pair.value;
			current_weight += pair.weight;
		}
		return element;
	}
	
	static get_ordered_array = function(out_array/*: Array*/, rng/*: Rng?*/ = undefined) /*-> int*/
	{
	    if (total_weight <= 0) {
	        return 0;
	    }
	    
		var queue = ds_priority_create();
		_add_to_priority_queue(1, queue, rng);
		var size = ds_priority_size(queue);
		for (var i = 0; i < size; ++i) {
			out_array[i] = ds_priority_delete_max(queue);
		}
		ds_priority_destroy(queue);
		return size;
	}
	
	static get_num_elements = function() /*-> int*/
	{
		return array_length(elements);
	}
	
	static change_weight_at = function(index/*: int*/, new_weight/*: number*/) /*-> bool*/
	{
		if (index < 0 || index >= array_length(elements)) {
			return false;
		}
		var pair = elements[index];
		var old_weight = pair.weight;
		pair.weight = new_weight;
		total_weight += (new_weight - old_weight);
		return true;
	}
	
	static clear = function()
	{
		array_resize(elements, 0);
		total_weight = 0;
	}
	
	static _add_to_priority_queue = function(sampler_probability/*: number*/, queue/*: ds_priority*/, rng/*: Rng?*/ = undefined)
	{
	    var num_elements = array_length(elements);
		for (var i = 0; i < num_elements; i++) {
			var pair = elements[i];
			var element_probability = pair.weight / total_weight;
			if (pair.value_is_sampler) {
				pair.value._add_to_priority_queue(sampler_probability * element_probability, pair.value, rng);
			}
			else {
			    var v = sampler_probability * element_probability;
			    var probability = (rng != undefined) ? rng.rng_random(v) : random(v);
				ds_priority_add(queue, pair.value, probability);
			}
		}
	}
}

function __WRS_WeightValuePair(_weight/*: number*/, _value/*: any*/, _value_is_sampler/*: bool*/ = false) constructor
{
	weight = _weight;                       /// @is {number}
	value = _value;                         /// @is {any}
	value_is_sampler = _value_is_sampler;   /// @is {bool}
}

/// Creates a WeightedRandomSampler with contents defined in the given array.
/// In the array, every even element is a value and every odd element is the
/// weight of the value before it.
function weighted_random_sampler_from_array(arr/*: Array<any|number>*/) /*-> WeightedRandomSampler*/
{
	var rt = new WeightedRandomSampler();
	for (var i = 0, n = array_length(arr); i < n; i += 2) {
		var value = arr[@ i];
		var weight = arr[@ i + 1];
		rt.add(value, weight);
	}
	return rt;
}
