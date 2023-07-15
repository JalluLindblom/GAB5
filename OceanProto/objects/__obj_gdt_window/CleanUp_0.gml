event_inherited();

cleanup_event.invoke(id);

if (surface_exists(content_surface)) {
    surface_free(content_surface);
    content_surface = -1;
}

__get_window_manager()._remove_window(id);
