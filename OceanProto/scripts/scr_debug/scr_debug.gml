
#macro EXPECTED_RUNTIME_VERSION "2022.0.0.12"

if (DEBUG_MODE) {
    if (GM_runtime_version != EXPECTED_RUNTIME_VERSION) {
        var msg = "Wrong runtime version!\nExpected " + EXPECTED_RUNTIME_VERSION + "\nIs " + GM_runtime_version
            + "\n\nIf this change in runtime version was intended, go change the value of the macro \"EXPECTED_RUNTIME_VERSION\"."
            + "\nOtherwise, please go your GameMaker preferences and change the runtime to the expected one.";
        show_message(msg);
    }
}

#macro DEBUG_MODE false
#macro Default:DEBUG_MODE true

#macro CALL_ONLY_ONCE {}
#macro Default:CALL_ONLY_ONCE { static called = false; if (called) { log_error("Function that was supposed to be called only once was called more than once.\n" + string_join_array(debug_get_callstack(), "\n")); } called = true; }

#macro CONFIG_DEFAULT "Default"
#macro CONFIG_RELEASE "Release"
#macro CONFIG_DEMO    "Demo"
