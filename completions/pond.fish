set -l commands new create ls list rm remove enable disable status load unload var variable get set

# Disable file completion as no subcommand requires a file path
complete -c pond -f

# Complete subcommands if no subcommand has been given so far
complete -c pond -n "not __fish_seen_subcommand_from $commands" -a "new create ls list rm remove enable disable status load unload var variable"

# Offer output of `pond list` as completions for commands that accept a pond name ingoring any 'var' or 'variable' subcommands
complete -c pond -n "__fish_seen_subcommand_from rm remove enable disable status load unload; and not __fish_seen_subcommand_from var variable" -a "(pond list 2>/dev/null || echo)"

# If the 'var' or 'variable' subcommands are used without an operation, offer operation completions
complete -c pond -n "__fish_seen_subcommand_from var variable; and not __fish_seen_subcommand_from get set ls list rm remove" -a "get set ls list rm remove"

# If the 'var' or 'variable' subcommands are used with an operation but without a pond name offer pond name completions
complete -c pond -n "__fish_seen_subcommand_from var variable; and __fish_seen_subcommand_from get set ls list rm remove; and not __fish_seen_subcommand_from (pond list 2>/dev/null || echo)" -a "(pond list 2>/dev/null || echo)"

# If the 'var' or 'variable' subcommands are used with an operation and a pond name do not offer variable name completion
complete -c pond -n "__fish_seen_subcommand_from var variable; and __fish_seen_subcommand_from get set ls list rm remove; and __fish_seen_subcommand_from (pond list 2>/dev/null || echo)" -a ""

# Complete long and short option flags with descriptions
complete -c pond -s h -l help -d 'Print a short help text and exit'
complete -c pond -l version -d 'Print a short version string and exit'
