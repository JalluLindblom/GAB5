
function http_create() /*-> __obj_gu_http*/
{
    var http = instance_create_depth(0, 0, 0, __obj_gu_http);
    return http;
}

function HttpResponse(_status/*: int*/, _url/*: string*/, _headers/*: struct*/, _result/*: string*/, _gm_status/*: number*/) constructor
{
    status      = _status;      /// @is {int}
    url         = _url;         /// @is {string}
    headers     = _headers;     /// @is {struct}
    result      = _result;      /// @is {string}
    gm_status   = _gm_status;   /// @is {number}
    
    static is_ok = function() /*-> bool*/
    {
        return (status >= 200) && (status < 300);
    }
    
    static text = function() /*-> string*/
    {
        return result;
    }
    
    static json = function() /*-> struct|Array|undefined*/
    {
        try {
            return json_parse(result);
        }
        catch (err) {
            return undefined;
        }
    }
}
