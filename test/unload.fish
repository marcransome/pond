set fail 1
set success 0

set -x __pond_under_test yes
set pond_name pond
set success_output "Pond unloaded: $pond_name"

set command_usage "\
Usage:
    pond unload [options] <name>

Options:
    -v, --verbose  Output variable names during unload

Arguments:
    name  The name of the pond to unload"

# TODO expand test cases to include less well formed variable definitions
function __pond_setup
    pond create -e $pond_name

    echo "\
set -xg GLOBAL_EXPORT_ONE 1
set -xg GLOBAL_EXPORT_TWO 2
set -xg GLOBAL_EXPORT_THREE 3
" >> $pond_data/$pond_name/$pond_vars
end

function __pond_export_vars
    set -xg GLOBAL_EXPORT_ONE 1
    set -xg GLOBAL_EXPORT_TWO 2
    set -xg GLOBAL_EXPORT_THREE 3
end

function __pond_tear_down
    echo 'y' | pond remove $pond_name
end

@echo 'pond unload: success tests'
__pond_setup
__pond_export_vars
@test 'pond unload: success for pond with global exports' (pond unload $pond_name >/dev/null 2>&1) $status -eq $success
__pond_export_vars
@test 'pond unload: output success for pond with global exports' (pond unload $pond_name 2>&1) = $success_output
@test 'pond unload: global variable one was erase' -z (echo $GLOBAL_EXPORT_ONE)
@test 'pond unload: global variable two was erase' -z (echo $GLOBAL_EXPORT_TWO)
@test 'pond unload: global variable three was erase' -z (echo $GLOBAL_EXPORT_THREE)
__pond_tear_down

@echo 'pond unload: failure exit code tests'
__pond_setup
@test 'pond unload: fails for missing pond name' (pond unload >/dev/null 2>&1) $status -eq $fail
@test 'pond unload: fails for trailing arguments' (pond unload $pond_name trailing >/dev/null 2>&1) $status -eq $fail
@test 'pond unload: fails for malformed pond name' (pond unload _invalid >/dev/null 2>&1) $status -eq $fail
@test 'pond unload: fails for short invalid option' (pond unload -i >/dev/null 2>&1) $status -eq $fail
@test 'pond unload: fails for long invalid option' (pond unload --invalid >/dev/null 2>&1) $status -eq $fail
@test 'pond unload: fails for valid short option and missing pond name' (pond unload -e >/dev/null 2>&1) $status -eq $fail
@test 'pond unload: fails for valid long option and missing pond name' (pond unload --empty >/dev/null 2>&1) $status -eq $fail
@test 'pond unload: fails for invalid short option and valid pond name' (pond unload -i $pond_name >/dev/null 2>&1) $status -eq $fail
@test 'pond unload: fails for invalid long option and valid pond name' (pond unload --invalid $pond_name >/dev/null 2>&1) $status -eq $fail
@test 'pond unload: fails for non-existent pond' (pond unload non-exist >/dev/null 2>&1) $status -eq $fail
__pond_tear_down

@echo 'pond unload: failure usage output tests'
__pond_setup
@test 'pond unload: command usage shown for missing pond name' (pond unload 2>&1 | string collect) = $command_usage
@test 'pond unload: command usage shown for trailing arguments' (pond unload $pond_name trailing 2>&1 | string collect) = $command_usage
@test 'pond unload: command usage shown for malformed pond name' (pond unload _invalid 2>&1 | string collect) = $command_usage
@test 'pond unload: command usage shown for short invalid option' (pond unload -i 2>&1 | string collect) = $command_usage
@test 'pond unload: command usage shown for long invalid option' (pond unload --invalid 2>&1 | string collect) = $command_usage
@test 'pond unload: command usage shown for valid short option and missing pond name' (pond unload -e 2>&1 | string collect) = $command_usage
@test 'pond unload: command usage shown for valid long option and missing pond name' (pond unload --empty 2>&1 | string collect) = $command_usage
@test 'pond unload: command usage shown for invalid short option and valid pond name' (pond unload -i $pond_name 2>&1 | string collect) = $command_usage
@test 'pond unload: command usage shown for invalid long option and valid pond name' (pond unload --invalid $pond_name 2>&1 | string collect) = $command_usage
@test 'pond unload: command error shown for non-existent pond' (pond unload non-exist 2>&1 | string collect) = "Pond does not exist: non-exist"
__pond_tear_down

set -e __pond_setup
set -e __pond_export_vars
set -e __pond_tear_down
set -e __pond_under_test
