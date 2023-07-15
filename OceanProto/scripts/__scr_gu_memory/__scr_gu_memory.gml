
/// @param {surface} surface
function destroy_surface(surface)
{
    if (surface != undefined && surface_exists(surface)) {
        surface_free(surface);
    }
    return -1;
}

/// @param {buffer} buffer
function destroy_buffer(buffer)
{
    if (buffer != undefined && buffer_exists(buffer)) {
        buffer_delete(buffer);
    }
    return -1;
}

/// @param {ds_grid} grid
function destroy_grid(grid)
{
    if (grid != undefined && ds_exists(grid, ds_type_grid)) {
        ds_grid_destroy(grid);
    }
    return -1;
}

/// @param {ds_map} map
function destroy_map(map)
{
    if (map != undefined && ds_exists(map, ds_type_map)) {
        ds_map_destroy(map);
    }
    return -1;
}

/// @param {ds_list} list
function destroy_list(list)
{
    if (list != undefined && ds_exists(list, ds_type_list)) {
        ds_list_destroy(list);
    }
    return -1;
}

/// @param {ds_priority} priority
function destroy_priority(priority)
{
    if (priority != undefined && ds_exists(priority, ds_type_priority)) {
        ds_priority_destroy(priority);
    }
    return -1;
}

/// @param {ds_queue} queue
function destroy_queue(queue)
{
    if (queue != undefined && ds_exists(queue, ds_type_queue)) {
        ds_queue_destroy(queue);
    }
    return -1;
}

/// @param {ds_set} set
function destroy_set(set)
{
    if (set != undefined && ds_exists(set, ds_type_set)) {
        ds_set_destroy(set);
    }
    return -1;
}

/// @param {instance} instance
function destroy_instance(instance)
{
    if (instance != undefined && instance_exists(instance)) {
        instance_destroy(instance);
    }
    return noone;
}
