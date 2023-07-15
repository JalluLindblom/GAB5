event_inherited();

timer += 1;
if (timer >= 30) {
    instance_destroy();
    return;
}

if (timer > 0) {
    y -= 5 / timer;
    image_angle += sign(image_xscale) * 5 / timer;
}

image_alpha = (timer % 6 < 3) ? 1.0 : 0.0;
