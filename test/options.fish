set fail 1
set success 0
set pond_version 0.3.0

# exit code tests

@test 'short version option succeeds' (pond -v >/dev/null 2>&1) $status -eq $success

@test 'long version option succeeds' (pond --version >/dev/null 2>&1) $status -eq $success

@test 'short help option succeeds' (pond -h >/dev/null 2>&1) $status -eq $success

@test 'long help option succeeds' (pond --help >/dev/null 2>&1) $status -eq $success

# output tests

@test 'short version option reports correctly' (pond -v) = "pond $pond_version"

@test 'long version option reports correctly' (pond --version) = "pond $pond_version"
