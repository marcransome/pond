source ./helpers/functions.fish
source ./helpers/variables.fish

set success_output_single_regular "\
$pond_name_regular"

set success_output_single_private "\
$pond_name_private"

set combined_output_single "\
$pond_name_regular
$pond_name_private"

set success_output_multiple_regular "\
$pond_name_regular_prefix-1
$pond_name_regular_prefix-2
$pond_name_regular_prefix-3"

set success_output_multiple_private "\
$pond_name_private_prefix-1
$pond_name_private_prefix-2
$pond_name_private_prefix-3"

set combined_output_multiple "\
$pond_name_regular_prefix-1
$pond_name_regular_prefix-2
$pond_name_regular_prefix-3
$pond_name_private_prefix-1
$pond_name_private_prefix-2
$pond_name_private_prefix-3"

set command_usage "\
Usage:
    pond list [options]

Options:
    -p, --private   List private ponds
    -r, --regular   List regular ponds
    -e, --enabled   List enabled ponds
    -d, --disabled  List disabled ponds"

for command in "pond list" "pond list "{-r,--regular}

    @echo "$command: success tests for regular pond"
    __pond_setup 1 regular enabled unpopulated
    @test "pond list: success regular pond" (eval $command >/dev/null 2>&1) $status -eq $success
    @test "pond list: output message correct" (eval $command 2>&1 | string collect) = $success_output_single_regular
    __pond_tear_down

    @echo "$command: success tests for regular disabled pond"
    __pond_setup 1 regular disabled unpopulated
    @test "pond list: success regular disabled pond" (eval $command >/dev/null 2>&1) $status -eq $success
    @test "pond list: output message correct" (eval $command 2>&1 | string collect) = $success_output_single_regular
    __pond_tear_down

    @echo "$command: success tests for multiple regular ponds"
    __pond_setup 3 regular enabled unpopulated
    @test "pond list: success multiple regular ponds" (eval $command >/dev/null 2>&1) $status -eq $success
    @test "pond list: output message correct" (eval $command 2>&1 | string collect) = $success_output_multiple_regular
    __pond_tear_down

    @echo "$command: success tests for multiple regular disabled ponds"
    __pond_setup 3 regular disabled unpopulated
    @test "pond list: success multiple regular disabled ponds" (eval $command >/dev/null 2>&1) $status -eq $success
    @test "pond list: output message correct" (eval $command 2>&1 | string collect) = $success_output_multiple_regular
    __pond_tear_down

end

for command in "pond list" "pond list "{-p,--private}

    @echo "$command: success tests for private pond"
    __pond_setup 1 private enabled unpopulated
    @test "pond list: success private pond" (eval $command >/dev/null 2>&1) $status -eq $success
    @test "pond list: output message correct" (eval $command 2>&1 | string collect) = $success_output_single_private
    __pond_tear_down

    @echo "$command: success tests for private disabled pond"
    __pond_setup 1 private disabled unpopulated
    @test "pond list: success private disabled pond" (eval $command >/dev/null 2>&1) $status -eq $success
    @test "pond list: output message correct" (eval $command 2>&1 | string collect) = $success_output_single_private
    __pond_tear_down

    @echo "$command: success tests for multiple private ponds"
    __pond_setup 3 private enabled unpopulated
    @test "pond list: success multiple private ponds" (eval $command >/dev/null 2>&1) $status -eq $success
    @test "pond list: output message correct" (eval $command 2>&1 | string collect) = $success_output_multiple_private
    __pond_tear_down

    @echo "$command: success tests for multiple private disabled ponds"
    __pond_setup 3 private disabled unpopulated
    @test "pond list: success multiple private disabled ponds" (eval $command >/dev/null 2>&1) $status -eq $success
    @test "pond list: output message correct" (eval $command 2>&1 | string collect) = $success_output_multiple_private
    __pond_tear_down

end

for command in "pond list" "pond list "{-p,--private}" "{-r,--regular}

    @echo "$command: success tests for regular and private ponds"
    __pond_setup 1 regular enabled unpopulated
    __pond_setup 1 private enabled unpopulated
    @test "pond list: success regular and private pond" (eval $command >/dev/null 2>&1) $status -eq $success
    @test "pond list: output message correct" (eval $command 2>&1 | string collect) = $combined_output_single
    __pond_tear_down

    @echo "$command: success tests for regular disabled and private ponds"
    __pond_setup 1 regular disabled unpopulated
    __pond_setup 1 private disabled unpopulated
    @test "pond list: success regular disabled and private ponds" (eval $command >/dev/null 2>&1) $status -eq $success
    @test "pond list: output message correct" (eval $command 2>&1 | string collect) = $combined_output_single
    __pond_tear_down

    @echo "$command: success tests for multiple regular and private ponds"
    __pond_setup 3 regular enabled unpopulated
    __pond_setup 3 private enabled unpopulated
    @test "pond list: success multiple regular and private ponds" (eval $command >/dev/null 2>&1) $status -eq $success
    @test "pond list: output message correct" (eval $command 2>&1 | string collect) = $combined_output_multiple
    __pond_tear_down

    @echo "$command: success tests for multiple regular disabled and private ponds"
    __pond_setup 3 regular disabled unpopulated
    __pond_setup 3 private disabled unpopulated
    @test "pond list: success multiple regular disabled and private ponds" (eval $command >/dev/null 2>&1) $status -eq $success
    @test "pond list: output message correct" (eval $command 2>&1 | string collect) = $combined_output_multiple
    __pond_tear_down

end

for command in "pond list" "pond list "{-e,--enabled}

    @echo "$command: success tests for regular enabled pond"
    __pond_setup 1 regular enabled unpopulated
    @test "pond list: success regular enabled pond" (eval $command >/dev/null 2>&1) $status -eq $success
    @test "pond list: output message correct" (eval $command 2>&1 | string collect) = $success_output_single_regular
    __pond_tear_down

    @echo "$command: success tests for private enabled pond"
    __pond_setup 1 private enabled unpopulated
    @test "pond list: success private enabled pond" (eval $command >/dev/null 2>&1) $status -eq $success
    @test "pond list: output message correct" (eval $command 2>&1 | string collect) = $success_output_single_private
    __pond_tear_down

    @echo "$command: success tests for multiple regular enabled ponds"
    __pond_setup 3 regular enabled unpopulated
    @test "pond list: success multiple regular enabled ponds" (eval $command >/dev/null 2>&1) $status -eq $success
    @test "pond list: output message correct" (eval $command 2>&1 | string collect) = $success_output_multiple_regular
    __pond_tear_down

    @echo "$command: success tests for multiple private enabled ponds"
    __pond_setup 3 private enabled unpopulated
    @test "pond list: success multiple private enabled ponds" (eval $command >/dev/null 2>&1) $status -eq $success
    @test "pond list: output message correct" (eval $command 2>&1 | string collect) = $success_output_multiple_private
    __pond_tear_down
end

for command in "pond list" "pond list "{-d,--disabled}

    @echo "$command: success tests for regular disabled pond"
    __pond_setup 1 regular disabled unpopulated
    @test "pond list: success regular disabled pond" (eval $command >/dev/null 2>&1) $status -eq $success
    @test "pond list: output message correct" (eval $command 2>&1 | string collect) = $success_output_single_regular
    __pond_tear_down

    @echo "$command: success tests for private disabled pond"
    __pond_setup 1 private disabled unpopulated
    @test "pond list: success private disabled pond" (eval $command >/dev/null 2>&1) $status -eq $success
    @test "pond list: output message correct" (eval $command 2>&1 | string collect) = $success_output_single_private
    __pond_tear_down

    @echo "$command: success tests for multiple regular disabled ponds"
    __pond_setup 3 regular disabled unpopulated
    @test "pond list: success multiple regular disabled ponds" (eval $command >/dev/null 2>&1) $status -eq $success
    @test "pond list: output message correct" (eval $command 2>&1 | string collect) = $success_output_multiple_regular
    __pond_tear_down

    @echo "$command: success tests for multiple private disabled ponds"
    __pond_setup 3 private disabled unpopulated
    @test "pond list: success multiple private disabled ponds" (eval $command >/dev/null 2>&1) $status -eq $success
    @test "pond list: output message correct" (eval $command 2>&1 | string collect) = $success_output_multiple_private
    __pond_tear_down
end

for command in "pond list "{-r,--regular}

    @echo "$command: failure tests for missing regular ponds"
    @test "pond list: fails for missing ponds when none exist" (eval $command >/dev/null 2>&1) $status -eq $fail
    @test "pond list: output message correct" (eval $command 2>&1) = (set_color red; and echo -n "Error: "; and set_color normal; and echo "No ponds found")

    __pond_setup 1 private enabled unpopulated
    @test "pond list: fails for missing ponds when only private ponds exist" (eval $command >/dev/null 2>&1) $status -eq $fail
    @test "pond list: output message correct" (eval $command 2>&1) = (set_color red; and echo -n "Error: "; and set_color normal; and echo "No ponds found")
    __pond_tear_down

end

for command in "pond list "{-p,--private}

    @echo "$command: failure tests for missing private ponds"
    @test "pond list: fails for missing ponds when none exist" (eval $command >/dev/null 2>&1) $status -eq $fail
    @test "pond list: output message correct" (eval $command 2>&1) = (set_color red; and echo -n "Error: "; and set_color normal; and echo "No ponds found")

    __pond_setup 1 regular enabled unpopulated
    @test "pond list: fails for missing ponds when only regular ponds exist" (eval $command >/dev/null 2>&1) $status -eq $fail
    @test "pond list: output message correct" (eval $command 2>&1) = (set_color red; and echo -n "Error: "; and set_color normal; and echo "No ponds found")
    __pond_tear_down

end

for command in "pond list "{-e,--enabled}

    @echo "$command: failure tests for missing enabled ponds"
    @test "pond list: fails for missing ponds when none exist" (eval $command >/dev/null 2>&1) $status -eq $fail
    @test "pond list: output message correct" (eval $command 2>&1) = (set_color red; and echo -n "Error: "; and set_color normal; and echo "No ponds found")

    __pond_setup 1 regular disabled unpopulated
    @test "pond list: fails for missing ponds when only regular disabled ponds exist" (eval $command >/dev/null 2>&1) $status -eq $fail
    @test "pond list: output message correct" (eval $command 2>&1) = (set_color red; and echo -n "Error: "; and set_color normal; and echo "No ponds found")
    __pond_tear_down

    __pond_setup 1 private disabled unpopulated
    @test "pond list: fails for missing ponds when only private disabled ponds exist" (eval $command >/dev/null 2>&1) $status -eq $fail
    @test "pond list: output message correct" (eval $command 2>&1) = (set_color red; and echo -n "Error: "; and set_color normal; and echo "No ponds found")
    __pond_tear_down

end

for command in "pond list "{-d,--disabled}

    @echo "$command: failure tests for missing disabled ponds"
    @test "pond list: fails for missing ponds when none exist" (eval $command >/dev/null 2>&1) $status -eq $fail
    @test "pond list: output message correct" (eval $command 2>&1) = (set_color red; and echo -n "Error: "; and set_color normal; and echo "No ponds found")

    __pond_setup 1 regular enabled unpopulated
    @test "pond list: fails for missing ponds when only regular enabled ponds exist" (eval $command >/dev/null 2>&1) $status -eq $fail
    @test "pond list: output message correct" (eval $command 2>&1) = (set_color red; and echo -n "Error: "; and set_color normal; and echo "No ponds found")
    __pond_tear_down

    __pond_setup 1 private enabled unpopulated
    @test "pond list: fails for missing ponds when only private enabled ponds exist" (eval $command >/dev/null 2>&1) $status -eq $fail
    @test "pond list: output message correct" (eval $command 2>&1) = (set_color red; and echo -n "Error: "; and set_color normal; and echo "No ponds found")
    __pond_tear_down

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
