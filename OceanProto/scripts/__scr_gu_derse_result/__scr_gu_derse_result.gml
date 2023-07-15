
function DerseResult(_value/*: any*/, _error/*: string?*/) constructor
{
    value = _value; /// @is {any}
    error = _error; /// @is {string?}
}

function __derse_success(value/*: any*/) /*-> DerseResult*/
{
    return new DerseResult(value, undefined);
}

function __derse_error(error/*: string*/) /*-> DerseResult*/
{
    return new DerseResult(undefined, error);
}
