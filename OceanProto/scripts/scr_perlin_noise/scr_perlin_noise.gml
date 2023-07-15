
function PerlinGeneratorCpu2d(_size/*: int*/, rng/*: Rng*/) constructor
{
    size = _size;                                       /// @is {int}
    permutation = __make_perlin_permutation(size, rng); /// @is {int[]}
    
    /// @returns A value between 0 and 1.
    static get = function(xx/*: number*/, yy/*: number*/) /*-> number*/
    {
        var X = floor(xx) & (size - 1);
    	var Y = floor(yy) & (size - 1);
    
    	var xf = xx - floor(xx);
    	var yf = yy - floor(yy);
        
    	var top_right_x    = xf - 1.0;
    	var top_right_y    = yf - 1.0;
    	var top_left_x     = xf;
    	var top_left_y     = yf - 1.0;
    	var bottom_right_x = xf - 1.0;
    	var bottom_right_y = yf;
    	var bottom_left_x  = xf;
    	var bottom_left_y  = yf;
    	
    	var value_top_right    = permutation[@ permutation[@ X + 1] + Y + 1];
    	var value_top_left     = permutation[@ permutation[@ X] + Y + 1];
    	var value_bottom_right = permutation[@ permutation[@ X + 1] + Y];
    	var value_bottom_left  = permutation[@ permutation[@ X] + Y];
    	
    	var dot_top_right    = dot_product(top_right_x,    top_right_y,    __get_constant_vector_x(value_top_right),    __get_constant_vector_y(value_top_right));
    	var dot_top_left     = dot_product(top_left_x,     top_left_y,     __get_constant_vector_x(value_top_left),     __get_constant_vector_y(value_top_left));
    	var dot_bottom_right = dot_product(bottom_right_x, bottom_right_y, __get_constant_vector_x(value_bottom_right), __get_constant_vector_y(value_bottom_right));
    	var dot_bottom_left  = dot_product(bottom_left_x,  bottom_left_y,  __get_constant_vector_x(value_bottom_left),  __get_constant_vector_y(value_bottom_left));
    	
    	var u = __fade(xf);
    	var v = __fade(yf);
    	
    	return 0.5 * (1.0 + lerp(lerp(dot_bottom_left, dot_top_left, v), lerp(dot_bottom_right, dot_top_right, v), u));
    }
}

function __make_perlin_permutation(size/*: int*/, rng/*: Rng*/) /*-> int[]*/
{
	var P = array_create(size);
	for (var i = 0; i < size; i++) {
	    P[@ i] = i;
	}
	rng.rng_array_shuffle(P);
	array_resize(P, size * 2);
	for (var i = 0; i < size; i++){
	    P[@ i + size] = P[@ i];
	}
	return P;
}

function __get_constant_vector_x(v/*: int*/) /*-> number*/
{
	switch (v & 3) {
	    case 0: return 1.0;
	    case 1: return -1.0;
	    case 2: return -1.0;
	}
	return 1.0;
}

function __get_constant_vector_y(v/*: int*/) /*-> number*/
{
	switch (v & 3) {
	    case 0: return 1.0;
	    case 1: return 1.0;
	    case 2: return -1.0;
	}
	return -1.0;
}

function __fade(t/*: number*/) /*-> number*/
{
	return ((6 * t - 15) * t + 10) * t * t * t;
}
