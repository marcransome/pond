source ./helpers/functions.fish
source ./helpers/variables.fish

set command_usage "\
Usage:
    pond load <name>

Arguments:
    name  The name of the pond to load"

function __pond_loaded_event_intercept --on-event pond_loaded -a got_pond_name got_pond_path
    set -g event_pond_name $got_pond_name
    set -g event_pond_path $got_pond_path
end

@echo "pond load: success tests for regular pond"
__pond_setup 1 regular enabled populated
@test "setup: pond variables exist" -n (read < $pond_home/$pond_regular/$pond_name_regular/$pond_vars)
@test "pond load: success exit code" (pond load $pond_name_regular >/dev/null 2>&1) $status -eq $success
@test "pond load: test variable one was set" (echo $TEST_VAR_1) = "test_var_1"
@test "pond load: test variable two was set" (echo $TEST_VAR_2) = "test_var_2"
@test "pond load: test variable three was set" (echo $TEST_VAR_3) = "test_var_3"
@test "pond load: got pond name in event" (echo $event_pond_name) = $pond_name_regular
@test "pond load: got pond path in event" (echo $event_pond_path) = $pond_home/$pond_regular/$pond_name_regular
__pond_tear_down
__pond_event_reset

@echo "pond load: output tests for regular pond"
__pond_setup 1 regular enabled populated
@test "pond load: success output message" (pond load $pond_name_regular 2>&1) = "Loaded pond: $pond_name_regular"
__pond_tear_down
__pond_event_reset

@echo "pond load: success tests for private pond"
__pond_setup 1 private enabled populated
@test "setup: pond variables exist" -n (read < $pond_home/$pond_private/$pond_name_private/$pond_vars)
@test "pond load: success exit code" (pond load $pond_name_private >/dev/null 2>&1) $status -eq $success
@test "pond load: test variable one was set" (echo $TEST_VAR_PRIVATE_1) = "test_var_private_1"
@test "pond load: test variable two was set" (echo $TEST_VAR_PRIVATE_2) = "test_var_private_2"
@test "pond load: test variable three was set" (echo $TEST_VAR_PRIVATE_3) = "test_var_private_3"
@test "pond load: got pond name in event" (echo $event_pond_name) = $pond_name_private
@test "pond load: got pond path in event" (echo $event_pond_path) = $pond_home/$pond_private/$pond_name_private
__pond_tear_down
__pond_event_reset

@echo "pond load: output tests for private pond"
__pond_setup 1 private enabled populated
@test "pond load: success output message" (pond load $pond_name_private 2>&1) = "Loaded private pond: $pond_name_private"
__pond_tear_down
__pond_event_reset

@echo "pond load: validation failure exit code tests"
@test "pond load: fails for missing pond name" (pond load >/dev/null 2>&1) $status -eq $fail
@test "pond load: fails for trailing arguments" (pond load $pond_name_regular trailing >/dev/null 2>&1) $status -eq $fail
@test "pond load: fails for malformed pond name" (pond load _invalid >/dev/null 2>&1) $status -eq $fail
@test "pond load: fails for non-existent pond" (pond load no-exist >/dev/null 2>&1) $status -eq $fail

@echo "pond load: validation failure output tests"
@test "pond load: command usage shown for missing pond name" (pond load 2>&1 | string collect) = $command_usage
@test "pond load: command usage shown for trailing arguments" (pond load $pond_name_regular trailing 2>&1 | string collect) = $command_usage
@test "pond load: command usage shown for malformed pond name" (pond load _invalid 2>&1 | string collect) = $command_usage
@test "pond load: command error shown for non-existent pond" (pond load no-exist 2>&1 | string collect) = "Pond does not exist: no-exist"
