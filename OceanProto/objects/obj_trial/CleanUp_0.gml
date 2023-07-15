event_inherited();

log_event("Trial cleaned up.");

terrain.free();
ticker.free();
hud = destroy_instance(hud);
