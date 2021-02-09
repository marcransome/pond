set -l commands new create ls list rm remove var variable get set

# Disable file completion as no subcommand requires a file path
complete -c pond -f

# Complete subcommands if no subcommand has been given so far
complete -c pond -n "not __fish_seen_subcommand_from $commands" -a "new create ls list rm remove var variable"

# If the 'rm' or 'remove' subcommands are used, offer output of
# `pond list` as completions
complete -c pond -n "__fish_seen_subcommand_from rm remove" -a "(pond list 2>/dev/null || echo)"

# If the 'var' or 'variable' subcommands are used, offer these completions
complete -c pond -n "__fish_seen_subcommand_from var variable" -a "get set ls list rm remove"

# Complete long and short option flags with descriptions
complete -c pond -s h -l help -d 'Print a short help text and exit'
complete -c pond -l version -d 'Print a short version string and exit'
