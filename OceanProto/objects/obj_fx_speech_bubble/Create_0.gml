event_inherited();

attached_creature	= noone;	/// @is {obj_creature}
content_sprite		= -1;		/// @is {sprite}
no_bubble			= false;	/// @is {bool}
dir					= 0;		/// @is {number}
life_timer			= 0;		/// @is {number}
infinite			= false;	/// @is {bool}

next_bubbles_queue = undefined; /// @is {struct[]?}

appear_animation_timer = 0;     /// @is {number}
disappear_animation_timer = 0;  /// @is {number}

initialize = function(_attached_creature/*: obj_creature*/, _content_sprite/*: sprite*/, _is_thinking/*: bool*/, _dir/*: number*/, _infinite/*: bool*/, _create_callback/*: (function<obj_fx_speech_bubble, void>)*/)
{
    attached_creature = _attached_creature;
    content_sprite = _content_sprite;
    no_bubble = _is_thinking;
    dir = _dir;
    infinite = _infinite;
    if (no_bubble) {
        sprite_index = -1;
    }
    var is_player = object_is_ancestor_or_child(_attached_creature.object_index, obj_human_player);
    switch (_content_sprite) {
        case spr_emote_hand_waving: {
            sfx_world_play(snd_emote_hand_wave, is_player, random_range(1.0, 1.2));
            break;
        }
        case spr_emote_hand_right: {
            sfx_world_play(snd_emote_hand_right, is_player, random_range(1.0, 1.2));
            break;
        }
        case spr_emote_dagger:
        case spr_emote_knife: {
            //sfx_world_play(snd_emote_dagger, is_player, random_range(1.0, 1.2));
            sfx_world_play(snd_draw_knife, is_player, random_range(1.0, 1.2));
            break;
        }
        case spr_emote_heart: {
            sfx_world_play(snd_emote_heart_up, is_player, random_range(1.0, 1.2));
            break;
        }
        case spr_emote_heart_broken: {
            sfx_world_play(snd_emote_heart_down, is_player, random_range(1.0, 1.2));
            break;
        }
    }
	
	_create_callback(id);
}

enqueue_next = function(_content_sprite/*: sprite*/, _is_thinking/*: bool*/, _dir/*: number*/, _infinite/*: bool*/, _create_callback/*: (function<obj_fx_speech_bubble, void>)*/)
{
    var queue_entry = {
        content_sprite: _content_sprite,
        no_bubble: _is_thinking,
        dir: _dir,
        infinite: _infinite,
		create_callback: _create_callback,
    };
    if (next_bubbles_queue == undefined) {
        life_timer += 30;
        next_bubbles_queue = [ queue_entry ];
    }
    else {
        array_push(next_bubbles_queue, queue_entry);
    }
}