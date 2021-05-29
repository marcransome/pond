<img alt="pond" src="images/fish-pond.png" width="180" align="left">

# Pond

[![Tests Status](https://github.com/marcransome/pond/actions/workflows/build.yml/badge.svg)](https://github.com/marcransome/pond/actions?query=workflow%3Atests) [![License](https://img.shields.io/badge/license-MIT-blue)](http://opensource.org/licenses/mit-license.php) [![fish](https://img.shields.io/badge/fish-3.2.2-blue)](https://fishshell.com) [![Issues](https://img.shields.io/github/issues/marcransome/pond)](https://github.com/marcransome/pond/issues)

Pond is a shell environment manager for the [fish shell](https://fishshell.com).

<hr>

## Background

Pond started life as a small idea: to group related shell configuration—primarily in the form of environment variables—into named collections (_ponds_) and to provide a simple mechanism for controlling when those groups are made accessible in the shell environment (through `load`, `unload`, `enable`, and `disable` commands respectively).

It has since grown to leverage [autoloaded functions](https://fishshell.com/docs/current/index.html#autoloading-functions) as a means of encapsulating environment configuration and provides a simple set of subcommands to manage such configuration.

📖 Read [The road to 1.0.0]() for more historical context.

## Installation

Install with [Fisher](https://github.com/jorgebucaran/fisher):

```console
$ fisher install marcransome/pond
```

Or with [Oh My Fish](https://github.com/oh-my-fish/oh-my-fish):

```console
$ omf install https://github.com/marcransome/pond
```

Or with [plug.fish](https://github.com/kidonng/plug.fish):

```console
$ plug install marcransome/pond
```

### Creating ponds

Create an empty pond using the `create` command:

```console
$ pond create my-app
```

Ponds are _enabled_ by default, meaning any functions that are added will automatically be made available in new shell sessions. To disable this behaviour set the universal variable `pond_enable_on_create` to `no`:

```console
$ set -U pond_enable_on_create no
```

### Adding functions to a pond

Move to the pond directory for which you wish to add a function:

```console
$ pond dir my-app
```

Add one or more related functions here. For example:

```
$ vi start-my-app.fish
...
```

Which would contain the function definition:

```fish
function start-my-app
  ...
end
```

### Enabling ponds

Use the `enable` command to make functions belonging to a pond available in new shell sessions:

```console
$ pond enable my-app
Enabled pond: my-app
```

### Disabling ponds

Use the `disable` command to make pond functions belonging to a pond inaccessible in new shell sessions:

```console
$ pond disable my-app
Disabled pond: my-app
```

### Loading ponds

Use the `load` command to make pond functions available in the current shell session:

```console
$ pond load my-app
Loaded pond: my-app
```

### Unloading ponds

Use the `unload` command to remove pond functions from the current shell session:

```console
$ pond unload my-app
Unloaded pond: my-app
```

### Viewing the status of ponds

Use the `status` command to view the status of a pond:

```console
$ pond status my-app
name: my-app
enabled: yes
path: /Users/<username>/.config/fish/pond/my-app
```

### Listing ponds

Use the `list` command to list all available ponds:

```console
$ pond list
my-app
```

Use one or more filter options to limit the output:

```console
$ pond list --enabled
my-app
```

### Removing ponds

Use the `remove` command to remove a pond:

```console
$ pond remove my-app
Remove pond: my-app? y
Removed pond: my-app
```

To automatically accept the confirmation prompt use the `-y` or `--yes` option:

```console
$ pond remove --yes my-app
Removed pond: my-app
```

### Draining ponds

Use the `drain` command to drain all functions from a pond:

```console
$ pond drain my-app
Drain pond: my-app? y
Drained pond: my-app
```

To automatically accept the confirmation prompt use the `-y` or `--yes` option:

```console
$ pond drain --yes my-app
Drained pond: my-app
```

### Viewing global configuration

To view global configuration settings for `pond`:

```console
$ pond config
Pond home: /Users/<username>/.config/fish/pond
Enable ponds on creation: yes
Pond editor command: /usr/local/bin/vim
```

### Opening a pond directory

To open a pond directory:

```console
$ pond dir my-app
```

The current working directory will be changed to the pond directory.

## Additional documentation

Only a small subset of operations is documented here. Additional documentation is provided by the `pond` command when invoked with no arguments or the `--help` option. Use `pond <command> --help` for details of a specific command.

Further documentation is provided in separate man page discussed below.

### Installing the man page

The `pond(1)` man page is provided separately from the plugin installation for `pond` itself. To install the _latest_ version of the man page:

Using `fish`:

```console
$ curl https://raw.githubusercontent.com/marcransome/pond/main/manpages/install.fish | fish
```

Or, using `bash`:

```console
$ bash -c "$(curl https://raw.githubusercontent.com/marcransome/pond/main/manpages/install.sh)"
```

To install the matching version of the man page for your `pond` installation, replace the branch name `main` in the above URLs with the semantic version number (use `pond --version` to obtain the version string).

### Viewing the man page online

As an alternative to installing the man page, [view the latest version of the man page online](http://htmlpreview.github.io/?https://github.com/marcransome/pond/blob/main/manpages/pond.html).

## Event handlers

Pond emits events for many successful operations. Setup an [event handler](https://fishshell.com/docs/current/index.html#event) to repond to such events with your own code:

Event name      | Description                     | Arguments
--------------- | --------------------------------| ----------------------------------------------
`pond_created`  | Emitted when a pond is created  | `argv[1]`: pond name<br />`argv[2]`: pond path
`pond_removed`  | Emitted when a pond is removed  | `argv[1]`: pond name<br />`argv[2]`: pond path
`pond_enabled`  | Emitted when a pond is enabled  | `argv[1]`: pond name<br />`argv[2]`: pond path
`pond_disabled` | Emitted when a pond is disabled | `argv[1]`: pond name<br />`argv[2]`: pond path
`pond_loaded`   | Emitted when a pond is loaded   | `argv[1]`: pond name<br />`argv[2]`: pond path
`pond_unloaded` | Emitted when a pond is unloaded | `argv[1]`: pond name<br />`argv[2]`: pond path
`pond_drained`  | Emitted when a pond is drained  | `argv[1]`: pond name<br />`argv[2]`: pond path

For example, to write the name of each new pond created to a file:

```console
function pond_create_handler --on-event pond_created --argument-names pond_name pond_path
  echo "$pond_name was created at $pond_path on "(date) >> ~/my-ponds
end
```

## Acknowledgements

* Icons made by [Freepik](https://www.freepik.com) from [www.flaticon.com](https://www.flaticon.com/)
* Pond's [workflow](https://github.com/marcransome/pond/actions) uses the [fishtape](https://github.com/jorgebucaran/fishtape) test runner and [tap-diff](https://github.com/axross/tap-diff) to make things pretty

## License
Pond is provided under the terms of the [MIT License](http://opensource.org/licenses/mit-license.php).

## Contact
Email me at [marc.ransome@fidgetbox.co.uk](mailto:marc.ransome@fidgetbox.co.uk) or tweet [@marcransome](http://www.twitter.com/marcransome).
