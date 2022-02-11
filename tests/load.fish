set parent (dirname (status --current-filename))
source $parent/fixtures/functions.fish
source $parent/fixtures/variables.fish

set command_usage "\
Usage:
    pond load ponds...

Arguments:
    ponds  The name of one or more ponds to load"

set success_output_single_pond "\
Loaded pond: $pond_name"

set success_output_multiple_ponds "\
Loaded pond: $pond_name_prefix-1
Loaded pond: $pond_name_prefix-2
Loaded pond: $pond_name_prefix-3"

set not_exists_error (__pond_error_string "Pond does not exist: no-exist")

function __pond_loaded_event_intercept --on-event pond_loaded -a got_pond_name got_pond_path
    set -ga event_pond_names $got_pond_name
    set -ga event_pond_paths $got_pond_path
end

@echo "pond load: success tests for single pond"
__pond_setup 1 disabled unloaded populated
@test "setup: pond function path absent" (not contains $pond_home/$pond_name $pond_function_path) $status -eq $success
@test "setup: pond fish function path absent" (not contains $pond_home/$pond_name $fish_function_path) $status -eq $success
@test "pond load: success exit code" (pond load $pond_name >/dev/null 2>&1) $status -eq $success
@test "pond load: pond function path absent" (not contains $pond_home/$pond_name $pond_function_path) $status -eq $success
@test "pond load: fish function path created" (contains $pond_home/$pond_name $fish_function_path) $status -eq $success
@test "pond load: got pond name in event" (echo $event_pond_names) = $pond_name
@test "pond load: got pond path in event" (echo $event_pond_paths) = $pond_home/$pond_name
__pond_tear_down
__pond_event_reset

@echo "pond load: output tests for single pond"
__pond_setup 1 disabled loaded populated
@test "pond load: success output message" (pond load $pond_name 2>&1) = $success_output_single_pond
__pond_tear_down
__pond_event_reset

@echo "pond load: success tests for multiple ponds"
__pond_setup 3 disabled unloaded populated
@test "setup: $pond_name_prefix-1 pond function path absent" (not contains $pond_home/$pond_name_prefix-1 $pond_function_path) $status -eq $success
@test "setup: $pond_name_prefix-2 pond function path absent" (not contains $pond_home/$pond_name_prefix-2 $pond_function_path) $status -eq $success
@test "setup: $pond_name_prefix-3 pond function path absent" (not contains $pond_home/$pond_name_prefix-3 $pond_function_path) $status -eq $success
@test "setup: $pond_name_prefix-1 fish function path absent" (not contains $pond_home/$pond_name_prefix-1 $fish_function_path) $status -eq $success
@test "setup: $pond_name_prefix-2 fish function path absent" (not contains $pond_home/$pond_name_prefix-2 $fish_function_path) $status -eq $success
@test "setup: $pond_name_prefix-3 fish function path absent" (not contains $pond_home/$pond_name_prefix-3 $fish_function_path) $status -eq $success
@test "pond load: success exit code" (pond load $pond_name_prefix-1 $pond_name_prefix-2 $pond_name_prefix-3 >/dev/null 2>&1) $status -eq $success
@test "pond load: $pond_name_prefix-1 pond function path absent" (not contains $pond_home/$pond_name_prefix-1 $pond_function_path) $status -eq $success
@test "pond load: $pond_name_prefix-2 pond function path absent" (not contains $pond_home/$pond_name_prefix-2 $pond_function_path) $status -eq $success
@test "pond load: $pond_name_prefix-3 pond function path absent" (not contains $pond_home/$pond_name_prefix-3 $pond_function_path) $status -eq $success
@test "pond load: $pond_name_prefix-1 fish function path created" (contains $pond_home/$pond_name_prefix-1 $fish_function_path) $status -eq $success
@test "pond load: $pond_name_prefix-2 fish function path created" (contains $pond_home/$pond_name_prefix-2 $fish_function_path) $status -eq $success
@test "pond load: $pond_name_prefix-3 fish function path created" (contains $pond_home/$pond_name_prefix-3 $fish_function_path) $status -eq $success
@test "pond load: got pond names in events" (echo $event_pond_names) = "$pond_name_prefix-1 $pond_name_prefix-2 $pond_name_prefix-3"
@test "pond load: got pond paths in events" (echo $event_pond_paths) = "$pond_home/$pond_name_prefix-1 $pond_home/$pond_name_prefix-2 $pond_home/$pond_name_prefix-3"
__pond_tear_down
__pond_event_reset

@echo "pond load: output tests for multiple ponds"
__pond_setup 3 enabled unloaded populated
@test "pond load: success output message" (pond load $pond_name_prefix-1 $pond_name_prefix-2 $pond_name_prefix-3 2>&1 | string collect) = $success_output_multiple_ponds
__pond_tear_down
__pond_event_reset

@echo "pond load: validation failure exit code tests"
@test "pond load: fails for missing pond name" (pond load >/dev/null 2>&1) $status -eq $failure
@test "pond load: fails for malformed pond name" (pond load _invalid >/dev/null 2>&1) $status -eq $failure
@test "pond load: fails for non-existent pond" (pond load no-exist >/dev/null 2>&1) $status -eq $failure

@echo "pond load: validation failure output tests"
@test "pond load: command usage shown for missing pond name" (pond load 2>&1 | string collect) = $command_usage
@test "pond load: command usage shown for malformed pond name" (pond load _invalid 2>&1 | string collect) = $command_usage
@test "pond load: command error shown for non-existent pond" (pond load no-exist 2>&1 | string collect) = $not_exists_error
