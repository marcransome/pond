source ./helpers/functions.fish
source ./helpers/variables.fish

@echo "pond init: success tests for regular enabled pond"
__pond_setup 1 regular enabled populated
@test "setup: pond enabled" -L $pond_home/$pond_links/$pond_name_regular
@test "pond init: success exit code" (__pond_init) $status -eq $success
@test "pond init: test variable one is set" (echo $TEST_POND_1_VAR_1) = (string lower $TEST_POND_1_VAR_1)
@test "pond init: test variable two is set" (echo $TEST_POND_1_VAR_2) = (string lower $TEST_POND_1_VAR_2)
@test "pond init: test variable three is set" (echo $TEST_POND_1_VAR_3) = (string lower $TEST_POND_1_VAR_3)
__pond_tear_down
__pond_clear_vars 1 regular

@echo "pond init: success tests for private enabled pond"
__pond_setup 1 private enabled populated
@test "setup: pond enabled" -L $pond_home/$pond_links/$pond_name_private
@test "pond init: success exit code" (__pond_init) $status -eq $success
@test "pond init: test variable one is set" (echo $TEST_POND_PRIVATE_1_VAR_1) = (string lower $TEST_POND_PRIVATE_1_VAR_1)
@test "pond init: test variable two is set" (echo $TEST_POND_PRIVATE_1_VAR_2) = (string lower $TEST_POND_PRIVATE_1_VAR_2)
@test "pond init: test variable three is set" (echo $TEST_POND_PRIVATE_1_VAR_3) = (string lower $TEST_POND_PRIVATE_1_VAR_3)
__pond_tear_down
__pond_clear_vars 1 private

@echo "pond init: success tests for regular disabled pond"
__pond_setup 1 regular disabled populated
@test "setup: pond disabled" ! -L $pond_home/$pond_links/$pond_name_regular
@test "pond init: success exit code" (__pond_init) $status -eq $success
@test "pond init: test variable one is not set" (set -q TEST_POND_1_VAR_1) $status -eq $fail
@test "pond init: test variable two is not set" (set -q TEST_POND_1_VAR_2) $status -eq $fail
@test "pond init: test variable three is not set" (set -q TEST_POND_1_VAR_3) $status -eq $fail
__pond_tear_down
__pond_clear_vars 1 regular

@echo "pond init: success tests for private disabled pond"
__pond_setup 1 private disabled populated
@test "setup: pond disabled" ! -L $pond_home/$pond_links/$pond_name_private
@test "pond init: success exit code" (__pond_init) $status -eq $success
@test "pond init: test variable one is not set" (set -q TEST_POND_PRIVATE_1_VAR_1) $status -eq $fail
@test "pond init: test variable two is not set" (set -q TEST_POND_PRIVATE_1_VAR_2) $status -eq $fail
@test "pond init: test variable three is not set" (set -q TEST_POND_PRIVATE_1_VAR_3) $status -eq $fail
__pond_tear_down
__pond_clear_vars 1 private
