set fail 1
set success 0

set -x __pond_under_test yes
set pond_name test-pond
set pond_editor_before_test $pond_editor

set command_usage "\
Usage:
    pond create [options] <name>

Options:
    -e, --empty    Create an empty pond; do not open editor
    -p, --private  Create a private pond

Arguments:
    name  The name of the pond to create; a pond names must
          begin with an alphanumeric character followed by
          any number of additional alphanumeric characters,
          underscores or dashes"

function __pond_setup
    pond create -e $pond_name >/dev/null 2>&1
end

function __pond_tear_down
    echo "y" | pond remove $pond_name >/dev/null 2>&1
end

function __pond_editor_intercept_with -a function_name
    set -x pond_editor $function_name
end

function __pond_regular_pond_editor -a pond_path
    if ! test "$pond_path" = "$pond_home/$pond_regular/$pond_name/$pond_vars"
        return 1
    end
end

function __pond_private_pond_editor -a pond_path
    if ! test "$pond_path" = "$pond_home/$pond_private/$pond_name/$pond_vars"
        return 1
    end
end

function __pond_editor_reset
    set pond_editor $pond_editor_before_test
end

# TODO directory mode permissions tests (755 regular pond, 700 private

@echo "pond create $pond_name: success tests"
__pond_editor_intercept_with __pond_regular_pond_editor
@test "pond create: success exit code" (pond create $pond_name >/dev/null 2>&1) $status -eq $success
@test "pond create: pond directory created" -d $pond_home/$pond_regular/$pond_name
@test "pond create: functions directory created" -d $pond_home/$pond_regular/$pond_name/$pond_functions
@test "pond create: variables file created" -f $pond_home/$pond_regular/$pond_name/$pond_vars
__pond_tear_down
@test "pond create: output message correct" (pond create $pond_name 2>&1) = "Created pond: $pond_name"
__pond_tear_down
__pond_editor_reset

for command in "pond create "{-e,--empty}" $pond_name"
    @echo "$command: success tests"
    @test "pond create: success exit code" (eval $command >/dev/null 2>&1) $status -eq $success
    @test "pond create: pond directory created" -d $pond_home/$pond_regular/$pond_name
    @test "pond create: functions directory created" -d $pond_home/$pond_regular/$pond_name/$pond_functions
    @test "pond create: variables file created" -f $pond_home/$pond_regular/$pond_name/$pond_vars
    __pond_tear_down
    @test "pond create: output message correct" (eval $command 2>&1) = "Created pond: $pond_name"
    __pond_tear_down
end

for command in "pond create "{-p,--private}" $pond_name"
    @echo "$command: success tests"
    __pond_editor_intercept_with __pond_private_pond_editor
    @test "pond create: success exit code" (eval $command >/dev/null 2>&1) $status -eq $success
    @test "pond create: pond directory created" -d $pond_home/$pond_private/$pond_name
    @test "pond create: pond functions directory created" -d $pond_home/$pond_private/$pond_name/$pond_functions
    @test "pond create: pond variables file created" -f $pond_home/$pond_private/$pond_name/$pond_vars
    __pond_tear_down
    @test "pond create: output message correct" (eval $command 2>&1) = "Created private pond: $pond_name"
    __pond_tear_down
    __pond_editor_reset
end

@echo "pond create: validation failure exit code tests"
__pond_setup
@test "pond create: fails for missing pond name" (pond create >/dev/null 2>&1) $status -eq $fail
@test "pond create: fails for trailing arguments" (pond create $pond_name trailing >/dev/null 2>&1) $status -eq $fail
@test "pond create: fails for malformed pond name" (pond create _invalid >/dev/null 2>&1) $status -eq $fail
@test "pond create: fails for existing pond" (pond create $pond_name >/dev/null 2>&1) $status -eq $fail
__pond_tear_down

for valid_option in -e --empty -p --private
    for invalid_option in -i --invalid
        @test "pond create: command usage shown for valid option $valid_option and missing pond name" (pond create $valid_option >/dev/null 2>&1) $status -eq $fail
        @test "pond create: command usage shown for valid option $valid_option and invalid pond name" (pond create $valid_option _invalid >/dev/null 2>&1) $status -eq $fail
        @test "pond create: command usage shown for invalid option $invalid_option and valid pond name" (pond create $invalid_option $pond_name >/dev/null 2>&1) $status -eq $fail
        @test "pond create: command usage shown for invalid option $invalid_option and invalid pond name" (pond create $invalid_option _invalid >/dev/null 2>&1) $status -eq $fail
    end
end

@echo "pond create: validation failure output tests"
__pond_setup
@test "pond create: command usage shown for missing pond name" (pond create 2>&1 | string collect) = $command_usage
@test "pond create: command usage shown for trailing arguments" (pond create $pond_name trailing 2>&1 | string collect) = $command_usage
@test "pond create: command usage shown for malformed pond name" (pond create _invalid 2>&1 | string collect) = $command_usage
@test "pond create: command error shown for existing pond" (pond create $pond_name 2>&1 | string collect) = "Pond already exists: $pond_name"
__pond_tear_down

for valid_option in -e --empty -p --private
    for invalid_option in -i --invalid
        @test "pond create: command usage shown for valid option $valid_option and missing pond name" (pond create $valid_option 2>&1 | string collect) = $command_usage
        @test "pond create: command usage shown for valid option $valid_option and invalid pond name" (pond create $valid_option _invalid 2>&1 | string collect) = $command_usage
        @test "pond create: command usage shown for invalid option $invalid_option and valid pond name" (pond create $invalid_option $pond_name 2>&1 | string collect) = $command_usage
        @test "pond create: command usage shown for invalid option $invalid_option and invalid pond name" (pond create $invalid_option _invalid 2>&1 | string collect) = $command_usage
    end
end

set -e __pond_setup
set -e __pond_editor_intercept_with
set -e __pond_regular_pond_editor
set -e __pond_private_pond_editor
set -e __pond_editor_reset
set -e __pond_tear_down
set -e __pond_under_test
