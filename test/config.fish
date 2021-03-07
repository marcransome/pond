set fail 1
set success 0

set -x __pond_under_test yes
set pond_editor_before_test "$pond_editor"
set pond_enable_on_create_before_test "$pond_enable_on_create"

set command_usage "\
Usage:
    pond config"

function __pond_reset
    set -U pond_editor $pond_editor_before_test
    set -U pond_enable_on_create $pond_enable_on_create_before_test
end

set -U pond_editor test-editor
set -U pond_enable_on_create yes

@echo 'pond config: success tests'
@test "pond config: success exit code" (pond config >/dev/null 2>&1) $status -eq $success
@test "pond config: success output message" (pond config 2>&1 | string collect) = "\
Pond home: $__fish_config_dir/pond
Enable ponds on creation: yes
Pond editor command: test-editor"

@echo 'pond config: pond_enable_on_create universal variable change tests'
set -U pond_enable_on_create no
@test "pond config: success output message" (pond config 2>&1 | string collect) = "\
Pond home: $__fish_config_dir/pond
Enable ponds on creation: no
Pond editor command: test-editor"

@echo 'pond config: pond_editor universal variable change tests'
set -U pond_editor another-editor
@test "pond config: success output message" (pond config 2>&1 | string collect) = "\
Pond home: $__fish_config_dir/pond
Enable ponds on creation: no
Pond editor command: another-editor"

@echo "pond edit: validation failure exit code tests"
@test "pond edit: fails for trailing arguments" (pond config trailing >/dev/null 2>&1) $status -eq $fail

@echo "pond config: validation failure output tests"
@test "pond config: command usage shown for trailing arguments" (pond config trailing 2>&1 | string collect) = $command_usage

__pond_reset
