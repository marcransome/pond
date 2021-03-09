source ./helpers/functions.fish
source ./helpers/variables.fish

set verbose_output_regular_pond "\
Erased variable: TEST_VAR_1
Erased variable: TEST_VAR_2
Erased variable: TEST_VAR_3
Unloaded pond: $pond_name_regular"

set verbose_output_private_pond "\
Erased variable: TEST_VAR_PRIVATE_1
Erased variable: TEST_VAR_PRIVATE_2
Erased variable: TEST_VAR_PRIVATE_3
Unloaded private pond: $pond_name_private"

set command_usage "\
Usage:
    pond unload [options] <name>

Options:
    -v, --verbose  Output variable names during unload

Arguments:
    name  The name of the pond to unload"

function __pond_unloaded_event_intercept --on-event pond_unloaded -a got_pond_name got_pond_path
    set -g event_pond_name $got_pond_name
    set -g event_pond_path $got_pond_path
end

@echo "pond unload: success tests for regular pond"
__pond_setup 1 regular enabled populated
__pond_load_vars 1 regular
@test "setup: test variable one is set" (echo $TEST_VAR_1) = "test_var_1"
@test "setup: test variable two is set" (echo $TEST_VAR_2) = "test_var_2"
@test "setup: test variable three is set" (echo $TEST_VAR_3) = "test_var_3"
@test "pond unload: success exit code" (pond unload $pond_name_regular >/dev/null 2>&1) $status -eq $success
@test "pond unload: test variable one was erased" (set -q TEST_VAR_1) $status -eq 1
@test "pond unload: test variable two was erased" (set -q TEST_VAR_2) $status -eq 1
@test "pond unload: test variable three was erased" (set -q TEST_VAR_3) $status -eq 1
@test "pond unload: got pond name in event" (echo $event_pond_name) = $pond_name_regular
@test "pond unload: got pond path in event" (echo $event_pond_path) = $pond_home/$pond_regular/$pond_name_regular
__pond_tear_down
__pond_event_reset

@echo "pond unload: output tests for regular pond"
__pond_setup 1 regular enabled populated
__pond_load_vars 1 regular
@test "pond unload: success output message" (pond unload $pond_name_regular 2>&1) = "Unloaded pond: $pond_name_regular"
__pond_tear_down
__pond_event_reset

for command in "pond unload "{-v,--verbose}" $pond_name_regular"
    @echo "$command: verbose output tests for regular pond"
    __pond_setup 1 regular enabled populated
    __pond_load_vars 1 regular
    @test "pond unload: success output message" (eval $command 2>&1 | string collect) = $verbose_output_regular_pond
    __pond_tear_down
    __pond_event_reset
end

@echo "pond unload: success tests for private pond"
__pond_setup 1 private enabled populated
__pond_load_vars 1 private
@test "setup: test variable one is set" (echo $TEST_VAR_PRIVATE_1) = "test_var_private_1"
@test "setup: test variable two is set" (echo $TEST_VAR_PRIVATE_2) = "test_var_private_2"
@test "setup: test variable three is set" (echo $TEST_VAR_PRIVATE_3) = "test_var_private_3"
@test "pond unload: success exit code" (pond unload $pond_name_private >/dev/null 2>&1) $status -eq $success
@test "pond unload: test variable one was erased" (set -q TEST_VAR_1) $status -eq 1
@test "pond unload: test variable two was erased" (set -q TEST_VAR_2) $status -eq 1
@test "pond unload: test variable three was erased" (set -q TEST_VAR_3) $status -eq 1
@test "pond unload: got pond name in event" (echo $event_pond_name) = $pond_name_private
@test "pond unload: got pond path in event" (echo $event_pond_path) = $pond_home/$pond_private/$pond_name_private
__pond_tear_down
__pond_event_reset

@echo "pond unload: output tests for private pond"
__pond_setup 1 private enabled populated
__pond_load_vars 1 private
@test "pond unload: success output message" (pond unload $pond_name_private 2>&1) = "Unloaded private pond: $pond_name_private"
__pond_tear_down
__pond_event_reset

for command in "pond unload "{-v,--verbose}" $pond_name_private"
    @echo "$command: verbose output tests for private pond"
    __pond_setup 1 private enabled populated
    __pond_load_vars 1 private
    @test "pond unload: success output message" (eval $command 2>&1 | string collect) = $verbose_output_private_pond
    __pond_tear_down
    __pond_event_reset
end

@echo "pond unload: validation failure exit code tests"
@test "pond unload: fails for missing pond name" (pond unload >/dev/null 2>&1) $status -eq $fail
@test "pond unload: fails for trailing arguments" (pond unload $pond_name_regular trailing >/dev/null 2>&1) $status -eq $fail
@test "pond unload: fails for malformed pond name" (pond unload _invalid >/dev/null 2>&1) $status -eq $fail
@test "pond unload: fails for non-existent pond" (pond unload no-exist >/dev/null 2>&1) $status -eq $fail

for valid_option in -v --verbose
    @test "pond unload: fails for valid option $valid_option and missing pond name" (pond unload $valid_option >/dev/null 2>&1) $status -eq $fail
    @test "pond unload: fails for valid option $valid_option and invalid pond name" (pond unload $valid_option _invalid >/dev/null 2>&1) $status -eq $fail
end

for invalid_option in -i --invalid
    @test "pond unload: fails for invalid option $invalid_option and valid pond name" (pond unload $invalid_option $pond_name >/dev/null 2>&1) $status -eq $fail
    @test "pond unload: fails for invalid option $invalid_option and invalid pond name" (pond unload $invalid_option _invalid >/dev/null 2>&1) $status -eq $fail
end

@echo "pond unload: validation failure output tests"
@test "pond unload: command usage shown for missing pond name" (pond unload 2>&1 | string collect) = $command_usage
@test "pond unload: command usage shown for trailing arguments" (pond unload $pond_name_regular trailing 2>&1 | string collect) = $command_usage
@test "pond unload: command usage shown for malformed pond name" (pond unload _invalid 2>&1 | string collect) = $command_usage
@test "pond unload: command error shown for non-existent pond" (pond unload no-exist 2>&1 | string collect) = "Pond does not exist: no-exist"

for valid_option in -v --verbose
    @test "pond unload: command usage shown for valid option $valid_option and missing pond name" (pond unload $valid_option 2>&1 | string collect) = $command_usage
    @test "pond unload: command usage shown for valid option $valid_option and invalid pond name" (pond unload $valid_option _invalid 2>&1 | string collect) = $command_usage
end

for invalid_option in -i --invalid
    @test "pond unload: command usage shown for invalid option $invalid_option and valid pond name" (pond unload $invalid_option $pond_name 2>&1 | string collect) = $command_usage
    @test "pond unload: command usage shown for invalid option $invalid_option and invalid pond name" (pond unload $invalid_option _invalid 2>&1 | string collect) = $command_usage
end
