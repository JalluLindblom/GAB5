
/// Starts a session that submits the trial data to the server as trials are finished.
function server_session_start(user_id/*: string*/, level_filenames/*: string[]*/, total_score/*: number*/, rng/*: Rng*/, preset_traits/*: PersonalityTraits?*/ = undefined) /*-> Promise*/
{
    var capture = {
        level_filenames: array_mapped(level_filenames, _string_replace_backslashes_with_forward_slashes),
        user_id: user_id,
        rng: rng,
        preset_traits: preset_traits,
        total_score: total_score,
    };
    LoadingStatus.set("Loading...");
    return API.user_get_submitted_levels(user_id)
    .and_then(method(capture, function(submitted_level_filenames/*: string[]?*/) {
        
        LoadingStatus.clear();
        if (submitted_level_filenames == undefined) {
            log_error("Failed to get user data.");
            return;
        }
        
        array_map(submitted_level_filenames, _string_replace_backslashes_with_forward_slashes);
        
        // Only consider those submitted levels that are part of the given level batch.
        array_filter(submitted_level_filenames, method({ level_filenames: level_filenames }, function(submitted_filename/*: string*/) {
            return array_contains(level_filenames, submitted_filename);
        }));
        
        // Find the first level that hasn't been submitted yet.
        var next_level_filename = undefined /*#as string?*/;
        for (var i = 0, len = array_length(level_filenames); i < len; ++i) {
            var level_filename = level_filenames[i];
            if (!array_contains(submitted_level_filenames, level_filename)) {
                next_level_filename = level_filename;
                break;
            }
        }
        
        if (next_level_filename == undefined) {
            // All trials have been submitted already.
            session_show_end_menu(user_id, total_score);
            return;
        }
        
        var play_order = array_length(submitted_level_filenames) + 1;
        var c = {
            user_id: user_id,
            next_level_filename: next_level_filename,
            preset_traits: preset_traits,
            play_order: play_order,
            level_filenames: level_filenames,
            trial: undefined /*#as TrialData?*/,
            total_score: total_score,
            rng: rng,
        };
        return _session_run_trial(user_id, next_level_filename, play_order, array_length(level_filenames), preset_traits, total_score, rng)
        .and_then(method(c, function(_trial/*: TrialData*/) {
            trial = _trial;
			return wait_close_all_personality_traits_menus()
			.and_then(function() {
				if (Configs.show_trial_result_menu) {
					return session_show_trial_result_menu(trial, array_length(level_filenames));
				}
				else {
					return true;
				}
			})
            .and_then(function(submit_and_continue/*: bool*/) {
                if (submit_and_continue) {
                    LoadingStatus.set("Submitting...");
                    return API.trial_submit(trial)
                    .and_then(function(submit_success/*: bool*/) {
                        LoadingStatus.clear();
                        if (!submit_success) {
                            show_message("Failed to submit trial data.");
                            game_end();
                            return;
                        }
                        return server_session_start(user_id, level_filenames, total_score + trial.result.trial_score, rng);
                    });
                }
                else {
                    return server_session_start(user_id, level_filenames, total_score + trial.result.trial_score,rng, trial.traits);
                }
            });
        }));
    }));
}

/// Starts a session that doesn't connect to a server.
/// Instead, the trial data is saved as a local file at the end of the session.
function local_session_start(user_id/*: string*/, level_filenames/*: string[]*/, rng/*: Rng*/) /*-> Promise*/
{
	var promise = wait_one_step();
	
	var main_capture = {
		user_id: user_id,
		level_filenames: level_filenames,
		rng: rng,
		total_score: 0,
		trials: [],
	};
	
	for (var i = 0, len = array_length(level_filenames); i < len; ++i) {
		var level_filename = level_filenames[@ i];
		var capture = {
			level_filename: level_filename,
			i: i,
			trial: undefined,
			main_capture: main_capture,
		};
		promise = promise
		.and_then(method(capture, function() {
			return _session_run_trial(main_capture.user_id, level_filename, i + 1, array_length(main_capture.level_filenames), undefined, main_capture.total_score, main_capture.rng);	
		}))
		.and_then(method(capture, function(_trial/*: TrialData*/) {
	        trial = _trial;
	        array_push(main_capture.trials, trial);
	        main_capture.total_score += trial.result.trial_score;
		}))
		.and_then(function() {
			return wait_close_all_personality_traits_menus();
		})
		.and_then(method(capture, function() {
			if (Configs.show_trial_result_menu) {
				return session_show_trial_result_menu(trial, array_length(main_capture.level_filenames));
			}
			else {
				return true;
			}
		}));
	}
	
	promise = promise.and_then(method(main_capture, function() {
		session_show_end_menu(user_id, total_score, trials);
	}))
	.and_catch(log_error);
	
	return promise;
}

function _session_run_trial(
    user_id/*: string*/,
    level_filename/*: string*/,
    play_order/*: int*/,
    total_num_levels/*: int*/,
    preset_traits/*: PersonalityTraits?*/,
    total_score_before_this_trial/*: number*/,
    rng/*: Rng*/
) /*-> Promise<TrialData>*/
{
    var level = level_load_from_file(level_filename);
    var traits = preset_traits ?? new PersonalityTraits(0.5, 0.5, 0.5, 0.5, 0.5);
    var seed = rng.rng_irandom(power(2, 32));
    
    var capture = {
        level: level,
        seed: seed,
        play_order: play_order,
        user_id: user_id,
        level_filename: level_filename,
        traits: traits,
    };
    
    var header_text = LANG("TraitMenu_Title", "TRIAL_NUMBER", string(play_order) + "/" + string(total_num_levels));
    return trial_run(level, seed, traits, header_text, total_score_before_this_trial)
    .and_then(method(capture, function(result/*: TrialResult*/) {
        var num_monsters	= level_get_num_cells_of_type(level, LCT_monster);
        var num_food		= level_get_num_cells_of_type(level, LCT_food);
        var num_humans_h    = level_get_num_cells_of_type(level, LCT_human_random);
        var num_humans_per_type = array_mapped([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], method({ level: level }, function(type_number/*: int*/) {
            return level_get_num_cells_of_type(level, global.all_typed_human_ai_level_cell_types[type_number]);
        }));
        var num_humans      = num_humans_h + array_sum(num_humans_per_type);
        var num_sand		= level_get_num_cells_of_type(level, LCT_sand);
        var level_info		= new TrialLevelInfo(level_filename, play_order, num_monsters, num_food, num_humans, num_humans_h, num_humans_per_type, num_sand);
        return new TrialData(user_id, Configs.configuration_version, GM_version, seed, level_info, traits, result);
    }));
}

function session_show_trial_result_menu(trial/*: TrialData*/, total_num_levels/*: int*/) /*-> Promise<bool>*/
{
    var capture = {
        trial: trial,
        total_num_levels: total_num_levels,
    };
    return new Promise(method(capture, function(resolve, reject) {
        switch (trial.result.type) {
            case TRES_SURVIVED: {
                sfx_ui_play(snd_survived);
                break;
            }
            case TRES_PERISHED: {
                sfx_ui_play(snd_perished);
                break;
            }
        }
        var menu_def = _make_session_trial_result_menu(trial, total_num_levels, resolve);
        create_popup_menu(menu_def, 450);
    }));
}

function session_show_end_menu(user_id/*: string*/, total_score/*: number*/, trials_to_be_downloaded/*: Trial[]?*/ = undefined)
{
    var menu_def = _make_session_end_menu(user_id, total_score, trials_to_be_downloaded);
    create_popup_menu(menu_def, 450);
}

function _make_session_trial_result_menu(trial/*: TrialData*/, total_num_levels/*: int*/, callback/*: (function<bool, void>)*/) /*-> MenuDefinition*/
{
    var headers = /*#cast*/ [
        ME_spacer(1),
        ME_heading(LANG("TrialEndMenu_Title", "TRIAL_NUMBER", string(trial.level_info.play_order) + "/" + string(total_num_levels))),
        ME_spacer(1),
    ] /*#as MenuEntryDefinition[]*/;
    
    var capture =  {
        callback: callback,
    };
    var result_text = "";
    switch (trial.result.type) {
        case TRES_SURVIVED: result_text = LANG("TrialEndMenu_ResultSurvived"); break;
        case TRES_PERISHED: result_text = LANG("TrialEndMenu_ResultPerished"); break;
    }
    if (trial.result.trial_score > 0) {
        result_text += "\n" + LANG("TrialEndMenu_Score", "TRIAL_SCORE", trial.result.trial_score);
    }
    else {
        result_text += "\n" + LANG("TrialEndMenu_NoScore");
    }
    result_text = "[pin_center]" + result_text + "[/]";
    var bodies = /*#cast*/ [
        ME_spacer(0.5),
        ME_text(result_text, false, false),
        ME_spacer(1.0),
        ME_button(LANG("TrialEndMenu_Submit"), method(capture, function() {
            callback(true);
            return MENU_RETURN.close_menu;
        })),
        ME_spacer(0.5),
    ] /*#as MenuEntryDefinition[]*/;
    
    if (DEBUG_MODE) {
        array_push(bodies, ME_function("DEBUG: Rerun level", method(capture, function() {
            callback(false);
            return MENU_RETURN.close_menu;
        })));
    }
    
    var footers = /*#cast*/ [
        ME_spacer(1),
    ] /*#as MenuEntryDefinition[]*/;
    
    return new MenuDefinition(headers, bodies, footers);
}

function _make_session_end_menu(user_id/*: string*/, total_score/*: number*/, trials_to_be_downloaded/*: Trial[]?*/ = undefined) /*-> MenuDefinition*/
{
    var headers = /*#cast*/ [
        ME_spacer(1.0),
        ME_heading(LANG("FinishedMenu_Title")),
        ME_spacer(0.5),
    ] /*#as MenuEntryDefinition[]*/;
    
    var bodies = /*#cast*/ [
        ME_text("[pin_center]" + LANG("FinishedMenu_ScoreText", "TOTAL_SCORE", total_score), false, false),
    ] /*#as MenuEntryDefinition[]*/;
    
    if (trials_to_be_downloaded != undefined) {
        var button_text = "Save results"; // TODO: Localization
        array_append(bodies, [
            ME_spacer(1.0),
            ME_button(button_text, function() {
            	save_trial_results_as_csv(trials);
                return MENU_RETURN.void;
            }),
        ]);
    }
    else if (string_trim(Configs.next_url) != "") {
        var url = string_trim(Configs.next_url);
        url = string_replace_all(url, "{USER_ID}", user_id);
        var obfuscated_total_score = total_score + choose(1, -1) * irandom(Configs.url_score_randomization);
        url = string_replace_all(url, "{TOTAL_SCORE}", string(obfuscated_total_score));
        var button_text = LANG("FinishedMenu_UrlLinkButtonText");
        array_append(bodies, [
            ME_spacer(1.0),
            ME_button(button_text, method({ url: url }, function() {
                url_open(url);
                return MENU_RETURN.void;
            })),
        ]);
    }
    else {
        var body_text = "[pin_center]" + LANG("FinishedMenu_NoLinkText") + "[/]";
        array_append(bodies, [
            ME_spacer(1.0),
            ME_text(body_text, false, false),
        ]);
    }
    
    var footers = /*#cast*/ [
        ME_spacer(1.0),
    ] /*#as MenuEntryDefinition[]*/;
    
    return new MenuDefinition(headers, bodies, footers);
}

function _string_replace_backslashes_with_forward_slashes(str/*: string*/) /*-> string*/
{
    return string_replace_all(str, "\\", "/");
}

function user_get_total_score_of_levels(user_id/*: string*/, level_names/*: string[]*/) /*-> Promise<number>*/
{
	level_names = array_mapped(level_names, function(name/*: string*/) {
		return string_replace_all(name, "\\", "/");
	});
	var c = {
		level_names: level_names,
	};
	return API.user_get_submitted_trials(user_id, ["level_info", "result"])
	.and_then(method(c, function(trials/*: struct[]?*/) {
		if (trials == undefined) {
			log_warning("Failed to get user submitted trials!");
			return 0;
		}
		var total_score = 0;
		for (var i = 0, len = array_length(trials); i < len; ++i) {
			var trial = trials[i];
			var level_filename = string_replace_all(trial.level_info.filename, "\\", "/");
			if (array_contains(level_names, level_filename)) {
				if (variable_struct_exists(trial.result, "trial_score")) {
					total_score += trial.result.trial_score ?? 0;
				}
			}
		}
		return total_score;
	}));
}

function save_trial_results_as_csv(trials/*: TrialData[]*/) /*-> bool*/
{
	var is_browser = (os_browser != browser_not_a_browser);
	if (is_browser) {
		var str = trial_data_as_csv_headers();
			for (var i = 0, len = array_length(trials); i < len; ++i) {
			str += trial_data_as_csv(trials[@ i]);
		}
		html5_download_string_as_file(str, "trials.csv");
		return true;
	}
	else {
		var filename = get_save_filename("*.csv", "trials.csv");
		var file = file_text_open_write(filename);
		if (file < 0) {
			return false;
		}
		file_text_write_string(file, trial_data_as_csv_headers());
		for (var i = 0, len = array_length(trials); i < len; ++i) {
			var trial = trials[@ i];
			var line = trial_data_as_csv(trial);
			file_text_write_string(file, line);
		}
		file_text_close(file);
		return true;
	}
	
	return false;
}
