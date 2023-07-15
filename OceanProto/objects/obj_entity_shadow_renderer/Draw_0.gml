event_inherited();

if ((statics_surface_needs_redraw || !surface_exists(static_shadows_surface)) && instance_exists(Trial)) {
    
    statics_surface_needs_redraw = false;
    
    var surf_width = Trial.terrain.width * CSIZE;
    var surf_height = Trial.terrain.height * CSIZE;
    static_shadows_surface = __create_or_resize_surface_if_needed(static_shadows_surface, surf_width, surf_height);
    
    surface_set_target(static_shadows_surface);
    draw_clear_alpha(c_black, 0);
    
    for (var i = 0, len = instance_number(obj_foliage); i < len; ++i) {
        var foliage = instance_find(obj_foliage, i);
        var xx = foliage.x;
        var yy = foliage.y;
        var x1 = xx - 30;
        var y1 = yy - 24;
        var x2 = xx + 34;
        var y2 = yy + 40;
        if (foliage.left_is_hole) {
            x1 += 5;
        }
        if (foliage.right_is_hole) {
            x2 -= 12;
        }
        if (foliage.below_is_hole) {
            y2 -= 26;
        }
        if (foliage.above_is_hole) {
            y1 += 5;
        }
        render_rectangle(x1, y1, x2, y2, #ebc054, 0.75, false);
    }
    
    for (var i = 0, len = instance_number(obj_rock); i < len; ++i) {
        var rock = instance_find(obj_rock, i);
        var xx = rock.x;
        var yy = rock.y;
        var x1 = xx - 29;
        var y1 = yy - 24;
        var x2 = xx + 34;
        var y2 = yy + 40;
        render_rectangle(x1, y1, x2, y2, c_black, 0.2, false);
    }
    
    surface_reset_target();
}

if (surface_exists(static_shadows_surface)) {
    draw_surface_ext(static_shadows_surface, 0, 0, 1, 1, 0, c_white, 1);
}

for (var i = 0, len = instance_number(obj_creature); i < len; ++i) {
    var creature = instance_find(obj_creature, i);
    var radius = creature.shadow_radius;
    var xx = creature.x + creature.attack_animation_offset_x;
    var yy = creature.y + creature.attack_animation_offset_y;
    var x1 = xx - radius;
    var y1 = yy - radius / 2;
    var x2 = xx + radius;
    var y2 = yy + radius / 2;
    render_ellipse(x1, y1, x2, y2, c_black, 0.35, false);
}

for (var i = 0, len = instance_number(obj_food); i < len; ++i) {
    var food = instance_find(obj_food, i);
    var radius = 20;
    var xx = food.x;
    var yy = food.y;
    var x1 = xx - radius;
    var y1 = yy - radius / 2;
    var x2 = xx + radius;
    var y2 = yy + radius / 2;
    render_ellipse(x1, y1, x2, y2, c_black, 0.35, false);
}