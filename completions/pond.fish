set -l commands_without_options edit enable disable load unload status
set -l commands_with_options create remove
set -l commands "$commands_without_options $commands_with_options"

# Disable file completion as no subcommand requires a file path
complete -c pond -f

# Complete commands if no subcommand has been given so far
complete -c pond -n "not __fish_seen_subcommand_from $commands" -a 'create' -d 'Create a new pond'
complete -c pond -n "not __fish_seen_subcommand_from $commands" -a 'remove' -d 'Remove a pond and associated data'
complete -c pond -n "not __fish_seen_subcommand_from $commands" -a 'edit' -d 'Edit an existing pond'
complete -c pond -n "not __fish_seen_subcommand_from $commands" -a 'enable' -d 'Enable a pond for new shell sessions'
complete -c pond -n "not __fish_seen_subcommand_from $commands" -a 'disable' -d 'Disable a pond for new shell sessions'
complete -c pond -n "not __fish_seen_subcommand_from $commands" -a 'load' -d 'Load pond data into current shell session'
complete -c pond -n "not __fish_seen_subcommand_from $commands" -a 'unload' -d 'Unload pond data into from current shell session'
complete -c pond -n "not __fish_seen_subcommand_from $commands" -a 'status' -d 'View pond status'

# Complete option or pond name for create command
complete -c pond -n "__fish_seen_subcommand_from create; and not __fish_seen_subcommand_from -e --empty" -a "-e --empty" -d "Create pond without opening editor"
complete -c pond -n "__fish_seen_subcommand_from create; and not __fish_seen_subcommand_from (pond list 2>/dev/null)" -a "(pond list 2>/dev/null)"
complete -c pond -n "__fish_seen_subcommand_from create; and __fish_seen_subcommand_from -e --empty" -a "(pond list 2>/dev/null)"

# Complete option or pond name for remove command
complete -c pond -n "__fish_seen_subcommand_from remove; and not __fish_seen_subcommand_from -s --silent" -a "-s --silent" -d "Remove a pond and associated data"
complete -c pond -n "__fish_seen_subcommand_from remove; and not __fish_seen_subcommand_from (pond list 2>/dev/null)" -a "(pond list 2>/dev/null)"
complete -c pond -n "__fish_seen_subcommand_from remove; and __fish_seen_subcommand_from -s --silent" -a "(pond list 2>/dev/null)"

# Complete long and short options
complete -c pond -s h -l help -d 'Print a short help text and exit'
complete -c pond -s v -l version -d 'Print a short version string and exit'
