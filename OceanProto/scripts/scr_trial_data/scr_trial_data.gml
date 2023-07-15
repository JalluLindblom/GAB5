
function TrialData(
    _user_id/*: string*/,
    _config_version/*: string*/,
    _game_version/*: string*/,
    _seed/*: number*/,
    _level_info/*: TrialLevelInfo*/,
    _traits/*: PersonalityTraits*/,
    _result/*: TrialResult*/
) constructor
{
    user_id         = _user_id;         /// @is {string}
    config_version  = _config_version;  /// @is {string}
    game_version    = _game_version;    /// @is {string}
    seed            = _seed;            /// @is {number}
    level_info      = _level_info;      /// @is {TrialLevelInfo}
    traits          = _traits;          /// @is {PersonalityTraits}
    result          = _result;          /// @is {TrialResult}
}

function TrialLevelInfo(
    _filename/*: string*/,
    _play_order/*: int*/,
    _num_monsters/*: int*/,
    _num_food/*: int*/,
    _num_humans/*: int*/,
    _num_humans_h/*: int*/,
    _num_humans_per_type/*: int[]*/,
    _num_sand/*: int*/
) constructor
{
    filename        = _filename;                /// @is {string}
    play_order      = _play_order;              /// @is {int}
    num_monsters    = _num_monsters;            /// @is {int}
    num_food        = _num_food;                /// @is {int}
    num_humans      = _num_humans;              /// @is {int}
    num_humans_h    = _num_humans_h;            /// @is {int}
    num_humans_0    = _num_humans_per_type[0];  /// @is {int}
    num_humans_1    = _num_humans_per_type[1];  /// @is {int}
    num_humans_2    = _num_humans_per_type[2];  /// @is {int}
    num_humans_3    = _num_humans_per_type[3];  /// @is {int}
    num_humans_4    = _num_humans_per_type[4];  /// @is {int}
    num_humans_5    = _num_humans_per_type[5];  /// @is {int}
    num_humans_6    = _num_humans_per_type[6];  /// @is {int}
    num_humans_7    = _num_humans_per_type[7];  /// @is {int}
    num_humans_8    = _num_humans_per_type[8];  /// @is {int}
    num_humans_9    = _num_humans_per_type[9];  /// @is {int}
    num_sand        = _num_sand;                /// @is {int}
}

function trial_data_get_flattened_names() /*-> string[]*/
{
    static result = undefined;
    if (result == undefined) {
        var dummy_level_info = new TrialLevelInfo("", 0, 0, 0, 0, 0, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 0);
        var dummy = new TrialData("", "", "", 0, dummy_level_info, new PersonalityTraits(), new TrialResult(TRES_SURVIVED, 0, 0, 0, 0, 0, 0));
        var names = [];
        _struct_get_names_recursively(dummy, "", names);
        array_sort(names, true);
        result = names;
    }
    return result;
}

function trial_data_as_csv_headers() /*-> string*/
{
    var names = trial_data_get_flattened_names();
    return snap_to_csv([ names ], ";");
}

function trial_data_as_csv(trial_data/*: TrialData*/) /*-> string*/
{
    var names = trial_data_get_flattened_names();
    var values = [];
    for (var i = 0, len = array_length(names); i < len; ++i) {
        var name = names[i];
        array_push(values, _struct_get_value_recursively(trial_data, name));
    }
    return snap_to_csv([ values ], ";");
}

function _trial_datas_as_2d_array(trials/*: TrialData[]*/) /*-> string[][]*/
{
    if (array_length(trials) == 0) {
        return [];
    }
    var arr = [];
    var names = [];
    _struct_get_names_recursively(trials[0], "", names);
    array_push(arr, names);
    for (var i = 0, num_trials = array_length(trials); i < num_trials; ++i) {
        var trial = trials[i];
        var row = [];
        for (var j = 0, num_names = array_length(names); j < num_names; ++j) {
            array_push(row, _struct_get_value_recursively(trial, names[j]));
        }
        array_push(arr, row);
    }
    return arr;
}

function _snake_to_camel_case(value/*: string*/) /*-> string*/
{
    var parts = string_split(value, "_");
    var result = "";
    for (var i = 0, len = array_length(parts); i < len; ++i) {
        var part = parts[i];
        var part_len = string_length(part);
        if (i == 0) {
            result += part;
        }
        else if (part_len > 0) {
            result += string_upper(string_copy(part, 1, 1)) + string_copy(part, 2, part_len - 1);
        }
    }
    return result;
}

function _struct_get_names_recursively(struct/*: struct*/, prefix/*: string*/, out_names/*: string[]*/)
{
    var names = variable_struct_get_names(struct);
    for (var i = 0, len = array_length(names); i < len; ++i) {
        var name = names[i];
        var value = struct[$ name];
        if (is_struct(value)) {
            _struct_get_names_recursively(value, name + ".", out_names);
        }
        else {
            array_push(out_names, prefix + name);
        }
    }
}

function _struct_get_value_recursively(struct/*: struct*/, name/*: string*/) /*-> any*/
{
    var name_parts = string_split(name, ".");
    for (var i = 0, len = array_length(name_parts); i < len; ++i) {
        var name_part = name_parts[i];
        if (i == len - 1) {
            return struct[$ name_part];
        }
        else {
            struct = struct[$ name_part];
        }
    }
}
