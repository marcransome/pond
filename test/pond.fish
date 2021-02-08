set fail 1
set success 0
set test_pond pond
set pond_version 0.2.0

# pond command tests

@test 'short version option succeeds' (pond -v >/dev/null 2>&1) $status -eq $success

@test 'long version option succeeds' (pond --version >/dev/null 2>&1) $status -eq $success

@test 'short help option succeeds' (pond -h >/dev/null 2>&1) $status -eq $success

@test 'long help option succeeds' (pond --help >/dev/null 2>&1) $status -eq $success

@test 'create pond succeeds' (pond create test >/dev/null 2>&1) $status -eq $success

@test 'create pond fails when pond already exists' (pond create test >/dev/null 2>&1) $status -eq $fail

@test 'list ponds succeeds when ponds exist' (pond list >/dev/null 2>&1) $status -eq $success

@test 'remove pond succeeds when pond exists' (echo 'y' | pond remove test >/dev/null 2>&1) $status -eq $success

@test 'remove pond fails when pond does not exist' (echo 'y' | pond remove test >/dev/null 2>&1) $status -eq $fail

@test 'list ponds fails when no ponds exist' (pond list >/dev/null 2>&1) $status -eq $fail

# pond command output tests

@test 'short version option reports correctly' (pond -v) = "pond $pond_version"

@test 'long version option reports correctly' (pond --version) = "pond $pond_version"

@test 'create pond reports correctly' (pond create $test_pond) = "pond: Created an empty pond named '$test_pond'"

@test 'create pond reports correctly when pond already exists' (pond create $test_pond 2>&1) = "pond: A pond named '$test_pond' already exists"

@test 'list pond reports correctly when ponds exist' (pond list | string collect) = "pond: Found the following ponds:
  test"

@test 'remove pond reports correctly when pond exists' (echo 'y' | pond remove $test_pond) = "pond: Removed pond '$test_pond'"

@test 'remove pond reports correctly when pond does not exist' (pond remove $test_pond 2>&1) = "pond: A pond named '$test_pond' does not exist"

@test 'list pond reports correctly when no ponds exist' (pond list 2>&1) = "pond: No ponds found; create one with 'create'"
