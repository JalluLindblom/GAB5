
/// Takes a string that may or may not contain tags for Scribble rendering,
/// removes those tags and returns the modified string.
function utils_scribble_remove_tags(text/*: string*/) /*-> string*/
{
    var str_buf = buffer_create(1024, buffer_grow, 1);
    
    var tag_start_pos = -1;
    var len = string_length(text);
    for (var pos = 1; pos <= len; ++pos) {
        var char = string_char_at(text, pos);
        if (tag_start_pos >= 1) {
            if (char == "]") {
                tag_start_pos = -1;
            }
        }
        else if (char == "[") {
            if (pos < len && string_char_at(text, pos + 1) == "[") {
                // don't do anything
            }
            else if (pos > 1 && string_char_at(text, pos - 1) == "[") {
                buffer_write(str_buf, buffer_text, char);
            }
            else {
                tag_start_pos = pos;
            }
        }
        else {
            buffer_write(str_buf, buffer_text, char);
        }
    }
    
    if (tag_start_pos >= 1) {
        buffer_write(str_buf, buffer_text, string_copy(text, tag_start_pos, len - (tag_start_pos - 1)));
    }
    
    buffer_seek(str_buf, buffer_seek_start, 0);
    var str = buffer_read(str_buf, buffer_string);
    buffer_delete(str_buf);
    return str;
}
