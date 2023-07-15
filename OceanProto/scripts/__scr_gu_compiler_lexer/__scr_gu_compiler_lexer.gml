
function TokenizeException(_position, _message) constructor
{
	position = _position;
	msg = string(_message);
	
	static toString = function() {
		return "At " + string(position) + ": " + msg;
	};
};

/// @param {string} str
/// @param {*}		type
/// @param {*}      literalValue=undefined
function Token(_str, _type) constructor
{
    var _literalValue = argument_count >= 3 ? argument[2] : undefined;
    
    str = _str;
    type = _type;
    position = -1;
    literalValue = _literalValue;
    
    static toString = function() {
        return "{ str: " + str + ", type: " + string(type) + " }";
    };
};

/// @param {(function(str) => Token)[]} tokenRules
function Lexer(_tokenRules) constructor
{
	tokenRules = _tokenRules;
	
	/// @desc	Tokenizes the given string into an array of tokens.
	///			Throws TokenizeException on tokenization failure.
	/// @param {string} str
	/// @param {Number} positionOffset=0
	/// @return {Token[]}
	static TokenizeString = function(str)
	{
		var positionOffset = argument_count >= 2 ? argument[1] : 0;
		
		if (positionOffset >= string_length(str)) {
			return [];
		}
		
	    var tokens = [];
	    var startPos = 1;
	    var tokenParsedAtLastPos = undefined;
	    for (var endPos = 2; endPos <= string_length(str) + 1; ++endPos) {
	        var tokenStr = string_copy(str, startPos, endPos - startPos);
	        var token = _StringToToken(tokenStr, positionOffset + startPos);
	        if (token == undefined && tokenParsedAtLastPos != undefined) {
	        	array_push(tokens, tokenParsedAtLastPos);
	            endPos -= 1;
	            startPos = endPos;
	        }
	        tokenParsedAtLastPos = token;
	    }
	    if (is_undefined(tokenParsedAtLastPos)) {
	        var msg = "Unexpected token at " + string(startPos) + ".";
	        throw new TokenizeException(positionOffset + startPos, msg);
	    }
	    if (tokenParsedAtLastPos != undefined) {
	    	array_push(tokens, tokenParsedAtLastPos);
	    }
	    return tokens;
	};
	
	static _StringToToken = function(str, position)
	{
	    for (var i = 0; i < array_length(tokenRules); ++i) {
	        var rule = tokenRules[@ i];
	        var token = rule(str);
	        if (!is_undefined(token)) {
	        	token.position = position;
	            return token;
	        }
	    }
	    return undefined;
	};
};
