# basic commands

@test 'create pond succeeds' (pond create test >/dev/null 2>&1) $status -eq 0

@test 'list ponds succeeds' (pond list >/dev/null 2>&1) $status -eq 0

@test 'remove pond succeeds' (echo 'y' | pond remove test >/dev/null 2>&1) $status -eq 0

@test 'list ponds fails when no ponds exist' (pond list >/dev/null 2>&1) $status -eq 1

# stdout tests

@test 'create pond reports correctly' (pond create test) = "pond: Created an empty pond named 'test'"

@test 'list pond reports correctly' (pond list | string collect) = "pond: Found the following ponds:
  test"

@test 'remove pond reports correctly' (echo 'y' | pond remove test) = "pond: Removed pond 'test'"

@test 'list pond reports correctly when no ponds exist' (pond list) = "pond: No ponds found; create one with 'create'"
