event_inherited();

if (!instance_exists(player)) {
    player = instance_find(obj_human_player, 0);
    if (instance_exists(player)) {
        player.animation_started_event.listen(function(animation/*: CREATURE_ANIMATION*/, time/*: number*/, dir/*: number*/) {
            if (animation == CREATURE_ANIMATION.hurt) {
                flash();
            }
        });
    }
}

if (!instance_exists(player)) {
    return;
}

if (damage_flash_timer > 0) {
    damage_flash_timer -= 1;
}

animated_energy += (player.energy - animated_energy) * 0.25;