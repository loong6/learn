--[[
Author : ZangXu @Bojoy 2014
FileName: BJMUpdateLogicEx.lua
Description: 
]]

---BJMUpdateLogicEx
-- @module bjm.logic.UpdateLogic
-- @alias logic.UpdateLogic

require(bjm.PACKAGE_NAME .. ".util.BJMScheduler")
local scheduler = bjm.util.BJMScheduler

local sdk = bjm.sdk
sdk.UpdateLogic = bjm.reg.GetModule("BJMUpdateLogicEx")

--[[------------------------------------------------------------------------------
ctor
]]
function sdk.UpdateLogic:ctor()
	dump(self, "self")
	releaselog("UpdateLogic ctor...")

	bjm.reg.RegLogicFunction(self, bjm.global.function_type.on_loaded, 							"", self.OnLoaded)
	bjm.reg.RegLogicFunction(self, bjm.global.function_type.on_destroy, 						"", self.OnDestroy)

	bjm.reg.RegLogicFunction(self, bjm.global.function_type.update_check_patches, 				"", self.OnUpdateCheckPatches)
	bjm.reg.RegLogicFunction(self, bjm.global.function_type.update_check_patches_error, 		"", self.OnUpdateCheckPatchesError)
	bjm.reg.RegLogicFunction(self, bjm.global.function_type.update_download_patch, 				"", self.OnUpdateDownloadPatch)
	bjm.reg.RegLogicFunction(self, bjm.global.function_type.update_download_patch_error, 		"", self.OnUpdateDownloadPatchError)
	bjm.reg.RegLogicFunction(self, bjm.global.function_type.update_stop, 						"", self.OnUpdateStop)
	bjm.reg.RegLogicFunction(self, bjm.global.function_type.update_success, 					"", self.OnUpdateSuccess)
	bjm.reg.RegLogicFunction(self, bjm.global.function_type.update_res_version, 				"", self.OnUpdateResVersion)
	bjm.reg.RegLogicFunction(self, bjm.global.function_type.update_max_res_version, 			"", self.OnUpdateMaxResVersion)
	bjm.reg.RegLogicFunction(self, bjm.global.function_type.update_no_patch, 					"", self.OnUpdateNoPatch)
	bjm.reg.RegLogicFunction(self, bjm.global.function_type.update_show_wifi, 					"", self.OnUpdateShowWifi)
	bjm.reg.RegLogicFunction(self, bjm.global.function_type.update_show_check_patches_error, 	"", self.OnUpdateShowCheckPatchesError)
	bjm.reg.RegLogicFunction(self, bjm.global.function_type.update_show_download_error, 		"", self.OnUpdateShowDownloadError)
	bjm.reg.RegLogicFunction(self, bjm.global.function_type.update_add_patch_fail, 				"", self.OnUpdateAddPatchFail)

	bjm.reg.RegLogicFunction(self, bjm.global.function_type.update_patch_crc_invalid, 			"", self.OnUpdatePatchCrcInvalid)
	
	
	
end

--[[------------------------------------------------------------------------------
]]
local function Restart(index)
	bjm.sdk.ResUpdate.SelectNextCDNIndex()
	if (index == 2) then
		bjm.sdk.manager.ResetPatchesEvn()
	end

	bjm.sdk.ResUpdate.StartUpdateAsync(
		bjm.sdk.RemoteConfig.data.curHost, --sdk.RemoteConfig.data.resUrl,
		sdk.RemoteConfig.data.resVersion
		)
end

--[[------------------------------------------------------------------------------
OnLoaded
]]
function sdk.UpdateLogic:OnLoaded()
	releaselog("update logic on loaded...........")
	bjm.net.http.SetUseHttps(OPEN_HTTPS)
	local success = bjm.sdk.manager.Init(self)
end

--[[------------------------------------------------------------------------------
OnDestroy
]]
function sdk.UpdateLogic:OnDestroy()
	releaselog("update logic on destroy...........")
end

--[[------------------------------------------------------------------------------
-**
update success
*]]
local function UpdateSuccess()
	releaselog("all update and patch is successful")
	bjm.sdk.manager.OnResUpdateRet()
end

--[[------------------------------------------------------------------------------
]]
function sdk.UpdateLogic:OnUpdateCheckPatches(patch_name, percent)
	-- not used
end

--[[------------------------------------------------------------------------------
]]
function sdk.UpdateLogic:OnUpdateCheckPatchesError(patch_name, percent)
	-- not used
end

--[[------------------------------------------------------------------------------
]]
function sdk.UpdateLogic:OnUpdateStop(patch_name, percent)
	releaselog("download stoped and restart")
	bjm.sdk.ResUpdate.StartUpdateAsync(
		bjm.sdk.RemoteConfig.data.curHost, --sdk.RemoteConfig.data.resUrl,
		sdk.RemoteConfig.data.resVersion
		)
end

--[[------------------------------------------------------------------------------
cur_bytes: kb
total_bytes: kb
speed: kb/s
]]
function sdk.UpdateLogic:OnUpdateDownloadPatch(patch_name, percent, cur_bytes, total_bytes, speed)
	-- should be overwrite
end

--[[------------------------------------------------------------------------------
]]
function sdk.UpdateLogic:OnUpdateDownloadPatchError(patch_name, percent)
	-- not used
end

--[[------------------------------------------------------------------------------
]]
function sdk.UpdateLogic:OnUpdateSuccess(patch_name, percent)
	UpdateSuccess()
end

--[[------------------------------------------------------------------------------
]]
function sdk.UpdateLogic:OnUpdateResVersion(none, version)
	-- should be overwrite
	releaselog("on update cur res version: " .. version)
end

--[[------------------------------------------------------------------------------
]]
function sdk.UpdateLogic:OnUpdateMaxResVersion(none, version)
	-- should be overwrite
	releaselog("on update max res version: " .. version)
end

--[[------------------------------------------------------------------------------
]]
function sdk.UpdateLogic:OnUpdateNoPatch(patch_name, percent)
	UpdateSuccess()
end

--[[------------------------------------------------------------------------------
]]
function sdk.UpdateLogic:OnUpdateShowWifi(patch_name, percent)
	-- to do
end

--[[------------------------------------------------------------------------------
]]
function sdk.UpdateLogic:OnUpdateShowCheckPatchesError(patch_name, percent)
	local schedule_OnUpdateShowCheckPatchesError = nil
	bjm.ui.system.ShowDialog(
		GetSDKString("sdk_error"),
		GetSDKString("sdk_update_check_patches_error", patch_name),
		function (index)
			schedule_OnUpdateShowCheckPatchesError = scheduler.scheduleGlobal(function ()
				scheduler.unscheduleGlobal(schedule_OnUpdateShowCheckPatchesError)
				Restart(index)
			end, 0.1)
		end,
		{GetSDKString("sdk_update_restart_single"), GetSDKString("sdk_update_restart_all")}
	)
end

--[[------------------------------------------------------------------------------
]]
function sdk.UpdateLogic:OnUpdateShowDownloadError(patch_name, percent)
	local schedule_OnUpdateShowDownloadError = nil
	bjm.ui.system.ShowDialog(
		GetSDKString("sdk_error"),
		GetSDKString("sdk_update_download_patch_error", patch_name),
		function (index)
			schedule_OnUpdateShowDownloadError = scheduler.scheduleGlobal(function ()
				scheduler.unscheduleGlobal(schedule_OnUpdateShowDownloadError)
				Restart(index)
			end, 0.1)
		end,
		{GetSDKString("sdk_update_restart_single"), GetSDKString("sdk_update_restart_all")}
	)
end

--[[------------------------------------------------------------------------------
]]
function sdk.UpdateLogic:OnUpdateAddPatchFail(patch_name)
	releaselog("OnUpdateAddPatchFail patch_name is: " .. patch_name)
	local schedule_OnUpdateAddPatchFail = nil
	bjm.ui.system.ShowDialog(
		GetSDKString("sdk_error"),
		GetSDKString("sdk_update_add_patch_fail", patch_name),
		function (index)
			schedule_OnUpdateAddPatchFail = scheduler.scheduleGlobal(function ()
				scheduler.unscheduleGlobal(schedule_OnUpdateAddPatchFail)
				Restart(index)
			end, 0.1)
		end,
		{GetSDKString("sdk_update_restart_single"), GetSDKString("sdk_update_restart_all")}
	)			
end

--[[------------------------------------------------------------------------------
-**
*]]
function sdk.UpdateLogic:OnUpdatePatchCrcInvalid(patch_name)
	releaselog("OnUpdatePatchCrcInvalid patch_name is: " .. patch_name)
	local schedule_OnUpdatePatchCrcInvalid = nil
	bjm.ui.system.ShowDialog(
		GetSDKString("sdk_error"),
		GetSDKString("sdk_update_patch_crc_invalid", patch_name),
		function (index)
			schedule_OnUpdatePatchCrcInvalid = scheduler.scheduleGlobal(function ()
				scheduler.unscheduleGlobal(schedule_OnUpdatePatchCrcInvalid)
				Restart(index)
			end, 0.1)
		end,
		{GetSDKString("sdk_update_restart_single"), GetSDKString("sdk_update_restart_all")}
	)	
end

--[[------------------------------------------------------------------------------
-**
*]]
function sdk.UpdateLogic:OnSDKLoginFinish(success)
	releaselog("sdk.UpdateLogic OnSDKLoginFinish, success: " .. success)

	self.sdkLogined = true
end