
function human_find_exploration_pathfinding_target(human/*: obj_human*/, tick_rng/*: Rng*/) /*-> TerrainCell?*/
{
    var human_cx = floor(human.x / CSIZE);
    var human_cy = floor(human.y / CSIZE);
    var cell_sight_radius = floor(human.exploration_range / CSIZE);
    var cx1 = clamp(human_cx - cell_sight_radius, 0, Trial.terrain.width - 1);
    var cy1 = clamp(human_cy - cell_sight_radius, 0, Trial.terrain.height - 1);
    var cx2 = clamp(human_cx + cell_sight_radius, 0, Trial.terrain.width - 1);
    var cy2 = clamp(human_cy + cell_sight_radius, 0, Trial.terrain.height - 1);
    var tcells = Trial.terrain.cells;
    static candidate_cells = [];
    var num_candidate_cells = 0;
    for (var cx = cx1; cx <= cx2; ++cx) {
        for (var cy = cy1; cy <= cy2; ++cy) {
            if (point_distance(human_cx, human_cy, cx, cy) > cell_sight_radius) {
                continue;
            }
            var cell = tcells[cy][cx];
            if (!cell.is_traversable) {
                continue;
            }
            candidate_cells[num_candidate_cells++] = cell;
        }
    }
    if (num_candidate_cells <= 0) {
        return undefined;
    }
    return tick_rng.rng_array_get_random(candidate_cells, 0, num_candidate_cells);
}
