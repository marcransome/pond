source ./fixtures/functions.fish
source ./fixtures/variables.fish

set command_usage "\
Usage:
    pond init <name>

Arguments:
name  The name of the pond for which an init function will
      be opened in an editor and optionally created if it
      does not already exist" >&2

@echo "pond init $pond_name: success tests for pond without init function"
__pond_setup 1 enabled unpopulated
__pond_editor_intercept_with __pond_test_init_editor
@test "setup: init function absent" ! -f "$pond_home/$pond_name/"{$pond_name}_{$pond_init_suffix}.fish
@test "pond init: success invoking editor" (pond init $pond_name >/dev/null 2>&1) $status -eq $success
@test "pond init: init function created" -f "$pond_home/$pond_name/"{$pond_name}_{$pond_init_suffix}.fish
__pond_tear_down

@echo "pond init $pond_name: output tests for pond without init function"
__pond_setup 1 enabled unpopulated
__pond_editor_intercept_with __pond_test_init_editor
@test "pond init: success output message" (pond init $pond_name 2>&1) = "Created init file: $pond_home/$pond_name/"{$pond_name}_{$pond_init_suffix}.fish
__pond_tear_down

@echo "pond init $pond_name: success tests for pond with existing init function"
__pond_setup 1 enabled populated
__pond_editor_intercept_with __pond_test_init_editor
@test "setup: init function exists" -f "$pond_home/$pond_name/"{$pond_name}_{$pond_init_suffix}.fish
@test "pond init: success invoking editor" (pond init $pond_name >/dev/null 2>&1) $status -eq $success
@test "pond init: init function exists" -f "$pond_home/$pond_name/"{$pond_name}_{$pond_init_suffix}.fish
__pond_tear_down

@echo "pond init $pond_name: output tests for pond with existing init function"
__pond_setup 1 enabled populated
__pond_editor_intercept_with __pond_test_init_editor
@test "pond init: no output message" -z (pond init $pond_name 2>&1)
__pond_tear_down

__pond_editor_reset
