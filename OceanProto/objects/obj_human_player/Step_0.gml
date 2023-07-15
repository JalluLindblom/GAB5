event_inherited();

// Move the crosshair to the current action target entity.
var current_action = get_current_action() /*#as HumanAction*/;
if (current_action != undefined) {
    crosshair.target_entity = noone;
    switch (current_action.type) {
        case HAT_approach_food: {
            if (Configs.show_crosshair_approach_food) {
                crosshair.target_entity = current_action.target_food;
            }
            break;
        }
        case HAT_approach_monster: {
            if (Configs.show_crosshair_approach_monster) {
                crosshair.target_entity = current_action.target_monster;
            }
            break;
        }
        case HAT_approach_human: {
            if (Configs.show_crosshair_approach_human) {
                crosshair.target_entity = current_action.target_human;
            }
            break;
        }
        case HAT_avoid_monster: {
            if (Configs.show_crosshair_avoid_monster) {
                crosshair.target_entity = current_action.target_monster;
            }
            break;
        }
        case HAT_avoid_human: {
            if (Configs.show_crosshair_avoid_human) {
                crosshair.target_entity = current_action.target_human;
            }
            break;
        }
        case HAT_attack_monster: {
            if (Configs.show_crosshair_attack_monster) {
                crosshair.target_entity = current_action.target_monster;
            }
            break;
        }
        case HAT_attack_human: {
            if (Configs.show_crosshair_attack_human) {
                crosshair.target_entity = current_action.target_human;
            }
            break;
        }
        case HAT_exchange_with_human: {
            if (Configs.show_crosshair_exchange_with_human) {
                crosshair.target_entity = current_action.target_human;
            }
            break;
        }
    }
}