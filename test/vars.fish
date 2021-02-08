set fail 1
set success 0

set -x test_pond pond
set -x test_variable ABC
set -x test_value 123

# setup

pond create $test_pond

# variable command tests

@test 'set pond variable succeeds' (pond var set $test_pond $test_variable $test_value >/dev/null 2>&1) $status -eq $success

@test 'set pond variable fails for a non-existent pond' (pond var set none $test_variable $test_value >/dev/null 2>&1) $status -eq $fail

@test 'get pond variable succeeds' (pond var get $test_pond $test_variable >/dev/null 2>&1) $status -eq $success

@test 'get pond variable fails for a non-existent variable' (pond var get $test_pond NONE >/dev/null 2>&1) $status -eq $fail

@test 'get pond variable fails for a non-existent pond' (pond var get none $test_variable >/dev/null 2>&1) $status -eq $fail

@test 'remove pond variable succeeds' (pond var remove $test_pond $test_variable >/dev/null 2>&1) $status -eq $success

@test 'remove pond variable fails for a non-existent variable' (pond var remove $test_pond NONE >/dev/null 2>&1) $status -eq $fail

@test 'remove pond variable fails for a non-existent pond' (pond var remove none $test_variable >/dev/null 2>&1) $status -eq $fail

# setup

pond create pond

# variable command output tests

@test 'set pond variable reports correctly' (pond var set $test_pond $test_variable $test_value) = "pond: Set variable '$test_variable' in pond '$test_pond'"

@test 'set pond variable reports correctly for a non-existent pond' (pond var set none $test_variable $test_value) = "pond: A pond named 'none' does not exist"

@test 'get pond variable reports correctly' (pond var get $test_pond $test_variable) = "$test_value"

@test 'get pond variable reports correctly for a non-existent variable' (pond var get $test_pond NONE) = "pond: No variable named 'NONE' in pond '$test_pond'"

@test 'get pond variable reports correctly for a non-existent pond' (pond var get none $test_variable) = "pond: A pond named 'none' does not exist"

@test 'remove pond variable reports correctly' (pond var remove $test_pond $test_variable) = "pond: Variable '$test_variable' removed from pond '$test_pond'"

@test 'remove pond variable reports correctly for a non-existent variable' (pond var remove $test_pond NONE) = "pond: No variable named 'NONE' in pond '$test_pond'"

@test 'remove pond variable reports correctly for a non-existent pond' (pond var remove none $test_variable) = "pond: A pond named 'none' does not exist"
