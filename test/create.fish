set fail 1
set success 0

set -x __pond_under_test yes
set pond_name pond

set command_usage "\
Usage:
    pond create [options] <name>

Options:
    -e, --empty  Create pond without opening editor

Arguments:
    name  The name of the pond to create"

function __pond_setup
    pond create -e $pond_name
end

function __pond_tear_down
    echo 'y' | pond remove $pond_name
end

# success tests
@test 'pond create: success invoking editor' (pond create $pond_name >/dev/null 2>&1) $status -eq $success
__pond_tear_down
@test 'pond create: success with -e option' (pond create -e $pond_name >/dev/null 2>&1) $status -eq $success
__pond_tear_down
@test 'pond create: success with --empty option' (pond create --empty $pond_name >/dev/null 2>&1) $status -eq $success
__pond_tear_down

# failure exit code tests
__pond_setup
@test 'pond create: fails for missing pond name' (pond create >/dev/null 2>&1) $status -eq $fail
@test 'pond create: fails for trailing arguments' (pond create $pond_name trailing >/dev/null 2>&1) $status -eq $fail
@test 'pond create: fails for missing pond name' (pond create >/dev/null 2>&1) $status -eq $fail
@test 'pond create: fails for malformed pond name' (pond create _invalid >/dev/null 2>&1) $status -eq $fail
@test 'pond create: fails for short invalid option' (pond create -i >/dev/null 2>&1) $status -eq $fail
@test 'pond create: fails for long invalid option' (pond create --invalid >/dev/null 2>&1) $status -eq $fail
@test 'pond create: fails for valid short option and missing pond name' (pond create -e >/dev/null 2>&1) $status -eq $fail
@test 'pond create: fails for valid long option and missing pond name' (pond create --empty >/dev/null 2>&1) $status -eq $fail
@test 'pond create: fails for invalid short option and valid pond name' (pond create -i $pond_name >/dev/null 2>&1) $status -eq $fail
@test 'pond create: fails for invalid long option and valid pond name' (pond create --invalid $pond_name >/dev/null 2>&1) $status -eq $fail
@test 'pond create: fails for existing pond' (pond create $pond_name >/dev/null 2>&1) $status -eq $fail
__pond_tear_down

# failure usage output tests
__pond_setup
@test 'pond create: command usage shown for missing pond name' (pond create 2>&1 | string collect) = $command_usage
@test 'pond create: command usage shown for trailing arguments' (pond create $pond_name trailing 2>&1 | string collect) = $command_usage
@test 'pond create: command usage shown for missing pond name' (pond create 2>&1 | string collect) = $command_usage
@test 'pond create: fails for malformed pond name' (pond create _invalid 2>&1 | string collect) = $command_usage
@test 'pond create: fails for short invalid option' (pond create -i 2>&1 | string collect) = $command_usage
@test 'pond create: fails for long invalid option' (pond create --invalid 2>&1 | string collect) = $command_usage
@test 'pond create: fails for valid short option and missing pond name' (pond create -e 2>&1 | string collect) = $command_usage
@test 'pond create: fails for valid long option and missing pond name' (pond create --empty 2>&1 | string collect) = $command_usage
@test 'pond create: fails for invalid short option and valid pond name' (pond create -i $pond_name 2>&1 | string collect) = $command_usage
@test 'pond create: fails for invalid long option and valid pond name' (pond create --invalid $pond_name 2>&1 | string collect) = $command_usage
@test 'pond create: fails for existing pond' (pond create $pond_name 2>&1 | string collect) = "Pond already exists: pond"
__pond_tear_down

set -e __pond_setup
set -e __pond_tear_down
set -e __pond_under_test
