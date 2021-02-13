set fail 1
set success 0

set -x __pond_under_test yes
set pond_name pond
set pond_editor_before_test $pond_editor

set command_usage "\
Usage:
    pond edit <name>

Arguments:
    name  The name of the pond to edit"

function __pond_setup_regular
    pond create -e $pond_name >/dev/null 2>&1
end

function __pond_setup_private
    pond create -e -p $pond_name >/dev/null 2>&1
end

function __pond_tear_down
    echo "y" | pond remove $pond_name >/dev/null 2>&1
end

function __pond_editor_intercept_with -a function_name
    set -x pond_editor $function_name
end

function __pond_regular_pond_editor -a pond_path
    if ! test "$pond_path" = "$pond_home/$pond_regular/$pond_name/$pond_vars"
        return 1
    end
end

function __pond_private_pond_editor -a pond_path
    if ! test "$pond_path" = "$pond_home/$pond_private/$pond_name/$pond_vars"
        return 1
    end
end

function __pond_editor_reset
    set pond_editor $pond_editor_before_test
end

@echo "pond edit $pond_name: success tests for regular pond"
__pond_setup_regular
__pond_editor_intercept_with __pond_regular_pond_editor
@test "pond edit: success invoking editor" (pond edit $pond_name >/dev/null 2>&1) $status -eq $success
__pond_tear_down

@echo "pond edit $pond_name: success tests for private pond"
__pond_setup_private
__pond_editor_intercept_with __pond_private_pond_editor
@test "pond edit: success invoking editor" (pond edit $pond_name >/dev/null 2>&1) $status -eq $success
__pond_tear_down

@echo "pond edit $pond_name: failure tests for regular pond"
__pond_setup_regular
set -e __pond_under_test # temporarily disable to allow "command" to be invoked with missing editor
__pond_editor_intercept_with non-exist-cmd
@test "pond edit: fails for missing editor" (pond edit $pond_name >/dev/null 2>&1) $status -eq $fail
@test "pond edit: output failure for missing editor" (pond edit $pond_name 2>&1) = "Editor not found: non-exist-cmd"
set __pond_under_test yes
__pond_tear_down


@echo "pond edit $pond_name: failure tests for private pond"
__pond_setup_private
set -e __pond_under_test # temporarily disable to allow "command" to be invoked with missing editor
__pond_editor_intercept_with non-exist-cmd
@test "pond edit: fails for missing editor" (pond edit $pond_name >/dev/null 2>&1) $status -eq $fail
@test "pond edit: output failure for missing editor" (pond edit $pond_name 2>&1) = "Editor not found: non-exist-cmd"
set __pond_under_test yes
__pond_tear_down








# @echo "pond create: validation failure exit code tests"
# __pond_setup
# @test "pond create: fails for missing pond name" (pond create >/dev/null 2>&1) $status -eq $fail
# @test "pond create: fails for trailing arguments" (pond create $pond_name trailing >/dev/null 2>&1) $status -eq $fail
# @test "pond create: fails for malformed pond name" (pond create _invalid >/dev/null 2>&1) $status -eq $fail
# @test "pond create: fails for short invalid option" (pond create -i >/dev/null 2>&1) $status -eq $fail
# @test "pond create: fails for long invalid option" (pond create --invalid >/dev/null 2>&1) $status -eq $fail
# @test "pond create: fails for valid short option and missing pond name" (pond create -e >/dev/null 2>&1) $status -eq $fail
# @test "pond create: fails for valid long option and missing pond name" (pond create --empty >/dev/null 2>&1) $status -eq $fail
# @test "pond create: fails for invalid short option and valid pond name" (pond create -i $pond_name >/dev/null 2>&1) $status -eq $fail
# @test "pond create: fails for invalid long option and valid pond name" (pond create --invalid $pond_name >/dev/null 2>&1) $status -eq $fail
# @test "pond create: fails for existing pond" (pond create $pond_name >/dev/null 2>&1) $status -eq $fail
# __pond_tear_down







@echo "pond edit: validation failure exit code tests"
@test "pond edit: fails for missing pond name" (pond edit >/dev/null 2>&1) $status -eq $fail
@test "pond edit: fails for trailing arguments" (pond edit $pond_name trailing >/dev/null 2>&1) $status -eq $fail
@test "pond edit: fails for malformed pond name" (pond edit _invalid >/dev/null 2>&1) $status -eq $fail
@test "pond edit: fails for non-existent pond" (pond edit no-exist >/dev/null 2>&1) $status -eq $fail

for valid_option in -e --empty -p --private
    for invalid_option in -i --invalid
        @test "pond edit: command usage shown for valid option $valid_option and missing pond name" (pond edit $valid_option >/dev/null 2>&1) $status -eq $fail
        @test "pond edit: command usage shown for valid option $valid_option and invalid pond name" (pond edit $valid_option _invalid >/dev/null 2>&1) $status -eq $fail
        @test "pond edit: command usage shown for invalid option $invalid_option and valid pond name" (pond edit $invalid_option $pond_name >/dev/null 2>&1) $status -eq $fail
        @test "pond edit: command usage shown for invalid option $invalid_option and invalid pond name" (pond edit $invalid_option _invalid >/dev/null 2>&1) $status -eq $fail
    end
end

@echo "pond edit: validation failure output tests"
@test "pond edit: command usage shown for missing pond name" (pond edit 2>&1 | string collect) = $command_usage
@test "pond edit: command usage shown for trailing arguments" (pond edit $pond_name trailing 2>&1 | string collect) = $command_usage
@test "pond edit: command usage shown for malformed pond name" (pond edit _invalid 2>&1 | string collect) = $command_usage
@test "pond edit: command error shown for non-existent pond" (pond edit no-exist 2>&1 | string collect) = "Pond does not exist: no-exist"

for valid_option in -e --empty -p --private
    for invalid_option in -i --invalid
        @test "pond edit: command usage shown for valid option $valid_option and missing pond name" (pond edit $valid_option 2>&1 | string collect) = $command_usage
        @test "pond edit: command usage shown for valid option $valid_option and invalid pond name" (pond edit $valid_option _invalid 2>&1 | string collect) = $command_usage
        @test "pond edit: command usage shown for invalid option $invalid_option and valid pond name" (pond edit $invalid_option $pond_name 2>&1 | string collect) = $command_usage
        @test "pond edit: command usage shown for invalid option $invalid_option and invalid pond name" (pond edit $invalid_option _invalid 2>&1 | string collect) = $command_usage
    end
end








__pond_setup_regular
@echo "pond edit: validation failure exit code tests"
@test "pond edit: fails for missing pond name" (pond edit >/dev/null 2>&1) $status -eq $fail
@test "pond edit: fails for trailing arguments" (pond edit $pond_name trailing >/dev/null 2>&1) $status -eq $fail
@test "pond edit: fails for malformed pond name" (pond edit _invalid >/dev/null 2>&1) $status -eq $fail
@test "pond edit: fails for short invalid option" (pond edit -i >/dev/null 2>&1) $status -eq $fail
@test "pond edit: fails for long invalid option" (pond edit --invalid >/dev/null 2>&1) $status -eq $fail
@test "pond edit: fails for invalid short option and valid pond name" (pond edit -i $pond_name >/dev/null 2>&1) $status -eq $fail
@test "pond edit: fails for invalid long option and valid pond name" (pond edit --invalid $pond_name >/dev/null 2>&1) $status -eq $fail
@test "pond edit: fails for non-existent pond" (pond edit non-exist >/dev/null 2>&1) $status -eq $fail
__pond_tear_down

#
# @echo "pond edit: failure usage output tests"
# __pond_setup
# @test "pond edit: command usage shown for missing pond name" (pond edit 2>&1 | string collect) = $command_usage
# @test "pond edit: command usage shown for trailing arguments" (pond edit $pond_name trailing 2>&1 | string collect) = $command_usage
# @test "pond edit: command usage shown for malformed pond name" (pond edit _invalid 2>&1 | string collect) = $command_usage
# @test "pond edit: command usage shown for short invalid option" (pond edit -i 2>&1 | string collect) = $command_usage
# @test "pond edit: command usage shown for long invalid option" (pond edit --invalid 2>&1 | string collect) = $command_usage
# @test "pond edit: command usage shown for valid short option and missing pond name" (pond edit -e 2>&1 | string collect) = $command_usage
# @test "pond edit: command usage shown for valid long option and missing pond name" (pond edit --empty 2>&1 | string collect) = $command_usage
# @test "pond edit: command usage shown for invalid short option and valid pond name" (pond edit -i $pond_name 2>&1 | string collect) = $command_usage
# @test "pond edit: command usage shown for invalid long option and valid pond name" (pond edit --invalid $pond_name 2>&1 | string collect) = $command_usage
# @test "pond edit: command error shown for non-existent pond" (pond edit non-exist 2>&1 | string collect) = "Pond does not exist: non-exist"
# __pond_tear_down

set -e __pond_setup_regular
set -e __pond_setup_private
set -e __pond_editor_intercept_with
set -e __pond_regular_pond_editor
set -e __pond_private_pond_editor
set -e __pond_editor_reset
set -e __pond_tear_down
set -e __pond_under_test
