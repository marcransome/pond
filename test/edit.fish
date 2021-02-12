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

# TODO expand test cases to include less well formed variable definitions
function __pond_setup
    pond create -e $pond_name
end

function __pond_tear_down
    echo 'y' | pond remove $pond_name
end

function __pond_intercept_editor_call -a pond_path
    if ! test $pond_path = $pond_data/$pond_name/$pond_vars
        return 1
    end
end

set -x pond_editor __pond_intercept_editor_call

@echo 'pond edit: success tests'
__pond_setup
@test 'pond edit: success invoking editor' (pond edit $pond_name ) $status -eq $success
__pond_tear_down

@echo 'pond edit: failure tests'
__pond_setup
set -e __pond_under_test # temporarily disable to allow 'command' to be invoked with missing editor
set pond_editor non-exist-cmd
@test 'pond edit: fails for missing editor' (pond edit $pond_name >/dev/null 2>&1) $status -eq $fail
@test 'pond edit: output failure for missing editor' (pond edit $pond_name 2>&1) = "Editor not found: non-exist-cmd"
set __pond_under_test yes
__pond_tear_down

@test 'pond edit: fails for missing pond name' (pond edit >/dev/null 2>&1) $status -eq $fail
@test 'pond edit: fails for trailing arguments' (pond edit $pond_name trailing >/dev/null 2>&1) $status -eq $fail
@test 'pond edit: fails for malformed pond name' (pond edit _invalid >/dev/null 2>&1) $status -eq $fail
@test 'pond edit: fails for short invalid option' (pond edit -i >/dev/null 2>&1) $status -eq $fail
@test 'pond edit: fails for long invalid option' (pond edit --invalid >/dev/null 2>&1) $status -eq $fail
@test 'pond edit: fails for valid short option and missing pond name' (pond edit -e >/dev/null 2>&1) $status -eq $fail
@test 'pond edit: fails for valid long option and missing pond name' (pond edit --empty >/dev/null 2>&1) $status -eq $fail
@test 'pond edit: fails for invalid short option and valid pond name' (pond edit -i $pond_name >/dev/null 2>&1) $status -eq $fail
@test 'pond edit: fails for invalid long option and valid pond name' (pond edit --invalid $pond_name >/dev/null 2>&1) $status -eq $fail
@test 'pond edit: fails for non-existent pond' (pond edit non-exist >/dev/null 2>&1) $status -eq $fail
__pond_tear_down

@echo 'pond edit: failure usage output tests'
__pond_setup
@test 'pond edit: command usage shown for missing pond name' (pond edit 2>&1 | string collect) = $command_usage
@test 'pond edit: command usage shown for trailing arguments' (pond edit $pond_name trailing 2>&1 | string collect) = $command_usage
@test 'pond edit: command usage shown for malformed pond name' (pond edit _invalid 2>&1 | string collect) = $command_usage
@test 'pond edit: command usage shown for short invalid option' (pond edit -i 2>&1 | string collect) = $command_usage
@test 'pond edit: command usage shown for long invalid option' (pond edit --invalid 2>&1 | string collect) = $command_usage
@test 'pond edit: command usage shown for valid short option and missing pond name' (pond edit -e 2>&1 | string collect) = $command_usage
@test 'pond edit: command usage shown for valid long option and missing pond name' (pond edit --empty 2>&1 | string collect) = $command_usage
@test 'pond edit: command usage shown for invalid short option and valid pond name' (pond edit -i $pond_name 2>&1 | string collect) = $command_usage
@test 'pond edit: command usage shown for invalid long option and valid pond name' (pond edit --invalid $pond_name 2>&1 | string collect) = $command_usage
@test 'pond edit: command error shown for non-existent pond' (pond edit non-exist 2>&1 | string collect) = "Pond does not exist: non-exist"
__pond_tear_down

set -e __pond_setup
set -e __pond_intercept_editor_call
set -e __pond_tear_down
set -e __pond_under_test
set pond_editor $pond_editor_before_test
