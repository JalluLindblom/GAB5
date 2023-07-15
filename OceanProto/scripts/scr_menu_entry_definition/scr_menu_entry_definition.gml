
function MenuEntryDefinition(_check_enabled/*: (function<bool>)?*/) constructor
{
    check_enabled   = _check_enabled;   /// @is {(function<bool>)?}
    // TODO: Maybe get this via an argument?
    style           = CommonMenuStyle;  /// @is {MenuStyling}
    
    _padding_left = 0;    /// @is {number}
    _padding_top = 0;     /// @is {number}
    _padding_right = 0;   /// @is {number}
    _padding_bot = 0;     /// @is {number}
    
    static is_interactable_type = function() /*-> bool*/
    {
        return _is_interactable_type_virtual();
    }
    
    static initialize = function(entry/*: MenuEntry*/)
    {
        return _initialize_virtual(entry);
    }
    
    static step = function(entry/*: MenuEntry*/, controller/*: MenuController*/, mouse_xx/*: number*/, mouse_yy/*: number*/, has_controls/*: bool*/, x1/*: number*/, yy/*: number*/, x2/*: number*/) /*-> MENU_RETURN*/
    {
        return _step_virtual(entry, controller, mouse_xx, mouse_yy, has_controls, x1, yy, x2);
    }
    
    static render = function(entry/*: MenuEntry*/, controller/*: MenuController*/, mouse_xx/*: number*/, mouse_yy/*: number*/, has_controls/*: bool*/, x1/*: number*/, yy/*: number*/, x2/*: number*/)
    {
        x1 += _padding_left;
        x2 -= _padding_right;
        yy += _padding_top;
        _render_virtual(entry, controller, mouse_xx, mouse_yy, has_controls, x1, yy, x2);
    }
    
    static get_height = function(entry/*: MenuEntry*/, width/*: number*/) /*-> number*/
    {
        return _padding_top + _padding_bot + _get_height_virtual(entry, width);
    }
    
    static cleanup = function(entry/*: MenuEntry*/)
    {
        return _cleanup_virtual(entry);
    }
    
    static set_paddings = function(_left/*: number*/ = 0, _top/*: number*/ = 0, _right/*: number*/ = 0, _bot/*: number*/ = 0) /*-> MenuEntryDefinition*/
    {
        _padding_left = _left;
        _padding_top = _top;
        _padding_right = _right;
        _padding_bot = _bot;
        return self;
    }
    
    static create_instance = function(parent_menu/*: Menu?*/) /*-> MenuEntry*/
    {
        return new MenuEntry(self, parent_menu);
    }
    
    static is_enabled = function() /*-> bool*/
    {
        return (check_enabled != undefined) ? check_enabled() : true;
    }
    
    // virtual
    static _is_interactable_type_virtual = function() /*-> bool*/
    {
        return false;
    }
    
    // virtual
    static _initialize_virtual = function(entry/*: MenuEntry*/)
    {
    }
    
    // virtual
    static _step_virtual = function(entry/*: MenuEntry*/, controller/*: MenuController*/, mouse_xx/*: number*/, mouse_yy/*: number*/, has_controls/*: bool*/, x1/*: number*/, yy/*: number*/, x2/*: number*/) /*-> MENU_RETURN*/
    {
        return MENU_RETURN.void;
    }
    
    // virtual
    static _render_virtual = function(entry/*: MenuEntry*/, controller/*: MenuController*/, mouse_xx/*: number*/, mouse_yy/*: number*/, has_controls/*: bool*/, x1/*: number*/, yy/*: number*/, x2/*: number*/)
    {
    }
    
    // virtual
    static _get_height_virtual = function(entry/*: MenuEntry*/, width/*: number*/) /*-> number*/
    {
        return 0;
    }
    
    // virtual
    static _cleanup_virtual = function(entry/*: MenuEntry*/)
    {
    }
}
