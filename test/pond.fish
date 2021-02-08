@test 'can create pond' (pond create test > /dev/null 2>&1 ) $status -eq 0

@test 'can remove pond' (echo 'y' | pond remove test >/dev/null 2>&1) $status -eq 0
