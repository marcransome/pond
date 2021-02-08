function _pond_install --on-event pond_install
    set -U pond_tree "$__fish_config_dir/ponds"
    set -U pond_vars "env_vars.fish"
    set -U pond_funcs "functions"
    set -U pond_prefix "pond"
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
    for vars in $pond_tree/*/$pond_vars
        source $vars
    end

    for func in $pond_tree/*/$pond_funcs/*.fish
        source $func
    end
end

_pond_init
