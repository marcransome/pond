set parent (dirname (status --current-filename))
source $parent/fixtures/variables.fish

set command_usage "\
Usage:
    pond config"

@echo 'pond config: success tests'
@test "pond config: success exit code" (pond config >/dev/null 2>&1) $status -eq $success
@test "pond config: success output message" (pond config 2>&1 | string collect) = "\
Pond home: $pond_home
Enable ponds on creation: $pond_enable_on_create
Load ponds on creation: $pond_load_on_create
Pond editor command: $pond_editor"

@echo 'pond config: pond_enable_on_create universal variable tests'
set -gx pond_enable_on_create yes
@test "setup: pond_enable_on_create set to 'yes'" (echo $pond_enable_on_create) = "yes"
@test "pond config: success output message" (pond config 2>&1 | string collect) = "\
Pond home: $pond_home
Enable ponds on creation: yes
Load ponds on creation: $pond_load_on_create
Pond editor command: $pond_editor"

@echo 'pond config: pond_enable_on_create universal variable tests'
set -gx pond_enable_on_create no
@test "setup: pond_enable_on_create set to 'no'" (echo $pond_enable_on_create) = "no"
@test "pond config: success output message" (pond config 2>&1 | string collect) = "\
Pond home: $pond_home
Enable ponds on creation: no
Load ponds on creation: $pond_load_on_create
Pond editor command: $pond_editor"

@echo 'pond config: pond_load_on_create universal variable tests'
set -gx pond_load_on_create yes
@test "setup: pond_load_on_create set to 'yes'" (echo $pond_load_on_create) = "yes"
@test "pond config: success output message" (pond config 2>&1 | string collect) = "\
Pond home: $pond_home
Enable ponds on creation: $pond_enable_on_create
Load ponds on creation: yes
Pond editor command: $pond_editor"

@echo 'pond config: pond_load_on_create universal variable tests'
set -gx pond_load_on_create no
@test "setup: pond_load_on_create set to 'no'" (echo $pond_load_on_create) = "no"
@test "pond config: success output message" (pond config 2>&1 | string collect) = "\
Pond home: $pond_home
Enable ponds on creation: $pond_enable_on_create
Load ponds on creation: no
Pond editor command: $pond_editor"

@echo 'pond config: pond_editor universal variable tests'
set -gx pond_editor this-editor
@test "setup: pond_editor set to 'this-editor'" (echo $pond_enable_on_create) = "no"
@test "pond config: success output message" (pond config 2>&1 | string collect) = "\
Pond home: $pond_home
Enable ponds on creation: $pond_enable_on_create
Load ponds on creation: $pond_load_on_create
Pond editor command: this-editor"

@echo 'pond config: pond_editor universal variable tests'
set -gx pond_editor that-editor
@test "setup: pond_editor set to 'that-editor'" (echo $pond_editor) = "that-editor"
@test "pond config: success output message" (pond config 2>&1 | string collect) = "\
Pond home: $pond_home
Enable ponds on creation: $pond_enable_on_create
Load ponds on creation: $pond_load_on_create
Pond editor command: that-editor"

@echo "pond config: validation failure exit code tests"
@test "pond config: fails for trailing arguments" (pond config trailing >/dev/null 2>&1) $status -eq $failure

@echo "pond config: validation failure output tests"
@test "pond config: command usage shown for trailing arguments" (pond config trailing 2>&1 | string collect) = $command_usage
