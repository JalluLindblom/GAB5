event_inherited();

if (Trial.is_auto_run) {
    return;
}

attack_animation_offset_x *= 0.75;
attack_animation_offset_y *= 0.75;

if (sprite_index == -1) {
    sprite_index = creature_sprites.idle;
}

var target_xscale = sign(image_xscale);
var target_yscale = sign(image_yscale);
var image_xscale_multiplier = 1;
var image_yscale_multiplier = 1;

switch (animation) {
    case CREATURE_ANIMATION.attack: {
        if (sprite_index != creature_sprites.attack) {
            sprite_index = creature_sprites.attack;
        }
        target_xscale = -sign(angle_difference(animation_direction, 90));
        break;
    }
    case CREATURE_ANIMATION.miss_attack: {
        if (sprite_index != creature_sprites.attack) {
            sprite_index = creature_sprites.attack;
        }
        target_xscale = -sign(angle_difference(animation_direction, 90));
        break;
    }
    case CREATURE_ANIMATION.duck: {
        if (sprite_index != creature_sprites.duck) {
            sprite_index = creature_sprites.duck;
        }
        target_xscale = -sign(angle_difference(animation_direction, 90));
        break;
    }
    case CREATURE_ANIMATION.hurt: {
        if (sprite_index != creature_sprites.hurt) {
            sprite_index = creature_sprites.hurt;
        }
        target_xscale = -sign(angle_difference(animation_direction, 90));
        break;
    }
    case CREATURE_ANIMATION.exchange: {
        if (sprite_index != creature_sprites.exchange) {
            sprite_index = creature_sprites.exchange;
        }
        target_xscale = -sign(angle_difference(animation_direction, 90));
        if (animation_timer < 10) {
            var xscale_channel = animcurve_get_channel(crv_creature_exchange_scale, "xscale");
            var yscale_channel = animcurve_get_channel(crv_creature_exchange_scale, "yscale");
            var t = animation_timer / 10;
            image_xscale_multiplier = animcurve_channel_evaluate(xscale_channel, t) * 1.0;
            image_yscale_multiplier = animcurve_channel_evaluate(yscale_channel, t) * 1.0;
        }
        break;
    }
    default: {
        
        if (x_on_current_tick == x_on_previous_tick && y_on_current_tick == y_on_previous_tick) {
            time_spend_standing += 1;
            if (time_spend_standing > 60) {
                sprite_index = creature_sprites.idle;
            }
            else if (sprite_index != creature_sprites.idle) {
                sprite_index = creature_sprites.stand;
            }
            target_yscale = 1.0 + (sin((current_time + (id_hash / 1000)) / (200 + id_hash % 100)) * 0.5 - 0.5) * 0.03;
        }
        else {
            time_spend_standing = 0;
            target_yscale = 1.0;
            sprite_index = creature_sprites.walk;
            if (x_on_current_tick > x_on_previous_tick) {
                target_xscale = 1.0;
            }
            else if (x_on_current_tick < x_on_previous_tick) {
                target_xscale = -1.0;
            }
        }
        
        break;
    }
}

if (animation != undefined) {
    animation_timer += 1;
    if (animation_timer > animation_time) {
        animation = undefined;
        animation_timer = 0;
        animation_time = 0;
    }
}

animated_xscale += (target_xscale - image_xscale) * 0.5;
animated_yscale += (target_yscale - image_yscale) * 0.5;

image_xscale = animated_xscale * image_xscale_multiplier;
if (abs(image_xscale) < 0.25) {
    image_xscale = sign(image_xscale) * 0.25;
}
image_yscale = animated_yscale * image_yscale_multiplier;

if (Trial.game_speed >= 0 && Trial.state < TRIAL_STATE.ended) {
    image_speed = Trial.game_speed;
}
else {
    image_speed = 0;
}
