event_inherited();

trial = noone;  /// @is {obj_trial}

animated_energy = 0;            /// @is {number}
damage_flash_timer = 0;         /// @is {number}

player = noone;                 /// @is {obj_human_player}

initialize = function(_trial/*: obj_trial*/)
{
    trial = _trial;
}

flash = function()
{
    damage_flash_timer = 20;
}