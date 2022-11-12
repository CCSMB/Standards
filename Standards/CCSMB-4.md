# CCSMB-4: Lua

*Author: Oliver Cooper (oeed)*

*Last updated: 2022-01-27*

*Version: v1.0.0*

## Quick information

| Information |                           |
| ----------- | ------------------------- |
| Version     | 1.0.0                     |
| Type        | Plain text file format    |
| MIME        | `text/lua`                |
| Extensions  | `.lua`                    |

## Technical details

*This format is based upon [plain text](/Standards/CCSMB-2.md) and as such technical details that apply to plain
text also apply to this format.*

Lua code files should contain valid, executable Lua source code. These can either be self-contained programs, APIs or Lua
otherwise loaded by a program. Lua code files should be loaded with `require`, over `os.loadAPI`. Lua code files should also use `local` to declare a variable, unless a `global` is needed, which it usually is not.
