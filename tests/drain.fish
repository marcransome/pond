set parent (dirname (status --current-filename))
source $parent/fixtures/functions.fish
source $parent/fixtures/variables.fish

set command_usage "\
Usage:
    pond drain [options] ponds...

Options:
    -y, --yes  Automatically accept confirmation prompts

Arguments:
    ponds  The name of one or more ponds to drain"

set success_output_single_pond "\
Drained pond: $pond_name"

set success_output_multiple_ponds "\
Drained pond: $pond_name_prefix-1
Drained pond: $pond_name_prefix-2
Drained pond: $pond_name_prefix-3"

set not_exists_error (__pond_error_string "Pond does not exist: no-exist")

function __pond_drained_event_intercept --on-event pond_drained -a got_pond_name got_pond_path
    set -ga event_pond_names $got_pond_name
    set -ga event_pond_paths $got_pond_path
end

for command in "pond drain "{-y,--yes}

    @echo "$command: success tests for single pond"
    __pond_setup 1 enabled loaded populated
    @test "setup: pond file exists" -f $pond_home/$pond_name/{$pond_name}_{$pond_autoload_suffix}.fish
    @test "pond drain: success exit code" (eval $command $pond_name >/dev/null 2>&1) $status -eq $success
    @test "pond drain: pond file removed" ! -f $pond_home/$pond_name/{$pond_name}_{$pond_autoload_suffix}.fish
    @test "pond drain: got pond name in event" (echo $event_pond_names) = $pond_name
    @test "pond drain: got pond path in event" (echo $event_pond_paths) = $pond_home/$pond_name
    __pond_tear_down
    __pond_event_reset

    @echo "$command: output tests for single pond"
    __pond_setup 1 enabled loaded populated
    @test "pond drain: success output message" (eval $command $pond_name 2>&1) = $success_output_single_pond
    __pond_tear_down
    __pond_event_reset

    @echo "$command: success tests for multiple ponds"
    __pond_setup 3 enabled loaded populated
    @test "setup: $pond_name_prefix-1 pond file exists" -f $pond_home/$pond_name_prefix-1/{$pond_name_prefix-1}_{$pond_autoload_suffix}.fish
    @test "setup: $pond_name_prefix-2 pond file exists" -f $pond_home/$pond_name_prefix-2/{$pond_name_prefix-2}_{$pond_autoload_suffix}.fish
    @test "setup: $pond_name_prefix-3 pond file exists" -f $pond_home/$pond_name_prefix-3/{$pond_name_prefix-3}_{$pond_autoload_suffix}.fish
    @test "pond drain: success exit code" (eval $command $pond_name_prefix-1 $pond_name_prefix-2 $pond_name_prefix-3 >/dev/null 2>&1) $status -eq $success
    @test "pond drain: $pond_name_prefix-1 pond file removed" ! -f $pond_home/$pond_name_prefix-1/{$pond_name_prefix-1}_{$pond_autoload_suffix}.fish
    @test "pond drain: $pond_name_prefix-2 pond file removed" ! -f $pond_home/$pond_name_prefix-2/{$pond_name_prefix-2}_{$pond_autoload_suffix}.fish
    @test "pond drain: $pond_name_prefix-3 pond file removed" ! -f $pond_home/$pond_name_prefix-3/{$pond_name_prefix-3}_{$pond_autoload_suffix}.fish
    @test "pond drain: got pond names in events" (echo $event_pond_names) = "$pond_name_prefix-1 $pond_name_prefix-2 $pond_name_prefix-3"
    @test "pond drain: got pond paths in events" (echo $event_pond_paths) = "$pond_home/$pond_name_prefix-1 $pond_home/$pond_name_prefix-2 $pond_home/$pond_name_prefix-3"
    __pond_tear_down
    __pond_event_reset

    @echo "$command: output tests for multiple ponds"
    __pond_setup 3 enabled loaded populated
    @test "pond drain: success output message" (eval $command $pond_name_prefix-1 $pond_name_prefix-2 $pond_name_prefix-3 2>&1 | string collect) = $success_output_multiple_ponds
    __pond_tear_down
    __pond_event_reset

end

@echo "pond drain: validation failure exit code tests"
@test "pond drain: fails for missing pond name" (pond drain >/dev/null 2>&1) $status -eq $failure
@test "pond drain: fails for malformed pond name" (pond drain _invalid >/dev/null 2>&1) $status -eq $failure
@test "pond drain: fails for non-existent pond" (pond drain no-exist >/dev/null 2>&1) $status -eq $failure

for valid_option in -y --yes
    @test "pond drain: fails for valid option $valid_option and missing pond name" (pond drain $valid_option >/dev/null 2>&1) $status -eq $failure
    @test "pond drain: fails for valid option $valid_option and invalid pond name" (pond drain $valid_option _invalid >/dev/null 2>&1) $status -eq $failure
end

for invalid_option in -i --invalid
    @test "pond drain: fails for invalid option $invalid_option and valid pond name" (pond drain $invalid_option $pond_name >/dev/null 2>&1) $status -eq $failure
    @test "pond drain: fails for invalid option $invalid_option and invalid pond name" (pond drain $invalid_option _invalid >/dev/null 2>&1) $status -eq $failure
end

@echo "pond drain: validation failure output tests"
@test "pond drain: command usage shown for missing pond name" (pond drain 2>&1 | string collect) = $command_usage
@test "pond drain: command usage shown for malformed pond name" (pond drain _invalid 2>&1 | string collect) = $command_usage
@test "pond drain: command error shown for non-existent pond" (pond drain no-exist 2>&1 | string collect) = $not_exists_error

for valid_option in -y --yes
    @test "pond drain: command usage shown for valid option $valid_option and missing pond name" (pond drain $valid_option 2>&1 | string collect) = $command_usage
    @test "pond drain: command usage shown for valid option $valid_option and invalid pond name" (pond drain $valid_option _invalid 2>&1 | string collect) = $command_usage
end

for invalid_option in -i --invalid
    @test "pond drain: command usage shown for invalid option $invalid_option and valid pond name" (pond drain $invalid_option $pond_name 2>&1 | string collect) = $command_usage
    @test "pond drain: command usage shown for invalid option $invalid_option and invalid pond name" (pond drain $invalid_option _invalid 2>&1 | string collect) = $command_usage
end
