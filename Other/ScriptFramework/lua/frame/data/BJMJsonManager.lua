--[[
Author : ZangXu @Bojoy 2014
FileName: BJMJsonManager.lua
Description: 
]]

---BJMJsonManager
-- @module bjm.data.json

require(bjm.PACKAGE_NAME .. ".util.BJMIO")
require(bjm.PACKAGE_NAME .. ".util.BJMJson")

local json = {}
bjm.data.json = json

--[[------------------------------------------------------------------------------
json cache
]]
json.cache = {}

--[[------------------------------------------------------------------------------
add json config from file
@param add_to_cache if need to add this json config to cache
@return config instance
]]
json.AddConfigFile = function (config_name, config_uri, add_to_cache)
	local file_content = bjm.util.io.ReadFile(config_uri)
	do return json.AddConfigString(config_name, file_content, add_to_cache) end	
end

--[[------------------------------------------------------------------------------
add json config from file on file system
@param add_to_cache if need to add this json config to cache
@return config instance
]]
json.AddConfigFileFromFileSystem = function (config_name, config_uri, add_to_cache)
	local file_content = bjm.util.io.ReadFileFromFileSystem(config_uri)
	do return json.AddConfigString(config_name, file_content, add_to_cache) end	
end

--[[------------------------------------------------------------------------------
add json config from string
@param add_to_cache if need to add this json config to cache
@return config instance
]]
json.AddConfigString = function (config_name, config_content, add_to_cache)
	local obj = bjm.util.json.Decode(config_content)
	if (obj == nil) then
		do return nil end
	end

	if (add_to_cache == true) then
		json.cache[config_name] = obj
	end

	do return obj end
end

--[[------------------------------------------------------------------------------
remove json config
]]
json.RemoveConfig = function (config_name)
	json.cache.config_name = nil
end

--[[------------------------------------------------------------------------------
find json config
]]
json.FindConfig = function (config_name)
	do return json.cache[config_name] end
end

--[[------------------------------------------------------------------------------
remove all json configs
]]
json.RemoveAll = function ()
	json.cache = {}
end

--[[------------------------------------------------------------------------------
-**
xml to lua table
*]]