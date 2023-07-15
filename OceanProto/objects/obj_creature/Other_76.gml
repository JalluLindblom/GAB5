// "Broadcast Message" event
event_inherited();

if (layer_instance_get_instance(event_data[?"element_id"]) == id && (event_data[? "event_type"] == "sprite event")) {
    var is_player = object_is_ancestor_or_child(object_index, obj_human_player);
    switch (event_data[? "message"]) {
        case "footstep1": {
            var snd = choose(
                snd_footstep_grass_2,
                snd_footstep_grass_3,
            );
            sfx_world_play(snd, is_player, random_range(0.8, 1.2));
            break;
        }
        case "footstep2": {
            var snd = choose(
                snd_footstep_grass_1,
                snd_footstep_grass_4,
                snd_footstep_grass_5,
            );
            sfx_world_play(snd, is_player, random_range(0.8, 1.2));
            break;
        }
    }
}
