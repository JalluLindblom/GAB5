
function make_instructions_menu() /*-> MenuDefinition*/
{
    var headers = /*#cast*/ [
        ME_spacer(1.0),
        ME_heading(LANG("Instructions_Title")),
        ME_spacer(1.0),
    ] /*#as MenuEntryDefinition[]*/;
    
    var bodies = /*#cast*/ [] /*#as MenuEntryDefinition[]*/;
    
    if (array_length(Configs.options_openness) > 1) {
        //array_push(bodies, ME_text(LANG("Trait_Openness"), true, false));
        array_push(bodies, ME_text(LANG("Instructions_Openness_Description"), false, false));
        array_push(bodies, ME_spacer(1));
    }
    else {
        traits.openness = Configs.options_openness[0];
    }
    
    if (array_length(Configs.options_conscientiousness) > 1) {
        //array_push(bodies, ME_text(LANG("Trait_Conscientiousness"), true, false));
        array_push(bodies, ME_text(LANG("Instructions_Conscientiousness_Description"), false, false));
        array_push(bodies, ME_spacer(1));
    }
    else {
        traits.conscientiousness = Configs.options_conscientiousness[0];
    }
    
    if (array_length(Configs.options_extraversion) > 1) {
        //array_push(bodies, ME_text(LANG("Trait_Extraversion"), true, false));
        array_push(bodies, ME_text(LANG("Instructions_Extraversion_Description"), false, false));
        array_push(bodies, ME_spacer(1));
    }
    else {
        traits.extraversion = Configs.options_extraversion[0];
    }
    
    if (array_length(Configs.options_agreeableness) > 1) {
        //array_push(bodies, ME_text(LANG("Trait_Agreeableness"), true, false));
        array_push(bodies, ME_text(LANG("Instructions_Agreeableness_Description"), false, false));
        array_push(bodies, ME_spacer(1));
    }
    else {
        traits.agreeableness = Configs.options_agreeableness[0];
    }
    
    if (array_length(Configs.options_neuroticism) > 1) {
        //array_push(bodies, ME_text(LANG("Trait_Neuroticism"), true, false));
        array_push(bodies, ME_text(LANG("Instructions_Neuroticism_Description"), false, false));
        array_push(bodies, ME_spacer(1));
    }
    else {
        traits.neuroticism = Configs.options_neuroticism[0];
    }
    
    var footers = /*#cast*/ [
        ME_spacer(2.0),
    ] /*#as MenuEntryDefinition[]*/;
    
    return new MenuDefinition(headers, bodies, footers);
}
