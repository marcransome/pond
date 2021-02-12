set fail 1
set success 0

set -x __pond_under_test yes
set pond_name pond
set success_output "Pond loaded: $pond_name"

set command_usage "\
Usage:
    pond load <name>

Arguments:
    name  The name of the pond to load"

function __pond_setup
    pond create -e $pond_name
end

function __pond_add_global_exports
    echo "\
set -xg GLOBAL_EXPORT_ONE 1
set -xg GLOBAL_EXPORT_TWO 2
set -xg GLOBAL_EXPORT_THREE 3
" >> $pond_data/$pond_name/$pond_vars
end

function __pond_tear_down
    echo 'y' | pond remove $pond_name
end

@echo 'pond load: success tests'
__pond_setup
@test 'pond load: success for empty pond' (pond load $pond_name >/dev/null 2>&1) $status -eq $success
@test 'pond load: output success for empty pond' (pond load $pond_name 2>&1) = $success_output
__pond_add_global_exports
@test 'pond load: success for pond with global exports' (pond load $pond_name >/dev/null 2>&1) $status -eq $success
@test 'pond load: output success for pond with global exports' (pond load $pond_name 2>&1) = $success_output
@test 'pond load: global variable one was set' (echo $GLOBAL_EXPORT_ONE) = "1"
@test 'pond load: global variable two was set' (echo $GLOBAL_EXPORT_TWO) = "2"
@test 'pond load: global variable three was set' (echo $GLOBAL_EXPORT_THREE) = "3"
__pond_tear_down

@echo 'pond load: failure exit code tests'
__pond_setup
@test 'pond load: fails for missing pond name' (pond load >/dev/null 2>&1) $status -eq $fail
@test 'pond load: fails for trailing arguments' (pond load $pond_name trailing >/dev/null 2>&1) $status -eq $fail
@test 'pond load: fails for malformed pond name' (pond load _invalid >/dev/null 2>&1) $status -eq $fail
@test 'pond load: fails for short invalid option' (pond load -i >/dev/null 2>&1) $status -eq $fail
@test 'pond load: fails for long invalid option' (pond load --invalid >/dev/null 2>&1) $status -eq $fail
@test 'pond load: fails for valid short option and missing pond name' (pond load -e >/dev/null 2>&1) $status -eq $fail
@test 'pond load: fails for valid long option and missing pond name' (pond load --empty >/dev/null 2>&1) $status -eq $fail
@test 'pond load: fails for invalid short option and valid pond name' (pond load -i $pond_name >/dev/null 2>&1) $status -eq $fail
@test 'pond load: fails for invalid long option and valid pond name' (pond load --invalid $pond_name >/dev/null 2>&1) $status -eq $fail
@test 'pond load: fails for non-existent pond' (pond load non-exist >/dev/null 2>&1) $status -eq $fail
__pond_tear_down

@echo 'pond load: failure usage output tests'
__pond_setup
@test 'pond load: command usage shown for missing pond name' (pond load 2>&1 | string collect) = $command_usage
@test 'pond load: command usage shown for trailing arguments' (pond load $pond_name trailing 2>&1 | string collect) = $command_usage
@test 'pond load: command usage shown for malformed pond name' (pond load _invalid 2>&1 | string collect) = $command_usage
@test 'pond load: command usage shown for short invalid option' (pond load -i 2>&1 | string collect) = $command_usage
@test 'pond load: command usage shown for long invalid option' (pond load --invalid 2>&1 | string collect) = $command_usage
@test 'pond load: command usage shown for valid short option and missing pond name' (pond load -e 2>&1 | string collect) = $command_usage
@test 'pond load: command usage shown for valid long option and missing pond name' (pond load --empty 2>&1 | string collect) = $command_usage
@test 'pond load: command usage shown for invalid short option and valid pond name' (pond load -i $pond_name 2>&1 | string collect) = $command_usage
@test 'pond load: command usage shown for invalid long option and valid pond name' (pond load --invalid $pond_name 2>&1 | string collect) = $command_usage
@test 'pond load: command error shown for non-existent pond' (pond load non-exist 2>&1 | string collect) = "Pond does not exist: non-exist"
__pond_tear_down

set -e __pond_setup
set -e __pond_add_global_exports
set -e __pond_tear_down
set -e __pond_under_test
