event_inherited();

base_url = "";      /// @is {string}
api_base_url = "";  /// @is {string}

http = http_create();   /// @is {__obj_gu_http}

headers = {}; /// @is {struct}

function initialize(_base_url/*: string*/, _username/*: string*/, _password/*: string*/)
{
    base_url = _base_url;
    api_base_url = base_url + "api/game";
    headers.Authorization = "Basic " + base64_encode(_username + ":" + _password);
}

function test_connection() /*-> Promise<bool>*/
{
    return http.get(base_url)
    .and_then(function(res/*: HttpResponse*/) {
        return res.is_ok() && res.gm_status == 0;
    });
}

function trial_submit(trial/*: TrialData*/) /*-> Promise<bool>*/
{
    var names = [];
    _struct_get_names_recursively(trial, "", names);
    var body = trial;
    var url = api_base_url + "/trials";
    return http.post_json(url, body, headers).and_then(function(res/*: HttpResponse*/) {
        if (!res.is_ok()) {
            log_warning("HTTP error: " + string(res.status));
            return false;
        }
        return true;
    });
}

function user_get_submitted_levels(user_id/*: string*/) /*-> Promise<string[]?>*/
{
    var url = api_base_url + "/levelsPerUser/" + user_id;
    return http.get(url, headers)
    .and_then(function(res/*: HttpResponse*/) {
        if (!res.is_ok()) {
            log_warning("HTTP error: " + string(res.status));
            return undefined;
        }
        return res.json();
    });
}

function user_get_submitted_trials(user_id/*: string*/, field_names/*: string[]*/) /*-> Promise<struct[]?>*/
{
    var url = api_base_url + "/trialsPerUser/" + user_id + "?fields=" + string_join_array(field_names, ",");
    return http.get(url, headers)
    .and_then(function(res/*: HttpResponse*/) {
        if (!res.is_ok()) {
            log_warning("HTTP error: " + string(res.status));
            return undefined;
        }
        return res.json();
    });
}

function user_get_total_score(user_id/*: string*/) /*-> Promise<number?>*/
{
    var url = api_base_url + "/totalScorePerUser/" + user_id;
    return http.get(url, headers)
    .and_then(function(res/*: HttpResponse*/) {
        if (!res.is_ok()) {
            log_warning("HTTP error: " + string(res.status));
            return undefined;
        }
        return res.json().total_score;
    });
}

function user_exists(user_id/*: string*/) /*-> Promise<bool?>*/
{
    var url = api_base_url + "/userExists/" + user_id;
    return http.get(url, headers)
    .and_then(function(res/*: HttpResponse*/) {
        if (!res.is_ok()) {
            log_warning("HTTP error: " + string(res.status));
            return undefined;
        }
        return (res.text() == "1");
    });
}