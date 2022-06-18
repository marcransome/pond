set parent (dirname (status --current-filename))
source $parent/fixtures/functions.fish
source $parent/fixtures/variables.fish

set command_usage "\
Usage:
    pond autounload <name>

Arguments:
    name  The name of the pond for which an autounload function
          will be opened in an editor and optionally created if
          it does not already exist"

set not_exists_error (__pond_error_string "Pond does not exist: no-exist")

@echo "pond autounload $pond_name: success tests for pond without autounload function"
__pond_setup 1 enabled loaded unpopulated
__pond_editor_intercept_with __pond_test_autounload_editor
@test "setup: autounload function absent" ! -f "$pond_home/$pond_name/"{$pond_name}_{$pond_autounload_suffix}.fish
@test "pond autounload: success invoking editor" (pond autounload $pond_name >/dev/null 2>&1) $status -eq $success
@test "pond autounload: autounload function created" -f "$pond_home/$pond_name/"{$pond_name}_{$pond_autounload_suffix}.fish
__pond_tear_down

@echo "pond autounload $pond_name: output tests for pond without autounload function"
__pond_setup 1 enabled loaded unpopulated
__pond_editor_intercept_with __pond_test_autounload_editor
@test "pond autounload: success output message" (pond autounload $pond_name 2>&1) = "Created autounload function: $pond_home/$pond_name/"{$pond_name}_{$pond_autounload_suffix}.fish
__pond_tear_down

@echo "pond autounload $pond_name: success tests for pond with existing autounload function"
__pond_setup 1 enabled loaded populated
__pond_editor_intercept_with __pond_test_autounload_editor
@test "setup: autounload function exists" -f "$pond_home/$pond_name/"{$pond_name}_{$pond_autounload_suffix}.fish
@test "pond autounload: success invoking editor" (pond autounload $pond_name >/dev/null 2>&1) $status -eq $success
@test "pond autounload: autounload function exists" -f "$pond_home/$pond_name/"{$pond_name}_{$pond_autounload_suffix}.fish
__pond_tear_down

@echo "pond autounload $pond_name: output tests for pond with existing autounload function"
__pond_setup 1 enabled loaded populated
__pond_editor_intercept_with __pond_test_autounload_editor
@test "pond autounload: no output message" -z (pond autounload $pond_name 2>&1)
__pond_tear_down

__pond_editor_reset

@echo "pond autounload: validation failure exit code tests"
@test "pond autounload: fails for missing pond name" (pond autounload >/dev/null 2>&1) $status -eq $failure
@test "pond autounload: fails for malformed pond name" (pond autounload _invalid >/dev/null 2>&1) $status -eq $failure
@test "pond autounload: fails for non-existent pond" (pond autounload no-exist >/dev/null 2>&1) $status -eq $failure

@echo "pond autounload: validation failure output tests"
@test "pond autounload: command usage shown for missing pond name" (pond autounload 2>&1 | string collect) = $command_usage
@test "pond autounload: command usage shown for malformed pond name" (pond autounload _invalid 2>&1 | string collect) = $command_usage
@test "pond autounload: command error shown for non-existent pond" (pond autounload no-exist 2>&1 | string collect) = $not_exists_error
