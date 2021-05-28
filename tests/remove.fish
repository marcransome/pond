source ./fixtures/functions.fish
source ./fixtures/variables.fish

set command_usage "\
Usage:
    pond remove [options] ponds...

Options:
    -y, --yes  Automatically accept confirmation prompts

Arguments:
    ponds  The name of one or more ponds to remove"

set success_output_single_pond "\
Removed pond: $pond_name"

set success_output_multiple_ponds "\
Removed pond: $pond_name_prefix-1
Removed pond: $pond_name_prefix-2
Removed pond: $pond_name_prefix-3"

function __pond_removed_event_intercept --on-event pond_removed -a event_pond_name event_pond_path
    set -ga event_pond_names $event_pond_name
    set -ga event_pond_paths $event_pond_path
end

for command in "pond remove "{-y,--yes}

    @echo "$command: success tests for single enabled pond"
    __pond_setup 1 enabled populated
    @test "setup: pond directory exists" -d $pond_home/$pond_name
    @test "setup: pond function path present" (contains $pond_home/$pond_name $pond_function_path) $status -eq $success
    @test "setup: fish function path present" (contains $pond_home/$pond_name $fish_function_path) $status -eq $success
    @test "pond remove: success exit code" (eval $command $pond_name >/dev/null 2>&1) $status -eq $success
    @test "pond remove: pond directory removed" ! -d $pond_home/$pond_name
    @test "pond remove: pond function path removed" (not contains $pond_home/$pond_name $pond_function_path) $status -eq $success
    @test "pond remove: fish function path removed" (not contains $pond_home/$pond_name $fish_function_path) $status -eq $success
    @test "pond remove: got pond name in event" (echo $event_pond_names) = $pond_name
    @test "pond remove: got pond path in event" (echo $event_pond_paths) = $pond_home/$pond_name
    __pond_tear_down
    __pond_event_reset

    @echo "$command: output tests for single enabled pond"
    __pond_setup 1 enabled unpopulated
    @test "pond remove: success output message" (eval $command $pond_name 2>&1) = $success_output_single_pond
    __pond_tear_down
    __pond_event_reset

    @echo "$command: success tests for single disabled pond"
    __pond_setup 1 disabled populated
    @test "setup: pond directory exists" -d $pond_home/$pond_name
    @test "setup: pond function path absent" (not contains $pond_home/$pond_name $pond_function_path) $status -eq $success
    @test "setup: fish function path present" (not contains $pond_home/$pond_name $fish_function_path) $status -eq $success
    @test "pond remove: success exit code" (eval $command $pond_name >/dev/null 2>&1) $status -eq $success
    @test "pond remove: pond directory removed" ! -d $pond_home/$pond_name
    @test "pond remove: pond function path absent" (not contains $pond_home/$pond_name $pond_function_path) $status -eq $success
    @test "pond remove: fish function path absent" (not contains $pond_home/$pond_name $fish_function_path) $status -eq $success
    @test "pond remove: got pond name in event" (echo $event_pond_names) = $pond_name
    @test "pond remove: got pond path in event" (echo $event_pond_paths) = $pond_home/$pond_name
    __pond_tear_down
    __pond_event_reset

    @echo "$command: output tests for single disabled pond"
    __pond_setup 1 disabled unpopulated
    @test "pond remove: success output message" (eval $command $pond_name 2>&1) = $success_output_single_pond
    __pond_tear_down
    __pond_event_reset

    @echo "$command: success tests for multiple enabled ponds"
    __pond_setup 3 enabled populated
    @test "setup: $pond_name_prefix-1 pond directory exists" -d $pond_home/$pond_name_prefix-1
    @test "setup: $pond_name_prefix-2 pond directory exists" -d $pond_home/$pond_name_prefix-2
    @test "setup: $pond_name_prefix-3 pond directory exists" -d $pond_home/$pond_name_prefix-3
    @test "setup: $pond_name_prefix-1 pond function path present" (contains $pond_home/$pond_name_prefix-1 $pond_function_path) $status -eq $success
    @test "setup: $pond_name_prefix-2 pond function path present" (contains $pond_home/$pond_name_prefix-2 $pond_function_path) $status -eq $success
    @test "setup: $pond_name_prefix-3 pond function path present" (contains $pond_home/$pond_name_prefix-3 $pond_function_path) $status -eq $success
    @test "setup: $pond_name_prefix-1 fish function path present" (contains $pond_home/$pond_name_prefix-1 $fish_function_path) $status -eq $success
    @test "setup: $pond_name_prefix-2 fish function path present" (contains $pond_home/$pond_name_prefix-2 $fish_function_path) $status -eq $success
    @test "setup: $pond_name_prefix-3 fish function path present" (contains $pond_home/$pond_name_prefix-3 $fish_function_path) $status -eq $success
    @test "pond remove: success exit code" (eval $command $pond_name_prefix-1 $pond_name_prefix-2 $pond_name_prefix-3 >/dev/null 2>&1) $status -eq $success
    @test "pond remove: $pond_name_prefix-1 pond directory removed" ! -d $pond_home/$pond_name_prefix-1
    @test "pond remove: $pond_name_prefix-2 pond directory removed" ! -d $pond_home/$pond_name_prefix-2
    @test "pond remove: $pond_name_prefix-3 pond directory removed" ! -d $pond_home/$pond_name_prefix-3
    @test "pond remove: $pond_name_prefix-1 pond function path removed" (not contains $pond_home/$pond_name_prefix-1 $pond_function_path) $status -eq $success
    @test "pond remove: $pond_name_prefix-2 pond function path removed" (not contains $pond_home/$pond_name_prefix-2 $pond_function_path) $status -eq $success
    @test "pond remove: $pond_name_prefix-3 pond function path removed" (not contains $pond_home/$pond_name_prefix-3 $pond_function_path) $status -eq $success
    @test "pond remove: $pond_name_prefix-1 fish function path removed" (not contains $pond_home/$pond_name_prefix-1 $fish_function_path) $status -eq $success
    @test "pond remove: $pond_name_prefix-2 fish function path removed" (not contains $pond_home/$pond_name_prefix-2 $fish_function_path) $status -eq $success
    @test "pond remove: $pond_name_prefix-3 fish function path removed" (not contains $pond_home/$pond_name_prefix-3 $fish_function_path) $status -eq $success
    @test "pond remove: got pond name in event" (echo $event_pond_names) = "$pond_name_prefix-1 $pond_name_prefix-2 $pond_name_prefix-3"
    @test "pond remove: got pond path in event" (echo $event_pond_paths) = "$pond_home/$pond_name_prefix-1 $pond_home/$pond_name_prefix-2 $pond_home/$pond_name_prefix-3"
    __pond_tear_down
    __pond_event_reset

    @echo "$command: output tests for multiple enabled ponds"
    __pond_setup 3 enabled unpopulated
    @test "pond remove: success output message" (eval $command $pond_name_prefix-1 $pond_name_prefix-2 $pond_name_prefix-3 2>&1 | string collect) = $success_output_multiple_ponds
    __pond_tear_down
    __pond_event_reset

    @echo "$command: success tests for multiple disabled ponds"
    __pond_setup 3 disabled populated
    @test "setup: $pond_name_prefix-1 pond directory exists" -d $pond_home/$pond_name_prefix-1
    @test "setup: $pond_name_prefix-2 pond directory exists" -d $pond_home/$pond_name_prefix-2
    @test "setup: $pond_name_prefix-3 pond directory exists" -d $pond_home/$pond_name_prefix-3
    @test "setup: $pond_name_prefix-1 pond function path absent" (not contains $pond_home/$pond_name_prefix-1 $pond_function_path) $status -eq $success
    @test "setup: $pond_name_prefix-2 pond function path absent" (not contains $pond_home/$pond_name_prefix-2 $pond_function_path) $status -eq $success
    @test "setup: $pond_name_prefix-3 pond function path absent" (not contains $pond_home/$pond_name_prefix-3 $pond_function_path) $status -eq $success
    @test "setup: $pond_name_prefix-1 fish function path absent" (not contains $pond_home/$pond_name_prefix-1 $fish_function_path) $status -eq $success
    @test "setup: $pond_name_prefix-2 fish function path absent" (not contains $pond_home/$pond_name_prefix-2 $fish_function_path) $status -eq $success
    @test "setup: $pond_name_prefix-3 fish function path absent" (not contains $pond_home/$pond_name_prefix-3 $fish_function_path) $status -eq $success
    @test "pond remove: success exit code" (eval $command $pond_name_prefix-1 $pond_name_prefix-2 $pond_name_prefix-3 >/dev/null 2>&1) $status -eq $success
    @test "pond remove: $pond_name_prefix-1 pond directory removed" ! -d $pond_home/$pond_name_prefix-1
    @test "pond remove: $pond_name_prefix-2 pond directory removed" ! -d $pond_home/$pond_name_prefix-2
    @test "pond remove: $pond_name_prefix-3 pond directory removed" ! -d $pond_home/$pond_name_prefix-3
    @test "pond remove: $pond_name_prefix-1 pond function path absent" (not contains $pond_home/$pond_name_prefix-1 $pond_function_path) $status -eq $success
    @test "pond remove: $pond_name_prefix-2 pond function path absent" (not contains $pond_home/$pond_name_prefix-2 $pond_function_path) $status -eq $success
    @test "pond remove: $pond_name_prefix-3 pond function path absent" (not contains $pond_home/$pond_name_prefix-3 $pond_function_path) $status -eq $success
    @test "pond remove: $pond_name_prefix-1 fish function path absent" (not contains $pond_home/$pond_name_prefix-1 $fish_function_path) $status -eq $success
    @test "pond remove: $pond_name_prefix-2 fish function path absent" (not contains $pond_home/$pond_name_prefix-2 $fish_function_path) $status -eq $success
    @test "pond remove: $pond_name_prefix-3 fish function path absent" (not contains $pond_home/$pond_name_prefix-3 $fish_function_path) $status -eq $success
    @test "pond remove: got pond name in event" (echo $event_pond_names) = "$pond_name_prefix-1 $pond_name_prefix-2 $pond_name_prefix-3"
    @test "pond remove: got pond path in event" (echo $event_pond_paths) = "$pond_home/$pond_name_prefix-1 $pond_home/$pond_name_prefix-2 $pond_home/$pond_name_prefix-3"
    __pond_tear_down
    __pond_event_reset

    @echo "$command: output tests for multiple disabled ponds"
    __pond_setup 3 disabled unpopulated
    @test "pond remove: success output message" (eval $command $pond_name_prefix-1 $pond_name_prefix-2 $pond_name_prefix-3 2>&1 | string collect) = $success_output_multiple_ponds
    __pond_tear_down
    __pond_event_reset

end

@echo "pond remove: validation failure exit code tests"
@test "pond remove: fails for missing pond name" (pond remove >/dev/null 2>&1) $status -eq $fail
@test "pond remove: fails for malformed pond name" (pond remove _invalid >/dev/null 2>&1) $status -eq $fail
@test "pond remove: fails for non-existent pond" (pond remove no-exist >/dev/null 2>&1) $status -eq $fail

for valid_option in -y --yes
    @test "pond remove: fails for valid option $valid_option and missing pond name" (pond remove $valid_option >/dev/null 2>&1) $status -eq $fail
    @test "pond remove: fails for valid option $valid_option and invalid pond name" (pond remove $valid_option _invalid >/dev/null 2>&1) $status -eq $fail
end

for invalid_option in -i --invalid
    @test "pond remove: fails for invalid option $invalid_option and valid pond name" (pond remove $invalid_option $pond_name >/dev/null 2>&1) $status -eq $fail
    @test "pond remove: fails for invalid option $invalid_option and invalid pond name" (pond remove $invalid_option _invalid >/dev/null 2>&1) $status -eq $fail
end

@echo "pond remove: validation failure output tests"
@test "pond remove: command usage shown for missing pond name" (pond remove 2>&1 | string collect) = $command_usage
@test "pond remove: command usage shown for malformed pond name" (pond remove _invalid 2>&1 | string collect) = $command_usage
@test "pond remove: command error shown for non-existent pond" (pond remove no-exist 2>&1 | string collect) = "Pond does not exist: no-exist"

for valid_option in -y --yes
    @test "pond remove: command usage shown for valid option $valid_option and missing pond name" (pond remove $valid_option 2>&1 | string collect) = $command_usage
    @test "pond remove: command usage shown for valid option $valid_option and invalid pond name" (pond remove $valid_option _invalid 2>&1 | string collect) = $command_usage
end

for invalid_option in -i --invalid
    @test "pond remove: command usage shown for invalid option $invalid_option and valid pond name" (pond remove $invalid_option $pond_name 2>&1 | string collect) = $command_usage
    @test "pond remove: command usage shown for invalid option $invalid_option and invalid pond name" (pond remove $invalid_option _invalid 2>&1 | string collect) = $command_usage
end
