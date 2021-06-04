function pond -a command -d "A fish shell environment manager"
    set -g pond_version 1.0.0

    function __pond_usage
        echo "\
Pond $pond_version

Usage:
    pond [options]
    pond <command> [command-options] ...

Help Options:
    -h, --help            Show this help message
    <command> -h, --help  Show command help

Application Options:
    -v, --version         Print the version string

Commands:
    create   Create a new pond
    init     Create/open pond init function
    deinit   Create/open pond deinit function
    remove   Remove a pond and associated data
    list     List ponds
    enable   Enable a pond for new shell sessions
    disable  Disable a pond for new shell sessions
    load     Load pond data into current shell session
    unload   Unload pond data from current shell session
    status   View pond status
    drain    Drain all data from pond
    dir      Change current working directory to pond
    config   Show configuration settings" >&2
        echo
    end

    function __pond_create_command_usage
        echo "\
Usage:
    pond create ponds...

Arguments:
    name  The name of one or more ponds to create; a pond name
          must begin with an alphanumeric character followed by
          any number of additional alphanumeric characters,
          underscores or dashes" >&2
        echo
    end

    function __pond_init_command_usage
        echo "\
Usage:
    pond init <name>

Arguments:
    name  The name of the pond for which an init function will
          be opened in an editor and optionally created if it
          does not already exist" >&2
        echo
    end

    function __pond_deinit_command_usage
        echo "\
Usage:
    pond deinit <name>

Arguments:
    name  The name of the pond for which a deinit function will
          be opened in an editor and optionally created if it
          does not already exist" >&2
        echo
    end

    function __pond_remove_command_usage
        echo "\
Usage:
    pond remove [options] ponds...

Options:
    -y, --yes  Automatically accept confirmation prompts

Arguments:
    ponds  The name of one or more ponds to remove" >&2
        echo
    end

    function __pond_list_command_usage
        echo "\
Usage:
    pond list [options]

Options:
    -e, --enabled   List enabled ponds
    -d, --disabled  List disabled ponds" >&2
        echo
    end

    function __pond_enable_command_usage
        echo "\
Usage:
    pond enable ponds...

Arguments:
    ponds  The name of one or more ponds to enable" >&2
        echo
    end

    function __pond_disable_command_usage
        echo "\
Usage:
    pond disable ponds...

Arguments:
    ponds  The name of one or more ponds to disable" >&2
        echo
    end

    function __pond_load_command_usage
        echo "\
Usage:
    pond load ponds...

Arguments:
    ponds  The name of one or more ponds to load" >&2
        echo
    end

    function __pond_unload_command_usage
        echo "\
Usage:
    pond unload ponds...

Arguments:
    ponds  The name of one or more ponds to unload" >&2
        echo
    end

    function __pond_status_command_usage
        echo "\
Usage:
    pond status [ponds...]

Arguments:
    name  The name of one or more ponds" >&2
        echo
    end

    function __pond_drain_command_usage
        echo "\
Usage:
    pond drain [options] ponds...

Options:
    -y, --yes  Automatically accept confirmation prompts

Arguments:
    ponds  The name of one or more ponds to drain" >&2
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

    function __pond_config_command_usage
        echo "\
Usage:
    pond config" >&2
        echo
    end

    function __pond_create_operation -a pond_name
        set -l pond_path $pond_home/$pond_name

        if test (mkdir -m 0755 -p $pond_path >/dev/null 2>&1) $status -ne 0
            echo "Failed to create pond directory: $pond_path" >&2; and return 1
        end

        if test "$pond_enable_on_create" = "yes"
            set -U -a pond_function_path $pond_path
        end

        if not contains $pond_path $fish_function_path
            set -a fish_function_path $pond_path
        end

        echo "Created empty pond: $pond_name"
        emit pond_created $pond_name $pond_path
    end

    function __pond_init_operation -a pond_name
        set -l pond_path $pond_home/$pond_name
        set -l pond_init_file $pond_path/{$pond_name}_{$pond_init_suffix}.fish

        if ! test -f $pond_init_file
            if test (echo -e "function "{$pond_name}_{$pond_init_suffix}"\n\nend" >> $pond_init_file) $status -ne 0
                echo "Unable to create init file: $pond_init_file" >&2; and return 1
            else
                echo "Created init file: $pond_init_file"
            end
        end

        if test -z "$__pond_under_test"
            and test (command -s $pond_editor >/dev/null 2>&1) $status -ne 0
            echo "Editor not found: $pond_editor" >&2; and return 1
        end

        $pond_editor $pond_init_file
    end

    function __pond_deinit_operation -a pond_name
        set -l pond_path $pond_home/$pond_name
        set -l pond_deinit_file $pond_path/{$pond_name}_{$pond_deinit_suffix}.fish

        if ! test -f $pond_deinit_file
            if test (echo -e "function "{$pond_name}_{$pond_deinit_suffix}"\n\nend" >> $pond_deinit_file) $status -ne 0
                echo "Unable to create deinit file: $pond_deinit_file" >&2; and return 1
            else
                echo "Created deinit file: $pond_deinit_file"
            end
        end

        if test -z "$__pond_under_test"
            and test (command -s $pond_editor >/dev/null 2>&1) $status -ne 0
            echo "Editor not found: $pond_editor" >&2; and return 1
        end

        $pond_editor $pond_deinit_file
    end

    function __pond_remove_operation -a pond_name
        set -l pond_path $pond_home/$pond_name

        if test "$pond_auto_accept" != "yes"
            read --prompt-str "Remove pond: $pond_name? " answer
            if ! string length -q $answer; or ! string match -i -r '^(y|yes)$' -q $answer
                return 0
            end
        end

        set -l pond_function_path_index (contains -i $pond_path $pond_function_path)
        if test -n "$pond_function_path_index"
            set -e pond_function_path[$pond_function_path_index]
        end

        set -l fish_function_path_index (contains -i $pond_path $fish_function_path)
        if test -n "$fish_function_path_index"
            set -e fish_function_path[$fish_function_path_index]
        end

        if test (rm -rf $pond_path >/dev/null 2>&1) $status -ne 0
            echo "Unable to remove pond: $pond_name" >&2; and return 1
        end

        echo "Removed pond: $pond_name"
        emit pond_removed $pond_name $pond_path
    end

    function __pond_list_operation -a pond_list_enabled pond_list_disabled
        set -l pond_names
        set -l pond_count 0

        if test "$pond_list_enabled" = "yes"; and test "$pond_list_disabled" = "yes"
            for pond_path in $pond_home/*
                echo (basename $pond_path)
                set pond_count (math $pond_count + 1)
            end
        else if test "$pond_list_enabled" = "yes"; and test "$pond_list_disabled" = "no"
            for pond_path in $pond_home/*
                if contains $pond_path $pond_function_path
                    echo (basename $pond_path)
                    set pond_count (math $pond_count + 1)
                end
            end
        else if test "$pond_list_enabled" = "no"; and test "$pond_list_disabled" = "yes"
            for pond_path in $pond_home/*
                if not contains $pond_path $pond_function_path
                    echo (basename $pond_path)
                    set pond_count (math $pond_count + 1)
                end
            end
        end

        if test $pond_count -eq 0
            echo "No matching ponds" >&2; and return 1
        end
    end

    function __pond_enable_operation -a pond_name
        set -l pond_path  $pond_home/$pond_name

        if contains $pond_path $pond_function_path
            echo "Pond already enabled: $pond_name" >&2; and return 1
        else
            set -U -a pond_function_path $pond_path

            if not contains $pond_path $fish_function_path
                set -a fish_function_path $pond_path
            end

            echo "Enabled pond: $pond_name"
            emit pond_enabled $pond_name $pond_path
        end
    end

    function __pond_disable_operation -a pond_name
        set -l pond_path $pond_home/$pond_name

        if not contains $pond_path $pond_function_path
            echo "Pond already disabled: $pond_name" >&2; and return 1
        else
            set -l pond_function_path_index (contains -i $pond_path $pond_function_path)
            if test -n "$pond_function_path_index"
                set -e pond_function_path[$pond_function_path_index]
            end

            set -l fish_function_path_index (contains -i $pond_path $fish_function_path)
            if test -n "$fish_function_path_index"
                set -e fish_function_path[$fish_function_path_index]
            end

            echo "Disabled pond: $pond_name"
            emit pond_disabled $pond_name $pond_path
        end
    end

    function __pond_load_operation -a pond_name
        set -l pond_path $pond_home/$pond_name
        set -l pond_init_function {$pond_name}_{$pond_init_suffix}

        if not contains $pond_path $fish_function_path
            set -a fish_function_path $pond_path
        end

        type -q $pond_init_function; and $pond_init_function

        echo "Loaded pond: $pond_name"
        emit pond_loaded $pond_name $pond_path
    end

    function __pond_unload_operation -a pond_name
        set -l pond_path $pond_home/$pond_name
        set -l pond_deinit_function {$pond_name}_{$pond_deinit_suffix}

        type -q $pond_deinit_function; and $pond_deinit_function

        set -l fish_function_path_index (contains -i $pond_path $fish_function_path)
        if test -n "$fish_function_path_index"
            set -e fish_function_path[$fish_function_path_index]
        end

        echo "Unloaded pond: $pond_name"
        emit pond_unloaded $pond_name $pond_path
    end

    function __pond_status_operation -a pond_name
        set -l pond_path $pond_home/$pond_name

        echo "name: $pond_name"
        echo "enabled: "(contains $pond_path $pond_function_path; and echo 'yes'; or echo 'no')
        echo "path: $pond_path"
    end

    function __pond_drain_operation -a pond_name
        set -l pond_path $pond_home/$pond_name

        if test "$pond_auto_accept" != "yes"
            read --prompt-str "Drain pond: $pond_name? " answer
            if ! string length -q $answer; or ! string match -i -r '^(y|yes)$' -q $answer
                return 0
            end
        end

        if test (rm -rf $pond_path/* >/dev/null 2>&1) $status -ne 0
            echo "Unable to drain pond: $pond_name" >&2; and return 1
        end

        echo "Drained pond: $pond_name"
        emit pond_drained $pond_name $pond_path
    end

    function __pond_dir_operation -a pond_name
        cd $pond_home/$pond_name
    end

    function __pond_config_operation
        echo "Pond home: $pond_home"
        echo "Enable ponds on creation: $pond_enable_on_create"
        echo "Pond editor command: $pond_editor"
    end

    function __pond_show_exists_error -a pond_name
        echo "Pond already exists: $pond_name" >&2
    end

    function __pond_show_not_exists_error -a pond_name
        echo "Pond does not exist: $pond_name" >&2
    end

    function __pond_exists -a pond_name
        if ! test -d $pond_home/$pond_name
            return 1
        end
    end

    function __pond_name_is_valid -a pond_name
        return (string match -r '^([A-Za-z0-9]{1}[A-Za-z0-9-_]*)$' -q -- $pond_name)
    end

    function __pond_cleanup
        functions -e __pond_cleanup

        for command in create remove list enable disable load unload status drain dir config
            functions -e "__pond_"(echo $command)"_command_usage"
            functions -e "__pond_"(echo $command)"_operation"
        end

        functions -e __pond_usage
        functions -e __pond_show_exists_error
        functions -e __pond_show_not_exists_error
        functions -e __pond_exists
        functions -e __pond_name_is_valid
        set -e pond_auto_accept
        set -e pond_version
    end

    if isatty
        set -g pond_auto_accept no
    else
        read --local --null --array stdin; and set --append argv $stdin
        set command $argv[1]
        set -g pond_auto_accept yes
    end

    set argv $argv[2..-1]

    switch $command
        case -v --version
            if test (count $argv) -ne 0; __pond_usage; and __pond_cleanup; and return 1; end
            echo "pond $pond_version"
        case '' -h --help
            __pond_usage
        case create
            if test (count $argv) -eq 0; __pond_create_command_usage; and __pond_cleanup; and return 1; end

            for pond_name in $argv
                if ! __pond_name_is_valid "$pond_name"
                    __pond_create_command_usage
                    __pond_cleanup
                    return 1
                else if __pond_exists $pond_name
                    __pond_show_exists_error $pond_name
                    __pond_cleanup
                    return 1
                end

                __pond_create_operation $pond_name
                set -l exit_code $status
                if test $exit_code -gt 0
                    __pond_cleanup; and return $exit_code
                end
            end
        case remove
            if ! argparse 'y/yes' >/dev/null 2>&1 -- $argv
                __pond_remove_command_usage
                __pond_cleanup; and return 1
            end

            set -q _flag_yes; and set pond_auto_accept yes

            if test (count $argv) -eq 0; __pond_remove_command_usage; and __pond_cleanup; and return 1; end

            for pond_name in $argv
                if ! __pond_name_is_valid "$pond_name"
                    __pond_remove_command_usage
                    __pond_cleanup
                    return 1
                else if ! __pond_exists $pond_name
                    __pond_show_not_exists_error $pond_name
                    __pond_cleanup
                    return 1
                end

                __pond_remove_operation $pond_name
                set -l exit_code $status
                if test $exit_code -gt 0
                    __pond_cleanup; and return $exit_code
                end
            end
        case list
            set -l pond_list_enabled yes
            set -l pond_list_disabled yes

            if test (count $argv) -gt 0
                if ! argparse 'e/enabled' 'd/disabled' >/dev/null 2>&1 -- $argv
                    __pond_list_command_usage
                    __pond_cleanup; and return 1
                end

                if test (count $argv) -ne 0; __pond_list_command_usage; and __pond_cleanup; and return 1; end

                if set -q _flag_enabled; or set -q _flag_disabled
                    set -q _flag_enabled; and set pond_list_enabled yes; or set pond_list_enabled no
                    set -q _flag_disabled; and set pond_list_disabled yes; or set pond_list_disabled no
                end
            end

            __pond_list_operation $pond_list_enabled $pond_list_disabled
            set -l exit_code $status
            __pond_cleanup; and return $exit_code
        case enable
            if test (count $argv) -eq 0; __pond_enable_command_usage; and __pond_cleanup; and return 1; end

            for pond_name in $argv
                if ! __pond_name_is_valid "$pond_name"
                    __pond_enable_command_usage
                    __pond_cleanup
                    return 1
                else if ! __pond_exists $pond_name
                    __pond_show_not_exists_error $pond_name
                    __pond_cleanup
                    return 1
                end

                __pond_enable_operation $pond_name
                set -l exit_code $status
                if test $exit_code -gt 0
                    __pond_cleanup; and return $exit_code
                end
            end
        case disable
            if test (count $argv) -eq 0; __pond_disable_command_usage; and __pond_cleanup; and return 1; end

            for pond_name in $argv
                if ! __pond_name_is_valid "$pond_name"
                    __pond_disable_command_usage
                    __pond_cleanup
                    return 1
                else if ! __pond_exists $pond_name
                    __pond_show_not_exists_error $pond_name
                    __pond_cleanup
                    return 1
                end

                __pond_disable_operation $pond_name
                set -l exit_code $status
                if test $exit_code -gt 0
                    __pond_cleanup; and return $exit_code
                end
            end

        case load
            if test (count $argv) -eq 0; __pond_load_command_usage; and __pond_cleanup; and return 1; end

            for pond_name in $argv
                if ! __pond_name_is_valid "$pond_name"
                    __pond_load_command_usage
                    __pond_cleanup
                    return 1
                else if ! __pond_exists $pond_name
                    __pond_show_not_exists_error $pond_name
                    __pond_cleanup
                    return 1
                end

                __pond_load_operation $pond_name
                set -l exit_code $status
                if test $exit_code -gt 0
                    __pond_cleanup; and return $exit_code
                end
            end
        case unload
            if test (count $argv) -eq 0; __pond_unload_command_usage; and __pond_cleanup; and return 1; end

            for pond_name in $argv
                if ! __pond_name_is_valid "$pond_name"
                    __pond_unload_command_usage
                    __pond_cleanup
                    return 1
                else if ! __pond_exists $pond_name
                    __pond_show_not_exists_error $pond_name
                    __pond_cleanup
                    return 1
                end

                __pond_unload_operation $pond_name
                set -l exit_code $status
                if test $exit_code -gt 0
                    __pond_cleanup; and return $exit_code
                end
            end
        case status
            if test (count $argv) -eq 0
                set -l pond_count (count $pond_home/*/)
                set -l pond_enabled_count (count (string match -r "$pond_home/.*" -- $pond_function_path))

                echo "$pond_count "(test $pond_count -eq 1; and echo "pond"; or echo "ponds")", $pond_enabled_count enabled"
                __pond_cleanup
                return 0
            end

            for pond_name in $argv
                if ! __pond_name_is_valid "$pond_name"
                    __pond_status_command_usage
                    __pond_cleanup
                    return 1
                else if ! __pond_exists $pond_name
                    __pond_show_not_exists_error $pond_name
                    __pond_cleanup
                    return 1
                end

                __pond_status_operation $pond_name
                set -l exit_code $status
                if test $exit_code -gt 0
                    __pond_cleanup; and return $exit_code
                end
            end
        case drain
            if ! argparse 'y/yes' >/dev/null 2>&1 -- $argv
                __pond_drain_command_usage
                __pond_cleanup; and return 1
            end

            set -q _flag_yes; and set pond_auto_accept yes

            if test (count $argv) -eq 0; __pond_drain_command_usage; and __pond_cleanup; and return 1; end

            for pond_name in $argv
                if ! __pond_name_is_valid "$pond_name"
                    __pond_drain_command_usage
                    __pond_cleanup
                    return 1
                else if ! __pond_exists $pond_name
                    __pond_show_not_exists_error $pond_name
                    __pond_cleanup
                    return 1
                end

                __pond_drain_operation $pond_name
                set -l exit_code $status
                if test $exit_code -gt 0
                    __pond_cleanup; and return $exit_code
                end
            end
        case init
            set -l pond_name $argv[-1]
            set argv $argv[1..-2]

            if test -z "$pond_name"; or ! __pond_name_is_valid "$pond_name"
                __pond_init_command_usage
                __pond_cleanup; and return 1
            end

            if test -z "$pond_name"; or ! __pond_name_is_valid "$pond_name"; or test (count $argv) -ne 0
                __pond_init_command_usage; and __pond_cleanup; and return 1
            else if ! __pond_exists $pond_name
                __pond_show_not_exists_error $pond_name; and __pond_cleanup; and return 1
            end

            __pond_init_operation $pond_name
            set -l exit_code $status
            __pond_cleanup; and return $exit_code
        case deinit
            set -l pond_name $argv[-1]
            set argv $argv[1..-2]

            if test -z "$pond_name"; or ! __pond_name_is_valid "$pond_name"
                __pond_deinit_command_usage
                __pond_cleanup; and return 1
            end

            if test -z "$pond_name"; or ! __pond_name_is_valid "$pond_name"; or test (count $argv) -ne 0
                __pond_deinit_command_usage; and __pond_cleanup; and return 1
            else if ! __pond_exists $pond_name
                __pond_show_not_exists_error $pond_name; and __pond_cleanup; and return 1
            end

            __pond_deinit_operation $pond_name
            set -l exit_code $status
            __pond_cleanup; and return $exit_code
        case dir
            set -l pond_name $argv[-1]
            set argv $argv[1..-2]

            if test -z "$pond_name"; or ! __pond_name_is_valid "$pond_name"; or test (count $argv) -ne 0
                __pond_dir_command_usage; and __pond_cleanup; and return 1
            else if ! __pond_exists $pond_name
                __pond_show_not_exists_error $pond_name; and __pond_cleanup; and return 1
            end

            __pond_dir_operation $pond_name
            set -l exit_code $status
            __pond_cleanup; and return $exit_code
        case config
            if test (count $argv) -ne 0; __pond_config_command_usage; and __pond_cleanup; and return 1; end

            __pond_config_operation
            set -l exit_code $status
            __pond_cleanup; and return $exit_code
        case '*'
            __pond_usage
            echo "Unknown command: $command" >&2; and __pond_cleanup; and return 1
    end

    __pond_cleanup
end
