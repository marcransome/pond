set fail 1
set success 0

set -x __pond_under_test yes
set pond_name pond
set pond_enable_on_create_before_test $pond_enable_on_create

set command_usage "\
Usage:
    pond disable <name>

Arguments:
    name  The name of the pond to disable"

function __pond_setup_and_enabled
    set pond_enable_on_create yes; and pond create -e $pond_name
    echo 'set -xg TEST_VAR test_value' >> $pond_data/$pond_name/$pond_vars
    pond status $pond_name
end

function __pond_setup_and_disabled
    set pond_enable_on_create no; and pond create -e $pond_name
    echo 'set -xg TEST_VAR test_value' >> $pond_data/$pond_name/$pond_vars
    pond status $pond_name
end

function __pond_tear_down
    echo 'y' | pond remove $pond_name
end

@echo 'pond disable: success tests'
__pond_setup_and_enabled
@test 'pond disable: success' (pond disable $pond_name >/dev/null 2>&1) $status -eq $success
@test "pond disable: pond symlink removed" ! -L $pond_links/$pond_name
__pond_tear_down

@echo 'pond disable: failure exit code tests'
__pond_setup_and_enabled
@test 'pond disable: fails for missing pond name' (pond disable >/dev/null 2>&1) $status -eq $fail
@test 'pond disable: fails for trailing arguments' (pond disable $pond_name trailing >/dev/null 2>&1) $status -eq $fail
@test 'pond disable: fails for malformed pond name' (pond disable _invalid >/dev/null 2>&1) $status -eq $fail
@test 'pond disable: fails for non-existent pond' (pond disable non-exist >/dev/null 2>&1) $status -eq $fail
__pond_tear_down

@echo 'pond disable: failure usage output tests'
__pond_setup_and_enabled
@test 'pond disable: command usage shown for missing pond name' (pond disable 2>&1 | string collect) = $command_usage
@test 'pond disable: command usage shown for trailing arguments' (pond disable $pond_name trailing 2>&1 | string collect) = $command_usage
@test 'pond disable: command usage shown for malformed pond name' (pond disable _invalid 2>&1 | string collect) = $command_usage
@test 'pond disable: command reports disabled pond' (pond disable $pond_name 2>&1) = "Disabled pond: pond"
@test 'pond disable: command error shown for non-existent pond' (pond disable non-exist 2>&1) = "Pond does not exist: non-exist"
__pond_tear_down

set -e __pond_setup_and_enabled
set -e __pond_setup_and_disabled
set -e __pond_tear_down
set -e __pond_under_test
set pond_enable_on_create $pond_enable_on_create_before_test
