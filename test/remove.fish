set fail 1
set success 0

set -x __pond_under_test yes
set pond_name pond

set command_usage "\
Usage:
    pond remove [options] <name>

Options:
    -s, --silent  Silence confirmation prompt

Arguments:
    name  The name of the pond to remove"

function __pond_setup
    pond create -e $pond_name
end

function __pond_tear_down
    echo 'y' | pond remove $pond_name
end

@echo 'remove command success tests'
__pond_setup
@test 'pond remove: success with confirmation' (echo 'y' | pond remove $pond_name >/dev/null 2>&1) $status -eq $success
@test "pond remove: pond directory removed" ! -d $pond_data/$pond_name

__pond_setup
@test 'pond remove: success with -s option' (pond remove -s $pond_name >/dev/null 2>&1) $status -eq $success
@test "pond remove: pond directory removed" ! -d $pond_data/$pond_name

__pond_setup
@test 'pond remove: success with --silent option' (pond remove --silent $pond_name >/dev/null 2>&1) $status -eq $success
@test "pond remove: pond directory removed" ! -d $pond_data/$pond_name

@echo 'remove command failure exit code tests'
__pond_setup
@test 'pond remove: fails for missing pond name' (pond remove >/dev/null 2>&1) $status -eq $fail
@test 'pond remove: fails for trailing arguments' (pond remove $pond_name trailing >/dev/null 2>&1) $status -eq $fail
@test 'pond remove: fails for missing pond name' (pond remove >/dev/null 2>&1) $status -eq $fail
@test 'pond remove: fails for malformed pond name' (pond remove _invalid >/dev/null 2>&1) $status -eq $fail
@test 'pond remove: fails for short invalid option' (pond remove -i >/dev/null 2>&1) $status -eq $fail
@test 'pond remove: fails for long invalid option' (pond remove --invalid >/dev/null 2>&1) $status -eq $fail
@test 'pond remove: fails for valid short option and missing pond name' (pond remove -e >/dev/null 2>&1) $status -eq $fail
@test 'pond remove: fails for valid long option and missing pond name' (pond remove --empty >/dev/null 2>&1) $status -eq $fail
@test 'pond remove: fails for invalid short option and valid pond name' (pond remove -i $pond_name >/dev/null 2>&1) $status -eq $fail
@test 'pond remove: fails for invalid long option and valid pond name' (pond remove --invalid $pond_name >/dev/null 2>&1) $status -eq $fail
@test 'pond remove: fails for non-existent pond' (pond remove non-exist >/dev/null 2>&1) $status -eq $fail
__pond_tear_down

@echo 'remove command failure usage output tests'
__pond_setup
@test 'pond remove: command usage shown for missing pond name' (pond remove 2>&1 | string collect) = $command_usage
@test 'pond remove: command usage shown for trailing arguments' (pond remove $pond_name trailing 2>&1 | string collect) = $command_usage
@test 'pond remove: command usage shown for missing pond name' (pond remove 2>&1 | string collect) = $command_usage
@test 'pond remove: command usage shown for malformed pond name' (pond remove _invalid 2>&1 | string collect) = $command_usage
@test 'pond remove: command usage shown for short invalid option' (pond remove -i 2>&1 | string collect) = $command_usage
@test 'pond remove: command usage shown for long invalid option' (pond remove --invalid 2>&1 | string collect) = $command_usage
@test 'pond remove: command usage shown for valid short option and missing pond name' (pond remove -e 2>&1 | string collect) = $command_usage
@test 'pond remove: command usage shown for valid long option and missing pond name' (pond remove --empty 2>&1 | string collect) = $command_usage
@test 'pond remove: command usage shown for invalid short option and valid pond name' (pond remove -i $pond_name 2>&1 | string collect) = $command_usage
@test 'pond remove: command usage shown for invalid long option and valid pond name' (pond remove --invalid $pond_name 2>&1 | string collect) = $command_usage
@test 'pond remove: command usage shown for non-existent pond' (pond remove non-exist 2>&1 | string collect) = "Pond does not exist: non-exist"
__pond_tear_down

set -e __pond_setup
set -e __pond_tear_down
set -e __pond_under_test
