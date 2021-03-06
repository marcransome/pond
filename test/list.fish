set fail 1
set success 0

set -x __pond_under_test yes
set pond_name test-pond
set pond_name_private test-private-pond

set success_output_single_regular "\
$pond_name"

set success_output_single_private "\
$pond_name_private"

set combined_output_single "\
$pond_name
$pond_name_private"

set success_output_multiple_regular "\
$pond_name-1
$pond_name-2
$pond_name-3"

set success_output_multiple_private "\
$pond_name_private-1
$pond_name_private-2
$pond_name_private-3"

set combined_output_multiple "\
$pond_name-1
$pond_name-2
$pond_name-3
$pond_name_private-1
$pond_name_private-2
$pond_name_private-3"

set command_usage "\
Usage:
    pond list [options]

Options:
    -p, --private   List private ponds
    -r, --regular   List regular ponds
    -e, --enabled   List enabled ponds
    -d, --disabled  List disabled ponds"

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


for command in "pond list" "pond list "{-r,--regular}

    @echo "$command: success tests for regular pond"
    __pond_setup_single_regular
    @test "pond list: success regular pond" (eval $command >/dev/null 2>&1) $status -eq $success
    @test "pond list: output message correct" (eval $command 2>&1 | string collect) = $success_output_single_regular
    __pond_tear_down_single_regular

    @echo "$command: success tests for disabled regular pond"
    __pond_setup_single_regular_disabled
    @test "pond list: success disabled regular pond" (eval $command >/dev/null 2>&1) $status -eq $success
    @test "pond list: output message correct" (eval $command 2>&1 | string collect) = $success_output_single_regular
    __pond_tear_down_single_regular

    @echo "$command: success tests for multiple regular ponds"
    __pond_setup_multiple_regular
    @test "pond list: success multiple regular ponds" (eval $command >/dev/null 2>&1) $status -eq $success
    @test "pond list: output message correct" (eval $command 2>&1 | string collect) = $success_output_multiple_regular
    __pond_tear_down_multiple_regular

    @echo "$command: success tests for multiple disabled regular ponds"
    __pond_setup_multiple_regular_disabled
    @test "pond list: success multiple disabled regular ponds" (eval $command >/dev/null 2>&1) $status -eq $success
    @test "pond list: output message correct" (eval $command 2>&1 | string collect) = $success_output_multiple_regular
    __pond_tear_down_multiple_regular

end

for command in "pond list" "pond list "{-p,--private}

    @echo "$command: success tests for private pond"
    __pond_setup_single_private
    @test "pond list: success private pond" (eval $command >/dev/null 2>&1) $status -eq $success
    @test "pond list: output message correct" (eval $command 2>&1 | string collect) = $success_output_single_private
    __pond_tear_down_single_private

    @echo "$command: success tests for disabled private pond"
    __pond_setup_single_private_disabled
    @test "pond list: success disabled private pond" (eval $command >/dev/null 2>&1) $status -eq $success
    @test "pond list: output message correct" (eval $command 2>&1 | string collect) = $success_output_single_private
    __pond_tear_down_single_private

    @echo "$command: success tests for multiple private ponds"
    __pond_setup_multiple_private
    @test "pond list: success multiple private ponds" (eval $command >/dev/null 2>&1) $status -eq $success
    @test "pond list: output message correct" (eval $command 2>&1 | string collect) = $success_output_multiple_private
    __pond_tear_down_multiple_private

    @echo "$command: success tests for multiple disabled private ponds"
    __pond_setup_multiple_private_disabled
    @test "pond list: success multiple disabled private ponds" (eval $command >/dev/null 2>&1) $status -eq $success
    @test "pond list: output message correct" (eval $command 2>&1 | string collect) = $success_output_multiple_private
    __pond_tear_down_multiple_private

end

for command in "pond list" "pond list "{-p,--private}" "{-r,--regular}

    @echo "$command: success tests for regular and private ponds"
    __pond_setup_single_regular
    __pond_setup_single_private
    @test "pond list: success regular and private pond" (eval $command >/dev/null 2>&1) $status -eq $success
    @test "pond list: output message correct" (eval $command 2>&1 | string collect) = $combined_output_single
    __pond_tear_down_single_regular
    __pond_tear_down_single_private

    @echo "$command: success tests for disabled regular and private ponds"
    __pond_setup_single_regular_disabled
    __pond_setup_single_private_disabled
    @test "pond list: success disabled regular and private ponds" (eval $command >/dev/null 2>&1) $status -eq $success
    @test "pond list: output message correct" (eval $command 2>&1 | string collect) = $combined_output_single
    __pond_tear_down_single_regular
    __pond_tear_down_single_private

    @echo "$command: success tests for multiple regular and private ponds"
    __pond_setup_multiple_regular
    __pond_setup_multiple_private
    @test "pond list: success multiple regular and private ponds" (eval $command >/dev/null 2>&1) $status -eq $success
    @test "pond list: output message correct" (eval $command 2>&1 | string collect) = $combined_output_multiple
    __pond_tear_down_multiple_regular
    __pond_tear_down_multiple_private

    @echo "$command: success tests for multiple disabled regular and private ponds"
    __pond_setup_multiple_regular_disabled
    __pond_setup_multiple_private_disabled
    @test "pond list: success multiple disabled regular and private ponds" (eval $command >/dev/null 2>&1) $status -eq $success
    @test "pond list: output message correct" (eval $command 2>&1 | string collect) = $combined_output_multiple
    __pond_tear_down_multiple_regular
    __pond_tear_down_multiple_private

end

for command in "pond list" "pond list "{-e,--enabled}

    @echo "$command: success tests for enabled regular pond"
    __pond_setup_single_regular
    @test "pond list: enabled regular pond" (eval $command >/dev/null 2>&1) $status -eq $success
    @test "pond list: output message correct" (eval $command 2>&1 | string collect) = $success_output_single_regular
    __pond_tear_down_single_regular

    @echo "$command: success tests for enabled private pond"
    __pond_setup_single_private
    @test "pond list: success enabled private pond" (eval $command >/dev/null 2>&1) $status -eq $success
    @test "pond list: output message correct" (eval $command 2>&1 | string collect) = $success_output_single_private
    __pond_tear_down_single_private

    @echo "$command: success tests for multiple enabled regular ponds"
    __pond_setup_multiple_regular
    @test "pond list: success multiple enabled regular ponds" (eval $command >/dev/null 2>&1) $status -eq $success
    @test "pond list: output message correct" (eval $command 2>&1 | string collect) = $success_output_multiple_regular
    __pond_tear_down_multiple_regular

    @echo "$command: success tests for multiple enabled private ponds"
    __pond_setup_multiple_private
    @test "pond list: success multiple enabled private ponds" (eval $command >/dev/null 2>&1) $status -eq $success
    @test "pond list: output message correct" (eval $command 2>&1 | string collect) = $success_output_multiple_private
    __pond_tear_down_multiple_private
end
for command in "pond list "{-r,--regular}

    @echo "$command: failure tests for missing regular ponds"
    @test "pond list: fails for missing ponds when none exist" (eval $command >/dev/null 2>&1) $status -eq $fail
    @test "pond list: output message correct" (eval $command 2>&1 | string collect) = "No ponds found"

    __pond_setup_multiple_private
    @test "pond list: fails for missing ponds when only private ponds exist" (eval $command >/dev/null 2>&1) $status -eq $fail
    @test "pond list: output message correct" (eval $command 2>&1 | string collect) = "No ponds found"
    __pond_tear_down_multiple_private

end

for command in "pond list "{-p,--private}

    @echo "$command: failure tests for missing private ponds"
    @test "pond list: fails for missing ponds when none exist" (eval $command >/dev/null 2>&1) $status -eq $fail
    @test "pond list: output message correct" (eval $command 2>&1 | string collect) = "No ponds found"

    __pond_setup_multiple_regular
    @test "pond list: fails for missing ponds when only regular ponds exist" (eval $command >/dev/null 2>&1) $status -eq $fail
    @test "pond list: output message correct" (eval $command 2>&1 | string collect) = "No ponds found"
    __pond_tear_down_multiple_regular

end

for command in "pond list "{-e,--enabled}

    @echo "$command: failure tests for missing ponds"
    @test "pond list: fails for missing ponds when none exist" (eval $command >/dev/null 2>&1) $status -eq $fail
    @test "pond list: output message correct" (eval $command 2>&1 | string collect) = "No ponds found"

    __pond_setup_multiple_regular_disabled
    @test "pond list: fails for missing ponds when only disabled regular ponds exist" (eval $command >/dev/null 2>&1) $status -eq $fail
    @test "pond list: output message correct" (eval $command 2>&1 | string collect) = "No ponds found"
    __pond_tear_down_multiple_regular

    __pond_setup_multiple_private_disabled
    @test "pond list: fails for missing ponds when only disabled private ponds exist" (eval $command >/dev/null 2>&1) $status -eq $fail
    @test "pond list: output message correct" (eval $command 2>&1 | string collect) = "No ponds found"
    __pond_tear_down_multiple_private

end

for command in "pond list "{-d,--disabled}

    @echo "$command: failure tests for missing ponds"
    @test "pond list: fails for missing ponds when none exist" (eval $command >/dev/null 2>&1) $status -eq $fail
    @test "pond list: output message correct" (eval $command 2>&1 | string collect) = "No ponds found"

    __pond_setup_multiple_regular
    @test "pond list: fails for missing ponds when only enabled regular ponds exist" (eval $command >/dev/null 2>&1) $status -eq $fail
    @test "pond list: output message correct" (eval $command 2>&1 | string collect) = "No ponds found"
    __pond_tear_down_multiple_regular

    __pond_setup_multiple_private
    @test "pond list: fails for missing ponds when only enabled private ponds exist" (eval $command >/dev/null 2>&1) $status -eq $fail
    @test "pond list: output message correct" (eval $command 2>&1 | string collect) = "No ponds found"
    __pond_tear_down_multiple_private

end

@echo "pond list: validation failure exit code tests"
@test "pond list: fails for trailing arguments" (pond list trailing >/dev/null 2>&1) $status -eq $fail

for invalid_option in -i --invalid
    @test "pond list: fails for invalid option $invalid_option" (pond list $invalid_option >/dev/null 2>&1) $status -eq $fail
end

@echo "pond list: validation failure output tests"
@test "pond list: command usage shown for trailing arguments" (pond list trailing 2>&1 | string collect) = $command_usage

for invalid_option in -i --invalid
    @test "pond list: command usage shown for invalid option $invalid_option" (pond list $invalid_option 2>&1 | string collect) = $command_usage
end
