# CCSMB-X: Virtual File System

*Author: walksanator (Walker Fowlkes)*

*Version: 1.0.*
     
*Last revised: 2023-01-DD*

## Quick information

| Information |                              |
| ----------- | -----------------------------|
| Version     | 1.0.9                        |
| Author      | walksanator (Walker Fowlkes) |
| Type        | Virtual File System Archiv   |
| MIME        | `text/plain`                 |
| Extensions  | `.vfs`                       |

## Technical details

the VFS file is a text-based format that represents folder(s) as a lua table
where each file/directories name is the key of the table, and the content is the value
for files the value is the contents of the file
for directories the value is a table containg more files/directories
