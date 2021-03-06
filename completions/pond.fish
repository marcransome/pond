set -l commands_without_options edit enable disable load status dir config
set -l commands_with_options create remove drain unload list
set -l commands "$commands_without_options $commands_with_options"

# Disable file completion as no subcommand requires a file path
complete -c pond -f

# Complete commands if no subcommand has been given so far
complete -c pond -n "not __fish_seen_subcommand_from $commands" -a 'create' -d 'Create a new pond'
complete -c pond -n "not __fish_seen_subcommand_from $commands" -a 'remove' -d 'Remove a pond and associated data'
complete -c pond -n "not __fish_seen_subcommand_from $commands" -a 'list' -d 'List all ponds'
complete -c pond -n "not __fish_seen_subcommand_from $commands" -a 'edit' -d 'Edit an existing pond'
complete -c pond -n "not __fish_seen_subcommand_from $commands" -a 'enable' -d 'Enable a pond for new shell sessions'
complete -c pond -n "not __fish_seen_subcommand_from $commands" -a 'disable' -d 'Disable a pond for new shell sessions'
complete -c pond -n "not __fish_seen_subcommand_from $commands" -a 'load' -d 'Load pond data into current shell session'
complete -c pond -n "not __fish_seen_subcommand_from $commands" -a 'unload' -d 'Unload pond data from current shell session'
complete -c pond -n "not __fish_seen_subcommand_from $commands" -a 'status' -d 'View pond status'
complete -c pond -n "not __fish_seen_subcommand_from $commands" -a 'drain' -d 'Drain all data from pond'
complete -c pond -n "not __fish_seen_subcommand_from $commands" -a 'dir' -d 'Change current working directory to pond'
complete -c pond -n "not __fish_seen_subcommand_from $commands" -a 'config' -d 'Show configuration settings'

# Complete options for list command
complete -c pond -n "__fish_seen_subcommand_from list; and not __fish_seen_subcommand_from -p --private" -a "-p --private" -d "List private ponds"
complete -c pond -n "__fish_seen_subcommand_from list; and not __fish_seen_subcommand_from -r --regular" -a "-r --regular" -d "List regular ponds"
complete -c pond -n "__fish_seen_subcommand_from list; and not __fish_seen_subcommand_from -e --enabled" -a "-e --enabled" -d "List enabled ponds"
complete -c pond -n "__fish_seen_subcommand_from list; and not __fish_seen_subcommand_from -d --disabled" -a "-d --disabled" -d "List disabled ponds"

# Complete pond name for commands that do not support options
complete -c pond -n "__fish_seen_subcommand_from $commands_without_options; and not __fish_seen_subcommand_from list; and not __fish_seen_subcommand_from (pond list 2>/dev/null)" -a "(pond list 2>/dev/null)"

# Complete options for create command
complete -c pond -n "__fish_seen_subcommand_from create; and not __fish_seen_subcommand_from -e --empty" -a "-e --empty" -d "Create pond without opening editor"
complete -c pond -n "__fish_seen_subcommand_from create; and not __fish_seen_subcommand_from -p --private" -a "-p --private" -d "Create private pond"

# Complete options or pond name for remove command
complete -c pond -n "__fish_seen_subcommand_from remove; and not __fish_seen_subcommand_from -s --silent" -a "-s --silent" -d "Silence confirmation prompt"
complete -c pond -n "__fish_seen_subcommand_from remove; and not __fish_seen_subcommand_from (pond list 2>/dev/null)" -a "(pond list 2>/dev/null)"
complete -c pond -n "__fish_seen_subcommand_from remove; and __fish_seen_subcommand_from -s --silent" -a "(pond list 2>/dev/null)"

# Complete options or pond name for drain command
complete -c pond -n "__fish_seen_subcommand_from drain; and not __fish_seen_subcommand_from -s --silent" -a "-s --silent" -d "Silence confirmation prompt"
complete -c pond -n "__fish_seen_subcommand_from drain; and not __fish_seen_subcommand_from (pond list 2>/dev/null)" -a "(pond list 2>/dev/null)"
complete -c pond -n "__fish_seen_subcommand_from drain; and __fish_seen_subcommand_from -s --silent" -a "(pond list 2>/dev/null)"

# Complete options or pond name for unload command
complete -c pond -n "__fish_seen_subcommand_from unload; and not __fish_seen_subcommand_from -v --verbose" -a "-v --verbose" -d "Output variable names during unload"
complete -c pond -n "__fish_seen_subcommand_from unload; and not __fish_seen_subcommand_from (pond list 2>/dev/null)" -a "(pond list 2>/dev/null)"
complete -c pond -n "__fish_seen_subcommand_from unload; and __fish_seen_subcommand_from -v --verbose" -a "(pond list 2>/dev/null)"

# Complete long and short options
complete -c pond -n "not __fish_seen_subcommand_from $commands" -s h -l help -d 'Print a short help text and exit'
complete -c pond -n "not __fish_seen_subcommand_from $commands" -s v -l version -d 'Print a short version string and exit'
