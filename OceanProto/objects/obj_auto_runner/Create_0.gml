event_inherited();

auto_run_configs = /*#cast*/ undefined;      /// @is {struct}
output_csv_filename = /*#cast*/ undefined;   /// @is {string}
rng = /*#cast*/ undefined;                   /// @is {Rng}
callback = /*#cast*/ undefined;              /// @is {function<void>}

params = [];                            /// @is {struct[]}
current_param_index = 0;                /// @is {int}
running = false;                        /// @is {bool}
file = -1;                              /// @is {file_handle}

total_score = 0;    /// @is {number}

initialize = function(_auto_run_configs/*: struct*/, _output_csv_filename/*: string*/, _rng/*: Rng*/, _callback/*: (function<void>)*/)
{
    auto_run_configs = _auto_run_configs;
    output_csv_filename = _output_csv_filename;
    rng = _rng;
    callback = _callback;
    
    var permutations = personality_traits_make_all_permutations(
        auto_run_configs[$ "options_openness"],
        auto_run_configs[$ "options_conscientiousness"],
        auto_run_configs[$ "options_extraversion"],
        auto_run_configs[$ "options_agreeableness"],
        auto_run_configs[$ "options_neuroticism"]
    );
    var level_filenames = Configs.levels;
    
    array_resize(params, 0);
    for (var i = 0, num_filenames = array_length(level_filenames); i < num_filenames; ++i) {
        var filename = level_filenames[i];
        for (var j = 0, num_permutations = array_length(permutations); j < num_permutations; ++j) {
            var traits = permutations[j];
            repeat (auto_run_configs[$ "num_runs_per_permutation"]) {
                array_push(params, {
                    traits: traits,
                    filename: filename,
                    seed: rng.rng_irandom(power(2, 32)),
                });
            }
        }
    }
    
    current_param_index = 0;
    running = false;
    
    file = file_text_open_write(output_csv_filename);
    if (file < 0) {
        throw "Failed to open file for writing.";
    }
    
    file_text_write_string(file, trial_data_as_csv_headers());
}