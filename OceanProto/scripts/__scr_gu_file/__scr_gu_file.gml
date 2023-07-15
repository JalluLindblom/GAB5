
function file_read_text_lines(filename/*: string*/) /*-> string[]?*/
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

function file_read_string(filename/*: string*/) /*-> string?*/
{
	if (!file_exists(filename)) {
		return undefined;
	}
	
	var buffer = buffer_load(filename);
	if (!buffer_exists(buffer)) {
	    return undefined;
	}
	
	var str = undefined /*#as string?*/;
	if (buffer_get_size(buffer) > 0) {
		str = buffer_read(buffer, buffer_string);
	}
	buffer_delete(buffer);
	return str;
}

function file_read_json(filename/*: string*/) /*-> struct|Array|undefined*/
{
	var json_string = file_read_string(filename);
	var json = undefined;
    try {
        json = json_parse(json_string);
    }
    catch (_) { }
    var type = typeof(json);
    if (type != "struct" && type != "array") {
        json = undefined;
    }
    return json;
}

function file_write_json(filename/*: string*/, json/*: struct|Array*/) /*-> bool*/
{
	var json_string = json_stringify(json);
	return file_write_string(filename, json_string);
}

function file_write_string(filename/*: string*/, str/*: string*/) /*-> bool*/
{
	var wrote = false;
	var buf = buffer_create(1024, buffer_grow, 1);
	buffer_write(buf, buffer_text, str);
	try {
		buffer_save(buf, filename);
		wrote = true;
	}
	catch (err) {
		wrote = false;
	}
	buffer_delete(buf);
	return wrote;
}

function file_foreach(directory/*: string*/, mask/*: string*/, recursive/*: bool*/, callback/*: (function<string, void>)*/)
{
	var c = {
        find: undefined,
        mask: mask,
        recursive: recursive,
        callback: callback,
    };
    c.find = method(c, function(dir/*: string*/)
    {
        if (!string_ends_with(dir, "/") && !string_ends_with(dir, "\\")) {
            dir += "\\";
        }
        
        for (var filename = file_find_first(dir + mask, 0); filename != ""; filename = file_find_next()) {
        	callback(dir + filename);
        }
        file_find_close();
        
        if (recursive) {
	        var directories = [];
	        for (var dir_name = file_find_first(dir + "*", fa_directory); dir_name != ""; dir_name = file_find_next()) {
	            var full_dir_name = dir + dir_name + "\\";
	            if (directory_exists(full_dir_name)) {
	                array_push(directories, full_dir_name);
	            }
	        }
	        file_find_close();
	        
	        for (var i = 0, len = array_length(directories); i < len; ++i) {
	            find(directories[i]);
	        }
        }
        
    });
    
    c.find(directory);
}

function file_find_all(directory/*: string*/, mask/*: string*/, recursive/*: bool*/) /*-> string[]*/
{
	var c = { filenames: [] };
	var callback = method(c, function(filename/*: string*/) {
		array_push(filenames, filename);
	});
	file_foreach(directory, mask, recursive, callback);
	return c.filenames;
}

function file_path_get_stem(path/*: string*/) /*-> string?*/
{
	var path_len = string_length(path);
	var start_pos = max(0, string_last_pos("/", path), string_last_pos("\\", path)) + 1;
	if (start_pos > path_len) {
		return undefined;
	}
	var end_pos = string_last_pos(".", path);
	if (end_pos <= 0) {
		end_pos = path_len + 1;
	}
	return string_copy(path, start_pos, (end_pos - start_pos));
}
