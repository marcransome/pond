function pond -a command -d "A fish shell environment manager"
    set -l pond_version 0.3.0

    function __pond_usage
        functions -e __pond_usage
        echo "\
Usage:
    pond [options] or pond <command> [command-options] ...

Help Options:
    -h, --help            Show this help message
    <command> -h, --help  Show command help

Application Options:
    -v, --version           Print the version string

Commands:
    create   Create a new pond
    remove   Remove a pond and associated data
    list     List ponds
    edit     Edit an existing pond
    enable   Enable a pond for new shell sessions
    disable  Disable a pond for new shell sessions
    load     Load pond data into current shell session
    unload   Unload pond data from current shell session
    status   View pond status
    drain    Drain all data from pond" >&2
        echo
    end

    function __pond_create_command_usage
        functions -e __pond_create_command_usage
        echo "\
Usage:
    pond create [options] <name>

Options:
    -e, --empty    Create an empty pond; do not open editor
    -p, --private  Create a private pond

Arguments:
    name  The name of the pond to create; a pond names must
          begin with an alphanumeric character followed by
          any number of additional alphanumeric characters,
          underscores or dashes" >&2
        echo
    end

    function __pond_remove_command_usage
        functions -e __pond_remove_command_usage
        echo "\
Usage:
    pond remove [options] <name>

Options:
    -s, --silent  Silence confirmation prompt

Arguments:
    name  The name of the pond to remove" >&2
        echo
    end

    function __pond_list_command_usage
        functions -e __pond_list_command_usage
        echo "\
Usage:
    pond list" >&2
        echo
    end

    function __pond_edit_command_usage
        functions -e __pond_edit_command_usage
        echo "\
Usage:
    pond edit <name>

Arguments:
    name  The name of the pond to edit" >&2
        echo
    end

    function __pond_enable_command_usage
        functions -e __pond_enable_command_usage
        echo "\
Usage:
    pond enable <name>

Arguments:
    name  The name of the pond to enable" >&2
        echo
    end

    function __pond_disable_command_usage
        functions -e __pond_disable_command_usage
        echo "\
Usage:
    pond disable <name>

Arguments:
    name  The name of the pond to disable" >&2
        echo
    end

    function __pond_load_command_usage
        functions -e __pond_load_command_usage
        echo "\
Usage:
    pond load <name>

Arguments:
    name  The name of the pond to load" >&2
        echo
    end

    function __pond_unload_command_usage
        functions -e __pond_unload_command_usage
        echo "\
Usage:
    pond unload [options] <name>

Options:
    -v, --verbose  Output variable names during unload

Arguments:
    name  The name of the pond to unload" >&2
        echo
    end

    function __pond_status_command_usage
        functions -e __pond_status_command_usage
        echo "\
Usage:
    pond status <name>

Arguments:
    name  The name of the pond" >&2
        echo
    end

    function __pond_drain_command_usage
        functions -e __pond_drain_command_usage
        echo "\
Usage:
    pond drain <name>

Arguments:
    name  The name of the pond to drain" >&2
        echo
    end

    function __pond_create_operation -a pond_name empty private
        functions -e __pond_create_operation

        set -l pond_parent $pond_regular
        set -l pond_mode 755

        if test "$private" = "yes"
            set pond_parent $pond_private
            set pond_mode 700
        end

        if test (mkdir -p $pond_home/$pond_parent/$pond_name >/dev/null 2>&1) $status -ne 0
            echo "Failed to create pond directory: $pond_home/$pond_parent/$pond_name" >&2 && return 1
        end

        if test (chmod $pond_mode $pond_home/$pond_parent/$pond_name >/dev/null 2>&1) $status -ne 0
            echo "Failed to set mode on directory: $pond_home/$pond_parent/$pond_name"
        end

        if test (touch $pond_home/$pond_parent/$pond_name/$pond_vars 2>/dev/null) $status -ne 0
            echo "Failed to create pond variables file: $pond_home/$pond_parent/$pond_name/$pond_vars" >&2 && return 1
        end

        if test (mkdir -p $pond_home/$pond_parent/$pond_name/$pond_functions >/dev/null 2>&1) $status -ne 0
            echo "Failed to create pond functions directory: $pond_home/$pond_parent/$pond_name/$pond_functions" >&2 && return 1
        end

        if test "$pond_enable_on_create" = "yes"
            ln -s $pond_home/$pond_parent/$pond_name $pond_home/$pond_links/$pond_name >/dev/null 2>&1
            if test $status -ne 0
                echo "Failed to create symbolic link: $pond_home/$pond_links/$pond_name" >&2 && return 1
            end
        end

        if test -z "$__pond_under_test"
            and test (command -s $pond_editor >/dev/null 2>&1) $status -ne 0
            echo "Editor not found: $pond_editor" >&2 && return 1
        end

        if test "$empty" = "no"
            $pond_editor $pond_home/$pond_parent/$pond_name/$pond_vars
        end

        if __pond_is_private $pond_name
            echo "Created private pond: $pond_name"
        else
            echo "Created pond: $pond_name"
        end
    end

    function __pond_edit_operation -a pond_name
        functions -e __pond_edit_operation

        set -l pond_parent $pond_regular
        if __pond_is_private $pond_name; set pond_parent $pond_private; end

        if test -z "$__pond_under_test"
            and test (command -s $pond_editor >/dev/null 2>&1) $status -ne 0
            echo "Editor not found: $pond_editor" >&2 && return 1
        end

        $pond_editor $pond_home/$pond_parent/$pond_name/$pond_vars
    end

    function __pond_remove_operation -a pond_name silent
        functions -e __pond_remove_operation

        set -l answer
        set -l pond_parent $pond_regular
        set -l pond_remove_prompt 'Remove pond'
        set -l pond_remove_success 'Removed pond'
        set -l pond_remove_failure 'Unable to remove pond'

        if __pond_is_private $pond_name
            set pond_parent $pond_private
            set pond_remove_prompt 'Remove private pond'
            set pond_remove_success 'Removed private pond'
            set pond_remove_failure 'Unable to remove private pond'
        end

        if test "$silent" != "yes"
            read --prompt-str "$pond_remove_prompt: $pond_name? " answer
            if ! string length -q $answer; or ! string match -i -r '^(y|yes)$' -q $answer
                return 0;
            end
        end

        if test -L $pond_home/$pond_links/$pond_name
            if test (unlink $pond_home/$pond_links/$pond_name >/dev/null 2>&1) $status -ne 0
                echo "Failed to remove symbolic link: $pond_links/$pond_name" >&2 && return 1
            end
        end

        if test (rm -rf $pond_home/$pond_parent/$pond_name >/dev/null 2>&1) $status -ne 0
            echo "$pond_remove_failure: $pond_name" >&2 && return 1
        end

        echo "$pond_remove_success: $pond_name"
    end

    function __pond_list_operation
        functions -e __pond_list_operation

        if __pond_is_private
            set -l pond_paths $pond_home/$pond_private/*/
        else
            set -l pond_paths $pond_home/$pond_regular/*/
        end

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

        set -l pond_parent (test __pond_is_private -eq 0; and echo $pond_private; or echo $pond_regular)

        if test -L $pond_home/$pond_links/$pond_name;
            echo "Pond already enabled: $pond_name" >&2 && return 1
        else
            ln -s $pond_home/$pond_parent/$pond_name $pond_links/$pond_name >/dev/null 2>&1
            if test $status -ne 0
                echo "Failed to create symbolic link: $pond_links/$pond_name" >&2 && return 1
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
                echo "Failed to remove symbolic link: $pond_links/$pond_name" >&2 && return 1
            end

            echo "Disabled pond: $pond_name"
        end
    end

    function __pond_load_operation -a pond_name
        functions -e __pond_load_operation

        set -l pond_parent (test __pond_is_private -eq 0; and echo $pond_private; or echo $pond_regular)

        source $pond_home/$pond_parent/$pond_vars
        if test $status -ne 0
            echo "Failed to source file: $pond_home/$pond_parent/$pond_name/$pond_vars" >&2 && return 1
        end

        echo "Pond loaded: $pond_name"
    end

    function __pond_unload_operation -a pond_name verbose
        functions -e __pond_unload_operation

        set -l pond_parent (test __pond_is_private -eq 0; and echo $pond_private; or echo $pond_regular)

        while read -la line
            if test -z "$line"; or string match -r '^#' "$line" -q
                continue
            end

            set tokens (string match -r '\s*set\s+-{1,2}[A-Za-z]+\s+([^\s]+)' -- "$line")

            if test $verbose = "yes"
                echo "Erasing variable: $tokens[2]"
            end

            set -e $tokens[2]
            if test $status -ne 0
                echo "Failed to erase variable: $tokens[2]" >&2 && return 1
            end
        end < $pond_home/$pond_parent/$pond_vars

        echo "Pond unloaded: $pond_name"
    end

    function __pond_status_operation -a pond_name
        functions -e __pond_status_operation
        echo "name: $pond_name"
        echo "enabled: "(test -L $pond_home/$pond_links/$pond_name; and echo 'yes'; or echo 'no')
        echo "private: "(test __pond_is_private -eq 0; and echo 'yes'; or echo 'no')
        echo "path: $pond_home/"(test __pond_is_private -eq 0; and echo $pond_private; or echo $pond_regular)/$pond_name
    end

    function __pond_drain_operation -a pond_name silent
        functions -e __pond_drain_operation
        set -l answer

        if test $silent = "no"
            read --prompt-str "Drain pond: $pond_name? " answer
            if ! string length -q $answer; or ! string match -i -r '^(y|yes)$' -q $answer
                return 0;
            end
        end

        set -l pond_parent (test __pond_is_private -eq 0; and echo $pond_private; or echo $pond_regular)

        echo > $pond_home/$pond_parent/$pond_vars
        if test $status -eq 0
            echo "Drained pond: $pond_name"
        else
            echo "Unable to drain pond: $pond_name" >&2 && return 1
        end
    end

    function __pond_exists -a pond_name
        if ! test -d $pond_home/$pond_regular/$pond_name; and ! test -d $pond_home/$pond_private/$pond_name
            return 1
        end
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

    function __pond_is_private -a pond_name
        return (test -d $pond_home/$pond_private/$pond_name >/dev/null 2>&1) $status
    end

    function __pond_name_is_valid -a pond_name
        return (string match -r '^([A-Za-z0-9]{1}[A-Za-z0-9-_]*)$' -q -- $pond_name)
    end

    set argv $argv[2..-1] # remove command from argv

    switch $command
        case -v --version
            echo "pond $pond_version"
        case '' -h --help
            __pond_usage
        case create
            set -l pond_name $argv[-1]  # extract pond name from last argument
            set argv $argv[1..-2]       # remove pond name from argv
            set -l pond_empty no
            set -l pond_private no

            if test -z "$pond_name"; or ! __pond_name_is_valid "$pond_name"
                __pond_create_command_usage
                return 1
            end

            if test (count $argv) -gt 0
                if ! argparse 'e/empty' 'p/private' >/dev/null 2>&1 -- $argv
                    __pond_create_command_usage
                    return 1
                end
                if test (count $argv) -ne 0; __pond_create_command_usage && return 1; end
                set -q _flag_empty; and set pond_empty yes
                set -q _flag_private; and set pond_private yes
            end

            if __pond_exists $pond_name; __pond_show_exists_error $pond_name && return 1; end

             __pond_create_operation $pond_name $pond_empty $pond_private
        case edit
            set -l pond_name $argv[-1]  # extract pond name from last argument
            set argv $argv[1..-2]       # remove pond name from argv

            if test -z "$pond_name"; or ! __pond_name_is_valid "$pond_name"; or test (count $argv) -ne 0
                __pond_edit_command_usage
                return 1
            end

            if ! __pond_exists $pond_name; __pond_show_not_exists_error $pond_name && return 1; end

            __pond_edit_operation $pond_name
        case remove
            set -l pond_name $argv[-1]  # extract pond name from last argument
            set argv $argv[1..-2]       # remove pond name from argv
            set -l pond_silent no

            if test -z "$pond_name"; or ! __pond_name_is_valid "$pond_name"
                __pond_remove_command_usage
                return 1
            end

            if test (count $argv) -gt 0
                if ! argparse 's/silent' >/dev/null 2>&1 -- $argv
                    __pond_remove_command_usage
                    return 1
                end
                if test (count $argv) -ne 0; __pond_remove_command_usage && return 1; end
                set -q _flag_silent; and set pond_silent yes
            end

            if ! __pond_exists $pond_name; __pond_show_not_exists_error $pond_name && return 1; end

            __pond_remove_operation $pond_name $pond_silent
        case list
            if test (count $argv) -gt 1; __pond_list_command_usage && return 1; end

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

            __pond_enable_operation $pond_name
        case disable
            set -l pond_name

            if test (count $argv) -eq 2;
                and string match -r '^([A-Za-z0-9]{1}[A-Za-z0-9-_]*)$' -q -- $argv[2];
              set pond_name $argv[2]
            else
                __pond_disable_command_usage && return 1
            end
            if ! __pond_exists $pond_name; __pond_show_not_exists_error $pond_name && return 1; end

            __pond_disable_operation $pond_name
        case load
            set -l pond_name

            if test (count $argv) -eq 2;
                and string match -r '^([A-Za-z0-9]{1}[A-Za-z0-9-_]*)$' -q -- $argv[2];
              set pond_name $argv[2]
            else
                __pond_load_command_usage && return 1
            end
            if ! __pond_exists $pond_name; __pond_show_not_exists_error $pond_name && return 1; end

            __pond_load_operation $pond_name
        case unload
            set -l pond_name
            set -l pond_command_option

            if test (count $argv) -eq 2;
                and string match -r '^([A-Za-z0-9]{1}[A-Za-z0-9-_]*)$' -q -- $argv[2];
              set pond_name $argv[2]
            else if test (count $argv) -eq 3;
                and string match -r '^(-v|--verbose)$' -q -- $argv[2];
                and string match -r '^([A-Za-z0-9]+[A-Za-z0-9-_]*)$' -q -- $argv[3]
              set pond_command_option $argv[2]
              set pond_name $argv[3]
            else
                __pond_unload_command_usage && return 1
            end
            if ! __pond_exists $pond_name; __pond_show_not_exists_error $pond_name && return 1; end

            switch $pond_command_option
                case -v --verbose
                    __pond_unload_operation $pond_name yes
                case '*'
                    __pond_unload_operation $pond_name no
            end
        case status
            set -l pond_name

            if test (count $argv) -eq 2;
                and string match -r '^([A-Za-z0-9]{1}[A-Za-z0-9-_]*)$' -q -- $argv[2];
              set pond_name $argv[2]
            else
                __pond_status_command_usage && return 1
            end
            if ! __pond_exists $pond_name; __pond_show_not_exists_error $pond_name && return 1; end

            __pond_status_operation $pond_name
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
                    __pond_drain_operation $pond_name yes
                case '*'
                    __pond_drain_operation $pond_name no
            end
        case '*'
            __pond_usage
            echo "Unknown command: $command" >&2 && return 1
    end
end
