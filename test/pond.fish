set fail 1
set success 0
set pond_version 0.2.0

# setup

set -x test_pond pond

# pond command tests

@test 'short version option succeeds' (pond -v >/dev/null 2>&1) $status -eq $success

@test 'long version option succeeds' (pond --version >/dev/null 2>&1) $status -eq $success

@test 'short help option succeeds' (pond -h >/dev/null 2>&1) $status -eq $success

@test 'long help option succeeds' (pond --help >/dev/null 2>&1) $status -eq $success

@test 'create pond succeeds' (pond create $test_pond >/dev/null 2>&1) $status -eq $success

@test 'create pond fails when pond already exists' (pond create $test_pond >/dev/null 2>&1) $status -eq $fail

@test 'list ponds succeeds when ponds exist' (pond list >/dev/null 2>&1) $status -eq $success

@test 'remove pond succeeds when pond exists' (echo 'y' | pond remove $test_pond >/dev/null 2>&1) $status -eq $success

@test 'remove pond fails when pond does not exist' (echo 'y' | pond remove $test_pond >/dev/null 2>&1) $status -eq $fail

@test 'list ponds fails when no ponds exist' (pond list >/dev/null 2>&1) $status -eq $fail

# pond command output tests

@test 'short version option reports correctly' (pond -v) = "pond $pond_version"

@test 'long version option reports correctly' (pond --version) = "pond $pond_version"

@test 'create pond reports correctly' (pond create $test_pond) = "Created an empty pond '$test_pond'"

@test 'create pond reports correctly when pond already exists' (pond create $test_pond 2>&1) = "Pond '$test_pond' already exists"

@test 'list pond reports correctly when ponds exist' (pond list | string collect) = "$test_pond"

@test 'remove pond reports correctly when pond exists' (echo 'y' | pond remove $test_pond) = "Removed pond '$test_pond'"

@test 'remove pond reports correctly when pond does not exist' (pond remove $test_pond 2>&1) = "Pond '$test_pond' does not exist"

@test 'list pond reports correctly when no ponds exist' (pond list 2>&1) = "No ponds found; create one with 'create'"
