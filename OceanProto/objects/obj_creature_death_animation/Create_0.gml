event_inherited();

timer = 0;  /// @is {number}

initialize = function(creature/*: obj_creature*/)
{
    sprite_index = creature.creature_sprites.dead;
    image_xscale = sign(creature.image_xscale);
}