event_inherited();

if (instance_exists(initial_speech_bubble) && instance_exists(Trial) && (Trial.state >= TRIAL_STATE.running)) {
    instance_destroy(initial_speech_bubble);
    initial_speech_bubble = noone;
}
