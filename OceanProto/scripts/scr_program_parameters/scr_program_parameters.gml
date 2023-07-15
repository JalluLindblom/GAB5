
function ProgramParameters() constructor
{
    user_id         = undefined;    /// @is {string?}
    config          = undefined;    /// @is {string?}
    lang            = undefined;    /// @is {string?}
    auto_run_config = undefined;    /// @is {string?}
    auto_run_seed   = undefined;    /// @is {string?}
    auto_run_output = undefined;    /// @is {string?}
    log_output_file = undefined;    /// @is {string?}
}

/// @returns {ProgramParameters}
function get_program_parameters()
{
    var params = new ProgramParameters();
    var params_names = variable_struct_get_names(params);
    
    for (var i = 0, count = parameter_count(); i <= count; ++i) {
        var param = parameter_string(i);
        var parts = string_split(param, "=");
        if (array_length(parts) >= 2) {
            var name = parts[0];
            var value = parts[1];
            for (var j = 0, len = array_length(params_names); j < len; ++j) {
                if (name == params_names[j]) {
                    params[$ name] = value;
                    break;
                }
            }
        }
    }
    
    return params;
}
