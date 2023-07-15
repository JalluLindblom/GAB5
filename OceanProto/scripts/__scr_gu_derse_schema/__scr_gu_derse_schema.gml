
function DerseSchema() constructor
{
    // A variable whose value doesn't matter. It's only here so we can detect
    // that a given struct is a DerseSchema. We would use instanceof() for that
    // but that wouldn't work for constructors that inherit DerseSchema.
    __derse_schema_tag = 0; /// @is {any}
    
    // virtual
    static validate = function(value/*: any*/) /*-> string?*/
    {
        return "Incomplete schema.";
    }
}

function DerseSchema_Numeric(_min_value/*: number?*/ = undefined, _max_value/*: number?*/ = undefined, _min_inclusive/*: bool*/ = true, _max_inclusive/*: bool*/ = true) : DerseSchema() constructor
{
    min_value = _min_value;         /// @is {number?}
    max_value = _max_value;         /// @is {number?}
    min_inclusive = _min_inclusive; /// @is {bool}
    max_inclusive = _max_inclusive; /// @is {bool}
    
    // override
    static validate = function(value/*: any*/) /*-> string?*/
    {
        if (!is_numeric(value)) {
            return "Expected a value of a numeric type but got a value of type \"" + typeof(value) + "\".";
        }
        
        if (min_value != undefined) {
            if (min_inclusive) {
                if (value < min_value) {
                    return "Expected a value equal to or greater than " + string(min_value) + " but got " + string(value) + ".";
                }
            }
            else if (value <= min_value) {
                return "Expected a value greater than " + string(min_value) + " but got " + string(value) + ".";
            }
        }
        
        if (max_value != undefined) {
            if (max_inclusive) {
                if (value > max_value) {
                    return "Expected a value equal to or less than " + string(max_value) + " but got " + string(value) + ".";
                }
            }
            else if (value >= max_value) {
                return "Expected a value less than " + string(max_value) + " but got " + string(value) + ".";
            }
        }
        
        return undefined;
    }
}

function DerseSchema_String(_min_length/*: number?*/ = undefined, _max_length/*: number?*/ = undefined, _min_inclusive/*: bool*/ = true, _max_inclusive/*: bool*/ = true) : DerseSchema() constructor
{
    min_length = _min_length;       /// @is {number?}
    max_length = _max_length;       /// @is {number?}
    min_inclusive = _min_inclusive; /// @is {bool}
    max_inclusive = _max_inclusive; /// @is {bool}
    
    // override
    static validate = function(value/*: any*/) /*-> string?*/
    {
        if (!is_string(value)) {
            return "Expected a string but got a value of type \"" + typeof(value) + "\".";
        }
        
        var len = string_length(value);
        if (min_length != undefined) {
            if (min_inclusive) {
                if (len < min_length) {
                    return "Expected a string of length equal to or greater than " + string(min_length) + " but the length was " + string(len) + ".";
                }
            }
            else if (len <= min_length) {
                return "Expected a string of length greater than " + string(min_length) + " but the length was " + string(len) + ".";
            }
        }
        
        if (max_length != undefined) {
            if (max_inclusive) {
                if (len > max_length) {
                    return "Expected a string of length equal to or less than " + string(max_length) + " but the length was " + string(len) + ".";
                }
            }
            else if (len >= max_length) {
                return "Expected a string of length less than " + string(max_length) + " but the length was " + string(len) + ".";
            }
        }
        
        return undefined;
    }
}

function DerseSchema_Boolean(_strict/*: bool*/ = true) : DerseSchema() constructor
{
    strict = _strict;   /// @is {bool}
    
    // override
    static validate = function(value/*: any*/) /*-> string?*/
    {
        if (strict) {
            var type = typeof(value);
            if (type != "bool") {
                return "Expected a boolean value but got a value of type \"" + type + "\".";
            }
        }
        else {
            try {
                var v = bool(value);
            }
            catch (err) {
                return "Expected a boolean-compatible value but got a value of type \"" + typeof(value) + "\".";
            }
        }
        return undefined;
    }
}

function DerseSchema_Array(
    _valueSchema/*: DerseSchema?*/ = undefined,
    _min_length/*: number?*/ = undefined,
    _max_length/*: number?*/ = undefined,
    _min_inclusive/*: bool*/ = true,
    _max_inclusive/*: bool*/ = true
) : DerseSchema() constructor
{
    value_schema    = _valueSchema;     /// @is {DerseSchema?}
    min_length      = _min_length;      /// @is {number?}
    max_length      = _max_length;      /// @is {number?}
    min_inclusive   = _min_inclusive;   /// @is {bool}
    max_inclusive   = _max_inclusive;   /// @is {bool}
    
    // override
    static validate = function(value/*: any*/) /*-> string?*/
    {
        if (!is_array(value)) {
            return "Expected an array but got a value of type " + typeof(value) + ".";
        }
        
        var arr_len = array_length(value);
        
        if (min_length != undefined) {
            if (min_inclusive) {
                if (arr_len < min_length) {
                    return "Expected an array of length greater than or equal to " + string(min_length) + " but the length was " + string(arr_len) + ".";
                }
            }
            else if (arr_len <= min_length) {
                return "Expected an array of length greater than " + string(min_length) + " but the length was " + string(arr_len) + ".";
            }
        }
        
        if (max_length != undefined) {
            if (max_inclusive) {
                if (arr_len > max_length) {
                    return "Expected an array of length less than or equal to " + string(max_length) + " but the length was " + string(arr_len) + ".";
                }
            }
            else if (arr_len >= max_length) {
                return "Expected an array of length less than " + string(max_length) + " but the length was " + string(arr_len) + ".";
            }
        }
        
        if (value_schema != undefined) {
            var schema = value_schema /*#as DerseSchema*/;
            for (var i = 0; i < arr_len; ++i) {
                var element = value[@ i];
                var error = schema.validate(element);
                if (error != undefined) {
                    return "Element at index " + string(i) + ": " + error;
                }
            }
        }
        
        return undefined;
    }
}

function DerseSchema_Alternatives(_schemas/*: DerseSchema[]*/) : DerseSchema() constructor
{
    schemas = _schemas; /// @is {DerseSchema[]}
    
    // override
    static validate = function(value/*: any*/) /*-> string?*/
    {
        var num_schemas = array_length(schemas);
        for (var i = 0; i < num_schemas; ++i) {
            var schema = schemas[@ i];
            if (schema.validate(value) == undefined) {
                return undefined;
            }
        }
        return "The value doesn't conform to any of the given " + string(num_schemas) + " schemas.";
    }
}

function __is_derse_schema_constructor(schema/*: any*/) /*-> bool*/
{
    return is_struct(schema) && variable_struct_exists(schema, "__derse_schema_tag");
}
