--[[
Author : ZangXu @Bojoy 2014
FileName: BJMConfiguration.lua
Description: 
]]

---BJMConfiguration
-- @module bjm.util.config

local util = bjm.util

util.config = {}

local config = util.config

--[[------------------------------------------------------------------------------
get app version
]]
config.GetAppVersion = function()
	return BJMLuaUtil:GetAppVersion()
end

--[[------------------------------------------------------------------------------
get plugins
]]
config.GetPlugins = function()
	return BJMLuaUtil:GetPlugins()
end

--[[------------------------------------------------------------------------------
get channel
]]
config.GetChannel = function()
	return BJMLuaUtil:GetChannel()
end

--[[------------------------------------------------------------------------------
get XGParam
]]
config.GetXGParam = function()
	return BJMLuaUtil:GetXGParam()
end

--[[------------------------------------------------------------------------------
get app code
]]
config.GetAppCode = function()
	return BJMLuaUtil:GetAppCode()
end

--[[------------------------------------------------------------------------------
-**
get app id
*]]
config.GetAppID = function()
	return BJMLuaUtil:GetAppID()
end

--[[------------------------------------------------------------------------------
get use sdk
]]
config.GetUseSDK = function()
	return BJMLuaUtil:GetUseSDK() and BJMProxyUtil ~= nil
end

--[[------------------------------------------------------------------------------
get use sdk
]]
config.GetUseUpdate = function()
	return BJMLuaUtil:GetUseUpdate()
end

--[[------------------------------------------------------------------------------
set use sdk
]]
config.SetUseUpdate = function()
	return BJMLuaUtil:SetUseUpdate()
end

--[[------------------------------------------------------------------------------
get use offline
]]
config.GetUseOffline = function()
	return BJMLuaUtil:GetUseOffline()
end

--[[------------------------------------------------------------------------------
-**
get use show bulletin
only used when you need skip bulletin step on win32!!
*]]
config.GetUseBulletin = function()
	return BJMLuaUtil:GetUseBulletin()
end

--[[------------------------------------------------------------------------------
get operator
]]
config.GetOperator = function()
	return BJMLuaUtil:GetOperator()
end

--[[------------------------------------------------------------------------------
get ssf
ssf: 1 正式服
ssf: 0 测试服
]]
config.GetSSF = function()
	return (BJMLuaUtil:GetUseTest() ~= true)
end

--[[------------------------------------------------------------------------------
-**
get use inner network??
*]]
config.GetUseInner = function()
	return BJMLuaUtil:GetUseInner()
end

--[[------------------------------------------------------------------------------
-**
*]]
config.GetUseCrashReport = function()
	return BJMLuaUtil:GetUseCrashReport()
end

--[[------------------------------------------------------------------------------
-**
*]]
config.GetAdaptType = function()
	return BJMLuaUtil:GetAdaptType()
end

--[[------------------------------------------------------------------------------
get ssf
ssf: 1 正式服
ssf: 0 测试服
]]
config.GetSSFString = function()
	local ssf = (BJMLuaUtil:GetUseTest() ~= true)
	if (ssf == true) then
		ssf = "1"
	else
		ssf = "0"
	end
	return ssf
end

--[[------------------------------------------------------------------------------
-**
*]]
config.GetLocale = function()
	return BJMLuaUtil:GetLocale()
end