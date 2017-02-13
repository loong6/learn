--[[
Author : ZangXu @Bojoy 2014
FileName: BJMSDKCache.lua
Description: 
]]

local sdk = bjm.sdk
sdk.cache = {}
local cache = sdk.cache

local function Instance()
	return BJMSDKCacheServer:Instance()
end

--[[------------------------------------------------------------------------------
-**
get value from cache
if cache is not loaded, engine will load cache from local file
*]]
cache.GetValue = function (key)
	return Instance():GetValue(key)
end

--[[------------------------------------------------------------------------------
-**
set value
cache will be automatically written to local file
no need to call save
*]]
cache.SetValue = function (key, value)
	Instance():SetValue(key, value)
end