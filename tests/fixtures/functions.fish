function __pond_init_populate -a pond_name
    set -l pond_init_function {$pond_name}_{$pond_init_suffix}
    set -l pond_init_file $pond_home/$pond_name/$pond_init_function.fish

    echo "function $pond_init_function\n\nend" >> $pond_init_file
end

function __pond_deinit_populate -a pond_name
    set -l pond_deinit_function {$pond_name}_{$pond_deinit_suffix}
    set -l pond_deinit_file $pond_home/$pond_name/$pond_deinit_function.fish

    echo "function $pond_deinit_function\n\nend" >> $pond_deinit_file
end

function __pond_setup -a pond_count pond_state pond_data
    for pond_name in $pond_name_prefix-(seq $pond_count)
        mkdir -p $pond_home/$pond_name

        if test "$pond_state" = "enabled"
             set -U -a pond_function_path $pond_home/$pond_name    # enabled
             set -g -a fish_function_path $pond_home/$pond_name    # loaded
        end

        if test "$pond_data" = "populated"
            __pond_init_populate $pond_name
            __pond_deinit_populate $pond_name
        end
    end
end

function __pond_load_init -a pond_count
    for pond_name in $pond_name_prefix-(seq $pond_count)
        {$pond_name}_{$pond_init_suffix}
    end
end

function __pond_load_deinit -a pond_count
    for pond_name in $pond_name_prefix-(seq $pond_count)
        {$pond_name}_{$pond_init_suffix}
    end
end

function __pond_tear_down
    for pond_path in $pond_home/$pond_name_prefix-*
        rm -rf $pond_path
        set -l fish_function_path_index (contains -i $pond_path $fish_function_path)
        if test -n "$fish_function_path_index"
            set -e fish_function_path[$fish_function_path_index]
        end
    end

    set -e pond_function_path
end

function __pond_editor_intercept_with -a function_name
    set -U pond_editor $function_name
end

function __pond_expect_init_path -a got_path
    if ! test "$got_path" = "$pond_home/$pond_name/$pond_name"_{$pond_init_suffix}.fish
        return 1
    end
end

function __pond_expect_deinit_path -a got_path
    if ! test "$got_path" = "$pond_home/$pond_name/$pond_name"_{$pond_deinit_suffix}.fish
        return 1
    end
end

function __pond_editor_reset
    set -U pond_editor $pond_editor_before_test
end

function __pond_event_reset
    set -e event_pond_name
    set -e event_pond_path
    set -e event_pond_names
    set -e event_pond_paths
end
