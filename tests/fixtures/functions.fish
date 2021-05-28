function __pond_init_populate -a pond_name pond_vars_count
    set -l pond_var_name_prefix (string upper $pond_name | string replace -a '-' _)"_VAR"
    set -l pond_init_function {$pond_name}_{$pond_init_suffix}
    set -l pond_init_file $pond_home/$pond_name/$pond_init_function.fish

    echo "function $pond_init_function" >> $pond_init_file
    for pond_var_name in $pond_var_name_prefix"_"(seq $pond_vars_count)
        echo "set -xg $pond_var_name "(string lower $pond_var_name) >> $pond_init_file
    end
    echo "end" >> $pond_init_file
end

function __pond_deinit_populate -a pond_name pond_vars_count
    set -l pond_var_name_prefix (string upper $pond_name | string replace -a '-' _)"_VAR"
    set -l pond_deinit_function {$pond_name}_{$pond_deinit_suffix}
    set -l pond_deinit_file $pond_home/$pond_name/$pond_deinit_function.fish

    echo "function $pond_deinit_function" >> $pond_deinit_file
    for pond_var_name in $pond_var_name_prefix"_"(seq $pond_vars_count)
        echo "set -e $pond_var_name "(string lower $pond_var_name) >> $pond_deinit_file
    end
    echo "end" >> $pond_deinit_file
end

function __pond_setup -a pond_count pond_state pond_data
    for pond_name in $pond_name_prefix-(seq $pond_count)
        mkdir -p $pond_home/$pond_name

        if test "$pond_state" = "enabled"
             set -U -a pond_function_path $pond_home/$pond_name
        end

        if test "$pond_data" = "populated"
            __pond_init_populate $pond_name $pond_test_var_count
            __pond_deinit_populate $pond_name $pond_test_var_count
        end
    end
end

function __pond_load_vars -a pond_count
    for pond_name in $pond_name_prefix-(seq $pond_count)
        {$pond_name}_{$pond_init_suffix}
    end
end

function __pond_clear_vars -a pond_count
    for pond_name in $pond_name_prefix-(seq $pond_count)
        for test_var in (string upper $pond_name | string replace -a '-' _)"_VAR_"(seq $pond_test_var_count)
            set -q $test_var; and set -e $test_var
        end
    end
end

function __pond_tear_down


    # TODO running this locally can have negative consequences; can we create a tempdir and point pond_home at it for testing?
    rm -rf $pond_home/*

    for pond_path in $pond_function_path
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
