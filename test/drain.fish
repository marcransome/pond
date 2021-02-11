set fail 1
set success 0

set -x __pond_under_test yes
set pond_name pond

set command_usage "\
Usage:
    pond drain <name>

Arguments:
    name  The name of the pond to drain"

function __pond_setup
    pond create -e $pond_name
    echo 'set -xg TEST_VAR test_value' >> $pond_data/$pond_name/$pond_vars
end

function __pond_tear_down
    echo 'y' | pond remove $pond_name
end

__pond_setup
@echo 'drain command success tests'
@test 'pond drain: success' (echo 'y' | pond drain $pond_name >/dev/null 2>&1) $status -eq $success
@test "pond drain: pond variables empty" -z (read < $pond_data/$pond_name/$pond_vars)
__pond_tear_down

@echo 'drain command success tests'
__pond_setup
@test 'pond drain: success with confirmation' (echo 'y' | pond drain $pond_name >/dev/null 2>&1) $status -eq $success
@test "pond drain: pond variables empty" -z (read < $pond_data/$pond_name/$pond_vars)
__pond_tear_down

__pond_setup
@test 'pond drain: success with -s option' (pond drain -s $pond_name >/dev/null 2>&1) $status -eq $success
@test "pond drain: pond variables empty" -z (read < $pond_data/$pond_name/$pond_vars)
__pond_tear_down

__pond_setup
@test 'pond drain: success with --silent option' (pond drain --silent $pond_name >/dev/null 2>&1) $status -eq $success
@test "pond drain: pond variables empty" -z (read < $pond_data/$pond_name/$pond_vars)
__pond_tear_down

@echo 'drain command failure exit code tests'
__pond_setup
@test 'pond drain: fails for missing pond name' (pond drain >/dev/null 2>&1) $status -eq $fail
@test 'pond drain: fails for trailing arguments' (pond drain $pond_name trailing >/dev/null 2>&1) $status -eq $fail
@test 'pond drain: fails for malformed pond name' (pond drain _invalid >/dev/null 2>&1) $status -eq $fail
@test 'pond drain: fails for non-existent pond' (pond drain non-exist >/dev/null 2>&1) $status -eq $fail
__pond_tear_down

@echo 'drain command failure usage output tests'
__pond_setup
@test 'pond drain: command usage shown for missing pond name' (pond drain 2>&1 | string collect) = $command_usage
@test 'pond drain: command usage shown for trailing arguments' (pond drain $pond_name trailing 2>&1 | string collect) = $command_usage
@test 'pond drain: command usage shown for malformed pond name' (pond drain _invalid 2>&1 | string collect) = $command_usage
@test 'pond drain: command error shown for non-existent pond' (pond drain non-exist 2>&1) = "Pond does not exist: non-exist"
__pond_tear_down

set -e __pond_setup
set -e __pond_tear_down
set -e __pond_under_test
