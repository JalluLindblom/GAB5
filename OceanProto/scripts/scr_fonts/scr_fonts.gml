
function initialize_fonts()
{
    CALL_ONLY_ONCE
    
    globalvar FontConsoleSmall;          /// @is {string}
    FontConsoleSmall = font_get_name(fnt_courier_new_smaller);
    
    globalvar FontConsoleBold;          /// @is {string}
    globalvar FontConsoleBoldOutlined;  /// @is {string}
    FontConsoleBold = font_get_name(fnt_courier_new_small_bold);
    FontConsoleBoldOutlined = FontConsoleBold + "_outlined";
    scribble_custom_font_bake_outline(FontConsoleBold, FontConsoleBoldOutlined, c_black, true);
    
    globalvar FontConsoleMediumBold;          /// @is {string}
    globalvar FontConsoleMediumBoldOutlined;  /// @is {string}
    FontConsoleMediumBold = font_get_name(fnt_courier_new_medium_bold);
    FontConsoleMediumBoldOutlined = FontConsoleMediumBold + "_outlined";
    scribble_custom_font_bake_outline(FontConsoleMediumBold, FontConsoleMediumBoldOutlined, c_black, true);
    
    globalvar FontTerminal;         /// @is {string}
    globalvar FontTerminalOutlined; /// @is {string}
    FontTerminal = font_get_name(fnt_r644);
    FontTerminalOutlined = FontTerminal + "_outlined";
    scribble_custom_font_bake_outline(FontTerminal, FontTerminalOutlined, c_black, true);
    
    globalvar FontJosefinSans;         /// @is {string}
    globalvar FontJosefinSansBold;         /// @is {string}
    FontJosefinSans = font_get_name(fnt_josefin_sans);
    FontJosefinSansBold = font_get_name(fnt_josefin_sans_bold);
	scribble_font_set_style_family(FontJosefinSans, FontJosefinSansBold, undefined, undefined);
    
    globalvar FontJosefinSansSmallBold;         /// @is {string}
    FontJosefinSansSmallBold = font_get_name(fnt_josefin_sans_small_bold);
}
