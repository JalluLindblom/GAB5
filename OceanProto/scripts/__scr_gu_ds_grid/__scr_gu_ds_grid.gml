
function ds_grid_copied(grid/*: ds_grid*/) /*-> ds_grid*/
{
    var copy = ds_grid_create(ds_grid_width(grid), ds_grid_height(grid));
    ds_grid_copy(copy, grid);
    return copy;
}

function ds_grid_equals(grid1/*: ds_grid*/, grid2/*: ds_grid*/) /*-> bool*/
{
    var w1 = ds_grid_width(grid1);
    var h1 = ds_grid_height(grid1);
    if (w1 != ds_grid_width(grid2) || h1 != ds_grid_height(grid2)) {
        return false;
    }
    for (var xx = 0; xx < w1; ++xx) {
        for (var yy = 0; yy < h1; ++yy) {
            if (grid1[# xx, yy] != grid2[# xx, yy]) {
                return false;
            }
        }
    }
    return true;
}
