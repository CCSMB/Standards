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
directories in VFS are tables, whereas files have their contents embedded as a string
VFS files should be read and written in binary mode as to prevent converting charachters to `?`
One drawback of VFS is that it doesen't preserve 
