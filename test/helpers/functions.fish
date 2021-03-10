function __pond_vars_populate -a pond_vars_path pond_vars_count pond_vars_type
    set pond_var_name_prefix (test "$pond_vars_type" = "regular"; and echo "TEST_VAR"; or echo "TEST_VAR_PRIVATE")

    for pond_var_name in $pond_var_name_prefix"_"(seq $pond_vars_count)
        echo "set -xg $pond_var_name "(string lower $pond_var_name) >> $pond_vars_path
    end
end

function __pond_setup -a pond_count pond_type pond_state pond_data
    set pond_name (test "$pond_type" = "regular"; and echo $pond_name_regular_prefix; or echo $pond_name_private_prefix)
    for i in (seq $pond_count)
        mkdir $pond_home/$pond_type/$pond_name-$i
        test "$pond_state" = "enabled"; and ln -s $pond_home/$pond_type/$pond_name-$i $pond_home/$pond_links/$pond_name-$i
        test "$pond_data" = "populated"; and __pond_vars_populate $pond_home/$pond_type/$pond_name-$i/$pond_vars $pond_test_var_count $pond_type
        touch $pond_home/$pond_type/$pond_name-$i/$pond_vars
        mkdir $pond_home/$pond_type/$pond_name-$i/$pond_functions
    end
end

function __pond_load_vars -a pond_count pond_type
    set pond_name (test "$pond_type" = "regular"; and echo $pond_name_regular_prefix; or echo $pond_name_private_prefix)
    for i in (seq $pond_count)
        source $pond_home/$pond_type/$pond_name-$i/$pond_vars
    end
end

function __pond_clear_vars
    for test_var in TEST_VAR_{,PRIVATE_}(seq $pond_test_var_count)
        set -q $test_var; and set -e $test_var
    end
end

function __pond_tear_down
    rm -rf $pond_home/{$pond_regular,$pond_private,$pond_links}
    mkdir $pond_home/{$pond_regular,$pond_private,$pond_links}
end

function __pond_editor_intercept_with -a function_name
    set -U pond_editor $function_name
end

function __pond_regular_pond_editor -a pond_path
    if ! test "$pond_path" = "$pond_home/$pond_regular/$pond_name_regular/$pond_vars"
        return 1
    end
end

function __pond_private_pond_editor -a pond_path
    if ! test "$pond_path" = "$pond_home/$pond_private/$pond_name_private/$pond_vars"
        return 1
    end
end

function __pond_editor_reset
    set -U pond_editor $pond_editor_before_test
end
