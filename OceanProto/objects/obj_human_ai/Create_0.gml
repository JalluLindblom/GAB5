event_inherited();

// The type number assigned when loading this human from a level.
// The number may be used to change things such as personality traits.
// If undefined, the type is considered "random" or "unpredictable" and the type
// will result will be chosen randomly when generating the level.
type_number = undefined; /// @is {int?}

initial_speech_bubble = noone; /// @is {obj_fx_speech_bubble}

human_ai_initialize = function(_type_number/*: int?*/)
{
    type_number = _type_number;
    
    if (type_number != undefined && instance_exists(Trial) && !Trial.is_auto_run) {
        var callback = function(bubble/*: obj_fx_speech_bubble*/) {
            initial_speech_bubble = bubble;
        }
        switch (type_number) {
            case 1: fx_create_speech_bubble(id, spr_emote_knife, false, 0, true, callback); break;
            case 2: fx_create_speech_bubble(id, spr_emote_hand_right, false, 0, true, callback); break;
        }
        
    }
}

creature_sprites.set(
    spr_human_green_idle,
    spr_human_green_walk,
    spr_human_green_stand,
    spr_human_green_attack,
    spr_human_green_duck,
    spr_human_green_hurt,
    spr_human_green_exchange,
    spr_human_green_hurt
);

shadow_radius = 24;