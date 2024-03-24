# *CCSMB-11*: Desktop Application Discovery

*Author: Tomodachi94*

*Version:*

*Last revised:*

The words MUST, MUST NOT, SHOULD, SHOULD NOT, and MAY are defined in [RFC 2119](https://www.rfc-editor.org/rfc/rfc2119).

## Rationale

Currently, most ComputerCraft graphical operating systems, windowing and desktop management systems, and application launchers (collectively "target software") define their own method of discovering and launching applications. The behavior and expectations for each piece of target software vary wildly; for example, some target software expects programs to manage their own windowing through system-specific APIs, while other target software manages it entirely for all programs. Additionally, installation scripts and package managers ("software management tooling") contains wildly inconsistent behavior, varying from not defining any sort of application discovery, containing support for one or two specific target softwares, or attempting to maintain support for *all* target software.

The purpose of this specification is to standardize behavior for installing, discovering, and launching graphical applications, enabling greater interoperability in all target software and software management tooling.

## Application specifications

Central to the specification are "application specifications". Each application specification MUST be a Lua file with valid syntax. Each application specification SHOULD NOT call non-builtin functions in their source (as well as functions introducing [non-determinism](https://en.wikipedia.org/wiki/Deterministic_system)). Each specification MUST return a table. The table specified in each application specification MUST contain the following fields:

| Field             | Type                | Description                                                                                                                       |
|---------------------------|---------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Name                      | str                         | A human-readable name of the application.                                                                                                                                                                                    |
| Type                      | str ("Application")         | The type of the entry. Compliant software SHOULD ignore the whole entry if this is set to an unknown value.                                                                                                                  |
| Exec                      | str                         | The path to the file to execute, including arguments. The full path MAY be omitted if it is present in `shell.getPath`.                                                                                                      |
| Terminal                  | bool                        | Whether to run the application in a terminal or not.                                                                                                                                                                         |
| CompliantWindowManagement | bool                        | Whether the application manages its own windows through a system-specific API. If set to `false`, compliant specifications SHOULD define `ShowIn` (see below). If `Terminal` is set to `true`, this is implied to be `true`. |

Compliant application specifications MAY define the following additional fields:

| Field       | Type                        | Description                                                                                                                                                                                                             |
|-------------|-----------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Icon        | str-indexed array of str    | An array, where the keys are sizes in pixels (16x16 and 32x32 are common) and the values are paths to a square image representing the application. The file MAY be a BIMG file; other formats are permitted but discouraged.                                                                                      |
| GenericName | str                         | The "generic name" of the application. For example, for a file browser, this should be "File Browser".                                                                                                                                                                                                            |
| Categories  | number-indexed array of str | Categories in which the application should be shown in application launchers. For a list of valid values, see the [FreeDesktop Desktop Menu specification](https://www.freedesktop.org/wiki/Specifications/menu-spec/).                                                                                           |
| Keywords    | number-indexed array of str | Keywords which, when combined with Name and GenericName, are useful for searching valid applications.                                                                                                                                                                                                             |
| ShowIn      | number-indexed array of str | A list of target software that the application specification should be listed in. Compliant target software SHOULD ignore the specification if this field is set and the target software is not listed here.                                                                                                      |

Compliant software MAY define extra fields, but they MUST prefixed with `X-`. Compliant software SHOULD ignore all unrecognized fields without the prefix.

## Global variables

Compliant graphical OSes and desktop managers MUST set the `CCSMB_DESKTOP_CURRENT_DESKTOP` global variable, a string containing the name or path of the file executed that launched the OS or desktop manager. The variable MAY contain the command-line arguments that the graphical OS or desktop manager was started with, but this is optional and SHOULD NOT be expected by software.

Software MAY use this variable when determining what graphical OS or desktop manager is running.

Compliant graphical OSes and desktop managers SHOULD set this variable to `nil` when exiting.

## Module

Compliant graphical OSes and desktop managers MAY define the `ccsmb_desktop` module. The module MAY be loaded through `require`; it MAY also be defined in the `ccsmb_desktop` global, but this is strongly discouraged.

The `ccsmb_desktop` module MUST contain the `ccsmb_desktop.run` function. The function MUST open a new window. The function MUST accept arguments in the same way that `shell.run` does:
> All arguments are concatenated together and then parsed as a command line. As a result, shell.run("program a b") is the same as shell.run("program", "a", "b").
> — [CC: Tweaked documentation](https://tweaked.cc/module/shell.html#v:run)

The function MAY fail if the application fails to launch or continue running for any reason.

The `ccsmb_desktop` module MUST NOT contain any functions not specified above.

## Settings

This section defines variables that SHOULD be defined through the `settings` API ("settings").

### `ccsmb_desktop.search_targets`

This setting MUST be an array of absolute directories. Each directory SHOULD contain valid application specifications.

Compliant software MUST search all directories (in the order listed). Compliant software MUST NOT assume the filenames in each directory are the same as the application names; however, software management tooling SHOULD install application specifications with a sensible filename. Application specifications SHOULD use the extension `.desktop`; `.lua` SHOULD also be allowed, but software management tooling SHOULD avoid installing specifications with this extension, to avoid confusion with actual programs.

If this setting is not set, compliant software MAY search in the following directories in the order listed:
1. `/Application Specifications`
2. `/AppSpecs`
3. `/etc/ccsmb/applications`
4. `/usr/share/ccsmb/applications`
5. `/Applications`
6. `/etc/applications`
7. `/usr/share/applications`
8. `/Library/Application Specifications`

If none of the directories listed above exist, compliant software MAY create a directory of its choice, provided it sets this setting and `ccsmb_desktop.install_target` (defined below).

If none of the directories listed aboove exist, application launchers MAY choose to abort launching themselves or to remain open and empty.

### `ccsmb_desktop.install_target`

This setting MUST be a string containing a path to a directory. The directory MUST be created. Compliant software management tooling MUST install applications in this directory.

If the setting is not specified, software management tooling MUST search for all of the following directories and place specifications into them if the first match exists:
1. `/Application Specifications`
2. `/AppSpecs`
3. `/etc/ccsmb/applications`
4. `/usr/share/ccsmb/applications`
5. `/Applications`
6. `/etc/applications`
7. `/usr/share/applications`
8. `/Library/Application Specifications`
 
Software management tooling MAY create a directory of its choosing from the above list if none exist. If software management tooling chooses to do this, the `ccsmb_desktop.install_target` and `ccsmb_desktop.search_targets` settings MUST be set by the tooling.
