
function __window_Rect(_x1/*: number*/, _y1/*: number*/, _x2/*: number*/, _y2/*: number*/) constructor
{
	x1 = _x1;	/// @is {number}
    y1 = _y1;	/// @is {number}
    x2 = _x2;	/// @is {number}
    y2 = _y2;	/// @is {number}
    
    /// Gets the width of this rectangle.
    static get_width = function() /*-> number*/
    {
        return x2 - x1;
    }
    
    /// Gets the height of this rectangle.
    static get_height = function() /*-> number*/
    {
        return y2 - y1;
    }
    
    static get_area = function() /*-> number*/
    {
        return (x2 - x1) * (y2 - y1);
    }
    
    static get_center_x = function() /*-> number*/
    {
        return (x1 + x2) / 2;
    }
    
    static get_center_y = function() /*-> number*/
    {
        return (y1 + y2) / 2;
    }
    
    /// Shrinks the rectangle, moving all sides inwards by the given amount.
    /// Makes sure that the rectangle does not become of negative width or height.
    static shrink = function(amount/*: number*/) /*-> __window_Rect*/
    {
        x1 += amount;
        y1 += amount;
        x2 -= amount;
        y2 -= amount;
        if (x1 > x2) {
            var xx = (x1 + x2) / 2;
            x1 = xx;
            x2 = xx;
        }
        if (y1 > y2) {
            var yy = (y1 + y2) / 2;
            y1 = yy;
            y2 = yy;
        }
        return self;
    }
    
    static expand_left = function(amount/*: number*/) /*-> __window_Rect*/
    {
        x1 -= amount;
        return self;
    }
    
    static expand_right = function(amount/*: number*/) /*-> __window_Rect*/
    {
        x2 += amount;
        return self;
    }
    
    static expand_top = function(amount/*: number*/) /*-> __window_Rect*/
    {
        y1 -= amount;
        return self;
    }
    
    static expand_bottom = function(amount/*: number*/) /*-> __window_Rect*/
    {
        y2 += amount;
        return self;
    }
    
    /// Expands the rectangle, moving all sides outwards by the given amount.
    static expand = function(amount/*: number*/) /*-> __window_Rect*/
    {
        x1 -= amount;
        y1 -= amount;
        x2 += amount;
        y2 += amount;
        return self;
    }
    
    /// Expands this rectangle to fit the other rectangle within it.
    static expand_to_fit_rectangle = function(rectangle/*: __window_Rect*/) /*-> __window_Rect*/
    {
        x1 = min(x1, rectangle.x1);
        y1 = min(y1, rectangle.y1);
        x2 = max(x2, rectangle.x2);
        y2 = max(y2, rectangle.y2);
        return self;
    }
    
    static expand_to_fit_point = function(xx/*: number*/, yy/*: number*/) /*-> __window_Rect*/
    {
        x1 = min(x1, xx);
        y1 = min(y1, yy);
        x2 = max(x2, xx);
        y2 = max(y2, yy);
        return self;
    }
    
    /// Translates this rectangle so that its top left corner
    /// is at the given coordinates.
    static align_top_left = function(left_x/*: number*/, top_y/*: number*/) /*-> __window_Rect*/
    {
        translate(left_x - x1, top_y - y1);
        return self;
    }
    
    static align_left = function(left_x/*: number*/) /*-> __window_Rect*/
    {
        translate(left_x - x1, 0);
        return self;
    }
    
    static align_right = function(right_x/*: number*/) /*-> __window_Rect*/
    {
        translate(right_x - x2, 0);
        return self;
    }
    
    static align_top = function(top_y/*: number*/) /*-> __window_Rect*/
    {
        translate(0, top_y - y1);
        return self;
    }
    
    static align_bottom = function(bottom_y/*: number*/) /*-> __window_Rect*/
    {
        translate(0, bottom_y - y2);
        return self;
    }
    
    static align_center_horizontal = function(center_x/*: number*/) /*-> __window_Rect*/
    {
        translate((center_x - get_width() / 2) - x1, 0);
        return self;
    }
    
    static align_center_vertical = function(center_y/*: number*/) /*-> __window_Rect*/
    {
        translate(0, (center_y - get_height() / 2) - y1);
        return self;
    }
    
    static align_center = function(center_x/*: number*/, center_y/*: number*/) /*-> __window_Rect*/
    {
        align_center_horizontal(center_x);
        align_center_vertical(center_y);
        return self;
    }
    
    static align_horizontally = function(extentsRectangle/*: __window_Rect*/, halign/*: horizontal_alignment*/) /*-> __window_Rect*/
    {
        switch (halign) {
            case fa_left: return align_left(extentsRectangle.x1);
            case fa_center: return align_center_horizontal(extentsRectangle.get_center_x());
            case fa_right: return align_right(extentsRectangle.x2);
        }
        return self;
    }
    
    static align_vertically = function(extentsRectangle/*: __window_Rect*/, valign/*: vertical_alignment*/) /*-> __window_Rect*/
    {
        switch (valign) {
            case fa_top: return align_top(extentsRectangle.y1);
            case fa_middle: return align_center_vertical(extentsRectangle.get_center_y());
            case fa_bottom: return align_bottom(extentsRectangle.y2);
        }
        return self;
    }
    
    static align = function(extentsRectangle/*: __window_Rect*/, halign/*: horizontal_alignment*/, valign/*: vertical_alignment*/) /*-> __window_Rect*/
    {
        align_horizontally(extentsRectangle, halign);
        align_vertically(extentsRectangle, valign);
        return self;
    }
    
    /// Translates all points of this rectangle by the given offset.
    static translate = function(xoffset/*: number*/, yoffset/*: number*/) /*-> __window_Rect*/
    {
        x1 += xoffset;
        y1 += yoffset;
        x2 += xoffset;
        y2 += yoffset;
        return self;
    }
    
    /// Moves the top of this rectangle by the given amount.
    /// Makes sure that the height of this rectangle will not end up being negative.
    static shrink_top = function(amount/*: number*/) /*-> __window_Rect*/
    {
        y1 += amount;
        y1 = min(y1, y2);
        return self;
    }
    
    static fit_left = function(left_x/*: number*/) /*-> __window_Rect*/
    {
        if (x1 < left_x) {
            translate(left_x - x1, 0);
        }
        return self;
    }
    
    static fit_right = function(right_x/*: number*/) /*-> __window_Rect*/
    {
        if (x2 > right_x) {
            translate(right_x - x2, 0);
        }
        return self;
    }
    
    static fit_top = function(top_y/*: number*/) /*-> __window_Rect*/
    {
        if (y1 < top_y) {
            translate(0, top_y - y1);
        }
        return self;
    }
    
    static fit_bottom = function(bottom_y/*: number*/) /*-> __window_Rect*/
    {
        if (y2 > bottom_y) {
            translate(0, bottom_y - y2);
        }
        return self;
    }
    
    static fit = function(left_x/*: number*/, top_y/*: number*/, right_x/*: number*/, bottom_y/*: number*/) /*-> __window_Rect*/
    {
        fit_left(left_x);
        fit_top(top_y);
        fit_right(right_x);
        fit_bottom(bottom_y);
        return self;
    }
    
    static scale = function(scale/*: number*/) /*-> __window_Rect*/
    {
        x1 *= scale;
        y1 *= scale;
        x2 *= scale;
        y2 *= scale;
        return self;
    }
    
    static resize_to_fit_into = function(width/*: number*/, height/*: number*/) /*-> __window_Rect*/
    {
        var aspectRatio = get_width() / get_height();
        var otherAspectRatio = width / height;
        var ratio = 1;
        if (aspectRatio < otherAspectRatio) {
            ratio = height / get_height();
        }
        else {
            ratio = width / get_width();
        }
        x2 = x1 + get_width() * ratio;
        y2 = y1 + get_height() * ratio;
        return self;
    }
    
    static contains_point = function(x/*: number*/, y/*: number*/) /*-> bool*/
    {
        return x >= x1 && x <= x2 && y >= y1 && y <= y2;
    }
    
    /// Creates a copy of this rectangle.
    static copied = function() /*-> __window_Rect*/
    {
        return new __window_Rect(x1, y1, x2, y2);
    }
    
    static copy_to = function(otherRectangle/*: __window_Rect*/) /*-> void*/
    {
        otherRectangle.x1 = x1;
        otherRectangle.y1 = y1;
        otherRectangle.x2 = x2;
        otherRectangle.y2 = y2;
    }
    
    static copy_from = function(otherRectangle/*: __window_Rect*/) /*-> void*/
    {
        x1 = otherRectangle.x1;
        y1 = otherRectangle.y1;
        x2 = otherRectangle.x2;
        y2 = otherRectangle.y2;
    }
    
    static equals = function(otherRectangle/*: __window_Rect*/) /*-> bool*/
    {
        return (x1 == otherRectangle.x1)
            && (x2 == otherRectangle.x2)
            && (y1 == otherRectangle.y1)
            && (y2 == otherRectangle.y2);
    }
    
    static is_in_rect = function(other_rect/*: __window_Rect*/) /*-> bool*/
    {
        return rectangle_in_rectangle(x1, y1, x2, y2, other_rect.x1, other_rect.y1, other_rect.x2, other_rect.y2);
    }
    
    static set = function(_x1/*: number*/, _y1/*: number*/, _x2/*: number*/, _y2/*: number*/) /*-> __window_Rect*/
    {
        x1 = _x1;
        y1 = _y1;
        x2 = _x2;
        y2 = _y2;
        return self;
    }
}

function __window_file_read_json(filename/*: string*/) /*-> struct|Array|undefined*/
{
	var json_string = __window_file_read_string(filename);
	var json = undefined;
    try {
        json = json_parse(json_string);
    }
    catch (_) { }
    var type = typeof(json);
    if (type != "struct" && type != "array") {
        json = undefined;
    }
    return json;
}

function __window_file_read_string(filename/*: string*/) /*-> string?*/
{
	if (!file_exists(filename)) {
		return undefined;
	}
	
	var buffer = buffer_load(filename);
	if (!buffer_exists(buffer)) {
	    return undefined;
	}
	
	var str = undefined /*#as string?*/;
	if (buffer_get_size(buffer) > 0) {
		str = buffer_read(buffer, buffer_string);
	}
	buffer_delete(buffer);
	return str;
}

function __window_file_write_json(filename/*: string*/, json/*: struct|Array*/)
{
	var json_string = json_stringify(json);
	__window_file_write_string(filename, json_string);
}

function __window_file_write_string(filename/*: string*/, str/*: string*/)
{
	var buf = buffer_create(1024, buffer_grow, 1);
	buffer_write(buf, buffer_text, str);
	buffer_save(buf, filename);
	buffer_delete(buf);
}

function __window_array_contains(array/*: Array*/, value/*: any*/) /*-> bool*/
{
	var len = array_length(array);
	for (var i = 0; i < len; ++i) {
	    if (value == array[i]) {
	        return true;
	    }
	}
	return false;	
}

function __window_array_remove_all(array/*: Array*/, value/*: any*/) /*-> number*/
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


function __window_Event() constructor
{
	handlers = [];      /// @is {function[]}
    once_handlers = []; /// @is {function[]}
    
    /// @param {function} handler
    /// @returns {function} The handler that was given as an argument.
    static listen = function(handler)
    {
        array_push(handlers, handler);
        return handler;
    }
    
    /// @param {function} handler
    /// @return {bool} True iff the handler was removed. False if it's not a listener and couldn't be removed.
    static remove_listener = function(handler)
    {
        for (var i = 0, len = array_length(handlers); i < len; ++i) {
            if (handlers[i] == handler) {
                array_delete(handlers, i, 1);
                return true;
            }
        }
        return false;
    }
    
    static clear = function()
    {
        array_resize(handlers, 0);
        array_resize(once_handlers, 0);
    }
    
    /// @param {function} handler
    /// @returns {function} The handler that was given as an argument.
    static once = function(handler)
    {
        array_push(once_handlers, handler);
        return handler;
    }
    
    /// @returns {bool} True iff this event currently has any listeners.
    static has_listeners = function()
    {
        return array_length(handlers) > 0 || array_length(once_handlers) > 0;
    }
    
    /// @param ...args
    static invoke = function(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15)
    {
        var num_handlers = array_length(handlers);
        if (num_handlers > 0) {
        	for (var i = 0; i < num_handlers; ++i) {
                handlers[i](arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15);
            }
        }
        var num_once_handlers = array_length(once_handlers);
        if (num_once_handlers > 0) {
            for (var i = 0; i < num_once_handlers; ++i) {
                once_handlers[i](arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15);
            }
            array_resize(once_handlers, 0);
        }
    }
}

