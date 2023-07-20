event_inherited();

randomize();

promises_set_uncaught_handler(function(promise/*: Promise*/) {
    var str = "A promise was rejected but not caught:\n";
    str += "[#ff5555]|[/c]";
    str += "\n[#ff5555]| [/c]\"" + string(promise.reason) + "\"";
    str += "\n[#ff5555]|[/c]";
    str += "\n[#ff5555]| [/c]At:";
    if (DEBUG_MODE && promise.debug_callstack != undefined && is_array(promise.debug_callstack)) {
        var len = array_length(promise.debug_callstack);
        for (var j = len - 1; j >= 0; --j) {
            var value = promise.debug_callstack[@ j];
            
            // The last value in the callstack is (as documented) for some reason 0. Don't print that.
            if (j == len - 1 && value == 0) {
                continue;
            }
            
            str += "\n[#ff5555]| [/c]" + string(value);
        }
    }
    str += "\n[#ff5555]|__________[/c]";
    log_error(str);
});

globalvar ProgramParams; /// @is {ProgramParameters}
ProgramParams = get_program_parameters();

initialize_log();
initialize_fonts();

if (DEBUG_MODE) {
    globalvar DebugTerminal; /// @is {obj_terminal}
    DebugTerminal = instance_create_depth(0, 0, 0, obj_terminal);
}

initialize_api_env();

log("Program started.");

log("Build version: " + string(GM_version));
log("Build configuration: " + os_get_config());
log("Debug mode: " + (DEBUG_MODE ? "true" : "false"));
log("os_type: " + string(os_type) + " " + string(os_type_to_string(os_type)));
log("os_browser: " + string(os_browser) + " " + string(os_browser_to_string(os_browser)));

if (DEBUG_MODE) {
    globalvar Debugs;  /// @is {DebugSettings}
    Debugs = /*#cast*/ undefined;
    load_active_debug_settings();
}

initialize_common_menu_configurations();

if (DEBUG_MODE) {
    instance_create_depth(0, 0, 0, obj_debug);
}

initialize_localization();

var lang = ProgramParams.lang;
if (lang == undefined) {
    if (DEBUG_MODE) {
        lang = _debug_ask_localization();
        lang = lang ?? "en";
    }
    else {
        lang = "en";
    }
}
load_and_set_localization(lang);

initialize_configs();
initialize_human_action_types();
initialize_creature_pathfinding();
initialize_trials();
initialize_tilesets();
initialize_level_cell_types();

var base_url = API_ENV.remote_url;
if (!string_ends_with(base_url, "/")) {
	base_url += "/";
}

globalvar API;  /// @is {obj_api}
API = instance_create_depth(0, 0, 0, obj_api);
API.initialize(base_url, API_ENV.api_username, API_ENV.api_password);

draw_set_circle_precision(64);

reload_game_configurations();

globalvar Camera;   /// @is {obj_camera}
Camera = instance_create_depth(0, 0, 0, obj_camera);

instance_create_depth(0, 0, 0, obj_entity_manager);
instance_create_depth(0, 0, 0, obj_entity_shadow_renderer);
instance_create_depth(0, 0, 0, obj_obstacles_renderer);
if (DEBUG_MODE || Configs.show_build_info_watermark) {
	instance_create_depth(0, 0, 0, obj_watermark);
}
instance_create_depth(0, 0, 0, obj_main_hud);

globalvar LoadingStatus; /// @is {obj_loading_status}
LoadingStatus = instance_create_depth(0, 0, 0, obj_loading_status);

window_set_size(1600, 900);

if (os_get_config() == CONFIG_DEMO) {
	var rng = new Rng(irandom(power(2, 32)));
	local_session_start("DEMO_USER", Configs.levels, rng);
}
else {
	LoadingStatus.set("Connecting...");
	var is_remote_defined = (API_ENV.remote_url != "");
	var capture = { is_remote_defined : is_remote_defined };
	(is_remote_defined ? API.test_connection() : promise_resolve(false))
	.and_then(method(capture, function(is_ok/*: bool*/) {
	    LoadingStatus.clear();
	    if (!is_ok && is_remote_defined) {
	    	var msg = "Failed to connect to the server.";
	        show_message(msg);
	    }
	    if (ProgramParams.user_id != undefined) {
	        var user_id = ProgramParams.user_id;
	        var capture = {
	            user_id: user_id,
	        };
	        API.user_exists(user_id)
	        .and_then(method(capture, function(exists/*: bool?*/) {
	            if (exists == undefined) {
	                show_message("Failed to get data from the server.");
	                game_end();
	                return;
	            }
	            if (!exists) {
	                show_message("User ID " + string(user_id) + " is not registered.");
	                game_end();
	                return;
	            }
				return API.user_get_total_score(user_id);
			}))
	        .and_then(method(capture, function(total_score/*: number?*/) {
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
	        if (DEBUG_MODE) {
	        	
	        	if (ProgramParams.auto_run_config != undefined) {
		            var output_filename = ProgramParams.auto_run_output ?? get_save_filename_ext("*.csv", "trials.csv", "", "Save results as");
		            var seed = (ProgramParams.auto_run_seed != undefined) ? try_string_to_real(ProgramParams.auto_run_seed) : undefined;
		            seed ??= irandom(power(2, 32));
		            var rng = new Rng(seed);
	        		auto_run_trials(ProgramParams.auto_run_config, output_filename, rng);
	        	}
	        	else {
	        		var menu = create_popup_menu(make_dev_menu(is_remote_defined), 600, 600);
	            	menu.persistent = false;
	        	}
	        }
	        else {
	            // TODO: Find the latest session?
	        }
	    }
	}))
	.and_catch(function(err) {
	    LoadingStatus.clear();
	    show_message(err);
	});
}
