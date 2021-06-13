source ./fixtures/functions.fish
source ./fixtures/variables.fish

@echo "pond init: success tests for single enabled pond"
__pond_setup 1 enabled populated
__pond_remove_from_fish_function_path $pond_name
@test "setup: pond is enabled" (contains $pond_home/$pond_name $pond_function_path) $status -eq $success
@test "setup: pond is not loaded" (not contains $pond_home/$pond_name $fish_function_path) $status -eq $success
@test "pond init: success exit code" (__pond_init) $status -eq $success
@test "pond init: fish function path created" (contains $pond_home/$pond_name $fish_function_path) $status -eq $success
@test "pond init: autoloaded init function accessible" (functions -q {$pond_name}_{$pond_init_suffix}) $status -eq $success
@test "pond init: autoloaded deinit function accessible" (functions -q {$pond_name}_{$pond_deinit_suffix}) $status -eq $success
__pond_tear_down

@echo "pond init: success tests for single disabled pond"
__pond_setup 1 disabled populated
@test "setup: pond is disabled" (not contains $pond_home/$pond_name $pond_function_path) $status -eq $success
@test "setup: pond is not loaded" (not contains $pond_home/$pond_name $fish_function_path) $status -eq $success
@test "pond init: success exit code" (__pond_init) $status -eq $success
@test "pond init: autoloaded init function inaccessible" (functions -q {$pond_name}_{$pond_init_suffix}) $status -eq $failure
@test "pond init: autoloaded deinit function inaccessible" (functions -q {$pond_name}_{$pond_deinit_suffix}) $status -eq $failure
__pond_tear_down

@echo "pond init: success tests for multiple enabled ponds"
__pond_setup 3 enabled populated
__pond_remove_from_fish_function_path $pond_name_prefix-1 $pond_name_prefix-2 $pond_name_prefix-3
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
@test "pond init: $pond_name_prefix-1 autoloaded init function accessible" (functions -q {$pond_name_prefix-1}_{$pond_init_suffix}) $status -eq $success
@test "pond init: $pond_name_prefix-2 autoloaded init function accessible" (functions -q {$pond_name_prefix-2}_{$pond_init_suffix}) $status -eq $success
@test "pond init: $pond_name_prefix-3 autoloaded init function accessible" (functions -q {$pond_name_prefix-3}_{$pond_init_suffix}) $status -eq $success
@test "pond init: $pond_name_prefix-1 autoloaded deinit function accessible" (functions -q {$pond_name_prefix-1}_{$pond_deinit_suffix}) $status -eq $success
@test "pond init: $pond_name_prefix-2 autoloaded deinit function accessible" (functions -q {$pond_name_prefix-2}_{$pond_deinit_suffix}) $status -eq $success
@test "pond init: $pond_name_prefix-3 autoloaded deinit function accessible" (functions -q {$pond_name_prefix-3}_{$pond_deinit_suffix}) $status -eq $success
__pond_tear_down

@echo "pond init: success tests for multiple disabled ponds"
__pond_setup 3 disabled populated
@test "setup: $pond_name_prefix-1 pond is disabled" (not contains $pond_home/$pond_name_prefix-1 $pond_function_path) $status -eq $success
@test "setup: $pond_name_prefix-2 pond is disabled" (not contains $pond_home/$pond_name_prefix-2 $pond_function_path) $status -eq $success
@test "setup: $pond_name_prefix-3 pond is disabled" (not contains $pond_home/$pond_name_prefix-3 $pond_function_path) $status -eq $success
@test "setup: $pond_name_prefix-1 pond is not loaded" (not contains $pond_home/$pond_name_prefix-1 $fish_function_path) $status -eq $success
@test "setup: $pond_name_prefix-2 pond is not loaded" (not contains $pond_home/$pond_name_prefix-2 $fish_function_path) $status -eq $success
@test "setup: $pond_name_prefix-3 pond is not loaded" (not contains $pond_home/$pond_name_prefix-3 $fish_function_path) $status -eq $success
@test "pond init: success exit code" (__pond_init) $status -eq $success
@test "pond init: $pond_name_prefix-1 autoloaded init function inaccessible" (functions -q {$pond_name_prefix-1}_{$pond_init_suffix}) $status -eq $failure
@test "pond init: $pond_name_prefix-2 autoloaded init function inaccessible" (functions -q {$pond_name_prefix-2}_{$pond_init_suffix}) $status -eq $failure
@test "pond init: $pond_name_prefix-3 autoloaded init function inaccessible" (functions -q {$pond_name_prefix-3}_{$pond_init_suffix}) $status -eq $failure
@test "pond init: $pond_name_prefix-1 autoloaded deinit function inaccessible" (functions -q {$pond_name_prefix-1}_{$pond_deinit_suffix}) $status -eq $failure
@test "pond init: $pond_name_prefix-2 autoloaded deinit function inaccessible" (functions -q {$pond_name_prefix-2}_{$pond_deinit_suffix}) $status -eq $failure
@test "pond init: $pond_name_prefix-3 autoloaded deinit function inaccessible" (functions -q {$pond_name_prefix-3}_{$pond_deinit_suffix}) $status -eq $failure
__pond_tear_down
