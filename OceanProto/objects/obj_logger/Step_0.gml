event_inherited();

if (dump_timer > 0) {
    dump_timer -= 1;
}
else {
    _dump();
    dump_timer = 60;
}