source ./helpers/functions.fish
source ./helpers/variables.fish

set command_usage "\
Usage:
    pond load ponds...

Arguments:
    ponds  The name of one or more ponds to load"

set success_output_single_regular "\
Loaded pond: $pond_name_regular"

set success_output_single_private "\
Loaded private pond: $pond_name_private"

set success_output_multiple_regular "\
Loaded pond: $pond_name_regular_prefix-1
Loaded pond: $pond_name_regular_prefix-2
Loaded pond: $pond_name_regular_prefix-3"

set success_output_multiple_private "\
Loaded private pond: $pond_name_private_prefix-1
Loaded private pond: $pond_name_private_prefix-2
Loaded private pond: $pond_name_private_prefix-3"

function __pond_loaded_event_intercept --on-event pond_loaded -a got_pond_name got_pond_path
    set -ga event_pond_names $got_pond_name
    set -ga event_pond_paths $got_pond_path
end

@echo "pond load: success tests for regular pond"
__pond_setup 1 regular enabled populated
@test "setup: pond variables exist" -n (read < $pond_home/$pond_regular/$pond_name_regular/$pond_vars)
@test "pond load: success exit code" (pond load $pond_name_regular >/dev/null 2>&1) $status -eq $success
@test "pond load: test variable one was set" (echo $TEST_POND_1_VAR_1) = "test_pond_1_var_1"
@test "pond load: test variable two was set" (echo $TEST_POND_1_VAR_2) = "test_pond_1_var_2"
@test "pond load: test variable three was set" (echo $TEST_POND_1_VAR_3) = "test_pond_1_var_3"
@test "pond load: got pond name in event" (echo $event_pond_names) = $pond_name_regular
@test "pond load: got pond path in event" (echo $event_pond_paths) = $pond_home/$pond_regular/$pond_name_regular
__pond_tear_down
__pond_event_reset

@echo "pond load: output tests for regular pond"
__pond_setup 1 regular enabled populated
@test "pond load: success output message" (pond load $pond_name_regular 2>&1) = $success_output_single_regular
__pond_tear_down
__pond_event_reset

@echo "pond load: success tests for private pond"
__pond_setup 1 private enabled populated
@test "setup: pond variables exist" -n (read < $pond_home/$pond_private/$pond_name_private/$pond_vars)
@test "pond load: success exit code" (pond load $pond_name_private >/dev/null 2>&1) $status -eq $success
@test "pond load: test variable one was set" (echo $TEST_POND_PRIVATE_1_VAR_1) = "test_pond_private_1_var_1"
@test "pond load: test variable two was set" (echo $TEST_POND_PRIVATE_1_VAR_2) = "test_pond_private_1_var_2"
@test "pond load: test variable three was set" (echo $TEST_POND_PRIVATE_1_VAR_3) = "test_pond_private_1_var_3"
@test "pond load: got pond name in event" (echo $event_pond_names) = $pond_name_private
@test "pond load: got pond path in event" (echo $event_pond_paths) = $pond_home/$pond_private/$pond_name_private
__pond_tear_down
__pond_event_reset

@echo "pond load: output tests for private pond"
__pond_setup 1 private enabled populated
@test "pond load: success output message" (pond load $pond_name_private 2>&1) = $success_output_single_private
__pond_tear_down
__pond_event_reset

@echo "pond load: success tests for multiple regular ponds"
__pond_setup 3 regular enabled populated
@test "setup: $pond_name_regular_prefix-1 variables exist" -n (read < $pond_home/$pond_regular/$pond_name_regular_prefix-1/$pond_vars)
@test "setup: $pond_name_regular_prefix-2 variables exist" -n (read < $pond_home/$pond_regular/$pond_name_regular_prefix-2/$pond_vars)
@test "setup: $pond_name_regular_prefix-3 variables exist" -n (read < $pond_home/$pond_regular/$pond_name_regular_prefix-3/$pond_vars)
@test "pond load: success exit code" (pond load $pond_name_regular_prefix-1 $pond_name_regular_prefix-2 $pond_name_regular_prefix-3 >/dev/null 2>&1) $status -eq $success
@test "pond load: $pond_name_regular_prefix-1 variable one was set" (echo $TEST_POND_1_VAR_1) = "test_pond_1_var_1"
@test "pond load: $pond_name_regular_prefix-1 variable two was set" (echo $TEST_POND_1_VAR_2) = "test_pond_1_var_2"
@test "pond load: $pond_name_regular_prefix-1 variable three was set" (echo $TEST_POND_1_VAR_3) = "test_pond_1_var_3"
@test "pond load: $pond_name_regular_prefix-2 variable one was set" (echo $TEST_POND_2_VAR_1) = "test_pond_2_var_1"
@test "pond load: $pond_name_regular_prefix-2 variable two was set" (echo $TEST_POND_2_VAR_2) = "test_pond_2_var_2"
@test "pond load: $pond_name_regular_prefix-2 variable three was set" (echo $TEST_POND_2_VAR_3) = "test_pond_2_var_3"
@test "pond load: $pond_name_regular_prefix-3 variable one was set" (echo $TEST_POND_3_VAR_1) = "test_pond_3_var_1"
@test "pond load: $pond_name_regular_prefix-3 variable two was set" (echo $TEST_POND_3_VAR_2) = "test_pond_3_var_2"
@test "pond load: $pond_name_regular_prefix-3 variable three was set" (echo $TEST_POND_3_VAR_3) = "test_pond_3_var_3"
@test "pond load: got pond names in events" (echo $event_pond_names) = "$pond_name_regular_prefix-1 $pond_name_regular_prefix-2 $pond_name_regular_prefix-3"
@test "pond load: got pond paths in events" (echo $event_pond_paths) = "$pond_home/$pond_regular/$pond_name_regular_prefix-1 $pond_home/$pond_regular/$pond_name_regular_prefix-2 $pond_home/$pond_regular/$pond_name_regular_prefix-3"
__pond_tear_down
__pond_event_reset

@echo "pond load: output tests for multiple regular ponds"
__pond_setup 3 regular enabled populated
@test "pond load: success output message" (pond load $pond_name_regular_prefix-1 $pond_name_regular_prefix-2 $pond_name_regular_prefix-3 2>&1 | string collect) = $success_output_multiple_regular
__pond_tear_down
__pond_event_reset

@echo "pond load: success tests for multiple private ponds"
__pond_setup 3 private enabled populated
@test "setup: $pond_name_private_prefix-1 variables exist" -n (read < $pond_home/$pond_private/$pond_name_private_prefix-1/$pond_vars)
@test "setup: $pond_name_private_prefix-2 variables exist" -n (read < $pond_home/$pond_private/$pond_name_private_prefix-2/$pond_vars)
@test "setup: $pond_name_private_prefix-3 variables exist" -n (read < $pond_home/$pond_private/$pond_name_private_prefix-3/$pond_vars)
@test "pond load: success exit code" (pond load $pond_name_private_prefix-1 $pond_name_private_prefix-2 $pond_name_private_prefix-3 >/dev/null 2>&1) $status -eq $success
@test "pond load: $pond_name_private_prefix-1 variable one was set" (echo $TEST_POND_PRIVATE_1_VAR_1) = "test_pond_private_1_var_1"
@test "pond load: $pond_name_private_prefix-1 variable two was set" (echo $TEST_POND_PRIVATE_1_VAR_2) = "test_pond_private_1_var_2"
@test "pond load: $pond_name_private_prefix-1 variable three was set" (echo $TEST_POND_PRIVATE_1_VAR_3) = "test_pond_private_1_var_3"
@test "pond load: $pond_name_private_prefix-2 variable one was set" (echo $TEST_POND_PRIVATE_2_VAR_1) = "test_pond_private_2_var_1"
@test "pond load: $pond_name_private_prefix-2 variable two was set" (echo $TEST_POND_PRIVATE_2_VAR_2) = "test_pond_private_2_var_2"
@test "pond load: $pond_name_private_prefix-2 variable three was set" (echo $TEST_POND_PRIVATE_2_VAR_3) = "test_pond_private_2_var_3"
@test "pond load: $pond_name_private_prefix-3 variable one was set" (echo $TEST_POND_PRIVATE_3_VAR_1) = "test_pond_private_3_var_1"
@test "pond load: $pond_name_private_prefix-3 variable two was set" (echo $TEST_POND_PRIVATE_3_VAR_2) = "test_pond_private_3_var_2"
@test "pond load: $pond_name_private_prefix-3 variable three was set" (echo $TEST_POND_PRIVATE_3_VAR_3) = "test_pond_private_3_var_3"
@test "pond load: got pond names in events" (echo $event_pond_names) = "$pond_name_private_prefix-1 $pond_name_private_prefix-2 $pond_name_private_prefix-3"
@test "pond load: got pond paths in events" (echo $event_pond_paths) = "$pond_home/$pond_private/$pond_name_private_prefix-1 $pond_home/$pond_private/$pond_name_private_prefix-2 $pond_home/$pond_private/$pond_name_private_prefix-3"
__pond_tear_down
__pond_event_reset

@echo "pond load: output tests for multiple private ponds"
__pond_setup 3 private enabled populated
@test "pond load: success output message" (pond load $pond_name_private_prefix-1 $pond_name_private_prefix-2 $pond_name_private_prefix-3 2>&1 | string collect) = $success_output_multiple_private
__pond_tear_down
__pond_event_reset

@echo "pond load: validation failure exit code tests"
@test "pond load: fails for missing pond name" (pond load >/dev/null 2>&1) $status -eq $fail
@test "pond load: fails for malformed pond name" (pond load _invalid >/dev/null 2>&1) $status -eq $fail
@test "pond load: fails for non-existent pond" (pond load no-exist >/dev/null 2>&1) $status -eq $fail

@echo "pond load: validation failure output tests"
@test "pond load: command usage shown for missing pond name" (pond load 2>&1 | string collect) = $command_usage
@test "pond load: command usage shown for malformed pond name" (pond load _invalid 2>&1 | string collect) = $command_usage
@test "pond load: command error shown for non-existent pond" (pond load no-exist 2>&1 | string collect) = "Pond does not exist: no-exist"
