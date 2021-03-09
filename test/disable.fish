source ./helpers/functions.fish
source ./helpers/variables.fish

set pond_enable_on_create_before_test $pond_enable_on_create

set command_usage "\
Usage:
    pond disable <name>

Arguments:
    name  The name of the pond to disable"

function __pond_disabled_event_intercept --on-event pond_disabled -a got_pond_name got_pond_path
    set -g event_pond_name $got_pond_name
    set -g event_pond_path $got_pond_path
end

function __pond_disabled_event_reset
    set -e event_pond_name
    set -e event_pond_path
end

@echo "pond disable: success tests for regular pond"
__pond_setup 1 regular enabled unpopulated
@test "setup: pond enabled" -L $pond_home/$pond_links/$pond_name_regular
@test "pond disable: success exit code" (pond disable $pond_name_regular >/dev/null 2>&1) $status -eq $success
@test "pond disable: pond symlink removed" ! -L $pond_home/$pond_links/$pond_name_regular
@test "pond disable: got pond name in event" (echo $event_pond_name) = $pond_name_regular
@test "pond disable: got pond path in event" (echo $event_pond_path) = $pond_home/$pond_regular/$pond_name_regular
__pond_tear_down
__pond_disabled_event_reset

@echo "pond disable: output tests for regular pond"
__pond_setup 1 regular enabled unpopulated
@test "pond disable: success output message" (pond disable $pond_name_regular 2>&1) = "Disabled pond: $pond_name_regular"
__pond_tear_down
__pond_disabled_event_reset

@echo "pond disable: success tests for private pond"
__pond_setup 1 private enabled unpopulated
@test "setup: pond enabled" -L $pond_home/$pond_links/$pond_name_private
@test "pond disable: success exit code" (pond disable $pond_name_private >/dev/null 2>&1) $status -eq $success
@test "pond disable: pond symlink removed" ! -L $pond_home/$pond_links/$pond_name_private
@test "pond disable: got pond name in event" (echo $event_pond_name) = $pond_name_private
@test "pond disable: got pond path in event" (echo $event_pond_path) = $pond_home/$pond_private/$pond_name_private
__pond_tear_down
__pond_disabled_event_reset

@echo "pond disable: output tests for private pond"
__pond_setup 1 private enabled unpopulated
@test "pond disable: success output message" (pond disable $pond_name_private 2>&1) = "Disabled private pond: $pond_name_private"
__pond_tear_down
__pond_disabled_event_reset

@echo "pond disable: failure tests for disabled regular pond"
__pond_setup 1 regular disabled unpopulated
@test "setup: pond disabled" ! -L $pond_home/$pond_links/$pond_name_regular
@test "pond disable: command error shown for disabled regular pond" (pond disable $pond_name_regular 2>&1 | string collect) = "Pond already disabled: $pond_name_regular"
__pond_tear_down

@echo "pond disable: failure tests for disabled private pond"
__pond_setup 1 private disabled unpopulated
@test "setup: pond disabled" ! -L $pond_home/$pond_links/$pond_name_private
@test "pond disable: command error shown for disabled private pond" (pond disable $pond_name_private 2>&1 | string collect) = "Pond already disabled: $pond_name_private"
__pond_tear_down

@echo "pond disable: validation failure exit code tests"
@test "pond disable: fails for missing pond name" (pond disable >/dev/null 2>&1) $status -eq $fail
@test "pond disable: fails for trailing arguments" (pond disable $pond_name_regular trailing >/dev/null 2>&1) $status -eq $fail
@test "pond disable: fails for malformed pond name" (pond disable _invalid >/dev/null 2>&1) $status -eq $fail
@test "pond disable: fails for non-existent pond" (pond disable no-exist >/dev/null 2>&1) $status -eq $fail

@echo "pond disable: validation failure output tests"
@test "pond disable: command usage shown for missing pond name" (pond disable 2>&1 | string collect) = $command_usage
@test "pond disable: command usage shown for trailing arguments" (pond disable $pond_name_regular trailing 2>&1 | string collect) = $command_usage
@test "pond disable: command usage shown for malformed pond name" (pond disable _invalid 2>&1 | string collect) = $command_usage
@test "pond disable: command error shown for non-existent pond" (pond disable no-exist 2>&1 | string collect) = "Pond does not exist: no-exist"

set pond_enable_on_create $pond_enable_on_create_before_test
