source ./fixtures/functions.fish
source ./fixtures/variables.fish

set command_usage "\
Usage:
    pond autoload <name>

Arguments:
name  The name of the pond for which an autoload function
      will be opened in an editor and optionally created if
      it does not already exist" >&2

@echo "pond autoload $pond_name: success tests for pond without autoload function"
__pond_setup 1 enabled loaded unpopulated
__pond_editor_intercept_with __pond_test_autoload_editor
@test "setup: autoload function absent" ! -f "$pond_home/$pond_name/"{$pond_name}_{$pond_autoload_suffix}.fish
@test "pond autoload: success invoking editor" (pond autoload $pond_name >/dev/null 2>&1) $status -eq $success
@test "pond autoload: autoload function created" -f "$pond_home/$pond_name/"{$pond_name}_{$pond_autoload_suffix}.fish
__pond_tear_down

@echo "pond autoload $pond_name: output tests for pond without autoload function"
__pond_setup 1 enabled loaded unpopulated
__pond_editor_intercept_with __pond_test_autoload_editor
@test "pond autoload: success output message" (pond autoload $pond_name 2>&1) = "Created autoload function: $pond_home/$pond_name/"{$pond_name}_{$pond_autoload_suffix}.fish
__pond_tear_down

@echo "pond autoload $pond_name: success tests for pond with existing autoload function"
__pond_setup 1 enabled loaded populated
__pond_editor_intercept_with __pond_test_autoload_editor
@test "setup: autoload function exists" -f "$pond_home/$pond_name/"{$pond_name}_{$pond_autoload_suffix}.fish
@test "pond autoload: success invoking editor" (pond autoload $pond_name >/dev/null 2>&1) $status -eq $success
@test "pond autoload: autoload function exists" -f "$pond_home/$pond_name/"{$pond_name}_{$pond_autoload_suffix}.fish
__pond_tear_down

@echo "pond autoload $pond_name: output tests for pond with existing autoload function"
__pond_setup 1 enabled loaded populated
__pond_editor_intercept_with __pond_test_autoload_editor
@test "pond autoload: no output message" -z (pond autoload $pond_name 2>&1)
__pond_tear_down

__pond_editor_reset
