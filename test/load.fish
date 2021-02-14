set fail 1
set success 0

set -x __pond_under_test yes
set pond_name test-pond

set command_usage "\
Usage:
    pond load <name>

Arguments:
    name  The name of the pond to load"

function __pond_setup_regular
    pond create -e $pond_name >/dev/null 2>&1
    for var in TEST_VAR_{1,2,3}
        set -xg $var (string lower $var)
        echo "set -xg $var "(string lower $var) >>  $pond_home/$pond_regular/$pond_name/$pond_vars
    end
end

function __pond_setup_private
    pond create -e -p $pond_name >/dev/null 2>&1
    for var in TEST_VAR_PRIVATE_{1,2,3}
        set -xg $var (string lower $var)
        echo "set -xg $var "(string lower $var) >>  $pond_home/$pond_private/$pond_name/$pond_vars
    end
end

function __pond_tear_down
    for var in TEST_VAR{,_PRIVATE}_{1,2,3}
        set -e $var
    end
    echo "y" | pond remove $pond_name >/dev/null 2>&1
end

@echo "pond load: success tests for regular pond"
__pond_setup_regular
@test "setup: pond variables exist" -n (read < $pond_home/$pond_regular/$pond_name/$pond_vars)
@test "pond load: success exit code" (pond load $pond_name >/dev/null 2>&1) $status -eq $success
@test "pond load: test variable one was set" (echo $TEST_VAR_1) = "test_var_1"
@test "pond load: test variable two was set" (echo $TEST_VAR_2) = "test_var_2"
@test "pond load: test variable three was set" (echo $TEST_VAR_3) = "test_var_3"
__pond_tear_down

@echo "pond load: output tests for regular pond"
__pond_setup_regular
@test "pond load: success output message" (pond load $pond_name 2>&1) = "Loaded pond: $pond_name"
__pond_tear_down

@echo "pond load: success tests for private pond"
__pond_setup_private
@test "setup: pond variables exist" -n (read < $pond_home/$pond_private/$pond_name/$pond_vars)
@test "pond load: success exit code" (pond load $pond_name >/dev/null 2>&1) $status -eq $success
@test "pond load: test variable one was set" (echo $TEST_VAR_PRIVATE_1) = "test_var_private_1"
@test "pond load: test variable two was set" (echo $TEST_VAR_PRIVATE_2) = "test_var_private_2"
@test "pond load: test variable three was set" (echo $TEST_VAR_PRIVATE_3) = "test_var_private_3"
__pond_tear_down

@echo "pond load: output tests for private pond"
__pond_setup_private
@test "pond load: success output message" (pond load $pond_name 2>&1) = "Loaded private pond: $pond_name"
__pond_tear_down

@echo "pond load: validation failure exit code tests"
@test "pond load: fails for missing pond name" (pond load >/dev/null 2>&1) $status -eq $fail
@test "pond load: fails for trailing arguments" (pond load $pond_name trailing >/dev/null 2>&1) $status -eq $fail
@test "pond load: fails for malformed pond name" (pond load _invalid >/dev/null 2>&1) $status -eq $fail
@test "pond load: fails for non-existent pond" (pond load no-exist >/dev/null 2>&1) $status -eq $fail

@echo "pond load: validation failure output tests"
@test "pond load: command usage shown for missing pond name" (pond load 2>&1 | string collect) = $command_usage
@test "pond load: command usage shown for trailing arguments" (pond load $pond_name trailing 2>&1 | string collect) = $command_usage
@test "pond load: command usage shown for malformed pond name" (pond load _invalid 2>&1 | string collect) = $command_usage
@test "pond load: command usage shown for non-existent pond" (pond load no-exist 2>&1 | string collect) = "Pond does not exist: no-exist"

set -e __pond_setup_regular
set -e __pond_setup_private
set -e __pond_tear_down
set -e __pond_under_test
