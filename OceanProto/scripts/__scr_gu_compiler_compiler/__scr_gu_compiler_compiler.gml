
function GmlCompileException(_message) constructor
{
    message = string(_message);
    static toString = function()
    {
        return message;
    }
}

function GmlCompiler() constructor
{
    parser = new GmlParser();
    lexer = new Lexer(GetGmlTokenRules());
    
    static compile_expression_from_string = function(gml_string/*: string*/)
    {
        var tokens = lexer.TokenizeString(gml_string);
        var token_feed = new ArrayTokenFeed(tokens, 0, function(token) { return token.type == GML_TOKEN_TYPE.Whitespace; });
        var expression = parser.EXP(token_feed);
        if (expression.success) {
            if (!token_feed.IsEmpty()) {
                throw new GmlCompileException("Unexpected token after expression.");
            }
            return expression.data.func;
        }
        else {
            throw new GmlCompileException("Unexpected token.");
        }
    }
}
