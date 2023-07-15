
function initialize_common_menu_configurations()
{
    CALL_ONLY_ONCE
    
    globalvar CommonMenuController; /// @is {MenuController}
    CommonMenuController = new MenuController();
    
    CommonMenuController.check_pressed = function(verb/*: MENU_INPUT_VERB*/) {
        switch (verb) {
            case MENU_INPUT_VERB.select:    return keyboard_check_pressed(vk_space);
            case MENU_INPUT_VERB.back:      return keyboard_check_pressed(vk_escape);
            case MENU_INPUT_VERB.left:      return keyboard_check_pressed(vk_left);
            case MENU_INPUT_VERB.up:        return keyboard_check_pressed(vk_up);
            case MENU_INPUT_VERB.right:     return keyboard_check_pressed(vk_right);
            case MENU_INPUT_VERB.down:      return keyboard_check_pressed(vk_down);
        }
        return false;
    };
    CommonMenuController.check_repeated = function(verb/*: MENU_INPUT_VERB*/) {
        return false;
    };
    CommonMenuController.is_mouse_enabled = function() {
        return true;
    };
    CommonMenuController.is_keyboard_enabled = function() {
        return false;
    };
    CommonMenuController.set_cursor = function(cursor/*: MENU_CURSOR*/) {
        switch (cursor) {
            case MENU_CURSOR.pointy: cursor_set(cr_handpoint); break;
            case MENU_CURSOR.draggy: cursor_set(cr_drag); break;
        }
    };
    
    
    
    globalvar CommonMenuStyle;  /// @is {MenuStyling}
    CommonMenuStyle = new MenuStyling(
        COLOR.black,
        COLOR.black,
        COLOR.black,
        COLOR.black,
        COLOR.black,
        FontJosefinSans
    );
}
