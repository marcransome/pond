function pond --argument-names cmd --description "An environment manager for Fish"
    set --local pond_version 0.1.0

    function _pond_usage
        echo "Usage: pond <command> [arguments]"
        echo "Pond management:"
        echo "       pond create  <name>  Create a new pond"
        echo "       pond remove  <name>  Remove a pond and associated configuration"
        echo "       pond list            List all ponds"
        echo "Options:"
        echo "       -v or --version  Print version"
        echo "       -h or --help     Print this help message"
        functions -e _pond_usage
    end

    switch $cmd
        case '-v' '--version'
            echo "pond $pond_version"
        case '' '-h' '--help'
            _pond_usage
        case 'new' 'create'
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
        case 'ls' 'list'
            set --local pond_paths $pond_tree/*

            if test (count $pond_paths) -eq 0
                echo "$pond_prefix: No ponds found; create one with 'create'" >&2 && return 1
            else
                echo "$pond_prefix: Found the following ponds:"
                for pond_path in $pond_paths
                    echo "  "(basename $pond_path)
                end
            end
        case 'rm' 'remove'
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
        case '*'
            echo "$pond_prefix: Unknown command: \"$cmd\"" >&2 && return 1
    end
end
