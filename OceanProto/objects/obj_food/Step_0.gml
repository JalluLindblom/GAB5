event_inherited();

fixed_draw_offset_x = 0;
fixed_draw_offset_y = -2 - sin((current_time + id_hash / 1000) / (300 + id_hash % 100)) * 2;