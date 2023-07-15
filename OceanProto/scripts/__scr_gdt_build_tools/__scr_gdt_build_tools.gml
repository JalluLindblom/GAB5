
/// Gets the value of the given environment variable.
/// The variables were saved during the build process.
/// This works reliably ONLY when launching a debug build from the IDE.
function build_tools_get_env_var(var_name/*: string*/) /*-> string?*/
{
    var map = __build_tools_get_env_var_map();
    if (ds_map_exists(map, var_name)) {
        return map[? var_name];
    }
    return undefined;
}

function build_tools_get_env_var_names() /*-> string[]*/
{
    var map = __build_tools_get_env_var_map();
    static names = undefined;
    if (names == undefined) {
        names = array_create(ds_map_size(map), undefined);
        var i = 0;
        for (var name = ds_map_find_first(map); name != undefined; name = ds_map_find_next(map, name)) {
            names[@ i++] = name;
        }
    }
    return names;
}

/// Gets the map that contains environment variables printed during the building process.
/// The variables are printed into the file in pre_build_step.bat.
/// The keys are the names of the variables and the values are the value, all as strings.
/// @returns {ds_map<string, string>}
function __build_tools_get_env_var_map() /*-> ds_map<string, string>*/
{
    static map = -1;
    if (!ds_exists(map, ds_type_map)) {
        map = ds_map_create();
        var filename = "__build_tools_pre_build_env_vars.txt";
        var lines = __build_tools_file_read_text_lines(filename);
        for (var i = 0, len = array_length(lines); i < len; ++i) {
            var line = lines[@ i];
            var pos = string_pos("=", line);
            if (pos > 0) {
                var name = string_copy(line, 1, pos - 1);
                var value = string_copy(line, pos + 1, string_length(line));
                map[? name] = value;
            }
        }
    }
    return map;
}

/// @param {string} filename
/// @returns {string[]?}
function __build_tools_file_read_text_lines(filename)
{
    var file = file_text_open_read(filename);
    if (file < 0) {
        return undefined;
    }
	var lines = [];
    while (!file_text_eof(file)) {
        array_push(lines, file_text_read_string(file));
        file_text_readln(file);
    }
    file_text_close(file);
    return lines;
}
