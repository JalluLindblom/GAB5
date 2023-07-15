event_inherited();

var req_id = async_load[? "id"];
if (ds_map_exists(_req_callbacks, req_id)) {
    var callback = _req_callbacks[? req_id];
    var res_headers_map = /*#cast*/ async_load[? "response_headers"] /*#as ds_map*/;
    var res_http_status = async_load[? "http_status"];
    var res_url = async_load[? "url"];
    var res_status = async_load[? "status"];
    var res_result = async_load[? "result"];
    if (res_status > 0) {
        // Don't do anything, it's still coming.
    }
    else {
        ds_map_delete(_req_callbacks, req_id);
        var headers_struct = ds_exists(res_headers_map, ds_type_map) ? struct_from_ds_map(res_headers_map) : {};
        var res = new HttpResponse(res_http_status, res_url, headers_struct, res_result, res_status);
        callback(res);
    }
}