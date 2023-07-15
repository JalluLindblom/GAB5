
function initialize_tilesets()
{
    CALL_ONLY_ONCE
    
    globalvar GTS_Grass; /// @is {GroundTileset}
    GTS_Grass = new GroundTileset();
    GTS_Grass.top_left                  = 1;
    GTS_Grass.top_mid                   = 2;
    GTS_Grass.top_right                 = 3;
    GTS_Grass.mid_left                  = 21;
    GTS_Grass.mid_mid                   = 22;
    GTS_Grass.mid_right                 = 23;
    GTS_Grass.bot_left                  = 41;
    GTS_Grass.bot_mid                   = 42;
    GTS_Grass.bot_right                 = 43;
    GTS_Grass.corner_top_left           = 4;
    GTS_Grass.corner_top_right          = 5;
    GTS_Grass.corner_bot_left           = 24;
    GTS_Grass.corner_bot_right          = 25;
    GTS_Grass.bridge_hor_left           = 61;
    GTS_Grass.bridge_hor_mid            = 62;
    GTS_Grass.bridge_hor_right          = 63;
    GTS_Grass.bridge_ver_top            = 40;
    GTS_Grass.bridge_ver_mid            = 60;
    GTS_Grass.bridge_ver_bot            = 80;
    GTS_Grass.bridge_corner_top_left    = 44;
    GTS_Grass.bridge_corner_top_right   = 45;
    GTS_Grass.bridge_corner_bot_left    = 64;
    GTS_Grass.bridge_corner_bot_right   = 65;
    GTS_Grass.island                    = 20;
}

function GroundTileset() constructor
{
    top_left                = 0;    /// @is {int}
    top_mid                 = 0;    /// @is {int}
    top_right               = 0;    /// @is {int}
    mid_left                = 0;    /// @is {int}
    mid_mid                 = 0;    /// @is {int}
    mid_right               = 0;    /// @is {int}
    bot_left                = 0;    /// @is {int}
    bot_mid                 = 0;    /// @is {int}
    bot_right               = 0;    /// @is {int}
    corner_top_left         = 0;    /// @is {int}
    corner_top_right        = 0;    /// @is {int}
    corner_bot_left         = 0;    /// @is {int}
    corner_bot_right        = 0;    /// @is {int}
    bridge_hor_left         = 0;    /// @is {int}
    bridge_hor_mid          = 0;    /// @is {int}
    bridge_hor_right        = 0;    /// @is {int}
    bridge_ver_top          = 0;    /// @is {int}
    bridge_ver_mid          = 0;    /// @is {int}
    bridge_ver_bot          = 0;    /// @is {int}
    bridge_corner_top_left  = 0;    /// @is {int}
    bridge_corner_top_right = 0;    /// @is {int}
    bridge_corner_bot_left  = 0;    /// @is {int}
    bridge_corner_bot_right = 0;    /// @is {int}
    island                  = 0;    /// @is {int}
}
