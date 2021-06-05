source ./fixtures/functions.fish
source ./fixtures/variables.fish

set command_usage "\
Usage:
    pond disable ponds...

Arguments:
    ponds  The name of one or more ponds to disable"

set success_output_single_pond "\
Disabled pond: $pond_name"

set success_output_multiple_ponds "\
Disabled pond: $pond_name_prefix-1
Disabled pond: $pond_name_prefix-2
Disabled pond: $pond_name_prefix-3"

set already_disabled_error (__pond_error_string "Pond already disabled: $pond_name")
set not_exists_error (__pond_error_string "Pond does not exist: no-exist")

function __pond_disabled_event_intercept --on-event pond_disabled -a got_pond_name got_pond_path
    set -ga event_pond_names $got_pond_name
    set -ga event_pond_paths $got_pond_path
end

@echo "pond disable: success tests for single pond"
__pond_setup 1 enabled unpopulated
@test "setup: pond enabled" (contains $pond_home/$pond_name $pond_function_path) $status -eq $success
@test "pond disable: success exit code" (pond disable $pond_name >/dev/null 2>&1) $status -eq $success
@test "pond disable: pond function path removed" (not contains $pond_home/$pond_name $pond_function_path) $status -eq $success
@test "pond disable: got pond name in event" (echo $event_pond_names) = $pond_name
@test "pond disable: got pond path in event" (echo $event_pond_paths) = $pond_home/$pond_name
__pond_tear_down
__pond_event_reset

@echo "pond disable: output tests for single pond"
__pond_setup 1 enabled unpopulated
@test "pond disable: success output message" (pond disable $pond_name 2>&1) = $success_output_single_pond
__pond_tear_down
__pond_event_reset

@echo "pond disable: success tests for multiple ponds"
__pond_setup 3 enabled unpopulated
@test "setup: pond enabled" (contains $pond_home/$pond_name_prefix-1 $pond_function_path) $status -eq $success
@test "setup: pond enabled" (contains $pond_home/$pond_name_prefix-2 $pond_function_path) $status -eq $success
@test "setup: pond enabled" (contains $pond_home/$pond_name_prefix-3 $pond_function_path) $status -eq $success
@test "pond disable: success exit code" (pond disable $pond_name_prefix-1 $pond_name_prefix-2 $pond_name_prefix-3 >/dev/null 2>&1) $status -eq $success
@test "pond disable: pond function path removed" (not contains $pond_home/$pond_name_prefix-1 $pond_function_path) $status -eq $success
@test "pond disable: pond function path removed" (not contains $pond_home/$pond_name_prefix-2 $pond_function_path) $status -eq $success
@test "pond disable: pond function path removed" (not contains $pond_home/$pond_name_prefix-3 $pond_function_path) $status -eq $success
@test "pond disable: got pond names in events" (echo $event_pond_names) = "$pond_name_prefix-1 $pond_name_prefix-2 $pond_name_prefix-3"
@test "pond disable: got pond paths in events" (echo $event_pond_paths) = "$pond_home/$pond_name_prefix-1 $pond_home/$pond_name_prefix-2 $pond_home/$pond_name_prefix-3"
__pond_tear_down
__pond_event_reset

@echo "pond disable: output tests for multiple ponds"
__pond_setup 3 enabled unpopulated
@test "pond disable: success output message" (pond disable $pond_name_prefix-1 $pond_name_prefix-2 $pond_name_prefix-3 2>&1 | string collect) = $success_output_multiple_ponds
__pond_tear_down
__pond_event_reset

@echo "pond disable: failure tests for single disabled pond"
__pond_setup 1 disabled unpopulated
@test "setup: pond disabled" (not contains $pond_home/$pond_name $pond_function_path) $status -eq $success
@test "pond disable: command error shown for disabled pond" (pond disable $pond_name 2>&1 | string collect) = $already_disabled_error
__pond_tear_down

@echo "pond disable: failure tests for multiple disabled ponds"
__pond_setup 3 disabled unpopulated
@test "setup: pond disabled" (not contains $pond_home/$pond_name_prefix-1 $pond_function_path) $status -eq $success
@test "setup: pond disabled" (not contains $pond_home/$pond_name_prefix-2 $pond_function_path) $status -eq $success
@test "setup: pond disabled" (not contains $pond_home/$pond_name_prefix-3 $pond_function_path) $status -eq $success
@test "pond disable: command error shown for disabled pond" (pond disable $pond_name_prefix-1 $pond_name_prefix-2 $pond_name_prefix-3 2>&1 | string collect) = $already_disabled_error
__pond_tear_down

@echo "pond disable: validation failure exit code tests"
@test "pond disable: fails for missing pond name" (pond disable >/dev/null 2>&1) $status -eq $failure
@test "pond disable: fails for malformed pond name" (pond disable _invalid >/dev/null 2>&1) $status -eq $failure
@test "pond disable: fails for non-existent pond" (pond disable no-exist >/dev/null 2>&1) $status -eq $failure

@echo "pond disable: validation failure output tests"
@test "pond disable: command usage shown for missing pond name" (pond disable 2>&1 | string collect) = $command_usage
@test "pond disable: command usage shown for malformed pond name" (pond disable _invalid 2>&1 | string collect) = $command_usage
@test "pond disable: command error shown for non-existent pond" (pond disable no-exist 2>&1 | string collect) = $not_exists_error
