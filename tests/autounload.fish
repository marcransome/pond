set parent (dirname (status --current-filename))
source $parent/fixtures/functions.fish
source $parent/fixtures/variables.fish

set command_usage "\
Usage:
    pond autounload [options] <name>

Options:
    -s, --show  Show autounload function without opening editor

Arguments:
    name  The name of the pond for which an autounload function
          will be opened in an editor and optionally created if
          it does not already exist"

set success_output_single_pond "\
function test-pond-1_autounload

end"

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

for command in "pond autounload "{-s,--show}

    @echo "$command: success tests for single pond"

    __pond_setup 1 enabled loaded populated
    @test "setup: autounload function exists" -f "$pond_home/$pond_name/"{$pond_name}_{$pond_autounload_suffix}.fish
    @test "pond autounload: success exit code" (eval $command $pond_name >/dev/null 2>&1) $status -eq $success
    @test "pond autounload: autounload function exists" -f "$pond_home/$pond_name/"{$pond_name}_{$pond_autounload_suffix}.fish
    __pond_tear_down

    @echo "$command: output tests for single pond"
    __pond_setup 1 enabled loaded populated
    @test "pond autounload: success output message" (eval $command $pond_name 2>&1 | string collect) = $success_output_single_pond
    __pond_tear_down

end

@echo "pond autounload: validation failure exit code tests"
@test "pond autounload: fails for missing pond name" (pond autounload >/dev/null 2>&1) $status -eq $failure
@test "pond autounload: fails for malformed pond name" (pond autounload _invalid >/dev/null 2>&1) $status -eq $failure
@test "pond autounload: fails for non-existent pond" (pond autounload no-exist >/dev/null 2>&1) $status -eq $failure

for valid_option in -s --show
    @test "pond autounload: fails for valid option $valid_option and missing pond name" (pond autounload $valid_option >/dev/null 2>&1) $status -eq $failure
    @test "pond autounload: fails for valid option $valid_option and invalid pond name" (pond autounload $valid_option _invalid >/dev/null 2>&1) $status -eq $failure
end

for invalid_option in -i --invalid
    @test "pond autounload: fails for invalid option $invalid_option and valid pond name" (pond autounload $invalid_option $pond_name >/dev/null 2>&1) $status -eq $failure
    @test "pond autounload: fails for invalid option $invalid_option and invalid pond name" (pond autounload $invalid_option _invalid >/dev/null 2>&1) $status -eq $failure
end

@echo "pond autounload: validation failure output tests"
@test "pond autounload: command usage shown for missing pond name" (pond autounload 2>&1 | string collect) = $command_usage
@test "pond autounload: command usage shown for malformed pond name" (pond autounload _invalid 2>&1 | string collect) = $command_usage
@test "pond autounload: command error shown for non-existent pond" (pond autounload no-exist 2>&1 | string collect) = $not_exists_error

for valid_option in -y --yes
    @test "pond autounload: command usage shown for valid option $valid_option and missing pond name" (pond autounload $valid_option 2>&1 | string collect) = $command_usage
    @test "pond autounload: command usage shown for valid option $valid_option and invalid pond name" (pond autounload $valid_option _invalid 2>&1 | string collect) = $command_usage
end

for invalid_option in -i --invalid
    @test "pond autounload: command usage shown for invalid option $invalid_option and valid pond name" (pond autounload $invalid_option $pond_name 2>&1 | string collect) = $command_usage
    @test "pond autounload: command usage shown for invalid option $invalid_option and invalid pond name" (pond autounload $invalid_option _invalid 2>&1 | string collect) = $command_usage
end
