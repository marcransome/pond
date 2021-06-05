source ./fixtures/variables.fish
source ./fixtures/functions.fish

set unknown_command_error (__pond_error_string "Unknown command: unknown")

@echo 'pond: unknown command failure exit code tests'
@test 'pond fails for unknown command' (pond unknown >/dev/null 2>&1) $status -eq $failure

@echo 'pond: unknown command output tests'
@test 'pond reports correct error' (pond unknown 2>&1) = $unknown_command_error
