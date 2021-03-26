source ./helpers/functions.fish
source ./helpers/variables.fish

set success_output_single_regular_enabled "\
name: $pond_name_regular
enabled: yes
private: no
path: $pond_home/$pond_regular/$pond_name_regular"

set success_output_single_private_enabled "\
name: $pond_name_private
enabled: yes
private: yes
path: $pond_home/$pond_private/$pond_name_private"

set success_output_single_regular_disabled "\
name: $pond_name_regular
enabled: no
private: no
path: $pond_home/$pond_regular/$pond_name_regular"

set success_output_single_private_disabled "\
name: $pond_name_private
enabled: no
private: yes
path: $pond_home/$pond_private/$pond_name_private"

set success_output_multiple_regular_enabled "\
name: $pond_name_regular_prefix-1
enabled: yes
private: no
path: $pond_home/$pond_regular/$pond_name_regular_prefix-1
name: $pond_name_regular_prefix-2
enabled: yes
private: no
path: $pond_home/$pond_regular/$pond_name_regular_prefix-2
name: $pond_name_regular_prefix-3
enabled: yes
private: no
path: $pond_home/$pond_regular/$pond_name_regular_prefix-3"

set success_output_multiple_private_enabled "\
name: $pond_name_private_prefix-1
enabled: yes
private: yes
path: $pond_home/$pond_private/$pond_name_private_prefix-1
name: $pond_name_private_prefix-2
enabled: yes
private: yes
path: $pond_home/$pond_private/$pond_name_private_prefix-2
name: $pond_name_private_prefix-3
enabled: yes
private: yes
path: $pond_home/$pond_private/$pond_name_private_prefix-3"

set success_output_multiple_regular_disabled "\
name: $pond_name_regular_prefix-1
enabled: no
private: no
path: $pond_home/$pond_regular/$pond_name_regular_prefix-1
name: $pond_name_regular_prefix-2
enabled: no
private: no
path: $pond_home/$pond_regular/$pond_name_regular_prefix-2
name: $pond_name_regular_prefix-3
enabled: no
private: no
path: $pond_home/$pond_regular/$pond_name_regular_prefix-3"

set success_output_multiple_private_disabled "\
name: $pond_name_private_prefix-1
enabled: no
private: yes
path: $pond_home/$pond_private/$pond_name_private_prefix-1
name: $pond_name_private_prefix-2
enabled: no
private: yes
path: $pond_home/$pond_private/$pond_name_private_prefix-2
name: $pond_name_private_prefix-3
enabled: no
private: yes
path: $pond_home/$pond_private/$pond_name_private_prefix-3"

set command_usage "\
Usage:
    pond status [ponds...]

Arguments:
    name  The name of one or more ponds"

@echo "pond status $pond_name_regular: success tests for global status (0 ponds)"
@test "pond status: success exit code" (pond status >/dev/null 2>&1) $status -eq $success
@test "pond status: output success" (pond status 2>&1 | string collect) = "0 ponds, 0 enabled"

@echo "pond status $pond_name_regular: success tests for global status (1 regular enabled pond)"
__pond_setup 1 regular enabled unpopulated
@test "pond status: success exit code" (pond status >/dev/null 2>&1) $status -eq $success
@test "pond status: output success" (pond status 2>&1 | string collect) = "1 pond, 1 enabled"
__pond_tear_down

@echo "pond status $pond_name_regular: success tests for global status (1 regular disabled pond)"
__pond_setup 1 regular disabled unpopulated
@test "pond status: success exit code" (pond status >/dev/null 2>&1) $status -eq $success
@test "pond status: output success" (pond status 2>&1 | string collect) = "1 pond, 0 enabled"
__pond_tear_down

@echo "pond status $pond_name_regular: success tests for global status (1 private enabled pond)"
__pond_setup 1 private enabled unpopulated
@test "pond status: success exit code" (pond status >/dev/null 2>&1) $status -eq $success
@test "pond status: output success" (pond status 2>&1 | string collect) = "1 pond, 1 enabled"
__pond_tear_down

@echo "pond status $pond_name_regular: success tests for global status (1 private disabled pond)"
__pond_setup 1 private disabled unpopulated
@test "pond status: success exit code" (pond status >/dev/null 2>&1) $status -eq $success
@test "pond status: output success" (pond status 2>&1 | string collect) = "1 pond, 0 enabled"
__pond_tear_down

@echo "pond status $pond_name_regular: success tests for global status (multiple regular enabled ponds)"
__pond_setup 3 regular enabled unpopulated
@test "pond status: success exit code" (pond status >/dev/null 2>&1) $status -eq $success
@test "pond status: output success" (pond status 2>&1 | string collect) = "3 ponds, 3 enabled"
__pond_tear_down

@echo "pond status $pond_name_regular: success tests for global status (multiple regular disabled ponds)"
__pond_setup 3 regular disabled unpopulated
@test "pond status: success exit code" (pond status >/dev/null 2>&1) $status -eq $success
@test "pond status: output success" (pond status 2>&1 | string collect) = "3 ponds, 0 enabled"
__pond_tear_down

@echo "pond status $pond_name_regular: success tests for global status (multiple private enabled ponds)"
__pond_setup 3 private enabled unpopulated
@test "pond status: success exit code" (pond status >/dev/null 2>&1) $status -eq $success
@test "pond status: output success" (pond status 2>&1 | string collect) = "3 ponds, 3 enabled"
__pond_tear_down

@echo "pond status $pond_name_regular: success tests for global status (multiple private disabled ponds)"
__pond_setup 3 private disabled unpopulated
@test "pond status: success exit code" (pond status >/dev/null 2>&1) $status -eq $success
@test "pond status: output success" (pond status 2>&1 | string collect) = "3 ponds, 0 enabled"
__pond_tear_down

@echo "pond status $pond_name_regular: success tests for regular enabled pond"
__pond_setup 1 regular enabled unpopulated
@test "pond status: success exit code" (pond status $pond_name_regular >/dev/null 2>&1) $status -eq $success
@test "pond status: output success" (pond status $pond_name_regular 2>&1 | string collect) = $success_output_single_regular_enabled
__pond_tear_down

@echo "pond status $pond_name_regular: success tests for regular disabled pond"
__pond_setup 1 regular disabled unpopulated
@test "pond status: success exit code" (pond status $pond_name_regular >/dev/null 2>&1) $status -eq $success
@test "pond status: output success" (pond status $pond_name_regular 2>&1 | string collect) = $success_output_single_regular_disabled
__pond_tear_down

@echo "pond status $pond_name_private: success tests for private enabled pond"
__pond_setup 1 private enabled unpopulated
@test "pond status: success exit code" (pond status $pond_name_private >/dev/null 2>&1) $status -eq $success
@test "pond status: output success" (pond status $pond_name_private 2>&1 | string collect) = $success_output_single_private_enabled
__pond_tear_down

@echo "pond status $pond_name_private: success tests for private disabled pond"
__pond_setup 1 private disabled unpopulated
@test "pond status: success exit code" (pond status $pond_name_private >/dev/null 2>&1) $status -eq $success
@test "pond status: output success" (pond status $pond_name_private 2>&1 | string collect) = $success_output_single_private_disabled
__pond_tear_down

@echo "pond status $pond_name_regular: success tests for multiple regular enabled ponds"
__pond_setup 3 regular enabled unpopulated
@test "pond status: success exit code" (pond status $pond_name_regular_prefix-1 $pond_name_regular_prefix-2 $pond_name_regular_prefix-3 >/dev/null 2>&1) $status -eq $success
@test "pond status: output success" (pond status $pond_name_regular_prefix-1 $pond_name_regular_prefix-2 $pond_name_regular_prefix-3 2>&1 | string collect) = $success_output_multiple_regular_enabled
__pond_tear_down

@echo "pond status $pond_name_regular: success tests for multiple regular disabled ponds"
__pond_setup 3 regular disabled unpopulated
@test "pond status: success exit code" (pond status $pond_name_regular_prefix-1 $pond_name_regular_prefix-2 $pond_name_regular_prefix-3 >/dev/null 2>&1) $status -eq $success
@test "pond status: output success" (pond status $pond_name_regular_prefix-1 $pond_name_regular_prefix-2 $pond_name_regular_prefix-3 2>&1 | string collect) = $success_output_multiple_regular_disabled
__pond_tear_down

@echo "pond status $pond_name_private: success tests for multiple private enabled ponds"
__pond_setup 3 private enabled unpopulated
@test "pond status: success exit code" (pond status $pond_name_private_prefix-1 $pond_name_private_prefix-2 $pond_name_private_prefix-3 >/dev/null 2>&1) $status -eq $success
@test "pond status: output success" (pond status $pond_name_private_prefix-1 $pond_name_private_prefix-2 $pond_name_private_prefix-3 2>&1 | string collect) = $success_output_multiple_private_enabled
__pond_tear_down

@echo "pond status $pond_name_private: success tests for multiple private disabled ponds"
__pond_setup 3 private disabled unpopulated
@test "pond status: success exit code" (pond status $pond_name_private_prefix-1 $pond_name_private_prefix-2 $pond_name_private_prefix-3 >/dev/null 2>&1) $status -eq $success
@test "pond status: output success" (pond status $pond_name_private_prefix-1 $pond_name_private_prefix-2 $pond_name_private_prefix-3 2>&1 | string collect) = $success_output_multiple_private_disabled
__pond_tear_down

@echo "pond status: validation failure exit code tests"
@test "pond status: fails for malformed pond name" (pond status _invalid >/dev/null 2>&1) $status -eq $fail
@test "pond status: fails for non-existent pond" (pond status no-exist >/dev/null 2>&1) $status -eq $fail

@echo "pond status: validation failure output tests"
@test "pond status: command usage shown for malformed pond name" (pond status _invalid 2>&1 | string collect) = $command_usage
@test "pond status: command error shown for non-existent pond" (pond status no-exist 2>&1) = (set_color red; and echo -n "Error: "; and set_color normal; and echo "Pond does not exist: no-exist")
