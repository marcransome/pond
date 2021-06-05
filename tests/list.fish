source ./fixtures/functions.fish
source ./fixtures/variables.fish

set success_output_single_pond "\
$pond_name"

set success_output_multiple_ponds "\
$pond_name_prefix-1
$pond_name_prefix-2
$pond_name_prefix-3"

set no_match_error (__pond_error_string "No matching ponds")

set command_usage "\
Usage:
    pond list [options]

Options:
    -e, --enabled   List enabled ponds
    -d, --disabled  List disabled ponds"

for command in "pond list"

    @echo "$command: success tests for single enabled pond"
    __pond_setup 1 enabled unpopulated
    @test "pond list: success single enabled pond" (eval $command >/dev/null 2>&1) $status -eq $success
    @test "pond list: output message correct" (eval $command 2>&1 | string collect) = $success_output_single_pond
    __pond_tear_down

    @echo "$command: success tests for single disabled pond"
    __pond_setup 1 disabled unpopulated
    @test "pond list: success single disabled pond" (eval $command >/dev/null 2>&1) $status -eq $success
    @test "pond list: output message correct" (eval $command 2>&1 | string collect) = $success_output_single_pond
    __pond_tear_down

    @echo "$command: success tests for multiple enabled ponds"
    __pond_setup 3 enabled unpopulated
    @test "pond list: success multiple enabled ponds" (eval $command >/dev/null 2>&1) $status -eq $success
    @test "pond list: output message correct" (eval $command 2>&1 | string collect) = $success_output_multiple_ponds
    __pond_tear_down

    @echo "$command: success tests for multiple disabled ponds"
    __pond_setup 3 disabled unpopulated
    @test "pond list: success multiple disabled ponds" (eval $command >/dev/null 2>&1) $status -eq $success
    @test "pond list: output message correct" (eval $command 2>&1 | string collect) = $success_output_multiple_ponds
    __pond_tear_down

end

for command in "pond list "{-e,--enabled}

    @echo "$command: success tests for single enabled pond"
    __pond_setup 1 enabled unpopulated
    @test "pond list: success single enabled pond" (eval $command >/dev/null 2>&1) $status -eq $success
    @test "pond list: output message correct" (eval $command 2>&1 | string collect) = $success_output_single_pond
    __pond_tear_down

    @echo "$command: success tests for single disabled pond"
    __pond_setup 1 disabled unpopulated
    @test "pond list: success single disabled pond" (eval $command >/dev/null 2>&1) $status -eq $failure
    @test "pond list: output message correct" (eval $command 2>&1 | string collect) = $no_match_error
    __pond_tear_down


    @echo "$command: success tests for multiple enabled ponds"
    __pond_setup 3 enabled unpopulated
    @test "pond list: success multiple enabled ponds" (eval $command >/dev/null 2>&1) $status -eq $success
    @test "pond list: output message correct" (eval $command 2>&1 | string collect) = $success_output_multiple_ponds
    __pond_tear_down

    @echo "$command: success tests for multiple disabled ponds"
    __pond_setup 3 disabled unpopulated
    @test "pond list: success multiple enabled ponds" (eval $command >/dev/null 2>&1) $status -eq $failure
    @test "pond list: output message correct" (eval $command 2>&1 | string collect) = $no_match_error
    __pond_tear_down

end

for command in "pond list "{-d,--disabled}

    @echo "$command: success tests for single enabled pond"
    __pond_setup 1 enabled unpopulated
    @test "pond list: success single enabled pond" (eval $command >/dev/null 2>&1) $status -eq $failure
    @test "pond list: output message correct" (eval $command 2>&1 | string collect) = $no_match_error
    __pond_tear_down

    @echo "$command: success tests for single disabled pond"
    __pond_setup 1 disabled unpopulated
    @test "pond list: success single disabled pond" (eval $command >/dev/null 2>&1) $status -eq $success
    @test "pond list: output message correct" (eval $command 2>&1 | string collect) = $success_output_single_pond
    __pond_tear_down


    @echo "$command: success tests for multiple enabled ponds"
    __pond_setup 3 enabled unpopulated
    @test "pond list: success multiple enabled ponds" (eval $command >/dev/null 2>&1) $status -eq $failure
    @test "pond list: output message correct" (eval $command 2>&1 | string collect) = $no_match_error
    __pond_tear_down

    @echo "$command: success tests for multiple disabled ponds"
    __pond_setup 3 disabled unpopulated
    @test "pond list: success multiple enabled ponds" (eval $command >/dev/null 2>&1) $status -eq $success
    @test "pond list: output message correct" (eval $command 2>&1 | string collect) = $success_output_multiple_ponds
    __pond_tear_down

end

@echo "pond list: validation failure exit code tests"
@test "pond list: fails for trailing arguments" (pond list trailing >/dev/null 2>&1) $status -eq $failure

for invalid_option in -i --invalid
    @test "pond list: fails for invalid option $invalid_option" (pond list $invalid_option >/dev/null 2>&1) $status -eq $failure
end

@echo "pond list: validation failure output tests"
@test "pond list: command usage shown for trailing arguments" (pond list trailing 2>&1 | string collect) = $command_usage

for invalid_option in -i --invalid
    @test "pond list: command usage shown for invalid option $invalid_option" (pond list $invalid_option 2>&1 | string collect) = $command_usage
end
