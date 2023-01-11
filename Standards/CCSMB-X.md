# CCSMB-X: Virtual File System Archive

*Author: walksanator (Walker Fowlkes)*

*Version: 1.0.*
     
*Last revised: 2023-01-DD*

## Quick information

| Information |                              |
| ----------- | -----------------------------|
| Version     | 1.0.9                        |
| Author      | walksanator (Walker Fowlkes) |
| Type        | Virtual File System Archiv   |
| MIME        | `appilcation/vfs`            |
| Extensions  | `.vfs`                       |

## Technical details

The VFS file format is a text-based format that represents folder(s) as a lua table
where the keys of the table are used as file names and values are used for conents.
Directories in VFS are tables, whereas files have their contents embedded as a string.
VFS files should be read and written in binary mode as to prevent converting binary charachters to `?`
One drawback of the VFS format is that it does not save any MetaData of files compressed

## Examples included

In the CCSMB-X folder there is a [example tool](./CCSMB-X/vfstool.lua) for creating and extracting archive
and a [example archive](./CCSMB-X/Example1.vfs) containg a _G dumper script in a folder named "empty" and it's output
