set fail 1
set success 0

set -x __pond_under_test yes
set pond_name test-pond

function __pond_setup_regular
    pond create -e $pond_name >/dev/null 2>&1
    for var in TEST_VAR_{1,2,3}
        echo "set -xg $var "(string lower $var) >> $pond_home/$pond_regular/$pond_name/$pond_vars
    end
end

function __pond_setup_private
    pond create -e -p $pond_name >/dev/null 2>&1
    for var in TEST_VAR_PRIVATE_{1,2,3}
        echo "set -xg $var "(string lower $var) >> $pond_home/$pond_private/$pond_name/$pond_vars
    end
end

function __pond_clear_vars
    for var in TEST_VAR_{,PRIVATE_}{1,2,3}
        set -e $var
    end
end

function __pond_disable
    pond disable $pond_name >/dev/null 2>&1
end

function __pond_tear_down
    pond remove -s $pond_name >/dev/null 2>&1
end

@echo "pond init: success tests for enabled regular pond"
__pond_setup_regular
@test "setup: pond enabled" -L $pond_home/$pond_links/$pond_name
@test "pond init: success exit code" (__pond_init) $status -eq $success
@test "pond init: test variable one is set" (echo $TEST_VAR_1) = "test_var_1"
@test "pond init: test variable two is set" (echo $TEST_VAR_2) = "test_var_2"
@test "pond init: test variable three is set" (echo $TEST_VAR_3) = "test_var_3"
__pond_tear_down
__pond_clear_vars


@echo "pond init: success tests for enabled private pond"
__pond_setup_private
@test "setup: pond enabled" -L $pond_home/$pond_links/$pond_name
@test "pond init: success exit code" (__pond_init) $status -eq $success
@test "pond init: test variable one is set" (echo $TEST_VAR_PRIVATE_1) = "test_var_private_1"
@test "pond init: test variable two is set" (echo $TEST_VAR_PRIVATE_2) = "test_var_private_2"
@test "pond init: test variable three is set" (echo $TEST_VAR_PRIVATE_3) = "test_var_private_3"
__pond_tear_down
__pond_clear_vars

@echo "pond init: success tests for disabled regular pond"
__pond_setup_regular
__pond_disable
@test "setup: pond disabled" ! -L $pond_home/$pond_links/$pond_name
@test "pond init: success exit code" (__pond_init) $status -eq $success
@test "pond init: test variable one is not set" (set -q TEST_VAR_1) $status -eq 1
@test "pond init: test variable two is not set" (set -q TEST_VAR_2) $status -eq 1
@test "pond init: test variable three is not set" (set -q TEST_VAR_3) $status -eq 1
__pond_tear_down
__pond_clear_vars

@echo "pond init: success tests for disabled private pond"
__pond_setup_private
__pond_disable
@test "setup: pond disabled" ! -L $pond_home/$pond_links/$pond_name
@test "pond init: success exit code" (__pond_init) $status -eq $success
@test "pond init: test variable one is not set" (set -q TEST_VAR_PRIVATE_1) $status -eq 1
@test "pond init: test variable two is not set" (set -q TEST_VAR_PRIVATE_2) $status -eq 1
@test "pond init: test variable three is not set" (set -q TEST_VAR_PRIVATE_3) $status -eq 1
__pond_tear_down
__pond_clear_vars

set -e __pond_setup_regular
set -e __pond_setup_private
set -e __pond_clear_vars
set -e __pond_disable
set -e __pond_tear_down
set -e __pond_under_test
