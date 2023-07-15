
function Pathfinder(
    _get_heuristic/*: (function<TerrainCell, TerrainCell, number>)*/,
    _get_neighbors/*: (function<TerrainCell, PfNeighbor[], StructPool, int>)*/,
    _options/*: PathfinderOptions?*/
) constructor
{
    get_heuristic = _get_heuristic; /// @is {function<TerrainCell, TerrainCell, number>}
    get_neighbors = _get_neighbors; /// @is {function<TerrainCell, PfNeighbor[], StructPool, int>}
    options = new PathfinderOptions(-1);   /// @is {PathfinderOptions}
    if (_options != undefined) {
        _append_struct(options, _options);
    }
    
    start_node = undefined; /// @is {TerrainCell}
    goal_node = undefined;  /// @is {TerrainCell}
    
    open_set = ds_priority_create();    /// @is {ds_priority<TerrainCell>}
    came_from = ds_map_create();        /// @is {ds_map<struct>}
    g_score = ds_map_create();          /// @is {ds_map<TerrainCell, number>}
    came_from_pool = make_struct_pool(  /// @is {StructPool}
        function (from_node, data) { // Create
            return {
                from_node: from_node,
                data: data,
            };
        },
        function (old, from_node, data) { // Replace
            old.from_node = from_node;
            old.data = data;
        }
    );
    path_element_pool = make_struct_pool(  /// @is {StructPool}
        function (node, previous_node, data) { // Create
            return new PfPathElement(node, previous_node, data);
        },
        function (old, node, previous_node, data) { // Replace
            old.node = node;
            old.previous_node = previous_node;
            old.data = data;
        }
    );
    neighbor_pool = make_struct_pool(  /// @is {StructPool}
        function(node, cost, data) { // Create
            return new PfNeighbor(node, cost, data);
        },
        function(old, node, cost, data) { // Replace
            old.node = node;
            old.cost = cost;
            old.data = data;
        },
    );
    
    path = [];  /// @is {PfPathElement[]}
    
    done = true;
    path_found = false;
    
    num_steps_performed = 0;
    
    static start = function(_start_node/*: TerrainCell*/, _goal_node/*: TerrainCell*/)
    {
        start_node = _start_node;
        goal_node = _goal_node;
        
        ds_priority_clear(open_set);
        ds_map_clear(came_from);
        ds_map_clear(g_score);
        came_from_pool.expire_all();
        path_element_pool.expire_all();
        
        array_resize(path, 0);
        
        done = false;
        path_found = false;
        
        num_steps_performed = 0;
        
        g_score[? start_node] = 0;
        ds_priority_add(open_set, start_node, get_heuristic(start_node, goal_node));
    }
    
    static is_done = function()
    {
        return done;
    }
    
    static path_is_found = function()
    {
        return path_found;
    }
    
    static construct_path = function()
    {
        static _construct_path_to_node = function(node)
        {
            array_resize(path, 0);
            while (true) {
                var cf = came_from[? node];
                if (cf != undefined) {
                    array_push(path, path_element_pool.create_new(node, cf.from_node, cf.data));
                    node = cf.from_node;
                }
                else {
                    break;
                }
            }
            array_reverse(path);
        }
        
        if (path_found) {
            _construct_path_to_node(goal_node);
            return true;
        }
        else {
            var node_closest_to_goal = undefined;
            var smallest_h = -1;
            for (var node = ds_map_find_first(came_from); node != undefined; node = ds_map_find_next(came_from, node)) {
                var cf = came_from[? node];
                var h = get_heuristic(cf.from_node, goal_node);
                if (node_closest_to_goal == undefined || h < smallest_h) {
                    node_closest_to_goal = cf.from_node;
                    smallest_h = h;
                }
            }
            if (node_closest_to_goal != undefined) {
                _construct_path_to_node(node_closest_to_goal);
                return true;
            }
        }
        return false;
    }
    
    static get_path = function()
    {
        return path;
    }
    
    static step = function()
    {
        if (done) {
            return;
        }
        
        ++num_steps_performed;
        
        if (!ds_priority_empty(open_set)) {
            var min_f = ds_priority_find_priority(open_set, ds_priority_find_min(open_set));
            var current_node = ds_priority_delete_min(open_set);
            if (current_node == goal_node) {
                // Path found
                path_found = true;
        	    done = true;
        	    return;
            }
            if (options.max_estimation >= 0 && min_f > options.max_estimation) {
                path_found = false;
                done = true;
                return;
            }
            static neighbor_nodes_array = [];
            neighbor_pool.expire_all();
            var current_node_g_score = g_score[? current_node];
            var num_neighbors = get_neighbors(current_node, neighbor_nodes_array, neighbor_pool);
            for (var i = 0; i < num_neighbors; ++i) {
                var neighbor = neighbor_nodes_array[i];
                var neighbor_node_g_score = g_score[? neighbor.node];
                var tg = current_node_g_score + neighbor.cost;
                if (neighbor_node_g_score == undefined || tg < neighbor_node_g_score) {
                    came_from[? neighbor.node] = came_from_pool.create_new(current_node, neighbor.data);
                    g_score[? neighbor.node] = tg;
                    if (ds_priority_find_priority(open_set, neighbor.node) == undefined) {
                        var f = tg + get_heuristic(neighbor.node, goal_node);
                        ds_priority_add(open_set, neighbor.node, f);
                    }
                }
            }
        }
        if (ds_priority_empty(open_set)) {
            // No path found
            path_found = false;
            done = true;
    	    return;
        }
    }
    
    static finish = function()
    {
        while (!done) {
            step();
        }
        return path_found;
    }
    
    static free = function()
    {
        open_set = destroy_priority(open_set);
        came_from = destroy_map(came_from);
        g_score = destroy_map(g_score);
    }
}

function PfPathElement(_node/*: TerrainCell*/, _previous_node/*: TerrainCell*/, _data/*: any*/) constructor
{
    node = _node;                   /// @is {TerrainCell}
    previous_node = _previous_node; /// @is {TerrainCell}
    data = _data;                   /// @is {any}
}

function PfNeighbor(_node/*: TerrainCell*/, _cost/*: number*/, _data/*: any*/) constructor
{
    node = _node;   /// @is {TerrainCell}
    cost = _cost;   /// @is {number}
    data = _data;   /// @is {any}
}

function find_path(
    start/*: TerrainCell*/,
    goal/*: TerrainCell*/,
    get_heuristic/*: (function<TerrainCell, TerrainCell, number>)*/,
    get_neighbors/*: (function<TerrainCell, PfNeighbor[], StructPool, int>)*/,
    options/*: PathfinderOptions?*/,
    only_find_full_path/*: bool*/
) /*-> PfPathElement[]?*/
{
    var pf = new Pathfinder(get_heuristic, get_neighbors, options);
    pf.start(start, goal);
    pf.finish();
    if (only_find_full_path && !pf.path_is_found()) {
        pf.free();
        return undefined;
    }
    pf.construct_path();
    pf.free();
    return pf.path;
}

function _append_struct(destination, source)
{
    var names = variable_struct_get_names(source);
    for (var i = 0, len = array_length(names); i < len; ++i) {
        var name = names[i];
        variable_struct_set(destination, name, variable_struct_get(source, name));
    }
}

function PathfinderOptions(_max_estimation/*: number*/) constructor
{
    max_estimation = _max_estimation; /// @is {number}
}
