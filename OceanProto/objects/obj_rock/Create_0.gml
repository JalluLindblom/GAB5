event_inherited();

with (obj_entity_shadow_renderer) {
    statics_changed = true;
}
with (obj_obstacles_renderer) {
    statics_changed = true;
}

rocks = []; /// @is {struct[]}

initialize = function(level/*: Level*/, rng/*: Rng*/)
{
    sprite_index = rng.rng_choose(spr_rock_1, spr_rock_2, spr_rock_3, spr_rock_4);
    
    static positions = undefined;
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
    var below_is_hole = (cy >= level.height - 1) || (level.cells[cy + 1][cx].type == LCT_hole);
    var above_is_hole = (cy <= 0) || (level.cells[cy - 1][cx].type == LCT_hole);
    var left_is_hole = (cx >= 0) || (level.cells[cy][cx - 1].type == LCT_hole);
    var right_is_hole = (cx >= level.width - 1) || (level.cells[cy][cx + 1].type == LCT_hole);
    
    array_resize(rocks, 0);
    var pos_deck = random_deck_from_array(positions);
    var n = array_length(positions);
    
    for (var i = 0; i < n; ++i) {
        
        var pos = pos_deck.draw_one(rng);
        
        var xx = lerp(-CSIZE / 2, CSIZE / 2, pos.xx) + rng.rng_irandom_range(-8.0, 8.0);
        var yy = lerp(-CSIZE / 2, CSIZE / 2, pos.yy) + rng.rng_irandom_range(-4.0, 8.0);
        
        // If there's an edge of a hole right where the rock would be, don't spawn it.
        // (because it would look like it partially floats mid-air)
        if (below_is_hole && yy >= 15) {
            continue;
        }
        if (above_is_hole && yy <= -10) {
            continue;
        }
        if (left_is_hole && xx <= -12) {
            continue;
        }
        if (right_is_hole && xx >= 12) {
            continue;
        }
        
        array_push(rocks, {
            sprite: rng.rng_choose(spr_rock_1, spr_rock_2, spr_rock_3, spr_rock_4),
            xx: xx,
            yy: yy,
            xscale: rng.rng_choose(-1, 1),
        });
    }
    
    array_sort(rocks, function(r1, r2) {
        return r1.yy - r2.yy;
    });
}

draw = function(xx/*: number*/, yy/*: number*/)
{
    for (var i = 0, len = array_length(rocks); i < len; ++i) {
        var rock = rocks[i];
        draw_sprite_ext(rock.sprite, 0, xx + rock.xx, yy + rock.yy, rock.xscale, 1, 0, c_white, 1);
    }
}