% pond(1) Version 0.5.2 | Pond User's Guide

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

Arguments can be read from standard input when **pond** is used in a pipeline. For example, to take the first pond name output from the **list** command and execute a **remove** operation using this name:

_Example:_ **pond list | head -1 | pond remove**

All arguments passed via standard input are appended to the arguments already present in the **pond** command. When used in this way, the **\--silent** option used by many commands is assumed, meaning no prompt for user confirmation will be requested for certain operations (see **COMMANDS** to determine which commands this applies to), and the **\--empty** option is assumed when using the **create** command. **pond** exits 1 if using the **edit** command in a pipeline as no interactive editor can be opened without a tty.

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

**remove** [**-s**|**\--silent**] _pond_
---------------------------------------

Remove the pond named _pond_. The directory containing pond data will be erased (typically a subdirectory of the name _pond_ located in **\$\_\_fish\_config\_dir/pond/regular/** or **\$\_\_fish\_config\_dir/pond/private/**. Confirmation from the user is expected, with a **yes** response to confirm removal, but can be silenced (automatically accepted) using **\--silent**.

**-s**, **\--silent**

:   Silence confirmation prompt (this option is inferred when using **pond** in the context of a pipeline)

**list**
--------

List all ponds. Each pond name is printed on a separate line.

**edit** _pond_
---------------

Open an interactive editor for modifying shell variables in a pond (i.e. **set**(1) commands). See **ENVIRONMENT** for a discussion of the **pond\_editor** _universal_ variable that controls which editor is used.

**enable** _pond_
-----------------

Enable pond _pond_ if not already enabled. A symbolic link will be created in **\$\_\_fish\_config\_dir/pond/links** to the pond directory (the pond directory path can be viewed using the **status** command). When new shell sessions are created any such symbolic links are followed and the **env\_vars.fish** file in each enabled pond directory is sourced into the environment to make its shell variables available to processes.

**disable** _pond_
------------------

Disable pond _pond_ if not already disabled. The symbolic link to the pond directory in **\$\_\_fish\_config\_dir/pond/links** is removed. Any shell variables that exist in _pond_ will no longer be accessible to processes when new shell sessions are created after disabling the pond.

**load** _pond_
---------------

Load pond _pond_. The path of the pond's **env\_vars.fish** file will be passed to **source**(1) and its contents evaluated in the current shell, making shell variables created with **set**(1) accessible to the current shell, and exported variables (i.e. **set -x** ...) available to child processes.

**unload** _pond_
-----------------

Unload pond _pond_. **pond** will attempt to parse the pond's **env\_vars.fish** file for **set**(1) commands and erase these shell variables from the current shell using **set -e**.

**-v**, **\--verbose**

:   Output variable names during unload

**status** _pond_
-----------------

View status of _pond_. Status information includes the _name_ of the pond, its _enabled_ state (**yes** or **no**), _private_ state (**yes** or **no**) and the absolute _path_ to the directory comprising its data.

**drain** [**-s**|**\--silent**] _pond_
---------------------------------------

Drain all shell variables from _pond_. Draining a pond effectively removes all content from the pond's **env\_vars.fish** file. If the pond was previously enabled (prior to the current shell session being created) or loaded into the current shell session with the **load** command, its variables will remain set and accessible to processes spawned by the current shell.

**-s**, **\--silent**

:   Silence confirmation prompt (this option is inferred when using **pond** in the context of a pipeline)

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

fish(1), fish-doc(1), set(1)
