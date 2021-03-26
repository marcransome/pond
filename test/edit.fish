source ./helpers/functions.fish
source ./helpers/variables.fish

set pond_editor_before_test "$pond_editor"

set command_usage "\
Usage:
    pond edit <name>

Arguments:
    name  The name of the pond to edit"

@echo "pond edit $pond_name_regular: success tests for regular pond"
__pond_setup 1 regular enabled unpopulated
__pond_editor_intercept_with __pond_regular_pond_editor
@test "pond edit: success invoking editor" (pond edit $pond_name_regular >/dev/null 2>&1) $status -eq $success
__pond_tear_down

@echo "pond edit $pond_name_private: success tests for private pond"
__pond_setup 1 private enabled unpopulated
__pond_editor_intercept_with __pond_private_pond_editor
@test "pond edit: success invoking editor" (pond edit $pond_name_private >/dev/null 2>&1) $status -eq $success
__pond_tear_down

@echo "pond edit $pond_name_regular: failure tests for regular pond"
__pond_setup 1 regular enabled unpopulated
set -e __pond_under_test # temporarily disable to allow "command" to be invoked with missing editor
__pond_editor_intercept_with non-exist-cmd
@test "pond edit: fails for missing editor" (pond edit $pond_name_regular >/dev/null 2>&1) $status -eq $fail
@test "pond edit: output failure for missing editor" (pond edit $pond_name_regular 2>&1) = (set_color red; and echo -n "Error: "; and set_color normal; and echo "Editor not found: non-exist-cmd")
set __pond_under_test yes
__pond_tear_down

@echo "pond edit $pond_name_private: failure tests for private pond"
__pond_setup 1 private enabled unpopulated
set -e __pond_under_test # temporarily disable to allow "command" to be invoked with missing editor
__pond_editor_intercept_with non-exist-cmd
@test "pond edit: fails for missing editor" (pond edit $pond_name_private >/dev/null 2>&1) $status -eq $fail
@test "pond edit: output failure for missing editor" (pond edit $pond_name_private 2>&1) = (set_color red; and echo -n "Error: "; and set_color normal; and echo "Editor not found: non-exist-cmd")
set __pond_under_test yes
__pond_tear_down

@echo "pond edit: validation failure exit code tests"
@test "pond edit: fails for missing pond name" (pond edit >/dev/null 2>&1) $status -eq $fail
@test "pond edit: fails for trailing arguments" (pond edit $pond_name_regular trailing >/dev/null 2>&1) $status -eq $fail
@test "pond edit: fails for malformed pond name" (pond edit _invalid >/dev/null 2>&1) $status -eq $fail
@test "pond edit: fails for non-existent pond" (pond edit no-exist >/dev/null 2>&1) $status -eq $fail

for valid_option in -e --empty -p --private
    @test "pond edit: fails for valid option $valid_option and missing pond name" (pond edit $valid_option >/dev/null 2>&1) $status -eq $fail
    @test "pond edit: fails for valid option $valid_option and invalid pond name" (pond edit $valid_option _invalid >/dev/null 2>&1) $status -eq $fail
end

for invalid_option in -i --invalid
    @test "pond edit: fails for invalid option $invalid_option and valid pond name" (pond edit $invalid_option $pond_name >/dev/null 2>&1) $status -eq $fail
    @test "pond edit: fails for invalid option $invalid_option and invalid pond name" (pond edit $invalid_option _invalid >/dev/null 2>&1) $status -eq $fail
end

@echo "pond edit: validation failure output tests"
@test "pond edit: command usage shown for missing pond name" (pond edit 2>&1 | string collect) = $command_usage
@test "pond edit: command usage shown for trailing arguments" (pond edit $pond_name_regular trailing 2>&1 | string collect) = $command_usage
@test "pond edit: command usage shown for malformed pond name" (pond edit _invalid 2>&1 | string collect) = $command_usage
@test "pond edit: command error shown for non-existent pond" (pond edit no-exist 2>&1) = (set_color red; and echo -n "Error: "; and set_color normal; and echo "Pond does not exist: no-exist")

for valid_option in -e --empty -p --private
    @test "pond edit: command usage shown for valid option $valid_option and missing pond name" (pond edit $valid_option 2>&1 | string collect) = $command_usage
    @test "pond edit: command usage shown for valid option $valid_option and invalid pond name" (pond edit $valid_option _invalid 2>&1 | string collect) = $command_usage
end

for invalid_option in -i --invalid
    @test "pond edit: command usage shown for invalid option $invalid_option and valid pond name" (pond edit $invalid_option $pond_name 2>&1 | string collect) = $command_usage
    @test "pond edit: command usage shown for invalid option $invalid_option and invalid pond name" (pond edit $invalid_option _invalid 2>&1 | string collect) = $command_usage
end

__pond_editor_reset
