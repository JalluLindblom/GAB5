
function create_popup_menu(menu_definition/*: MenuDefinition*/, width/*: number*/, height/*: number?*/ = undefined) /*-> obj_popup_menu*/
{
    var popup_menu = instance_create_depth(0, 0, 0, obj_popup_menu);
    popup_menu.initialize(menu_definition, width, height);
    return popup_menu;
}
