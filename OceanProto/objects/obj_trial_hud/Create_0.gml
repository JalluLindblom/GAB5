event_inherited();

time_hud    = instance_create_depth(0, 0, 0, obj_trial_time_hud);   /// @is {obj_trial_time_hud}
energy_hud  = instance_create_depth(0, 0, 0, obj_trial_energy_hud); /// @is {obj_trial_energy_hud}
score_hud   = instance_create_depth(0, 0, 0, obj_trial_score_hud);  /// @is {obj_trial_score_hud}

initialize = function(_trial/*: obj_trial*/)
{
    time_hud.initialize(_trial);
    energy_hud.initialize(_trial);
    score_hud.initialize(_trial);
}