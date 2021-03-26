source ./helpers/functions.fish
source ./helpers/variables.fish

set pond_enable_on_create_before_test $pond_enable_on_create

set command_usage "\
Usage:
    pond enable ponds...

Arguments:
    ponds  The name of one or more ponds to enable"

set success_output_single_regular "\
Enabled pond: $pond_name_regular"

set success_output_single_private "\
Enabled private pond: $pond_name_private"

set success_output_multiple_regular "\
Enabled pond: $pond_name_regular_prefix-1
Enabled pond: $pond_name_regular_prefix-2
Enabled pond: $pond_name_regular_prefix-3"

set success_output_multiple_private "\
Enabled private pond: $pond_name_private_prefix-1
Enabled private pond: $pond_name_private_prefix-2
Enabled private pond: $pond_name_private_prefix-3"

function __pond_enabled_event_intercept --on-event pond_enabled -a got_pond_name got_pond_path
    set -ga event_pond_names $got_pond_name
    set -ga event_pond_paths $got_pond_path
end

@echo "pond enable: success tests for regular pond"
__pond_setup 1 regular disabled unpopulated
@test "setup: pond disabled" ! -L $pond_home/$pond_links/$pond_name_regular
@test "pond enable: success exit code" (pond enable $pond_name_regular >/dev/null 2>&1) $status -eq $success
@test "pond enable: pond symlink created" -L $pond_home/$pond_links/$pond_name_regular
@test "pond enable: symlink valid" (readlink $pond_home/$pond_links/$pond_name_regular) = "$pond_home/$pond_regular/$pond_name_regular"
@test "pond enable: got pond name in event" (echo $event_pond_names) = $pond_name_regular
@test "pond enable: got pond path in event" (echo $event_pond_paths) = $pond_home/$pond_regular/$pond_name_regular
__pond_tear_down
__pond_event_reset

@echo "pond enable: output tests for regular pond"
__pond_setup 1 regular disabled unpopulated
@test "pond enable: success output message" (pond enable $pond_name_regular 2>&1) = $success_output_single_regular
__pond_tear_down
__pond_event_reset

@echo "pond enable: success tests for private pond"
__pond_setup 1 private disabled unpopulated
@test "setup: pond disabled" ! -L $pond_home/$pond_links/$pond_name_private
@test "pond enable: success exit code" (pond enable $pond_name_private >/dev/null 2>&1) $status -eq $success
@test "pond enable: pond symlink created" -L $pond_home/$pond_links/$pond_name_private
@test "pond enable: symlink valid" (readlink $pond_home/$pond_links/$pond_name_private) = "$pond_home/$pond_private/$pond_name_private"
@test "pond enable: got pond name in event" (echo $event_pond_names) = $pond_name_private
@test "pond enable: got pond path in event" (echo $event_pond_paths) = $pond_home/$pond_private/$pond_name_private
__pond_tear_down
__pond_event_reset

@echo "pond enable: output tests for private pond"
__pond_setup 1 private disabled unpopulated
@test "pond enable: success output message" (pond enable $pond_name_private 2>&1) = $success_output_single_private
__pond_tear_down
__pond_event_reset

@echo "pond enable: success tests for multiple regular ponds"
__pond_setup 3 regular disabled unpopulated
@test "setup: pond disabled" ! -L $pond_home/$pond_links/$pond_name_regular_prefix-1
@test "setup: pond disabled" ! -L $pond_home/$pond_links/$pond_name_regular_prefix-2
@test "setup: pond disabled" ! -L $pond_home/$pond_links/$pond_name_regular_prefix-3
@test "pond enable: success exit code" (pond enable $pond_name_regular_prefix-1 $pond_name_regular_prefix-2 $pond_name_regular_prefix-3 >/dev/null 2>&1) $status -eq $success
@test "pond enable: pond symlink created" -L $pond_home/$pond_links/$pond_name_regular_prefix-1
@test "pond enable: pond symlink created" -L $pond_home/$pond_links/$pond_name_regular_prefix-2
@test "pond enable: pond symlink created" -L $pond_home/$pond_links/$pond_name_regular_prefix-3
@test "pond enable: symlink valid" (readlink $pond_home/$pond_links/$pond_name_regular_prefix-1) = "$pond_home/$pond_regular/$pond_name_regular_prefix-1"
@test "pond enable: symlink valid" (readlink $pond_home/$pond_links/$pond_name_regular_prefix-2) = "$pond_home/$pond_regular/$pond_name_regular_prefix-2"
@test "pond enable: symlink valid" (readlink $pond_home/$pond_links/$pond_name_regular_prefix-3) = "$pond_home/$pond_regular/$pond_name_regular_prefix-3"
@test "pond enable: got pond names in events" (echo $event_pond_names) = "$pond_name_regular_prefix-1 $pond_name_regular_prefix-2 $pond_name_regular_prefix-3"
@test "pond enable: got pond paths in events" (echo $event_pond_paths) = "$pond_home/$pond_regular/$pond_name_regular_prefix-1 $pond_home/$pond_regular/$pond_name_regular_prefix-2 $pond_home/$pond_regular/$pond_name_regular_prefix-3"
__pond_tear_down
__pond_event_reset

@echo "pond enable: output tests for multiple regular ponds"
__pond_setup 3 regular disabled unpopulated
@test "pond enable: success output message" (pond enable $pond_name_regular_prefix-1 $pond_name_regular_prefix-2 $pond_name_regular_prefix-3 2>&1 | string collect) = $success_output_multiple_regular
__pond_tear_down
__pond_event_reset

@echo "pond enable: success tests for multiple private ponds"
__pond_setup 3 private disabled unpopulated
@test "setup: pond disabled" ! -L $pond_home/$pond_links/$pond_name_private_prefix-1
@test "setup: pond disabled" ! -L $pond_home/$pond_links/$pond_name_private_prefix-2
@test "setup: pond disabled" ! -L $pond_home/$pond_links/$pond_name_private_prefix-3
@test "pond enable: success exit code" (pond enable $pond_name_private_prefix-1 $pond_name_private_prefix-2 $pond_name_private_prefix-3 >/dev/null 2>&1) $status -eq $success
@test "pond enable: pond symlink created" -L $pond_home/$pond_links/$pond_name_private_prefix-1
@test "pond enable: pond symlink created" -L $pond_home/$pond_links/$pond_name_private_prefix-2
@test "pond enable: pond symlink created" -L $pond_home/$pond_links/$pond_name_private_prefix-3
@test "pond enable: symlink valid" (readlink $pond_home/$pond_links/$pond_name_private_prefix-1) = "$pond_home/$pond_private/$pond_name_private_prefix-1"
@test "pond enable: symlink valid" (readlink $pond_home/$pond_links/$pond_name_private_prefix-2) = "$pond_home/$pond_private/$pond_name_private_prefix-2"
@test "pond enable: symlink valid" (readlink $pond_home/$pond_links/$pond_name_private_prefix-3) = "$pond_home/$pond_private/$pond_name_private_prefix-3"
@test "pond enable: got pond names in events" (echo $event_pond_names) = "$pond_name_private_prefix-1 $pond_name_private_prefix-2 $pond_name_private_prefix-3"
@test "pond enable: got pond paths in events" (echo $event_pond_paths) = "$pond_home/$pond_private/$pond_name_private_prefix-1 $pond_home/$pond_private/$pond_name_private_prefix-2 $pond_home/$pond_private/$pond_name_private_prefix-3"
__pond_tear_down
__pond_event_reset

@echo "pond enable: output tests for multiple private ponds"
__pond_setup 3 private disabled unpopulated
@test "pond enable: success output message" (pond enable $pond_name_private_prefix-1 $pond_name_private_prefix-2 $pond_name_private_prefix-3 2>&1 | string collect) = $success_output_multiple_private
__pond_tear_down
__pond_event_reset

@echo "pond enable: failure tests for regular enabled pond"
__pond_setup 1 regular enabled unpopulated
ln -s $pond_home/$pond_regular/$pond_name_regular $pond_home/$pond_links/$pond_name_regular
@test "setup: pond enabled" -L $pond_home/$pond_links/$pond_name_regular
@test "pond enable: command error shown for regular enabled pond" (pond enable $pond_name_regular 2>&1) = (set_color red; and echo -n "Error: "; and set_color normal; and echo "Pond already enabled: $pond_name_regular")
__pond_tear_down

@echo "pond enable: failure tests for multiple regular enabled ponds"
__pond_setup 3 regular enabled unpopulated
ln -s $pond_home/$pond_regular/$pond_name_regular $pond_home/$pond_links/$pond_name_regular_prefix-1
@test "setup: pond enabled" -L $pond_home/$pond_links/$pond_name_regular_prefix-1
@test "setup: pond enabled" -L $pond_home/$pond_links/$pond_name_regular_prefix-2
@test "setup: pond enabled" -L $pond_home/$pond_links/$pond_name_regular_prefix-3
@test "pond enable: command error shown for regular enabled pond" (pond enable $pond_name_regular_prefix-1 $pond_name_regular_prefix-2 $pond_name_regular_prefix-3 2>&1) = (set_color red; and echo -n "Error: "; and set_color normal; and echo "Pond already enabled: $pond_name_regular_prefix-1")
__pond_tear_down

@echo "pond enable: failure tests for private enabled pond"
__pond_setup 1 private enabled unpopulated
ln -s $pond_home/$pond_private/$pond_name_private $pond_home/$pond_links/$pond_name_private
@test "setup: pond enabled" -L $pond_home/$pond_links/$pond_name_private
@test "pond enable: command error shown for private enabled pond" (pond enable $pond_name_private 2>&1) = (set_color red; and echo -n "Error: "; and set_color normal; and echo "Pond already enabled: $pond_name_private")
__pond_tear_down

@echo "pond enable: failure tests for multiple private enabled ponds"
__pond_setup 3 private enabled unpopulated
ln -s $pond_home/$pond_private/$pond_name_private $pond_home/$pond_links/$pond_name_private_prefix-1
@test "setup: pond enabled" -L $pond_home/$pond_links/$pond_name_private_prefix-1
@test "setup: pond enabled" -L $pond_home/$pond_links/$pond_name_private_prefix-2
@test "setup: pond enabled" -L $pond_home/$pond_links/$pond_name_private_prefix-3
@test "pond enable: command error shown for private enabled pond" (pond enable $pond_name_private_prefix-1 $pond_name_private_prefix-2 $pond_name_private_prefix-3 2>&1) = (set_color red; and echo -n "Error: "; and set_color normal; and echo "Pond already enabled: $pond_name_private_prefix-1")
__pond_tear_down

@echo "pond enable: validation failure exit code tests"
@test "pond enable: fails for missing pond name" (pond enable >/dev/null 2>&1) $status -eq $fail
@test "pond enable: fails for malformed pond name" (pond enable _invalid >/dev/null 2>&1) $status -eq $fail
@test "pond enable: fails for non-existent pond" (pond enable no-exist >/dev/null 2>&1) $status -eq $fail

@echo "pond enable: validation failure output tests"
@test "pond enable: command usage shown for missing pond name" (pond enable 2>&1 | string collect) = $command_usage
@test "pond enable: command usage shown for malformed pond name" (pond enable _invalid 2>&1 | string collect) = $command_usage
@test "pond enable: command error shown for non-existent pond" (pond enable no-exist 2>&1) = (set_color red; and echo -n "Error: "; and set_color normal; and echo "Pond does not exist: no-exist")

set pond_enable_on_create $pond_enable_on_create_before_test
