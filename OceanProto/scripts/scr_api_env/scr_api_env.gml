
#macro API_ENV_FILENAME ".api_env.json"

function initialize_api_env()
{
    CALL_ONLY_ONCE
    
    globalvar API_ENV; /// @is {ApiEnv}
    
    var json = file_read_json(API_ENV_FILENAME);
    
    if (json == undefined) {
        log_error("Couldn't find API configuration file \"" + API_ENV_FILENAME + "\".");
        API_ENV = new ApiEnv("", "", "");
    }
    else {
        API_ENV = new ApiEnv(json.remote_url, json.api_username, json.api_password);
    }
}

function ApiEnv(_remote_url/*: string*/, _api_username/*: string*/, _api_password/*: string*/) constructor
{
    remote_url = _remote_url; /// @is {string}
    api_username = _api_username; /// @is {string}
    api_password = _api_password; /// @is {string}
}
