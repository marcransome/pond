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

You can create, remove and list ponds easily. Manage environment variables across ponds by setting, getting, listing, or removing variables as needed. Tab completions are provided for all Pond subcommands discussed here.

:exclamation: Pond won't protect you from yourself! If you define variables with the same name in multiple ponds and enable them for a new shell session.. fun things may happen. Bonus points for a [pull-request](https://docs.github.com/en/desktop/contributing-and-collaborating-using-github-desktop/creating-an-issue-or-pull-request).

### Managing ponds

A _pond_ represents a collection of environment variables (and in a future release _functions_) in the fish shell. Ponds are used to group related environment variables together. Naming ponds after individual applications or local development environments is a good way to separate them by their use-case.

#### Creating ponds

Create an empty pond using the `create` subcommand (or its alias `new`):

```console
$ pond create my-app
Created an empty pond 'my-app'
```

Ponds are enabled by default, meaning any environment variables added to them will be made available to all new shell sessions. To disable this behaviour set the universal variable `pond_enable_on_create` to `0`.

#### Listing ponds

List available ponds using the `list` subcommand:

```console
$ pond list
my-app
```

#### Removing ponds

Remove a pond using the `remove` subcommand (or its alias `rm`):

```console
$ pond remove my-app
Are you sure you want to remove pond 'my-app'? y
```

#### Enabling ponds

To enable a pond and ensure all new shell sessions source its environment variables use the `enable` subcommand:

```console
$ pond enable my-app
Enabled pond 'my-app'
```

#### Disabling ponds

To enable a pond and ensure all new shell sessions _do not_ source its environment variables use the `disable` subcommand:

```console
$ pond disable my-app
Disabled pond 'my-app'
```

### Viewing pond status

To view the status of a pond use the `status` subcommand:

```console
name: my-app
enabled: no
path: /Users/<username>/.config/fish/pond/ponds/my-app
```

#### Adding pond variables

Add a single variable to a pond using the `variable set` subcommand (or the shortened version `var set`), along with the pond name, variable name, and variable value:

```console
$ pond variable set my-app MEMORY_LIMIT 123
Set variable 'MEMORY_LIMIT' in pond 'my-app'
```

#### Listing pond variables

View all variables belonging to a pond using the `variable list` subcommand (or the shortened version `var ls`) along with the pond name:

```console
$ pond variable list my-app
set -xg MEMORY_LIMIT 123
```

#### Removing pond variables

Remove a single variable from a pond using the `variable remove` subcommand (or the shortened version `var rm`), along with the pond name, and variable name:

```console
$ pond variable remove my-app MEMORY_LIMIT
Variable 'MEMORY_LIMIT' removed from pond 'my-app'
```

## Acknowledgements

Icons made by [Freepik](https://www.freepik.com) from [www.flaticon.com](https://www.flaticon.com/).

## License
Pond is provided under the terms of the [MIT License](http://opensource.org/licenses/mit-license.php).

## Contact
Email me at [marc.ransome@fidgetbox.co.uk](mailto:marc.ransome@fidgetbox.co.uk) or tweet [@marcransome](http://www.twitter.com/marcransome).
