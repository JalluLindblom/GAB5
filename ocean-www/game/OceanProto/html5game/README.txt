
----- Running auto-runs via the command line -----

To start an auto-run via the command line, start "Ocean Proto.exe" and give it the following command line parameters:
    "config":          The configuration file to use. This should refer to a file in this directory, such as "configurations.json"
    "lang":            The language to use. This should refer to a localization file in the /localization/ directory. For example, to use the english language file "en.ini", pass "en" as the value to this parameter.
    "auto_run_config": The auto-run configuration file. For example "example_auto_run_configs.json".
    "auto_run_seed":   The seed for the random generator for running the simulations.
    "auto_run_output": The output filename where the results of the auto-run will be printed in CSV format.
    "log_output_file": (optional) A filename to an output log file.

Example command line call:
"Ocean Proto.exe" config=configurations.json lang=en auto_run_config=example_auto_run_configs.json auto_run_output=trials.csv log_output_file=log.txt auto_run_seed=12345

Note that if you pass a non-absolute path to any of the output filename arguments (auto_run_output or log_output_file), the root directory will be your AppData directory.
So for example, if you write "auto_run_output=trials.csv", it will resolve as "C:/Users/<username>/AppData/Local/OceanProto/trials.csv"
On the other hand, for the input filenames such as "auto_run_config", a non-absolute value such as "auto_run_config=example_auto_run_configs.json" will find that file within the directory where the executable file (Ocean Proto.exe) is.

--------------------------------------------------
