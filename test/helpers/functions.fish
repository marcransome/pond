function __pond_vars_populate -a pond_name pond_vars_count pond_vars_type
    set -l pond_var_name_prefix (string upper $pond_name | string replace -a '-' _)"_VAR"

    echo "function "$pond_name"_init" >> $pond_home/$pond_vars_type/$pond_name/{$pond_name}_init.fish
    for pond_var_name in $pond_var_name_prefix"_"(seq $pond_vars_count)
        echo "set -xg $pond_var_name "(string lower $pond_var_name) >> $pond_home/$pond_vars_type/$pond_name/{$pond_name}_init.fish
    end
    echo "end" >> $pond_home/$pond_vars_type/$pond_name/{$pond_name}_init.fish
end

function __pond_setup -a pond_count pond_type pond_state pond_data
    set -l pond_name (test "$pond_type" = "regular"; and echo $pond_name_regular_prefix; or echo $pond_name_private_prefix)
    for i in (seq $pond_count)
        mkdir $pond_home/$pond_type/$pond_name-$i
        test "$pond_state" = "enabled"; and set -U -a pond_function_path $pond_home/$pond_type/$pond_name-$i
        if test "$pond_data" = "populated"
            __pond_vars_populate $pond_name-$i $pond_test_var_count $pond_type
        else
            touch $pond_home/$pond_type/$pond_name-$i/$pond_name-{$i}_init.fish
        end
    end
end

function __pond_load_vars -a pond_count pond_type
    set -l pond_name (test "$pond_type" = "regular"; and echo $pond_name_regular_prefix; or echo $pond_name_private_prefix)
    for i in (seq $pond_count)
        source $pond_home/$pond_type/$pond_name-$i/{$pond_name-$i}_init.fish
        {$pond_name-$i}_init
    end
end

function __pond_clear_vars -a pond_count pond_type
    set -l pond_prefix (test "$pond_type" = "regular"; and echo $pond_name_regular_prefix; or echo $pond_name_private_prefix)

    for pond_name in $pond_prefix-(seq $pond_count)
        for test_var in (string upper $pond_name | string replace -a '-' _)"_VAR_"(seq $pond_test_var_count)
            set -q $test_var; and set -e $test_var
        end
    end
end

function __pond_tear_down
    rm -rf $pond_home/{$pond_regular,$pond_private}
    mkdir $pond_home/{$pond_regular,$pond_private}

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

function __pond_regular_pond_editor -a pond_path
    if ! test "$pond_path" = "$pond_home/$pond_regular/$pond_name_regular/"$pond_name_regular"_init.fish"
        return 1
    end
end

function __pond_private_pond_editor -a pond_path
    if ! test "$pond_path" = "$pond_home/$pond_private/$pond_name_private/"$pond_name_private"_init.fish"
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
