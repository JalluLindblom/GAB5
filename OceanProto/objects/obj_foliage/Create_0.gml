event_inherited();

with (obj_entity_shadow_renderer) {
    statics_changed = true;
}
with (obj_obstacles_renderer) {
    statics_changed = true;
}

foliages = []; /// @is {struct[]}

below_is_hole = false;  /// @is {bool}
above_is_hole = false;  /// @is {bool}
left_is_hole = false;   /// @is {bool}
right_is_hole = false;  /// @is {bool}

image_xscale = 0.8;
image_yscale = image_xscale;

initialize = function(level/*: Level*/, rng/*: Rng*/)
{
    var positions = undefined;
    if (positions == undefined) {
        positions = [];
        for (var xx = 0.2; xx <= 0.8; xx += 0.2) {
            for (var yy = 0.3; yy <= 1.1; yy += 0.4) {
                array_push(positions, { xx: xx, yy: yy });
            }
        }
    }
    
    var cx = floor(x / CSIZE);
    var cy = floor(y / CSIZE);
    below_is_hole = (cy >= level.height - 1) || (level.cells[cy + 1][cx].type == LCT_hole);
    above_is_hole = (cy <= 0) || (level.cells[cy - 1][cx].type == LCT_hole);
    left_is_hole = (cx <= 0) || (level.cells[cy][cx - 1].type == LCT_hole);
    right_is_hole = (cx >= level.width - 1) || (level.cells[cy][cx + 1].type == LCT_hole);
    
    array_resize(foliages, 0);
    var pos_deck = random_deck_from_array(positions);
    var n = array_length(positions);
    
    for (var i = 0; i < n; ++i) {
        
        var pos = pos_deck.draw_one(rng);
        
        var xx = lerp(-CSIZE / 2, CSIZE / 2, pos.xx) + rng.rng_irandom_range(-20.0, 20.0);
        var yy = lerp(-CSIZE / 2, CSIZE / 2, pos.yy) + rng.rng_irandom_range(-8.0, 16.0);
        
        // If there's an edge of a hole right where the foliage would be, don't spawn it.
        // (because it would look like it partially floats mid-air)
        if (below_is_hole && yy >= 15) {
            continue;
        }
        if (above_is_hole && yy <= -10) {
            continue;
        }
        if (left_is_hole && xx <= -8) {
            continue;
        }
        if (right_is_hole && xx >= 8) {
            continue;
        }
        
        array_push(foliages, {
            sprite: rng.rng_choose(
                spr_foliage_1,
                spr_foliage_2,
                spr_foliage_3,
                spr_foliage_4,
            ),
            xx: xx,
            yy: yy,
            xscale: rng.rng_choose(-1, 1),
            blend: rng.rng_choose(#ebcc86, #c4ab70, #a38e5d, #8f7c51),
        });
    }
    
    array_sort(foliages, function(r1, r2) {
        return r1.yy - r2.yy;
    });
}

draw = function(xx/*: number*/, yy/*: number*/)
{
    for (var i = 0, len = array_length(foliages); i < len; ++i) {
        var f = foliages[i];
        var xscale = f.xscale * image_xscale;
        var yscale = image_yscale;
        draw_sprite_ext(f.sprite, 0, xx + f.xx, yy + f.yy, xscale, yscale, image_angle, f.blend, image_alpha);
    }
}