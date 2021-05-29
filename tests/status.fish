source ./fixtures/functions.fish
source ./fixtures/variables.fish

set success_output_single_pond_enabled "\
name: $pond_name
enabled: yes
path: $pond_home/$pond_name"

set success_output_single_pond_disabled "\
name: $pond_name
enabled: no
path: $pond_home/$pond_name"

set success_output_multiple_ponds_enabled "\
name: $pond_name_prefix-1
enabled: yes
path: $pond_home/$pond_name_prefix-1
name: $pond_name_prefix-2
enabled: yes
path: $pond_home/$pond_name_prefix-2
name: $pond_name_prefix-3
enabled: yes
path: $pond_home/$pond_name_prefix-3"

set success_output_multiple_ponds_disabled "\
name: $pond_name_prefix-1
enabled: no
path: $pond_home/$pond_name_prefix-1
name: $pond_name_prefix-2
enabled: no
path: $pond_home/$pond_name_prefix-2
name: $pond_name_prefix-3
enabled: no
path: $pond_home/$pond_name_prefix-3"

set command_usage "\
Usage:
    pond status [ponds...]

Arguments:
    name  The name of one or more ponds"

@echo "pond status: success tests for global status (0 ponds)"
@test "pond status: success exit code" (pond status >/dev/null 2>&1) $status -eq $success
@test "pond status: output success" (pond status 2>&1 | string collect) = "0 ponds, 0 enabled"

@echo "pond status: success tests for global status (single enabled pond)"
__pond_setup 1 enabled unpopulated
@test "pond status: success exit code" (pond status >/dev/null 2>&1) $status -eq $success
@test "pond status: output success" (pond status 2>&1 | string collect) = "1 pond, 1 enabled"
__pond_tear_down

@echo "pond status: success tests for global status (single disabled pond)"
__pond_setup 1 disabled unpopulated
@test "pond status: success exit code" (pond status >/dev/null 2>&1) $status -eq $success
@test "pond status: output success" (pond status 2>&1 | string collect) = "1 pond, 0 enabled"
__pond_tear_down

@echo "pond status: success tests for global status (multiple enabled ponds)"
__pond_setup 3 enabled unpopulated
@test "pond status: success exit code" (pond status >/dev/null 2>&1) $status -eq $success
@test "pond status: output success" (pond status 2>&1 | string collect) = "3 ponds, 3 enabled"
__pond_tear_down

@echo "pond status: success tests for global status (multiple disabled ponds)"
__pond_setup 3 disabled unpopulated
@test "pond status: success exit code" (pond status >/dev/null 2>&1) $status -eq $success
@test "pond status: output success" (pond status 2>&1 | string collect) = "3 ponds, 0 enabled"
__pond_tear_down

@echo "pond status $pond_name: success tests for single enabled pond"
__pond_setup 1 enabled unpopulated
@test "pond status: success exit code" (pond status $pond_name >/dev/null 2>&1) $status -eq $success
@test "pond status: output success" (pond status $pond_name 2>&1 | string collect) = $success_output_single_pond_enabled
__pond_tear_down

@echo "pond status $pond_name: success tests for single disabled pond"
__pond_setup 1 disabled unpopulated
@test "pond status: success exit code" (pond status $pond_name >/dev/null 2>&1) $status -eq $success
@test "pond status: output success" (pond status $pond_name 2>&1 | string collect) = $success_output_single_pond_disabled
__pond_tear_down

@echo "pond status $pond_name_prefix-1 $pond_name_prefix-2 $pond_name_prefix-3: success tests for multiple enabled ponds"
__pond_setup 3 enabled unpopulated
@test "pond status: success exit code" (pond status $pond_name_prefix-1 $pond_name_prefix-2 $pond_name_prefix-3 >/dev/null 2>&1) $status -eq $success
@test "pond status: output success" (pond status $pond_name_prefix-1 $pond_name_prefix-2 $pond_name_prefix-3 2>&1 | string collect) = $success_output_multiple_ponds_enabled
__pond_tear_down

@echo "pond status $pond_name_prefix-1 $pond_name_prefix-2 $pond_name_prefix-3: success tests for multiple disabled ponds"
__pond_setup 3 disabled unpopulated
@test "pond status: success exit code" (pond status $pond_name_prefix-1 $pond_name_prefix-2 $pond_name_prefix-3 >/dev/null 2>&1) $status -eq $success
@test "pond status: output success" (pond status $pond_name_prefix-1 $pond_name_prefix-2 $pond_name_prefix-3 2>&1 | string collect) = $success_output_multiple_ponds_disabled
__pond_tear_down

@echo "pond status: validation failure exit code tests"
@test "pond status: fails for malformed pond name" (pond status _invalid >/dev/null 2>&1) $status -eq $fail
@test "pond status: fails for non-existent pond" (pond status no-exist >/dev/null 2>&1) $status -eq $fail

@echo "pond status: validation failure output tests"
@test "pond status: command usage shown for malformed pond name" (pond status _invalid 2>&1 | string collect) = $command_usage
@test "pond status: command error shown for non-existent pond" (pond status no-exist 2>&1 | string collect) = "Pond does not exist: no-exist"
