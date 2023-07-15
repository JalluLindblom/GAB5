event_inherited();

if (!instance_exists(attached_creature)) {
    instance_destroy();
    return;
}

image_xscale = 1;
image_yscale = 1;

life_timer += 1;
if (!infinite && life_timer > 60 * 1) {
    if (disappear_animation_timer < 10) {
        disappear_animation_timer += 1;
        var xscale_channel = animcurve_get_channel(crv_speech_bubble_disappear, "xscale");
        var yscale_channel = animcurve_get_channel(crv_speech_bubble_disappear, "yscale");
        var t = disappear_animation_timer / 10;
        image_xscale = animcurve_channel_evaluate(xscale_channel, t) * 1.0;
        image_yscale = animcurve_channel_evaluate(yscale_channel, t) * 1.0;
    }
    else {
        instance_destroy();
        return;
    }
}

if (appear_animation_timer < 10) {
    appear_animation_timer += 1;
    var xscale_channel = animcurve_get_channel(crv_speech_bubble_appear, "xscale");
    var yscale_channel = animcurve_get_channel(crv_speech_bubble_appear, "yscale");
    var t = appear_animation_timer / 10;
    image_xscale = animcurve_channel_evaluate(xscale_channel, t) * 1.0;
    image_yscale = animcurve_channel_evaluate(yscale_channel, t) * 1.0;
}

image_xscale *= (angle_difference(90, dir) > 0) ? 1 : -1;

x = (attached_creature.bbox_left + attached_creature.bbox_right) / 2;
y = attached_creature.bbox_top - 5;