event_inherited();

// Change the walking animation's speed based on current moving speed.
// Note: This assumes that all obj_humans use similar walking sprites, so that
// the formula here works!
if (instance_exists(Trial) && Trial.state == TRIAL_STATE.running && sprite_index == creature_sprites.walk) {
    var current_speed = point_distance(x_on_current_tick, y_on_current_tick, x_on_previous_tick, y_on_previous_tick);
    image_speed = Trial.game_speed * (current_speed * 0.25);
}