% pond(1) Version 0.6.2 | Pond User's Guide

NAME
====

**pond** — a shell environment manager for the fish shell

SYNOPSIS
========

| **pond** [*options*]
| **pond** *command* \[*options*] ...

DESCRIPTION
===========

A pond represents a collection of shell variables (and in a future release functions) within the fish shell. Ponds are used to group related shell variables together. Naming ponds after individual applications or local development environments is a good way to separate and control them by use-case.

Pond provides tab completion for all commands and options discussed here in addition to pond name completion for any ponds that exist locally.

Arguments can be read from standard input when **pond** is used in a pipeline. For example, to remove all disabled ponds:

_Example:_ **pond list \--disabled | pond remove**

All arguments passed via standard input are appended to the arguments already present in the **pond** command. When used in this way, the **\--silent** option is assumed by commands that support this option, meaning no user confirmation will be requested for those operations (see **COMMANDS** to determine which commands this applies to), and the **\--empty** option is assumed for the **create** command. **pond** exits 1 if the **edit** command is used in a pipeline as an interactive editor cannot be opened without a tty.

Options
-------

**-h,** **\--help**

:   Print brief usage information

**-v,** **\--version**

:   Print the current version string

COMMANDS
========

**create** [**-e**|**\--empty**] [**-p**|**\--private**] _pond_
---------------------------------------------------------------

Create a new pond named _pond_. Each pond comprises a directory tree containing a single file for storing shell variable definitions (i.e. **set**(1) commands) and a _functions_ subdirectory intended for storing *autoloaded* fish functions (to be implemented in a future update).

A pond may be marked **\--private** during creation. Private ponds are intended to store shell variables that contain sensitive values (e.g. tokens or keys). Private ponds are stored in a separate directory tree to regular ponds and their collective parent directory is given 0700 permissions rather than the 0755 permissions used by regular ponds. In addition, private ponds may be treated differently by pond commands introduced in future updates.

By default, a directory named _pond_ is created within either the **regular** or **private** subdirectory under **\$\_\_fish\_config\_dir/pond/** dependent upon the type of the pond.

When creating a new pond, an interactive editor is opened (unless the **\--empty** option is specified) ready to add new shell variable definitions. See **ENVIRONMENT** for a discussion of the **pond\_editor** universal variable that controls which editor is used.

**-e**, **\--empty**

:   Create an empty pond without opening an interactive editor (this option is inferred when using **pond** in the context of a pipeline)

**-p**, **\--private**

:   Create a private pond

**remove** [**-s**|**\--silent**] _ponds..._
--------------------------------------------

Remove _ponds_. All pond data will be erased for each named pond (i.e. the pond directory located in **\$\_\_fish\_config\_dir/pond/regular/** or **\$\_\_fish\_config\_dir/pond/private/** for each named pond is erased). Confirmation is requested from the user for each named pond and a **yes** response confirms removal of the named pond. Confirmation prompts can be silenced with the **\--silent** option.

**-s**, **\--silent**

:   Silence confirmation prompt (this option is inferred when using **pond** in the context of a pipeline)

**list** [**-p**|**\--private**] [**-r**|**\--regular**] [**-e**|**\--enabled**] [**-d**|**\--disabled**]
---------------------------------------------------------------------------------------------------------

List ponds. If no options are specified, _all_ pond names will be printed to standard output, one per line (equivalent to combining all four options **\--private**, **\--regular**, **\--enabled** and **\--disabled**).

If only one of **-p**|**\--private** or **-r**|**\--regular** is specified, the other option is assumed disabled (e.g. by specifying **-p**|**\--private** only private ponds will be listed). If neither option is provided both are assumed enabled.

If only one of **-e**|**\--enabled** or **-d**|**\--disabled** is specified, the other option is assumed disabled (e.g. by specifying **-e**|**\--enabled**, only enabled ponds will be listed). If neither option is provided both are assumed enabled.

**-p**, **\--private**

:   List private ponds

**-r**, **\--regular**

:   List regular ponds

**-e**, **\--enabled**

:   List enabled ponds

**-d**, **\--disabled**

:   List disabled ponds

_Example:_ **pond list \--private** (list private ponds, both enabled and disabled)

_Example:_ **pond list \--disabled** (list disabled ponds, both regular and private)

_Example:_ **pond list \--enabled \--private** (list enabled private ponds only)

**edit** _pond_
---------------

Open an interactive editor for modifying shell variables in a pond (i.e. **set**(1) commands). See **ENVIRONMENT** for a discussion of the **pond\_editor** _universal_ variable that controls which editor is used.

**enable** _ponds..._
---------------------

Enable _ponds_. A symbolic link will be created in **\$\_\_fish\_config\_dir/pond/links** to the pond directory for each named pond (a pond's directory path can be viewed using the **status** command). When a new shell session is created, the **env\_vars.fish** file for each enabled pond is sourced into the shell environment, making shell variables created with the **set**(1) command accessible to the shell, and making exported variables (i.e. **set -x** ...) available to child processes of the shell.

**disable** _ponds..._
----------------------

Disable _ponds_. The symbolic link to the pond directory in **\$\_\_fish\_config\_dir/pond/links** for each named pond is removed. Any shell variables present in each named pond's **env\_vars.fish** file will no longer be sourced into shell sessions that are created after those ponds are disabled.

**load** _ponds..._
-------------------

Load _ponds_. The path of each named pond's **env\_vars.fish** file will be passed to the **source**(1) command and its contents evaluated in the current shell session, making shell variables created with the **set**(1) command accessible to the current shell, and making exported variables (i.e. **set -x** ...) available to child processes of the current shell.

**unload** _ponds..._
---------------------

Unload _ponds_. **pond** will attempt to parse each named pond's **env\_vars.fish** file for **set**(1) commands and will erase matching shell variables from the current shell session using **set -e**.

**-v**, **\--verbose**

:   Output variable names during unload

**status** _pond_
-----------------

View status of _pond_. Status information includes the _name_ of the pond, its _enabled_ state (**yes** or **no**), _private_ state (**yes** or **no**) and the absolute _path_ to the directory comprising its data.

**drain** [**-s**|**\--silent**] _ponds..._
---------------------------------------

Drain _ponds_. All content is removed from the **env\_vars.fish** file for each named pond. If any of the named ponds was enabled, or had been previously loaded into the current shell session with the **load** command, then its variables _will remain set_ in the shell environment and continue to be accessible to processes spawned by the current shell until it exits.

**-s**, **\--silent**

:   Silence confirmation prompt (this option is inferred when using **pond** in the context of a pipeline)

**dir** _pond_
--------------

Change the current working directory to the pond directory for _pond_.

**config**
----------

Print the current configuration settings.

ENVIRONMENT
===========

A number of _universal_ shell variables (see **set**(1) for discussion of _universal_ variables) are set during installation. These variables control different aspects of functionality of **pond** and may be modified as described here:

**pond\_editor**

:   The editor to open when using the **create** or **edit** commands. May be set to an absolute path or the name of a command accessible via one of the paths specified in the **PATH** environment variable. During installation this variable is set to the value of the **EDITOR** environment variable, if set, or one of **vim**, **vi**, **emacs**, or **nano**, whichever is found first in one of the paths set in **PATH**, working from left to right. An error may be generated during installation if no suitable editor is found.

**pond\_enable\_on\_create**

:   The value of this shell variable is set to **yes** by default and will cause all ponds created with the **create** command to be enabled by default. To disable this behaviour set the value of this variable to **no**.

    _Default:_ **yes**.

EXIT STATUS
===========

**pond** exits 0 on success, and >0 if an error occurs.

BUGS
====

See GitHub Issues: https://github.com/marcransome/pond/issues

AUTHOR
======

Marc Ransome <marc.ransome@fidgetbox.co.uk>

SEE ALSO
========

fish(1), fish-doc(1), fish-completions(1), set(1)
