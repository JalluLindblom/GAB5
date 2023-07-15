event_inherited();

ticker = new Ticker();              /// @is {Ticker}
level = /*#cast*/ undefined;             /// @is {Level}
terrain = /*#cast*/ undefined;           /// @is {Terrain}
rng = /*#cast*/ undefined;               /// @is {Rng}
traits = /*#cast*/ undefined;            /// @is {PersonalityTraits}
is_auto_run = false;                /// @is {bool}
total_score_before_this_trial = 0;  /// @is {number}

max_ticks = ceil(60 * Configs.trial_time);  /// @is {int}

game_speed = 1.0;       /// @is {number}
tick_remainder = 0.0;   /// @is {number}

ended_callback = /*#cast*/ undefined;    /// @is {function<TrialResult>}

hud = noone;    /// @is {obj_trial_hud}

enum TRIAL_STATE
{
    // These are assumed to be in chronological order!
    uninitialized,
    initialized,
    running,
    ended,
    finalized,
}

state = TRIAL_STATE.uninitialized;  /// @is {TRIAL_STATE}
result = undefined;                 /// @is {TrialResult}

initialize = function(
    _level/*: Level*/,
    tick_rng_seed/*: int*/,
    _is_auto_run/*: bool*/ = false,
    _game_speed/*: number*/ = 1,
    _total_score_before_this_trial/*: number*/ = 0
)
{
    level = _level;
    terrain = level_dump(level, _is_auto_run);
    rng = new Rng(tick_rng_seed);
    is_auto_run = _is_auto_run;
    game_speed = _game_speed;
    total_score_before_this_trial = _total_score_before_this_trial;
    
    ticker.initialize(tick_rng_seed);
    
    state = TRIAL_STATE.initialized;
    
    if (!is_auto_run) {
        hud = instance_create_depth(0, 0, 0, obj_trial_hud)
        hud.initialize(id);
    }
    
    log_event("Trial initialized.");
    log_event("Seed: " + string(tick_rng_seed));
    log_event("Level: " + string(_level.name));
}

/// @returns A promise with a trial result if this is not an auto-run trial.
///          The result if this is an auto-run trial.
start = function(_traits/*: PersonalityTraits*/) /*-> Promise<TrialResult>?|TrialResult*/
{
    if (state != TRIAL_STATE.initialized) {
        return undefined;
    }
    
    traits = _traits;
    
    for (var i = 0, len = instance_number(obj_human_player); i < len; ++i) {
        var player = instance_find(obj_human_player, i);
        player.set_traits(traits);
        if (!Trial.is_auto_run) {
            Trial.log_event("Traits and action weights for " + EID(player) + ":\n\n" + personality_traits_print_data(traits) + "\n");
        }
    }
    
    var num_ai_traits_in_configs = array_length(Configs.ai_human_traits);
    for (var i = 0, len = instance_number(obj_human_ai); i < len; ++i) {
        var ai = instance_find(obj_human_ai, i);
        static default_ai_trait_ranges = new PersonalityTraitRanges(
            [ 0.5, 0.5 ],
            [ 0.5, 0.5 ],
            [ 0.5, 0.5 ],
            [ 0.5, 0.5 ],
            [ 0.5, 0.5 ],
        );
        var ai_trait_ranges = default_ai_trait_ranges;
        if (ai.type_number == undefined) {
            if (num_ai_traits_in_configs > 0) {
                ai_trait_ranges = rng.rng_array_get_random(Configs.ai_human_traits);
            }
            else {
                log_error("Configurations don't have any entries in ai_human_traits!");
            }
        }
        else {
            if (ai.type_number >= 0 && ai.type_number < num_ai_traits_in_configs) {
                ai_trait_ranges = Configs.ai_human_traits[ai.type_number];
            }
            else {
                log_error("Human AI \"" + EID(ai, false) + "\" has type number \"" + string(ai.type_number) + "\" but the configurations don't define personality traits for that number.");
            }
        }
        var ai_traits = personality_traits_from_ranges(ai_trait_ranges, rng);
        ai.set_traits(ai_traits);
        if (!Trial.is_auto_run) {
            Trial.log_event("Traits and action weights for " + EID(ai) + ":\n\n" + personality_traits_print_data(ai_traits) + "\n");
        }
    }
    
    state = TRIAL_STATE.running;
    
    log_event("Trial started.");
    
    if (is_auto_run) {
        while (state != TRIAL_STATE.finalized) {
            _step();
        }
        return result;
    }
    else {
        return new Promise(function(resolve, reject) {
            ended_callback = resolve;
        });
    }
}

tick = function() /*-> bool*/
{
    if (result != undefined) {
        return false;
    }
    
    var res_type = undefined /*#as TRIAL_RESULT_TYPE?*/;
        
    if (ticker.spent_ticks >= max_ticks) {
        res_type = TRES_SURVIVED;
    }
    else {
        ticker.tick();
        if (!instance_exists(obj_human_player)) {
            res_type = TRES_PERISHED;
        }
    }
    
    if (res_type != undefined) {
        var time_left = (max_ticks - ticker.spent_ticks);
        var num_monsters_remaining  = instance_number(obj_monster);
        var num_food_remaining      = instance_number(obj_food);
        var num_humans_remaining    = instance_number(obj_human);
        var energy_remaining        = instance_exists(obj_human_player) ? obj_human_player.energy : 0;
        var energy_level            = instance_exists(obj_human_player) ? (obj_human_player.energy / obj_human_player.energy_max) : 0;
        var time_progress           = (ticker.spent_ticks / max_ticks);
        var trial_score             = Configs.trial_score(traits, energy_level, time_progress);
        result = new TrialResult(res_type, time_left, num_monsters_remaining, num_food_remaining, num_humans_remaining, energy_remaining, trial_score);
    }
    
    return true;
}

function log_event(message/*: string*/)
{
    // No logging when auto-running except if log output file is set explicitly.
    if (!is_auto_run || ProgramParams.auto_run_output != undefined) {
        var prefix = "[#55dd55]TRIAL(" + string(real(id)) + ") TICK#" + string(ticker.spent_ticks) + "[/c] ";
        log(prefix + message);
    }
}

function _step()
{
    switch (state) {
        case TRIAL_STATE.uninitialized: {
            // do nothing
            break;
        }
        case TRIAL_STATE.initialized: {
            // do nothing
            break;
        }
        case TRIAL_STATE.running: {
            
            if (game_speed >= 0) {
                tick_remainder += game_speed;
                while (result == undefined && tick_remainder >= 1.0) {
                    tick_remainder -= 1.0;
                    tick();
                }
            }
            else {
                while (tick()) {}
            }
            
            if (result != undefined) {
                state = TRIAL_STATE.ended;
            }
            break;
        }
        case TRIAL_STATE.ended: {
            log_event("Trial ended.");
            if (ended_callback != undefined) {
                ended_callback(result);
            }
            state = TRIAL_STATE.finalized;
            break;
        }
        case TRIAL_STATE.finalized: {
            // do nothing
            break;
        }
    }
}