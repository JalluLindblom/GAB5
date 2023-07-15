event_inherited();

if (ds_exists(window_list, ds_type_list)) {
    ds_list_destroy(window_list);
    window_list = -1;
}
if (ds_exists(windows_by_id_list, ds_type_list)) {
    ds_list_destroy(windows_by_id_list);
    windows_by_id_list = -1;
}

__window_file_write_json(window_state_filename, window_state);