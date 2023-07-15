
function room_goto_or_restart(room_numb/*: room*/) /*-> Promise*/
{
    var c = { room_numb: room_numb };
    return new Promise(method(c, function(resolve, reject) {
        var goer = instance_create_depth(0, 0, 0, obj_room_goer);
        goer.callback = resolve;
        if (room == room_numb) {
            room_restart();
        }
        else {
            room_goto(room_numb);
        }
    }));
}
