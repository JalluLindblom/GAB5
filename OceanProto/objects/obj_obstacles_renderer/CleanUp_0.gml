event_inherited();

surface = destroy_surface(surface);

for (var i = 0, len = array_length(layers); i < len; ++i) {
    layers[i] = destroy_instance(layers[i]);
}
array_resize(layers, 0);
