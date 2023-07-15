
function derse_read(value/*: any*/, schema/*: string|struct|DerseSchema*/) /*-> DerseResult*/
{
    if (is_string(schema)) {
        return __derse_read_with_string_schema(value, schema /*#as string*/);
    }
    else if (__is_derse_schema_constructor(schema)) {
        return __derse_read_with_complex_schema(value, schema /*#as DerseSchema*/);
    }
    else if (is_struct(schema)) {
        return __derse_read_with_struct_schema(value, schema /*#as struct*/);
    }
    else {
        return __derse_error("Invalid schema.");
    }
}

function __derse_read_with_string_schema(value/*: any*/, schema/*: string*/) /*-> DerseResult*/
{
    var type = typeof(value);
    if (type == schema) {
        return __derse_success(value);
    }
    else {
        return __derse_error("Expected a value of type \"" + schema + "\", but it was \"" + type + ".");
    }
}

function __derse_read_with_complex_schema(value/*: any*/, schema/*: DerseSchema*/) /*-> DerseResult*/
{
    var error = schema.validate(value);
    if (error != undefined) {
        return __derse_error(error);
    }
    return __derse_success(value);
}

function __derse_read_with_struct_schema(value/*: any*/, schema/*: struct*/) /*-> DerseResult*/
{
    // TODO
}
