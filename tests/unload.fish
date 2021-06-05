source ./fixtures/functions.fish
source ./fixtures/variables.fish

set success_output_single_pond "\
Unloaded pond: $pond_name"

set success_output_multiple_ponds "\
Unloaded pond: $pond_name_prefix-1
Unloaded pond: $pond_name_prefix-2
Unloaded pond: $pond_name_prefix-3"

set command_usage "\
Usage:
    pond unload ponds...

Arguments:
    ponds  The name of one or more ponds to unload"

set not_exists_error (__pond_error_string "Pond does not exist: no-exist")

function __pond_unloaded_event_intercept --on-event pond_unloaded -a got_pond_name got_pond_path
    set -ga event_pond_names $got_pond_name
    set -ga event_pond_paths $got_pond_path
end

@echo "pond unload: success tests for single pond"
__pond_setup 1 enabled unpopulated
@test "setup: pond function path present" (contains $pond_home/$pond_name $pond_function_path) $status -eq $success
@test "setup: fish function path present" (contains $pond_home/$pond_name $fish_function_path) $status -eq $success
@test "pond unload: success exit code" (pond unload $pond_name >/dev/null 2>&1) $status -eq $success
@test "setup: pond function path present" (contains $pond_home/$pond_name $pond_function_path) $status -eq $success
@test "setup: fish function path removed" (not contains $pond_home/$pond_name $fish_function_path) $status -eq $success
@test "pond unload: got pond name in event" (echo $event_pond_names) = $pond_name
@test "pond unload: got pond path in event" (echo $event_pond_paths) = $pond_home/$pond_name
__pond_tear_down
__pond_event_reset

@echo "pond unload: output tests for single pond"
__pond_setup 1 enabled unpopulated
@test "pond unload: success output message" (pond unload $pond_name 2>&1) = "Unloaded pond: $pond_name"
__pond_tear_down
__pond_event_reset

@echo "pond unload: success tests for multiple ponds"
__pond_setup 3 enabled unpopulated
@test "setup: $pond_name_prefix-1 pond function path present" (contains $pond_home/$pond_name_prefix-1 $pond_function_path) $status -eq $success
@test "setup: $pond_name_prefix-2 pond function path present" (contains $pond_home/$pond_name_prefix-2 $pond_function_path) $status -eq $success
@test "setup: $pond_name_prefix-3 pond function path present" (contains $pond_home/$pond_name_prefix-3 $pond_function_path) $status -eq $success
@test "setup: $pond_name_prefix-1 fish function path present" (contains $pond_home/$pond_name_prefix-1 $fish_function_path) $status -eq $success
@test "setup: $pond_name_prefix-2 fish function path present" (contains $pond_home/$pond_name_prefix-2 $fish_function_path) $status -eq $success
@test "setup: $pond_name_prefix-3 fish function path present" (contains $pond_home/$pond_name_prefix-3 $fish_function_path) $status -eq $success
@test "pond unload: success exit code" (pond unload $pond_name_prefix-1 $pond_name_prefix-2 $pond_name_prefix-3 >/dev/null 2>&1) $status -eq $success
@test "pond unload: $pond_name_prefix-1 pond function path present" (contains $pond_home/$pond_name_prefix-1 $pond_function_path) $status -eq $success
@test "pond unload: $pond_name_prefix-2 pond function path present" (contains $pond_home/$pond_name_prefix-2 $pond_function_path) $status -eq $success
@test "pond unload: $pond_name_prefix-3 pond function path present" (contains $pond_home/$pond_name_prefix-3 $pond_function_path) $status -eq $success
@test "pond unload: $pond_name_prefix-1 fish function path removed" (not contains $pond_home/$pond_name_prefix-1 $fish_function_path) $status -eq $success
@test "pond unload: $pond_name_prefix-2 fish function path removed" (not contains $pond_home/$pond_name_prefix-2 $fish_function_path) $status -eq $success
@test "pond unload: $pond_name_prefix-3 fish function path removed" (not contains $pond_home/$pond_name_prefix-3 $fish_function_path) $status -eq $success
@test "pond unload: got pond names in events" (echo $event_pond_names) = "$pond_name_prefix-1 $pond_name_prefix-2 $pond_name_prefix-3"
@test "pond unload: got pond paths in events" (echo $event_pond_paths) = "$pond_home/$pond_name_prefix-1 $pond_home/$pond_name_prefix-2 $pond_home/$pond_name_prefix-3"
__pond_tear_down
__pond_event_reset

@echo "pond unload: output tests for multiple ponds"
__pond_setup 3 enabled unpopulated
@test "pond unload: success output message" (pond unload $pond_name_prefix-1 $pond_name_prefix-2 $pond_name_prefix-3 2>&1 | string collect) = $success_output_multiple_ponds
__pond_tear_down
__pond_event_reset

@echo "pond unload: validation failure exit code tests"
@test "pond unload: fails for missing pond name" (pond unload >/dev/null 2>&1) $status -eq $failure
@test "pond unload: fails for malformed pond name" (pond unload _invalid >/dev/null 2>&1) $status -eq $failure
@test "pond unload: fails for non-existent pond" (pond unload no-exist >/dev/null 2>&1) $status -eq $failure

@echo "pond unload: validation failure output tests"
@test "pond unload: command usage shown for missing pond name" (pond unload 2>&1 | string collect) = $command_usage
@test "pond unload: command usage shown for malformed pond name" (pond unload _invalid 2>&1 | string collect) = $command_usage
@test "pond unload: command error shown for non-existent pond" (pond unload no-exist 2>&1 | string collect) = $not_exists_error
