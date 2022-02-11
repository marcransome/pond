set parent (dirname (status --current-filename))
source $parent/fixtures/functions.fish
source $parent/fixtures/variables.fish

set command_usage "\
Usage:
    pond dir <name>

Arguments:
    name  The name of the pond to change directory to"

set not_exists_error (__pond_error_string "Pond does not exist: no-exist")

@echo "pond dir $pond_name: success tests for single pond"
__pond_setup 1 enabled loaded unpopulated
@test "pond dir: success exit code" (pond dir $pond_name >/dev/null 2>&1) $status -eq $success
@test "pond dir: working directory changed" (pwd) = "$pond_home/$pond_name"
__pond_tear_down

@echo "pond dir: validation failure exit code tests"
@test "pond dir: fails for missing pond name" (pond dir >/dev/null 2>&1) $status -eq $failure
@test "pond dir: fails for trailing arguments" (pond dir $pond_name trailing >/dev/null 2>&1) $status -eq $failure
@test "pond dir: fails for malformed pond name" (pond dir _invalid >/dev/null 2>&1) $status -eq $failure
@test "pond dir: fails for non-existent pond" (pond dir no-exist >/dev/null 2>&1) $status -eq $failure

@echo "pond dir: validation failure output tests"
@test "pond dir: command usage shown for missing pond name" (pond dir 2>&1 | string collect) = $command_usage
@test "pond dir: command usage shown for trailing arguments" (pond dir $pond_name trailing 2>&1 | string collect) = $command_usage
@test "pond dir: command usage shown for malformed pond name" (pond dir _invalid 2>&1 | string collect) = $command_usage
@test "pond dir: command error shown for non-existent pond" (pond dir no-exist 2>&1 | string collect) = $not_exists_error
