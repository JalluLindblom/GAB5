
enum GML_TOKEN_TYPE
{
    Identifier,
    Literal,
    Whitespace,


    RoundLeftBracket,
    RoundRightBracket,
    SquareLeftBracket,
    SquareRightBracket,
    CurlyLeftBracket,
    CurlyRightBracket,
    AngledLeftBracket,
    AngledRightBracket,
    Plus,
    Minus,
    Asterisk,
    ForwardSlash,
    Percent,
    Equal,
    DoubleEqual,
    Exclamation,
    Ampersand,
    DoubleAmpersand,
    VerticalBar,
    DoubleVerticalBar,
    QuestionMark,
    Tilde,
    Comma,
    Dot,
    Caret,
    Colon,
    Semicolon,
    At,
    NumberSign,
    
    If,
    Else,
    For,
    While,
    Do,
    Until,
    Return,
    Break,
    Continue,
    Var,
    Function,
    Constructor,
    Struct,
    Try,
    Catch,
    Finally,
    Exit,
    Static,
    With,
    New,
    Enum,
};

function GetGmlTokenRules()
{
    return [
        
        // Real number literal
        function (str) {
            var numDots = 0;
            var isNumber = true;
            for (var i = 1; i <= string_length(str); ++i) {
                var c = string_char_at(str, i);
                if (c == string_digits(c)) {
                    continue;
                }
                if (c == ".") {
                    if (++numDots <= 1) {
                        continue;
                    }
                }
                return undefined;
            }
            try {
                return new Token(str, GML_TOKEN_TYPE.Literal, real(str));
            }
            catch (_exception) {
                return undefined;
            };
            return undefined;
        },
        
        // String literal
        function (str) {
            if (string_length(str) >= 2 && __gml_string_starts_with(str, "\"") && __gml_string_ends_with(str, "\"") && string_count("\"", str) == 2) {
                return new Token(str, GML_TOKEN_TYPE.Literal, string_copy(str, 2, string_length(str) - 2));
            }
            else if (string_length(str) >= 2 && __gml_string_starts_with(str, "'") && __gml_string_ends_with(str, "'") && string_count("'", str) == 2) {
                return new Token(str, GML_TOKEN_TYPE.Literal, string_copy(str, 2, string_length(str) - 2));
            }
            return undefined;
        },
        
        // Word literals
        function (str) {
            var value = "no value";
            switch (str) {
                case "true": value = true; break;
                case "false": value = false; break;
                case "pointer_null": value = pointer_null; break;
                case "pointer_invalid": value = pointer_invalid; break;
                case "NaN": value = NaN; break;
                case "infinity": value = infinity; break;
                case "pi": value = pi; break;
                case "undefined": value = undefined; break;
                case "self": value = self; break;
                case "other": value = other; break;
                case "all": value = all; break;
                case "noone": value = noone; break;
                case "global": value = global; break;
            }
            if (value != "no value") {
                return new Token(str, GML_TOKEN_TYPE.Literal, value);
            }
            return undefined;
        },
        
        // Keywords
        function (str) {
            var type = undefined;
            switch (str) {
                case "if": type = GML_TOKEN_TYPE.If; break;
                case "else": type = GML_TOKEN_TYPE.Else; break;
                case "for": type = GML_TOKEN_TYPE.For; break;
                case "while": type = GML_TOKEN_TYPE.While; break;
                case "do": type = GML_TOKEN_TYPE.Do; break;
                case "until": type = GML_TOKEN_TYPE.Until; break;
                case "return": type = GML_TOKEN_TYPE.Return; break;
                case "break": type = GML_TOKEN_TYPE.Break; break;
                case "continue": type = GML_TOKEN_TYPE.Continue; break;
                case "var": type = GML_TOKEN_TYPE.Var; break;
                case "function": type = GML_TOKEN_TYPE.Function; break;
                case "constructor": type = GML_TOKEN_TYPE.Constructor; break;
                case "struct": type = GML_TOKEN_TYPE.Struct; break;
                case "try": type = GML_TOKEN_TYPE.Try; break;
                case "catch": type = GML_TOKEN_TYPE.Catch; break;
                case "finally": type = GML_TOKEN_TYPE.Finally; break;
                case "exit": type = GML_TOKEN_TYPE.Exit; break;
                case "static": type = GML_TOKEN_TYPE.Static; break;
                case "with": type = GML_TOKEN_TYPE.With; break;
                case "new": type = GML_TOKEN_TYPE.New; break;
                case "enum": type = GML_TOKEN_TYPE.Enum; break;
            }
            if (!is_undefined(type)) {
                return new Token(str, type);
            }
            return undefined;
        },
        
        // Special characters
        function (str) {
            var type = undefined;
            switch (str) {
                case "(": type = GML_TOKEN_TYPE.RoundLeftBracket; break;
                case ")": type = GML_TOKEN_TYPE.RoundRightBracket; break;
                case "[": type = GML_TOKEN_TYPE.SquareLeftBracket; break;
                case "]": type = GML_TOKEN_TYPE.SquareRightBracket; break;
                case "{": type = GML_TOKEN_TYPE.CurlyLeftBracket; break;
                case "}": type = GML_TOKEN_TYPE.CurlyRightBracket; break;
                case "<": type = GML_TOKEN_TYPE.AngledLeftBracket; break;
                case ">": type = GML_TOKEN_TYPE.AngledRightBracket; break;
                case "+": type = GML_TOKEN_TYPE.Plus; break;
                case "-": type = GML_TOKEN_TYPE.Minus; break;
                case "*": type = GML_TOKEN_TYPE.Asterisk; break;
                case "/": type = GML_TOKEN_TYPE.ForwardSlash; break;
                case "%": type = GML_TOKEN_TYPE.Percent; break;
                case "=": type = GML_TOKEN_TYPE.Equal; break;
                case "==": type = GML_TOKEN_TYPE.DoubleEqual; break;
                case "!": type = GML_TOKEN_TYPE.Exclamation; break;
                case "&": type = GML_TOKEN_TYPE.Ampersand; break;
                case "&&": type = GML_TOKEN_TYPE.DoubleAmpersand; break;
                case "|": type = GML_TOKEN_TYPE.VerticalBar; break;
                case "||": type = GML_TOKEN_TYPE.DoubleVerticalBar; break;
                case "?": type = GML_TOKEN_TYPE.QuestionMark; break;
                case "~": type = GML_TOKEN_TYPE.Tilde; break;
                case ",": type = GML_TOKEN_TYPE.Comma; break;
                case ".": type = GML_TOKEN_TYPE.Dot; break;
                case "^": type = GML_TOKEN_TYPE.Caret; break;
                case ":": type = GML_TOKEN_TYPE.Colon; break;
                case ";": type = GML_TOKEN_TYPE.Semicolon; break;
                case "@": type = GML_TOKEN_TYPE.At; break;
                case "#": type = GML_TOKEN_TYPE.NumberSign; break;
            }
            if (!is_undefined(type)) {
                return new Token(str, type);
            }
            return undefined;
        },
        
        // Identifier
        function (str) {
            for (var i = 1; i <= string_length(str); ++i) {
                var c = string_char_at(str, i);
                if (c == string_letters(c)) {
                    continue;
                }
                if (c == "_") {
                    continue;
                }
                if (c == string_digits(c) && i != 1) {
                    continue;
                }
                return undefined;
            }
            return new Token(str, GML_TOKEN_TYPE.Identifier);
        },
        
        // Whitespace
        function (str) {
            if (string_length(str) > 0) {
                for (var i = 0; i < string_length(str); ++i) {
                    var c = string_char_at(str, i + 1);
                    if (c != " " && c != "\r" && c != "\n" && c != "\t") {
                        return undefined;
                    }
                }
                return new Token(str, GML_TOKEN_TYPE.Whitespace);
            }
            return undefined;
        }
        
    ];
};
