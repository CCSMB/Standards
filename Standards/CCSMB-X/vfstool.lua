local d = shell.getRunningProgram()
local sc = require "cc.shell.completion"

local pdir = fs.getDir(shell.getRunningProgram())

if not shell.getCompletionInfo()[d] then
    shell.setCompletionFunction(d,sc.build(
        {sc.choice, {"build","extract"}},
        sc.file,
        {sc.dirOrFile, many=true}
    ))
    settings.define("vfstool.overwrite",{default=false,type="boolean",description="whether to skip overwrite prompt"})
    settings.define("vfstool.dir_action",{default="",type="string",description="default action to take when unpacking and dir exists,Merge/Overwrite/Cancle M/O/C"})
end

local opts = {...}
if #opts < 4 then
    print("vfstool takes atleast 4 arguments")
    print("vfstool <build,extract> <File> <targets>...")
    print()
    print("information:")
    print("build takes folders/files from targets and puts it into File")
    print("extract takes File and extracts it into the first target")
    return
end

local direction = table.remove(opts,1)
local compression = table.remove(opts,1)
local output = table.remove(opts,1)
local files = opts

--this function is basically a VFS encoder function
--it takes a path and then recursively adds it to a table
local function gen_disk(path)
    sleep()
    local path = path or ""
    local pth = fs.getName(path)
    local tree = {}
    for _,v in pairs(fs.list(path)) do
        if fs.isDir(path.."/"..v) then
            tree[v] = gen_disk(path.."/"..v)
        else
            local chandle = fs.open(path.."/"..v,'rb')
            tree[v] = chandle.readAll()
            chandle.close()
        end
    end
    return tree
end
--boilerplate to make sure direction is valid
if not ((direction == "build") or (direction == "extract")) then
    error("arg #1 must be either build or extract not "..direction)
end

if direction == "build" then
    --make sure all input files exist
    for _,v in ipairs(files) do
        local v = shell.resolve(v)
        if not fs.exists(v) then error("File/Folder does not exist: "..v) end
    end

    --resolve path to output file
    local sro = shell.resolve(output)
    --check if we are okay to overwrite it
    if fs.exists(sro) and (not settings.get("vfstool.overwrite")) then
        print(output.." allready exist\nOverwrite Y/N:")
        c = read()
        if not string.find(c,"Y") then print("Aborted") return end
    end
    --create the table to store our VFS
    local final = {}
    print("starting tree gen")
    --add all targets to the root of the image
    for _,v in ipairs(files) do
        local sr = shell.resolve(v)
        print("adding: "..v)
        if fs.isDir(sr) then
            final[fs.getName(v)] = gen_disk(sr)
        else --why have diskgen do it when we can do it here
            local hand = fs.open(sr,'rb')
            local con = hand.readAll()
            final[fs.getName(v)] = con
            hand.close()
        end
    end
    print("serialising")
    local ser = textutils.serialise(final,{compact=true})
    print("writing")

    local handle = fs.open(sro,'wb') --write the serialised data to the file
    handle.write(ser)
    handle.close()
else
    if not fs.exists(shell.resolve(output)) then --make sure input image exist
        error("img file does not exist")
    end
    local rpath = shell.resolve(files[1])
    if fs.isReadOnly(rpath) then --make sure we can write to output
        error(files[1].." is not writable")
    end

    --really big boilerplate to make sure what we want to do to output
    local dir_action = settings.get("vfstool.dir_action")
    if fs.exists(rpath) and (dir_action ~= "M") and (dir_action ~= "O") and (dir_action ~= "C") and fs.exists(rpath) then
        print("directory "..files[1].."allready exist, Merge,Overwrite,Cancel?")
        write("<M/O/C>: ")
        local pr = read(nil,{"M","O","C"},function (t) require("cc.completion").choice(t,{"M","O","C"})end)
        if pr == "M" then
            print("Selected Merge")
        elseif pr == "O" then
            print("selected overwrite")
            fs.delete(rpath);
        else
            print("Cancelled")
            return
        end
    elseif fs.exists(rpath) then
        if dir_action == "M" then
            print("Selected Merge")
        elseif dir_action == "O" then
            print("selected overwrite")
            local ok = pcall(fs.delete,rpath);
            if not ok then print("failed to delete, probally because it is `/` but it is writable so lets go")end 
        else
            print("Cancelled")
            return
        end
    end

    --the sister to gen_disk, takes a the current path we are working in and the files to unpack
    --then writes them
    function unpack_vfs(path,files)
        print("making: "..path)
        fs.makeDir(fs.combine(rpath,path))
        shell.setDir(fs.combine(rpath,path))
        for k, v in pairs(files) do
            if type(v) == "table" then
                unpack_vfs(path.."/"..k,v)
            elseif type(v) == "string" then
                print("writing:"..k)
                local fh = fs.open(fs.combine(rpath,fs.combine(path,k)),'wb')
                fh.write(v)
                fh.close()
            end
        end
    end

    local diskf = fs.open(shell.resolve(output),"rb") --read content
    local content = diskf.readAll()
    diskf.close()
    local tcontents = textutils.unserialize(content) --decode to table
    local sdir = shell.dir()
    print("unpacking vfs")
    unpack_vfs("",tcontents) --unpack VFS
    print("done")
    shell.setDir(sdir) --head back to where we were

end