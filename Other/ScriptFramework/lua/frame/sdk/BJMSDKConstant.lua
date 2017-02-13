--[[
Author : ZangXu @Bojoy 2014
FileName: BJMSDKConstant.lua
Description: 
define all constant string, default values or enums here
]]

---BJMSDKConstant
-- @module bjm.sdk.global

bjm.sdk.global = {}

--[[------------------------------------------------------------------------------
-**
md5 hash
*]]
bjm.sdk.global.md5 = "#$211!yd099&^"

--[[------------------------------------------------------------------------------
-**
*]]
bjm.sdk.global.strings = 
{
	w001_waiting = "w001_waiting",
	sdk_error = "sdk_error",
	sdk_update_check_patches_error = "sdk_update_check_patches_error",
	sdk_update_restart_single = "sdk_update_restart_single",
	sdk_update_restart_all = "sdk_update_restart_all",
	sdk_update_add_patch_fail = "sdk_update_add_patch_fail",
	sdk_update_patch_crc_invalid = "sdk_update_patch_crc_invalid",
	sdk_update_download_patch_error = "sdk_update_download_patch_error",
	sdk_app_update = "sdk_app_update",
	sdk_app_update_normal = "sdk_app_update_normal",
	sdk_app_update_force = "sdk_app_update_force",
	sdk_ok = "sdk_ok",
	sdk_cancel = "sdk_cancel",
	sdk_info = "sdk_info",
	sdk_no_network = "sdk_no_network",
	sdk_w001_fail = "sdk_w001_fail",
	sdk_activity_waiting = "sdk_activity_waiting",
	sdk_serverlist_waiting = "sdk_serverlist_waiting"
}

--[[------------------------------------------------------------------------------
short code
]]
function GetSDKString(name, ...)
	local pat = bjm.util.GetSDKString(bjm.sdk.global.strings[name], ...)
	return string.format(pat, ...)
end

--[[------------------------------------------------------------------------------
-**
*]]
bjm.sdk.global.events =
{
	change_to_wait_for_login_gui = "change_to_wait_for_login_gui",
	sdk_cash_success = "sdk_cash_success",
	game_cash_success = "game_cash_success",
	game_cash_fail = "game_cash_fail",
	sdk_login_result = "sdk_login_result",
	sdk_activity_result = "sdk_activity_result",
	sdk_serverlist_result = "sdk_serverlist_result",
	sdk_push_token = "sdk_push_token",
	sdk_share_result = "sdk_share_result",
	sdk_bind_mobile_event = "sdk_bind_mobile_event",
	sdk_event_cafe_joined ="sdk_event_cafe_joined",
	sdk_event_cafe_article="sdk_event_cafe_article",
	sdk_event_cafe_comment="sdk_event_cafe_comment",
	sdk_event_invite_info="sdk_event_invite_info",
	sdk_fb_invite_result = "sdk_fb_invite_result",
	event_fb_friendlist  = "event_fb_friendlist",
	event_fb_friendlist_fail = "event_fb_friendlist_fail",
	sdk_fb_share_result  = "sdk_fb_share_result",
	sdk_share_success ="event_share_success",
	sdk_share_failed ="event_share_failed",
	sdk_event_invite_info="sdk_event_invite_info",
	event_fblogin_success = "event_fblogin_success",
	sdk_event_appflyer_report = "sdk_event_appflyer_report",
}