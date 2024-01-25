# CCSMB-X: Virtual File System Archive

*Author: walksanator (Walker Fowlkes)*

*Version: 1.0.*
     
*Last revised: 2023-01-DD*

## Quick information

| Information |                              |
| ----------- | -----------------------------|
| Version     | 1.0.9                        |
| Author      | walksanator (Walker Fowlkes) |
| Type        | Virtual File System Archive   |
| MIME        | `appilcation/vfs`            |
| Extensions  | `.vfs`                       |

## Technical details

The VFS file format is a text-based format that represents folder(s) as a Lua table
where the keys of the table are used as file names and values are used for contents.
Directories in VFS are tables, whereas files have their contents embedded as strings.
VFS files should be read and written in binary mode as to prevent converting binary characters to `?`.
VFS archives do not store metadata, programs that need things like modification times will need to seek a alternative.

## Examples

A example function that takes a directory and turns it into a VFS could be implemented as.
```lua
local function gen_disk(path) --takes a path to turn into a table
    local pth = fs.getName(path) --get the file name
    local tree = {} --create a empty tree
    for _,v in pairs(fs.list(path)) do --itterate
        if fs.isDir(path.."/"..v) then --if it is a dir
            tree[v] = gen_disk(path.."/"..v) --call this function on that directory
        else-- it is a file
            local chandle = fs.open(path.."/"..v,'rb') --read all contents and add to the VFS
            tree[v] = chandle.readAll()
            chandle.close()
        end
    end
    return tree --return the current VFS
end
```

Another example function that takes a root to extract to and VFS to extract from.
```lua
function unpack_vfs(path,files)
    fs.makeDir(path) --create the directory that files will live in
    shell.setDir(path) -- head into the new directory
    for k, v in pairs(files) do --itterate over directory contents in VFS
        if type(v) == "table" then
            unpack_vfs(path.."/"..k,v) --extract folder
        elseif type(v) == "string" then
            local fh = fs.open(fs.combine(rpath,fs.combine(path,k)),'wb') --extract file
            fh.write(v)
            fh.close()
        end
    end
end
```
