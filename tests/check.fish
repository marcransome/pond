set parent (dirname (status --current-filename))
source $parent/fixtures/functions.fish
source $parent/fixtures/variables.fish

set command_usage "\
Usage:
    pond check ponds...

Arguments:
    ponds  The name of one or more ponds to check"

set not_exists_error (__pond_error_string "Pond does not exist: no-exist")

function __pond_syntax_success_string_autoload -a pond_name
    echo -n "  "; set_color green; and echo -n "✔"; and set_color normal; and echo " "{$pond_name}_autoload.fish;
end

function __pond_syntax_success_string_autounload -a pond_name
    echo -n "  "; set_color green; and echo -n "✔"; and set_color normal; and echo " "{$pond_name}_autounload.fish;
end

function __pond_syntax_failure_string_autoload -a pond_name
    echo -n "  "; set_color red; and echo -n "✖"; and set_color normal; and echo " "{$pond_name}_autoload.fish;
end

function __pond_syntax_failure_string_autounload -a pond_name
    echo -n "  "; set_color red; and echo -n "✖"; and set_color normal; and echo " "{$pond_name}_autounload.fish;
end

function __pond_syntax_totals_string -a passed failed total
    set_color green; and echo -n "passed: $passed";
    and set_color normal; and echo -n "  ";
    and set_color red; and echo -n "failed: $failed";
    and set_color normal; and echo "  of $total functions"
end

set success_output_single_pond "\
Checking pond '$pond_name' for syntax issues..
"(__pond_syntax_success_string_autoload $pond_name)"
"(__pond_syntax_success_string_autounload $pond_name)"
"(__pond_syntax_totals_string 2 0 2)

set success_output_multiple_ponds "\
Checking pond '$pond_name_prefix-1' for syntax issues..
"(__pond_syntax_success_string_autoload $pond_name_prefix-1)"
"(__pond_syntax_success_string_autounload $pond_name_prefix-1)"
"(__pond_syntax_totals_string 2 0 2)"
Checking pond '$pond_name_prefix-2' for syntax issues..
"(__pond_syntax_success_string_autoload $pond_name_prefix-2)"
"(__pond_syntax_success_string_autounload $pond_name_prefix-2)"
"(__pond_syntax_totals_string 2 0 2)"
Checking pond '$pond_name_prefix-3' for syntax issues..
"(__pond_syntax_success_string_autoload $pond_name_prefix-3)"
"(__pond_syntax_success_string_autounload $pond_name_prefix-3)"
"(__pond_syntax_totals_string 2 0 2)

set failure_output_single_pond "\
Checking pond '$pond_name' for syntax issues..
"(__pond_syntax_failure_string_autoload $pond_name)"
"(__pond_syntax_failure_string_autounload $pond_name)"
"(__pond_syntax_totals_string 0 2 2)

# The 'check' subcommand exits on the first pond with syntax issues
set failure_output_multiple_ponds "\
Checking pond '$pond_name_prefix-1' for syntax issues..
"(__pond_syntax_failure_string_autoload $pond_name_prefix-1)"
"(__pond_syntax_failure_string_autounload $pond_name_prefix-1)"
"(__pond_syntax_totals_string 0 2 2)

@echo "pond check: success tests for single pond with valid autoload/autounload functions"
__pond_setup 1 enabled loaded populated
@test "pond check: success exit code" (pond check $pond_name >/dev/null 2>&1) $status -eq $success
__pond_tear_down

@echo "pond check: success output tests for single pond with valid autoload/autounload functions"
__pond_setup 1 enabled loaded populated
@test "pond check: success output message" (pond check $pond_name 2>&1 | string collect) = $success_output_single_pond
__pond_tear_down

@echo "pond check: failure tests for single pond with invalid autoload/autounload functions"
__pond_setup 1 enabled loaded populated
echo "end" > $pond_home/$pond_name/{$pond_name}_autoload.fish
echo "end" > $pond_home/$pond_name/{$pond_name}_autounload.fish
@test "setup: invalid autoload function definition" (cat $pond_home/$pond_name/{$pond_name}_autoload.fish | string collect) = "end"
@test "setup: invalid autounload function definition" (cat $pond_home/$pond_name/{$pond_name}_autounload.fish | string collect) = "end"
@test "pond check: failure exit code" (pond check $pond_name >/dev/null 2>&1) $status -eq $failure
__pond_tear_down

@echo "pond check: failure output tests for single pond with invalid autoload/autounload functions"
__pond_setup 1 enabled loaded populated
echo "end" > $pond_home/$pond_name/{$pond_name}_autoload.fish
echo "end" > $pond_home/$pond_name/{$pond_name}_autounload.fish
@test "setup: invalid autoload function definition" (cat $pond_home/$pond_name/{$pond_name}_autoload.fish | string collect) = "end"
@test "setup: invalid autounload function definition" (cat $pond_home/$pond_name/{$pond_name}_autounload.fish | string collect) = "end"
@test "pond check: failure output message" (pond check $pond_name 2>&1 | string collect) = $failure_output_single_pond
__pond_tear_down

__pond_setup 3 enabled loaded populated
@echo "pond check: success tests for multiple ponds with valid autoload/autounload functions"
@test "pond check: success exit code" (pond check $pond_name_prefix-1 $pond_name_prefix-2 $pond_name_prefix-3 >/dev/null 2>&1) $status -eq $success

@echo "pond check: success output tests for multiple ponds with valid autoload/autounload functions"
@test "pond check: success output message" (pond check $pond_name_prefix-1 $pond_name_prefix-2 $pond_name_prefix-3 2>&1 | string collect) = $success_output_multiple_ponds
__pond_tear_down

__pond_setup 3 enabled loaded populated
@echo "pond check: failure tests for multiple ponds with invalid autoload/autounload functions"
echo "end" > $pond_home/$pond_name_prefix-1/{$pond_name_prefix-1}_autoload.fish
echo "end" > $pond_home/$pond_name_prefix-1/{$pond_name_prefix-1}_autounload.fish
@test "setup: $pond_name_prefix-1 invalid autoload function definition" (cat $pond_home/$pond_name_prefix-1/{$pond_name_prefix-1}_autoload.fish | string collect) = "end"
@test "setup: $pond_name_prefix-1 invalid autounload function definition" (cat $pond_home/$pond_name_prefix-1/{$pond_name_prefix-1}_autounload.fish | string collect) = "end"
@test "pond check: failure exit code" (pond check $pond_name_prefix-1 $pond_name_prefix-2 $pond_name_prefix-3 >/dev/null 2>&1) $status -eq $failure

@echo "pond check: failure output tests for multiple ponds with invalid autoload/autounload functions"
@test "pond check: failure output message" (pond check $pond_name_prefix-1 $pond_name_prefix-2 $pond_name_prefix-3 2>&1 | string collect) = $failure_output_multiple_ponds
__pond_tear_down

@echo "pond check: validation failure exit code tests"
@test "pond check: fails for missing pond name" (pond check >/dev/null 2>&1) $status -eq $failure
@test "pond check: fails for malformed pond name" (pond check _invalid >/dev/null 2>&1) $status -eq $failure
@test "pond check: fails for non-existent pond" (pond check no-exist >/dev/null 2>&1) $status -eq $failure

@echo "pond check: validation failure output tests"
@test "pond check: command usage shown for missing pond name" (pond check 2>&1 | string collect) = $command_usage
@test "pond check: command usage shown for malformed pond name" (pond check _invalid 2>&1 | string collect) = $command_usage
@test "pond check: command error shown for non-existent pond" (pond check no-exist 2>&1 | string collect) = $not_exists_error
