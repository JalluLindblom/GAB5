
function make_personality_traits_menu(traits/*: PersonalityTraits*/, header_text/*: string*/, done_callback/*: (function<void>)*/) /*-> MenuDefinition*/
{
    var headers = /*#cast*/ [
        ME_spacer(1.0),
        ME_heading(header_text),
        ME_spacer(1.0),
    ] /*#as MenuEntryDefinition[]*/;
    
    var bodies = /*#cast*/ [] /*#as MenuEntryDefinition[]*/;
    
    var sliders = /*#cast*/ [] /*#as _MenuEntryDefinitionDiscreteSlider[]*/;
	
	var capture = {
		play_pressed: false,
		play_pressed_callback: done_callback,
		sliders: sliders,
	};
    
    var check_is_next_slider = method(capture, function(slider/*: _MenuEntryDefinitionDiscreteSlider*/) {
        if (slider.has_been_interacted_with) {
            return false;
        }
        for (var i = 0, len = array_length(sliders); i < len; ++i) {
            var s = sliders[i];
            if (!s.has_been_interacted_with) {
                return (s == slider);
            }
        }
        return false;
    });
	
	var check_is_slider_enabled = method(capture, function() {
		return !play_pressed;
	});
    
    if (array_length(Configs.options_openness) > 1) {
        var slider = ME_field_discrete_slider(LANG("Trait_Openness"), traits, "openness", Configs.options_openness, check_is_next_slider, undefined, check_is_slider_enabled);
        array_push(sliders, slider);
        array_push(bodies, slider);
        array_push(bodies, ME_spacer(0.5));
    }
    else {
        traits.openness = Configs.options_openness[0];
    }
    
    if (array_length(Configs.options_conscientiousness) > 1) {
        var slider = ME_field_discrete_slider(LANG("Trait_Conscientiousness"), traits, "conscientiousness", Configs.options_conscientiousness, check_is_next_slider, undefined, check_is_slider_enabled);
        array_push(sliders, slider);
        array_push(bodies, slider);
        array_push(bodies, ME_spacer(0.5));
    }
    else {
        traits.conscientiousness = Configs.options_conscientiousness[0];
    }
    
    if (array_length(Configs.options_extraversion) > 1) {
        var slider = ME_field_discrete_slider(LANG("Trait_Extraversion"), traits, "extraversion", Configs.options_extraversion, check_is_next_slider, undefined, check_is_slider_enabled);
        array_push(sliders, slider);
        array_push(bodies, slider);
        array_push(bodies, ME_spacer(0.5));
    }
    else {
        traits.extraversion = Configs.options_extraversion[0];
    }
    
    if (array_length(Configs.options_agreeableness) > 1) {
        var slider = ME_field_discrete_slider(LANG("Trait_Agreeableness"), traits, "agreeableness", Configs.options_agreeableness, check_is_next_slider, undefined, check_is_slider_enabled);
        array_push(sliders, slider);
        array_push(bodies, slider);
        array_push(bodies, ME_spacer(0.5));
    }
    else {
        traits.agreeableness = Configs.options_agreeableness[0];
    }
    
    if (array_length(Configs.options_neuroticism) > 1) {
        var slider = ME_field_discrete_slider(LANG("Trait_Neuroticism"), traits, "neuroticism", Configs.options_neuroticism, check_is_next_slider, undefined, check_is_slider_enabled);
        array_push(sliders, slider);
        array_push(bodies, slider);
        array_push(bodies, ME_spacer(0.5));
    }
    else {
        traits.neuroticism = Configs.options_neuroticism[0];
    }
    
    var is_infinite_speed = (Configs.game_speed < 0);
    var play_text = is_infinite_speed ? LANG("TraitMenu_PlayInfiniteSpeed") : LANG("TraitMenu_Play");
    array_append(bodies, [
        ME_spacer(1.5),
        ME_button(
            play_text,
            method(capture, function() {
				if (!play_pressed) {
					play_pressed_callback();
					play_pressed = true;
				}
                return MENU_RETURN.void;
            }),
            method(capture, function() {
				if (play_pressed) {
					return false;
				}
                var all_sliders_have_been_interacted_with = true;
                for (var i = 0, len = array_length(sliders); i < len; ++i) {
                    var slider = sliders[i];
                    if (!slider.has_been_interacted_with) {
                        all_sliders_have_been_interacted_with = false;
                        break;
                    }
                }
                return all_sliders_have_been_interacted_with;
            })
        ),
    ]);
    
    var footers = /*#cast*/ [
        ME_spacer(2.0),
    ] /*#as MenuEntryDefinition[]*/;
    
    return new MenuDefinition(headers, bodies, footers);
}

function get_personality_traits_via_menu(traits/*: PersonalityTraits*/, menu_header_text/*: string*/) /*-> Promise<PersonalityTraits>*/
{
    var c = {
        traits: traits,
        menu_header_text: menu_header_text,
    };
	return wait_close_all_personality_traits_menus()
	.and_then(method(c, function() {
		return new Promise(function(resolve, reject) {
			var menu_instance = instance_create_depth(0, 0, 0, obj_personality_traits_menu);
	        menu_instance.initialize(traits, menu_header_text, resolve);
		});
	}));
}

/// @returns {Promise}
function wait_close_all_personality_traits_menus()
{
	if (instance_exists(obj_personality_traits_menu)) {
		with (obj_personality_traits_menu) {
			closing = true;
		}
		return wait_condition(function() {
			return !instance_exists(obj_personality_traits_menu);
		});
	}
	else {
		return promise_resolve();
	}
}
