function pond -a command -d "A fish shell environment manager"
    set -l pond_version 0.3.0

    function __pond_usage
        functions -e __pond_usage
        echo "Usage:"
        echo "    pond [options] or pond [command-options] <command> ..."
        echo
        echo "Help Options:"
        echo "    -h, --help            Show this help message"
        echo "    <command> -h, --help  Show command help"
        echo
        echo "Application Options:"
        echo "    -v, --version           Print the version string"
        echo
        echo "Commands:"
        echo "    create   Create a new pond"
        echo "    remove   Remove a pond and associated data"
        echo "    edit     Edit an existing pond"
        echo "    enable   Enable a pond for new shell sessions"
        echo "    disable  Disable a pond for new shell sessions"
        echo "    load     Load pond data into current shell session"
        echo "    unload   Unload pond data into from current shell session"
        echo "    status   View pond status"
        echo "    drain    Drain all data from pond"
        echo
    end

    function __pond_create_command_usage
        functions -e __pond_create_command_usage
        echo "Usage:"
        echo "    pond create [options] <name>"
        echo
        echo "Options:"
        echo "    -e, --empty  Create pond without opening editor"
        echo
        echo "Arguments:"
        echo "    name  The name of the pond to create"
        echo
    end

    function __pond_remove_command_usage
        functions -e __pond_remove_command_usage
        echo "Usage:"
        echo "    pond remove [options] <name>"
        echo
        echo "Options:"
        echo "    -s, --silent  Silence confirmation prompt"
        echo
        echo "Arguments:"
        echo "    name  The name of the pond to remove"
        echo
    end

    function __pond_list_command_usage
        functions -e __pond_list_command_usage
        echo "Usage:"
        echo "    pond list"
        echo
    end

    function __pond_edit_command_usage
        functions -e __pond_edit_command_usage
        echo "Usage:"
        echo "    pond edit <name>"
        echo
        echo "Arguments:"
        echo "    name  The name of the pond to edit"
        echo
    end

    function __pond_enable_command_usage
        functions -e __pond_enable_command_usage
        echo "Usage:"
        echo "    pond enable <name>"
        echo
        echo "Arguments:"
        echo "    name  The name of the pond to enable"
        echo
    end

    function __pond_disable_command_usage
        functions -e __pond_disable_command_usage
        echo "Usage:"
        echo "    pond disable <name>"
        echo
        echo "Arguments:"
        echo "    name  The name of the pond to disable"
        echo
    end

    function __pond_load_command_usage
        functions -e __pond_load_command_usage
        echo "Usage:"
        echo "    pond load <name>"
        echo
        echo "Arguments:"
        echo "    name  The name of the pond to load"
        echo
    end

    function __pond_unload_command_usage
        functions -e __pond_unload_command_usage
        echo "Usage:"
        echo "    pond unload <name>"
        echo
        echo "Arguments:"
        echo "    name  The name of the pond to unload"
        echo
    end

    function __pond_status_command_usage
        functions -e __pond_status_command_usage
        echo "Usage:"
        echo "    pond status <name>"
        echo
        echo "Arguments:"
        echo "    name  The name of the pond"
        echo
    end

    function __pond_drain_command_usage
        functions -e __pond_drain_command_usage
        echo "Usage:"
        echo "    pond drain <name>"
        echo
        echo "Arguments:"
        echo "    name  The name of the pond to drain"
        echo
    end

    function __pond_create_operation -a pond_name
        functions -e __pond_create_operation
        mkdir -p $pond_data/$pond_name >/dev/null 2>&1
        if test $status -ne 0
            echo "Could not create pond directory at $pond_data/$pond_name" >&2 && return 1
        end

        touch $pond_data/$pond_name/$pond_vars 2>/dev/null
        if test $status -ne 0
            echo "Could not create pond variables file $pond_data/$pond_name/$pond_vars" >&2 && return 1
        end

        mkdir -p $pond_data/$pond_name/$pond_functions >/dev/null 2>&1
        if test $status -ne 0
            echo "Could not create pond functions directory $pond_data/$pond_name/$pond_functions" >&2 && return 1
        end

        echo "Created pond: $pond_name"

        if test $pond_enable_on_create
            ln -s $pond_data/$pond_name $pond_links/$pond_name >/dev/null 2>&1
            if test $status -ne 0
                echo "Could not create pond symbolic link at $pond_links/$pond_name" >&2 && return 1
            end
        end
    end

    function __pond_remove_operation -a pond_name silent
        functions -e __pond_remove_operation
        set -l answer

        if test $silent -ne 0
            read --prompt-str "Remove pond: $pond_name? " answer
            if ! string length -q $answer; or ! string match -i -r '^(y|yes)$' -q $answer
                return 0;
            end
        end

        rm -rf $pond_data/$pond_name
        if test $status -eq 0
            echo "Removed pond: $pond_name"
        else
            echo "Unable to remove pond: $pond_name" >&2 && return 1
        end
    end

    function __pond_list_operation
        functions -e __pond_list_operation

        set -l pond_paths $pond_data/*/

        if test (count $pond_paths) -eq 0
            echo "No ponds found" >&2 && return 1
        else
            for pond_path in $pond_paths
                echo (basename $pond_path)
            end
        end
    end

    function __pond_enable_operation -a pond_name
        functions -e __pond_enable_operation

        if test -L $pond_links/$pond_name
            echo "Pond is already enabled: $pond_name" >&2 && return 1
        else
            ln -s $pond_data/$pond_name $pond_links/$pond_name >/dev/null 2>&1
            if test $status -ne 0
                echo "Could not create symbolic link at $pond_links/$pond_name" >&2 && return 1
            end

            echo "Enabled pond: $pond_name"
        end
    end

    function __pond_disable_operation -a pond_name
        functions -e __pond_disable_operation

        if ! test -L $pond_links/$pond_name
            echo "Pond is already disabled: $pond_name" >&2 && return 1
        else
            unlink $pond_links/$pond_name >/dev/null 2>&1
            if test $status -ne 0
                echo "Could not remove symbolic link at $pond_links/$pond_name" >&2 && return 1
            end

            echo "Disabled pond: $pond_name"
        end
    end

    function __pond_load_operation -a pond_name
        functions -e __pond_load_operation

        source $pond_data/$pond_name/$pond_vars
        if test $status -ne 0
            echo "Unable to source variables file at $pond_data/$pond_name/$pond_vars" >&2 && return 1
        end

        echo "Pond loaded: $pond_name"
    end

    function __pond_unload_operation -a pond_name
        functions -e __pond_unload_operation

        while read -la line
            if test -z "$line"; or string match -r '^#' "$line" -q
                continue
            end

            set tokens (string match -r '^set -xg [A-Za-z0-9_]+ (.*)$' "$line")
            set -e $tokens[2]
            if test $status -ne 0
                echo "Unable to erase variable from environment '$tokens[2]'" >&2 && return 1
            end
        end < $pond_data/$pond_name/$pond_vars

        echo "Pond unloaded: $pond_name"
    end

    function __pond_status_operation -a pond_name
        functions -e __pond_status_operation
        echo "name: $pond_name"
        echo "enabled: "(test -L $pond_links/$pond_name; and echo 'yes'; or echo 'no')
        echo "path: $pond_data/$pond_name"
    end

    function __pond_drain_operation -a pond_name silent
        functions -e __pond_drain_operation
        set -l answer

        if test $silent -ne 0
            read --prompt-str "Drain pond: $pond_name? " answer
            if ! string length -q $answer; or ! string match -i -r '^(y|yes)$' -q $answer
                return 0;
            end
        end

        echo > $pond_data/$pond_name/$pond_vars
        if test $status -eq 0
            echo "Drained pond: $pond_name"
        else
            echo "Unable to drain pond: $pond_name" >&2 && return 1
        end
    end

    function __pond_exists -a pond_name
        functions -e __pond_exists
        test -d $pond_data/$pond_name
    end

    function __pond_show_exists_error -a pond_name
        functions -e __pond_show_exists_error
        echo "Pond already exists: $pond_name" >&2
    end

    function __pond_show_not_exists_error -a pond_name
        functions -e __pond_show_not_exists_error
        echo "Pond does not exist: $pond_name" >&2
    end

    function __pond_show_name_missing_error
        functions -e __pond_show_name_missing_error
        echo "No pond name specified" >&2
    end

    switch $command
        case -v --version
            echo "pond $pond_version"
        case '' -h --help
            __pond_usage
        case create
            set -l pond_name
            set -l pond_command_option

            if test (count $argv) -eq 2;
                and string match -r '^([A-Za-z0-9]{1}[A-Za-z0-9-_]*)$' -q -- $argv[2];
              set pond_name $argv[2]
            else if test (count $argv) -eq 3;
                and string match -r '^(-e|--empty)$' -q -- $argv[2];
                and string match -r '^([A-Za-z0-9]+[A-Za-z0-9-_]*)$' -q -- $argv[3]
              set pond_command_option $argv[2]
              set pond_name $argv[3]
            else
                __pond_create_command_usage && return 1
            end
            if __pond_exists $pond_name; __pond_show_exists_error $pond_name && return 1; end

            switch $pond_command_option
                case -e --empty
                    __pond_create_operation $pond_name
                case '*'
                    __pond_create_operation $pond_name
                    $pond_editor $pond_data/$pond_name/$pond_vars
            end
        case edit
            set -l pond_name

            if test (count $argv) -eq 2;
                and string match -r '^([A-Za-z0-9]{1}[A-Za-z0-9-_]*)$' -q -- $argv[2];
              set pond_name $argv[2]
            else
                __pond_edit_command_usage && return 1
            end
            if ! __pond_exists $pond_name; __pond_show_not_exists_error $pond_name && return 1; end

            $pond_editor $pond_data/$pond_name/$pond_vars
        case remove
            set -l pond_name
            set -l pond_command_option

            if test (count $argv) -eq 2;
                and string match -r '^([A-Za-z0-9]{1}[A-Za-z0-9-_]*)$' -q -- $argv[2];
              set pond_name $argv[2]
            else if test (count $argv) -eq 3;
                and string match -r '^(-s|--silent)$' -q -- $argv[2];
                and string match -r '^([A-Za-z0-9]+[A-Za-z0-9-_]*)$' -q -- $argv[3]
              set pond_command_option $argv[2]
              set pond_name $argv[3]
            else
                __pond_remove_command_usage && return 1
            end
            if ! __pond_exists $pond_name; __pond_show_not_exists_error $pond_name && return 1; end

            switch $pond_command_option
                case -s --silent
                    __pond_remove_operation $pond_name 0
                case '*'
                    __pond_remove_operation $pond_name 1
            end
        case list
            if test (count $argv) -ne 1; and __pond_list_command_usage && return 1; end

            __pond_list_operation
        case enable
            set -l pond_name

            if test (count $argv) -eq 2;
                and string match -r '^([A-Za-z0-9]{1}[A-Za-z0-9-_]*)$' -q -- $argv[2];
              set pond_name $argv[2]
            else
                __pond_enable_command_usage && return 1
            end
            if ! __pond_exists $pond_name; __pond_show_not_exists_error $pond_name && return 1; end

            __pond_enable_operation
        case disable
            set -l pond_name

            if test (count $argv) -eq 2;
                and string match -r '^([A-Za-z0-9]{1}[A-Za-z0-9-_]*)$' -q -- $argv[2];
              set pond_name $argv[2]
            else
                __pond_disable_command_usage && return 1
            end
            if ! __pond_exists $pond_name; __pond_show_not_exists_error $pond_name && return 1; end

            __pond_disable_operation
        case load
            set -l pond_name

            if test (count $argv) -eq 2;
                and string match -r '^([A-Za-z0-9]{1}[A-Za-z0-9-_]*)$' -q -- $argv[2];
              set pond_name $argv[2]
            else
                __pond_load_command_usage && return 1
            end
            if ! __pond_exists $pond_name; __pond_show_not_exists_error $pond_name && return 1; end

            __pond_load_operation
        case unload
            set -l pond_name

            if test (count $argv) -eq 2;
                and string match -r '^([A-Za-z0-9]{1}[A-Za-z0-9-_]*)$' -q -- $argv[2];
              set pond_name $argv[2]
            else
                __pond_unload_command_usage && return 1
            end
            if ! __pond_exists $pond_name; __pond_show_not_exists_error $pond_name && return 1; end

            __pond_unload_operation
        case status
            set -l pond_name

            if test (count $argv) -eq 2;
                and string match -r '^([A-Za-z0-9]{1}[A-Za-z0-9-_]*)$' -q -- $argv[2];
              set pond_name $argv[2]
            else
                __pond_status_command_usage && return 1
            end
            if ! __pond_exists $pond_name; __pond_show_not_exists_error $pond_name && return 1; end

            __pond_status_operation
        case drain
            set -l pond_name
            set -l pond_command_option

            if test (count $argv) -eq 2;
                and string match -r '^([A-Za-z0-9]{1}[A-Za-z0-9-_]*)$' -q -- $argv[2];
              set pond_name $argv[2]
            else if test (count $argv) -eq 3;
                and string match -r '^(-s|--silent)$' -q -- $argv[2];
                and string match -r '^([A-Za-z0-9]+[A-Za-z0-9-_]*)$' -q -- $argv[3]
              set pond_command_option $argv[2]
              set pond_name $argv[3]
            else
                __pond_drain_command_usage && return 1
            end
            if ! __pond_exists $pond_name; __pond_show_not_exists_error $pond_name && return 1; end

            switch $pond_command_option
                case -s --silent
                    __pond_drain_operation $pond_name 0
                case '*'
                    __pond_drain_operation $pond_name 1
            end
        case '*'
            __pond_usage
            echo "Unknown command: $command" >&2 && return 1
    end
end
