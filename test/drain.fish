source ./helpers/functions.fish
source ./helpers/variables.fish

set command_usage "\
Usage:
    pond drain [options] <name>

Options:
    -s, --silent  Silence confirmation prompt

Arguments:
    name  The name of the pond to drain"

function __pond_drained_event_intercept --on-event pond_drained -a got_pond_name got_pond_path
    set -g event_pond_name $got_pond_name
    set -g event_pond_path $got_pond_path
end

for command in "pond drain "{-s,--silent}

    @echo "$command: success tests for regular pond"
    __pond_setup 1 regular enabled populated
    @test "setup: pond variables exist" -n (read < $pond_home/$pond_regular/$pond_name_regular/$pond_vars)
    @test "pond drain: success exit code" (eval $command $pond_name_regular >/dev/null 2>&1) $status -eq $success
    @test "pond drain: pond variables removed" -z (read < $pond_home/$pond_regular/$pond_name_regular/$pond_vars)
    @test "pond drain: got pond name in event" (echo $event_pond_name) = $pond_name_regular
    @test "pond drain: got pond path in event" (echo $event_pond_path) = $pond_home/$pond_regular/$pond_name_regular
    __pond_tear_down
    __pond_event_reset

    @echo "$command: output tests for regular pond"
    __pond_setup 1 regular enabled populated
    @test "pond drain: success output message" (eval $command $pond_name_regular 2>&1) = "Drained pond: $pond_name_regular"
    __pond_tear_down
    __pond_event_reset

    @echo "$command: success tests for private pond"
    __pond_setup 1 private enabled populated
    @test "setup: pond variables exist" -n (read < $pond_home/$pond_private/$pond_name_private/$pond_vars)
    @test "pond drain: success exit code" (eval $command $pond_name_private >/dev/null 2>&1) $status -eq $success
    @test "pond drain: pond variables removed" -z (read < $pond_home/$pond_private/$pond_name_private/$pond_vars)
    @test "pond drain: got pond name in event" (echo $event_pond_name) = $pond_name_private
    @test "pond drain: got pond path in event" (echo $event_pond_path) = $pond_home/$pond_private/$pond_name_private
    __pond_tear_down
    __pond_event_reset

    @echo "$command: output tests for private pond"
    __pond_setup 1 private enabled populated
    @test "pond drain: success output message" (eval $command $pond_name_private 2>&1) = "Drained private pond: $pond_name_private"
    __pond_tear_down
    __pond_event_reset

end

@echo "pond drain: validation failure exit code tests"
@test "pond drain: fails for missing pond name" (pond drain >/dev/null 2>&1) $status -eq $fail
@test "pond drain: fails for trailing arguments" (pond drain $pond_name_regular trailing >/dev/null 2>&1) $status -eq $fail
@test "pond drain: fails for malformed pond name" (pond drain _invalid >/dev/null 2>&1) $status -eq $fail
@test "pond drain: fails for non-existent pond" (pond drain no-exist >/dev/null 2>&1) $status -eq $fail

for valid_option in -s --silent
    @test "pond drain: fails for valid option $valid_option and missing pond name" (pond drain $valid_option >/dev/null 2>&1) $status -eq $fail
    @test "pond drain: fails for valid option $valid_option and invalid pond name" (pond drain $valid_option _invalid >/dev/null 2>&1) $status -eq $fail
end

for invalid_option in -i --invalid
    @test "pond drain: fails for invalid option $invalid_option and valid pond name" (pond drain $invalid_option $pond_name_regular >/dev/null 2>&1) $status -eq $fail
    @test "pond drain: fails for invalid option $invalid_option and invalid pond name" (pond drain $invalid_option _invalid >/dev/null 2>&1) $status -eq $fail
end

@echo "pond drain: validation failure output tests"
@test "pond drain: command usage shown for missing pond name" (pond drain 2>&1 | string collect) = $command_usage
@test "pond drain: command usage shown for trailing arguments" (pond drain $pond_name_regular trailing 2>&1 | string collect) = $command_usage
@test "pond drain: command usage shown for malformed pond name" (pond drain _invalid 2>&1 | string collect) = $command_usage
@test "pond drain: command error shown for non-existent pond" (pond drain no-exist 2>&1 | string collect) = "Pond does not exist: no-exist"

for valid_option in -s --silent
    @test "pond drain: command usage shown for valid option $valid_option and missing pond name" (pond drain $valid_option 2>&1 | string collect) = $command_usage
    @test "pond drain: command usage shown for valid option $valid_option and invalid pond name" (pond drain $valid_option _invalid 2>&1 | string collect) = $command_usage
end

for invalid_option in -i --invalid
    @test "pond drain: command usage shown for invalid option $invalid_option and valid pond name" (pond drain $invalid_option $pond_name_regular 2>&1 | string collect) = $command_usage
    @test "pond drain: command usage shown for invalid option $invalid_option and invalid pond name" (pond drain $invalid_option _invalid 2>&1 | string collect) = $command_usage
end
