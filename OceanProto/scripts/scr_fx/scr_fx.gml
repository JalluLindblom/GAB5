
function fx_create_attack_hit_effect(xx/*: number*/, yy/*: number*/)
{
    if (instance_exists(Trial) && Trial.is_auto_run) {
        return noone;
    }
    
    var fx = instance_create_layer(xx, yy, "InstancesAbove", obj_fx_attack_hit_effect);
    return fx;
}

function fx_create_speech_bubble(creature/*: obj_creature*/, content_sprite/*: sprite*/, no_bubble/*: bool*/, dir/*: number*/, infinite/*: bool*/ = false, create_callback/*: (function<obj_fx_speech_bubble, void>)*/ = undefined)
{
	if (create_callback == undefined) create_callback = function(bubble/*: obj_fx_speech_bubble*/) {};
	
    if (instance_exists(Trial) && Trial.is_auto_run) {
        create_callback(noone);
		return;
    }
    
    var existing_bubble = noone /*#as obj_fx_speech_bubble*/;
    with (obj_fx_speech_bubble) {
        if (attached_creature == creature) {
            existing_bubble = id;
            break;
        }
    }
    if (instance_exists(existing_bubble)) {
        existing_bubble.enqueue_next(content_sprite, no_bubble, dir, infinite, create_callback);
    }
    else {
        var sb = instance_create_layer(creature.x, creature.y, "InstancesAbove", obj_fx_speech_bubble);
        sb.initialize(creature, content_sprite, no_bubble, dir, infinite, create_callback);
    }
}

function fx_creature_has_speech_bubble(_creature/*: obj_creature*/, _content_sprite/*: sprite*/)
{
    if (Trial.is_auto_run) {
        return false;
    }
    with (obj_fx_speech_bubble) {
        if (attached_creature == _creature && content_sprite == _content_sprite) {
            return true;
        }
        if (next_bubbles_queue != undefined) {
            for (var i = 0, len = array_length(next_bubbles_queue); i < len; ++i) {
                if (next_bubbles_queue[i].content_sprite == _content_sprite) {
                    return true;
                }
            }
        }
    }
    return false;
}

function fx_creature_clear_speech_bubbles(_creature/*: obj_creature*/)
{
    with (obj_fx_speech_bubble) {
        if (attached_creature == _creature) {
            next_bubbles_queue = undefined;
            instance_destroy();
        }
    }
}

function fx_create_heart_transfer(source_creature/*: obj_creature*/, target_creature/*: obj_creature*/)
{
    if (instance_exists(Trial) && Trial.is_auto_run) {
        return noone;
    }
    
    var fx = instance_create_layer(source_creature.x, source_creature.y, "InstancesAbove", obj_fx_heart_transfer);
    fx.initialize(source_creature, target_creature);
}
