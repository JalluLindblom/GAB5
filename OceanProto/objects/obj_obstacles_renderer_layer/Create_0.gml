event_inherited();

renderer    = /*#cast*/ undefined;   /// @is {obj_obstacles_renderer}
surf_rect   = /*#cast*/ undefined;   /// @is {Rect}

initialize = function(_renderer/*: obj_obstacles_renderer*/, _surf_rect/*: Rect*/)
{
    renderer = _renderer;
    surf_rect = _surf_rect;
}