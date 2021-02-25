set fail 1
set success 0

set -x __pond_under_test yes
set pond_name test-pond

set command_usage "\
Usage:
    pond dir <name>

Arguments:
    name  The name of the pond to change directory to"

function __pond_setup_regular
    pond create -e $pond_name >/dev/null 2>&1
end

function __pond_setup_private
    pond create -e -p $pond_name >/dev/null 2>&1
end

function __pond_tear_down
    pond remove -s $pond_name >/dev/null 2>&1
end

@echo "pond dir $pond_name: success tests for regular pond"
__pond_setup_regular
@test "pond dir: success exit code" (pond dir $pond_name >/dev/null 2>&1) $status -eq $success
@test "pond dir: working directory changed" (pwd) = "$pond_home/$pond_regular/$pond_name"
__pond_tear_down

@echo "pond dir $pond_name: success tests for private pond"
__pond_setup_private
@test "pond dir: success exit code" (pond dir $pond_name >/dev/null 2>&1) $status -eq $success
@test "pond dir: working directory changed" (pwd) = "$pond_home/$pond_private/$pond_name"
__pond_tear_down

@echo "pond dir: validation failure exit code tests"
@test "pond dir: fails for missing pond name" (pond dir >/dev/null 2>&1) $status -eq $fail
@test "pond dir: fails for trailing arguments" (pond dir $pond_name trailing >/dev/null 2>&1) $status -eq $fail
@test "pond dir: fails for malformed pond name" (pond dir _invalid >/dev/null 2>&1) $status -eq $fail
@test "pond dir: fails for non-existent pond" (pond dir no-exist >/dev/null 2>&1) $status -eq $fail

@echo "pond dir: validation failure output tests"
@test "pond dir: command usage shown for missing pond name" (pond dir 2>&1 | string collect) = $command_usage
@test "pond dir: command usage shown for trailing arguments" (pond dir $pond_name trailing 2>&1 | string collect) = $command_usage
@test "pond dir: command usage shown for malformed pond name" (pond dir _invalid 2>&1 | string collect) = $command_usage
@test "pond dir: command error shown for non-existent pond" (pond dir no-exist 2>&1 | string collect) = "Pond does not exist: no-exist"