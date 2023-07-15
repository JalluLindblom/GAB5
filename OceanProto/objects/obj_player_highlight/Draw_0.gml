event_inherited();

var radius = 42;
if (Trial.state < TRIAL_STATE.running) {
    radius += sin(current_time / 100) * 2;
}
radius = round(radius);
var x1 = x - radius;
var y1 = y - radius * 0.5;
var x2 = x + radius;
var y2 = y + radius * 0.5;
draw_nine_slice(spr_player_highlight, 0, x1, y1, x2, y2, 0, c_white, 1);