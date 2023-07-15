event_inherited();

creature_sprites.set(
    spr_human_blue_idle,
    spr_human_blue_walk,
    spr_human_blue_stand,
    spr_human_blue_attack,
    spr_human_blue_duck,
    spr_human_blue_hurt,
    spr_human_blue_exchange,
    spr_human_blue_hurt
);

shadow_radius = 24;

highlight = noone;  /// @is {obj_player_highlight}
crosshair = noone;  /// @is {obj_player_crosshair}

if (!Trial.is_auto_run) {
    highlight = instance_create_layer(x, y, "EntityHighlights", obj_player_highlight);
    highlight.player = id;
    
    crosshair = instance_create_layer(x, y, "EntityHighlights", obj_player_crosshair);
    crosshair.player = id;
}