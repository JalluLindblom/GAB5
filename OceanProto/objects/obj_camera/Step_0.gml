event_inherited();

var cam = view_camera[0];

var ww = max(1, window_get_width());
var wh = max(1, window_get_height());

var asw = surface_get_width(application_surface);
var ash = surface_get_height(application_surface);
if (asw != ww || ash != wh) {
    surface_resize(application_surface, ww, wh);
}

var cam_x = 0;
var cam_y = 0;
var cam_width = ww;
var cam_height = wh;
if (instance_exists(Trial) && Trial.terrain != undefined) {
    var terrain_width = Trial.terrain.width * CSIZE;
    var terrain_height = Trial.terrain.height * CSIZE;
    if (terrain_width > cam_width) {
        var ratio = terrain_width / cam_width;
        cam_width *= ratio;
        cam_height *= ratio;
    }
    if (terrain_height > cam_height) {
        var ratio = terrain_height / cam_height;
        cam_width *= ratio;
        cam_height *= ratio;
    }
    cam_x = (terrain_width / 2) - (cam_width / 2);
    cam_y = (terrain_height / 2) - (cam_height / 2);
    
}

var aspect_ratio = cam_width / cam_height;
cam_height += 150;
cam_width  += 150 * aspect_ratio;

camera_set_view_size(cam, cam_width, cam_height);
camera_set_view_pos(cam, cam_x, cam_y);