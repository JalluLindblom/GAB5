
function generate_levels_batch(
    generator_configs/*: struct*/,
    rng/*: Rng*/,
    callback/*: (function<Level, int, void>)*/
) /*-> int*/
{
    var gen = generator_configs; // for brevity
    
    var monster_num_decks = [];
    for (var i = 0; i < array_length(gen.monster_amounts); ++i) {
        var range = array_range(gen.monster_amounts[i][$ "min"], gen.monster_amounts[i][$ "max"]);
        array_push(monster_num_decks, random_deck_from_array(range));
    }
    var food_num_decks = [];
    for (var i = 0; i < array_length(gen.food_amounts); ++i) {
        var range = array_range(gen.food_amounts[i][$ "min"], gen.food_amounts[i][$ "max"]);
        array_push(food_num_decks, random_deck_from_array(range));
    }
    var human_num_decks = [];
    for (var i = 0; i < array_length(gen.human_amounts); ++i) {
        var range = array_range(gen.human_amounts[i][$ "min"], gen.human_amounts[i][$ "max"]);
        array_push(human_num_decks, random_deck_from_array(range));
    }
    
    var num_null_levels = array_length(array_filtered(monster_num_decks, _deck_is_all_zeroes))
                        * array_length(array_filtered(food_num_decks, _deck_is_all_zeroes))
                        * array_length(array_filtered(human_num_decks, _deck_is_all_zeroes));
    var total_num_levels = (array_length(monster_num_decks) * array_length(food_num_decks) * array_length(human_num_decks) - num_null_levels) * gen.num_variations;
    
    var sand_amounts = array_create(total_num_levels);
    var values_per_sand_deck = ceil(total_num_levels / array_length(gen.sand_amounts));
    var sand_n = 0;
    for (var i = 0; i < array_length(gen.sand_amounts); ++i) {
        var range = array_range(gen.sand_amounts[i][$ "min"], gen.sand_amounts[i][$ "max"]);
        var deck = random_deck_from_array(range);
        repeat (values_per_sand_deck) {
            if (sand_n < total_num_levels) {
                sand_amounts[sand_n++] = deck.draw_one(rng);
            }
        }
    }
    var sand_deck = random_deck_from_array(sand_amounts);
    
    var n = 0;
    for (var m = 0; m < array_length(monster_num_decks); ++m) {
        var monster_num_deck = monster_num_decks[m];
        for (var f = 0; f < array_length(food_num_decks); ++f) {
            var food_num_deck = food_num_decks[f];
            for (var h = 0; h < array_length(human_num_decks); ++h) {
                var human_num_deck = human_num_decks[h];
                
                if (_deck_is_all_zeroes(monster_num_deck) && _deck_is_all_zeroes(food_num_deck) && _deck_is_all_zeroes(human_num_deck)) {
                    // Don't generate levels that don't have any monsters, food or humans.
                    continue;
                }
                
                repeat (gen.num_variations) {
                    var num_monsters = monster_num_deck.draw_one(rng);
                    var num_foods = food_num_deck.draw_one(rng);
                    var num_humans = human_num_deck.draw_one(rng);
                    var num_sand = sand_deck.draw_one(rng);
                    var width = rng.rng_irandom_range(gen.min_width, gen.max_width);
                    var height = rng.rng_irandom_range(gen.min_height, gen.max_height);
                    var level = generate_level(width, height, num_monsters, num_foods, num_humans, num_sand, rng);
                    callback(level, n);
                    ++n;
                }
            }
        }
    }
    
    return n;
}

function generate_levels_batch_as_files(generator_configs/*: struct*/, directory_name/*: string*/, rng/*: Rng*/)
{
    var root_dir = environment_get_variable("LOCALAPPDATA");
    if (!string_ends_with(root_dir, "/") && !string_ends_with(root_dir, "\\")) {
        root_dir += "\\";
    }
    root_dir += "OceanProto\\generated_levels\\";
    
    var project_directory = build_tools_get_env_var("YYprojectDir");
    if (project_directory != undefined && show_question("Project directory detected. Generate the new level files directly into the project?")) {
        root_dir = project_directory + "\\datafiles\\";
    }
    else if (show_question("Levels will be generated into " + root_dir + ". Copy this path to clipboard now?")) {
        clipboard_set_text(root_dir);
    }
    
    var capture = {
        root_dir: root_dir,
        directory_name: directory_name,
        filenames: [],
    };
    var n = generate_levels_batch(generator_configs, rng, method(capture, function(level/*: Level*/, index/*: int*/) {
        var level_name = "level_" + string(index + 1);
        var relative_filename = directory_name + "\\" + level_name + ".txt";
        var success = level_write_to_file(level, root_dir + relative_filename);
        array_push(filenames, relative_filename);
        log("Generated level " + level_name + ". Saving it " + (success ? "[c_green]succeeded[/]" : "[c_red]failed[/]") + ".");
    }));
    log("Generated a total of " + string(n) + " levels.");
    
    file_write_string(root_dir + directory_name + "\\levels_config.json", snap_to_json({ levels: capture.filenames }, true));
    
    show_message("Level generation completed.");
}

function _deck_is_all_zeroes(deck/*: RandomDeck*/) /*-> bool*/
{
    return array_all_eq(deck._elements, 0);
}
