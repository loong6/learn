--[[
Author : ZangXu @Bojoy 2014
FileName: BJMXmlManager.lua
Description: 
]]

---BJMXmlManager
-- @module bjm.data.xml

local xml = {}
bjm.data.xml = xml

--instance
local instance = nil

local function Instance()
	if (instance ~= nil) then do return instance end end
	return BJMXmlSerializeServer:Instance()
end

--[[------------------------------------------------------------------------------
source config is a file
@param add_to_cache if need to add this config to c++ xml config cache
@return config instance
]]
xml.AddConfigFile = function (config_name, config_uri, add_to_cache)
	do return Instance():CreateOrAddConfig(config_name, config_uri, add_to_cache) end
end

--[[------------------------------------------------------------------------------
source config is a string
@param add_to_cache if need to add this config to c++ xml config cache
@return config instance
]]
xml.AddConfigString = function (config_name, config_content, add_to_cache)
	do return Instance():CreateOrAddConfigFromString(config_name, config_content, add_to_cache) end
end

--[[------------------------------------------------------------------------------
add a config to c++ xml config cache and name this config as config_name
]]
xml.AddConfig = function (config_name, config)
	Instance():AddConfig(config_name, config)
end

--[[------------------------------------------------------------------------------
remove config named config_name from c++ xml config cache 
]]
xml.RemoveConfig = function (config_name)
	Instance():RemoveConfig(config_name)
end

--[[------------------------------------------------------------------------------
find config
return config instance found
]]
xml.FindConfig = function (config_name)
	do return Instance():FindConfig(config_name) end
end
