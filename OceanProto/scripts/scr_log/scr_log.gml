
function initialize_log()
{
    CALL_ONLY_ONCE
    
    instance_create_depth(0, 0, 0, obj_logger);
    
    global.scream_log_errors = false;   /// @is {bool}
}

function log(message/*: string*/)
{
    obj_logger._log(message);
}

function log_warning(message/*: string*/)
{
    obj_logger._log_warning(message);
}

function log_error(message/*: string*/)
{
    obj_logger._log_error(message);
}
