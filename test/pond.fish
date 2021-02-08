# basic commands

@test 'can create pond' (pond create test >/dev/null 2>&1) $status -eq 0

@test 'can remove pond' (echo 'y' | pond remove test >/dev/null 2>&1) $status -eq 0

@test 'can list ponds' (pond list >/dev/null 2>&1) $status -eq 0

# stdout tests

@test 'create pond reports success' (pond create test) = "pond: Created an empty pond named 'test'"

@test 'list pond reports success' (pond list) = "pond: Found the following ponds:
  test"

@test 'remove pond reports success' (echo 'y' | pond remove test) = "pond: Removed pond 'test'"
