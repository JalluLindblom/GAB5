
/// @returns {MenuDefinition}
function make_dev_menu(is_remote_defined/*: bool*/)
{
    var headers = /*#cast*/ [
        
        ME_heading("DEVELOPER MENU"),
        
    ] /*#as MenuEntryDefinition[]*/;
    
    var check_is_remote_defined = method({ is_remote_defined: is_remote_defined }, function() {
    	return is_remote_defined;
    });
    
    var bodies = /*#cast*/ [
        
        ME_spacer(1),
        
        ME_sub_menu("Start session (server)", _make_server_session_start_menu(), check_is_remote_defined),
        
        ME_spacer(1.0),
        
        ME_sub_menu("Start session (local)", _make_local_session_start_menu()),
        
        ME_spacer(1.0),
        
        ME_function("Generate levels", function() {
            
            var rng = new Rng(irandom(power(2, 32)));
            
            var project_directory = build_tools_get_env_var("YYprojectDir");
            var suggested_directory = (project_directory != undefined) ? (project_directory + "\\datafiles") : program_directory;
            var generator_configs_filename = get_open_filename_ext("*.json", "", suggested_directory, "Select a generator file.");
            if (string_trim(generator_configs_filename) == "") {
                return;
            }
            var generator_configs = file_read_json(generator_configs_filename) /*#as struct*/;
            if (generator_configs == undefined || !is_struct(generator_configs)) {
                log_error("Failed to read generator configurations.");
                return;
            }
            
            var default_directory_name = "levels_" + _generated_levels_directory_datetime_string(date_current_datetime());
            var directory_name = get_string("The levels will be generated under a directory.\n\nEnter directory name:", default_directory_name);
            if (string_trim(directory_name) != "") {
                generate_levels_batch_as_files(generator_configs, directory_name, rng);
            }
            return MENU_RETURN.void;
        }),
        
        ME_spacer(1.0),
        
        ME_function("Auto-run", function() {
            var seed = ask_number("Random seed\n(the default here is a randomized number)", irandom(power(2, 32)));
            if (seed == undefined) {
                return;
            }
            var rng = new Rng(seed);
            
            var project_directory = build_tools_get_env_var("YYprojectDir");
            var suggested_directory = (project_directory != undefined) ? (project_directory + "\\datafiles") : program_directory;
            var auto_run_configs_filename = get_open_filename_ext("*.json", "", suggested_directory, "Select an auto-run configuration file.");
            if (string_trim(auto_run_configs_filename) == "") {
                return;
            }
            
            var output_filename = get_save_filename_ext("*.csv", "trials.csv", "", "Save results as");
            
            var capture = {
                start_time: get_timer(),
            };
            auto_run_trials(auto_run_configs_filename, output_filename, rng)
            .and_then(method(capture, function() {
                var end_time = get_timer();
                var msg = "Auto-run completed in " + string((end_time - start_time) / 1000000) + " seconds.";
                show_message(msg);
                game_end();
            }))
            .and_catch(function(err) {
                show_message(err);
            });
            return MENU_RETURN.close_menu;
        }),
        
        ME_spacer(1.0),
        
        ME_sub_menu("Play one level from the list", _make_dev_select_level_menu(), check_is_remote_defined),
        
        ME_spacer(1.0),
        
        ME_function("Play one level from a file repeatedly", function() {
            var level_filename = get_open_filename_ext("*.txt", "", "", "Select a level file");
            if (string_trim(level_filename) == "") {
                return;
            }
            var traits = new PersonalityTraits(0.5, 0.5, 0.5, 0.5, 0.5);
            var capture = {
                level_filename: level_filename,
                traits: traits,
                run: undefined,
            };
            capture.run = method(capture, function() {
                var level = level_load_from_file(level_filename);
                if (level == undefined) {
                    show_message("Failed to load level from file.");
                    return;
                }
                var seed = irandom(power(2, 32));
                trial_run(level, seed, traits, "Traits", 0).and_then(run);
            });
            capture.run();
            return MENU_RETURN.void;
        }),
        
        ME_spacer(1),
        
    ] /*#as MenuEntryDefinition[]*/;
    
    if (!is_remote_defined) {
    	array_append(bodies, [
    		ME_spacer(3),
    		ME_text("[pin_center][slant](not connected to a server)", false, false),
    	]);
    }
    
    var footers = /*#cast*/ [
    ] /*#as MenuEntryDefinition[]*/;
    
    return new MenuDefinition(headers, bodies, footers);
}

function _make_server_session_start_menu() /*-> MenuDefinition*/
{
	var bodies = [
		
		ME_spacer(4.0),
		
		ME_heading("START SESSION (SERVER)"),
		
		ME_spacer(1.0),
		
		ME_text("[pin_center]You're about to start a session of one or more trials. The results of the trials will be submitted to the server.", false, false),
		ME_text("[pin_center]Continue?", false, false),
		
		ME_spacer(2.0),
		
		ME_function("Continue", function() {
			var user_id = get_string("User ID", Debugs.dev_session_user_id);
			Debugs.dev_session_user_id = user_id;
			save_active_debug_settings();
            if (string_trim(user_id) != "") {
				API.user_get_total_score(user_id)
				.and_then(method({ user_id: user_id }, function(total_score/*: number?*/) {
					if (total_score == undefined) total_score = 0;
					var rng = new Rng(irandom(power(2, 32)));
	                var levels = array_copied(Configs.levels);
	                if (Configs.shuffle_levels) {
	                    rng.rng_array_shuffle(levels);
	                }
	                return server_session_start(user_id, levels, total_score, rng);
				}))
                .and_catch(function(err) {
                    show_message(err);
                });
            }
            else {
                game_end();
            }
            return MENU_RETURN.close_menu;
		}),
		ME_spacer(1.0),
		ME_function("Back", function() {
			return MENU_RETURN.back;
		}),
	];
	return new MenuDefinition([], bodies, []);
}

function _make_local_session_start_menu() /*-> MenuDefinition*/
{
	var bodies = [
		
		ME_spacer(4.0),
		
		ME_heading("START SESSION (LOCAL)"),
		
		ME_spacer(1.0),
		
		ME_text("[pin_center]You're about to start a session of one or more trials. At the end of the session, you will get to save the trial results as a CSV-file on your computer.", false, false),
		ME_text("[pin_center]Continue?", false, false),
		
		ME_spacer(2.0),
		
		ME_function("Continue", function() {
			var rng = new Rng(irandom(power(2, 32)));
        	var levels = array_copied(Configs.levels);
            if (Configs.shuffle_levels) {
                rng.rng_array_shuffle(levels);
            }
        	local_session_start("LOCAL_USER", levels, rng);
            return MENU_RETURN.close_menu;
		}),
		ME_spacer(1.0),
		ME_function("Back", function() {
			return MENU_RETURN.back;
		}),
	];
	return new MenuDefinition([], bodies, []);
}

function _make_dev_select_level_menu() /*-> MenuDefinition*/
{
    var headers = /*#cast*/ [
        
        ME_heading("Select level"),
        
    ] /*#as MenuEntryDefinition[]*/;
    
    var bodies = /*#cast*/ [
    ] /*#as MenuEntryDefinition[]*/;
    
    var filenames = Configs.levels;
    for (var i = 0, len = array_length(filenames); i < len; ++i) {
        var filename = filenames[i];
        var capture = {
            filename: filename,
        };
        array_push(bodies, ME_function(filename, method(capture, function() {
            var rng = new Rng(irandom(power(2, 32)));
            server_session_start("test_user", [ filename ], 0, rng)
            .and_catch(function(err) {
                show_message(err);
            });
            return MENU_RETURN.close_menu;
        })));
    }
    
    var footers = /*#cast*/ [
    ] /*#as MenuEntryDefinition[]*/;
    
    return new MenuDefinition(headers, bodies, footers);
}

function _generated_levels_directory_datetime_string(time/*: datetime*/) /*-> string*/
{
    var year    = string_pad_left(string(date_get_year(time)), 2, "0");
    var month   = string_pad_left(string(date_get_month(time)), 2, "0");
    var day     = string_pad_left(string(date_get_day(time)), 2, "0");
    var hour    = string_pad_left(string(date_get_hour(time)), 2, "0");
    var minute  = string_pad_left(string(date_get_minute(time)), 2, "0");
    var second  = string_pad_left(string(date_get_second(time)), 2, "0");
    return year + "_" + month + "_" + day + "_" + hour + "_" + minute + "_" + second;
}
