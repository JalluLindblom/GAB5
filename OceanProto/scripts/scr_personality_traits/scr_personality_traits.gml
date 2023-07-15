
function PersonalityTraits(
    _openness/*: number*/ = 0,
    _conscientiousness/*: number*/ = 0,
    _extraversion/*: number*/ = 0,
    _agreeableness/*: number*/ = 0,
    _neuroticism/*: number*/ = 0
) constructor
{
    openness            = _openness;            /// @is {number}
    conscientiousness   = _conscientiousness;   /// @is {number}
    extraversion        = _extraversion;        /// @is {number}
    agreeableness       = _agreeableness;       /// @is {number}
    neuroticism         = _neuroticism;         /// @is {number}
}

function PersonalityTraitRanges(
    _openness/*:          number[]*/,
    _conscientiousness/*: number[]*/,
    _extraversion/*:      number[]*/,
    _agreeableness/*:     number[]*/,
    _neuroticism/*:       number[]*/
) constructor
{
    openness            = _openness;            /// @is {number[]}
    conscientiousness   = _conscientiousness;   /// @is {number[]}
    extraversion        = _extraversion;        /// @is {number[]}
    agreeableness       = _agreeableness;       /// @is {number[]}
    neuroticism         = _neuroticism;         /// @is {number[]}
}

function personality_traits_from_ranges(ranges/*: PersonalityTraitRanges*/, rng/*: Rng*/) /*-> PersonalityTraits*/
{
    return new PersonalityTraits(
        rng.rng_random_range(ranges.openness[0],            ranges.openness[1]),
        rng.rng_random_range(ranges.conscientiousness[0],   ranges.conscientiousness[1]),
        rng.rng_random_range(ranges.extraversion[0],        ranges.extraversion[1]),
        rng.rng_random_range(ranges.agreeableness[0],       ranges.agreeableness[1]),
        rng.rng_random_range(ranges.neuroticism[0],         ranges.neuroticism[1]),
    );
}

function personality_traits_copied(traits/*: PersonalityTraits*/) /*-> PersonalityTraits*/
{
    return new PersonalityTraits(
        traits.openness,
        traits.conscientiousness,
        traits.extraversion,
        traits.agreeableness,
        traits.neuroticism
    );
}

function personality_traits_print_data(personality_traits/*: PersonalityTraits*/) /*-> string*/
{
    var params_table = new StringTable(fa_left, fa_left);
    
    params_table.add_row("Parameter", "Value");
    params_table.add_row("Openness", string(personality_traits.openness));
    params_table.add_row("Conscientiousness", string(personality_traits.conscientiousness));
    params_table.add_row("Extraversion", string(personality_traits.extraversion));
    params_table.add_row("Agreeableness", string(personality_traits.agreeableness));
    params_table.add_row("Neuroticism", string(personality_traits.neuroticism));
    
    var action_labels = array_mapped(global.all_human_action_types, function(action_type/*: HumanActionType*/) {
        return action_type.debug_name;
    });
    var energy_level = 1.0; // mock value
    var c = {
        personality_traits: personality_traits,
        energy_level: energy_level,
    };
    var action_weights = array_mapped(global.all_human_action_types, method(c, function(action_type/*: HumanActionType*/) {
        return action_type.get_weight(personality_traits, energy_level);
    }));
    
    var action_weights_table = _make_sampler_string_table("Action", action_labels, action_weights);
    
    var exchange_labels = [
        "Give",
        "Take",
    ];
    var exchange_weights = [
        Configs.exchange_give_weight(personality_traits, energy_level),
        Configs.exchange_take_weight(personality_traits, energy_level),
    ];
    var exchange_weights_table = _make_sampler_string_table("Exchange action", exchange_labels, exchange_weights);
    
    return params_table.dump(1, " ") + "\n\n" + action_weights_table.dump(1, " ") + "\n\n" + exchange_weights_table.dump(1, " ");
}

function _make_sampler_string_table(header/*: string*/, labels/*: string[]*/, weights/*: number[]*/) /*-> StringTable*/
{
    var table = new StringTable(fa_left, fa_left, fa_left);
    
    table.add_row(header, "Weight", "Probability");
    
    var total_weight = 0;
    var min_weight = /*#cast*/ undefined /*#as number*/;
    var max_weight = /*#cast*/ undefined /*#as number*/;
    for (var i = 0, len = array_length(weights); i < len; ++i) {
        var weight = weights[i];
        total_weight += weight;
        if (min_weight == undefined || weight < min_weight) {
            min_weight = weight;
        }
        if (max_weight == undefined || weight > max_weight) {
            max_weight = weight;
        }
    }
    
    var weight_format_total = 3;
    var weight_format_decimals = 2;
    var prob_format_total = 3;
    var prob_format_decimals = 2;
    
    var hue_min = color_get_hue(c_red);
    var hue_max = color_get_hue(c_green);
    var num_entries = min(array_length(labels), array_length(weights));
    for (var i = 0; i < num_entries; ++i) {
        var label = labels[i];
        var weight = weights[i];
        var hue = lerp(hue_min, hue_max, inv_lerp(min_weight, max_weight, weight));
        var color = make_color_hsv(hue, 160, 255);
        var col1 = label;
        var col2 = string_format(weight, weight_format_total, weight_format_decimals);
        var relative_weight = (total_weight > 0) ? (weight / total_weight) : 0;
        var percent_str = string_format(relative_weight * 100, prob_format_total, prob_format_decimals) + "%";
        var col3 = "[#" + color_to_rgb_hexadecimal_string(color) + "]" + percent_str + "[/]";
        
        table.add_row(col1, col2, col3);
    }
    
    table.add_row("TOTAL", string_format(total_weight, weight_format_total, weight_format_decimals), string_format(100, prob_format_total, prob_format_decimals) + "%");
    
    return table;
}

function personality_traits_make_all_permutations(
    options_openness/*: number[]*/,
    options_conscientiousness/*: number[]*/,
    options_extraversion/*: number[]*/,
    options_agreeableness/*: number[]*/,
    options_neuroticism/*: number[]*/
) /*-> PersonalityTraits[]*/
{
    var permutations = [];
    
    for (var i = 0; i < array_length(options_openness); ++i) {
        var openness = options_openness[i];
        for (var j = 0; j < array_length(options_conscientiousness); ++j) {
            var conscientiousness = options_conscientiousness[j];
            for (var k = 0; k < array_length(options_extraversion); ++k) {
                var extraversion = options_extraversion[k];
                for (var n = 0; n < array_length(options_agreeableness); ++n) {
                    var agreeableness = options_agreeableness[n];
                    for (var m = 0; m < array_length(options_neuroticism); ++m) {
                        var neuroticism = options_neuroticism[m];
                        array_push(permutations, new PersonalityTraits(openness, conscientiousness, extraversion, agreeableness, neuroticism));
                    }
                }
            }
        }
    }
    
    return permutations;
}
