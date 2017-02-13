--[[
Author : ZangXu @Bojoy 2014
FileName: BJMJson.lua
Description: 
]]

---BJMJson
-- @module bjm.util.json
-- @alias util.json

local util = bjm.util
util.json = {}

local cjson = require("cjson")

--[[------------------------------------------------------------------------------
--- Encodes an arbitrary Lua object / variable.
-- @param lua_table The Lua object / variable to be JSON encoded.
-- @return String containing the JSON encoding in internal Lua string format (i.e. not unicode)
]]
util.json.Encode = function(lua_table)
	local status, result = pcall(cjson.encode, lua_table)
	return result
end

--[[------------------------------------------------------------------------------
--- Decodes a JSON string and returns the decoded value as a Lua data structure / value.
-- @param content The string to scan.
-- @param Lua object, number The object that was scanned, as a Lua table / string / number / boolean or nil,
]]
util.json.Decode = function(content)
	local status, result = pcall(cjson.decode, content)
	return result
end

--[[------------------------------------------------------------------------------
]]
