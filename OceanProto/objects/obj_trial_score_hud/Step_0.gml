event_inherited();

var total_score = trial.total_score_before_this_trial;
if (trial.result != undefined) {
    total_score += trial.result.trial_score;
}

if (score_animation_timer > 0) {
    score_animation_timer -= 1;
}
else {
    score_animation_timer = 3;
    var score_step = Configs.score_animation_increment;
    var prev_animated_score = animated_score;
    if (abs(total_score - animated_score) >= score_step) {
        animated_score += sign(total_score - animated_score) * score_step;
    }
    else {
        animated_score = total_score;
    }
}