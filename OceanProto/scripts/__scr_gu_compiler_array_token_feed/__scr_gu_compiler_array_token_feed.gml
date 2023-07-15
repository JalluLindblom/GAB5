
function ArrayTokenFeed(_tokensArray, _index, _isIgnoredFunc) constructor
{
    tokens = _tokensArray;
    index = _index;
    isIgnoredFunc = _isIgnoredFunc;
    
    static IsEmpty = function(skipIgnored/*: bool?*/ = undefined)
    {
        if (is_undefined(skipIgnored)) {
            skipIgnored = true;
        }
        if (!skipIgnored || index < array_length(tokens)) {
            return false;
        }
        var i = index;
        while (i < array_length(tokens)) {
            var token = tokens[@ i];
            if (!skipIgnored || !isIgnoredFunc(token)) {
                return false;
            }
        }
        return true;
    };
    
    static MaybeGet = function(tokenType, skipIgnored) {
        if (is_undefined(skipIgnored)) {
            skipIgnored = true;
        }
        if (index >= array_length(tokens)) {
            return undefined;
        }
        var token = tokens[@ index];
        if (!skipIgnored) {
            if (token.type == tokenType) {
                ++index;
                return token;
            }
            else {
                return undefined;
            }
        }
        else {
            for (var i = index; i < array_length(tokens); ++i) {
                token = tokens[@ i];
                if (!skipIgnored || !isIgnoredFunc(token)) {
                    if (token.type == tokenType) {
                        index = i + 1;
                        return token;
                    }
                    else {
                        return undefined;
                    }
                }
            }
        }
        return undefined;
    };
    
    static MaybeIs = function(tokenType, skipIgnored)
    {
        if (is_undefined(skipIgnored)) {
            skipIgnored = true;
        }
        if (index >= array_length(tokens)) {
            return false;
        }
        var token = tokens[@ index];
        if (!skipIgnored) {
            if (token.type == tokenType) {
                ++index;
                return true;
            }
            else {
                return false;
            }
        }
        else {
            for (var i = index; i < array_length(tokens); ++i) {
                token = tokens[@ i];
                if (!skipIgnored || !isIgnoredFunc(token)) {
                    if (token.type == tokenType) {
                        index = i + 1;
                        return true;
                    }
                    else {
                        return false;
                    }
                }
            }
        }
        return false;
    };
    
    static GetNext = function(skipIgnored)
    {
        if (is_undefined(skipIgnored)) {
            skipIgnored = true;
        }
        if (index >= array_length(tokens)) {
            return undefined;
        }
        var token = tokens[@ index];
        if (!skipIgnored) {
            ++index;
            return token;
        }
        else {
            for (var i = index; i < array_length(tokens); ++i) {
                token = tokens[@ i];
                if (!skipIgnored || !isIgnoredFunc(token)) {
                    index = i + 1;
                    return token;
                }
            }
        }
        return undefined;
    };
    
    static Peek = function(skipIgnored)
    {
        if (is_undefined(skipIgnored)) {
            skipIgnored = true;
        }
        if (index >= array_length(tokens)) {
            return undefined;
        }
        var token = tokens[@ index];
        if (!skipIgnored) {
            return token;
        }
        else {
            for (var i = index; i < array_length(tokens); ++i) {
                token = tokens[@ i];
                if (!skipIgnored || !isIgnoredFunc(token)) {
                    return token;
                }
            }
        }
        return undefined;
    };
};
