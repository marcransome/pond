set parent (dirname (status --current-filename))
source $parent/fixtures/functions.fish
source $parent/fixtures/variables.fish

@echo "pond init: success tests for single enabled pond"
__pond_setup 1 enabled unloaded populated
@test "setup: pond is enabled" (contains $pond_home/$pond_name $pond_function_path) $status -eq $success
@test "setup: pond is not loaded" (not contains $pond_home/$pond_name $fish_function_path) $status -eq $success
@test "pond init: success exit code" (__pond_init) $status -eq $success
@test "pond init: fish function path created" (contains $pond_home/$pond_name $fish_function_path) $status -eq $success
@test "pond init: autoloaded autload function accessible" (functions -q {$pond_name}_{$pond_autoload_suffix}) $status -eq $success
@test "pond init: autoloaded autounload function accessible" (functions -q {$pond_name}_{$pond_autounload_suffix}) $status -eq $success
__pond_tear_down

@echo "pond init: success tests for single disabled pond"
__pond_setup 1 disabled unloaded populated
@test "setup: pond is disabled" (not contains $pond_home/$pond_name $pond_function_path) $status -eq $success
@test "setup: pond is not loaded" (not contains $pond_home/$pond_name $fish_function_path) $status -eq $success
@test "pond init: success exit code" (__pond_init) $status -eq $success
@test "pond init: autoloaded autload function inaccessible" (functions -q {$pond_name}_{$pond_autoload_suffix}) $status -eq $failure
@test "pond init: autoloaded autounload function inaccessible" (functions -q {$pond_name}_{$pond_autounload_suffix}) $status -eq $failure
__pond_tear_down

@echo "pond init: success tests for multiple enabled ponds"
__pond_setup 3 enabled unloaded populated
@test "setup: $pond_name_prefix-1 pond is enabled" (contains $pond_home/$pond_name_prefix-1 $pond_function_path) $status -eq $success
@test "setup: $pond_name_prefix-2 pond is enabled" (contains $pond_home/$pond_name_prefix-2 $pond_function_path) $status -eq $success
@test "setup: $pond_name_prefix-3 pond is enabled" (contains $pond_home/$pond_name_prefix-3 $pond_function_path) $status -eq $success
@test "setup: $pond_name_prefix-1 pond is not loaded" (not contains $pond_home/$pond_name_prefix-1 $fish_function_path) $status -eq $success
@test "setup: $pond_name_prefix-2 pond is not loaded" (not contains $pond_home/$pond_name_prefix-2 $fish_function_path) $status -eq $success
@test "setup: $pond_name_prefix-3 pond is not loaded" (not contains $pond_home/$pond_name_prefix-3 $fish_function_path) $status -eq $success
@test "pond init: success exit code" (__pond_init) $status -eq $success
@test "pond init: $pond_name_prefix-1 fish function path created" (contains $pond_home/$pond_name_prefix-1 $fish_function_path) $status -eq $success
@test "pond init: $pond_name_prefix-2 fish function path created" (contains $pond_home/$pond_name_prefix-2 $fish_function_path) $status -eq $success
@test "pond init: $pond_name_prefix-3 fish function path created" (contains $pond_home/$pond_name_prefix-3 $fish_function_path) $status -eq $success
@test "pond init: $pond_name_prefix-1 autload function accessible" (functions -q {$pond_name_prefix-1}_{$pond_autoload_suffix}) $status -eq $success
@test "pond init: $pond_name_prefix-2 autload function accessible" (functions -q {$pond_name_prefix-2}_{$pond_autoload_suffix}) $status -eq $success
@test "pond init: $pond_name_prefix-3 autload function accessible" (functions -q {$pond_name_prefix-3}_{$pond_autoload_suffix}) $status -eq $success
@test "pond init: $pond_name_prefix-1 autounload function accessible" (functions -q {$pond_name_prefix-1}_{$pond_autounload_suffix}) $status -eq $success
@test "pond init: $pond_name_prefix-2 autounload function accessible" (functions -q {$pond_name_prefix-2}_{$pond_autounload_suffix}) $status -eq $success
@test "pond init: $pond_name_prefix-3 autounload function accessible" (functions -q {$pond_name_prefix-3}_{$pond_autounload_suffix}) $status -eq $success
__pond_tear_down

@echo "pond init: success tests for multiple disabled ponds"
__pond_setup 3 disabled unloaded populated
@test "setup: $pond_name_prefix-1 pond is disabled" (not contains $pond_home/$pond_name_prefix-1 $pond_function_path) $status -eq $success
@test "setup: $pond_name_prefix-2 pond is disabled" (not contains $pond_home/$pond_name_prefix-2 $pond_function_path) $status -eq $success
@test "setup: $pond_name_prefix-3 pond is disabled" (not contains $pond_home/$pond_name_prefix-3 $pond_function_path) $status -eq $success
@test "setup: $pond_name_prefix-1 pond is not loaded" (not contains $pond_home/$pond_name_prefix-1 $fish_function_path) $status -eq $success
@test "setup: $pond_name_prefix-2 pond is not loaded" (not contains $pond_home/$pond_name_prefix-2 $fish_function_path) $status -eq $success
@test "setup: $pond_name_prefix-3 pond is not loaded" (not contains $pond_home/$pond_name_prefix-3 $fish_function_path) $status -eq $success
@test "pond init: success exit code" (__pond_init) $status -eq $success
@test "pond init: $pond_name_prefix-1 autload function inaccessible" (functions -q {$pond_name_prefix-1}_{$pond_autoload_suffix}) $status -eq $failure
@test "pond init: $pond_name_prefix-2 autload function inaccessible" (functions -q {$pond_name_prefix-2}_{$pond_autoload_suffix}) $status -eq $failure
@test "pond init: $pond_name_prefix-3 autload function inaccessible" (functions -q {$pond_name_prefix-3}_{$pond_autoload_suffix}) $status -eq $failure
@test "pond init: $pond_name_prefix-1 autounload function inaccessible" (functions -q {$pond_name_prefix-1}_{$pond_autounload_suffix}) $status -eq $failure
@test "pond init: $pond_name_prefix-2 autounload function inaccessible" (functions -q {$pond_name_prefix-2}_{$pond_autounload_suffix}) $status -eq $failure
@test "pond init: $pond_name_prefix-3 autounload function inaccessible" (functions -q {$pond_name_prefix-3}_{$pond_autounload_suffix}) $status -eq $failure
__pond_tear_down
