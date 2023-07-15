event_inherited();

if (!instance_exists(player) || !instance_exists(Trial)) {
    return;
}

x = player.x;
y = player.y;

if (Trial.state <= TRIAL_STATE.initialized) {
    visible = Configs.show_player_marker_at_beginning;
}
else {
    visible = Configs.show_player_marker_while_playing;
}