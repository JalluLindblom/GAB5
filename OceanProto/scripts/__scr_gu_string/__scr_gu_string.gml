
function string_split(str/*: string*/, separator/*: string*/) /*-> string[]*/
{
	var sep_len = string_length(separator);
	if (sep_len == 0) {
		return [ str ];
	}
	
	var parts = [];
	while (true) {
		var split_pos = string_pos(separator, str);
		if (split_pos <= 0) {
			break;
		}
		array_push(parts, string_copy(str, 1, split_pos -1));
		str = string_copy(str, split_pos + sep_len, string_length(str));
	}
	array_push(parts, str);
	return parts;
}

function string_trim_start(str/*: string*/) /*-> string*/
{
	var len = string_length(str);
	var start_pos;
	for (start_pos = 1; start_pos <= len; ++start_pos) {
		var char = string_char_at(str, start_pos);
		if (char != "\n" && char != "\r" && char != "\t" && char != " ") {
			break;
		}
	}
	return string_copy(str, start_pos, len);
}

function string_trim_end(str/*: string*/) /*-> string*/
{
	var end_pos;
	for (end_pos = string_length(str); end_pos >= 1; --end_pos) {
		var char = string_char_at(str, end_pos);
		if (char != "\n" && char != "\r" && char != "\t" && char != " ") {
			break;
		}
	}
	return string_copy(str, 1, end_pos);
}

function string_trim(str/*: string*/) /*-> string*/
{
	return string_trim_start(string_trim_end(str));
}

/// If last_separator is given, that will be used as the separator between the last two elements.
/// For example if your separator=", " and last_separator=" and ", you could get "A, B, C and D".
function string_join_array(array_of_strings/*: Array*/, separator/*: string*/, last_separator/*: string?*/ = undefined) /*-> string*/
{
	var total_string = "";
	var n = array_length(array_of_strings);
	for (var i = 0; i < n; ++i) {
		total_string += string(array_of_strings[i]);
		if (i < n - 1) {
			if (i < n - 2 || last_separator == undefined) {
				total_string += separator;
			}
			else {
				total_string += last_separator;
			}
		}
	}
	return total_string;
}


function string_join_list(list_of_strings/*: ds_list<any>*/, separator/*: string*/) /*-> string*/
{
	var total_string = "";
	var n = ds_list_size(list_of_strings);
	for (var i = 0; i < n; ++i) {
		total_string += string(list_of_strings[| i]);
		if (i < n - 1 && string_length(separator) > 0) {
			total_string += separator;
		}
	}
	return total_string;
}

function string_pad_right(str/*: string*/, length/*: number*/, separator/*: string*/ = " ") /*-> string*/
{
	str = string(str);
	if (string_length(separator) == 0) {
		separator = " ";
	}
	while (string_length(str) < length) {
		str += separator;
	}
	return str;
}

function string_pad_left(str/*: string*/, length/*: number*/, separator/*: string*/ = " ") /*-> string*/
{
	str = string(str);
	if (string_length(separator) == 0) {
		separator = " ";
	}
	while (string_length(str) < length) {
		str = separator + str;
	}
	return str;
}

function string_pad_left_and_right(str/*: string*/, length/*: number*/, separator/*: string*/ = " ") /*-> string*/
{
	str = string(str);
	if (string_length(separator) == 0) {
		separator = " ";
	}
	while (string_length(str) < length) {
		str = separator + str;
		if (string_length(str) < length) {
			str += separator;
		}
	}
	return str;
}

function string_pad(str/*: string*/, length/*: number*/, halign/*: horizontal_alignment*/, separator/*: string*/ = " ") /*-> string*/
{
	switch (halign) {
		case fa_left:	return string_pad_right(str, length, separator);
		case fa_center:	return string_pad_left_and_right(str, length, separator);
		case fa_right:	return string_pad_left(str, length, separator);
	}
	return str;
}

function string_starts_with(str/*: string*/, substr/*: string*/) /*-> bool*/
{
	var substr_len = string_length(substr);
	if (substr_len == 0) {
		return true;
	}
	return string_copy(str, 1, substr_len) == substr;
}

function string_ends_with(str/*: string*/, substr/*: string*/) /*-> bool*/
{
	var substr_len = string_length(substr);
	if (substr_len == 0) {
		return true;
	}
	var str_len = string_length(str);
	return string_copy(str, 1 + str_len - substr_len, substr_len) == substr;
}

function string_contains(str/*: string*/, substr/*: string*/) /*-> bool*/
{
	return string_pos(substr, str) >= 1;
}

function string_remove_prefix(str/*: string*/, prefix/*: string*/) /*-> string*/
{
	var prefix_len = string_length(prefix);
	if (string_copy(str, 1, prefix_len) == prefix) {
		return string_copy(str, prefix_len + 1, string_length(str));
	}
	return str;
}

function string_remove_postfix(str/*: string*/, postfix/*: string*/) /*-> string*/
{
	var str_len = string_length(str);
	var postfix_len = string_length(postfix);
	if (string_copy(str, str_len - postfix_len + 1, postfix_len) == postfix) {
		return string_copy(str, 1, str_len - postfix_len);
	}
	return str;
}

function string_json_uglify(json_string/*: string*/) /*-> string*/
{
    var str_buf = buffer_create(1024, buffer_grow, 1);
    
    var is_mid_string = false;
    for (var i = 1, str_len = string_length(json_string); i <= str_len; ++i) {
    	var char = string_char_at(json_string, i);
    	var write = false;
    	if (is_mid_string) {
    		write = true;
    		if (char == "\"" && (i <= 1 || string_char_at(json_string, i - 1) != "\\")) {
    			is_mid_string = false;
    		}
    	}
    	else {
    		if (char == "\"") {
    			is_mid_string = true;
    			write = true;
    		}
    		var is_whitespace = (char == "\n") || (char == "\r") || (char == "\t") || (char == " ");
    		write = !is_whitespace;
    	}
    	if (write) {
    		buffer_write(str_buf, buffer_text, char);
    	}
    }
    
    buffer_seek(str_buf, buffer_seek_start, 0);
    var uglified_string = buffer_read(str_buf, buffer_string);
    buffer_delete(str_buf);
    return uglified_string;
}

function StringJsonBeautifyOptions() constructor
{
	indent					= 4;		/// @is {int}
	space_before_colon		= false;	/// @is {bool}
	space_after_colon		= true;		/// @is {bool}
	newline_before_object	= false;	/// @is {bool}
	newline_before_array	= false;	/// @is {bool}
	newline_char			= "\n";		/// @is {string}
}

function string_json_beautify(json_string/*: string*/, options/*: StringJsonBeautifyOptions?*/ = undefined) /*-> string*/
{
	static default_options = new StringJsonBeautifyOptions();
	
	if (options == undefined) {
		options = default_options;
	}
	
	// For optimization purposes, snatch these to local variables.
	var indent					= options.indent;
	var space_before_colon		= options.space_before_colon;
	var space_after_colon		= options.space_after_colon;
	var newline_before_object	= options.newline_before_object;
	var newline_before_array	= options.newline_before_array;
	var newline_char			= options.newline_char;
	
	var uglified = string_json_uglify(json_string);
	
	var str_buf = buffer_create(1024, buffer_grow, 1);
	
	var num_indents = 0;
    var is_mid_string = false;
    for (var i = 1, str_len = string_length(uglified); i <= str_len; ++i) {
    	var char = string_char_at(uglified, i);
    	if (is_mid_string) {
    		buffer_write(str_buf, buffer_text, char);
    		if (char == "\"" && (i <= 1 || string_char_at(json_string, i - 1) != "\\")) {
    			is_mid_string = false;
    		}
    	}
    	else {
    		switch (char) {
	            case "{": case "[": {
	            	buffer_write(str_buf, buffer_text, char + newline_char);
	                num_indents += 1;
	                repeat (num_indents * indent) {
	                	buffer_write(str_buf, buffer_text, " ");
	                }
	                break;
	            }
	            case "}": case "]": {
	            	buffer_write(str_buf, buffer_text, newline_char);
	                num_indents -= 1;
	                repeat (num_indents * indent) {
	                	buffer_write(str_buf, buffer_text, " ");
	                }
	                buffer_write(str_buf, buffer_text, char);
	                break;
	            }
	            case ",": {
	            	buffer_write(str_buf, buffer_text, char + newline_char);
	                repeat (num_indents * indent) {
	                	buffer_write(str_buf, buffer_text, " ");
	                }
	                break;
	            }
	            case "\"": {
	            	buffer_write(str_buf, buffer_text, char);
	            	is_mid_string = true;
	            	break;
	            }
	            case ":": {
	            	if (space_before_colon) {
	            		buffer_write(str_buf, buffer_text, " ");
	            	}
	            	buffer_write(str_buf, buffer_text, char);
	            	if (space_after_colon && i < str_len) {
	            		var next_char = string_char_at(uglified, i + 1);
	            		if (newline_before_array && next_char == "[") {
	            			// don't
	            		}
	            		else if (newline_before_object && next_char == "{") {
	            			// don't
	            		}
	            		else {
	            			buffer_write(str_buf, buffer_text, " ");
	            		}
	            	}
	            	break;
	            }
	            default: {
	            	buffer_write(str_buf, buffer_text, char);
	            	break;
	            }
    		}
    	}
    }
	
    buffer_seek(str_buf, buffer_seek_start, 0);
    var beautified_string = buffer_read(str_buf, buffer_string);
    buffer_delete(str_buf);
    return beautified_string;
}
