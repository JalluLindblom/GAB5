
function MenuEntry(_menu_entry_definition/*: MenuEntryDefinition*/, _parent_menu/*: Menu?*/) constructor
{
    menu_entry_definition = _menu_entry_definition; /// @is {MenuEntryDefinition}
    parent_menu = _parent_menu;                   /// @is {Menu}
    
    custom_state = {};           /// @is {struct}
    
    menu_entry_definition.initialize(self);
    
    static step = function(controller/*: MenuController*/, mouse_xx/*: number*/, mouse_yy/*: number*/, has_controls/*: bool*/, x1/*: number*/, yy/*: number*/, x2/*: number*/) /*-> MENU_RETURN*/
    {
        return menu_entry_definition.step(self, controller, mouse_xx, mouse_yy, has_controls, x1, yy, x2);
    }
    
    static render = function(controller/*: MenuController*/, mouse_xx/*: number*/, mouse_yy/*: number*/, has_controls/*: bool*/, x1/*: number*/, yy/*: number*/, x2/*: number*/) /*-> number*/
    {
        return menu_entry_definition.render(self, controller, mouse_xx, mouse_yy, has_controls, x1, yy, x2);
    }
    
    static get_height = function(width/*: number*/) /*-> number*/
    {
        return menu_entry_definition.get_height(self, width);
    }
    
    static free = function()
    {
        menu_entry_definition.cleanup(self);
    }
}
