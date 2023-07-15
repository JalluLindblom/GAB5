event_inherited();

source_creature = noone;    /// @is {obj_creature}
target_creature = noone;    /// @is {obj_creature}

x1 = x; /// @is {number}
y1 = y; /// @is {number}
x2 = x; /// @is {number}
y2 = y; /// @is {number}

image_xscale = 0;
image_yscale = image_xscale;

life_timer = 0; /// @is {number}

offset_x = irandom_range(-10, 10);    /// @is {number}
offset_y = irandom_range(-10, 10);    /// @is {number}

initialize = function(_source_creature/*: obj_creature*/, _target_creature/*: obj_creature*/)
{
    source_creature = _source_creature;
    target_creature = _target_creature;
}