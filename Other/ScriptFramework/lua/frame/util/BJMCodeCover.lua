--[[
Author : Lituo @Bojoy 2014
FileName: BJMCodeCover.lua
Description: 
]]

---BJMCodeCover
-- @module bjm.util.codecover

local util = bjm.util

util.codecover = {}

local codecover = util.codecover

codecover.map = {}

local function _hook(event, line)
	local src = debug.getinfo(2, "S").source

	local c = codecover.map[src]
	if not c then
		c = {}
		c.md5 = nil
		c.cov = {}
		c.mod = true
		codecover.map[src] = c
	end

	if not c.md5 then
		c.md5 = bjm.util.MakeFileMD5(src)
		c.cov = {}
		c.mod = false

		local uri = codecover.save_path.."/"..c.md5

		if bjm.util.io.FileExistsFileSystem(uri) then
			local json = bjm.util.io.ReadFileFromFileSystem(uri)
			local data = bjm.util.json.Decode(json)
			for i, v in ipairs(data) do
				v = tostring(tonumber(v))
				c.cov[v] = true
			end
		end
	end

	if line > 0 then
		line = tostring(line - 1)
		if not c.cov[line] then
			c.cov[line] = true
			c.mod = true
		end
	end
end

codecover.Init = function(save_path)
	codecover.save_path = save_path

	debug.sethook(_hook, "l")
end

codecover.Save = function()
	for _, c in pairs(codecover.map) do
		if c.mod then
			c.mod = false
			local uri = codecover.save_path.."/"..c.md5
			local data = {}
			for k, _ in pairs(c.cov) do
				table.insert(data, tonumber(k))
			end
			table.sort(data)
			local json = bjm.util.json.Encode(data)
			json = string.gsub(json, ",", ",\r")

			bjm.util.io.WriteFile(uri, json)
		end
	end
end