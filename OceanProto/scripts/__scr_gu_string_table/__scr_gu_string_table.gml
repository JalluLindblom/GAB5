
/// @param {horizontal_alignment} ...haligns
function StringTable() constructor
{
    haligns = array_create(argument_count, fa_left);            /// @is {horizontal_alignment[]}
    for (var i = 0; i < argument_count; ++i) {
        haligns[i] = argument[i];
    }
    width = array_length(haligns);                              /// @is {int}
    rows = [];                                                  /// @is {string[][]}
    max_len_per_col = array_create(array_length(haligns), 0);   /// @is {int[]}
    
    /// @param {string} ...values
    static add_row = function()
    {
        var row = array_create(width, "");
        array_push(rows, row);
        for (var i = 0; i < argument_count; ++i) {
            var value = argument[i];
            row[i] = value;
            var len = string_length(value);
            if (len > max_len_per_col[i]) {
                max_len_per_col[i] = len;
            }
        }
    }
    
    /// @returns {string}
    static dump = function(padding/*: int*/, separator/*: string*/) /*-> string*/
    {
        var num_rows = array_length(rows);
        var num_cols = array_length(haligns);
        if (num_rows <= 0 || num_cols <= 0) {
            return "";
        }
        
        var str_buf = buffer_create(1024, buffer_grow, 1);
        
        for (var i = 0; i < num_rows; ++i) {
            for (var j = 0; j < num_cols; ++j) {
                var col_padding = j < num_cols - 1 ? padding : 0;
                var col_str = string_pad(rows[i][j], max_len_per_col[j] + col_padding, haligns[j], separator);
                buffer_write(str_buf, buffer_text, col_str);
            }
            if (i < num_rows - 1) {
                buffer_write(str_buf, buffer_text, "\n");
            }
        }
        
        buffer_seek(str_buf, buffer_seek_start, 0);
        var str = buffer_read(str_buf, buffer_string);
        buffer_delete(str_buf);
        return str;
    }
}
