
// This is hacky...
function line_on_rectangle(lx1/*: number*/, ly1/*: number*/, lx2/*: number*/, ly2/*: number*/, rx1/*: number*/, ry1/*: number*/, rx2/*: number*/, ry2/*: number*/) /*-> bool*/
{
    return rectangle_in_triangle(rx1, ry1, rx2, ry2, lx1, ly1, lx2, ly2, lx2 + 1, ly2 + 1);
}

function get_debug_hue_for_instance(instance/*: instance*/) /*-> number*/
{
    if (instance_exists(instance)) {
        return int_hash(real(instance.id)) % 255;
    }
    return 0;
}

function int_hash(value/*: int*/) /*-> int*/
{
    // https://stackoverflow.com/a/12996028
    value = int64(value);
    value = ((value >> 16) ^ value) * 0x45d9f3b;
    value = ((value >> 16) ^ value) * 0x45d9f3b;
    value = (value >> 16) ^ value;
    return value;
}

/*
E.g.
color_to_rgb_hexadecimal_string(make_color_rgb(255, 0, 255)) -> "FF00FF"
*/
function color_to_rgb_hexadecimal_string(color/*: int*/) /*-> string*/
{
    var red_hex = decimal_to_hexadecimal(color_get_red(color));
    var green_hex = decimal_to_hexadecimal(color_get_green(color));
    var blue_hex = decimal_to_hexadecimal(color_get_blue(color));
    var str = "";
    str += (string_length(red_hex) >= 2) ? red_hex : ("0" + red_hex);
    str += (string_length(green_hex) >= 2) ? green_hex : ("0" + green_hex);
    str += (string_length(blue_hex) >= 2) ? blue_hex : ("0" + blue_hex);
    return str;
}

/*
E.g.
decimal_to_hexadecimal(0) -> "0"
decimal_to_hexadecimal(1) -> "1"
decimal_to_hexadecimal(10) -> "A"
decimal_to_hexadecimal(255) -> "FF"
decimal_to_hexadecimal(4080) -> "FF0"
decimal_to_hexadecimal(65025) -> "FE01"
*/
function decimal_to_hexadecimal(n/*: int*/) /*-> string*/
{
	var str = "";
	while (n != 0) {
		var temp = n % 16;
		if (temp < 10) {
			str = string_insert(chr(temp + 48), str, 0);
		}
		else {
			str = string_insert(chr(temp + 55), str, 0);
		}
		n = floor(n / 16);
	}
	
	return (string_length(str) > 0) ? str : "0";
}

function color_from_hexadecimal_string(hex_string/*: string*/) /*-> int*/
{
	var r = 0;
	var g = 0;
	var b = 0;
	var str_len = string_length(hex_string);

	if (str_len >= 2) {
	    r = hexadecimal_string_to_decimal(string_copy(hex_string, 1, 2));
	}
	if (str_len >= 4) {
	    g = hexadecimal_string_to_decimal(string_copy(hex_string, 3, 2));
	}
	if (str_len >= 6) {
	    b = hexadecimal_string_to_decimal(string_copy(hex_string, 5, 2));
	}

	return make_color_rgb(r, g, b);	
}

function hexadecimal_string_to_decimal(hex_string/*: string*/) /*-> number*/
{
	var str_len = string_length(hex_string);
	if (str_len <= 0) {
		return 0;
	}
	
	var value = 0;
    for (var i = 0; i < str_len; ++i) {
        var char = string_char_at(hex_string, str_len - i);
        var code = ord(char);
        var char_value = 0;
        if (code >= 48 && code <= 57) { // Numbers
            char_value = code - 48;
        }
        else if (code >= 97 && code <= 102) { // Lower case letters
            char_value = code - 87;
        }
        else if (code >= 65 && code <= 70) { // Upper case letters
            char_value = code - 55;
        }
        value += char_value * power(16, i);
    }
	return value;
}

/// @param {object} child
/// @param {object} ...parents
function object_is_ancestor_or_child(child) /*-> bool*/
{
	for (var i = 1; i < argument_count; ++i) {
		var parent = argument[i];
		if ((child == parent) || object_is_ancestor(child, parent)) {
			return true;
		}
	}
	return false;
}

function make_included_file_filename(filename/*: string*/) /*-> string*/
{
	if (DEBUG_MODE) {
		var project_directory = build_tools_get_env_var("YYprojectDir");
		if (project_directory != undefined) {
			return project_directory + "/datafiles/" + filename;
		}
	}
	return filename;
}

function inv_lerp(val1/*: number*/, val2/*: number*/, amount/*: number*/) /*-> number*/
{
	return (amount - val1) / (val2 - val1);
}

function ask_number(message/*: string*/, def/*: number*/) /*-> number?*/
{
	while (true) {
		var str = get_string(message, string(def));
		if (str == "") {
			return undefined;
		}
		try {
			return real(str);
		}
		catch (err) { }
	}
}

function get_numpad_key(number/*: int*/) /*-> int*/
{
	switch (number) {
		case 0: return vk_numpad0;
		case 1: return vk_numpad1;
		case 2: return vk_numpad2;
		case 3: return vk_numpad3;
		case 4: return vk_numpad4;
		case 5: return vk_numpad5;
		case 6: return vk_numpad6;
		case 7: return vk_numpad7;
		case 8: return vk_numpad8;
		case 9: return vk_numpad9;
	}
	return undefined;
}

function try_string_to_real(str/*: string*/) /*-> number?*/
{
	try {
		return real(str);
	}
	catch (err) {
		return undefined;
	}
}


function os_type_to_string(_os_type/*: os_type*/) /*-> string?*/
{
	switch (_os_type) {
		case os_windows:	return "os_windows";
		case os_gxgames:	return "os_gxgames";
		case os_linux:		return "os_linux";
		case os_macosx:		return "os_macosx";
		case os_ios:		return "os_ios";
		case os_tvos:		return "os_tvos";
		case os_android:	return "os_android";
		case os_ps4:		return "os_ps4";
		case os_ps5:		return "os_ps5";
		case os_gdk:		return "os_gdk";
		case os_switch:		return "os_switch";
		case os_unknown:	return "os_unknown";
	}
	return undefined;
}

function os_browser_to_string(_os_browser/*: browser_type*/) /*-> string?*/
{
	switch (_os_browser) {
		case browser_not_a_browser:		return "browser_not_a_browser";
		case browser_unknown:			return "browser_unknown";
		case browser_ie:				return "browser_ie";
		case browser_ie_mobile:			return "browser_ie_mobile";
		case browser_firefox:			return "browser_firefox";
		case browser_chrome:			return "browser_chrome";
		case browser_safari:			return "browser_safari";
		case browser_safari_mobile:		return "browser_safari_mobile";
		case browser_opera:				return "browser_opera";
		case browser_tizen:				return "browser_tizen";
		case browser_windows_store:		return "browser_windows_store";
	}
	return undefined;
}

function find_instances_of_objects(objects/*: object[]*/) /*-> instance[]*/
{
	var arr_size = 0;
	for (var i = 0, len = array_length(objects); i < len; ++i) {
		arr_size += instance_number(objects[i]);
	}
	var arr = array_create(arr_size);
	var k = 0;
	for (var i = 0, len = array_length(objects); i < len; ++i) {
		with (objects[i]) {
			arr[k++] = id;
		}
	}
	return arr;
}
