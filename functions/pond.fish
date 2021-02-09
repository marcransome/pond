function pond --argument-names cmd --description "An environment manager for Fish"
    set --local pond_version 0.2.0

    function _pond_usage
        echo "Usage: pond <subcommand> ..."
        echo "Pond management:"
        echo "       pond create  <name>  Create a new pond"
        echo "       pond remove  <name>  Remove a pond and associated configuration"
        echo "       pond list            List all ponds"
        echo "       pond enable          Enable a pond for new shell sessions"
        echo "       pond disable         Disable a pond for new shell sessions"
        echo "       pond status          View pond status information"
        echo "Variable management:"
        echo "       pond var list    <pond>                List all pond variables"
        echo "       pond var set     <pond> <var> <value>  Set pond variable"
        echo "       pond var get     <pond> <var>          Get pond variable"
        echo "       pond var remove  <pond> <var>          Remove pond variable"
        echo "Options:"
        echo "       -v or --version  Print version"
        echo "       -h or --help     Print this help message"
        functions -e _pond_usage
    end

    function _pond_var_usage
        echo "Usage: pond var list|set|get|remove <pond> ..."
        echo "Variable management:"
        echo "       pond var list    <pond>                List all pond variables"
        echo "       pond var set     <pond> <var> <value>  Set pond variable"
        echo "       pond var get     <pond> <var>          Get pond variable"
        echo "       pond var remove  <pond> <var>          Remove pond variable"
        functions -e _pond_var_usage
    end

    switch $cmd
        case -v --version
            echo "pond $pond_version"
        case '' -h --help
            _pond_usage
        case new create
            set --local pond_name "$argv[2]"

            if test -z $pond_name
                echo "Missing pond name for subcommand: \"$cmd\"" >&2 && return 1
            end

            if test -d $pond_data/$pond_name
                echo "Pond '$pond_name' already exists" >&2 && return 1
            end

            mkdir -p $pond_data/$pond_name >/dev/null 2>&1
            if test $status -ne 0
                echo "Could not create pond directory at $pond_data/$pond_name" >&2 && return 1
            end

            touch $pond_data/$pond_name/$pond_vars >/dev/null 2>&1
            if test $status -ne 0
                echo "Could not create pond variables file $pond_data/$pond_name/$pond_vars" >&2 && return 1
            end

            mkdir -p $pond_data/$pond_name/$pond_functions >/dev/null 2>&1
            if test $status -ne 0
                echo "Could not create pond functions directory $pond_data/$pond_name/$pond_functions" >&2 && return 1
            end

            echo "Created an empty pond '$pond_name'"

            if test $pond_enable_on_create
                ln -s $pond_data/$pond_name $pond_links/$pond_name >/dev/null 2>&1
                if test $status -ne 0
                    echo "Could not create pond symbolic link at $pond_links/$pond_name" >&2 && return 1
                end
            end
        case ls list
            set --local pond_paths $pond_data/*

            if test (count $pond_paths) -eq 0
                echo "No ponds found; create one with 'create'" >&2 && return 1
            else
                for pond_path in $pond_paths
                    echo (basename $pond_path)
                end
            end
        case rm remove
            set --local pond_name "$argv[2]"

            if test -z $pond_name
                echo "Missing pond name for subcommand: \"$cmd\"" >&2 && return 1
            end

            if test -d $pond_data/$pond_name
                read --prompt-str "Are you sure you want to remove pond '$pond_name'? " answer
                if string length -q $answer; and string match -i -r '^(y|yes)$' -q $answer
                    rm -rf $pond_data/$pond_name
                    if test $status -eq 0
                        echo "Removed pond '$pond_name'"
                    else
                        echo "Unable to remove pond '$pond_name'" >&2 && return 1
                    end
                end
            else
                echo "Pond '$pond_name' does not exist" >&2 && return 1
            end

        case link enable
            set --local pond_name "$argv[2]"

            if test -z $pond_name
                echo "Missing pond name for subcommand: \"$cmd\"" >&2 && return 1
            end

            if ! test -e $pond_data/$pond_name
                echo "Pond '$pond_name' does not exist" >&2 && return 1
            end

            if test -L $pond_links/$pond_name
                echo "Pond '$pond_name' is already enabled" >&2 && return 1
            else
                ln -s $pond_data/$pond_name $pond_links/$pond_name >/dev/null 2>&1
                if test $status -ne 0
                    echo "Could not create pond symbolic link at $pond_links/$pond_name" >&2 && return 1
                end

                echo "Enabled pond '$pond_name'"
            end
        case unlink disable
            set --local pond_name "$argv[2]"

            if test -z $pond_name
                echo "Missing pond name for subcommand: \"$cmd\"" >&2 && return 1
            end

            if ! test -e $pond_data/$pond_name
                echo "Pond '$pond_name' does not exist" >&2 && return 1
            end

            if ! test -L $pond_links/$pond_name
                echo "Pond '$pond_name' is already disabled" >&2 && return 1
            else
                unlink $pond_links/$pond_name >/dev/null 2>&1
                if test $status -ne 0
                    echo "Could not remove symbolic link at $pond_links/$pond_name" >&2 && return 1
                end

                echo "Disabled pond '$pond_name'"
            end
        case status
            set --local pond_name "$argv[2]"

            if test -z $pond_name
                echo "Missing pond name for subcommand: \"$cmd\"" >&2 && return 1
            end

            if ! test -e $pond_data/$pond_name
                echo "Pond '$pond_name' does not exist" >&2 && return 1
            end

            echo "name: $pond_name"

            if test -L $pond_links/$pond_name
                echo "enabled: yes"
            else
                echo "enabled: no"
            end

            echo "path: $pond_data/$pond_name"
        case var variable
            set --local var_action "$argv[2]"
            set --local pond_name "$argv[3]"
            set --local var_name "$argv[4]"
            set --local var_value "$argv[5]"

            if test -z $var_action; or test -z $pond_name
                _pond_var_usage
                echo "invalid usage"
                return 1
            end

            if ! test -e $pond_data/$pond_name
                echo "Pond '$pond_name' does not exist" >&2 && return 1
            end

            if ! test -e $pond_data/$pond_name/$pond_vars
                echo "Creating variables file '$pond_vars' for pond"
            end

            switch $var_action
                case ls list
                    while read -la line
                        if test -z "$line"; or string match -r '^#' "$line" -q
                            continue
                        end

                        set tokens (string match -r '^.*set.*-.* (.*) (.*)$' "$line")
                        echo "$line"
                    end < $pond_data/$pond_name/$pond_vars
                case get
                    if ! test -n $var_name
                        echo "No variable name provided for pond '$pond_name'" >&2 && return 1
                    end

                    while read -la line
                        set tokens (string match -r '^.*set.*-.* (.*) (.*)$' "$line")

                        if test -z "$line"; or string match -r '^#' "$line" -q
                            continue
                        end

                        if test $tokens[2] = $var_name
                            echo "$tokens[3]"
                            return 0
                        end
                    end < $pond_data/$pond_name/$pond_vars
                    echo "No variable '$var_name' in pond '$pond_name'" >&2 && return 1
                case set
                    if test -z $var_value
                        echo "No value provided for variable '$var_name'" >&2 && return 1
                    end

                    if grep -q "^.*set.*-.* $var_name .*\$" $pond_data/$pond_name/$pond_vars
                        echo "Variable '$var_name' already exists in pond '$pond_name'" >&2 && return 1
                    else
                        echo "set -xg $var_name $var_value" >> $pond_data/$pond_name/$pond_vars
                        echo "Set variable '$var_name' in pond '$pond_name'"
                    end
                case rm remove
                    if grep -q "^.*set.*-.* $var_name .*\$" $pond_data/$pond_name/$pond_vars
                        grep -ve "^.*set.*-.* $var_name .*\$" $pond_data/$pond_name/$pond_vars > $pond_data/$pond_name/$pond_vars.rmop
                        mv $pond_data/$pond_name/$pond_vars.rmop $pond_data/$pond_name/$pond_vars
                        set -u $var_name
                        echo "Variable '$var_name' removed from pond '$pond_name'"
                    else
                        echo "No variable '$var_name' in pond '$pond_name'" >&2 && return 1
                    end
                case '*'
                    _pond_var_usage
                    echo "Unknown subcommand: \"$cmd\"" >&2 && return 1
            end
        case '*'
            _pond_usage
            echo "Unknown subcommand: \"$cmd\"" >&2 && return 1
    end
end
