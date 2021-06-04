source ./fixtures/functions.fish
source ./fixtures/variables.fish

set command_usage "\
Usage:
    pond deinit <name>

Arguments:
name  The name of the pond for which a deinit function will
      be opened in an editor and optionally created if it
      does not already exist"

@echo "pond edit $pond_name: success tests for pond without deinit function"
__pond_setup 1 enabled unpopulated
__pond_editor_intercept_with __pond_test_deinit_editor
@test "setup: deinit function absent" ! -f "$pond_home/$pond_name/"{$pond_name}_{$pond_deinit_suffix}.fish
@test "pond deinit: success invoking editor" (pond deinit $pond_name >/dev/null 2>&1) $status -eq $success
@test "pond deinit: deinit function created" -f "$pond_home/$pond_name/"{$pond_name}_{$pond_deinit_suffix}.fish
__pond_tear_down

@echo "pond edit $pond_name: output tests for pond without deinit function"
__pond_setup 1 enabled unpopulated
__pond_editor_intercept_with __pond_test_deinit_editor
@test "pond deinit: success output message" (pond deinit $pond_name 2>&1) = "Created deinit file: $pond_home/$pond_name/"{$pond_name}_{$pond_deinit_suffix}.fish
__pond_tear_down

@echo "pond edit $pond_name: success tests for pond with existing deinit function"
__pond_setup 1 enabled populated
__pond_editor_intercept_with __pond_test_deinit_editor
@test "setup: deinit function exists" -f "$pond_home/$pond_name/"{$pond_name}_{$pond_deinit_suffix}.fish
@test "pond deinit: success invoking editor" (pond deinit $pond_name >/dev/null 2>&1) $status -eq $success
@test "pond deinit: deinit function exists" -f "$pond_home/$pond_name/"{$pond_name}_{$pond_deinit_suffix}.fish
__pond_tear_down

@echo "pond edit $pond_name: output tests for pond with existing deinit function"
__pond_setup 1 enabled populated
__pond_editor_intercept_with __pond_test_deinit_editor
@test "pond deinit: no output message" -z (pond deinit $pond_name 2>&1)
__pond_tear_down

__pond_editor_reset
