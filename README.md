# Pond

[![Build Status](https://img.shields.io/endpoint.svg?url=https%3A%2F%2Factions-badge.atrox.dev%2Fmarcransome%2Fpond%2Fbadge%3Fref%3Dmain&style=flat&label=build)](https://github.com/marcransome/pond/actions?query=workflow%3Abuild) [![License](https://img.shields.io/badge/license-MIT-brightgreen)](http://opensource.org/licenses/mit-license.php) [![fish](https://img.shields.io/badge/fish-3.1.2-brightgreen)](https://fishshell.com)

Pond is a shell environment manager for the [fish shell](https://fishshell.com).

## Installation

Install with [Fisher](https://github.com/jorgebucaran/fisher):

```console
$ fisher install marcransome/pond
```

## Usage

### Managing ponds

A _pond_ represents a collection of environment variables (and in a future release _functions_) in the fish shell. Ponds are used to group related environment variables together. Naming ponds after individual applications or local development environments is a good way to separate them by their use-case.

#### Creating ponds

Create an empty pond using the `create` subcommand (or its alias `new`):

```console
$ pond create my-app
pond: Created an empty pond named 'my-app'
```

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
pond: Are you sure you want to remove pond 'my-app'? y
```

#### Adding pond variables

Add a single variable to a pond using the `variable set` subcommand (or the shortened version `var set`), along with the pond name, variable name, and variable value:

```console
$ pond variable set my-app MEMORY_LIMIT 123
pond: Set variable 'MEMORY_LIMIT' in pond 'my-app'
```

Each variable added this way is written to the pond variables file (typically located in `~/.config/fish/ponds/<pond-name>/env_vars.fish`) as a `set` command of the format `set -xg <variable-name> <variable-value>`. Pond variable files are automatically sourced into each new shell session and made available in the shell environment.

#### Listing pond variables

View all variables belonging to a pond using the `variable list` subcommand (or the shortened version `var ls`):

```console
$ pond variable list my-app
set -xg MEMORY_LIMIT 123
```

#### Removing pond variables

Remove a single variable from a pond using the `variable remove` subcommand (or the shortened version `var rm`), along with the pond name, and variable name:

```console
$ pond variable remove my-app MEMORY_LIMIT
pond: Variable 'MEMORY_LIMIT' removed from pond 'my-app'
```

#### Tab completions

Tab completions are provided for all Pond subcommands here.

### Managing environment variables

## License
`Pond` is provided under the terms of the [MIT License](http://opensource.org/licenses/mit-license.php).

## Contact
Email me at [marc.ransome@fidgetbox.co.uk](mailto:marc.ransome@fidgetbox.co.uk) or tweet [@marcransome](http://www.twitter.com/marcransome).
