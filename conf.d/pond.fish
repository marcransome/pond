function __pond_install --on-event pond_install
    set -U pond_home $__fish_config_dir/pond
    set -U pond_message_prefix pond
    set -U pond_enable_on_create yes
    set -U pond_init_suffix init
    set -U pond_deinit_suffix deinit

    set -l editors (command -s $EDITOR vim vi emacs nano)
    if test $status -eq 0
        set -U pond_editor $editors[1]
        echo "$pond_message_prefix: Setting pond editor to command: $editors[1]"
        echo "$pond_message_prefix: Change editor with: set -U pond_editor <path>"
    else
        echo "$pond_message_prefix: Unable to determine editor; some commands may not function" >&2
        echo "$pond_message_prefix: correctly (e.g. 'edit'); Set editor with: set -U pond_editor <path>" >&2
    end

    if test (mkdir -p $pond_home >/dev/null 2>&1) $status -ne 0
        echo "$pond_message_prefix: Failed to create directory: $pond_home" >&2
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

    for fish_path in $fish_function_path
        test -z "$pond_home"; and break
        for pond_path in (string match -r "$pond_home/.*" -- $fish_function_path)
            if set -l fish_function_path_index (contains -i $pond_path $fish_function_path)
                set -e fish_function_path[$fish_function_path_index]
            end
        end
    end

    set -e pond_home
    set -e pond_message_prefix
    set -e pond_enable_on_create
    set -e pond_editor
    set -e pond_init_suffix
    set -e pond_deinit_suffix

    set -e __pond_init
    set -e __pond_install
    set -e __pond_uninstall

    set -e pond_function_path
end

function __pond_init
    set -a fish_function_path $pond_function_path

    for pond_path in $pond_function_path
        set -l pond_init_function (string split -m1 -r '/' "$pond_path")[2]_init
        type -q $pond_init_function; and $pond_init_function
    end
end

__pond_init
