set fail 1
set success 0

set -x __pond_under_test yes
set pond_name test-pond

set success_output_regular_enabled_pond "\
name: $pond_name
enabled: yes
private: no
path: $pond_home/$pond_regular/$pond_name"

set success_output_private_enabled_pond "\
name: $pond_name
enabled: yes
private: yes
path: $pond_home/$pond_private/$pond_name"

set success_output_regular_disabled_pond "\
name: $pond_name
enabled: no
private: no
path: $pond_home/$pond_regular/$pond_name"

set success_output_private_disabled_pond "\
name: $pond_name
enabled: no
private: yes
path: $pond_home/$pond_private/$pond_name"

set command_usage "\
Usage:
    pond status <name>

Arguments:
    name  The name of the pond"

function __pond_setup_regular_enabled_pond
    pond create -e $pond_name >/dev/null 2>&1
    pond enable $pond_name >/dev/null 2>&1
end

function __pond_setup_private_enabled_pond
    pond create -e -p $pond_name >/dev/null 2>&1
    pond enable $pond_name >/dev/null 2>&1
end

function __pond_setup_regular_disabled_pond
    pond create -e $pond_name >/dev/null 2>&1
    pond disable $pond_name >/dev/null 2>&1
end

function __pond_setup_private_disabled_pond
    pond create -e -p $pond_name >/dev/null 2>&1
    pond disable $pond_name >/dev/null 2>&1
end

function __pond_tear_down
    echo "y" | pond remove $pond_name >/dev/null 2>&1
end

@echo "pond status $pond_name: success tests for regular enabled pond"
__pond_setup_regular_enabled_pond
@test "pond status: success exit code" (pond status $pond_name >/dev/null 2>&1) $status -eq $success
@test "pond status: output success" (pond status $pond_name 2>&1 | string collect) = $success_output_regular_enabled_pond
__pond_tear_down

@echo "pond status $pond_name: success tests for private enabled pond"
__pond_setup_private_enabled_pond
@test "pond status: success exit code" (pond status $pond_name >/dev/null 2>&1) $status -eq $success
@test "pond status: output success" (pond status $pond_name 2>&1 | string collect) = $success_output_private_enabled_pond
__pond_tear_down

@echo "pond status $pond_name: success tests for regular disabled pond"
__pond_setup_regular_disabled_pond
@test "pond status: success exit code" (pond status $pond_name >/dev/null 2>&1) $status -eq $success
@test "pond status: output success" (pond status $pond_name 2>&1 | string collect) = $success_output_regular_disabled_pond
__pond_tear_down

@echo "pond status $pond_name: success tests for private disabled pond"
__pond_setup_private_disabled_pond
@test "pond status: success exit code" (pond status $pond_name >/dev/null 2>&1) $status -eq $success
@test "pond status: output success" (pond status $pond_name 2>&1 | string collect) = $success_output_private_disabled_pond
__pond_tear_down

@echo "pond status: validation failure exit code tests"
@test "pond status: fails for missing pond name" (pond status >/dev/null 2>&1) $status -eq $fail
@test "pond status: fails for trailing arguments" (pond status $pond_name trailing >/dev/null 2>&1) $status -eq $fail
@test "pond status: fails for malformed pond name" (pond status _invalid >/dev/null 2>&1) $status -eq $fail
@test "pond status: fails for non-existent pond" (pond status no-exist >/dev/null 2>&1) $status -eq $fail

@echo "pond status: validation failure output tests"
@test "pond status: command usage shown for missing pond name" (pond status 2>&1 | string collect) = $command_usage
@test "pond status: command usage shown for trailing arguments" (pond status $pond_name trailing 2>&1 | string collect) = $command_usage
@test "pond status: command usage shown for malformed pond name" (pond status _invalid 2>&1 | string collect) = $command_usage
@test "pond status: command error shown for non-existent pond" (pond status no-exist 2>&1 | string collect) = "Pond does not exist: no-exist"

set -e __pond_setup_regular_enabled_pond
set -e __pond_setup_private_enabled_pond
set -e __pond_setup_regular_disabled_pond
set -e __pond_setup_private_disabled_pond
set -e __pond_under_test
