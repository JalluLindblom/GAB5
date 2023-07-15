
function auto_run_trials(auto_run_configs_filename/*: string*/, output_csv_filename/*: string*/, rng/*: Rng*/) /*-> Promise*/
{
    // These renderers seem to create a memory leak when active in auto-runs...
    // So just destroy them. They won't be created again at any point but
    // it doesn't matter because we'll end the game after auto-run is complete anyway.
    instance_destroy(obj_entity_shadow_renderer);
    instance_destroy(obj_obstacles_renderer);
    
    var auto_run_configs = file_read_json(auto_run_configs_filename) /*#as struct*/;
    if (auto_run_configs == undefined || !is_struct(auto_run_configs)) {
        log_error("Failed to read auto-run configurations.");
        return promise_reject();
    }
    
    var capture = {
        auto_run_configs: auto_run_configs,
        output_csv_filename: output_csv_filename,
        rng: rng,
    };
    log("Starting auto runs of one or more trials...");
    log("Auto run configurations: \"" + auto_run_configs_filename + "\"");
    log("Auto run output file: \"" + output_csv_filename + "\"");
    log("Auto run seed: \"" + string(rng.seed) + "\"");
    return new Promise(method(capture, function(resolve, reject) {
        var runner = instance_create_depth(0, 0, 0, obj_auto_runner);
        runner.initialize(auto_run_configs, output_csv_filename, rng, resolve);
    }))
    .and_then(function() {
        log("Auto runs completed.");
        game_end();
    });
}

function auto_run_trial(
    level_filename/*: string*/,
    play_order/*: int*/,
    traits/*: PersonalityTraits*/,
    seed/*: number*/,
    total_score_before_this_trial/*: number*/
) /*-> Promise<TrialData>*/
{
    Trial = destroy_instance(Trial);
    
    log("Starting auto run #" + string(play_order));
    
    var c = {
        level_filename: level_filename,
        play_order: play_order,
        traits: traits,
        seed: seed,
        total_score_before_this_trial: total_score_before_this_trial,
    };
    return room_goto_or_restart(rm_trial)
    .and_then(method(c, function() {
        Trial = instance_create_depth(0, 0, 0, obj_trial);
        var level = level_load_from_file(level_filename);
        Trial.initialize(level, seed, true, -1, total_score_before_this_trial);
        var result = Trial.start(traits);
        var num_monsters    = level_get_num_cells_of_type(level, LCT_monster);
        var num_food        = level_get_num_cells_of_type(level, LCT_food);
        var num_humans_h    = level_get_num_cells_of_type(level, LCT_human_random);
        var num_humans_per_type = array_mapped([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], method({ level: level }, function(type_number/*: int*/) {
            return level_get_num_cells_of_type(level, global.all_typed_human_ai_level_cell_types[type_number]);
        }));
        var num_humans      = num_humans_h + array_sum(num_humans_per_type);
        var num_sand        = level_get_num_cells_of_type(level, LCT_sand);
        var level_info      = new TrialLevelInfo(level_filename, play_order, num_monsters, num_food, num_humans, num_humans_h, num_humans_per_type, num_sand);
        delete level;
        return new TrialData("", Configs.configuration_version, GM_version, seed, level_info, traits, result);
    }));
}
