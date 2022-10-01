% pond(1) Version 2.2.0 | Pond User's Guide

NAME
====

**pond** — a shell environment manager for the fish shell

SYNOPSIS
========

| **pond** [*options*]
| **pond** *command* \[*options*] ...

DESCRIPTION
===========

A *pond* represents a named collection of functions in the fish shell.

Each pond comprises a directory containing one or more user-defined functions. Functions belonging to a pond may be *autoloaded* by name if a pond was enabled (see **enable**) prior to the shell being created or if the pond was loaded using the **load** command in the current shell.

In addition to user-defined functions, two special functions (see **autoload** and **autounload**) are automatically executed if they exist. These functions are the recommended way of setting or unsetting environment variables for a pond (using **set**(1)).

Arguments can be read from standard input when **pond** is used in a pipeline. For example, to remove all disabled ponds:

_Example:_ **pond list \--disabled | pond remove**

All arguments passed via standard input are appended to the arguments already present in the **pond** command. When used in this way, the **\--yes** option is assumed by commands that support it, meaning user confirmation prompts will be automatically accepted for those operations (see **COMMANDS** to determine which commands this applies to).

Options
-------

**-h,** **\--help**

:   Print brief usage information

**-v,** **\--version**

:   Print the current version string

COMMANDS
========

**create** _ponds..._
---------------------

Create ponds _ponds_. An empty directory will be created in **\$pond\_home** for each named pond.

**remove** [**-y**|**\--yes**] _ponds..._
-----------------------------------------

Remove _ponds_. All pond data will be erased for each named pond. Confirmation is requested from the user for each named pond and a **yes** response confirms removal of the named pond. Confirmation prompts can be automatically accepted with the **\--yes** option.

**-y**, **\--yes**

:   Automatically accept confirmation prompts (this option is inferred when using **pond** in the context of a pipeline)

**list** [**-e**|**\--enabled**] [**-d**|**\--disabled**] [**-l**|**\--loaded**] [**-u**|**\--unloaded**]
---------------------------------------------------------------------------------------------------------

List ponds. If no options are specified, _all_ pond names will be printed to standard output regardless of their status. If one or more options are specified, then only the names of ponds that match an option will be output.

**-e**, **\--enabled**

:   List enabled ponds

**-d**, **\--disabled**

:   List disabled ponds

**-l**, **\--loaded**

:   List loaded ponds

**-u**, **\--unloaded**

:   List unloaded ponds

_Example:_ **pond list** (list all ponds)

_Example:_ **pond list \--disabled** (list disabled ponds only)

_Example:_ **pond list \--enabled \--unloaded** (list enabled _and_ unloaded ponds only)

**check** _ponds..._
--------------------

Check _ponds_ for syntax issues. A list of function filenames will be printed, one filename per line, for each named pond. Function filenames will be prefixed with a green tick or red cross, indicating syntax validation success or failure for that file. A trailing line will be printed with the total number of passes, failures, and total function count for the pond. This command will exit early if syntax issues are found, after the first pond with failures.

**autoload** _pond_
-------------------

Open the autoload function for _pond_ in an interactive editor. The function will be created if it does not already exist and will be named after _pond_ with the suffix \_autoload.

If _pond_ is enabled (see **enable**) the function will be executed automatically during startup of new shell sessions. If _pond_ is loaded (see **load**) then the function will be executed automatically in the current shell session.

See **ENVIRONMENT** for a discussion of the **pond\_editor** _universal_ variable that controls which editor is used when this command is invoked.

**autounload** _pond_
---------------------

Open the autounload function for _pond_ in an interactive editor. The function will be created if it does not already exist and will be named after _pond_ with the suffix \_autounload.

If _pond_ is unloaded (see **unload**) the function will be executed automatically. It is advisable to use the autounload function to perform cleanup of any operations present in a pond's autoload function, if one exists. For example, unsetting environment variables that were previously set. Doing so will ensure that unloading a pond (see **unload**) will remove any configuration for a pond from the shell environment.

See **ENVIRONMENT** for a discussion of the **pond\_editor** _universal_ variable that controls which editor is used when this command is invoked.

**enable** _ponds..._
---------------------

Enable _ponds_. The path of each named pond will be added to the *\$fish\_function\_path environment variable in new shells. Functions belonging to a pond may be autoloaded by name if a pond was enabled before the shell was created.

**disable** _ponds..._
----------------------

Disable _ponds_. The path of each named pond will not be added to the *\$fish\_function\_path environment variable in new shells. Functions belonging to a pond will be inaccessible in new shells.

**load** _ponds..._
-------------------

Load _ponds_. The path of each named pond will be added to the *\$fish\_function\_path environment variable in the current shell. Functions belonging to _ponds_ may be autoloaded by name in the current shell.

**unload** _ponds..._
---------------------

Unload _ponds_. The path of each named pond will be remove from the *\$fish\_function\_path environment variable in the current shell. Functions belonging to _ponds_ will be inaccessible in the current shell.

**status** [_ponds..._]
-----------------------

View global status (without arguments) or status of the specified _ponds_.

The global status output includes a visual representation of the overall health of all ponds in the form of a leading dot symbol. The dot is coloured green or red to indicate the absence or presence of syntax issues in functions belonging to any ponds. This is followed by the version number of the pond command and a number of additional fields:

**Health**

:   The word 'good' (coloured green) or 'poor' (coloured red) indicating whether there are syntax issues or not within one or more ponds

**Ponds**

:   The total number of ponds followed by the number of enabled and loaded ponds in parentheses

**Loaded**

:   The directory path where ponds are stored followed by an ASCII representation of ponds rooted in that directory, each of which is preceded by a small dot symbol whose colour indicates if the pond is loaded (green) or not (grey)

When used with one or more _ponds_ the **status** command outputs the name of the pond preceded by a coloured dot symbol indicating if the pond is loaded (green) or not (grey) followed by the pond directory path and these additional fields:

**Status**

:   Indicates whether the pond is loaded or unloaded, and whether the enabled or disabled

**Health**

: The word 'good' or 'poor' (in red) indicating whether there are syntax issues with functions in the pond

**Autoload**

: Indicates whether an autoload function is present for the pond or not

**Autounload**

: Indicates whether an autounload function is present for the pond or not

**Functions**

: The number of functions in the pond

**Size**

: The size of the pond and unit suffix

**drain** [**-y**|**\--yes**] _ponds..._
---------------------------------------

Drain _ponds_. All functions are removed from each named pond. If any of the named ponds was enabled for the current shell session or had been previously loaded in the current shell session with the **load** command, variables for that pond _will remain_ in the shell environment and continue to be accessible to processes until the current shell exits.

**-y**, **\--yes**

:   Automatically accept confirmation prompts (this option is inferred when using **pond** in the context of a pipeline)

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

**pond\_load\_on\_create**

:   The value of this shell variable is set to **yes** by default and will cause all ponds created with the **create** command to be loaded by default. To disable this behaviour set the value of this variable to **no**.

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

fish(1), fish-doc(1), fish-completions(1), function(1), set(1)
