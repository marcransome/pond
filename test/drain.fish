set fail 1
set success 0

set -x __pond_under_test yes
set pond_name test-pond

set command_usage "\
Usage:
    pond drain [options] <name>

Options:
    -s, --silent  Silence confirmation prompt

Arguments:
    name  The name of the pond to drain"

function __pond_setup_regular
    pond create -e $pond_name >/dev/null 2>&1
    for var in TEST_VAR_{1,2,3}
        echo "set -xg $var "(string lower $var) >> $pond_home/$pond_regular/$pond_name/$pond_vars
    end
end

function __pond_setup_private
    pond create -e -p $pond_name >/dev/null 2>&1
    for var in TEST_VAR_PRIVATE_{1,2,3}
        echo "set -xg $var "(string lower $var) >> $pond_home/$pond_private/$pond_name/$pond_vars
    end
end

function __pond_tear_down
    pond remove -s $pond_name >/dev/null 2>&1
end

function __pond_event_intercept --on-event pond_drained -a got_pond_name got_pond_path
    set -g event_pond_name $got_pond_name
    set -g event_pond_path $got_pond_path
end

function __pond_event_reset
    set -e event_pond_name
    set -e event_pond_path
end

for command in "pond drain "{-s,--silent}" $pond_name"

    @echo "$command: success tests for regular pond"
    __pond_setup_regular
    @test "setup: pond variables exist" -n (read < $pond_home/$pond_regular/$pond_name/$pond_vars)
    @test "pond drain: success exit code" (eval $command >/dev/null 2>&1) $status -eq $success
    @test "pond drain: pond variables removed" -z (read < $pond_home/$pond_regular/$pond_name/$pond_vars)
    @test "pond drain: got pond name in event" (echo $event_pond_name) = $pond_name
    @test "pond drain: got pond path in event" (echo $event_pond_path) = $pond_home/$pond_regular/$pond_name
    __pond_tear_down
    __pond_event_reset

    @echo "$command: output tests for regular pond"
    __pond_setup_regular
    @test "pond drain: success output message" (eval $command 2>&1) = "Drained pond: $pond_name"
    __pond_tear_down
    __pond_event_reset

    @echo "$command: success tests for private pond"
    __pond_setup_private
    @test "setup: pond variables exist" -n (read < $pond_home/$pond_private/$pond_name/$pond_vars)
    @test "pond drain: success exit code" (eval $command >/dev/null 2>&1) $status -eq $success
    @test "pond drain: pond variables removed" -z (read < $pond_home/$pond_private/$pond_name/$pond_vars)
    @test "pond drain: got pond name in event" (echo $event_pond_name) = $pond_name
    @test "pond drain: got pond path in event" (echo $event_pond_path) = $pond_home/$pond_private/$pond_name
    __pond_tear_down
    __pond_event_reset

    @echo "$command: output tests for private pond"
    __pond_setup_private
    @test "pond drain: success output message" (eval $command 2>&1) = "Drained private pond: $pond_name"
    __pond_tear_down
    __pond_event_reset

end

@echo "pond drain: validation failure exit code tests"
@test "pond drain: fails for missing pond name" (pond drain >/dev/null 2>&1) $status -eq $fail
@test "pond drain: fails for trailing arguments" (pond drain $pond_name trailing >/dev/null 2>&1) $status -eq $fail
@test "pond drain: fails for malformed pond name" (pond drain _invalid >/dev/null 2>&1) $status -eq $fail
@test "pond drain: fails for non-existent pond" (pond drain no-exist >/dev/null 2>&1) $status -eq $fail

for valid_option in -s --silent
    for invalid_option in -i --invalid
        @test "pond drain: fails for valid option $valid_option and missing pond name" (pond drain $valid_option >/dev/null 2>&1) $status -eq $fail
        @test "pond drain: fails for valid option $valid_option and invalid pond name" (pond drain $valid_option _invalid >/dev/null 2>&1) $status -eq $fail
        @test "pond drain: fails for invalid option $invalid_option and valid pond name" (pond drain $invalid_option $pond_name >/dev/null 2>&1) $status -eq $fail
        @test "pond drain: fails for invalid option $invalid_option and invalid pond name" (pond drain $invalid_option _invalid >/dev/null 2>&1) $status -eq $fail
    end
end

@echo "pond drain: validation failure output tests"
@test "pond drain: command usage shown for missing pond name" (pond drain 2>&1 | string collect) = $command_usage
@test "pond drain: command usage shown for trailing arguments" (pond drain $pond_name trailing 2>&1 | string collect) = $command_usage
@test "pond drain: command usage shown for malformed pond name" (pond drain _invalid 2>&1 | string collect) = $command_usage
@test "pond drain: command error shown for non-existent pond" (pond drain no-exist 2>&1 | string collect) = "Pond does not exist: no-exist"

for valid_option in -s --silent
    for invalid_option in -i --invalid
        @test "pond drain: command usage shown for valid option $valid_option and missing pond name" (pond drain $valid_option 2>&1 | string collect) = $command_usage
        @test "pond drain: command usage shown for valid option $valid_option and invalid pond name" (pond drain $valid_option _invalid 2>&1 | string collect) = $command_usage
        @test "pond drain: command usage shown for invalid option $invalid_option and valid pond name" (pond drain $invalid_option $pond_name 2>&1 | string collect) = $command_usage
        @test "pond drain: command usage shown for invalid option $invalid_option and invalid pond name" (pond drain $invalid_option _invalid 2>&1 | string collect) = $command_usage
    end
end
