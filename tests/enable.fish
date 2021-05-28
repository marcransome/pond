source ./fixtures/functions.fish
source ./fixtures/variables.fish

set command_usage "\
Usage:
    pond enable ponds...

Arguments:
    ponds  The name of one or more ponds to enable"

set success_output_single_pond "\
Enabled pond: $pond_name"

set success_output_multiple_ponds "\
Enabled pond: $pond_name_prefix-1
Enabled pond: $pond_name_prefix-2
Enabled pond: $pond_name_prefix-3"

function __pond_enabled_event_intercept --on-event pond_enabled -a got_pond_name got_pond_path
    set -ga event_pond_names $got_pond_name
    set -ga event_pond_paths $got_pond_path
end

@echo "pond enable: success tests for single pond"
__pond_setup 1 disabled unpopulated
@test "setup: pond disabled" (not contains $pond_home/$pond_name $pond_function_path) $status -eq $success
@test "pond enable: success exit code" (pond enable $pond_name >/dev/null 2>&1) $status -eq $success
@test "pond enable: pond function path created" (contains $pond_home/$pond_name $pond_function_path) $status -eq $success
@test "pond enable: got pond name in event" (echo $event_pond_names) = $pond_name
@test "pond enable: got pond path in event" (echo $event_pond_paths) = $pond_home/$pond_name
__pond_tear_down
__pond_event_reset

@echo "pond enable: output tests for single pond"
__pond_setup 1 disabled unpopulated
@test "pond enable: success output message" (pond enable $pond_name 2>&1) = $success_output_single_pond
__pond_tear_down
__pond_event_reset

@echo "pond enable: success tests for multiple ponds"
__pond_setup 3 disabled unpopulated
@test "setup: pond disabled" (not contains $pond_home/$pond_name_prefix-1 $pond_function_path) $status -eq $success
@test "setup: pond disabled" (not contains $pond_home/$pond_name_prefix-2 $pond_function_path) $status -eq $success
@test "setup: pond disabled" (not contains $pond_home/$pond_name_prefix-3 $pond_function_path) $status -eq $success
@test "pond enable: success exit code" (pond enable $pond_name_prefix-1 $pond_name_prefix-2 $pond_name_prefix-3 >/dev/null 2>&1) $status -eq $success
@test "pond enable: pond function path created" (contains $pond_home/$pond_name_prefix-1 $pond_function_path) $status -eq $success
@test "pond enable: pond function path created" (contains $pond_home/$pond_name_prefix-2 $pond_function_path) $status -eq $success
@test "pond enable: pond function path created" (contains $pond_home/$pond_name_prefix-3 $pond_function_path) $status -eq $success
@test "pond enable: got pond names in events" (echo $event_pond_names) = "$pond_name_prefix-1 $pond_name_prefix-2 $pond_name_prefix-3"
@test "pond enable: got pond paths in events" (echo $event_pond_paths) = "$pond_home/$pond_name_prefix-1 $pond_home/$pond_name_prefix-2 $pond_home/$pond_name_prefix-3"
__pond_tear_down
__pond_event_reset

@echo "pond enable: output tests for multiple ponds"
__pond_setup 3 disabled unpopulated
@test "pond enable: success output message" (pond enable $pond_name_prefix-1 $pond_name_prefix-2 $pond_name_prefix-3 2>&1 | string collect) = $success_output_multiple_ponds
__pond_tear_down
__pond_event_reset

@echo "pond enable: failure tests for single enabled pond"
__pond_setup 1 enabled unpopulated
@test "setup: pond enabled" (contains $pond_home/$pond_name $pond_function_path) $status -eq $success
@test "pond enable: command error shown for enabled pond" (pond enable $pond_name 2>&1 | string collect) = "Pond already enabled: $pond_name"
__pond_tear_down

@echo "pond enable: failure tests for multiple enabled ponds"
__pond_setup 3 enabled unpopulated
@test "setup: pond enabled" (contains $pond_home/$pond_name_prefix-1 $pond_function_path) $status -eq $success
@test "setup: pond enabled" (contains $pond_home/$pond_name_prefix-2 $pond_function_path) $status -eq $success
@test "setup: pond enabled" (contains $pond_home/$pond_name_prefix-3 $pond_function_path) $status -eq $success
@test "pond enable: command error shown for enabled pond" (pond enable $pond_name_prefix-1 $pond_name_prefix-2 $pond_name_prefix-3 2>&1 | string collect) = "Pond already enabled: $pond_name_prefix-1"
__pond_tear_down

@echo "pond enable: validation failure exit code tests"
@test "pond enable: fails for missing pond name" (pond enable >/dev/null 2>&1) $status -eq $fail
@test "pond enable: fails for malformed pond name" (pond enable _invalid >/dev/null 2>&1) $status -eq $fail
@test "pond enable: fails for non-existent pond" (pond enable no-exist >/dev/null 2>&1) $status -eq $fail

@echo "pond enable: validation failure output tests"
@test "pond enable: command usage shown for missing pond name" (pond enable 2>&1 | string collect) = $command_usage
@test "pond enable: command usage shown for malformed pond name" (pond enable _invalid 2>&1 | string collect) = $command_usage
@test "pond enable: command error shown for non-existent pond" (pond enable no-exist 2>&1 | string collect) = "Pond does not exist: no-exist"
