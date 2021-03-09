source ./helpers/functions.fish
source ./helpers/variables.fish

set pond_enable_on_create_before_test $pond_enable_on_create

set command_usage "\
Usage:
    pond enable <name>

Arguments:
    name  The name of the pond to enable"

function __pond_enabled_event_intercept --on-event pond_enabled -a got_pond_name got_pond_path
    set -g event_pond_name $got_pond_name
    set -g event_pond_path $got_pond_path
end

@echo "pond enable: success tests for regular pond"
__pond_setup 1 regular disabled unpopulated
@test "setup: pond disabled" ! -L $pond_home/$pond_links/$pond_name_regular
@test "pond enable: success exit code" (pond enable $pond_name_regular >/dev/null 2>&1) $status -eq $success
@test "pond enable: pond symlink created" -L $pond_home/$pond_links/$pond_name_regular
@test "pond enable: symlink valid" (readlink $pond_home/$pond_links/$pond_name_regular) = "$pond_home/$pond_regular/$pond_name_regular"
@test "pond enable: got pond name in event" (echo $event_pond_name) = $pond_name_regular
@test "pond enable: got pond path in event" (echo $event_pond_path) = $pond_home/$pond_regular/$pond_name_regular
__pond_tear_down
__pond_event_reset

@echo "pond enable: output tests for regular pond"
__pond_setup 1 regular disabled unpopulated
@test "pond enable: success output message" (pond enable $pond_name_regular 2>&1) = "Enabled pond: $pond_name_regular"
__pond_tear_down
__pond_event_reset

@echo "pond enable: success tests for private pond"
__pond_setup 1 private disabled unpopulated
@test "setup: pond disabled" ! -L $pond_home/$pond_links/$pond_name_private
@test "pond enable: success exit code" (pond enable $pond_name_private >/dev/null 2>&1) $status -eq $success
@test "pond enable: pond symlink created" -L $pond_home/$pond_links/$pond_name_private
@test "pond enable: symlink valid" (readlink $pond_home/$pond_links/$pond_name_private) = "$pond_home/$pond_private/$pond_name_private"
@test "pond enable: got pond name in event" (echo $event_pond_name) = $pond_name_private
@test "pond enable: got pond path in event" (echo $event_pond_path) = $pond_home/$pond_private/$pond_name_private
__pond_tear_down
__pond_event_reset

@echo "pond enable: output tests for private pond"
__pond_setup 1 private disabled unpopulated
@test "pond enable: success output message" (pond enable $pond_name_private 2>&1) = "Enabled private pond: $pond_name_private"
__pond_tear_down
__pond_event_reset

@echo "pond enable: failure tests for regular enabled pond"
__pond_setup 1 regular enabled unpopulated
ln -s $pond_home/$pond_regular/$pond_name_regular $pond_home/$pond_links/$pond_name_regular
@test "setup: pond enabled" -L $pond_home/$pond_links/$pond_name_regular
@test "pond enable: command error shown for regular enabled pond" (pond enable $pond_name_regular 2>&1 | string collect) = "Pond already enabled: $pond_name_regular"
__pond_tear_down

@echo "pond enable: failure tests for private enabled pond"
__pond_setup 1 private enabled unpopulated
ln -s $pond_home/$pond_private/$pond_name_private $pond_home/$pond_links/$pond_name_private
@test "setup: pond enabled" -L $pond_home/$pond_links/$pond_name_private
@test "pond enable: command error shown for private enabled pond" (pond enable $pond_name_private 2>&1 | string collect) = "Pond already enabled: $pond_name_private"
__pond_tear_down

@echo "pond enable: validation failure exit code tests"
@test "pond enable: fails for missing pond name" (pond enable >/dev/null 2>&1) $status -eq $fail
@test "pond enable: fails for trailing arguments" (pond enable $pond_name_regular trailing >/dev/null 2>&1) $status -eq $fail
@test "pond enable: fails for malformed pond name" (pond enable _invalid >/dev/null 2>&1) $status -eq $fail
@test "pond enable: fails for non-existent pond" (pond enable no-exist >/dev/null 2>&1) $status -eq $fail

@echo "pond enable: validation failure output tests"
@test "pond enable: command usage shown for missing pond name" (pond enable 2>&1 | string collect) = $command_usage
@test "pond enable: command usage shown for trailing arguments" (pond enable $pond_name_regular trailing 2>&1 | string collect) = $command_usage
@test "pond enable: command usage shown for malformed pond name" (pond enable _invalid 2>&1 | string collect) = $command_usage
@test "pond enable: command error shown for non-existent pond" (pond enable no-exist 2>&1 | string collect) = "Pond does not exist: no-exist"

set pond_enable_on_create $pond_enable_on_create_before_test
