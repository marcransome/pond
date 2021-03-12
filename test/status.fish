source ./helpers/functions.fish
source ./helpers/variables.fish

set success_output_regular_enabled_pond "\
name: $pond_name_regular
enabled: yes
private: no
path: $pond_home/$pond_regular/$pond_name_regular"

set success_output_private_enabled_pond "\
name: $pond_name_private
enabled: yes
private: yes
path: $pond_home/$pond_private/$pond_name_private"

set success_output_regular_disabled_pond "\
name: $pond_name_regular
enabled: no
private: no
path: $pond_home/$pond_regular/$pond_name_regular"

set success_output_private_disabled_pond "\
name: $pond_name_private
enabled: no
private: yes
path: $pond_home/$pond_private/$pond_name_private"

set command_usage "\
Usage:
    pond status <name>

Arguments:
    name  The name of the pond"

@echo "pond status $pond_name_regular: success tests for regular enabled pond"
__pond_setup 1 regular enabled unpopulated
@test "pond status: success exit code" (pond status $pond_name_regular >/dev/null 2>&1) $status -eq $success
@test "pond status: output success" (pond status $pond_name_regular 2>&1 | string collect) = $success_output_regular_enabled_pond
__pond_tear_down

@echo "pond status $pond_name_private: success tests for private enabled pond"
__pond_setup 1 private enabled unpopulated
@test "pond status: success exit code" (pond status $pond_name_private >/dev/null 2>&1) $status -eq $success
@test "pond status: output success" (pond status $pond_name_private 2>&1 | string collect) = $success_output_private_enabled_pond
__pond_tear_down

@echo "pond status $pond_name_regular: success tests for regular disabled pond"
__pond_setup 1 regular disabled unpopulated
@test "pond status: success exit code" (pond status $pond_name_regular >/dev/null 2>&1) $status -eq $success
@test "pond status: output success" (pond status $pond_name_regular 2>&1 | string collect) = $success_output_regular_disabled_pond
__pond_tear_down

@echo "pond status $pond_name_private: success tests for private disabled pond"
__pond_setup 1 private disabled unpopulated
@test "pond status: success exit code" (pond status $pond_name_private >/dev/null 2>&1) $status -eq $success
@test "pond status: output success" (pond status $pond_name_private 2>&1 | string collect) = $success_output_private_disabled_pond
__pond_tear_down

@echo "pond status: validation failure exit code tests"
@test "pond status: fails for missing pond name" (pond status >/dev/null 2>&1) $status -eq $fail
@test "pond status: fails for trailing arguments" (pond status $pond_name_regular trailing >/dev/null 2>&1) $status -eq $fail
@test "pond status: fails for malformed pond name" (pond status _invalid >/dev/null 2>&1) $status -eq $fail
@test "pond status: fails for non-existent pond" (pond status no-exist >/dev/null 2>&1) $status -eq $fail

@echo "pond status: validation failure output tests"
@test "pond status: command usage shown for missing pond name" (pond status 2>&1 | string collect) = $command_usage
@test "pond status: command usage shown for trailing arguments" (pond status $pond_name_regular trailing 2>&1 | string collect) = $command_usage
@test "pond status: command usage shown for malformed pond name" (pond status _invalid 2>&1 | string collect) = $command_usage
@test "pond status: command error shown for non-existent pond" (pond status no-exist 2>&1 | string collect) = "Pond does not exist: no-exist"
