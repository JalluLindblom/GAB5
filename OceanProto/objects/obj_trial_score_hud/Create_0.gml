event_inherited();

trial = noone;  /// @is {obj_trial}

animated_score = 0;         /// @is {number}
score_animation_timer = 0;  /// @is {number}

initialize = function(_trial/*: obj_trial*/)
{
    trial = _trial;
    
    animated_score = trial.total_score_before_this_trial;
    if (trial.result != undefined) {
        animated_score += trial.result.trial_score;
    }
}