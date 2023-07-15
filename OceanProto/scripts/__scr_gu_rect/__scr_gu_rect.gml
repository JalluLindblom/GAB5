
/// A structure that represents a rectangle.
function Rect(_x1/*: number*/, _y1/*: number*/, _x2/*: number*/, _y2/*: number*/) constructor
{
    x1 = _x1; /// @is {number}
    y1 = _y1; /// @is {number}
    x2 = _x2; /// @is {number}
    y2 = _y2; /// @is {number}
    
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
    static shrink = function(amount/*: number*/) /*-> Rect*/
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
    
    static expand_left = function(amount/*: number*/) /*-> Rect*/
    {
        x1 -= amount;
        return self;
    }
    
    static expand_right = function(amount/*: number*/) /*-> Rect*/
    {
        x2 += amount;
        return self;
    }
    
    static expand_top = function(amount/*: number*/) /*-> Rect*/
    {
        y1 -= amount;
        return self;
    }
    
    static expand_bottom = function(amount/*: number*/) /*-> Rect*/
    {
        y2 += amount;
        return self;
    }
    
    /// Expands the rectangle, moving all sides outwards by the given amount.
    static expand = function(amount/*: number*/) /*-> Rect*/
    {
        x1 -= amount;
        y1 -= amount;
        x2 += amount;
        y2 += amount;
        return self;
    }
    
    /// Expands this rectangle to fit the other rectangle within it.
    static expand_to_fit_rectangle = function(rectangle/*: Rect*/) /*-> Rect*/
    {
        x1 = min(x1, rectangle.x1);
        y1 = min(y1, rectangle.y1);
        x2 = max(x2, rectangle.x2);
        y2 = max(y2, rectangle.y2);
        return self;
    }
    
    static expand_to_fit_point = function(xx/*: number*/, yy/*: number*/) /*-> Rect*/
    {
        x1 = min(x1, xx);
        y1 = min(y1, yy);
        x2 = max(x2, xx);
        y2 = max(y2, yy);
        return self;
    }
    
    /// Translates this rectangle so that its top left corner
    /// is at the given coordinates.
    static align_top_left = function(left_x/*: number*/, top_y/*: number*/) /*-> Rect*/
    {
        translate(left_x - x1, top_y - y1);
        return self;
    }
    
    static align_left = function(left_x/*: number*/) /*-> Rect*/
    {
        translate(left_x - x1, 0);
        return self;
    }
    
    static align_right = function(right_x/*: number*/) /*-> Rect*/
    {
        translate(right_x - x2, 0);
        return self;
    }
    
    static align_top = function(top_y/*: number*/) /*-> Rect*/
    {
        translate(0, top_y - y1);
        return self;
    }
    
    static align_bottom = function(bottom_y/*: number*/) /*-> Rect*/
    {
        translate(0, bottom_y - y2);
        return self;
    }
    
    static align_center_horizontal = function(center_x/*: number*/) /*-> Rect*/
    {
        translate((center_x - get_width() / 2) - x1, 0);
        return self;
    }
    
    static align_center_vertical = function(center_y/*: number*/) /*-> Rect*/
    {
        translate(0, (center_y - get_height() / 2) - y1);
        return self;
    }
    
    static align_center = function(center_x/*: number*/, center_y/*: number*/) /*-> Rect*/
    {
        align_center_horizontal(center_x);
        align_center_vertical(center_y);
        return self;
    }
    
    static align_horizontally = function(extentsRectangle/*: Rect*/, halign/*: horizontal_alignment*/) /*-> Rect*/
    {
        switch (halign) {
            case fa_left: return align_left(extentsRectangle.x1);
            case fa_center: return align_center_horizontal(extentsRectangle.get_center_x());
            case fa_right: return align_right(extentsRectangle.x2);
        }
        return self;
    }
    
    static align_vertically = function(extentsRectangle/*: Rect*/, valign/*: vertical_alignment*/) /*-> Rect*/
    {
        switch (valign) {
            case fa_top: return align_top(extentsRectangle.y1);
            case fa_middle: return align_center_vertical(extentsRectangle.get_center_y());
            case fa_bottom: return align_bottom(extentsRectangle.y2);
        }
        return self;
    }
    
    static align = function(extentsRectangle/*: Rect*/, halign/*: horizontal_alignment*/, valign/*: vertical_alignment*/) /*-> Rect*/
    {
        align_horizontally(extentsRectangle, halign);
        align_vertically(extentsRectangle, valign);
        return self;
    }
    
    /// Translates all points of this rectangle by the given offset.
    static translate = function(xoffset/*: number*/, yoffset/*: number*/) /*-> Rect*/
    {
        x1 += xoffset;
        y1 += yoffset;
        x2 += xoffset;
        y2 += yoffset;
        return self;
    }
    
    /// Moves the top of this rectangle by the given amount.
    /// Makes sure that the height of this rectangle will not end up being negative.
    static shrink_top = function(amount/*: number*/) /*-> Rect*/
    {
        y1 += amount;
        y1 = min(y1, y2);
        return self;
    }
    
    static fit_left = function(left_x/*: number*/) /*-> Rect*/
    {
        if (x1 < left_x) {
            translate(left_x - x1, 0);
        }
        return self;
    }
    
    static fit_right = function(right_x/*: number*/) /*-> Rect*/
    {
        if (x2 > right_x) {
            translate(right_x - x2, 0);
        }
        return self;
    }
    
    static fit_top = function(top_y/*: number*/) /*-> Rect*/
    {
        if (y1 < top_y) {
            translate(0, top_y - y1);
        }
        return self;
    }
    
    static fit_bottom = function(bottom_y/*: number*/) /*-> Rect*/
    {
        if (y2 > bottom_y) {
            translate(0, bottom_y - y2);
        }
        return self;
    }
    
    static fit = function(left_x/*: number*/, top_y/*: number*/, right_x/*: number*/, bottom_y/*: number*/) /*-> Rect*/
    {
        fit_left(left_x);
        fit_top(top_y);
        fit_right(right_x);
        fit_bottom(bottom_y);
        return self;
    }
    
    static scale = function(scale/*: number*/) /*-> Rect*/
    {
        x1 *= scale;
        y1 *= scale;
        x2 *= scale;
        y2 *= scale;
        return self;
    }
    
    static resize_to_fit_into = function(width/*: number*/, height/*: number*/) /*-> Rect*/
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
    static copied = function() /*-> Rect*/
    {
        return new Rect(x1, y1, x2, y2);
    }
    
    static copy_to = function(otherRectangle/*: Rect*/) /*-> void*/
    {
        otherRectangle.x1 = x1;
        otherRectangle.y1 = y1;
        otherRectangle.x2 = x2;
        otherRectangle.y2 = y2;
    }
    
    static copy_from = function(otherRectangle/*: Rect*/) /*-> void*/
    {
        x1 = otherRectangle.x1;
        y1 = otherRectangle.y1;
        x2 = otherRectangle.x2;
        y2 = otherRectangle.y2;
    }
    
    static equals = function(otherRectangle/*: Rect*/) /*-> bool*/
    {
        return (x1 == otherRectangle.x1)
            && (x2 == otherRectangle.x2)
            && (y1 == otherRectangle.y1)
            && (y2 == otherRectangle.y2);
    }
    
    static is_in_rect = function(other_rect/*: Rect*/) /*-> bool*/
    {
        return rectangle_in_rectangle(x1, y1, x2, y2, other_rect.x1, other_rect.y1, other_rect.x2, other_rect.y2);
    }
    
    static set = function(_x1/*: number*/, _y1/*: number*/, _x2/*: number*/, _y2/*: number*/) /*-> Rect*/
    {
        x1 = _x1;
        y1 = _y1;
        x2 = _x2;
        y2 = _y2;
        return self;
    }
}

/// Makes a rectangle that fits all the given rectangles in it.
/// If the given array is empty, returns undefined.
function rect_fit_all(rect_array/*: Rect[]*/, out_rect/*: Rect?*/ = undefined) /*-> Rect?*/
{
    var num_rects = array_length(rect_array);
    if (num_rects == 0) {
        return undefined;
    }
    if (out_rect == undefined) {
        out_rect = new Rect(0, 0, 0, 0);
    }
    rect_array[@ 0].copy_to(out_rect);
    for (var i = 0; i < num_rects; ++i) {
        out_rect.expand_to_fit_rectangle(rect_array[@ i]);
    }
    return out_rect;
}
