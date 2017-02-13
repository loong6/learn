--[[
Author : ZangXu @Bojoy 2014
FileName: BJMDevice.lua
Description: 
]]

---BJMDevice
-- @module bjm.util.device

local util = bjm.util

util.device = {}

local device = util.device

--[[------------------------------------------------------------------------------
get device code
]]
device.GetCode = function()
	return BJMLuaUtil:GetDeviceCode()
end

--[[------------------------------------------------------------------------------
get device mac
]]
device.GetMac = function()
	return BJMLuaUtil:GetMac()
end

--[[------------------------------------------------------------------------------
get device model
]]
device.GetModel = function()
	return BJMLuaUtil:GetModel()
end

--[[------------------------------------------------------------------------------
get system version
]]
device.GetSysVersion = function()
	return BJMLuaUtil:GetSysVersion()
end

--[[------------------------------------------------------------------------------
get phone number
]]
device.GetPhoneNumber = function()
	return BJMLuaUtil:GetPhoneNumber()
end

--[[------------------------------------------------------------------------------
get phone number
]]
device.GetUseHor = function()
	return BJMLuaUtil:GetUseHor()
end

--[[------------------------------------------------------------------------------
update app
]]
device.UpdateApp = function(appUrl, isForceUpdate, newVersion)
	return BJMLuaUtil:UpdateApp(appUrl, isForceUpdate, newVersion)
end

--[[------------------------------------------------------------------------------
get resolution
]]
device.GetResolution = function()
	return BJMLuaUtil:GetResolution()
end

--[[------------------------------------------------------------------------------
get os
]]
device.GetOS = function()
	return BJMLuaUtil:GetOS()
end

--[[------------------------------------------------------------------------------
-**
0-win32, 1-ios, 2-android
*]]
device.GetOSCode = function()
	local osCode = 0
	local os = device.GetOS()
	--print(os)
	if os == "android" then
		osCode = 1
	elseif os == "ios" then
		osCode = 2
	elseif os == "pc" then
		osCode = 0
	end

	return osCode
end

--[[------------------------------------------------------------------------------
get guid(lua)
]]
device.GetGuid = function()
	local seed 	= {'0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f'}
	local tb 	= {}
	for i = 1, 32 do
		table.insert(tb, seed[math.random(1,16)])
	end
	local sid 	= table.concat(tb)
	return string.format("%s-%s-%s-%s-%s",
		string.sub(sid, 1, 8),
		string.sub(sid, 9, 12),
		string.sub(sid, 13, 16),
		string.sub(sid, 17, 20),
		string.sub(sid, 21, 32)
		)
end

--[[------------------------------------------------------------------------------
open ie
]]
device.OpenIE = function(url)
	BJMLuaUtil:OpenIE(url)
end

--[[------------------------------------------------------------------------------
force update app
]]
device.ForceUpdateApp = function(url)
	BJMLuaUtil:ForceUpdateApp(url)
end

--[[------------------------------------------------------------------------------
-**
exit app
*]]
device.ExitApp = function()
	BJMLuaUtil:Exit()
end

--[[------------------------------------------------------------------------------
-**
network available???
*]]
device.CheckIsNetworkAvailable = function()
	return BJMLuaUtil:CheckIsNetworkAvailable()
end

--[[------------------------------------------------------------------------------
-**
save game data
目录与游戏包名相关
*]]
device.SaveGameDataToDevice = function(key, value)
	BJMLuaUtil:SaveGameDataToDevice(key, value)
end

--[[------------------------------------------------------------------------------
-**
get game data
目录与游戏包名相关
*]]
device.GetGameDataFromDevice = function(key)
	return BJMLuaUtil:GetGameDataFromDevice(key)
end

--[[------------------------------------------------------------------------------
-**
save public data
@publicdir 	设置为非空，存放跨应用公共记录数据(publicdir 为目录)
			设置为空，存放跨应用公共记录数据(目录为“public”)
*]]
device.SavePublicDataToDevice = function(key, value, publicdir)
	local public 	= publicdir or ""
	BJMLuaUtil:SavePublicDataToDevice(key, value, public)
end

--[[------------------------------------------------------------------------------
-**
get public data
@publicdir 	设置为非空，存放跨应用公共记录数据(publicdir 为目录)
			设置为空，存放跨应用公共记录数据(目录为“public”)
*]]
device.GetPublicDataFromDevice = function(key, publicdir)
	local public 	= publicdir or ""
	return BJMLuaUtil:GetPublicDataFromDevice(key, public)
end