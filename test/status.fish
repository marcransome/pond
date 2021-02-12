set fail 1
set success 0

set -x __pond_under_test yes
set pond_name pond
set pond_enable_on_create_before_test $pond_enable_on_create

set success_output_enabled "\
name: $pond_name
enabled: yes
path: $pond_home/ponds/$pond_name"

set success_output_disabled "\
name: $pond_name
enabled: no
path: $pond_home/ponds/$pond_name"

set command_usage "\
Usage:
    pond status <name>

Arguments:
    name  The name of the pond"

function __pond_setup_and_enabled
    set -x pond_enable_on_create yes; and pond create -e $pond_name
    pond status $pond_name
end

function __pond_setup_and_disabled
    set -x pond_enable_on_create no; and pond create -e $pond_name
    pond status $pond_name
end

function __pond_tear_down
    echo 'y' | pond remove $pond_name
end

@echo 'pond status: success tests for enabled pond'
__pond_setup_and_enabled
@test 'pond status: success for enabled pond' (pond status $pond_name >/dev/null 2>&1) $status -eq $success
@test 'pond status: output success for enabled pond' (pond status $pond_name 2>&1 | string collect) = $success_output_enabled
__pond_tear_down

@echo 'pond status: success tests for disabled pond'
__pond_setup_and_disabled
@test 'pond status: success for disabled pond' (pond status $pond_name >/dev/null 2>&1) $status -eq $success
@test 'pond status: output success for disabled pond' (pond status $pond_name 2>&1 | string collect) = $success_output_disabled
__pond_tear_down

@echo 'pond status: failure exit code tests'
__pond_setup_and_enabled
@test 'pond status: fails for missing pond name' (pond status >/dev/null 2>&1) $status -eq $fail
@test 'pond status: fails for trailing arguments' (pond status $pond_name trailing >/dev/null 2>&1) $status -eq $fail
@test 'pond status: fails for malformed pond name' (pond status _invalid >/dev/null 2>&1) $status -eq $fail
@test 'pond status: fails for non-existent pond' (pond status non-exist >/dev/null 2>&1) $status -eq $fail
__pond_tear_down

@echo 'pond status: failure usage output tests'
__pond_setup_and_enabled
@test 'pond status: command usage shown for missing pond name' (pond status 2>&1 | string collect) = $command_usage
@test 'pond status: command usage shown for trailing arguments' (pond status $pond_name trailing 2>&1 | string collect) = $command_usage
@test 'pond status: command usage shown for malformed pond name' (pond status _invalid 2>&1 | string collect) = $command_usage
@test 'pond status: command error shown for non-existent pond' (pond status non-exist 2>&1) = "Pond does not exist: non-exist"
__pond_tear_down

set -e __pond_setup_and_enabled
set -e __pond_setup_and_disabled
set -e __pond_tear_down
set -e __pond_under_test
set pond_enable_on_create $pond_enable_on_create_before_test
