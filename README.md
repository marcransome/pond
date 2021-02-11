<img alt="pond" src="images/fish-pond.png" width="180" align="left">

# Pond

[![Build Status](https://img.shields.io/endpoint.svg?url=https%3A%2F%2Factions-badge.atrox.dev%2Fmarcransome%2Fpond%2Fbadge%3Fref%3Dmain&style=flat&label=build)](https://github.com/marcransome/pond/actions?query=workflow%3Abuild) [![License](https://img.shields.io/badge/license-MIT-brightgreen)](http://opensource.org/licenses/mit-license.php) [![fish](https://img.shields.io/badge/fish-3.1.2-brightgreen)](https://fishshell.com)

Pond is a shell environment manager for the [fish shell](https://fishshell.com).

<hr>

## Installation

Install with [Fisher](https://github.com/jorgebucaran/fisher):

```console
$ fisher install marcransome/pond
```

## Usage

A _pond_ represents a collection of environment variables (and in a future release _functions_) in the fish shell. Ponds are used to group related environment variables together. Naming ponds after individual applications or local development environments is a good way to separate them by their use-case.

You can `create`, `remove`, and `edit` ponds easily. Manage the variables that are sourced into shell sessions with `enable`, `disable`, `load` or `unload`. Tab completions are provided for all pond commands and options discussed here.

:exclamation: Pond won't protect you from yourself! If you define multiple variables of the same name in more than one pond and either `enable` or `load` more than one.. fun things may happen. Bonus points for a [pull-request](https://docs.github.com/en/desktop/contributing-and-collaborating-using-github-desktop/creating-an-issue-or-pull-request).

### Managing ponds

#### Creating ponds

Create a new pond using the `create` command:

```console
$ pond create my-app
```

This command opens an editor in your shell (one of `$EDITOR` `vim`, `vi`, `emacs`, `nano`; whichever exists from left to right). If you wish to override the editor used, set the universal variable `pond_editor` to a valid path (e.g `set pond_editor /usr/local/bin/my-editor`).

Ponds are _enabled_ by default, meaning any environment variables added will be made available to all future shell sessions. To disable this behaviour set the universal variable `pond_enable_on_create` to `no`.

To create an empty pond (without opening an editor) for later use:

```console
$ pond create -e my-app
or
$ pond create --empty my-app
```

#### Listing ponds

List available ponds using the `list` command:

```console
$ pond list
my-app
```

#### Removing ponds

Remove a pond using the `remove` command:

```console
$ pond remove my-app
Remove pond: abc? y
Removed pond: abc
```

To silence the confirmation prompt add the `-s` or `--silent` option:

```console
$ pond remove --silent my-app
Removed pond: abc
```

#### Enabling ponds

To make variables in a pond available to future shell sessions, use the `enable` command:

```console
$ pond enable my-app
Enabled pond: abc
```

#### Disabling ponds

To make variables in a pond inaccessible to future shell sessions, use the `disable` command:

```console
$ pond disable my-app
Disabled pond: my-app
```

#### Loading ponds

To make variables in a pond available to the current shell session temporarily, use the `load` command:

```console
$ pond load my-app
Pond loaded: my-app
```

#### Unloading ponds

To unload a pond and remove all of its variables from the current shell session use the `unload` command:

```console
$ pond unload my-app
Pond unloaded: my-app
```

If the pond is _enabled_ this action will not stop pond variables from being exposed to new shell sessions. Instead, `disable` the pond to make the changes persist.

### Viewing pond status

To view the status of a pond use the `status` command:

```console
$ pond status my-app
name: my-app
enabled: no
path: /Users/<username>/.config/fish/pond/ponds/my-app
```

### Draining ponds

To drain a pond of all its variables but retain the pond, use the `drain` command:

```console
$ pond drain my-app
Drain pond: abc? y
Drained pond: abc
```

To silence the confirmation prompt add the `-s` or `--silent` option:

```console
$ pond drain --silent my-app
Drained pond: abc
```

Note, draining a pond will not unexport variables from the current shell session. Instead, `unload` the pond first.

## Acknowledgements

Icons made by [Freepik](https://www.freepik.com) from [www.flaticon.com](https://www.flaticon.com/).

## License
Pond is provided under the terms of the [MIT License](http://opensource.org/licenses/mit-license.php).

## Contact
Email me at [marc.ransome@fidgetbox.co.uk](mailto:marc.ransome@fidgetbox.co.uk) or tweet [@marcransome](http://www.twitter.com/marcransome).
