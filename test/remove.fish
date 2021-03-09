set fail 1
set success 0

set -x __pond_under_test yes
set pond_name test-pond
set pond_name_private test-private-pond

set command_usage "\
Usage:
    pond remove [options] ponds...

Options:
    -s, --silent  Silence confirmation prompt

Arguments:
    ponds  The name of one or more ponds to remove"

set success_output_single_regular "\
Removed pond: $pond_name"

set success_output_single_private "\
Removed private pond: $pond_name_private"

set success_output_multiple_regular "\
Removed pond: $pond_name-1
Removed pond: $pond_name-2
Removed pond: $pond_name-3"

set success_output_multiple_private "\
Removed private pond: $pond_name_private-1
Removed private pond: $pond_name_private-2
Removed private pond: $pond_name_private-3"

function __pond_setup_single_regular
    pond create -e $pond_name >/dev/null 2>&1
end

function __pond_setup_single_regular_disabled
    __pond_setup_single_regular
    pond disable $pond_name >/dev/null 2>&1
end

function __pond_setup_single_private
    pond create -e -p $pond_name_private >/dev/null 2>&1
end

function __pond_setup_single_private_disabled
    __pond_setup_single_private
    pond disable $pond_name_private >/dev/null 2>&1
end

function __pond_setup_multiple_regular
    pond create -e $pond_name-1 >/dev/null 2>&1
    pond create -e $pond_name-2 >/dev/null 2>&1
    pond create -e $pond_name-3 >/dev/null 2>&1
end

function __pond_setup_multiple_regular_disabled
    __pond_setup_multiple_regular
    pond disable $pond_name-1 >/dev/null 2>&1
    pond disable $pond_name-2 >/dev/null 2>&1
    pond disable $pond_name-3 >/dev/null 2>&1
end

function __pond_setup_multiple_private
    pond create -e -p $pond_name_private-1 >/dev/null 2>&1
    pond create -e -p $pond_name_private-2 >/dev/null 2>&1
    pond create -e -p $pond_name_private-3 >/dev/null 2>&1
end

function __pond_setup_multiple_private_disabled
    __pond_setup_multiple_private
    pond disable $pond_name_private-1 >/dev/null 2>&1
    pond disable $pond_name_private-2 >/dev/null 2>&1
    pond disable $pond_name_private-3 >/dev/null 2>&1
end

function __pond_tear_down_single_regular
    pond remove -s $pond_name >/dev/null 2>&1
end

function __pond_tear_down_single_private
    pond remove -s $pond_name_private >/dev/null 2>&1
end

function __pond_tear_down_multiple_regular
    pond remove -s $pond_name-1 >/dev/null 2>&1
    pond remove -s $pond_name-2 >/dev/null 2>&1
    pond remove -s $pond_name-3 >/dev/null 2>&1
end

function __pond_tear_down_multiple_private
    pond remove -s $pond_name_private-1 >/dev/null 2>&1
    pond remove -s $pond_name_private-2 >/dev/null 2>&1
    pond remove -s $pond_name_private-3 >/dev/null 2>&1
end

function __pond_event_intercept --on-event pond_removed -a got_pond_name got_pond_path
    set -ga event_pond_names $got_pond_name
    set -ga event_pond_paths $got_pond_path
end

function __pond_event_reset
    set -e event_pond_names
    set -e event_pond_paths
end

for command in "pond remove "{-s,--silent}" $pond_name"

    @echo "$command: success tests for regular enabled pond"
    __pond_setup_single_regular
    @test "setup: pond directory exists" -d $pond_home/$pond_regular/$pond_name
    @test "setup: pond link exists" -L $pond_home/$pond_links/$pond_name
    @test "setup: pond functions directory exists" -d $pond_home/$pond_regular/$pond_name/$pond_functions
    @test "pond remove: success exit code" (eval $command >/dev/null 2>&1) $status -eq $success
    @test "pond remove: pond directory removed" ! -d $pond_home/$pond_regular/$pond_name
    @test "pond remove: pond link removed" ! -L $pond_home/$pond_links/$pond_name
    @test "pond remove: pond functions directory removed" ! -d $pond_home/$pond_regular/$pond_name/$pond_functions
    @test "pond remove: got pond name in event" (echo $event_pond_names) = $pond_name
    @test "pond remove: got pond path in event" (echo $event_pond_paths) = $pond_home/$pond_regular/$pond_name
    __pond_tear_down_single_regular
    __pond_event_reset

    @echo "$command: output tests for regular enabled pond"
    __pond_setup_single_regular
    @test "pond remove: success output message" (eval $command 2>&1) = $success_output_single_regular
    __pond_tear_down_single_regular
    __pond_event_reset

    @echo "$command: success tests for regular disabled pond"
    __pond_setup_single_regular_disabled
    @test "setup: pond directory exists" -d $pond_home/$pond_regular/$pond_name
    @test "setup: pond link does not exist" ! -L $pond_home/$pond_links/$pond_name
    @test "setup: pond functions directory exists" -d $pond_home/$pond_regular/$pond_name/$pond_functions
    @test "pond remove: success exit code" (eval $command >/dev/null 2>&1) $status -eq $success
    @test "pond remove: pond directory removed" ! -d $pond_home/$pond_regular/$pond_name
    @test "pond remove: pond link does not exist" ! -L $pond_home/$pond_links/$pond_name
    @test "pond remove: pond functions directory removed" ! -d $pond_home/$pond_regular/$pond_name/$pond_functions
    @test "pond remove: got pond name in event" (echo $event_pond_names) = $pond_name
    @test "pond remove: got pond path in event" (echo $event_pond_paths) = $pond_home/$pond_regular/$pond_name
    __pond_tear_down_single_regular
    __pond_event_reset

    @echo "$command: output tests for regular disabled pond"
    __pond_setup_single_regular_disabled
    @test "pond remove: success output message" (eval $command 2>&1) = $success_output_single_regular
    __pond_tear_down_single_regular
    __pond_event_reset

end

for command in "pond remove "{-s,--silent}" $pond_name_private"

    @echo "$command: success tests for private enabled pond"
    __pond_setup_single_private
    @test "setup: pond directory exists" -d $pond_home/$pond_private/$pond_name_private
    @test "setup: pond link exists" -L $pond_home/$pond_links/$pond_name_private
    @test "setup: pond functions directory exists" -d $pond_home/$pond_private/$pond_name_private/$pond_functions
    @test "pond remove: success exit code" (eval $command >/dev/null 2>&1) $status -eq $success
    @test "pond remove: pond directory removed" ! -d $pond_home/$pond_private/$pond_name_private
    @test "pond remove: pond link removed" ! -L $pond_home/$pond_links/$pond_name_private
    @test "pond remove: pond functions directory removed" ! -d $pond_home/$pond_private/$pond_name_private/$pond_functions
    @test "pond remove: got pond name in event" (echo $event_pond_names) = $pond_name_private
    @test "pond remove: got pond path in event" (echo $event_pond_paths) = $pond_home/$pond_private/$pond_name_private
    __pond_tear_down_single_private
    __pond_event_reset

    @echo "$command: output tests for private enabled pond"
    __pond_setup_single_private
    @test "pond remove: success output message" (eval $command 2>&1) = $success_output_single_private
    __pond_tear_down_single_private
    __pond_event_reset

    @echo "$command: success tests for private disabled pond"
    __pond_setup_single_private_disabled
    @test "setup: pond directory exists" -d $pond_home/$pond_private/$pond_name_private
    @test "setup: pond link does not exist" ! -L $pond_home/$pond_links/$pond_name_private
    @test "setup: pond functions directory exists" -d $pond_home/$pond_private/$pond_name_private/$pond_functions
    @test "pond remove: success exit code" (eval $command >/dev/null 2>&1) $status -eq $success
    @test "pond remove: pond directory removed" ! -d $pond_home/$pond_private/$pond_name_private
    @test "pond remove: pond link does not exist" ! -L $pond_home/$pond_links/$pond_name_private
    @test "pond remove: pond functions directory removed" ! -d $pond_home/$pond_private/$pond_name_private/$pond_functions
    @test "pond remove: got pond name in event" (echo $event_pond_names) = $pond_name_private
    @test "pond remove: got pond path in event" (echo $event_pond_paths) = $pond_home/$pond_private/$pond_name_private
    __pond_tear_down_single_private
    __pond_event_reset

    @echo "$command: output tests for private disabled pond"
    __pond_setup_single_private_disabled
    @test "pond remove: success output message" (eval $command 2>&1) = $success_output_single_private
    __pond_tear_down_single_private
    __pond_event_reset

end

for command in "pond remove "{-s,--silent}" $pond_name-1 $pond_name-2 $pond_name-3"

    @echo "$command: success tests for multiple regular enabled ponds"
    __pond_setup_multiple_regular
    for multi_pond_name in "$pond_name-"(seq 3)
        @test "setup: pond directory $multi_pond_name exists" -d $pond_home/$pond_regular/$multi_pond_name
        @test "setup: pond link $multi_pond_name exists" -L $pond_home/$pond_links/$multi_pond_name
        @test "setup: pond functions directory $multi_pond_name/$pond_functions exists" -d $pond_home/$pond_regular/$multi_pond_name/$pond_functions
    end
    @test "pond remove: success exit code" (eval $command >/dev/null 2>&1) $status -eq $success
    for multi_pond_name in "$pond_name-"(seq 3)
        @test "pond remove: pond directory $multi_pond_name removed" ! -d $pond_home/$pond_regular/$multi_pond_name
        @test "pond remove: pond link $multi_pond_name removed" ! -L $pond_home/$pond_links/$multi_pond_name
        @test "pond remove: pond functions directory $multi_pond_name/$pond_functions removed" ! -d $pond_home/$pond_regular/$multi_pond_name/$pond_functions
    end
    @test "pond remove: got pond names in events" (echo $event_pond_names) = "$pond_name-1 $pond_name-2 $pond_name-3"
    @test "pond remove: got pond paths in events" (echo $event_pond_paths) = "$pond_home/$pond_regular/$pond_name-1 $pond_home/$pond_regular/$pond_name-2 $pond_home/$pond_regular/$pond_name-3"
    __pond_tear_down_multiple_regular
    __pond_event_reset

    @echo "$command: output tests for multiple regular enabled ponds"
    __pond_setup_multiple_regular
    @test "pond remove: success output message" (eval $command 2>&1 | string collect) = $success_output_multiple_regular
    __pond_tear_down_multiple_regular
    __pond_event_reset

    @echo "$command: success tests for multiple regular disabled ponds"
    __pond_setup_multiple_regular_disabled
    for multi_pond_name in "$pond_name-"(seq 3)
        @test "setup: pond directory $multi_pond_name exists" -d $pond_home/$pond_regular/$multi_pond_name
        @test "setup: pond link $multi_pond_name does not exist" ! -L $pond_home/$pond_links/$multi_pond_name
        @test "setup: pond functions directory $multi_pond_name/$pond_functions exists" -d $pond_home/$pond_regular/$multi_pond_name/$pond_functions
    end
    @test "pond remove: success exit code" (eval $command >/dev/null 2>&1) $status -eq $success
    for multi_pond_name in "$pond_name-"(seq 3)
        @test "pond remove: pond directory $multi_pond_name removed" ! -d $pond_home/$pond_regular/$multi_pond_name
        @test "pond remove: pond link $multi_pond_name does not exist" ! -L $pond_home/$pond_links/$multi_pond_name
        @test "pond remove: pond functions directory $multi_pond_name/$pond_functions removed" ! -d $pond_home/$pond_regular/$multi_pond_name/$pond_functions
    end
    @test "pond remove: got pond names in events" (echo $event_pond_names) = "$pond_name-1 $pond_name-2 $pond_name-3"
    @test "pond remove: got pond paths in events" (echo $event_pond_paths) = "$pond_home/$pond_regular/$pond_name-1 $pond_home/$pond_regular/$pond_name-2 $pond_home/$pond_regular/$pond_name-3"
    __pond_tear_down_multiple_regular
    __pond_event_reset

    @echo "$command: output tests for multiple regular disabled ponds"
    __pond_setup_multiple_regular_disabled
    @test "pond remove: success output message" (eval $command 2>&1 | string collect) = $success_output_multiple_regular
    __pond_tear_down_multiple_regular
    __pond_event_reset

end

for command in "pond remove "{-s,--silent}" $pond_name_private-1 $pond_name_private-2 $pond_name_private-3"

    @echo "$command: success tests for multiple private enabled ponds"
    __pond_setup_multiple_private
    for multi_pond_name in "$pond_name_private-"(seq 3)
        @test "setup: pond directory $multi_pond_name exists" -d $pond_home/$pond_private/$multi_pond_name
        @test "setup: pond link $multi_pond_name exists" -L $pond_home/$pond_links/$multi_pond_name
        @test "setup: pond functions directory $multi_pond_name/$pond_functions exists" -d $pond_home/$pond_private/$multi_pond_name/$pond_functions
    end
    @test "pond remove: success exit code" (eval $command >/dev/null 2>&1) $status -eq $success
    for multi_pond_name in "$pond_name_private-"(seq 3)
        @test "pond remove: pond directory $multi_pond_name removed" ! -d $pond_home/$pond_private/$multi_pond_name
        @test "pond remove: pond link $multi_pond_name removed" ! -L $pond_home/$pond_links/$multi_pond_name
        @test "pond remove: pond functions directory $multi_pond_name/$pond_functions removed" ! -d $pond_home/$pond_private/$multi_pond_name/$pond_functions
    end
    @test "pond remove: got pond names in events" (echo $event_pond_names) = "$pond_name_private-1 $pond_name_private-2 $pond_name_private-3"
    @test "pond remove: got pond paths in events" (echo $event_pond_paths) = "$pond_home/$pond_private/$pond_name_private-1 $pond_home/$pond_private/$pond_name_private-2 $pond_home/$pond_private/$pond_name_private-3"
    __pond_tear_down_multiple_private
    __pond_event_reset

    @echo "$command: output tests for multiple private enabled ponds"
    __pond_setup_multiple_private
    @test "pond remove: success output message" (eval $command 2>&1 | string collect) = $success_output_multiple_private
    __pond_tear_down_multiple_private
    __pond_event_reset

    @echo "$command: success tests for multiple private disabled ponds"
    __pond_setup_multiple_private_disabled
    for multi_pond_name in "$pond_name_private-"(seq 3)
        @test "setup: pond directory $multi_pond_name exists" -d $pond_home/$pond_private/$multi_pond_name
        @test "setup: pond link $multi_pond_name does not exist" ! -L $pond_home/$pond_links/$multi_pond_name
        @test "setup: pond functions directory $multi_pond_name/$pond_functions exists" -d $pond_home/$pond_private/$multi_pond_name/$pond_functions
    end
    @test "pond remove: success exit code" (eval $command >/dev/null 2>&1) $status -eq $success
    for multi_pond_name in "$pond_name_private-"(seq 3)
        @test "pond remove: pond directory $multi_pond_name removed" ! -d $pond_home/$pond_private/$multi_pond_name
        @test "pond remove: pond link $multi_pond_name does not exist" ! -L $pond_home/$pond_links/$multi_pond_name
        @test "pond remove: pond functions directory $multi_pond_name/$pond_functions removed" ! -d $pond_home/$pond_private/$multi_pond_name/$pond_functions
    end
    @test "pond remove: got pond names in events" (echo $event_pond_names) = "$pond_name_private-1 $pond_name_private-2 $pond_name_private-3"
    @test "pond remove: got pond paths in events" (echo $event_pond_paths) = "$pond_home/$pond_private/$pond_name_private-1 $pond_home/$pond_private/$pond_name_private-2 $pond_home/$pond_private/$pond_name_private-3"
    __pond_tear_down_multiple_private
    __pond_event_reset

    @echo "$command: output tests for multiple private disabled ponds"
    __pond_setup_multiple_private_disabled
    @test "pond remove: success output message" (eval $command 2>&1 | string collect) = $success_output_multiple_private
    __pond_tear_down_multiple_private
    __pond_event_reset

end

@echo "pond remove: validation failure exit code tests"
@test "pond remove: fails for missing pond name" (pond remove >/dev/null 2>&1) $status -eq $fail
@test "pond remove: fails for malformed pond name" (pond remove _invalid >/dev/null 2>&1) $status -eq $fail
@test "pond remove: fails for non-existent pond" (pond remove no-exist >/dev/null 2>&1) $status -eq $fail

for valid_option in -e --empty -p --private
    for invalid_option in -i --invalid
        @test "pond remove: fails for valid option $valid_option and missing pond name" (pond remove $valid_option >/dev/null 2>&1) $status -eq $fail
        @test "pond remove: fails for valid option $valid_option and invalid pond name" (pond remove $valid_option _invalid >/dev/null 2>&1) $status -eq $fail
        @test "pond remove: fails for invalid option $invalid_option and valid pond name" (pond remove $invalid_option $pond_name >/dev/null 2>&1) $status -eq $fail
        @test "pond remove: fails for invalid option $invalid_option and invalid pond name" (pond remove $invalid_option _invalid >/dev/null 2>&1) $status -eq $fail
    end
end

@echo "pond remove: validation failure output tests"
@test "pond remove: command usage shown for missing pond name" (pond remove 2>&1 | string collect) = $command_usage
@test "pond remove: command usage shown for malformed pond name" (pond remove _invalid 2>&1 | string collect) = $command_usage
@test "pond remove: command error shown for non-existent pond" (pond remove no-exist 2>&1 | string collect) = "Pond does not exist: no-exist"

for valid_option in -e --empty -p --private
    for invalid_option in -i --invalid
        @test "pond remove: command usage shown for valid option $valid_option and missing pond name" (pond remove $valid_option 2>&1 | string collect) = $command_usage
        @test "pond remove: command usage shown for valid option $valid_option and invalid pond name" (pond remove $valid_option _invalid 2>&1 | string collect) = $command_usage
        @test "pond remove: command usage shown for invalid option $invalid_option and valid pond name" (pond remove $invalid_option $pond_name 2>&1 | string collect) = $command_usage
        @test "pond remove: command usage shown for invalid option $invalid_option and invalid pond name" (pond remove $invalid_option _invalid 2>&1 | string collect) = $command_usage
    end
end
