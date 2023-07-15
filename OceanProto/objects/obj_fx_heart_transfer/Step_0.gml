event_inherited();

life_timer += 1;
if (life_timer > 40) {
    instance_destroy();
    return;
}

if (instance_exists(source_creature)) {
    x1 = (source_creature.bbox_left + source_creature.bbox_right) / 2;
    y1 = (source_creature.bbox_top + source_creature.bbox_bottom) / 2 + 20;
}
if (instance_exists(target_creature)) {
    x2 = (target_creature.bbox_left + target_creature.bbox_right) / 2;
    y2 = (target_creature.bbox_top + target_creature.bbox_bottom) / 2 + 20;
}

var t = clamp(life_timer / 40, 0, 1);

var pos_v = animcurve_channel_evaluate(animcurve_get_channel(crv_heart_transfer_position, 0), t);
x = lerp(x1, x2, pos_v) + offset_x;
y = lerp(y1, y2, pos_v) + offset_y;

var scale_v = animcurve_channel_evaluate(animcurve_get_channel(crv_heart_transfer_scale, 0), t);
image_xscale = lerp(0, 0.4, scale_v);
image_yscale = image_xscale;
