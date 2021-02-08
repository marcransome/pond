set fail 1
set success 0

# variable commands

@test 'set pond variable succeeds' (pond var set test ABC 123 >/dev/null 2>&1) $status -eq $success

@test 'set pond variable fails for a non-existent pond' (pond var set none ABC 123 >/dev/null 2>&1) $status -eq $fail

@test 'get pond variable succeeds' (pond get test ABC >/dev/null 2>&1) $status -eq $success

@test 'get pond variable fails for a non-existent variable' (pond get test NONE >/dev/null 2>&1) $status -eq $fail

@test 'get pond variable fails for a non-existent pond' (pond get none ABC >/dev/null 2>&1) $status -eq $fail
