function pond --argument-names cmd --description "An environment manager for Fish"
    set --local pond_version 0.2.0

    function _pond_usage
        echo "Usage: pond <command> [arguments]"
        echo "Pond management:"
        echo "       pond create  <name>  Create a new pond"
        echo "       pond remove  <name>  Remove a pond and associated configuration"
        echo "       pond list            List all ponds"
        echo "       pond show            Show all pond files"
        echo "Variable management:"
        echo "       pond var set     <pond> <var> <value>  Set pond variable to value"
        echo "       pond var get     <pond> [var]          Get all pond variables or one if name provided"
        echo "       pond var remove  <pond> <var>          Remove pond variable"
        echo "Options:"
        echo "       -v or --version  Print version"
        echo "       -h or --help     Print this help message"
        functions -e _pond_usage
    end

    function _pond_var_usage
        echo "Usage: pond var set|get|remove <pond> ..."
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
                echo "$pond_prefix: Missing name argument for command: \"$cmd\"" >&2 && return 1
            end

            if test -d $pond_tree/$pond_name
                echo "$pond_prefix: A pond named '$pond_name' already exists" >&2 && return 1
            end

            mkdir -p $pond_tree/$pond_name >/dev/null 2>&1
            if test $status -ne 0
                echo "$pond_prefix: Could not create pond directory at $pond_tree/$pond_name" >&2 && return 1
            end

            touch $pond_tree/$pond_name/$pond_vars >/dev/null 2>&1
            if test $status -ne 0
                echo "$pond_prefix: Could not create pond variables file $pond_tree/$pond_name/$pond_vars" >&2 && return 1
            end

            mkdir -p $pond_tree/$pond_name/functions >/dev/null 2>&1
            if test $status -ne 0
                echo "$pond_prefix: Could not create pond functions directory $pond_tree/$pond_name" >&2 && return 1
            end

            echo "$pond_prefix: Created an empty pond named '$pond_name'"
        case ls list
            set --local pond_paths $pond_tree/*

            if test (count $pond_paths) -eq 0
                echo "$pond_prefix: No ponds found; create one with 'create'" >&2 && return 1
            else
                echo "$pond_prefix: Found the following ponds:"
                for pond_path in $pond_paths
                    echo "  "(basename $pond_path)
                end
            end
        case rm remove
            set --local pond_name "$argv[2]"

            if test -z $pond_name
                echo "$pond_prefix: Missing name argument for command: \"$cmd\"" >&2 && return 1
            end

            if test -d $pond_tree/$pond_name
                read --prompt-str "$pond_prefix: Are you sure you want to remove pond '$pond_name'? " answer
                if string length -q $answer; and string match -i -r '^(y|yes)$' -q $answer
                    rm -rf $pond_tree/$pond_name
                    if test $status -eq 0
                        echo "$pond_prefix: Removed pond '$pond_name'"
                    else
                        echo "$pond_prefix: Unable to remove pond '$pond_name'" >&2 && return 1
                    end
                end
            else
                echo "$pond_prefix: A pond named '$pond_name' does not exist" >&2 && return 1
            end
        case v var variable
            set --local var_action "$argv[2]"
            set --local pond_name "$argv[3]"
            set --local var_name "$argv[4]"
            set --local var_value "$argv[5]"

            if test -z $var_action; or test -z $pond_name
                _pond_var_usage
                echo "$pond_prefix: invalid usage"
                return 1
            end

            if ! test -e $pond_tree/$pond_name
                echo "$pond_prefix: A pond named '$pond_name' does not exist" >&2 && return 1
            end

            if ! test -e $pond_tree/$pond_name/$pond_vars
                echo "$pond_prefix: Creating variables file '$pond_vars' for pond"
            end

            switch $var_action
                case ls list
                    while read -la line
                        if test -z "$line"; or string match -r '^#' "$line" -q
                            continue
                        end

                        set tokens (string match -r '^.*set.*-.* (.*) (.*)$' "$line")
                        echo "$line"
                    end < $pond_tree/$pond_name/$pond_vars
                case get
                    if ! test -n $var_name
                        echo "$pond_prefix: No variable named provided for pond '$pond_name'" >&2 && return 1
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
                    end < $pond_tree/$pond_name/$pond_vars
                    echo "$pond_prefix: No variable named '$var_name' in pond '$pond_name'" >&2 && return 1
                case set
                    if test -z $var_value
                        echo "$pond_prefix: No value provided for variable '$var_name'" >&2 && return 1
                    end

                    if grep -q "^.*set.*-.* $var_name .*\$" $pond_tree/$pond_name/$pond_vars
                        echo "$pond_prefix: A variable named '$var_name' already exists in pond '$pond_name'" >&2 && return 1
                    else
                        echo "set -xg $var_name $var_value" >> $pond_tree/$pond_name/$pond_vars
                        echo "$pond_prefix: Set variable '$var_name' in pond '$pond_name'" >&2
                    end
                case rm remove
                    if grep -q "^.*set.*-.* $var_name .*\$" $pond_tree/$pond_name/$pond_vars
                        grep -ve "^.*set.*-.* $var_name .*\$" $pond_tree/$pond_name/$pond_vars > $pond_tree/$pond_name/$pond_vars.rmop
                        mv $pond_tree/$pond_name/$pond_vars.rmop $pond_tree/$pond_name/$pond_vars
                        set -u $var_name
                        echo "$pond_prefix: Variable '$var_name' removed from pond '$pond_name'" >&2
                    else
                        echo "$pond_prefix: No variable named '$var_name' in pond '$pond_name'" >&2 && return 1
                    end
            end
        case '*'
            _pond_usage
            echo "$pond_prefix: Unknown command: \"$cmd\"" >&2 && return 1
    end
end
