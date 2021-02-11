set fail 1
set success 0
set pond_version 0.3.0

set -x __pond_under_test yes

set pond_usage "\
Usage:
    pond [options] or pond [command-options] <command> ...

Help Options:
    -h, --help            Show this help message
    <command> -h, --help  Show command help

Application Options:
    -v, --version           Print the version string

Commands:
    create   Create a new pond
    remove   Remove a pond and associated data
    edit     Edit an existing pond
    enable   Enable a pond for new shell sessions
    disable  Disable a pond for new shell sessions
    load     Load pond data into current shell session
    unload   Unload pond data from current shell session
    status   View pond status
    drain    Drain all data from pond"

@echo 'options success exit code tests'
@test 'pond -v success' (pond -v >/dev/null 2>&1) $status -eq $success
@test 'pond --version success' (pond --version >/dev/null 2>&1) $status -eq $success
@test 'pond -h success' (pond -h >/dev/null 2>&1) $status -eq $success
@test 'pond --help success' (pond --help >/dev/null 2>&1) $status -eq $success

@echo 'options failure exit code tests'
@test 'pond failure for invalid short option' (pond -i >/dev/null 2>&1) $status -eq $fail
@test 'pond failure for invalid long option' (pond --invalid >/dev/null 2>&1) $status -eq $fail

@echo 'version option output tests'
@test 'pond -v repots version' (pond -v) = "pond $pond_version"
@test 'pond --version reports version' (pond --version) = "pond $pond_version"

@echo 'help option usage tests'
@test 'pond -h repots usage' (pond -h 2>&1 | string collect) = $pond_usage
@test 'pond --help repots usage' (pond --help 2>&1 | string collect) = $pond_usage

set -e __pond_under_test
