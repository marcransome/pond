function __pond_install --on-event pond_install
    set -U pond_home $__fish_config_dir/pond
    set -U pond_regular regular
    set -U pond_private private
    set -U pond_links links
    set -U pond_vars env_vars.fish
    set -U pond_functions functions
    set -U pond_message_prefix pond
    set -U pond_enable_on_create yes

    set editors (command -s $EDITOR vim vi emacs nano)
    if test $status -eq 0
        set -U pond_editor vim
    else
        echo "Unable to determine editor; some commands may not function"
        echo "correctly (e.g. 'edit'); Set editor with: set -U pond_editor <path>"
    end

    for pond_dir in $pond_regular $pond_private $pond_links
        if test (mkdir -p $pond_home/$pond_dir >/dev/null 2>&1) $status -ne 0
            echo "pond_message_prefix: Failed to create directory: $dir"
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
            echo "$pond_message_prefix: Unable to remove pond data"
        end
    end

    set -e pond_home
    set -e pond_regular
    set -e pond_private
    set -e pond_links
    set -e pond_vars
    set -e pond_functions
    set -e pond_message_prefix
    set -e pond_enable_on_create
    set -e pond_editor
end

function __pond_init
    for vars in $pond_home/$pond_links/*/$pond_vars
        source $vars
    end

    for func in $pond_home/$pond_links/*/$pond_functions/*.fish
        source $func
    end
end

__pond_init
