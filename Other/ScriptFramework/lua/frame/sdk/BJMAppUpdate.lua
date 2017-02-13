--[[
Author : ZangXu @Bojoy 2014
FileName: BJMAppUpdate.lua
Description: 
]]

---BJMAppUpdate
-- @module bjm.sdk.AppUpdate
-- @alias module

require(bjm.PACKAGE_NAME .. ".util.BJMScheduler")
local scheduler = bjm.util.BJMScheduler

local sdk = bjm.sdk

sdk.AppUpdate = {}


local module = sdk.AppUpdate

--[[------------------------------------------------------------------------------
-**
valid version
*]]
module.ValidVersionIsOld = function(currAppVer, releaseAppVer) 
    releaselog("==> currAppVer : "..currAppVer..", releaseAppVer : "..releaseAppVer)

    local curTable = string.split(currAppVer, ".")
    local releaseTable = string.split(releaseAppVer, ".")

    local isOld = false

    local len = math.max(#curTable, #releaseTable)
    for i = 1, len, 1 do
        local v1 = tonumber(curTable[i] or "0")
        local v2 = tonumber(releaseTable[i] or "0")

        if v1 < v2 then
            isOld = true
            break
		elseif v1 > v2 then
			isOld = false
			break
        end
    end
    
    return isOld
end

--[[------------------------------------------------------------------------------
need update??
]]
module.IsNeedUpdate = function ()
	if (bjm.util.config.GetUseUpdate() == false) then
		releaselog("not use update")
		do return false end
	end
	if (bjm.sdk.RemoteConfig.data.newestVersion == nil) then
		releaselog("newestVersion is nil. check if you are in offline mode")
		do return false end
	end
	local updateType = bjm.sdk.RemoteConfig.data.updateType
	if (updateType == 0) then
		releaselog("no new version found")
		do return false end
	end
	local newestVersion = bjm.sdk.RemoteConfig.data.newestVersion
	local currentVersion = bjm.util.config.GetAppVersion()
	local isOld = module.ValidVersionIsOld(currentVersion, newestVersion)
	if (isOld) then do return true end end
	return false
end

--[[------------------------------------------------------------------------------
-**
force update
*]]
module.GoToUpdate = function ()
	local targetUrl = bjm.sdk.RemoteConfig.data.downloadUrl
	releaselog("do app update " .. targetUrl)
	bjm.util.device.ForceUpdateApp(targetUrl)
end

--[[------------------------------------------------------------------------------
show update dialog
]]
module.ShowUpdateDialog = function ()
	local newestVersion = bjm.sdk.RemoteConfig.data.newestVersion
	local updateType = bjm.sdk.RemoteConfig.data.updateType
	if (updateType == 1) then
		-- force update
		bjm.ui.system.ShowDialog(
			GetSDKString("sdk_app_update"),
			GetSDKString("sdk_app_update_force", newestVersion),
			function (index)
				module.GoToUpdate()
			end,
			{GetSDKString("sdk_ok")}
		)		
	elseif (updateType == 2) then
		-- normal update
		bjm.ui.system.ShowDialog(
			GetSDKString("sdk_app_update"),
			GetSDKString("sdk_app_update_normal", newestVersion),
			function (index)
				if (index == 1) then
					-- go to update
					module.GoToUpdate()
				elseif (index == 2) then
					-- don't do update
					-- go to res update
					releaselog("cancel app update")
					bjm.sdk.manager.OnAppUpdateRet()
				end
			end,
			{GetSDKString("sdk_ok"), GetSDKString("sdk_cancel")}
		)		
	end
	
end