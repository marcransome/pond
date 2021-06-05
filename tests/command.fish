source ./fixtures/variables.fish

set -gx TERM xterm-256color

set unknown_command_error (set_color red; and echo -n "Error: "; and set_color normal; and echo "Unknown command: unknown")

@echo 'pond: unknown command failure exit code tests'
@test 'pond fails for unknown command' (pond unknown >/dev/null 2>&1) $status -eq $failure

@echo 'pond: unknown command output tests'
@test 'pond reports correct error' (pond unknown 2>&1) = $unknown_command_error
