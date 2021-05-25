source ./helpers/functions.fish
source ./helpers/variables.fish

set pond_enable_on_create_before_test $pond_enable_on_create

set command_usage "\
Usage:
    pond disable ponds...

Arguments:
    ponds  The name of one or more ponds to disable"

set success_output_single_regular "\
Disabled pond: $pond_name_regular"

set success_output_single_private "\
Disabled private pond: $pond_name_private"

set success_output_multiple_regular "\
Disabled pond: $pond_name_regular_prefix-1
Disabled pond: $pond_name_regular_prefix-2
Disabled pond: $pond_name_regular_prefix-3"

set success_output_multiple_private "\
Disabled private pond: $pond_name_private_prefix-1
Disabled private pond: $pond_name_private_prefix-2
Disabled private pond: $pond_name_private_prefix-3"

function __pond_disabled_event_intercept --on-event pond_disabled -a got_pond_name got_pond_path
    set -ga event_pond_names $got_pond_name
    set -ga event_pond_paths $got_pond_path
end

@echo "pond disable: success tests for regular pond"
__pond_setup 1 regular enabled unpopulated
@test "setup: pond enabled" (contains $pond_home/$pond_regular/$pond_name_regular $pond_function_path) $status -eq $success
@test "pond disable: success exit code" (pond disable $pond_name_regular >/dev/null 2>&1) $status -eq $success
@test "pond disable: pond function path removed" (not contains $pond_home/$pond_regular/$pond_name_regular $pond_function_path) $status -eq $success
@test "pond disable: got pond name in event" (echo $event_pond_names) = $pond_name_regular
@test "pond disable: got pond path in event" (echo $event_pond_paths) = $pond_home/$pond_regular/$pond_name_regular
__pond_tear_down
__pond_event_reset

@echo "pond disable: output tests for regular pond"
__pond_setup 1 regular enabled unpopulated
@test "pond disable: success output message" (pond disable $pond_name_regular 2>&1) = $success_output_single_regular
__pond_tear_down
__pond_event_reset

@echo "pond disable: success tests for private pond"
__pond_setup 1 private enabled unpopulated
@test "setup: pond enabled" (contains $pond_home/$pond_private/$pond_name_private $pond_function_path) $status -eq $success
@test "pond disable: success exit code" (pond disable $pond_name_private >/dev/null 2>&1) $status -eq $success
@test "pond disable: pond function path removed" (not contains $pond_home/$pond_private/$pond_name_private $pond_function_path) $status -eq $success
@test "pond disable: got pond name in event" (echo $event_pond_names) = $pond_name_private
@test "pond disable: got pond path in event" (echo $event_pond_paths) = $pond_home/$pond_private/$pond_name_private
__pond_tear_down
__pond_event_reset

@echo "pond disable: output tests for private pond"
__pond_setup 1 private enabled unpopulated
@test "pond disable: success output message" (pond disable $pond_name_private 2>&1) = $success_output_single_private
__pond_tear_down
__pond_event_reset

@echo "pond disable: success tests for multiple regular ponds"
__pond_setup 3 regular enabled unpopulated
@test "setup: pond enabled" (contains $pond_home/$pond_regular/$pond_name_regular_prefix-1 $pond_function_path) $status -eq $success
@test "setup: pond enabled" (contains $pond_home/$pond_regular/$pond_name_regular_prefix-2 $pond_function_path) $status -eq $success
@test "setup: pond enabled" (contains $pond_home/$pond_regular/$pond_name_regular_prefix-3 $pond_function_path) $status -eq $success
@test "pond disable: success exit code" (pond disable $pond_name_regular_prefix-1 $pond_name_regular_prefix-2 $pond_name_regular_prefix-3 >/dev/null 2>&1) $status -eq $success
@test "pond disable: pond function path removed" (not contains $pond_home/$pond_regular/$pond_name_regular_prefix-1 $pond_function_path) $status -eq $success
@test "pond disable: pond function path removed" (not contains $pond_home/$pond_regular/$pond_name_regular_prefix-2 $pond_function_path) $status -eq $success
@test "pond disable: pond function path removed" (not contains $pond_home/$pond_regular/$pond_name_regular_prefix-3 $pond_function_path) $status -eq $success
@test "pond disable: got pond names in events" (echo $event_pond_names) = "$pond_name_regular_prefix-1 $pond_name_regular_prefix-2 $pond_name_regular_prefix-3"
@test "pond disable: got pond paths in events" (echo $event_pond_paths) = "$pond_home/$pond_regular/$pond_name_regular_prefix-1 $pond_home/$pond_regular/$pond_name_regular_prefix-2 $pond_home/$pond_regular/$pond_name_regular_prefix-3"
__pond_tear_down
__pond_event_reset

@echo "pond disable: output tests for multiple regular ponds"
__pond_setup 3 regular enabled unpopulated
@test "pond disable: success output message" (pond disable $pond_name_regular_prefix-1 $pond_name_regular_prefix-2 $pond_name_regular_prefix-3 2>&1 | string collect) = $success_output_multiple_regular
__pond_tear_down
__pond_event_reset

@echo "pond disable: success tests for multiple private ponds"
__pond_setup 3 private enabled unpopulated
@test "setup: pond enabled" (contains $pond_home/$pond_private/$pond_name_private_prefix-1 $pond_function_path) $status -eq $success
@test "setup: pond enabled" (contains $pond_home/$pond_private/$pond_name_private_prefix-2 $pond_function_path) $status -eq $success
@test "setup: pond enabled" (contains $pond_home/$pond_private/$pond_name_private_prefix-3 $pond_function_path) $status -eq $success
@test "pond disable: success exit code" (pond disable $pond_name_private_prefix-1 $pond_name_private_prefix-2 $pond_name_private_prefix-3 >/dev/null 2>&1) $status -eq $success
@test "pond disable: pond function path removed" (not contains $pond_home/$pond_private/$pond_name_private_prefix-1 $pond_function_path) $status -eq $success
@test "pond disable: pond function path removed" (not contains $pond_home/$pond_private/$pond_name_private_prefix-2 $pond_function_path) $status -eq $success
@test "pond disable: pond function path removed" (not contains $pond_home/$pond_private/$pond_name_private_prefix-3 $pond_function_path) $status -eq $success
@test "pond disable: got pond names in events" (echo $event_pond_names) = "$pond_name_private_prefix-1 $pond_name_private_prefix-2 $pond_name_private_prefix-3"
@test "pond disable: got pond paths in events" (echo $event_pond_paths) = "$pond_home/$pond_private/$pond_name_private_prefix-1 $pond_home/$pond_private/$pond_name_private_prefix-2 $pond_home/$pond_private/$pond_name_private_prefix-3"
__pond_tear_down
__pond_event_reset

@echo "pond disable: output tests for multiple private ponds"
__pond_setup 3 private enabled unpopulated
@test "pond disable: success output message" (pond disable $pond_name_private_prefix-1 $pond_name_private_prefix-2 $pond_name_private_prefix-3 2>&1 | string collect) = $success_output_multiple_private
__pond_tear_down
__pond_event_reset

@echo "pond disable: failure tests for regular disabled pond"
__pond_setup 1 regular disabled unpopulated
@test "setup: pond disabled" (not contains $pond_home/$pond_regular/$pond_name_regular $pond_function_path) $status -eq $success
@test "pond disable: command error shown for regular disabled pond" (pond disable $pond_name_regular 2>&1 | string collect) = "Pond already disabled: $pond_name_regular"
__pond_tear_down

@echo "pond disable: failure tests for multiple regular disabled ponds"
__pond_setup 3 regular disabled unpopulated
@test "setup: pond disabled" (not contains $pond_home/$pond_regular/$pond_name_regular_prefix-1 $pond_function_path) $status -eq $success
@test "setup: pond disabled" (not contains $pond_home/$pond_regular/$pond_name_regular_prefix-2 $pond_function_path) $status -eq $success
@test "setup: pond disabled" (not contains $pond_home/$pond_regular/$pond_name_regular_prefix-3 $pond_function_path) $status -eq $success
@test "pond disable: command error shown for regular disabled pond" (pond disable $pond_name_regular_prefix-1 $pond_name_regular_prefix-2 $pond_name_regular_prefix-3 2>&1 | string collect) = "Pond already disabled: $pond_name_regular_prefix-1"
__pond_tear_down

@echo "pond disable: failure tests for private disabled pond"
__pond_setup 1 private disabled unpopulated
@test "setup: pond disabled" (not contains $pond_home/$pond_private/$pond_name_private $pond_function_path) $status -eq $success
@test "pond disable: command error shown for private disabled pond" (pond disable $pond_name_private 2>&1 | string collect) = "Pond already disabled: $pond_name_private"
__pond_tear_down

@echo "pond disable: failure tests for multiple private disabled ponds"
__pond_setup 1 private disabled unpopulated
@test "setup: pond disabled" (not contains $pond_home/$pond_private/$pond_name_private_prefix-1 $pond_function_path) $status -eq $success
@test "setup: pond disabled" (not contains $pond_home/$pond_private/$pond_name_private_prefix-2 $pond_function_path) $status -eq $success
@test "setup: pond disabled" (not contains $pond_home/$pond_private/$pond_name_private_prefix-3 $pond_function_path) $status -eq $success
@test "pond disable: command error shown for private disabled pond" (pond disable $pond_name_private_prefix-1 $pond_name_private_prefix-2 $pond_name_private_prefix-3 2>&1 | string collect) = "Pond already disabled: $pond_name_private_prefix-1"
__pond_tear_down

@echo "pond disable: validation failure exit code tests"
@test "pond disable: fails for missing pond name" (pond disable >/dev/null 2>&1) $status -eq $fail
@test "pond disable: fails for malformed pond name" (pond disable _invalid >/dev/null 2>&1) $status -eq $fail
@test "pond disable: fails for non-existent pond" (pond disable no-exist >/dev/null 2>&1) $status -eq $fail

@echo "pond disable: validation failure output tests"
@test "pond disable: command usage shown for missing pond name" (pond disable 2>&1 | string collect) = $command_usage
@test "pond disable: command usage shown for malformed pond name" (pond disable _invalid 2>&1 | string collect) = $command_usage
@test "pond disable: command error shown for non-existent pond" (pond disable no-exist 2>&1 | string collect) = "Pond does not exist: no-exist"

set pond_enable_on_create $pond_enable_on_create_before_test
