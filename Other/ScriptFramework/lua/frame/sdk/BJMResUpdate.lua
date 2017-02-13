--[[
Author : ZangXu @Bojoy 2014
FileName: BJMResUpdate.lua
Description: 
]]

---BJMResUpdate
-- @module bjm.sdk.AppUpdate
-- @alias module

local sdk = bjm.sdk

sdk.ResUpdate = {}


local module = sdk.ResUpdate
module.updateLogic = nil
module.curCdnIndex = 0

--[[------------------------------------------------------------------------------
-**
init local variable
*]]
module.Init = function (updateLogic)
	if (module.updateLogic ~= nil) then
		module.updateLogic:Close()
	end
	module.updateLogic = updateLogic
end

--[[------------------------------------------------------------------------------
-**
get try cnds  string 
*]]
module.GetTryCdns = function ( originCdn , backupCdns )
	if (backupCdns == "" or originCdn == "") then return "" end
	local strA = "http://"
	local strB = string.gsub(originCdn , strA , "")
	local strB_table = string.split(strB , "/")
	local strB_First = strB_table[1]
	local strC = ""
	for i,v in ipairs( strB_table) do
		if i ~= 1 then
			strC =   strC .. "/" .. v 
		end
	end

	local strResult = ""
	local try_table = string.split(backupCdns , ",")
	for i,v in ipairs(try_table) do
		
		if v ~= strB_First then
			local tryStr = strA .. v .. strC
			if strResult ~= "" then
				strResult = strResult .. ","
			end
			strResult = strResult .. tryStr
		end
	end	

	return strResult
end

--[[------------------------------------------------------------------------------
-**
set cur select cdnindex
*]]
module.SetCurSelectCDNIndex = function(nIndex)
	module.curCdnIndex = nIndex
end

--[[------------------------------------------------------------------------------
-**
select next cdnindex
*]]
module.SelectNextCDNIndex = function()
	local listCount = #sdk.RemoteConfig.data.cndtable
	if listCount == 0 then
		releaselog("error: please check cdn list config")
	end
	local nIndex = module.curCdnIndex + 1
	module.curCdnIndex = math.mod(nIndex, listCount)
	if module.curCdnIndex == 0 then
		module.curCdnIndex = listCount
	end
end

--[[------------------------------------------------------------------------------
-**
select another cdn
*]]
module.SelectNewCDN = function(nIndex)
	if module.curCdnIndex == nIndex then return false end
	if BJMUpdateUtil:StopCurUpdate() == true then
		module.SetCurSelectCDNIndex(nIndex)
		return true
	end
	return false
end

--[[------------------------------------------------------------------------------
-**
get cur select cdnrul
*]]
module.GetCurSelectCDNUrl = function()
	local listCount = #sdk.RemoteConfig.data.cndtable
	if listCount == 0 then
		releaselog("error: please check cdn list config")
		return ""
	end
	
	if module.curCdnIndex == 0 then
		module.curCdnIndex = math.random(1, listCount)
	end

	return sdk.RemoteConfig.data.cndtable[module.curCdnIndex].cdnurl
end

--[[------------------------------------------------------------------------------
-**
start update async
*]]
module.StartUpdateAsync = function (res_url, res_cdn_version)
	releaselog("start res update")
	if (res_url == nil) then
		res_url = bjm.sdk.RemoteConfig.curHost--bjm.sdk.RemoteConfig.CDNToTry()
	end
	if (res_cdn_version == nil) then
		res_cdn_version = sdk.RemoteConfig.data.resVersion
	end
	local use_cdn_acc 	= sdk.RemoteConfig.data.useCDNAccelerate or false

	releaselog("SetCDNConfigs .. " .. module.GetCurSelectCDNUrl() .. "---" .. bjm.sdk.RemoteConfig.data.resPath .. "---" .. bjm.sdk.RemoteConfig.data.cdnDNSPodApi)
	BJMUpdateUtil:SetCDNConfigs(module.GetCurSelectCDNUrl(), bjm.sdk.RemoteConfig.data.resPath, bjm.sdk.RemoteConfig.data.cdnDNSPodApi);

	releaselog("StartUpdateAsync .. " .. res_url .. "---" .. res_cdn_version .. "---" .. tostring(use_cdn_acc))
	BJMUpdateUtil:StartUpdateAsync(module.updateLogic, res_url, res_cdn_version, use_cdn_acc)
end

--[[------------------------------------------------------------------------------
-**
reset patch evn
set local res version to 0
clear all local patches
*]]
module.ResetPatchesEvn = function ()
	BJMUpdateUtil:ResetEnv()
end
