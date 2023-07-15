event_inherited();

var fps_n = 10;
if (fps_cumulator_counter < fps_n) {
	fps_cumulative += fps;
	fps_real_cumulative += fps_real;
	++fps_cumulator_counter;
}
else {
	fps_average = fps_cumulative / fps_n;
	fps_real_average = fps_real_cumulative / fps_n;
	fps_cumulative = 0;
	fps_real_cumulative = 0;
	fps_cumulator_counter = 0;
}