
function initialize_trials()
{
    CALL_ONLY_ONCE
    
    globalvar Trial;    /// @is {obj_trial}
    Trial = noone;
}

function trial_run(level/*: Level*/, seed/*: number*/, traits/*: PersonalityTraits*/, trait_menu_header/*: string?*/, total_score_before_this_trial/*: number*/) /*-> Promise<TrialResult>*/
{
    Trial = destroy_instance(Trial);
    
    var capture = {
        level: level,
        seed: seed,
        traits: traits,
        trait_menu_header: trait_menu_header,
        total_score_before_this_trial: total_score_before_this_trial,
    };
    
    return room_goto_or_restart(rm_trial)
    .and_then(method(capture, function() {
        
        Trial = instance_create_depth(0, 0, 0, obj_trial);
        Trial.initialize(level, seed, false, Configs.game_speed, total_score_before_this_trial);
        
        if (trait_menu_header != undefined) {
            return get_personality_traits_via_menu(traits, trait_menu_header);
        }
    }))
    .and_then(method(capture, function() {
        return Trial.start(traits);
    }));
}

function TrialResult(
    _type/*: TRIAL_RESULT_TYPE*/,
    _time_left/*: number*/,
    _num_monsters_remaining/*: int*/,
    _num_food_remaining/*: int*/,
    _num_humans_remaining/*: int*/,
    _energy_remaining/*: int*/,
    _trial_score/*: int*/
) constructor
{
    type                    = _type;                    /// @is {TRIAL_RESULT_TYPE}
    time_left               = _time_left;               /// @is {number}
    num_monsters_remaining  = _num_monsters_remaining;  /// @is {int}
    num_food_remaining      = _num_food_remaining;      /// @is {int}
    num_humans_remaining    = _num_humans_remaining;    /// @is {int}
    energy_remaining        = _energy_remaining;        /// @is {number}
    trial_score             = _trial_score;             /// @is {number}
}

/// @typedef {string} TRIAL_RESULT_TYPE

globalvar TRES_SURVIVED; /// @is {TRIAL_RESULT_TYPE}
TRES_SURVIVED = "survived";
globalvar TRES_PERISHED; /// @is {TRIAL_RESULT_TYPE}
TRES_PERISHED = "perished";
