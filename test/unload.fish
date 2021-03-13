source ./helpers/functions.fish
source ./helpers/variables.fish

set success_output_single_regular "\
Unloaded pond: $pond_name_regular"

set success_output_verbose_single_regular "\
Erased variable: TEST_POND_1_VAR_1
Erased variable: TEST_POND_1_VAR_2
Erased variable: TEST_POND_1_VAR_3
Unloaded pond: $pond_name_regular"

set success_output_single_private "\
Unloaded private pond: $pond_name_private"

set success_output_verbose_single_private "\
Erased variable: TEST_POND_PRIVATE_1_VAR_1
Erased variable: TEST_POND_PRIVATE_1_VAR_2
Erased variable: TEST_POND_PRIVATE_1_VAR_3
Unloaded private pond: $pond_name_private"

set success_output_multiple_regular "\
Unloaded pond: $pond_name_regular_prefix-1
Unloaded pond: $pond_name_regular_prefix-2
Unloaded pond: $pond_name_regular_prefix-3"

set success_output_verbose_multiple_regular "\
Erased variable: TEST_POND_1_VAR_1
Erased variable: TEST_POND_1_VAR_2
Erased variable: TEST_POND_1_VAR_3
Unloaded pond: $pond_name_regular_prefix-1
Erased variable: TEST_POND_2_VAR_1
Erased variable: TEST_POND_2_VAR_2
Erased variable: TEST_POND_2_VAR_3
Unloaded pond: $pond_name_regular_prefix-2
Erased variable: TEST_POND_3_VAR_1
Erased variable: TEST_POND_3_VAR_2
Erased variable: TEST_POND_3_VAR_3
Unloaded pond: $pond_name_regular_prefix-3"

set success_output_multiple_private "\
Unloaded private pond: $pond_name_private_prefix-1
Unloaded private pond: $pond_name_private_prefix-2
Unloaded private pond: $pond_name_private_prefix-3"

set success_output_verbose_multiple_private "\
Erased variable: TEST_POND_PRIVATE_1_VAR_1
Erased variable: TEST_POND_PRIVATE_1_VAR_2
Erased variable: TEST_POND_PRIVATE_1_VAR_3
Unloaded private pond: $pond_name_private_prefix-1
Erased variable: TEST_POND_PRIVATE_2_VAR_1
Erased variable: TEST_POND_PRIVATE_2_VAR_2
Erased variable: TEST_POND_PRIVATE_2_VAR_3
Unloaded private pond: $pond_name_private_prefix-2
Erased variable: TEST_POND_PRIVATE_3_VAR_1
Erased variable: TEST_POND_PRIVATE_3_VAR_2
Erased variable: TEST_POND_PRIVATE_3_VAR_3
Unloaded private pond: $pond_name_private_prefix-3"

set command_usage "\
Usage:
    pond unload [options] ponds...

Options:
    -v, --verbose  Output variable names during unload

Arguments:
    ponds  The name of one or more ponds to unload"

function __pond_unloaded_event_intercept --on-event pond_unloaded -a got_pond_name got_pond_path
    set -ga event_pond_names $got_pond_name
    set -ga event_pond_paths $got_pond_path
end

@echo "pond unload: success tests for regular pond"
__pond_setup 1 regular enabled populated
__pond_load_vars 1 regular
@test "setup: test variable one is set" (set -q TEST_POND_1_VAR_1) $status -eq $success
@test "setup: test variable two is set" (set -q TEST_POND_1_VAR_2) $status -eq $success
@test "setup: test variable three is set" (set -q TEST_POND_1_VAR_3) $status -eq $success
@test "pond unload: success exit code" (pond unload $pond_name_regular >/dev/null 2>&1) $status -eq $success
@test "pond unload: test variable one was erased" (set -q TEST_POND_1_VAR_1) $status -eq $fail
@test "pond unload: test variable two was erased" (set -q TEST_POND_1_VAR_2) $status -eq $fail
@test "pond unload: test variable three was erased" (set -q TEST_POND_1_VAR_3) $status -eq $fail
@test "pond unload: got pond name in event" (echo $event_pond_names) = $pond_name_regular
@test "pond unload: got pond path in event" (echo $event_pond_paths) = $pond_home/$pond_regular/$pond_name_regular
__pond_tear_down
__pond_event_reset

@echo "pond unload: output tests for regular pond"
__pond_setup 1 regular enabled populated
__pond_load_vars 1 regular
@test "pond unload: success output message" (pond unload $pond_name_regular 2>&1) = "Unloaded pond: $pond_name_regular"
__pond_tear_down
__pond_event_reset

for command in "pond unload "{-v,--verbose}" $pond_name_regular"

    @echo "$command: verbose success tests for regular pond"
    __pond_setup 1 regular enabled populated
    __pond_load_vars 1 regular
    @test "setup: test variable one is set" (set -q TEST_POND_1_VAR_1) $status -eq $success
    @test "setup: test variable two is set" (set -q TEST_POND_1_VAR_2) $status -eq $success
    @test "setup: test variable three is set" (set -q TEST_POND_1_VAR_3) $status -eq $success
    @test "pond unload: success exit code" (eval $command >/dev/null 2>&1) $status -eq $success
    @test "pond unload: test variable one was erased" (set -q TEST_POND_1_VAR_1) $status -eq $fail
    @test "pond unload: test variable two was erased" (set -q TEST_POND_1_VAR_2) $status -eq $fail
    @test "pond unload: test variable three was erased" (set -q TEST_POND_1_VAR_3) $status -eq $fail
    @test "pond unload: got pond name in event" (echo $event_pond_names) = $pond_name_regular
    @test "pond unload: got pond path in event" (echo $event_pond_paths) = $pond_home/$pond_regular/$pond_name_regular
    __pond_tear_down
    __pond_event_reset

    @echo "$command: verbose output tests for regular pond"
    __pond_setup 1 regular enabled populated
    __pond_load_vars 1 regular
    @test "pond unload: success output message" (eval $command 2>&1 | string collect) = $success_output_verbose_single_regular
    __pond_tear_down
    __pond_event_reset

end

@echo "pond unload: success tests for private pond"
__pond_setup 1 private enabled populated
__pond_load_vars 1 private
@test "setup: test variable one is set" (set -q TEST_POND_PRIVATE_1_VAR_1) $status -eq $success
@test "setup: test variable two is set" (set -q TEST_POND_PRIVATE_1_VAR_2) $status -eq $success
@test "setup: test variable three is set" (set -q TEST_POND_PRIVATE_1_VAR_3) $status -eq $success
@test "pond unload: success exit code" (pond unload $pond_name_private >/dev/null 2>&1) $status -eq $success
@test "pond unload: test variable one was erased" (set -q TEST_POND_PRIVATE_1_VAR_1) $status -eq $fail
@test "pond unload: test variable two was erased" (set -q TEST_POND_PRIVATE_1_VAR_2) $status -eq $fail
@test "pond unload: test variable three was erased" (set -q TEST_POND_PRIVATE_1_VAR_3) $status -eq $fail
@test "pond unload: got pond name in event" (echo $event_pond_names) = $pond_name_private
@test "pond unload: got pond path in event" (echo $event_pond_paths) = $pond_home/$pond_private/$pond_name_private
__pond_tear_down
__pond_event_reset

@echo "pond unload: output tests for private pond"
__pond_setup 1 private enabled populated
__pond_load_vars 1 private
@test "pond unload: success output message" (pond unload $pond_name_private 2>&1) = "Unloaded private pond: $pond_name_private"
__pond_tear_down
__pond_event_reset

for command in "pond unload "{-v,--verbose}" $pond_name_private"

    @echo "$command: verbose success tests for private pond"
    __pond_setup 1 private enabled populated
    __pond_load_vars 1 private
    @test "setup: test variable one is set" (set -q TEST_POND_PRIVATE_1_VAR_1) $status -eq $success
    @test "setup: test variable two is set" (set -q TEST_POND_PRIVATE_1_VAR_2) $status -eq $success
    @test "setup: test variable three is set" (set -q TEST_POND_PRIVATE_1_VAR_3) $status -eq $success
    @test "pond unload: success exit code" (eval $command >/dev/null 2>&1) $status -eq $success
    @test "pond unload: test variable one was erased" (set -q TEST_POND_PRIVATE_1_VAR_1) $status -eq $fail
    @test "pond unload: test variable two was erased" (set -q TEST_POND_PRIVATE_1_VAR_2) $status -eq $fail
    @test "pond unload: test variable three was erased" (set -q TEST_POND_PRIVATE_1_VAR_3) $status -eq $fail
    @test "pond unload: got pond name in event" (echo $event_pond_names) = $pond_name_private
    @test "pond unload: got pond path in event" (echo $event_pond_paths) = $pond_home/$pond_private/$pond_name_private
    __pond_tear_down
    __pond_event_reset

    @echo "$command: verbose output tests for private pond"
    __pond_setup 1 private enabled populated
    __pond_load_vars 1 private
    @test "pond unload: success output message" (eval $command 2>&1 | string collect) = $success_output_verbose_single_private
    __pond_tear_down
    __pond_event_reset

end

@echo "pond unload: success tests for multiple regular ponds"
__pond_setup 3 regular enabled populated
__pond_load_vars 3 regular
@test "setup: $pond_name_regular_prefix-1 variable one is set" (set -q TEST_POND_1_VAR_1) $status -eq $success
@test "setup: $pond_name_regular_prefix-1 variable two is set" (set -q TEST_POND_1_VAR_2) $status -eq $success
@test "setup: $pond_name_regular_prefix-1 variable three is set" (set -q TEST_POND_1_VAR_3) $status -eq $success
@test "setup: $pond_name_regular_prefix-2 variable one is set" (set -q TEST_POND_2_VAR_1) $status -eq $success
@test "setup: $pond_name_regular_prefix-2 variable two is set" (set -q TEST_POND_2_VAR_2) $status -eq $success
@test "setup: $pond_name_regular_prefix-2 variable three is set" (set -q TEST_POND_2_VAR_3) $status -eq $success
@test "setup: $pond_name_regular_prefix-3 variable one is set" (set -q TEST_POND_3_VAR_1) $status -eq $success
@test "setup: $pond_name_regular_prefix-3 variable two is set" (set -q TEST_POND_3_VAR_2) $status -eq $success
@test "setup: $pond_name_regular_prefix-3 variable three is set" (set -q TEST_POND_3_VAR_3) $status -eq $success
@test "pond unload: success exit code" (pond unload $pond_name_regular_prefix-1 $pond_name_regular_prefix-2 $pond_name_regular_prefix-3 >/dev/null 2>&1) $status -eq $success
@test "pond unload: $pond_name_regular_prefix-1 variable one was erased" (set -q TEST_POND_1_VAR_1) $status -eq $fail
@test "pond unload: $pond_name_regular_prefix-1 variable two was erased" (set -q TEST_POND_1_VAR_2) $status -eq $fail
@test "pond unload: $pond_name_regular_prefix-1 variable three was erased" (set -q TEST_POND_1_VAR_3) $status -eq $fail
@test "pond unload: $pond_name_regular_prefix-2 variable one was erased" (set -q TEST_POND_2_VAR_1) $status -eq $fail
@test "pond unload: $pond_name_regular_prefix-2 variable two was erased" (set -q TEST_POND_2_VAR_2) $status -eq $fail
@test "pond unload: $pond_name_regular_prefix-2 variable three was erased" (set -q TEST_POND_2_VAR_3) $status -eq $fail
@test "pond unload: $pond_name_regular_prefix-3 variable one was erased" (set -q TEST_POND_3_VAR_1) $status -eq $fail
@test "pond unload: $pond_name_regular_prefix-3 variable two was erased" (set -q TEST_POND_3_VAR_2) $status -eq $fail
@test "pond unload: $pond_name_regular_prefix-3 variable three was erased" (set -q TEST_POND_3_VAR_3) $status -eq $fail
@test "pond unload: got pond names in events" (echo $event_pond_names) = "$pond_name_regular_prefix-1 $pond_name_regular_prefix-2 $pond_name_regular_prefix-3"
@test "pond unload: got pond paths in events" (echo $event_pond_paths) = "$pond_home/$pond_regular/$pond_name_regular_prefix-1 $pond_home/$pond_regular/$pond_name_regular_prefix-2 $pond_home/$pond_regular/$pond_name_regular_prefix-3"
__pond_tear_down
__pond_event_reset

@echo "pond unload: output tests for multiple regular ponds"
__pond_setup 3 regular enabled populated
__pond_load_vars 3 regular
@test "pond unload: success output message" (pond unload $pond_name_regular_prefix-1 $pond_name_regular_prefix-2 $pond_name_regular_prefix-3 2>&1 | string collect) = $success_output_multiple_regular
__pond_tear_down
__pond_event_reset

for command in "pond unload "{-v,--verbose}" $pond_name_regular_prefix-1 $pond_name_regular_prefix-2 $pond_name_regular_prefix-3"

    @echo "$command: verbose success tests for multiple regular ponds"
    __pond_setup 3 regular enabled populated
    __pond_load_vars 3 regular
    @test "setup: $pond_name_regular_prefix-1 variable one is set" (set -q TEST_POND_1_VAR_1) $status -eq $success
    @test "setup: $pond_name_regular_prefix-1 variable two is set" (set -q TEST_POND_1_VAR_2) $status -eq $success
    @test "setup: $pond_name_regular_prefix-1 variable three is set" (set -q TEST_POND_1_VAR_3) $status -eq $success
    @test "setup: $pond_name_regular_prefix-2 variable one is set" (set -q TEST_POND_2_VAR_1) $status -eq $success
    @test "setup: $pond_name_regular_prefix-2 variable two is set" (set -q TEST_POND_2_VAR_2) $status -eq $success
    @test "setup: $pond_name_regular_prefix-2 variable three is set" (set -q TEST_POND_2_VAR_3) $status -eq $success
    @test "setup: $pond_name_regular_prefix-3 variable one is set" (set -q TEST_POND_3_VAR_1) $status -eq $success
    @test "setup: $pond_name_regular_prefix-3 variable two is set" (set -q TEST_POND_3_VAR_2) $status -eq $success
    @test "setup: $pond_name_regular_prefix-3 variable three is set" (set -q TEST_POND_3_VAR_3) $status -eq $success
    @test "pond unload: success exit code" (eval $command >/dev/null 2>&1) $status -eq $success
    @test "pond unload: $pond_name_regular_prefix-1 variable one was erased" (set -q TEST_POND_1_VAR_1) $status -eq $fail
    @test "pond unload: $pond_name_regular_prefix-1 variable two was erased" (set -q TEST_POND_1_VAR_2) $status -eq $fail
    @test "pond unload: $pond_name_regular_prefix-1 variable three was erased" (set -q TEST_POND_1_VAR_3) $status -eq $fail
    @test "pond unload: $pond_name_regular_prefix-2 variable one was erased" (set -q TEST_POND_2_VAR_1) $status -eq $fail
    @test "pond unload: $pond_name_regular_prefix-2 variable two was erased" (set -q TEST_POND_2_VAR_2) $status -eq $fail
    @test "pond unload: $pond_name_regular_prefix-2 variable three was erased" (set -q TEST_POND_2_VAR_3) $status -eq $fail
    @test "pond unload: $pond_name_regular_prefix-3 variable one was erased" (set -q TEST_POND_3_VAR_1) $status -eq $fail
    @test "pond unload: $pond_name_regular_prefix-3 variable two was erased" (set -q TEST_POND_3_VAR_2) $status -eq $fail
    @test "pond unload: $pond_name_regular_prefix-3 variable three was erased" (set -q TEST_POND_3_VAR_3) $status -eq $fail
    @test "pond unload: got pond names in events" (echo $event_pond_names) = "$pond_name_regular_prefix-1 $pond_name_regular_prefix-2 $pond_name_regular_prefix-3"
    @test "pond unload: got pond paths in events" (echo $event_pond_paths) = "$pond_home/$pond_regular/$pond_name_regular_prefix-1 $pond_home/$pond_regular/$pond_name_regular_prefix-2 $pond_home/$pond_regular/$pond_name_regular_prefix-3"
    __pond_tear_down
    __pond_event_reset

    @echo "$command: verbose output tests for multiple regular ponds"
    __pond_setup 3 regular enabled populated
    __pond_load_vars 3 regular
    @test "pond unload: success output message" (eval $command 2>&1 | string collect) = $success_output_verbose_multiple_regular
    __pond_tear_down
    __pond_event_reset

end

@echo "pond unload: success tests for multiple private ponds"
__pond_setup 3 private enabled populated
__pond_load_vars 3 private
@test "setup: $pond_name_regular_prefix-1 variable one is set" (set -q TEST_POND_PRIVATE_1_VAR_1) $status -eq $success
@test "setup: $pond_name_regular_prefix-1 variable two is set" (set -q TEST_POND_PRIVATE_1_VAR_2) $status -eq $success
@test "setup: $pond_name_regular_prefix-1 variable three is set" (set -q TEST_POND_PRIVATE_1_VAR_3) $status -eq $success
@test "setup: $pond_name_regular_prefix-2 variable one is set" (set -q TEST_POND_PRIVATE_2_VAR_1) $status -eq $success
@test "setup: $pond_name_regular_prefix-2 variable two is set" (set -q TEST_POND_PRIVATE_2_VAR_2) $status -eq $success
@test "setup: $pond_name_regular_prefix-2 variable three is set" (set -q TEST_POND_PRIVATE_2_VAR_3) $status -eq $success
@test "setup: $pond_name_regular_prefix-3 variable one is set" (set -q TEST_POND_PRIVATE_3_VAR_1) $status -eq $success
@test "setup: $pond_name_regular_prefix-3 variable two is set" (set -q TEST_POND_PRIVATE_3_VAR_2) $status -eq $success
@test "setup: $pond_name_regular_prefix-3 variable three is set" (set -q TEST_POND_PRIVATE_3_VAR_3) $status -eq $success
@test "pond unload: success exit code" (pond unload $pond_name_private_prefix-1 $pond_name_private_prefix-2 $pond_name_private_prefix-3 >/dev/null 2>&1) $status -eq $success
@test "pond unload: $pond_name_regular_prefix-1 variable one was erased" (set -q TEST_POND_PRIVATE_1_VAR_1) $status -eq $fail
@test "pond unload: $pond_name_regular_prefix-1 variable two was erased" (set -q TEST_POND_PRIVATE_1_VAR_2) $status -eq $fail
@test "pond unload: $pond_name_regular_prefix-1 variable three was erased" (set -q TEST_POND_PRIVATE_1_VAR_3) $status -eq $fail
@test "pond unload: $pond_name_regular_prefix-2 variable one was erased" (set -q TEST_POND_PRIVATE_2_VAR_1) $status -eq $fail
@test "pond unload: $pond_name_regular_prefix-2 variable two was erased" (set -q TEST_POND_PRIVATE_2_VAR_2) $status -eq $fail
@test "pond unload: $pond_name_regular_prefix-2 variable three was erased" (set -q TEST_POND_PRIVATE_2_VAR_3) $status -eq $fail
@test "pond unload: $pond_name_regular_prefix-3 variable one was erased" (set -q TEST_POND_PRIVATE_3_VAR_1) $status -eq $fail
@test "pond unload: $pond_name_regular_prefix-3 variable two was erased" (set -q TEST_POND_PRIVATE_3_VAR_2) $status -eq $fail
@test "pond unload: $pond_name_regular_prefix-3 variable three was erased" (set -q TEST_POND_PRIVATE_3_VAR_3) $status -eq $fail
@test "pond unload: got pond names in events" (echo $event_pond_names) = "$pond_name_private_prefix-1 $pond_name_private_prefix-2 $pond_name_private_prefix-3"
@test "pond unload: got pond paths in events" (echo $event_pond_paths) = "$pond_home/$pond_private/$pond_name_private_prefix-1 $pond_home/$pond_private/$pond_name_private_prefix-2 $pond_home/$pond_private/$pond_name_private_prefix-3"
__pond_tear_down
__pond_event_reset

@echo "pond unload: output tests for multiple private ponds"
__pond_setup 3 private enabled populated
__pond_load_vars 3 private
@test "pond unload: success output message" (pond unload $pond_name_private_prefix-1 $pond_name_private_prefix-2 $pond_name_private_prefix-3 2>&1 | string collect) = $success_output_multiple_private
__pond_tear_down
__pond_event_reset

for command in "pond unload "{-v,--verbose}" $pond_name_private_prefix-1 $pond_name_private_prefix-2 $pond_name_private_prefix-3"

    @echo "$command: verbose success tests for multiple private ponds"
    __pond_setup 3 private enabled populated
    __pond_load_vars 3 private
    @test "setup: $pond_name_regular_prefix-1 variable one is set" (set -q TEST_POND_PRIVATE_1_VAR_1) $status -eq $success
    @test "setup: $pond_name_regular_prefix-1 variable two is set" (set -q TEST_POND_PRIVATE_1_VAR_2) $status -eq $success
    @test "setup: $pond_name_regular_prefix-1 variable three is set" (set -q TEST_POND_PRIVATE_1_VAR_3) $status -eq $success
    @test "setup: $pond_name_regular_prefix-2 variable one is set" (set -q TEST_POND_PRIVATE_2_VAR_1) $status -eq $success
    @test "setup: $pond_name_regular_prefix-2 variable two is set" (set -q TEST_POND_PRIVATE_2_VAR_2) $status -eq $success
    @test "setup: $pond_name_regular_prefix-2 variable three is set" (set -q TEST_POND_PRIVATE_2_VAR_3) $status -eq $success
    @test "setup: $pond_name_regular_prefix-3 variable one is set" (set -q TEST_POND_PRIVATE_3_VAR_1) $status -eq $success
    @test "setup: $pond_name_regular_prefix-3 variable two is set" (set -q TEST_POND_PRIVATE_3_VAR_2) $status -eq $success
    @test "setup: $pond_name_regular_prefix-3 variable three is set" (set -q TEST_POND_PRIVATE_3_VAR_3) $status -eq $success
    @test "pond unload: success exit code" (eval $command >/dev/null 2>&1) $status -eq $success
    @test "pond unload: $pond_name_regular_prefix-1 variable one was erased" (set -q TEST_POND_PRIVATE_1_VAR_1) $status -eq $fail
    @test "pond unload: $pond_name_regular_prefix-1 variable two was erased" (set -q TEST_POND_PRIVATE_1_VAR_2) $status -eq $fail
    @test "pond unload: $pond_name_regular_prefix-1 variable three was erased" (set -q TEST_POND_PRIVATE_1_VAR_3) $status -eq $fail
    @test "pond unload: $pond_name_regular_prefix-2 variable one was erased" (set -q TEST_POND_PRIVATE_2_VAR_1) $status -eq $fail
    @test "pond unload: $pond_name_regular_prefix-2 variable two was erased" (set -q TEST_POND_PRIVATE_2_VAR_2) $status -eq $fail
    @test "pond unload: $pond_name_regular_prefix-2 variable three was erased" (set -q TEST_POND_PRIVATE_2_VAR_3) $status -eq $fail
    @test "pond unload: $pond_name_regular_prefix-3 variable one was erased" (set -q TEST_POND_PRIVATE_3_VAR_1) $status -eq $fail
    @test "pond unload: $pond_name_regular_prefix-3 variable two was erased" (set -q TEST_POND_PRIVATE_3_VAR_2) $status -eq $fail
    @test "pond unload: $pond_name_regular_prefix-3 variable three was erased" (set -q TEST_POND_PRIVATE_3_VAR_3) $status -eq $fail
    @test "pond unload: got pond names in events" (echo $event_pond_names) = "$pond_name_private_prefix-1 $pond_name_private_prefix-2 $pond_name_private_prefix-3"
    @test "pond unload: got pond paths in events" (echo $event_pond_paths) = "$pond_home/$pond_private/$pond_name_private_prefix-1 $pond_home/$pond_private/$pond_name_private_prefix-2 $pond_home/$pond_private/$pond_name_private_prefix-3"
    __pond_tear_down
    __pond_event_reset

    @echo "$command: verbose output tests for multiple private ponds"
    __pond_setup 3 private enabled populated
    __pond_load_vars 3 private
    @test "pond unload: success output message" (eval $command 2>&1 | string collect) = $success_output_verbose_multiple_private
    __pond_tear_down
    __pond_event_reset

end

@echo "pond unload: validation failure exit code tests"
@test "pond unload: fails for missing pond name" (pond unload >/dev/null 2>&1) $status -eq $fail
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
