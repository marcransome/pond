function _pond_install --on-event pond_install
    set -U pond_home "$__fish_config_dir/pond"
    set -U pond_data  "$pond_home/ponds"
    set -U pond_links "$pond_home/enabled"
    set -U pond_vars "env_vars.fish"
    set -U pond_functions "functions"
    set -U pond_prefix "pond"
    set -U pond_enable_on_create 1
end

function _pond_uninstall --on-event pond_uninstall
    if test -d $pond_tree
        read --prompt-str "$pond_message_prefix: Purge all pond data when uninstalling plugin? " answer
        if string length -q $answer; and string match -i -r '^(y|yes)$' -q $answer
            rm -rf $pond_tree
            if test $status -eq 0
                echo "$pond_message_prefix: Removed all pond data"
            else
                echo "$pond_message_prefix: Unable to remove pond data"
            end
        end
    end
end

function _pond_init
    mkdir -p $pond_data >/dev/null 2>&1
    mkdir -p $pond_links >/dev/null 2>&1

    for vars in $pond_links/*/$pond_vars
        source $vars
    end

    for func in $pond_links/*/$pond_funcs/*.fish
        source $func
    end
end

_pond_init
