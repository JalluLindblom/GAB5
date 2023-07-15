
function GmlRunTimeException(_message) constructor
{
    message = string(_message);
    static toString = function() {
        return message;
    };
};

function GmlParseException(_message) constructor
{
    message = string(_message);
    static toString = function() {
        return message;
    };
};

function _ResolveGmlIdentifier(identifierString)
{
    var asset = asset_get_index(identifierString);
    if (asset >= 0) {
        return asset;
    }
    var funcIndex = __gu_compiler_get_function_index();
    var gmFunc = funcIndex[? identifierString];
    if (!is_undefined(gmFunc)) {
        return gmFunc;
    }
    if (variable_global_exists(identifierString)) {
        return variable_global_get(identifierString);
    }
    throw new GmlRunTimeException("Variable " + string(identifierString) + " not set before reading it.");
};

function _DotId(lhs, idStr) {
    if (lhs == global) {
        return variable_global_get(idStr);
    }
    if (is_struct(lhs)) {
        return variable_struct_get(lhs, idStr);
    }
    if (object_exists(lhs)) {
        var instance = instance_find(lhs, 0);
        return variable_instance_get(instance, idStr);
    }
    if (instance_exists(lhs)) {
        return variable_instance_get(lhs, idStr);
    }
    throw "No";
};

function GmlParser() constructor
{
    /*
    Formal grammar:
    
    EXP                 -> TERM BOP_TERM*
    BOP_TERM            -> BINARY_OPERATOR TERM
    TERM                -> UNARY_OPERATOR TERM TERM'?
                        |  '[' (EXP (',' EXP)*)? ']' TERM'?
                        |  '(' EXP ')' TERM'?
                        |  literal TERM'?
                        |  identifier TERM'?
    TERM'               -> '.' identifier ']' TERM'?
                        |  '[' ARRAY_COPY_ACCESS ']' TERM'?
                        |  '[' ARRAY_REF_ACCESS ']' TERM'?
                        |  '[' MAP_ACCESS ']' TERM'?
                        |  '[' LIST_ACCESS ']' TERM'?
                        |  '[' GRID_ACCESS ']' TERM'?
                        |  PAR_ARGS TERM'?
    ARRAY_COPY_ACCESS   -> EXP
    ARRAY_REF_ACCESS    -> '@' EXP
    MAP_ACCESS          -> '?' EXP
    LIST_ACCESS         -> '|' EXP
    GRID_ACCESS         -> '#' EXP ',' EXP
    PAR_ARGS            -> '(' (EXP (',' EXP)*)* ')'
    BINARY_OPERATOR     -> special_character
    UNARY_OPERATOR      -> special_character
    */
    
    static _success = function(_data)
    {
        return {
            success: true,
            data: _data
        };
    };
    
    static _fail = function()
    {
        return {
            success: false
        };
    };
    
    static EXP = function(token_feed)
    {
        var termRes = TERM(token_feed);
        if (!termRes.success) {
            return _fail();
        }
        var bopTermRes = BOP_TERM(token_feed);
        if (!bopTermRes.success) {
            return _success({
                func: termRes.data.evalFunc
            });
        }
        else {
            // TODO: Operator precedence
            var lhsTermEvalFunc = termRes.data.evalFunc;
            while (bopTermRes.success) {
                var capture = {
                    binaryFunction: bopTermRes.data.binaryFunction,
                    lhsTermEvalFunc: lhsTermEvalFunc,
                    rhsTermEvalFunc: bopTermRes.data.rhsTermEvalFunc
                };
                lhsTermEvalFunc = method(capture, function() {
                    return binaryFunction(lhsTermEvalFunc(), rhsTermEvalFunc());
                });
                bopTermRes = BOP_TERM(token_feed);
            }
            return _success({
                func: lhsTermEvalFunc
            });
        }
    };
    
    static BOP_TERM = function(token_feed)
    {
        var binOpRes = BINARY_OPERATOR(token_feed);
        if (!binOpRes.success) {
            return _fail();
        }
        var termRes = TERM(token_feed);
        if (!termRes.success) {
            throw new GmlParseException("Expected a term after binary operator.");
        }
        return _success({
            binaryFunction: binOpRes.data.binaryFunction,
            precedence: binOpRes.data.precedence,
            rhsTermEvalFunc: termRes.data.evalFunc
        });
    };
    
    static TERM = function(token_feed)
    {
        var evalFunc = undefined;
        
        var unOpRes = UNARY_OPERATOR(token_feed);
        if (unOpRes.success) {
            // -> UNARY_OPERATOR TERM TERM'?
            var termRes = TERM(token_feed);
            if (!termRes.success) {
                throw new GmlParseException("Expected a term after unary operator.");
            }
            var capture = {
                unaryFunction: unOpRes.data.unaryFunction,
                termEvalFunc: termRes.data.evalFunc
            };
            evalFunc = method(capture, function() {
                return unaryFunction(termEvalFunc());
            });
        }
        else {
            if (token_feed.MaybeIs(GML_TOKEN_TYPE.SquareLeftBracket)) {
                // -> '[' (EXP (',' EXP)*)? ']' TERM'?
                var expRes = EXP(token_feed);
                var arrayElementFuncs = [];
                while (!is_undefined(expRes)) {
                    array_push(arrayElementFuncs, expRes.data.func);
                    expRes = undefined;
                    if (token_feed.MaybeIs(GML_TOKEN_TYPE.Comma)) {
                        expRes = EXP(token_feed);
                        if (!expRes.success) {
                            throw new GmlParseException("Expected an expression after comma.");
                        }
                    }
                }
                if (!token_feed.MaybeIs(GML_TOKEN_TYPE.SquareRightBracket)) {
                    throw new GmlParseException("Expected a square right bracket.");
                }
                var capture = {
                    arrayElementFuncs: arrayElementFuncs
                };
                evalFunc = method(capture, function() {
                    var evaluatedArrayElements = array_create(array_length(arrayElementFuncs));
                    for (var i = 0; i < array_length(arrayElementFuncs); ++i) {
                        evaluatedArrayElements[@ i] = arrayElementFuncs[@ i]();
                    }
                    return evaluatedArrayElements;
                });
            }
            else if (token_feed.MaybeIs(GML_TOKEN_TYPE.RoundLeftBracket)) {
                // -> '(' EXP ')' TERM'?
                var expRes = EXP(token_feed);
                if (!expRes.success) {
                    throw new GmlParseException("Expected an expression after round left bracket.");
                }
                if (!token_feed.MaybeIs(GML_TOKEN_TYPE.RoundRightBracket)) {
                    throw new GmlParseException("Expected a round right bracket to end the expression.");
                }
                evalFunc = expRes.data.func;
            }
            else {
                // -> literal TERM'?
                var token = token_feed.MaybeGet(GML_TOKEN_TYPE.Literal);
                if (!is_undefined(token)) {
                    var capture = {
                        literalValue: token.literalValue
                    };
                    evalFunc = method(capture, function() {
                        return literalValue;
                    });
                }
                else {
                    // -> identifier TERM'?
                    token = token_feed.MaybeGet(GML_TOKEN_TYPE.Identifier);
                    if (!is_undefined(token)) {
                        var capture = {
                            identifierString: token.str
                        };
                        evalFunc = method(capture, function() {
                            return _ResolveGmlIdentifier(identifierString);
                        });
                    }
                }
            }
        }
        
        if (is_undefined(evalFunc)) {
            return _fail();
        }
        
        var termPrimeRes = TERM_PRIME(token_feed);
        if (termPrimeRes.success) {
            var capture = {
                termFunc: evalFunc,
                termPrimeFunc: termPrimeRes.data.func
            };
            return _success({
                evalFunc: method(capture, function() {
                    return termPrimeFunc(termFunc());
                })
            });
        }
        else {
            return _success({
                evalFunc: evalFunc
            });
        }
    };
    
    static TERM_PRIME = function(token_feed)
    {
        var evalFunc = undefined;
        
        if (token_feed.MaybeIs(GML_TOKEN_TYPE.Dot)) {
            // -> '.' identifier TERM'?
            var idToken = token_feed.MaybeGet(GML_TOKEN_TYPE.Identifier);
            if (is_undefined(idToken)) {
                throw new GmlParseException("Expected an identifier.");
            }
            
            var capture = {
                idString: idToken.str
            };
            evalFunc = method(capture, function(term) {
                return _DotId(term, idString);
            });
        }
        else if (token_feed.MaybeIs(GML_TOKEN_TYPE.SquareLeftBracket)) {
            var arrayCopyAccessRes = ARRAY_COPY_ACCESS(token_feed);
            if (arrayCopyAccessRes.success) {
                evalFunc = arrayCopyAccessRes.data.evalFunc;
            }
            if (is_undefined(evalFunc)) {
                var arrayRefAccessRes = ARRAY_REF_ACCESS(token_feed);
                if (arrayRefAccessRes.success) {
                    evalFunc = arrayRefAccessRes.data.evalFunc;
                }
            }
            if (is_undefined(evalFunc)) {
                var mapAccessRes = MAP_ACCESS(token_feed);
                if (mapAccessRes.success) {
                    evalFunc = mapAccessRes.data.evalFunc;
                }
            }
            if (is_undefined(evalFunc)) {
                var listAccessRes = LIST_ACCESS(token_feed);
                if (listAccessRes.success) {
                    evalFunc = listAccessRes.data.evalFunc;
                }
            }
            if (is_undefined(evalFunc)) {
                var gridAccessRes = GRID_ACCESS(token_feed);
                if (gridAccessRes.success) {
                    evalFunc = gridAccessRes.data.evalFunc;
                }
            }
            
            if (is_undefined(evalFunc)) {
                throw new GmlParseException("Expected an accessor expression after square left bracket.");
            }
            if (!token_feed.MaybeIs(GML_TOKEN_TYPE.SquareRightBracket)) {
                throw new GmlParseException("Expected a square right bracket after accessor expression.");
            }
        }
        else {
            var parArgsRes = PAR_ARGS(token_feed);
            if (parArgsRes.success) {
                var capture = {
                    argFuncs: parArgsRes.data.argFuncs
                };
                evalFunc = method(capture, function(term) {
                    var evaluatedArgs = __gml_array_mapped(argFuncs, function(f) { return f(); });
                    return execute_function_with_array_of_args(term, evaluatedArgs);
                });
            }
        }
        
        if (is_undefined(evalFunc)) {
            return _fail();
        }
        
        var termPrimeRes = TERM_PRIME(token_feed);
        if (termPrimeRes.success) {
            var capture = {
                termPrimeFunc: termPrimeRes.data.func,
                evalFunc: evalFunc
            };
            return _success({
                func: method(capture, function(term) {
                    return termPrimeFunc(evalFunc(term));
                })
            });
        }
        else {
            return _success({
                func: evalFunc
            });
        }
    };
    
    static ARRAY_COPY_ACCESS = function(token_feed)
    {
        var expRes = EXP(token_feed);
        if (!expRes.success) {
            return _fail();
        }
        var capture = {
            indexFunc: expRes.data.func
        };
        return _success({
            evalFunc: method(capture, function(term) {
                var index = indexFunc();
                if (index < 0 || index >= array_length(term)) {
                    throw new GmlRunTimeException("Index " + string(index) + " out of range.");
                }
                return term[index];
            })
        });
    };
    
    static ARRAY_REF_ACCESS = function(token_feed)
    {
        if (!token_feed.MaybeIs(GML_TOKEN_TYPE.At)) {
            return _fail();
        }
        var expRes = EXP(token_feed);
        if (!expRes.success) {
            throw new GmlParseException("Expected an array accessor expression after \"@\".");
        }
        var capture = {
            indexFunc: expRes.data.func
        };
        return _success({
            evalFunc: method(capture, function(term) {
                var index = indexFunc();
                if (index < 0 || index >= array_length(term)) {
                    throw new GmlRunTimeException("Index " + string(index) + " out of range.");
                }
                return term[@ index];
            })
        });
    };
    
    static MAP_ACCESS = function(token_feed)
    {
        if (!token_feed.MaybeIs(GML_TOKEN_TYPE.QuestionMark)) {
            return _fail();
        }
        var expRes = EXP(token_feed);
        if (!expRes.success) {
            throw new GmlParseException("Expected a map accessor expression after \"?\".");
        }
        var capture = {
            keyFunc: expRes.data.func
        };
        return _success({
            evalFunc: method(capture, function(term) {
                var key = keyFunc();
                return term[? key];
            })
        });
    };
    
    static LIST_ACCESS = function(token_feed)
    {
        if (!token_feed.MaybeIs(GML_TOKEN_TYPE.VerticalBar)) {
            return _fail();
        }
        var expRes = EXP(token_feed);
        if (!expRes.success) {
            throw new GmlParseException("Expected a list accessor expression after \"|\".");
        }
        var capture = {
            indexFunc: expRes.data.func
        };
        return _success({
            evalFunc: method(capture, function(term) {
                var index = indexFunc();
                return term[| index];
            })
        });
    };
    
    static GRID_ACCESS = function(token_feed)
    {
        if (!token_feed.MaybeIs(GML_TOKEN_TYPE.NumberSign)) {
            return _fail();
        }
        var xExpRes = EXP(token_feed);
        if (!xExpRes.success) {
            throw new GmlParseException("Expected an x-position grid accessor expression after \"#\".");
        }
        if (!token_feed.MaybeIs(GML_TOKEN_TYPE.Comma)) {
            throw new GmlParseException("Expected a comma after the x-position grid accessor expression.");
        }
        var yExpRes = EXP(token_feed);
        if (!yExpRes.success) {
            throw new GmlParseException("Expected a y-position grid accessor expression after comma.");
        }
        var capture = {
            xPosFunc: xExpRes.data.func,
            yPosFunc: yExpRes.data.func
        };
        return _success({
            evalFunc: method(capture, function(term) {
                var xPos = xPosFunc();
                var yPos = yPosFunc();
                return term[# xPos, yPos];
            })
        });
    };
    
    static PAR_ARGS = function(token_feed)
    {
        if (!token_feed.MaybeIs(GML_TOKEN_TYPE.RoundLeftBracket)) {
            return _fail();
        }
        var expRes = EXP(token_feed);
        var argFuncs = [];
        while (!is_undefined(expRes) && expRes.success) {
            array_push(argFuncs, expRes.data.func);
            expRes = undefined;
            if (token_feed.MaybeIs(GML_TOKEN_TYPE.Comma)) {
                expRes = EXP(token_feed);
                if (!expRes.success) {
                    throw new GmlParseException("Expected an expression after comma.");
                }
            }
        }
        if (!token_feed.MaybeIs(GML_TOKEN_TYPE.RoundRightBracket)) {
            throw new GmlParseException("Expected a round right bracket.");
        }
        return _success({
            argFuncs: argFuncs
        });
    };
    
    static BINARY_OPERATOR = function(token_feed)
    {
        var f = undefined; // function
        var p = undefined; // precedence
        
        if (token_feed.MaybeIs(GML_TOKEN_TYPE.Plus)) {                      p = 11; f = function(lhs, rhs) { return lhs + rhs; }; }
        else if (token_feed.MaybeIs(GML_TOKEN_TYPE.Minus)) {                p = 11; f = function(lhs, rhs) { return lhs - rhs; }; }
        else if (token_feed.MaybeIs(GML_TOKEN_TYPE.Asterisk)) {             p = 12; f = function(lhs, rhs) { return lhs * rhs; }; }
        else if (token_feed.MaybeIs(GML_TOKEN_TYPE.ForwardSlash)) {         p = 12; f = function(lhs, rhs) { return lhs / rhs; }; }
        else if (token_feed.MaybeIs(GML_TOKEN_TYPE.Percent)) {              p = 12; f = function(lhs, rhs) { return lhs % rhs; }; }
        else if (token_feed.MaybeIs(GML_TOKEN_TYPE.DoubleEqual)) {          p = 8;  f = function(lhs, rhs) { return lhs == rhs; }; }
        else if (token_feed.MaybeIs(GML_TOKEN_TYPE.Ampersand)) {            p = 7;  f = function(lhs, rhs) { return lhs & rhs; }; }
        else if (token_feed.MaybeIs(GML_TOKEN_TYPE.DoubleAmpersand)) {      p = 4;  f = function(lhs, rhs) { return lhs && rhs; }; }
        else if (token_feed.MaybeIs(GML_TOKEN_TYPE.VerticalBar)) {          p = 5;  f = function(lhs, rhs) { return lhs | rhs; }; }
        else if (token_feed.MaybeIs(GML_TOKEN_TYPE.DoubleVerticalBar)) {    p = 3;  f = function(lhs, rhs) { return lhs || rhs; }; }
        else if (token_feed.MaybeIs(GML_TOKEN_TYPE.Caret)) {                p = 6;  f = function(lhs, rhs) { return lhs ^ rhs; }; }
        
        if (is_undefined(f)) {
            return _fail();
        }
        else {
            return _success({
                binaryFunction: f,
                precedence: p
            });
        }
    };
    
    static UNARY_OPERATOR = function(token_feed)
    {
        var f = undefined;
        if (token_feed.MaybeIs(GML_TOKEN_TYPE.Plus)) {
            f = function(operand) { return +operand; };
        }
        else if (token_feed.MaybeIs(GML_TOKEN_TYPE.Minus)) {
            f = function(operand) { return -operand; };
        }
        else if (token_feed.MaybeIs(GML_TOKEN_TYPE.Exclamation)) {
            f = function(operand) { return !operand; };
        }
        
        if (is_undefined(f)) {
            return _fail();
        }
        else {
            return _success({
                unaryFunction: f
            });
        }
    };
    
};
