
global._sfx_world_play_times = ds_map_create();     /// @is {ds_map<sound, int>}
global._sfx_world_play_instances = ds_map_create(); /// @is {ds_map<sound, sound_instance>}

function _maybe_play(sound/*: sound*/, gain/*: number*/) /*-> sound_instance*/
{
    if (!ds_map_exists(global._sfx_world_play_times, sound)) {
        global._sfx_world_play_times[? sound] = current_time;
        global._sfx_world_play_instances[? sound] = audio_play_sound(sound, 1, false);
        audio_sound_gain(global._sfx_world_play_instances[? sound], gain, 0);
        return global._sfx_world_play_instances[? sound];
    }
    else {
        var time = global._sfx_world_play_times[? sound];
        var instance = global._sfx_world_play_instances[? sound];
        if (current_time - time >= 100) {
            global._sfx_world_play_times[? sound] = current_time;
            global._sfx_world_play_instances[? sound] = audio_play_sound(sound, 1, false);
            audio_sound_gain(global._sfx_world_play_instances[? sound], gain, 0);
            return global._sfx_world_play_instances[? sound];
        }
        else if (audio_sound_get_gain(global._sfx_world_play_instances[? sound]) < gain) {
            audio_sound_gain(global._sfx_world_play_instances[? sound], gain, 0);
        }
    }
    return -1;
}

function sfx_ui_play(sound/*: sound*/, gain/*: number*/ = 1.0, pitch/*: number*/ = 1.0)
{
    var snd = audio_play_sound(sound, 1, false);
    if (gain != 1.0 ){
        audio_sound_gain(snd, gain, 0);
    }
    if (pitch != 1.0) {
        audio_sound_pitch(snd, pitch);
    }
}

function sfx_world_play(sound/*: sound*/, is_player/*: bool*/, pitch/*: number*/ = 1.0)
{
    if (instance_exists(Trial) && Trial.game_speed < 0) {
        return;
    }
    
    var gain = is_player ? 1.0 : Configs.non_player_sound_volume;
    var snd = _maybe_play(sound, gain);
    if (snd >= 0) {
        audio_sound_pitch(snd, pitch);
    }
}
