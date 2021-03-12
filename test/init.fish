source ./helpers/functions.fish
source ./helpers/variables.fish

@echo "pond init: success tests for regular enabled pond"
__pond_setup 1 regular enabled populated
@test "setup: pond enabled" -L $pond_home/$pond_links/$pond_name_regular
@test "pond init: success exit code" (__pond_init) $status -eq $success
@test "pond init: test variable one is set" (echo $TEST_VAR_1) = "test_var_1"
@test "pond init: test variable two is set" (echo $TEST_VAR_2) = "test_var_2"
@test "pond init: test variable three is set" (echo $TEST_VAR_3) = "test_var_3"
__pond_tear_down
__pond_clear_vars

@echo "pond init: success tests for private enabled pond"
__pond_setup 1 private enabled populated
@test "setup: pond enabled" -L $pond_home/$pond_links/$pond_name_private
@test "pond init: success exit code" (__pond_init) $status -eq $success
@test "pond init: test variable one is set" (echo $TEST_VAR_PRIVATE_1) = "test_var_private_1"
@test "pond init: test variable two is set" (echo $TEST_VAR_PRIVATE_2) = "test_var_private_2"
@test "pond init: test variable three is set" (echo $TEST_VAR_PRIVATE_3) = "test_var_private_3"
__pond_tear_down
__pond_clear_vars

@echo "pond init: success tests for regular disabled pond"
__pond_setup 1 regular disabled populated
@test "setup: pond disabled" ! -L $pond_home/$pond_links/$pond_name_regular
@test "pond init: success exit code" (__pond_init) $status -eq $success
@test "pond init: test variable one is not set" (set -q TEST_VAR_1) $status -eq 1
@test "pond init: test variable two is not set" (set -q TEST_VAR_2) $status -eq 1
@test "pond init: test variable three is not set" (set -q TEST_VAR_3) $status -eq 1
__pond_tear_down
__pond_clear_vars

@echo "pond init: success tests for private disabled pond"
__pond_setup 1 private disabled populated
@test "setup: pond disabled" ! -L $pond_home/$pond_links/$pond_name_private
@test "pond init: success exit code" (__pond_init) $status -eq $success
@test "pond init: test variable one is not set" (set -q TEST_VAR_PRIVATE_1) $status -eq 1
@test "pond init: test variable two is not set" (set -q TEST_VAR_PRIVATE_2) $status -eq 1
@test "pond init: test variable three is not set" (set -q TEST_VAR_PRIVATE_3) $status -eq 1
__pond_tear_down
__pond_clear_vars
