
#macro LANG (ActiveLanguage.get)

function initialize_localization()
{
    CALL_ONLY_ONCE
    
    globalvar ActiveLanguage;   /// @is {Language}
    ActiveLanguage = /*#cast*/ undefined; // This should be overwritten at initialization.
}

function Language(_lines/*: struct*/) constructor
{
    lines = _lines; /// @is {struct}
    
	/// @param {string} lid
	/// @param {string|any} ...replacements
	static get = function(lid/*: string*/) /*-> string*/
	{
		if (!variable_struct_exists(lines, lid)) {
			if (DEBUG_MODE) {
				log_warning("Language doesn't have LID \"" + lid + "\".");
			}
			return lid;
		}
		
		var value = lines[$ lid];
		for (var i = 1; i < argument_count; i += 2) {
			var replacement_key = string(argument[i]);
			if (i < argument_count - 1) {
				var replacement_value = string(argument[i + 1]);
				value = string_replace_all(value, "{" + replacement_key + "}", replacement_value);
			}
		}
		return value;
	}
}

function load_and_set_localization(localization_name/*: string*/) /*-> bool*/
{
    var filename = "localization/" + localization_name + ".ini";
    if (!file_exists(filename)) {
        log_error("Failed to load localization file \"" + filename + "\".");
        return false;
    }
    try {
        var struct = snap_from_ini_file(filename, false);
		var lines = struct[$ "localization"];
		var lids = variable_struct_get_names(lines);
		for (var i = 0, len = array_length(lids); i < len; ++i) {
			var lid = lids[i];
			lines[$ lid] = string_replace_all(lines[$ lid], "\\n", "\n");
		}
        ActiveLanguage = new Language(lines);
    }
    catch (err) {
        show_message(err);
    }
    return true;
}

function _debug_ask_localization() /*-> string?*/
{
    var message = "Enter localization file's name.\n E.g. the name of /localization/en.ini would be just \"en\".";
    var lang = string_trim(get_string(message, Debugs.lang));
    Debugs.lang = lang;
    save_active_debug_settings();
    return (lang != "") ? lang : undefined;
}
