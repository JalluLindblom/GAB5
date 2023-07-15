event_inherited();

life_timer -= 1;
if (life_timer <= 0) {
    instance_destroy();
    return;
}

if (initial_flash_timer > 0) {
    initial_flash_timer -= 1;
}