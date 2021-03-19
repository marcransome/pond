<img alt="pond" src="images/fish-pond.png" width="180" align="left">

# Pond



[![Tests Status](https://github.com/marcransome/pond/actions/workflows/build.yml/badge.svg)](https://github.com/marcransome/pond/actions?query=workflow%3Atests) [![License](https://img.shields.io/badge/license-MIT-blue)](http://opensource.org/licenses/mit-license.php) [![fish](https://img.shields.io/badge/fish-3.2.0-blue)](https://fishshell.com)

Pond is a shell environment manager for the [fish shell](https://fishshell.com).

<br>
<hr>

## Installation

Install with [Fisher](https://github.com/jorgebucaran/fisher):

```console
$ fisher install marcransome/pond
```

## Usage

A _pond_ represents a collection of environment variables (and in a future release _functions_) in the fish shell. Ponds are used to group related environment variables together. Naming ponds after individual applications or local development environments is a good way to separate them by their use-case.

You can `create`, `remove`, and `edit` ponds easily. Manage how their environment variables are sourced into shell sessions with `enable`, `disable`, `load` or `unload`. Tab completions are provided for all pond commands and options discussed here.

:exclamation: Pond won't protect you from yourself! If you define multiple variables of the same name in more than one pond and either `enable` or `load` more than one at the same time.. fun things may happen. Bonus points for a [pull-request](https://docs.github.com/en/desktop/contributing-and-collaborating-using-github-desktop/creating-an-issue-or-pull-request).

### Creating ponds

Create a new pond using the `create` command:

```console
$ pond create my-app
```

By default, `create` opens an editor in your shell (one of `$EDITOR` `vim`, `vi`, `emacs`, `nano`; whichever is found first from left to right). If you wish to override the editor used, set the universal variable `pond_editor` to a command name or path (e.g `set -U pond_editor /usr/local/bin/my-editor`).

Ponds are _enabled_ by default, meaning any environment variables added to them will be made available to all future shell sessions. To disable this behaviour run: `set -U pond_enable_on_create no`.

To create an empty pond (without opening an editor) use the `-e` or `--empty` option:

```console
$ pond create --empty my-app
Created pond: my-app
```

Pond also supports the concept of a _private_ pond—intended to store environment variables that contain sensitive values (e.g. tokens, keys). Private ponds are stored in a separate directory tree to regular ponds and their collective parent directory is given `0700` permissions rather than the `0755` permissions used by regular ponds. In addition, private ponds may be treated differently by pond commands introduced in future updates (e.g. `export`).

To create a private pond use the `-p` or `--private` option:

```console
$ pond create --private my-app
Created private pond: my-app
```

Commands discussed through the remainder of this document are applicable to both regular and private ponds.

### Editing ponds

To open a pond for editing use the `edit` command:

```console
$ pond edit my-app
...
```

Refer to the [Creating ponds](#creating-ponds) section for further information about the default editor and how to change it (changes are applicable to both the `create` and `edit` commands).

### Listing ponds

Use the `list` command to list all ponds:

```console
$ pond list
my-app
```

Use one or more filter options to limit the output:

```console
$ pond list --private --disabled
my-app
```

### Removing ponds

Use the `remove` command to remove a pond:

```console
$ pond remove my-app
Remove pond: my-app? y
Removed pond: my-app
```

To silence the confirmation prompt use the `-s` or `--silent` option:

```console
$ pond remove --silent my-app
Removed pond: my-app
```

### Enabling ponds

Use the `enable` command to make pond variables available to future shell sessions:

```console
$ pond enable my-app
Enabled pond: my-app
```

### Disabling ponds

Use the `disable` command to make pond variables inaccessible to future shell sessions:

```console
$ pond disable my-app
Disabled pond: my-app
```

### Loading ponds

Use the `load` command to make pond variables available to the current shell session:

```console
$ pond load my-app
Loaded pond: my-app
```

### Unloading ponds

Use the `unload` command to remove pond variables from the current shell session:

```console
$ pond unload my-app
Unloaded pond: my-app
```

Unloading a pond will not stop pond variables from being exposed to new shell sessions if the pond is _enabled_. Instead, `disable` the pond to make the changes persist.

### Viewing the status of ponds

Use the `status` command to view the status of a pond:

```console
$ pond status my-app
name: my-app
enabled: yes
private: no
path: /Users/<username>/.config/fish/pond/regular/my-app
```

### Draining ponds

Use the `drain` command to drain all content from a pond:

```console
$ pond drain my-app
Drain pond: my-app? y
Drained pond: my-app
```

To silence the confirmation prompt use the `-s` or `--silent` option:

```console
$ pond drain --silent my-app
Drained pond: my-app
```

If a pond was previously _loaded_ into the current shell session this action will not remove pond variables from the shell environment. Instead, `unload` the pond to remove them first, or create a new shell session after draining a pond.

### Viewing global pond configuration

To view global configuration for the `pond` command:

```console
$ pond config
Pond home: /Users/<username>/.config/fish/pond
Enable ponds on creation: yes
Pond editor command: gvim
```

### Opening a pond directory

To open a pond directory:

```console
$ pond dir my-app
```

The current working directory will be changed to the pond directory.

## Additional documentation

Only a small subset of operations is documented here. Additional documentation is provided through usage output displayed by the `pond` command itself (see `pond --help` or `pond <command> --help`) as well as a separate man page discussed below.

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

```fish
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
