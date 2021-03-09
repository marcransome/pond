source ./helpers/functions.fish
source ./helpers/variables.fish

set pond_editor_before_test "$pond_editor"

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

function __pond_create_event_intercept --on-event pond_created -a got_pond_name got_pond_path
    set -g event_pond_name $got_pond_name
    set -g event_pond_path $got_pond_path
end

function __pond_create_event_reset
    set -e event_pond_name
    set -e event_pond_path
end

# TODO directory mode permissions tests (755 regular pond, 700 private

@echo "pond create $pond_name_regular: success tests"
__pond_editor_intercept_with __pond_regular_pond_editor
@test "pond create: success exit code" (pond create $pond_name_regular >/dev/null 2>&1) $status -eq $success
@test "pond create: pond directory created" -d $pond_home/$pond_regular/$pond_name_regular
@test "pond create: functions directory created" -d $pond_home/$pond_regular/$pond_name_regular/$pond_functions
@test "pond create: variables file created" -f $pond_home/$pond_regular/$pond_name_regular/$pond_vars
@test "pond create: got pond name in event" (echo $event_pond_name) = $pond_name_regular
@test "pond create: got pond path in event" (echo $event_pond_path) = $pond_home/$pond_regular/$pond_name_regular
__pond_tear_down
@test "pond create: output message correct" (pond create $pond_name_regular 2>&1) = "Created pond: $pond_name_regular"
__pond_tear_down
__pond_editor_reset
__pond_create_event_reset

for command in "pond create "{-e,--empty}" $pond_name_regular"
    @echo "$command: success tests"
    @test "pond create: success exit code" (eval $command >/dev/null 2>&1) $status -eq $success
    @test "pond create: pond directory created" -d $pond_home/$pond_regular/$pond_name_regular
    @test "pond create: functions directory created" -d $pond_home/$pond_regular/$pond_name_regular/$pond_functions
    @test "pond create: variables file created" -f $pond_home/$pond_regular/$pond_name_regular/$pond_vars
    @test "pond create: got pond name in event" (echo $event_pond_name) = $pond_name_regular
    @test "pond create: got pond path in event" (echo $event_pond_path) = $pond_home/$pond_regular/$pond_name_regular
    __pond_tear_down
    @test "pond create: output message correct" (eval $command 2>&1) = "Created pond: $pond_name_regular"
    __pond_tear_down
    __pond_create_event_reset
end

for command in "pond create "{-p,--private}" $pond_name_private"
    @echo "$command: success tests"
    __pond_editor_intercept_with __pond_private_pond_editor
    @test "pond create: success exit code" (eval $command >/dev/null 2>&1) $status -eq $success
    @test "pond create: pond directory created" -d $pond_home/$pond_private/$pond_name_private
    @test "pond create: pond functions directory created" -d $pond_home/$pond_private/$pond_name_private/$pond_functions
    @test "pond create: pond variables file created" -f $pond_home/$pond_private/$pond_name_private/$pond_vars
    @test "pond create: got pond name in event" (echo $event_pond_name) = $pond_name_private
    @test "pond create: got pond path in event" (echo $event_pond_path) = $pond_home/$pond_private/$pond_name_private
    __pond_tear_down
    @test "pond create: output message correct" (eval $command 2>&1) = "Created private pond: $pond_name_private"
    __pond_tear_down
    __pond_editor_reset
    __pond_create_event_reset
end

@echo "pond create: validation failure exit code tests"
@test "pond create: fails for missing pond name" (pond create >/dev/null 2>&1) $status -eq $fail
@test "pond create: fails for trailing arguments" (pond create $pond_name_regular trailing >/dev/null 2>&1) $status -eq $fail
@test "pond create: fails for malformed pond name" (pond create _invalid >/dev/null 2>&1) $status -eq $fail

__pond_setup 1 regular enabled unpopulated
@test "pond create: fails for existing regular pond" (pond create $pond_name_regular >/dev/null 2>&1) $status -eq $fail
__pond_tear_down

for option in -p --private
    __pond_setup 1 private enabled unpopulated
    @test "pond create: fails for existing private pond with option $option" (pond create $option $pond_name_private >/dev/null 2>&1) $status -eq $fail
    __pond_tear_down
end

for valid_option in -e --empty -p --private
    @test "pond create: fails for valid option $valid_option and missing pond name" (pond create $valid_option >/dev/null 2>&1) $status -eq $fail
    @test "pond create: fails for valid option $valid_option and invalid pond name" (pond create $valid_option _invalid >/dev/null 2>&1) $status -eq $fail
end

for invalid_option in -i --invalid
    @test "pond create: fails for invalid option $invalid_option and valid pond name" (pond create $invalid_option $pond_name_regular >/dev/null 2>&1) $status -eq $fail
    @test "pond create: fails for invalid option $invalid_option and invalid pond name" (pond create $invalid_option _invalid >/dev/null 2>&1) $status -eq $fail
end

@echo "pond create: validation failure output tests"
@test "pond create: command usage shown for missing pond name" (pond create 2>&1 | string collect) = $command_usage
@test "pond create: command usage shown for trailing arguments" (pond create $pond_name_regular trailing 2>&1 | string collect) = $command_usage
@test "pond create: command usage shown for malformed pond name" (pond create _invalid 2>&1 | string collect) = $command_usage

__pond_setup 1 regular enabled unpopulated
@test "pond create: command error shown for existing regular pond" (pond create $pond_name_regular 2>&1 | string collect) = "Pond already exists: $pond_name_regular"
__pond_tear_down

for option in -p --private
    __pond_setup 1 private enabled unpopulated
    @test "pond create: command error shown for existing private pond with option $option" (pond create $option $pond_name_private 2>&1 | string collect) = "Pond already exists: $pond_name_private"
    __pond_tear_down
end

for valid_option in -e --empty -p --private
    @test "pond create: command usage shown for valid option $valid_option and missing pond name" (pond create $valid_option 2>&1 | string collect) = $command_usage
    @test "pond create: command usage shown for valid option $valid_option and invalid pond name" (pond create $valid_option _invalid 2>&1 | string collect) = $command_usage
end

for invalid_option in -i --invalid
    @test "pond create: command usage shown for invalid option $invalid_option and valid pond name" (pond create $invalid_option $pond_name 2>&1 | string collect) = $command_usage
    @test "pond create: command usage shown for invalid option $invalid_option and invalid pond name" (pond create $invalid_option _invalid 2>&1 | string collect) = $command_usage
end
