event_inherited();

if (!instance_exists(player)) {
    instance_destroy();
    return;
}

if (!instance_exists(target_entity)) {
    target_entity = player;
}

x += (target_entity.x - x) * 0.5;
y += (target_entity.y - y) * 0.5;

visible = true;
if (target_entity == player && point_distance(x, y, target_entity.x, target_entity.y) < 10) {
    visible = false;
}