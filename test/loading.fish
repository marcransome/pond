set fail 1
set success 0

set -x test_pond pond
set -x test_variable ABC
set -x test_value 123

# setup

pond create $test_pond
pond variable set $test_variable $test_value

# pond loading tests

@test 'load pond succeeds' (pond load $test_pond >/dev/null 2>&1) $status -eq $success

@test 'unload pond succeeds' (pond unload $test_pond >/dev/null 2>&1) $status -eq $success

# pond loading output tests

@test 'load pond reports correctly' (pond load $test_pond) = "Pond '$test_pond' variables loaded into current shell session"

@test 'unload pond reports correctly' (pond unload $test_pond) = "Pond '$test_pond' variables unloaded from current shell session"

# tear-down

echo 'y' | pond remove $test_pond
