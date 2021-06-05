source ./fixtures/functions.fish
source ./fixtures/variables.fish

set command_usage "\
Usage:
    pond create ponds...

Arguments:
    name  The name of one or more ponds to create; a pond name
          must begin with an alphanumeric character followed by
          any number of additional alphanumeric characters,
          underscores or dashes"

set success_output_single_pond "Created empty pond: $pond_name"

set success_output_multiple_ponds "\
Created empty pond: $pond_name_prefix-1
Created empty pond: $pond_name_prefix-2
Created empty pond: $pond_name_prefix-3"

set already_exists_error (__pond_error_string "Pond already exists: $pond_name")

function __pond_created_event_intercept --on-event pond_created -a got_pond_name got_pond_path
    set -ga event_pond_names $got_pond_name
    set -ga event_pond_paths $got_pond_path
end

@echo "pond create $pond_name: success tests for single pond"
@test "pond create: success exit code" (pond create $pond_name >/dev/null 2>&1) $status -eq $success
@test "pond create: pond directory created" -d $pond_home/$pond_name
@test "pond create: got pond name in event" (echo $event_pond_names) = $pond_name
@test "pond create: got pond path in event" (echo $event_pond_paths) = $pond_home/$pond_name
__pond_tear_down
__pond_event_reset

@echo "pond create $pond_name: output tests for single pond"
@test "pond create: output message correct" (pond create $pond_name 2>&1) = $success_output_single_pond
__pond_tear_down
__pond_event_reset

@echo "pond create $pond_name_prefix-1 $pond_name_prefix-2 $pond_name_prefix-3: success tests for multiple ponds"
@test "pond create: success exit code" (pond create $pond_name_prefix-1 $pond_name_prefix-2 $pond_name_prefix-3 >/dev/null 2>&1) $status -eq $success
@test "pond create: pond directory created" -d $pond_home/$pond_name_prefix-1
@test "pond create: pond directory created" -d $pond_home/$pond_name_prefix-2
@test "pond create: pond directory created" -d $pond_home/$pond_name_prefix-3
@test "pond create: got pond names in events" (echo $event_pond_names) = "$pond_name_prefix-1 $pond_name_prefix-2 $pond_name_prefix-3"
@test "pond create: got pond paths in events" (echo $event_pond_paths) = "$pond_home/$pond_name_prefix-1 $pond_home/$pond_name_prefix-2 $pond_home/$pond_name_prefix-3"
__pond_tear_down
__pond_event_reset

@echo "pond create $pond_name_prefix-1 $pond_name_prefix-2 $pond_name_prefix-3: output tests for multiple ponds"
@test "pond create: success output message" (pond create $pond_name_prefix-1 $pond_name_prefix-2 $pond_name_prefix-3 2>&1 | string collect) = $success_output_multiple_ponds
__pond_tear_down
__pond_event_reset

@echo "pond create: validation failure exit code tests"
@test "pond create: fails for missing pond name" (pond create >/dev/null 2>&1) $status -eq $failure
@test "pond create: fails for malformed pond name" (pond create _invalid >/dev/null 2>&1) $status -eq $failure
__pond_setup 1 enabled unpopulated
@test "pond create: fails for existing pond" (pond create $pond_name >/dev/null 2>&1) $status -eq $failure
__pond_tear_down
__pond_event_reset

@echo "pond create: validation failure output tests"
@test "pond create: command usage shown for missing pond name" (pond create 2>&1 | string collect) = $command_usage
@test "pond create: command usage shown for malformed pond name" (pond create _invalid 2>&1 | string collect) = $command_usage
__pond_setup 1 enabled unpopulated
@test "pond create: command error shown for existing pond" (pond create $pond_name 2>&1 | string collect) = $already_exists_error
__pond_tear_down
__pond_event_reset
