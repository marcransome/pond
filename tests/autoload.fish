set parent (dirname (status --current-filename))
source $parent/fixtures/functions.fish
source $parent/fixtures/variables.fish

set command_usage "\
Usage:
    pond autoload [options] <name>

Options:
    -s, --show  Show autoload function without opening editor

Arguments:
    name  The name of the pond for which an autoload function
          will be opened in an editor and optionally created if
          it does not already exist" >&2

set success_output_single_pond "\
function test-pond-1_autoload

end"

set not_exists_error (__pond_error_string "Pond does not exist: no-exist")

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

for command in "pond autoload "{-s,--show}

    @echo "$command: success tests for single pond"

    __pond_setup 1 enabled loaded populated
    @test "setup: autoload function exists" -f "$pond_home/$pond_name/"{$pond_name}_{$pond_autoload_suffix}.fish
    @test "pond autoload: success exit code" (eval $command $pond_name >/dev/null 2>&1) $status -eq $success
    @test "pond autoload: autoload function exists" -f "$pond_home/$pond_name/"{$pond_name}_{$pond_autoload_suffix}.fish
    __pond_tear_down

    @echo "$command: output tests for single pond"
    __pond_setup 1 enabled loaded populated
    @test "pond autoload: success output message" (eval $command $pond_name 2>&1 | string collect) = $success_output_single_pond
    __pond_tear_down

end

@echo "pond autoload: validation failure exit code tests"
@test "pond autoload: fails for missing pond name" (pond autoload >/dev/null 2>&1) $status -eq $failure
@test "pond autoload: fails for malformed pond name" (pond autoload _invalid >/dev/null 2>&1) $status -eq $failure
@test "pond autoload: fails for non-existent pond" (pond autoload no-exist >/dev/null 2>&1) $status -eq $failure

for valid_option in -s --show
    @test "pond autoload: fails for valid option $valid_option and missing pond name" (pond autoload $valid_option >/dev/null 2>&1) $status -eq $failure
    @test "pond autoload: fails for valid option $valid_option and invalid pond name" (pond autoload $valid_option _invalid >/dev/null 2>&1) $status -eq $failure
end

for invalid_option in -i --invalid
    @test "pond autoload: fails for invalid option $invalid_option and valid pond name" (pond autoload $invalid_option $pond_name >/dev/null 2>&1) $status -eq $failure
    @test "pond autoload: fails for invalid option $invalid_option and invalid pond name" (pond autoload $invalid_option _invalid >/dev/null 2>&1) $status -eq $failure
end

@echo "pond autoload: validation failure output tests"
@test "pond autoload: command usage shown for missing pond name" (pond autoload 2>&1 | string collect) = $command_usage
@test "pond autoload: command usage shown for malformed pond name" (pond autoload _invalid 2>&1 | string collect) = $command_usage
@test "pond autoload: command error shown for non-existent pond" (pond autoload no-exist 2>&1 | string collect) = $not_exists_error

for valid_option in -y --yes
    @test "pond autoload: command usage shown for valid option $valid_option and missing pond name" (pond autoload $valid_option 2>&1 | string collect) = $command_usage
    @test "pond autoload: command usage shown for valid option $valid_option and invalid pond name" (pond autoload $valid_option _invalid 2>&1 | string collect) = $command_usage
end

for invalid_option in -i --invalid
    @test "pond autoload: command usage shown for invalid option $invalid_option and valid pond name" (pond autoload $invalid_option $pond_name 2>&1 | string collect) = $command_usage
    @test "pond autoload: command usage shown for invalid option $invalid_option and invalid pond name" (pond autoload $invalid_option _invalid 2>&1 | string collect) = $command_usage
end
