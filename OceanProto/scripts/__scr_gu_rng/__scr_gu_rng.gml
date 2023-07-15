
function Rng(_seed/*: int*/) constructor
{
    seed = _seed;   /// @is {int}
    
    // Linear congruential generator algorithm
    // with constants a, c, m from the book series Numerical Recipes.
    
    static a = 1664525;
    static c = 1013904223;
    static m = power(2, 32);
    
    /// @param ...values
    static rng_choose = function()
    {
        return argument[floor(rng_random(1) * argument_count)];
    }
    
    static rng_random = function(n/*: number*/) /*-> number*/
    {
        seed = (a * seed + c) % m;
        
        var _sign = sign(n);
        n = abs(n);
        return (seed / m) * n * _sign;
    }
    
    static rng_random_range = function(x1/*: number*/, x2/*: number*/) /*-> number*/
    {
        seed = (a * seed + c) % m;
        
        var x1Sign = sign(x1);
        x1 = abs(x1);
        var x2Sign = sign(x2);
        x2 = abs(x2);
        var diff = abs(x1 * x1Sign - x2 * x2Sign);
        return (seed / m) * diff + min(x1 * x1Sign, x2 * x2Sign);
    }
    
    static rng_irandom = function(n/*: number*/) /*-> number*/
    {
        seed = (a * seed + c) % m;
        
        var _sign = sign(n);
        n = floor(abs(n));
        return floor((seed / m) * (n + 1)) * _sign;
    }
    
    static rng_irandom_range = function(x1/*: number*/, x2/*: number*/) /*-> number*/
    { 
        seed = (a * seed + c) % m;
        
        var x1Sign = sign(x1);
        x1 = floor(abs(x1));
        var x2Sign = sign(x2);
        x2 = floor(abs(x2));
        var diff = abs(x1 * x1Sign - x2 * x2Sign);
        return floor((seed / m) * (diff + 1) + min(x1 * x1Sign, x2 * x2Sign));
    }
    
    static rng_array_shuffle = function(array/*: Array*/, start_index/*: int*/ = 0, length/*: int*/ = array_length(array) - start_index)
    {
    	var end_len = start_index + length;
    	var last_index = end_len - 1;
    	for (var i = start_index; i < end_len; ++i) {
    		var random_pos = self.rng_irandom_range(i, last_index);
    		var e1 = array[i];
    		array[i] = array[random_pos];
    		array[random_pos] = e1;
    	}
    }
    
    static rng_array_shuffled = function(array/*: Array*/, start_index/*: int*/ = undefined, length/*: int*/ = undefined) /*-> Array*/
    {
    	var new_array = array_copied(array);
    	self.rng_array_shuffle(new_array, start_index, length);
    	return new_array;
    }
    
    static rng_array_get_random = function(array/*: Array*/, start_index/*: int*/ = 0, length/*: int*/ = undefined) /*-> any*/
    {
    	if (length == undefined) length = array_length(array);
    	length = min(length, array_length(array) - start_index);
    	return array[self.rng_irandom_range(start_index, start_index + length - 1)];
    }
    
    static rng_array_get_random_element_or_default = function(array/*: Array*/, defaultValue/*: any*/) /*-> any*/
    {
        return (array_length(array) > 0) ? array[self.rng_irandom(array_length(array) - 1)] : defaultValue;
    }
    
    static rng_array_pop_random = function(array/*: Array*/) /*-> any*/
    {
    	var index = self.rng_irandom(array_length(array) - 1);
    	var value = array[index];
    	array_delete(array, index, 1);
    	return value;
    }
    
    /// Returns a random element from the collective set of all the given arrays.
    static rng_array_get_random_element_from_many = function(arrays/*: Array<Array>*/) /*-> any*/
    {
        var numArrays = array_length(arrays);
        var totalLength = 0;
        for (var i = 0; i < numArrays; ++i) {
            totalLength += array_length(arrays[i]);
        }
        var index = self.rng_irandom(totalLength - 1);
        for (var i = 0; i < numArrays; ++i) {
            var array = arrays[i];
            var len = array_length(array);
            if (index < len) {
                return array[index];
            }
            index -= len;
        }
        return undefined;
    }
}
