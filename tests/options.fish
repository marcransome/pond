source ./fixtures/variables.fish

set pond_usage "\
Pond $pond_test_version

Usage:
    pond [options]
    pond <command> [command-options] ...

Help Options:
    -h, --help            Show this help message
    <command> -h, --help  Show command help

Application Options:
    -v, --version         Print the version string

Commands:
    create   Create a new pond
    init     Create/open pond init function
    deinit   Create/open pond deinit function
    remove   Remove a pond and associated data
    list     List ponds
    enable   Enable a pond for new shell sessions
    disable  Disable a pond for new shell sessions
    load     Load pond data into current shell session
    unload   Unload pond data from current shell session
    status   View pond status
    drain    Drain all data from pond
    dir      Change current working directory to pond
    config   Show configuration settings"

@echo 'pond options: success exit code tests'
@test 'pond -v success' (pond -v >/dev/null 2>&1) $status -eq $success
@test 'pond --version success' (pond --version >/dev/null 2>&1) $status -eq $success
@test 'pond -h success' (pond -h >/dev/null 2>&1) $status -eq $success
@test 'pond --help success' (pond --help >/dev/null 2>&1) $status -eq $success

@echo 'pond options: failure exit code tests'
@test 'pond fails for invalid short option' (pond -i >/dev/null 2>&1) $status -eq $failure
@test 'pond fails for invalid long option' (pond --invalid >/dev/null 2>&1) $status -eq $failure

@echo 'pond options: version option output tests'
@test 'pond -v reports correct version' (pond -v) = "pond $pond_test_version"
@test 'pond --version reports correct version' (pond --version) = "pond $pond_test_version"

@echo 'pond options: help option usage tests'
@test 'pond -h reports usage' (pond -h 2>&1 | string collect) = $pond_usage
@test 'pond --help reports usage' (pond --help 2>&1 | string collect) = $pond_usage
