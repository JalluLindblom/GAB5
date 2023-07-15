
function Terrain() constructor
{
    cells = []; /// @is {TerrainCell[][]}
    width = 0;  /// @is {int}
    height = 0; /// @is {int}
    
    static cell_at = function(cx/*: int*/, cy/*: int*/) /*-> TerrainCell?*/
    {
        if (cx < 0 || cx >= width || cy < 0 || cy >= height) {
            return undefined;
        }
        return cells[cy][cx];
    }
    
    static cell_at_room = function(xx/*: number*/, yy/*: number*/) /*-> TerrainCell?*/
    {
        var cx = xx / CSIZE;
        var cy = yy / CSIZE;
        if (cx < 0 || cx >= width || cy < 0 || cy >= height) {
            return undefined;
        }
        return cells[cy][cx];
    }
    
    static free = function()
    {
    }
}

function TerrainCell(_cx/*: int*/, _cy/*: int*/, _is_traversable/*: bool*/) constructor
{
    cx = _cx;                           /// @is {int}
    cy = _cy;                           /// @is {int}
    is_traversable = _is_traversable;   /// @is {bool}
    is_sand = false;                    /// @is {bool}
    is_rock = false;                    /// @is {bool}
    
    room_rect = new Rect(cx * CSIZE, cy * CSIZE, (cx + 1) * CSIZE, (cy + 1) * CSIZE);   /// @is {Rect}
    
    static should_have_ground_tile = function() /*-> bool*/
    {
        return is_traversable || is_rock;
    }
}

function euclidean_distance_between_terrain_cells(cell1/*: TerrainCell*/, cell2/*: TerrainCell*/) /*-> number*/
{
    return point_distance(cell1.cx, cell1.cy, cell2.cx, cell2.cy);
}

function terrain_cells_colliding_between_cells(terrain/*: Terrain*/, c1/*: TerrainCell*/, c2/*: TerrainCell*/, cells_array/*: TerrainCell[]?*/) /*-> int*/
{
    var cx1 = min(c1.cx, c2.cx);
    var cy1 = min(c1.cy, c2.cy);
    var cx2 = max(c1.cx, c2.cx);
    var cy2 = max(c1.cy, c2.cy);
    var lx1 = c1.cx * CSIZE;
    var ly1 = c1.cy * CSIZE;
    var lx2 = c2.cx * CSIZE;
    var ly2 = c2.cy * CSIZE;
    var cw = CSIZE - 1;
    var ch = CSIZE - 1;
    
    var n = 0;
    for (var cx = cx1; cx <= cx2; ++cx) {
        for (var cy = cy1; cy <= cy2; ++cy) {
            var cell = terrain.cells[cy, cx];
            if (cell.is_traversable) {
                continue;
            }
            var crx1 = cell.room_rect.x1;
            var cry1 = cell.room_rect.y1;
            var crx2 = cell.room_rect.x2;
            var cry2 = cell.room_rect.y2;
            var collides = (line_on_rectangle(lx1, ly1, lx2, ly2, crx1, cry1, crx2, cry2)
                         || line_on_rectangle(lx1 + cw, ly1, lx2 + cw, ly2, crx1, cry1, crx2, cry2)
                         || line_on_rectangle(lx1, ly1 + ch, lx2, ly2 + ch, crx1, cry1, crx2, cry2)
                         || line_on_rectangle(lx1 + cw, ly1 + ch, lx2 + cw, ly2 + ch, crx1, cry1, crx2, cry2));
            if (collides) {
                if (cells_array != undefined) {
                    cells_array[n++] = cell;
                }
                else {
                    return true;
                }
            }
        }
    }
    return n;
}
