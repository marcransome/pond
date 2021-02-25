function pond -a command -d "A fish shell environment manager"
    set -l pond_version 0.5.2

    function __pond_usage
        echo "\
Usage:
    pond [options]
    pond <command> [command-options] ...

Help Options:
    -h, --help            Show this help message
    <command> -h, --help  Show command help

Application Options:
    -v, --version           Print the version string

Commands:
    create   Create a new pond
    remove   Remove a pond and associated data
    list     List all ponds
    edit     Edit an existing pond
    enable   Enable a pond for new shell sessions
    disable  Disable a pond for new shell sessions
    load     Load pond data into current shell session
    unload   Unload pond data from current shell session
    status   View pond status
    drain    Drain all data from pond
    dir      Change current working directory to pond" >&2
        echo
    end

    function __pond_create_command_usage
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
        echo "\
Usage:
    pond list" >&2
        echo
    end

    function __pond_edit_command_usage
        echo "\
Usage:
    pond edit <name>

Arguments:
    name  The name of the pond to edit" >&2
        echo
    end

    function __pond_enable_command_usage
        echo "\
Usage:
    pond enable <name>

Arguments:
    name  The name of the pond to enable" >&2
        echo
    end

    function __pond_disable_command_usage
        echo "\
Usage:
    pond disable <name>

Arguments:
    name  The name of the pond to disable" >&2
        echo
    end

    function __pond_load_command_usage
        echo "\
Usage:
    pond load <name>

Arguments:
    name  The name of the pond to load" >&2
        echo
    end

    function __pond_unload_command_usage
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
        echo "\
Usage:
    pond status <name>

Arguments:
    name  The name of the pond" >&2
        echo
    end

    function __pond_drain_command_usage
        echo "\
Usage:
    pond drain [options] <name>

Options:
    -s, --silent  Silence confirmation prompt

Arguments:
    name  The name of the pond to drain" >&2
        echo
    end

    function __pond_dir_command_usage
        echo "\
Usage:
    pond dir <name>

Arguments:
    name  The name of the pond to change directory to" >&2
        echo
    end

    function __pond_create_operation -a pond_name private
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

        if test "$pond_empty" != "yes"
            $pond_editor $pond_home/$pond_parent/$pond_name/$pond_vars
        end

        echo "Created "(__pond_is_private $pond_name; and echo "private pond"; or echo "pond")": $pond_name"
        emit pond_created $pond_name $pond_home/$pond_parent/$pond_name
    end

    function __pond_edit_operation -a pond_name
        set -l pond_parent $pond_regular
        if __pond_is_private $pond_name; set pond_parent $pond_private; end

        if test -z "$__pond_under_test"
            and test (command -s $pond_editor >/dev/null 2>&1) $status -ne 0
            echo "Editor not found: $pond_editor" >&2 && return 1
        end

        if isatty; or test -n "$__pond_under_test"
            $pond_editor $pond_home/$pond_parent/$pond_name/$pond_vars
        else
            return 1
        end
    end

    function __pond_remove_operation -a pond_name
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

        if test "$pond_silent" != "yes"
            read --prompt-str "$pond_remove_prompt: $pond_name? " answer
            if ! string length -q $answer; or ! string match -i -r '^(y|yes)$' -q $answer
                return 0
            end
        end

        if test -L $pond_home/$pond_links/$pond_name
            if test (unlink $pond_home/$pond_links/$pond_name >/dev/null 2>&1) $status -ne 0
                echo "Failed to remove symbolic link: $pond_home/$pond_links/$pond_name" >&2 && return 1
            end
        end

        if test (rm -rf $pond_home/$pond_parent/$pond_name >/dev/null 2>&1) $status -ne 0
            echo "$pond_remove_failure: $pond_name" >&2 && return 1
        end

        echo "$pond_remove_success: $pond_name"
        emit pond_removed $pond_name $pond_home/$pond_parent/$pond_name
    end

    function __pond_list_operation
        set -l pond_paths $pond_home/{$pond_regular,$pond_private}/*/

        if test (count $pond_paths) -eq 0
            echo "No ponds found" >&2 && return 1
        else
            for pond_path in $pond_paths; echo (basename $pond_path); end
        end
    end

    function __pond_enable_operation -a pond_name
        set -l pond_parent (__pond_is_private $pond_name; and echo $pond_private; or echo $pond_regular)

        if test -L $pond_home/$pond_links/$pond_name;
            echo "Pond already enabled: $pond_name" >&2 && return 1
        else
            ln -s $pond_home/$pond_parent/$pond_name $pond_home/$pond_links/$pond_name >/dev/null 2>&1
            if test $status -ne 0
                echo "Failed to create symbolic link: $pond_home/$pond_links/$pond_name" >&2 && return 1
            end

            echo "Enabled "(__pond_is_private $pond_name; and echo "private pond"; or echo "pond")": $pond_name"
            emit pond_enabled $pond_name $pond_home/$pond_parent/$pond_name
        end
    end

    function __pond_disable_operation -a pond_name
        set -l pond_parent (__pond_is_private $pond_name; and echo $pond_private; or echo $pond_regular)

        if ! test -L $pond_home/$pond_links/$pond_name
            echo "Pond already disabled: $pond_name" >&2 && return 1
        else
            unlink $pond_home/$pond_links/$pond_name >/dev/null 2>&1
            if test $status -ne 0
                echo "Failed to remove symbolic link: $pond_home/$pond_links/$pond_name" >&2 && return 1
            end

            echo "Disabled "(__pond_is_private $pond_name; and echo "private pond"; or echo "pond")": $pond_name"
            emit pond_disabled $pond_name $pond_home/$pond_parent/$pond_name
        end
    end

    function __pond_load_operation -a pond_name
        set -l pond_parent (__pond_is_private $pond_name; and echo $pond_private; or echo $pond_regular)

        source $pond_home/$pond_parent/$pond_name/$pond_vars
        if test $status -ne 0
            echo "Failed to source file: $pond_home/$pond_parent/$pond_name/$pond_vars" >&2 && return 1
        end

        echo "Loaded "(__pond_is_private $pond_name; and echo "private pond"; or echo "pond")": $pond_name"
        emit pond_loaded $pond_name $pond_home/$pond_parent/$pond_name
    end

    function __pond_unload_operation -a pond_name verbose
        set -l pond_parent (__pond_is_private $pond_name; and echo $pond_private; or echo $pond_regular)

        while read -la line
            if test -z "$line"; or string match -r '^\s*#' "$line" -q
                continue
            end

            set tokens (string match -r '\s*set\s+(?:-{1,2}[A-Za-z]+\s+)*([A-Za-z0-9_]+)\s+' -- "$line")

            if test (set -e $tokens[2] >/dev/null 2>&1) $status -eq 0
                if test "$verbose" = "yes"; echo "Erased variable: $tokens[2]"; end
            else
                echo "Failed to erase variable: $tokens[2]"
            end
        end < $pond_home/$pond_parent/$pond_name/$pond_vars

        echo "Unloaded "(__pond_is_private $pond_name; and echo "private pond"; or echo "pond")": $pond_name"
        emit pond_unloaded $pond_name $pond_home/$pond_parent/$pond_name
    end

    function __pond_status_operation -a pond_name
        echo "name: $pond_name"
        echo "enabled: "(test -L $pond_home/$pond_links/$pond_name; and echo 'yes'; or echo 'no')
        echo "private: "(__pond_is_private $pond_name; and echo 'yes'; or echo 'no')
        echo "path: $pond_home/"(__pond_is_private $pond_name; and echo $pond_private; or echo $pond_regular)/"$pond_name"
    end

    function __pond_drain_operation -a pond_name
        set -l answer
        set -l pond_parent $pond_regular
        set -l pond_drain_prompt 'Drain pond'
        set -l pond_drain_success 'Drained pond'
        set -l pond_drain_failure 'Unable to drain pond'

        if __pond_is_private $pond_name
            set pond_parent $pond_private
            set pond_drain_prompt 'Drain private pond'
            set pond_drain_success 'Drained private pond'
            set pond_drain_failure 'Unable to drain private pond'
        end

        if test "$pond_silent" != "yes"
            read --prompt-str "$pond_drain_prompt: $pond_name? " answer
            if ! string length -q $answer; or ! string match -i -r '^(y|yes)$' -q $answer
                return 0
            end
        end

        echo > $pond_home/$pond_parent/$pond_name/$pond_vars
        echo "$pond_drain_success: $pond_name"
        emit pond_drained $pond_name $pond_home/$pond_parent/$pond_name
    end

    function __pond_dir_operation -a pond_name
        set -l pond_parent (__pond_is_private $pond_name; and echo $pond_private; or echo $pond_regular)
        cd $pond_home/$pond_parent/$pond_name
    end

    function __pond_show_exists_error -a pond_name
        echo "Pond already exists: $pond_name" >&2
    end

    function __pond_show_not_exists_error -a pond_name
        echo "Pond does not exist: $pond_name" >&2
    end

    function __pond_show_name_missing_error
        echo "No pond name specified" >&2
    end

    function __pond_is_private -a pond_name
        return (test -d $pond_home/$pond_private/$pond_name >/dev/null 2>&1) $status
    end

    function __pond_exists -a pond_name
        if ! test -d $pond_home/$pond_regular/$pond_name; and ! test -d $pond_home/$pond_private/$pond_name
            return 1
        end
    end

    function __pond_name_is_valid -a pond_name
        return (string match -r '^([A-Za-z0-9]{1}[A-Za-z0-9-_]*)$' -q -- $pond_name)
    end

    function __pond_cleanup
        functions -e __pond_cleanup

        for command in create remove list edit enable disable load unload status drain dir
            functions -e "__pond_"(echo $command)"_command_usage"
            functions -e "__pond_"(echo $command)"_operation"
        end

        functions -e __pond_usage
        functions -e __pond_show_exists_error
        functions -e __pond_show_not_exists_error
        functions -e __pond_show_name_missing_error
        functions -e __pond_is_private
        functions -e __pond_exists
        functions -e __pond_name_is_valid
        set -e pond_silent
        set -e pond_empty
    end

    if isatty
        set -g pond_silent no
        set -g pond_empty no
    else
        read --local --null --array stdin && set --append argv $stdin
        set command $argv[1]
        set -g pond_silent yes
        set -g pond_empty yes
    end

    set argv $argv[2..-1]

    switch $command
        case -v --version
            if test (count $argv) -ne 0; __pond_usage && __pond_cleanup && return 1; end
            echo "pond $pond_version"
        case '' -h --help
            __pond_usage
        case create
            set -l pond_name $argv[-1]
            set argv $argv[1..-2]
            set -l pond_private no

            if test -z "$pond_name"; or ! __pond_name_is_valid "$pond_name"
                __pond_create_command_usage
                __pond_cleanup && return 1
            end

            if test (count $argv) -gt 0
                if ! argparse 'e/empty' 'p/private' >/dev/null 2>&1 -- $argv
                    __pond_create_command_usage
                    __pond_cleanup && return 1
                end
                if test (count $argv) -ne 0; __pond_create_command_usage && __pond_cleanup && return 1; end
                set -q _flag_empty; and set pond_empty yes
                set -q _flag_private; and set pond_private yes
            end

            if __pond_exists $pond_name; __pond_show_exists_error $pond_name && __pond_cleanup && return 1; end

            __pond_create_operation $pond_name $pond_private
            set -l exit_code $status
            __pond_cleanup && return $exit_code
        case edit
            set -l pond_name $argv[-1]
            set argv $argv[1..-2]

            if test -z "$pond_name"; or ! __pond_name_is_valid "$pond_name"; or test (count $argv) -ne 0
                __pond_edit_command_usage && __pond_cleanup && return 1
            else if ! __pond_exists $pond_name
                __pond_show_not_exists_error $pond_name && __pond_cleanup && return 1
            end

            __pond_edit_operation $pond_name
            set -l exit_code $status
            __pond_cleanup && return $exit_code
        case remove
            set -l pond_name $argv[-1]
            set argv $argv[1..-2]

            if test -z "$pond_name"; or ! __pond_name_is_valid "$pond_name"
                __pond_remove_command_usage
                __pond_cleanup && return 1
            end

            if test (count $argv) -gt 0
                if ! argparse 's/silent' >/dev/null 2>&1 -- $argv
                    __pond_remove_command_usage
                    __pond_cleanup && return 1
                end
                if test (count $argv) -ne 0; __pond_remove_command_usage && __pond_cleanup && return 1; end
                set -q _flag_silent; and set pond_silent yes
            end

            if ! __pond_exists $pond_name; __pond_show_not_exists_error $pond_name && __pond_cleanup && return 1; end

            __pond_remove_operation $pond_name
            set -l exit_code $status
            __pond_cleanup && return $exit_code
        case list
            if test (count $argv) -ne 0; __pond_list_command_usage && __pond_cleanup && return 1; end

            __pond_list_operation
            set -l exit_code $status
            __pond_cleanup && return $exit_code
        case enable
            set -l pond_name $argv[-1]
            set argv $argv[1..-2]

            if test -z "$pond_name"; or ! __pond_name_is_valid "$pond_name"; or test (count $argv) -ne 0
                __pond_enable_command_usage && __pond_cleanup && return 1
            else if ! __pond_exists $pond_name
                __pond_show_not_exists_error $pond_name && __pond_cleanup && return 1
            end

            __pond_enable_operation $pond_name
            set -l exit_code $status
            __pond_cleanup && return $exit_code
        case disable
            set -l pond_name $argv[-1]
            set argv $argv[1..-2]

            if test -z "$pond_name"; or ! __pond_name_is_valid "$pond_name"; or test (count $argv) -ne 0
                __pond_disable_command_usage && __pond_cleanup && return 1
            else if ! __pond_exists $pond_name
                __pond_show_not_exists_error $pond_name && __pond_cleanup && return 1
            end

            __pond_disable_operation $pond_name
            set -l exit_code $status
            __pond_cleanup && return $exit_code
        case load
            set -l pond_name $argv[-1]
            set argv $argv[1..-2]

            if test -z "$pond_name"; or ! __pond_name_is_valid "$pond_name"; or test (count $argv) -ne 0
                __pond_load_command_usage && __pond_cleanup && return 1
            else if ! __pond_exists $pond_name
                __pond_show_not_exists_error $pond_name && __pond_cleanup && return 1
            end

            __pond_load_operation $pond_name
            set -l exit_code $status
            __pond_cleanup && return $exit_code
        case unload
            set -l pond_name $argv[-1]
            set argv $argv[1..-2]
            set -l pond_verbose no

            if test -z "$pond_name"; or ! __pond_name_is_valid "$pond_name"
                __pond_unload_command_usage
                __pond_cleanup && return 1
            end

            if test (count $argv) -gt 0
                if ! argparse 'v/verbose' >/dev/null 2>&1 -- $argv
                    __pond_unload_command_usage
                    __pond_cleanup && return 1
                end
                if test (count $argv) -ne 0; __pond_unload_command_usage && __pond_cleanup && return 1; end
                set -q _flag_verbose; and set pond_verbose yes
            end

            if ! __pond_exists $pond_name; __pond_show_not_exists_error $pond_name && __pond_cleanup && return 1; end

            __pond_unload_operation $pond_name $pond_verbose
            set -l exit_code $status
            __pond_cleanup && return $exit_code
        case status
            set -l pond_name $argv[-1]
            set argv $argv[1..-2]

            if test -z "$pond_name"; or ! __pond_name_is_valid "$pond_name"; or test (count $argv) -ne 0
                __pond_status_command_usage && __pond_cleanup && return 1
            else if ! __pond_exists $pond_name
                __pond_show_not_exists_error $pond_name && __pond_cleanup && return 1
            end

            __pond_status_operation $pond_name
            set -l exit_code $status
            __pond_cleanup && return $exit_code
        case drain
            set -l pond_name $argv[-1]
            set argv $argv[1..-2]

            if test -z "$pond_name"; or ! __pond_name_is_valid "$pond_name"
                __pond_drain_command_usage
                __pond_cleanup && return 1
            end

            if test (count $argv) -gt 0
                if ! argparse 's/silent' >/dev/null 2>&1 -- $argv
                    __pond_drain_command_usage
                    __pond_cleanup && return 1
                end
                if test (count $argv) -ne 0; __pond_drain_command_usage && __pond_cleanup && return 1; end
                set -q _flag_silent; and set pond_silent yes
            end

            if ! __pond_exists $pond_name; __pond_show_not_exists_error $pond_name && __pond_cleanup && return 1; end

            __pond_drain_operation $pond_name
            set -l exit_code $status
            __pond_cleanup && return $exit_code
        case dir
            set -l pond_name $argv[-1]
            set argv $argv[1..-2]

            if test -z "$pond_name"; or ! __pond_name_is_valid "$pond_name"
                __pond_dir_command_usage
                __pond_cleanup && return 1
            end

            if ! __pond_exists $pond_name; __pond_show_not_exists_error $pond_name && __pond_cleanup && return 1; end

            __pond_dir_operation $pond_name
            set -l exit_code $status
            __pond_cleanup && return $exit_code
        case '*'
            __pond_usage
            echo "Unknown command: $command" >&2 && __pond_cleanup && return 1
    end

    __pond_cleanup
end
