set fail 1
set success 0

set -x __pond_under_test yes
set pond_name test-pond
set pond_enable_on_create_before_test $pond_enable_on_create

set command_usage "\
Usage:
    pond enable <name>

Arguments:
    name  The name of the pond to enable"

function __pond_setup_regular
    set pond_enable_on_create no; and pond create -e $pond_name >/dev/null 2>&1
end

function __pond_setup_private
    set pond_enable_on_create no; and pond create -e -p $pond_name >/dev/null 2>&1
end

function __pond_tear_down
    pond remove -s $pond_name >/dev/null 2>&1
end

function __pond_event_intercept --on-event pond_enabled -a got_pond_name got_pond_path
    set -g event_pond_name $got_pond_name
    set -g event_pond_path $got_pond_path
end

function __pond_event_reset
    set -e event_pond_name
    set -e event_pond_path
end

@echo "pond enable: success tests for regular pond"
__pond_setup_regular
@test "pond setup: pond disabled" ! -L $pond_home/$pond_links/$pond_name
@test "pond enable: success exit code" (pond enable $pond_name >/dev/null 2>&1) $status -eq $success
@test "pond enable: pond symlink created" -L $pond_home/$pond_links/$pond_name
@test "pond enable: symlink valid" (readlink $pond_home/$pond_links/$pond_name) = "$pond_home/$pond_regular/$pond_name"
@test "pond enable: got pond name in event" (echo $event_pond_name) = $pond_name
@test "pond enable: got pond path in event" (echo $event_pond_path) = $pond_home/$pond_regular/$pond_name
__pond_tear_down
__pond_event_reset

@echo "pond enable: output tests for regular pond"
__pond_setup_regular
@test "pond enable: success output message" (pond enable $pond_name 2>&1) = "Enabled pond: $pond_name"
__pond_tear_down
__pond_event_reset

@echo "pond enable: success tests for private pond"
__pond_setup_private
@test "pond setup: pond disabled" ! -L $pond_home/$pond_links/$pond_name
@test "pond enable: success exit code" (pond enable $pond_name >/dev/null 2>&1) $status -eq $success
@test "pond enable: pond symlink created" -L $pond_home/$pond_links/$pond_name
@test "pond enable: symlink valid" (readlink $pond_home/$pond_links/$pond_name) = "$pond_home/$pond_private/$pond_name"
@test "pond enable: got pond name in event" (echo $event_pond_name) = $pond_name
@test "pond enable: got pond path in event" (echo $event_pond_path) = $pond_home/$pond_private/$pond_name
__pond_tear_down
__pond_event_reset

@echo "pond enable: output tests for private pond"
__pond_setup_private
@test "pond enable: success output message" (pond enable $pond_name 2>&1) = "Enabled private pond: $pond_name"
__pond_tear_down
__pond_event_reset

@echo "pond enable: validation failure exit code tests"
@test "pond enable: fails for missing pond name" (pond enable >/dev/null 2>&1) $status -eq $fail
@test "pond enable: fails for trailing arguments" (pond enable $pond_name trailing >/dev/null 2>&1) $status -eq $fail
@test "pond enable: fails for malformed pond name" (pond enable _invalid >/dev/null 2>&1) $status -eq $fail
@test "pond enable: fails for non-existent pond" (pond enable no-exist >/dev/null 2>&1) $status -eq $fail

@echo "pond enable: validation failure output tests"
@test "pond enable: command usage shown for missing pond name" (pond enable 2>&1 | string collect) = $command_usage
@test "pond enable: command usage shown for trailing arguments" (pond enable $pond_name trailing 2>&1 | string collect) = $command_usage
@test "pond enable: command usage shown for malformed pond name" (pond enable _invalid 2>&1 | string collect) = $command_usage
@test "pond enable: command error shown for non-existent pond" (pond enable no-exist 2>&1 | string collect) = "Pond does not exist: no-exist"

__pond_setup_regular
ln -s $pond_home/$pond_regular/$pond_name $pond_home/$pond_links/$pond_name
@test "pond setup: pond enabled" -L $pond_home/$pond_links/$pond_name
@test "pond enable: command error shown for enabled regular pond" (pond enable $pond_name 2>&1 | string collect) = "Pond already enabled: $pond_name"
__pond_tear_down

__pond_setup_private
ln -s $pond_home/$pond_private/$pond_name $pond_home/$pond_links/$pond_name
@test "pond setup: pond enabled" -L $pond_home/$pond_links/$pond_name
@test "pond enable: command error shown for enabled private pond" (pond enable $pond_name 2>&1 | string collect) = "Pond already enabled: $pond_name"
__pond_tear_down

set pond_enable_on_create $pond_enable_on_create_before_test
