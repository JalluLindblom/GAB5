event_inherited();

if (mouse_check_button_pressed(mb_left)) {
    dragging_something = dragged_thing != -1;
    return true;
}

if (mouse_check_button_released(mb_left)) {
    dragging_something = false;
    return true;
}

var mx = mouse_x;
var my = mouse_y;
if (!mouse_check_button(mb_left)) {
    
    if (!dragging_something) {
        var dist = 5;
        var top     = (mx >= -dist) && (mx <= window_bbox.get_width() + dist) && (abs(my) < dist);
        var bottom  = (mx >= -dist) && (mx <= window_bbox.get_width() + dist) && (abs(my - window_bbox.get_height()) < dist);
        var left    = (my >= -dist) && (my <= window_bbox.get_height() + dist) && (abs(mx) < dist);
        var right   = (my >= -dist) && (my <= window_bbox.get_height() + dist) && (abs(mx - window_bbox.get_width()) < dist);
        dragged_thing = -1;
        if (top && left) {
            dragged_thing = GUI_WINDOW_DRAGGABLE.top_left;
            mx_offset = mx;
            my_offset = my;
        }
        else if (top && right) {
            dragged_thing = GUI_WINDOW_DRAGGABLE.top_right;
            mx_offset = mx - window_bbox.get_width();
            my_offset = my;
        }
        else if (bottom && right) {
            dragged_thing = GUI_WINDOW_DRAGGABLE.bottom_right;
            mx_offset = mx - window_bbox.get_width();
            my_offset = my - window_bbox.get_height();
        }
        else if (bottom && left) {
            dragged_thing = GUI_WINDOW_DRAGGABLE.bottom_left;
            mx_offset = mx;
            my_offset = my - window_bbox.get_height();
        }
        else if (top) {
            dragged_thing = GUI_WINDOW_DRAGGABLE.top;
            my_offset = my;
        }
        else if (right) {
            dragged_thing = GUI_WINDOW_DRAGGABLE.right;
            mx_offset = mx - window_bbox.get_width();
        }
        else if (bottom) {
            dragged_thing = GUI_WINDOW_DRAGGABLE.bottom;
            my_offset = my - window_bbox.get_height();
        }
        else if (left) {
            dragged_thing = GUI_WINDOW_DRAGGABLE.left;
            mx_offset = mx;
        }
        else {
            var in_window_area = window_bbox.contains_point(mx, my);
            var in_content_area = content_bbox.contains_point(mx, my);
            if (in_window_area && !in_content_area) {
                dragged_thing = GUI_WINDOW_DRAGGABLE.window;
                mx_offset = mx;
                my_offset = my;
            }
        }
        
        var handled = dragged_thing != -1;
        return handled;
    }
    else {
        if (dragged_thing == GUI_WINDOW_DRAGGABLE.window) {
            window_bbox.align_top_left(window_bbox.x1 + mx - mx_offset, window_bbox.y1 + my - my_offset);
        }
        else {
            var x1m = /*#cast*/ undefined /*#as number*/;
            var y1m = /*#cast*/ undefined /*#as number*/;
            var x2m = /*#cast*/ undefined /*#as number*/;
            var y2m = /*#cast*/ undefined /*#as number*/;
            switch (dragged_thing) {
                case GUI_WINDOW_DRAGGABLE.top_left:     x1m = mx; y1m = my; break;
                case GUI_WINDOW_DRAGGABLE.top:          y1m = my;           break;
                case GUI_WINDOW_DRAGGABLE.top_right:    x2m = mx; y1m = my; break;
                case GUI_WINDOW_DRAGGABLE.right:        x2m = mx;           break;
                case GUI_WINDOW_DRAGGABLE.bottom_right: x2m = mx; y2m = my; break;
                case GUI_WINDOW_DRAGGABLE.bottom:       y2m = my;           break;
                case GUI_WINDOW_DRAGGABLE.bottom_left:  x1m = mx; y2m = my; break;
                case GUI_WINDOW_DRAGGABLE.left:         x1m = mx;           break;
            }
            var min_width = 50;
            var min_height = 50;
            if (x1m != undefined) {
                window_bbox.x1 = median(0, window_bbox.x1 + x1m - mx_offset, window_bbox.x2 - min_width);
            }
            if (x2m != undefined) {
                window_bbox.x2 = median(window_bbox.x1 + x2m - mx_offset, window_bbox.x1 + min_width, display_get_gui_width());
            }
            if (y1m != undefined) {
                window_bbox.y1 = median(0, window_bbox.y1 + y1m - my_offset, window_bbox.y2 - min_height);
            }
            if (y2m != undefined) {
                window_bbox.y2 = median(window_bbox.y1 + y2m - my_offset, window_bbox.y1 + min_height, display_get_gui_height());
            }
            if (x1m != undefined || x2m != undefined || y1m != undefined || y2m != undefined) {
                content_resize_event.invoke(id);
            }
        }
        return true;
    }
}