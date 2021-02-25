set fail 1
set success 0

set -x __pond_under_test yes
set pond_name test-pond

set success_output_single "\
$pond_name"

set success_output_multiple "\
$pond_name-1
$pond_name-2
$pond_name-3"

set command_usage "\
Usage:
    pond list"

function __pond_setup_single
    pond create -e $pond_name >/dev/null 2>&1
end

function __pond_setup_multiple
    pond create -e $pond_name-1 >/dev/null 2>&1
    pond create -e $pond_name-2 >/dev/null 2>&1
    pond create -e $pond_name-3 >/dev/null 2>&1
end

function __pond_tear_down_single
    pond remove -s $pond_name >/dev/null 2>&1
end

function __pond_tear_down_multiple
    pond remove -s $pond_name-1 >/dev/null 2>&1
    pond remove -s $pond_name-2 >/dev/null 2>&1
    pond remove -s $pond_name-3 >/dev/null 2>&1
end

@echo "pond list: success tests for single pond"
__pond_setup_single
@test "pond list: success single pond" (pond list >/dev/null 2>&1) $status -eq $success
@test "pond list: output success single pond" (pond list 2>&1 | string collect) = $success_output_single
__pond_tear_down_single

@echo "pond list: success tests for multiple ponds"
__pond_setup_multiple
@test "pond list: success multiple ponds" (pond list >/dev/null 2>&1) $status -eq $success
@test "pond list: output success multiple ponds" (pond list 2>&1 | string collect) = $success_output_multiple
__pond_tear_down_multiple

@echo "pond list: validation failure exit code tests"
__pond_setup_single
@test "pond list: fails for trailing arguments" (pond list trailing >/dev/null 2>&1) $status -eq $fail
__pond_tear_down_single

@echo "pond list: validation output tests"
__pond_setup_single
@test "pond list: command usage shown for trailing arguments" (pond list trailing 2>&1 | string collect) = $command_usage
__pond_tear_down_single
