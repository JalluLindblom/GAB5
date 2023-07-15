event_inherited();

static_shadows_surface = -1;            /// @is {surface}
statics_surface_needs_redraw = true;    /// @is {bool}

// This variable is turned on by objects that are considered "statics"
// when they're created and destroyed, so that this renderer knows to
// rerender their shadows.
statics_changed = false;                /// @is {bool}