<img alt="pond" src="images/fish-pond.png" width="180" align="left">

# Pond

[![Build Status](https://img.shields.io/endpoint.svg?url=https%3A%2F%2Factions-badge.atrox.dev%2Fmarcransome%2Fpond%2Fbadge%3Fref%3Dmain&style=flat&label=build)](https://github.com/marcransome/pond/actions?query=workflow%3Abuild) [![License](https://img.shields.io/badge/license-MIT-brightgreen)](http://opensource.org/licenses/mit-license.php) [![fish](https://img.shields.io/badge/fish-3.1.2-brightgreen)](https://fishshell.com)

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

By default, `create` opens an editor in your shell (one of `$EDITOR` `vim`, `vi`, `emacs`, `nano`; whichever is found first from left to righ). If you wish to override the editor used, set the universal variable `pond_editor` to a command name of path (e.g `set pond_editor /usr/local/bin/my-editor`).

Ponds are _enabled_ by default, meaning any environment variables added will be made available to all future shell sessions. To disable this behaviour set the universal variable `pond_enable_on_create` to `no`.

To create an empty pond (without opening an editor) use the `-e` or `--empty` option:

```console
$ pond create --empty my-app
Created pond: my-app
```

Pond also supports the concept of a _private_ pond—intended to store environment variables that use sensitive values (e.g. tokens, keys). Private ponds are stored in a separate directory tree to regular ponds and their collective parent directory is given `0700` permissions rather than the `0755` permissions used by regular ponds. In addition, private ponds may be treated differently by pond commands introduced in future updates (e.g. `export`).

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

Refer to the [Creating ponds](#creating-ponds) section for further information about the default editor and how to change it (such changes are applicable to both the `create` and `edit` commands).

### Listing ponds

List available ponds using the `list` command:

```console
$ pond list
my-app
```

### Removing ponds

Remove a pond using the `remove` command:

```console
$ pond remove my-app
Remove pond: abc? y
Removed pond: abc
```

To silence the confirmation prompt use the `-s` or `--silent` option:

```console
$ pond remove --silent my-app
Removed pond: abc
```

### Enabling ponds

Use the `enable` command to o make variables in a pond available to future shell sessions:

```console
$ pond enable my-app
Enabled pond: abc
```

### Disabling ponds

Use the `disable` command to make variables in a pond inaccessible to future shell sessions:

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

If a pond is _enabled_ this action will not stop pond variables from being exposed to new shell sessions. Instead, `disable` the pond to make the changes persist.

### Viewing the status of ponds

Use the `status` command to view the current status of a pond

```console
$ pond status my-app
name: my-app
enabled: yes
private: no
path: /Users/<username>/.config/fish/pond/regular/my-app
```

### Draining ponds

Use the `drain` command to drain a pond of all its variables:

```console
$ pond drain my-app
Drain pond: abc? y
Drained pond: abc
```

To silence the confirmation prompt use the `-s` or `--silent` option:

```console
$ pond drain --silent my-app
Drained pond: abc
```

If a pond was previously _loaded_ into the current shell session this action will not remove pond variables from its environment. Instead, `unload` the pond to remove them first.

## Acknowledgements

Icons made by [Freepik](https://www.freepik.com) from [www.flaticon.com](https://www.flaticon.com/).

## License
Pond is provided under the terms of the [MIT License](http://opensource.org/licenses/mit-license.php).

## Contact
Email me at [marc.ransome@fidgetbox.co.uk](mailto:marc.ransome@fidgetbox.co.uk) or tweet [@marcransome](http://www.twitter.com/marcransome).
