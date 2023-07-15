event_inherited();

_req_callbacks = ds_map_create();    /// @is {ds_map<int, function<HttpResponse, void>>}

function get(url/*: string*/, headers/*: ds_map|struct|undefined*/ = undefined, callback/*: (function<HttpResponse, void>)?*/ = undefined) /*-> Promise<HttpResponse>*/
{
    var h = _create_headers_map(headers);
    var ret = request(url, "GET", "", h, callback);
    ds_map_destroy(h);
    return ret;
}

function post_string(url/*: string*/, body/*: string*/, headers/*: ds_map|struct|undefined*/ = undefined, callback/*: (function<HttpResponse, void>)?*/ = undefined) /*-> Promise<HttpResponse>*/
{
    var h = _create_headers_map(headers);
    h[? "Content-Type"] = "text/plain";
    var ret = request(url, "POST", body, h, callback);
    ds_map_destroy(h);
    return ret;
}

function post_json(url/*: string*/, body/*: struct|Array*/, headers/*: ds_map|struct|undefined*/ = undefined, callback/*: (function<HttpResponse, void>)?*/ = undefined) /*-> Promise<HttpResponse>*/
{
    var h = _create_headers_map(headers);
    h[? "Content-Type"] = "application/json";
    var ret = request(url, "POST", json_stringify(body), h, callback);
    ds_map_destroy(h);
    return ret;
}

function request(url/*: string*/, http_method/*: string*/, body/*: number|string|buffer*/, headers/*: ds_map|struct|undefined*/, callback/*: (function<HttpResponse, void>)*/) /*-> Promise<HttpResponse>*/
{
    var destroy_created_header_map = false;
    var headers_map = -1 /*#as ds_map*/;
    if (is_struct(headers)) {
        destroy_created_header_map = true;
        headers_map = struct_to_ds_map(/*#cast*/ headers);
    }
    else if (headers == undefined) {
        destroy_created_header_map = true;
        headers_map = ds_map_create();
    }
    else {
        headers_map = /*#cast*/ headers;
    }
    
    var req_id = http_request(url, http_method, headers_map, body);
    
    if (destroy_created_header_map) {
        ds_map_destroy(headers_map);
    }
    
    if (callback != undefined) {
        _req_callbacks[? req_id] = callback;
        return undefined;
    }
    else {
        return new Promise(method({ http: id, req_id: req_id }, function(resolve, reject) {
            if (!instance_exists(http)) {
                return;
            }
            http._req_callbacks[? req_id] = resolve;
        }));
    }
}


function _create_headers_map(custom_headers/*: ds_map|struct|undefined*/) /*-> ds_map*/
{
    var h = ds_map_create();
    if (custom_headers != undefined) {
        if (is_struct(custom_headers)) {
            struct_to_ds_map(/*#cast*/ custom_headers, h);
        }
        else {
            ds_map_copy(/*#cast*/ custom_headers, h);
        }
    }
    return h;
}
