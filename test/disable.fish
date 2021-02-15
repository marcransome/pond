set fail 1
set success 0

set -x __pond_under_test yes
set pond_name test-pond
set pond_enable_on_create_before_test $pond_enable_on_create

set command_usage "\
Usage:
    pond disable <name>

Arguments:
    name  The name of the pond to disable"

function __pond_setup_regular
    set pond_enable_on_create yes; and pond create -e $pond_name >/dev/null 2>&1
end

function __pond_setup_private
    set pond_enable_on_create yes; and pond create -e -p $pond_name >/dev/null 2>&1
end

function __pond_tear_down
    echo "y" | pond remove $pond_name >/dev/null 2>&1
end

@echo "pond disable: success tests for regular pond"
__pond_setup_regular
@test "pond setup: pond enabled" -L $pond_home/$pond_links/$pond_name
@test "pond disable: success exit code" (pond disable $pond_name >/dev/null 2>&1) $status -eq $success
@test "pond disable: pond symlink removed" ! -L $pond_home/$pond_links/$pond_name
__pond_tear_down

@echo "pond disable: success tests for private pond"
__pond_setup_private
@test "pond setup: pond enabled" -L $pond_home/$pond_links/$pond_name
@test "pond disable: success exit code" (pond disable $pond_name >/dev/null 2>&1) $status -eq $success
@test "pond disable: pond symlink removed" ! -L $pond_home/$pond_links/$pond_name
__pond_tear_down

@echo "pond disable: validation failure exit code tests"
@test "pond disable: fails for missing pond name" (pond disable >/dev/null 2>&1) $status -eq $fail
@test "pond disable: fails for trailing arguments" (pond disable $pond_name trailing >/dev/null 2>&1) $status -eq $fail
@test "pond disable: fails for malformed pond name" (pond disable _invalid >/dev/null 2>&1) $status -eq $fail
@test "pond disable: fails for non-existent pond" (pond disable no-exist >/dev/null 2>&1) $status -eq $fail

@echo "pond disable: validation failure output tests"
@test "pond disable: command usage shown for missing pond name" (pond disable 2>&1 | string collect) = $command_usage
@test "pond disable: command usage shown for trailing arguments" (pond disable $pond_name trailing 2>&1 | string collect) = $command_usage
@test "pond disable: command usage shown for malformed pond name" (pond disable _invalid 2>&1 | string collect) = $command_usage
@test "pond disable: command error shown for non-existent pond" (pond disable no-exist 2>&1 | string collect) = "Pond does not exist: no-exist"

__pond_setup_regular
unlink $pond_home/$pond_links/$pond_name
@test "pond setup: pond disabled" ! -L $pond_home/$pond_links/$pond_name
@test "pond disable: command error shown for disabled regular pond" (pond disable $pond_name 2>&1 | string collect) = "Pond already disabled: $pond_name"
__pond_tear_down

__pond_setup_private
unlink $pond_home/$pond_links/$pond_name
@test "pond setup: pond disabled" ! -L $pond_home/$pond_links/$pond_name
@test "pond disable: command error shown for disabled private pond" (pond disable $pond_name 2>&1 | string collect) = "Pond already disabled: $pond_name"
__pond_tear_down

set -e __pond_setup_regular
set -e __pond_setup_private
set -e __pond_tear_down
set -e __pond_under_test
set pond_enable_on_create $pond_enable_on_create_before_test
