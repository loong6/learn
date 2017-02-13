--[[
Author : ZangXu @Bojoy 2014
FileName: BJMIO.lua
Description: 
file or package utilities are all defined here
]]

---BJMIO
-- @module bjm.util.io

local util = bjm.util
util.io = {}
local io = util.io

require "bjm.util.BJMJson"

--[[------------------------------------------------------------------------------
read file
return file content
]]
io.ReadFile = function (uri)
	do return BJMLuaUtil:ReadFile(uri) end
end

--[[------------------------------------------------------------------------------
read file from file system
return file content
]]
io.ReadFileFromFileSystem = function (uri)
	do return BJMLuaUtil:ReadFileFromFileSystem(uri) end
end

--[[------------------------------------------------------------------------------
copy file from uri_from to uri_to, from pkg to filesystem
return if success
]]
io.CopyFile = function (uri_from, uri_to)
	do return BJMLuaUtil:CopyFile(uri_from, uri_to) end
end

--[[------------------------------------------------------------------------------
copy file from uri_from to uri_to, from filesystem to filesystem
return if success
]]
io.CopyFileFileSystem = function (uri_from, uri_to)
	do return BJMLuaUtil:CopyFileFileSystem(uri_from, uri_to) end
end

--[[------------------------------------------------------------------------------
write file
return if success
]]
io.WriteFile = function (uri, file_content)
	do return BJMLuaUtil:WriteFile(uri, file_content) end
end

--[[------------------------------------------------------------------------------
write file, file content comes from lua table
return if success
]]
io.WriteTable = function (uri, table)
	local fileContent = bjm.util.json.Encode(table)
	do return io.WriteFile(uri, fileContent) end
end

--[[------------------------------------------------------------------------------
read file, file conetent is a lua table
return lua table
]]
io.ReadTable = function (uri)
	local fileContent = io.ReadFile(uri)
	if (fileContent == "") then do return nil end end

	do return bjm.util.json.Decode(fileContent) end
end

--[[------------------------------------------------------------------------------
write file async, file content comes form lua table
]]
io.WriteTableAsync = function (uri, table)
	local fileContent = bjm.util.json.Encode(table)
	io.WriteFileAsync(uri, fileContent)
end

--[[------------------------------------------------------------------------------
write file, file content is string
no return value
]]
io.WriteFileAsync = function (uri, file_content)
	BJMLuaUtil:WriteFileAsync(uri, file_content)
end

--[[------------------------------------------------------------------------------
delete file
return if success
]]
io.DeleteFile = function (uri)
	do return BJMLuaUtil:DeleteFile(uri) end
end

--[[------------------------------------------------------------------------------
check file exists
]]
io.FileExists = function (uri)
	do return BJMLuaUtil:FileExists(uri) end
end

--[[------------------------------------------------------------------------------
check file exists in filesystem
]]
io.FileExistsFileSystem = function (uri)
	do return BJMLuaUtil:FileExistsFileSystem(uri) end
end

--[[------------------------------------------------------------------------------
compute file crc
]]
io.FileCrc = function (uri)
	do return BJMLuaUtil:FileCrc(uri) end
end

--[[------------------------------------------------------------------------------
create directory
return if success
]]
io.CreateDirectory = function (uri)
	do return BJMLuaUtil:CreateDirectory(uri) end
end

--[[------------------------------------------------------------------------------
delete directory
return if success
]]
io.DeleteDirectory = function (uri)
	do return BJMLuaUtil:DeleteDirectory(uri) end
end

--[[------------------------------------------------------------------------------
check directory exists
]]
io.DirectoryExists = function (uri)
	do return BJMLuaUtil:DirectoryExists(uri) end
end

--[[------------------------------------------------------------------------------
list files
]]
io.ListFiles = function (uri, pattern, fullPath)
	do return BJMLuaUtil:ListFiles(uri, pattern, fullPath) end
end

--[[------------------------------------------------------------------------------
list directories
]]
io.ListDirectories = function (uri, pattern, fullPath)
	do return BJMLuaUtil:ListDirectories(uri, pattern, fullPath) end
end

--[[------------------------------------------------------------------------------
-**
unzip
*]]
io.Unzip = function (zipUri, unzipUri, flat)
	do return BJMLuaUtil:Unzip(zipUri, unzipUri, flat) end
end

--[[------------------------------------------------------------------------------
-**
read file from file system and encode as base64
*]]
io.ReadFileFromFileSystemAsBase64 = function (uri)
	do return BJMLuaUtil:ReadFileFromFileSystemAsBase64(uri) end
end

--[[------------------------------------------------------------------------------
-**
rename file
*]]
io.RenameFile = function (from, to)
	do return BJMLuaUtil:RenameFile(from, to) end
end