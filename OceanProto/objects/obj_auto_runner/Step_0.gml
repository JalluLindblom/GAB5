event_inherited();

if (running) {
    return;
}

if (current_param_index >= array_length(params)) {
    callback();
    instance_destroy();
    return;
}

// Every now and then close and reopen the file so that we'll be dumping data
// consistently (in case of a crash later on or something).
if (current_param_index % 100 == 0) {
    file_text_close(file);
    file = file_text_open_append(output_csv_filename);
    gc_collect();
}

running = true;

LoadingStatus.set(string(current_param_index + 1) + "/" + string(array_length(params)));
var level_filename = params[current_param_index].filename;
var traits = params[current_param_index].traits;
var seed = params[current_param_index].seed;
var capture = {
    output_csv_filename: output_csv_filename,
    file: file,
    id: id,
};
return auto_run_trial(level_filename, current_param_index + 1, traits, seed, total_score)
.and_then(method(capture, function(trial_data/*: TrialData*/) {
    id.total_score += trial_data.result.trial_score;
    file_text_write_string(id.file, trial_data_as_csv(trial_data));
    id.running = false;
    ++id.current_param_index;
}))
.and_catch(function(err) {
    show_message(err);
});