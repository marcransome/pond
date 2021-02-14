set fail 1
set success 0

set -x __pond_under_test yes
set pond_name test-pond

set command_usage "\
Usage:
    pond remove [options] <name>

Options:
    -s, --silent  Silence confirmation prompt

Arguments:
    name  The name of the pond to remove"

function __pond_setup_regular
    pond create -e $pond_name >/dev/null 2>&1
end

function __pond_setup_private
    pond create -e -p $pond_name >/dev/null 2>&1
end

function __pond_tear_down
    echo "y" | pond remove $pond_name >/dev/null 2>&1
end

# command cases:
#   echo 'y' | pond remove $pond_name
#   pond remove -s $pond_name
#   pond remove --silent $pond_name
for command in "echo 'y' | pond remove $pond_name" "pond remove "{-s,--silent}" $pond_name"

    @echo "$command: success tests for regular pond"
    __pond_setup_regular
    @test "setup: pond directory exists" -d $pond_home/$pond_regular/$pond_name
    @test "setup: pond link exists" -L $pond_home/$pond_links/$pond_name
    @test "setup: pond function directory exists" -d $pond_home/$pond_regular/$pond_name/$pond_functions
    @test "pond remove: success exit code" (echo "y" | eval $command >/dev/null 2>&1) $status -eq $success
    @test "pond remove: pond directory removed" ! -d $pond_home/$pond_regular/$pond_name
    @test "pond remove: pond link removed" ! -L $pond_home/$pond_links/$pond_name
    @test "pond remove: pond function directory removed" ! -d $pond_home/$pond_regular/$pond_name/$pond_functions

    @echo "$command: output tests for regular pond"
    __pond_setup_regular
    @test "pond remove: success output message" (echo "y" | eval $command 2>&1) = "Removed pond: $pond_name"

    @echo "$command: success tests for private pond"
    __pond_setup_private
    @test "setup: pond directory exists" -d $pond_home/$pond_private/$pond_name
    @test "setup: pond link exists" -L $pond_home/$pond_links/$pond_name
    @test "setup: pond function directory exists" -d $pond_home/$pond_private/$pond_name/$pond_functions
    @test "pond remove: success exit code" (echo "y" | eval $command >/dev/null 2>&1) $status -eq $success
    @test "pond remove: pond directory removed" ! -d $pond_home/$pond_private/$pond_name
    @test "pond remove: pond link removed" ! -L $pond_home/$pond_links/$pond_name
    @test "pond remove: pond function directory removed" ! -d $pond_home/$pond_private/$pond_name/$pond_functions

    @echo "$command: output tests for private pond"
    __pond_setup_private
    @test "pond remove: success output message" (echo "y" | eval $command 2>&1) = "Removed private pond: $pond_name"

end

@echo "pond remove: validation failure exit code tests"
@test "pond remove: fails for missing pond name" (pond remove >/dev/null 2>&1) $status -eq $fail
@test "pond remove: fails for trailing arguments" (pond remove $pond_name trailing >/dev/null 2>&1) $status -eq $fail
@test "pond remove: fails for malformed pond name" (pond remove _invalid >/dev/null 2>&1) $status -eq $fail
@test "pond remove: fails for non-existent pond" (pond remove no-exist >/dev/null 2>&1) $status -eq $fail

for valid_option in -e --empty -p --private
    for invalid_option in -i --invalid
        @test "pond remove: command usage shown for valid option $valid_option and missing pond name" (pond remove $valid_option >/dev/null 2>&1) $status -eq $fail
        @test "pond remove: command usage shown for valid option $valid_option and invalid pond name" (pond remove $valid_option _invalid >/dev/null 2>&1) $status -eq $fail
        @test "pond remove: command usage shown for invalid option $invalid_option and valid pond name" (pond remove $invalid_option $pond_name >/dev/null 2>&1) $status -eq $fail
        @test "pond remove: command usage shown for invalid option $invalid_option and invalid pond name" (pond remove $invalid_option _invalid >/dev/null 2>&1) $status -eq $fail
    end
end

@echo "pond remove: validation failure output tests"
@test "pond remove: command usage shown for missing pond name" (pond remove 2>&1 | string collect) = $command_usage
@test "pond remove: command usage shown for trailing arguments" (pond remove $pond_name trailing 2>&1 | string collect) = $command_usage
@test "pond remove: command usage shown for malformed pond name" (pond remove _invalid 2>&1 | string collect) = $command_usage
@test "pond remove: command usage shown for non-existent pond" (pond remove no-exist 2>&1 | string collect) = "Pond does not exist: no-exist"

for valid_option in -e --empty -p --private
    for invalid_option in -i --invalid
        @test "pond remove: command usage shown for valid option $valid_option and missing pond name" (pond remove $valid_option 2>&1 | string collect) = $command_usage
        @test "pond remove: command usage shown for valid option $valid_option and invalid pond name" (pond remove $valid_option _invalid 2>&1 | string collect) = $command_usage
        @test "pond remove: command usage shown for invalid option $invalid_option and valid pond name" (pond remove $invalid_option $pond_name 2>&1 | string collect) = $command_usage
        @test "pond remove: command usage shown for invalid option $invalid_option and invalid pond name" (pond remove $invalid_option _invalid 2>&1 | string collect) = $command_usage
    end
end

set -e __pond_setup_regular
set -e __pond_setup_private
set -e __pond_tear_down
set -e __pond_under_test
