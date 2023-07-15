event_inherited();

if (menu != undefined) {
    menu.free();
    menu = undefined;
}

info_menu = destroy_instance(info_menu);
if (sprite_exists(frozen_sprite)) {
	sprite_delete(frozen_sprite);
}
