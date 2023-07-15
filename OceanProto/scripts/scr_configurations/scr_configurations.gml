
function initialize_configs()
{
    CALL_ONLY_ONCE
    
    globalvar Configs;  /// @is {GameConfigurations}
    Configs = /*#cast*/ undefined;
}

function GameConfigurations() constructor
{
    // All of these values are going to be overwritten by the values from a configurations file.
    // The initial value here defines the type as which it's to be read from the configuration file.
    
    configuration_version                   = /*#cast*/ "string";    /// @is {string}
    
    options_openness                        = /*#cast*/ "array";     /// @is {number[]}
    options_conscientiousness               = /*#cast*/ "array";     /// @is {number[]}
    options_extraversion                    = /*#cast*/ "array";     /// @is {number[]}
    options_agreeableness                   = /*#cast*/ "array";     /// @is {number[]}
    options_neuroticism                     = /*#cast*/ "array";     /// @is {number[]}
    
    trial_time                              = /*#cast*/ "number";    /// @is {number}
    
    trial_score                             = /*#cast*/ "method";    /// @is {function<PersonalityTraits, number, number, number>}
    
    game_speed                              = /*#cast*/ "number";    /// @is {number}
	
	show_trial_result_menu					= /*#cast*/ "bool";      /// @is {bool}
	
	leave_traits_menu_open_when_playing		= /*#cast*/ "bool";      /// @is {bool}
    
    human_sight_range                       = /*#cast*/ "method";    /// @is {function<PersonalityTraits, number, number>}
    
    human_energy_max                        = /*#cast*/ "number";    /// @is {number}
    human_starting_energy                   = /*#cast*/ "number";    /// @is {number}
    monster_energy_max                      = /*#cast*/ "number";    /// @is {number}
    monster_starting_energy                 = /*#cast*/ "number";    /// @is {number}
    
    human_energy_gain_eat_food              = /*#cast*/ "number";    /// @is {number}
    human_energy_gain_kill_monster          = /*#cast*/ "number";    /// @is {number}
    human_energy_gain_kill_human            = /*#cast*/ "number";    /// @is {number}
    
    human_constant_energy_loss_amount       = /*#cast*/ "number";    /// @is {number}
    human_constant_energy_loss_frequency    = /*#cast*/ "number";    /// @is {number}
    
    attack_frequency                        = /*#cast*/ "number";    /// @is {number}
    exchange_frequency                      = /*#cast*/ "number";    /// @is {number}
    action_update_frequency                 = /*#cast*/ "number";    /// @is {number}
    
    move_speed_approach_food                = /*#cast*/ "method";    /// @is {function<PersonalityTraits, number, number>}
    move_speed_approach_monster             = /*#cast*/ "method";    /// @is {function<PersonalityTraits, number, number>}
    move_speed_approach_human               = /*#cast*/ "method";    /// @is {function<PersonalityTraits, number, number>}
    move_speed_avoid_monster                = /*#cast*/ "method";    /// @is {function<PersonalityTraits, number, number>}
    move_speed_avoid_human                  = /*#cast*/ "method";    /// @is {function<PersonalityTraits, number, number>}
    move_speed_attack_monster               = /*#cast*/ "method";    /// @is {function<PersonalityTraits, number, number>}
    move_speed_attack_human                 = /*#cast*/ "method";    /// @is {function<PersonalityTraits, number, number>}
    move_speed_exchange_with_human          = /*#cast*/ "method";    /// @is {function<PersonalityTraits, number, number>}
    move_speed_explore                      = /*#cast*/ "method";    /// @is {function<PersonalityTraits, number, number>}
    
    human_sand_move_speed_multiplier        = /*#cast*/ "number";    /// @is {number}
    monster_sand_move_speed_multiplier      = /*#cast*/ "number";    /// @is {number}
    
    monster_movement_speed                  = /*#cast*/ "number";    /// @is {number}
    monster_exploration_movement_speed      = /*#cast*/ "number";    /// @is {number}
    monster_sight_range                     = /*#cast*/ "number";    /// @is {number}
    monster_exploration_range               = /*#cast*/ "number";    /// @is {number}
    
    human_fight_hit_weight					= /*#cast*/ "method";    /// @is {function<PersonalityTraits, number, number>}
    human_fight_miss_weight					= /*#cast*/ "method";    /// @is {function<PersonalityTraits, number, number>}
    human_fight_flee_weight					= /*#cast*/ "method";    /// @is {function<PersonalityTraits, number, number>}
    
    monster_fight_hit_weight				= /*#cast*/ "number";    /// @is {number}
    monster_fight_miss_weight				= /*#cast*/ "number";    /// @is {number}
    monster_fight_flee_weight				= /*#cast*/ "number";    /// @is {number}
    
    human_first_attack_damage               = /*#cast*/ "method";    /// @is {function<PersonalityTraits, number, number>}
    human_normal_attack_damage              = /*#cast*/ "method";    /// @is {function<PersonalityTraits, number, number>}
    human_attacker_energy_gain              = /*#cast*/ "method";    /// @is {function<PersonalityTraits, number, number>}
    monster_first_attack_damage             = /*#cast*/ "number";    /// @is {number}
    monster_normal_attack_damage            = /*#cast*/ "number";    /// @is {number}
    monster_attacker_energy_gain            = /*#cast*/ "number";    /// @is {number}
    
    num_memory_slots                        = /*#cast*/ "number";    /// @is {number}
    
    exchange_give_weight                    = /*#cast*/ "method";    /// @is {function<PersonalityTraits, number, number>}
    exchange_take_weight                    = /*#cast*/ "method";    /// @is {function<PersonalityTraits, number, number>}
    
    exchange_collaboration_energy_gain      = /*#cast*/ "number";    /// @is {number}
    exchange_being_ripped_off_energy_gain   = /*#cast*/ "number";    /// @is {number}
    exchange_ripping_off_energy_gain        = /*#cast*/ "number";    /// @is {number}
    
    exchange_back_chance                    = /*#cast*/ "method";    /// @is {function<PersonalityTraits, number, number>}
    
    human_exploration_range                 = /*#cast*/ "method";    /// @is {function<PersonalityTraits, number, number>}
    
    weight_approach_food                    = /*#cast*/ "method";    /// @is {function<PersonalityTraits, number, number>}
    weight_approach_monster                 = /*#cast*/ "method";    /// @is {function<PersonalityTraits, number, number>}
    weight_approach_human                   = /*#cast*/ "method";    /// @is {function<PersonalityTraits, number, number>}
    weight_avoid_monster                    = /*#cast*/ "method";    /// @is {function<PersonalityTraits, number, number>}
    weight_avoid_human                      = /*#cast*/ "method";    /// @is {function<PersonalityTraits, number, number>}
    weight_attack_monster                   = /*#cast*/ "method";    /// @is {function<PersonalityTraits, number, number>}
    weight_attack_human                     = /*#cast*/ "method";    /// @is {function<PersonalityTraits, number, number>}
    weight_exchange_with_human              = /*#cast*/ "method";    /// @is {function<PersonalityTraits, number, number>}
    weight_explore                          = /*#cast*/ "method";    /// @is {function<PersonalityTraits, number, number>}
    
    target_weight_approach_food				= /*#cast*/ "method";	/// @is {function<PersonalityTraits, number, number, number>}
	target_weight_approach_monster			= /*#cast*/ "method";	/// @is {function<PersonalityTraits, number, number, number>}
	target_weight_approach_human			= /*#cast*/ "method";	/// @is {function<PersonalityTraits, number, number, number>}
	target_weight_avoid_monster				= /*#cast*/ "method";	/// @is {function<PersonalityTraits, number, number, number>}
	target_weight_avoid_human				= /*#cast*/ "method";	/// @is {function<PersonalityTraits, number, number, number>}
    
    current_action_weight_modifier          = /*#cast*/ "method";    /// @is {function<PersonalityTraits, number, number, number>}
    
    human_counter_attack_chance_against_human   = /*#cast*/ "method";    /// @is {function<PersonalityTraits, number, number>}
    human_counter_attack_chance_against_monster = /*#cast*/ "method";    /// @is {function<PersonalityTraits, number, number>}
    
    ai_human_traits							= /*#cast*/ "array";		/// @is {PersonalityTraitRanges[]}
    
    show_player_marker_at_beginning         = /*#cast*/ "bool";      /// @is {bool}
    show_player_marker_while_playing        = /*#cast*/ "bool";      /// @is {bool}
    
    show_crosshair_approach_food            = /*#cast*/ "bool";      /// @is {bool}
    show_crosshair_approach_monster         = /*#cast*/ "bool";      /// @is {bool}
    show_crosshair_approach_human           = /*#cast*/ "bool";      /// @is {bool}
    show_crosshair_avoid_monster            = /*#cast*/ "bool";      /// @is {bool}
    show_crosshair_avoid_human              = /*#cast*/ "bool";      /// @is {bool}
    show_crosshair_attack_monster           = /*#cast*/ "bool";      /// @is {bool}
    show_crosshair_attack_human             = /*#cast*/ "bool";      /// @is {bool}
    show_crosshair_exchange_with_human      = /*#cast*/ "bool";      /// @is {bool}
	
	show_build_info_watermark				= /*#cast*/ "bool";      /// @is {bool}
    
    level_background_color                  = /*#cast*/ "string";    /// @is {string}
    trait_menu_slider_is_triangle           = /*#cast*/ "bool";      /// @is {bool}
    show_keyboard_prompts                   = /*#cast*/ "bool";      /// @is {bool}
    non_player_sound_volume                 = /*#cast*/ "number";    /// @is {number}
    score_animation_increment               = /*#cast*/ "number";    /// @is {number}
    
    url_score_randomization					= /*#cast*/ "number";	/// @is {number}
    
    next_url                                = /*#cast*/ "string";    /// @is {string}
    
    shuffle_levels                          = /*#cast*/ "bool";      /// @is {bool}
    
    levels                                  = /*#cast*/ "array";     /// @is {Array<string>}
}

function _json_remove_comments(json/*: string*/) /*-> string*/
{
    var lines = string_split(json, "\n");
    for (var i = 0, len = array_length(lines); i < len; ++i) {
        var line = lines[i];
        var pos = string_last_pos("//", line);
        if (pos >= 1) {
            var num_quotes_before_this = 0;
            for (var p = 1; p < pos; ++p) {
                if (string_char_at(line, p) == "\"") {
                    ++num_quotes_before_this;
                }
            }
            var is_mid_string = (num_quotes_before_this % 2) == 1;
            if (!is_mid_string) {
                lines[i] = string_copy(line, 1, pos - 1);
            }
        }
    }
    return string_join_array(lines, "\n");
}

function _load_game_configurations_from_file(filename/*: string*/, require_all_variables/*: bool*/) /*-> GameConfigurations?*/
{
    if (!file_exists(filename)) {
        log_error("Configuration file doesn't exist (" + string(filename) + ").");
        return undefined;
    }
    var full_text = file_read_string(filename);
    if (full_text == undefined) {
        log_error("Failed to read configuration file \"" + filename + "\".");
        return undefined;
    }
    full_text = _json_remove_comments(full_text);
    
    var json_struct = /*#cast*/ undefined /*#as struct*/;
    try {
        json_struct = snap_from_json(full_text);
    }
    catch (err) {
        show_message("Failed to parse configuration file:\n\n" + string(err));
    }
    if (json_struct == undefined) {
        log_error("Failed to read the configuration file \"" + filename + "\".");
        return undefined;
    }
    if (typeof(json_struct) != "struct") {
        log_error("Configuration file \"" + filename + "\" is in an unexpected format: " + typeof(json_struct) + ".");
        return undefined;
    }
    
    var compiler = new GmlCompiler();
    
    // A "scheme" of the configurations struct.
    // The value of each variable in it defines the expected type of that variable.
    // See GameConfigurations constructor definition for details.
    var config_scheme = new GameConfigurations();
    var names = variable_struct_get_names(config_scheme);
    
    // Create the configuration struct that will eventually be returned.
    // Set all variables to undefined as default.
    var configurations = new GameConfigurations();
    for (var i = 0, len = array_length(names); i < len; ++i) {
        var name = names[i];
        configurations[$ name] = undefined;
    }
    
    for (var i = 0, len = array_length(names); i < len; ++i) {
        var name = names[i];
        if (!variable_struct_exists(json_struct, name)) {
            if (require_all_variables) {
                log_error("Configuration file \"" + filename + "\" doesn't define the variable \"" + string(name) + "\".");
                return undefined;
            }
            else {
                continue;
            }
        }
        var value = json_struct[$ name];
        var value_type = typeof(value);
        var expected_type = config_scheme[$ name];
        if (expected_type == "method") {
            var expression = compiler.compile_expression_from_string(value);
            if (name == "current_action_weight_modifier") {
                value = method({ expression: expression }, function(traits/*: PersonalityTraits*/, energy_level/*: number*/, current_action_weight/*: number*/) {
                    return _evaluate_config_expression(expression, traits, energy_level, current_action_weight, undefined, undefined);
                });
            }
            else if (name == "trial_score") {
                value = method({ expression: expression }, function(traits/*: PersonalityTraits*/, energy_level/*: number*/, time_progress/*: number*/) {
                    return _evaluate_config_expression(expression, traits, energy_level, undefined, time_progress, undefined);
                });
            }
            else if (string_starts_with(name, "target_weight_")) {
                value = method({ expression: expression }, function(traits/*: PersonalityTraits*/, energy_level/*: number*/, distance/*: number*/) {
                    return _evaluate_config_expression(expression, traits, energy_level, undefined, undefined, distance);
                });
            }
            else {
                value = method({ expression: expression }, function(traits/*: PersonalityTraits*/, energy_level/*: number*/) {
                    return _evaluate_config_expression(expression, traits, energy_level, undefined, undefined, undefined);
                });
            }
        }
        else if (value_type != expected_type) {
            log_error("Configuration file \"" + filename + "\" variable \"" + name + "\" is of an unexpected type \"" + value_type + "\". Expected \"" + expected_type + "\".");
            return undefined;
        }
        configurations[$ name] = value;
    }
    
    return configurations;
}

function reload_game_configurations() /*-> bool*/
{
    var main_config_filename = "configurations.json";
    var custom_config_filename = ProgramParams.config;
    if (DEBUG_MODE && (custom_config_filename == undefined || string_trim(custom_config_filename) == "")) {
        custom_config_filename = _debug_ask_custom_config_filename();
    }
    
    // Load the main configurations.
    var configs = _load_game_configurations_from_file(make_included_file_filename(main_config_filename), true);
    if (configs == undefined) {
        log_error("Failed to load main configs from \"" + main_config_filename + "\".");
        return false;
    }
    
    log("Loaded base configurations from \"" + main_config_filename + "\".");
    
    // Load custom configurations on top of the main configurations.
    if (custom_config_filename != undefined) {
        if (!string_ends_with(custom_config_filename, ".json")) {
            custom_config_filename = custom_config_filename + ".json";
        }
        var custom_configs = _load_game_configurations_from_file(make_included_file_filename(custom_config_filename), false);
        if (custom_configs == undefined) {
            log_error("Failed to load custom configs from \"" + custom_config_filename + "\"");
            return false;
        }
        // Overwrite non-undefined values from custom configurations to the actual configurations.
        var names = variable_struct_get_names(custom_configs);
        for (var i = 0, len = array_length(names); i < len; ++i) {
            var name = names[i];
            if (custom_configs[$ name] != undefined) {
                configs[$ name] = custom_configs[$ name];
            }
        }
        log("Loaded custom configurations from \"" + custom_config_filename + "\". All fields that are defined in this configuration were overwritten over the base configurations.");
    }
    else {
    	log("No custom configurations were loaded, because none were specified. Only the base configurations will be in effect.");
    }
    
    Configs = configs;
    
    return true;
}

function _debug_ask_custom_config_filename() /*-> string?*/
{
    var message = "Enter custom configuration's relative filename. You can leave out the file extension (e.g. .json).";
    message += "\n\nThese custom will partially or fully overwrite the default configurations.";
    message += "\n\nLeave blank or cancel to use default configurations as is.";
    var custom_config = string_trim(get_string(message, Debugs.custom_config));
    Debugs.custom_config = custom_config;
    save_active_debug_settings();
    return (custom_config != "") ? custom_config : undefined;
}

function _evaluate_config_expression(
    expression/*: function*/,
    traits/*: PersonalityTraits*/,
    energy_level/*: number*/,
    current_action_weight/*: number?*/,
    time_progress/*: number?*/,
    distance/*: number?*/
) /*-> any*/
{
    global.O            = traits.openness;
    global.C            = traits.conscientiousness;
    global.E            = traits.extraversion;
    global.A            = traits.agreeableness;
    global.N            = traits.neuroticism;
    global.ENERGY_LEVEL = energy_level;
    global.WEIGHT       = current_action_weight;
    global.TIME         = time_progress;
    global.DISTANCE		= distance;
    return expression();
}
