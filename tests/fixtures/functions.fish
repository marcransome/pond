function __pond_autoload_populate -a pond_name
    set -l pond_autoload_function {$pond_name}_{$pond_autoload_suffix}
    set -l pond_autoload_file $pond_home/$pond_name/$pond_autoload_function.fish

    echo -e "function $pond_autoload_function\n\nend" >>$pond_autoload_file
end

function __pond_autounload_populate -a pond_name
    set -l pond_autounload_function {$pond_name}_{$pond_autounload_suffix}
    set -l pond_autounload_file $pond_home/$pond_name/$pond_autounload_function.fish

    echo -e "function $pond_autounload_function\n\nend" >>$pond_autounload_file
end

function __pond_setup -a pond_count pond_enabled_state pond_loaded_state pond_data
    for pond_name in $pond_name_prefix-(seq $pond_count)
        mkdir -p $pond_home/$pond_name

        if test "$pond_enabled_state" = enabled
            set -U -a pond_function_path $pond_home/$pond_name
        else
            __pond_disable $pond_name
        end

        if test "$pond_loaded_state" = loaded
            set -g -a fish_function_path $pond_home/$pond_name
        else
            __pond_unload $pond_name
        end

        if test "$pond_data" = populated
            __pond_autoload_populate $pond_name
            __pond_autounload_populate $pond_name
        end
    end
end

function __pond_unload -a pond_name
    set -l fish_function_path_index (contains -i $pond_home/$pond_name $fish_function_path)
    if test -n "$fish_function_path_index"
        set -e fish_function_path[$fish_function_path_index]
    end
end

function __pond_disable -a pond_name
    set -l pond_function_path_index (contains -i $pond_home/$pond_name $pond_function_path)
    if test -n "$pond_function_path_index"
        set -e pond_function_path[$pond_function_path_index]
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

function __pond_expect_autoload_path -a got_path
    if ! test "$got_path" = "$pond_home/$pond_name/$pond_name"_{$pond_autoload_suffix}.fish
        return 1
    end
end

function __pond_expect_autounload_path -a got_path
    if ! test "$got_path" = "$pond_home/$pond_name/$pond_name"_{$pond_autounload_suffix}.fish
        return 1
    end
end

function __pond_test_autoload_editor -a autoload_file_path
    if ! test "$autoload_file_path" = "$pond_home/$pond_name/"{$pond_name}_{$pond_autoload_suffix}.fish
        return 1
    end
end

function __pond_test_autounload_editor -a autounload_file_path
    if ! test "$autounload_file_path" = "$pond_home/$pond_name/"{$pond_name}_{$pond_autounload_suffix}.fish
        return 1
    end
end

function __pond_editor_intercept_with -a function_name
    set -gx pond_editor $function_name
end

function __pond_editor_reset
    set -ge pond_editor
end

function __pond_error_string -a message
    printf (set_color red; and echo -n "Error: "; and set_color normal; and echo "$message")
end

function __pond_event_reset
    set -e event_pond_name
    set -e event_pond_path
    set -e event_pond_names
    set -e event_pond_paths
end
