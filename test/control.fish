set fail 1
set success 0

set -x test_pond pond

# setup

pond create $test_pond # enables pond by default

# pond control tests

@test 'enable pond fails when pond already enabled' (pond enable $test_pond >/dev/null 2>&1) $status -eq $fail

@test 'disable pond succeeds' (pond disable $test_pond >/dev/null 2>&1) $status -eq $success

@test 'enable pond succeeds' (pond enable $test_pond >/dev/null 2>&1) $status -eq $success

@test 'status succeeds' (pond status $test_pond >/dev/null 2>&1) $status -eq $success

@test 'status fails for non-existent pond' (pond status none >/dev/null 2>&1) $status -eq $fail

# tear-down

echo 'y' | pond remove $test_pond

# setup

pond create $test_pond # enables pond by default

# pond control output tests

@test 'enable pond fails when pond already enabled' (pond enable $test_pond 2>&1) = "Pond '$test_pond' is already enabled"

@test 'disable pond succeeds' (pond disable $test_pond) = "Disabled pond '$test_pond'"

@test 'status reports correctly for disabled pond' (pond status $test_pond 2>&1 | string collect) = "name: pond
enabled: no
path: $__fish_config_dir/pond/ponds/$test_pond"

@test 'enable pond succeeds' (pond enable $test_pond) = "Enabled pond '$test_pond'"

@test 'status reports correctly for enabled pond' (pond status $test_pond 2>&1 | string collect) = "name: pond
enabled: yes
path: $__fish_config_dir/pond/ponds/$test_pond"

@test 'status reports correctly for non-existent pond' (pond status none 2>&1) = "Pond 'none' does not exist"

# tear-down

echo 'y' | pond remove $test_pond
