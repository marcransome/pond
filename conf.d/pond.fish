function __pond_install --on-event pond_install
    set -U pond_home $__fish_config_dir/pond
    set -U pond_regular regular
    set -U pond_private private
    set -U pond_message_prefix pond
    set -U pond_enable_on_create yes

    set -l editors (command -s $EDITOR vim vi emacs nano)
    if test $status -eq 0
        set -U pond_editor $editors[1]
        echo "$pond_message_prefix: Setting pond editor to command: $editors[1]"
        echo "$pond_message_prefix: Change editor with: set -U pond_editor <path>"
    else
        echo "$pond_message_prefix: Unable to determine editor; some commands may not function" >&2
        echo "$pond_message_prefix: correctly (e.g. 'edit'); Set editor with: set -U pond_editor <path>" >&2
    end

    for pond_dir in $pond_regular $pond_private
        if test (mkdir -p $pond_home/$pond_dir >/dev/null 2>&1) $status -ne 0
            echo "$pond_message_prefix: Failed to create directory: $dir"
        end
    end
end

function __pond_uninstall --on-event pond_uninstall
    read --prompt-str "$pond_message_prefix: Purge all pond data when uninstalling plugin? " answer
    if string length -q $answer; and string match -i -r '^(y|yes)$' -q $answer
        rm -rf $pond_home
        if test $status -eq 0
            echo "$pond_message_prefix: Removed all pond data"
        else
            echo "$pond_message_prefix: Unable to remove pond data" >&2
        end
    end

    echo "$pond_message_prefix: Unable to remove pond data"
    for pond_path in $pond_function_path
        set -l fish_function_path_index (contains -i $pond_path $fish_function_path)
        if test -n "$fish_function_path_index"
            set -e fish_function_path[$fish_function_path_index]
        end
    end

    set -e pond_home
    set -e pond_regular
    set -e pond_private
    set -e pond_message_prefix
    set -e pond_enable_on_create
    set -e pond_function_path
    set -e pond_editor

    set -e __pond_init
    set -e __pond_install
    set -e __pond_uninstall
end

function __pond_init
    set -a fish_function_path $pond_function_path

    for pond_path in $pond_function_path
        if test -z "$pond_path"; continue; end

        set -l pond_init_function (basename $pond_path)_init
        if test (type -q $pond_init_function) $status -eq 0
            $pond_init_function
        end
    end
end

__pond_init
