event_inherited();

output_filename = undefined;    /// @is {string?}
output_file     = -1;           /// @is {file_handle}
dump_timer      = 0;            /// @is {number}

output_file_log_buffer      = [];   /// @is {string[]}
output_file_log_buffer_len  = 0;    /// @is {int]}

if (ProgramParams.log_output_file != undefined && is_string(ProgramParams.log_output_file)) {
    output_filename = ProgramParams.log_output_file;
    output_file = file_text_open_write(output_filename);
}

_make_timestamp = function() /*-> string*/
{
    static _str = function(num/*: number*/) /*-> string*/
    {
        var str = string(num);
        if (string_length(str) == 1) {
            str = "0" + str;
        }
        return str;
    }
    var time = date_current_datetime();
    var year    = _str(date_get_year(time));
    var month   = _str(date_get_month(time));
    var day     = _str(date_get_day(time));
    var hour    = _str(date_get_hour(time));
    var minute  = _str(date_get_minute(time));
    var second  = _str(date_get_second(time));
    return year +  "_" + month + "_" + day + "_" + hour + "_" + minute + "_" + second;
}

_log = function(message/*: string*/)
{
    message = _make_timestamp() + " " + message;
    var no_scribble_message = utils_scribble_remove_tags(message)
    show_debug_message(no_scribble_message);
    if (DEBUG_MODE) {
        DebugTerminal.println(message);
    }
    if (output_file >= 0) {
        output_file_log_buffer[output_file_log_buffer_len++] = no_scribble_message;
    }
}

_log_warning = function(message/*: string*/)
{
    message = _make_timestamp() + " " + message;
    message = "[#dddd55]Warning:[/c] " + message;
    var no_scribble_message = utils_scribble_remove_tags(message);
    if (global.scream_log_errors) {
        show_message(no_scribble_message);
    }
    show_debug_message(no_scribble_message);
    if (DEBUG_MODE) {
        DebugTerminal.println(message);
    }
    if (output_file >= 0) {
        output_file_log_buffer[output_file_log_buffer_len++] = no_scribble_message;
    }
}

_log_error = function(message/*: string*/)
{
    message = _make_timestamp() + " " + message;
    message = "[#dd5555]Error:[/c] " + message;
    var no_scribble_message = utils_scribble_remove_tags(message);
    if (global.scream_log_errors) {
        show_message(no_scribble_message);
    }
    show_debug_message(no_scribble_message);
    if (DEBUG_MODE) {
        DebugTerminal.println(message);
    }
    if (output_file >= 0) {
        output_file_log_buffer[output_file_log_buffer_len++] = no_scribble_message;
    }
}

_dump = function()
{
    if (output_file >= 0) {
        for (var i = 0; i < output_file_log_buffer_len; ++i) {
            file_text_write_string(output_file, output_file_log_buffer[i]);
            file_text_writeln(output_file);
        }
        file_text_close(output_file);
        output_file = file_text_open_append(output_filename);
    }
    output_file_log_buffer_len = 0;
}