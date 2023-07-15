event_inherited();

if (condition()) {
	callback();
	instance_destroy();
	return;
}
