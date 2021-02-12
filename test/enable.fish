set fail 1
set success 0

set -x __pond_under_test yes
set pond_name pond
set pond_enable_on_create_before_test $pond_enable_on_create

set command_usage "\
Usage:
    pond enable <name>

Arguments:
    name  The name of the pond to enable"

function __pond_setup_and_enabled
    set -x pond_enable_on_create yes; and pond create -e $pond_name
    pond status $pond_name
end

function __pond_setup_and_disabled
    set -x pond_enable_on_create no; and pond create -e $pond_name
    echo 'set -xg TEST_VAR test_value' >> $pond_data/$pond_name/$pond_vars
    pond status $pond_name
end

function __pond_tear_down
    echo 'y' | pond remove $pond_name
end

@echo 'pond enable: success tests'
__pond_setup_and_disabled
@test 'pond enable: success' (pond enable $pond_name >/dev/null 2>&1) $status -eq $success
@test "pond enable: pond symlink created" -L $pond_links/$pond_name
__pond_tear_down

@echo 'pond enable: failure exit code tests'
__pond_setup_and_enabled
@test 'pond enable: fails for missing pond name' (pond enable >/dev/null 2>&1) $status -eq $fail
@test 'pond enable: fails for trailing arguments' (pond enable $pond_name trailing >/dev/null 2>&1) $status -eq $fail
@test 'pond enable: fails for malformed pond name' (pond enable _invalid >/dev/null 2>&1) $status -eq $fail
@test 'pond enable: fails for already enabled pond' (pond enable $pond_name >/dev/null 2>&1) $status -eq $fail
@test 'pond enable: fails for non-existent pond' (pond enable non-exist >/dev/null 2>&1) $status -eq $fail
__pond_tear_down

@echo 'pond enable: failure usage output tests'
__pond_setup_and_enabled
@test 'pond enable: command usage shown for missing pond name' (pond enable 2>&1 | string collect) = $command_usage
@test 'pond enable: command usage shown for trailing arguments' (pond enable $pond_name trailing 2>&1 | string collect) = $command_usage
@test 'pond enable: command usage shown for malformed pond name' (pond enable _invalid 2>&1 | string collect) = $command_usage
@test 'pond enable: command error shown for existing pond' (pond enable $pond_name 2>&1) = "Pond already enabled: pond"
@test 'pond enable: command error shown for non-existent pond' (pond enable non-exist 2>&1) = "Pond does not exist: non-exist"
__pond_tear_down

set -e __pond_setup_and_enabled
set -e __pond_setup_and_disabled
set -e __pond_tear_down
set -e __pond_under_test
set pond_enable_on_create $pond_enable_on_create_before_test
