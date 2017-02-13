--[[
Author : ZangXu @Bojoy 2014
FileName: BJMSDKManager.lua
Description: 
Procedure:
1.  send w001 [fetch configs stored at server side]
2.a w001 success, receive w001 [parse configs params, save them in BJMRemoteConfig]
2.b w001 fail, ...
3. init proxy sdk 
   [there are two purpose of initing proxy here. 
    1. init proxy sdk
    2. we need to check app update at this time point. some third party sdk includes update functionality in initialization
   ]
4.a init success:
   4.a.a sdk does app update, go to res update
   4.a.b sdk doesn't do app update, go to app update
4.b init fail, ...
5.a res update success, go to wait for login (use push button to login)
5.b res update fail, redo res update
6.  push button to login: 
6.a sdk has login, do sdk login
6.b sdk dosen't have login, do game login
7.a login success, enter game
7.b login fail, go to wait for login
]]

require(bjm.PACKAGE_NAME .. ".util.BJMScheduler")
local scheduler = bjm.util.BJMScheduler

require(bjm.PACKAGE_NAME .. ".sdk.BJMGAM")
require(bjm.PACKAGE_NAME .. ".util.BJMConfiguration")
require(bjm.PACKAGE_NAME .. ".sdk.BJMServerList")

local sdk = bjm.sdk

sdk.manager = {}

local manager = sdk.manager
manager.logic = nil
manager.updateLogic = nil
manager.sdk_desc = nil
manager.serverID = ""
manager.roleName = ""
manager.showWaitingFunc = nil
manager.hideWaitingFunc = nil
manager.UnpackPluginTab = {}

--[[------------------------------------------------------------------------------
-**
init
*]]
manager.Init = function(updateLogic)
	manager.logic = sdk.SDKLogic.new()
	manager.updateLogic = updateLogic

	-- res update init
	bjm.sdk.ResUpdate.Init(sdk.manager.updateLogic)

	local success = sdk.RemoteConfig.PrepareCDN()
	if (success == false) then
		do return false end
	end

	manager.CheckNetworkAndSendW001()
end

--[[------------------------------------------------------------------------------
-**
set show waiting func
*]]
manager.SetShowWaitingFunc = function(show_waiting_func, hide_waiting_func)
	manager.showWaitingFunc = show_waiting_func
	manager.hideWaitingFunc = hide_waiting_func
end

--[[------------------------------------------------------------------------------
-**
*]]
manager.CheckNetworkAndSendW001 = function()
	releaselog("manager.CheckNetworkAndSendW001")
	-- remote config
	sdk.RemoteConfig.Init()
	local isNetworkAvailable = bjm.util.device.CheckIsNetworkAvailable()
	local isUseOffline = bjm.util.config.GetUseOffline()
	if (isNetworkAvailable == false) then
		releaselog("no network")
		if (isUseOffline) then
			-- use off line
			-- do nothing
			releaselog("offline game, don't fetch server configs, set as if w001 is return")
			manager.OnW001Ret()
			do return end
		else
			releaselog("online game, prevent game advancing")
			manager.NoNetwork()
			do return end
		end
	else
		releaselog("network is good")
	end

	sdk.RemoteConfig.SendW001()
end

--[[------------------------------------------------------------------------------
-**
*]]
manager.NoNetwork = function()
	local schedule_no_network = nil
	bjm.ui.system.ShowDialog(
		GetSDKString("sdk_info"),
		GetSDKString("sdk_no_network"),
		function (index)
			schedule_no_network = scheduler.scheduleGlobal(function ()
				dump(schedule_no_network, "schedule_no_network2")
				scheduler.unscheduleGlobal(schedule_no_network)
				manager.CheckNetworkAndSendW001()	
			end, 0.1)	
			dump(schedule_no_network, "schedule_no_network1")
		end,
		{GetSDKString("sdk_ok")}
	)
end

--[[------------------------------------------------------------------------------
-**
*]]
manager.OnW001Fail = function()
	local isUseOffline = bjm.util.config.GetUseOffline()
	if (isUseOffline ~= true) then
		releaselog("w001 fail, and not use offine, show error")
		SendError(bjm.global.err.all_cdn_fail_w001)
		bjm.ui.system.CloseWaiting()

		local schedule_w001_fail = nil
		bjm.ui.system.ShowDialog(
			GetSDKString("sdk_error"),
			GetSDKString("sdk_w001_fail"),
			function (index)
				schedule_w001_fail = scheduler.scheduleGlobal(function ()
					scheduler.unscheduleGlobal(schedule_w001_fail)
					manager.CheckNetworkAndSendW001()	
				end, 0.1)				
			end,
			{GetSDKString("sdk_ok")}
		)
	else
		releaselog("w001 fail, and use offine, goto init plugin")
		manager.OnW001Ret()
	end	
end

--[[------------------------------------------------------------------------------
-**
load proxy config
*]]
manager.LoadProxyConfig = function()
	local operator = bjm.util.config.GetOperator()

	--reload sdk.SDKConfig
	package.loaded["sdk.SDKConfig"] = nil
	manager.sdk_desc = require("sdk.SDKConfig")

	if manager.sdk_desc == nil or manager.sdk_desc[operator] == nil then
		return false
	else
		return true
	end
end

--[[------------------------------------------------------------------------------
-**
parse channel
*]]
manager.ParseChannelAndConversion = function (channel)
	local conversions = 
	{
		{ name = "google_conversion", 	field = "useGoogleConversion" },
		{ name = "mta_conversion", 		field = "useMtaConversion" },
		{ name = "baidu_conversion", 	field = "useBaiduConversion" },
		{ name = "inmobi_conversion", 	field = "useInmobiConversion" },
		{ name = "dmp_conversion", 		field = "useDmpConversion" },
		--add more here
	}

	for i, v in ipairs(conversions) do
		local index1, index2 = string.find(channel, v.name)
		if (index2 ~= nil) then
			bjm.sdk.proxy[v.field] = true
			local tokens = string.split(channel, ":")
			if (#tokens ~= 2) then
				releaselog("invalid format of "..v.name..". must be "..v.name..":code")
				bjm.sdk.proxy[v.field] = false
			end

			channel = tokens[2]
			releaselog("ParseChannelAndConversion", v.name, v.field, channel)
			break
		end
	end

	return channel
end

manager.InitUnpackPlugin = function()
	manager.UnpackPluginTab = {}
	if sdk.RemoteConfig.data.w001Json.unpack_plugin == nil then sdk.RemoteConfig.data.w001Json.unpack_plugin = "" end
	releaselog("unpack_plugin is .. " .. sdk.RemoteConfig.data.w001Json.unpack_plugin)
	if sdk.RemoteConfig.data.w001Json.unpack_plugin == "" then return end
	manager.UnpackPluginTab = string.split(sdk.RemoteConfig.data.w001Json.unpack_plugin, ",")
end

manager.IsUnpackProxySDK = function(plugin)
	for i,v in ipairs(manager.UnpackPluginTab) do
		if v == plugin then return true end
	end
	return false
end

--[[------------------------------------------------------------------------------
-**
init and setup plugin
*]]
manager.InitAndSetupProxySDK = function()
	releaselog("manager.InitAndSetupProxySDK")

	local domain = sdk.RemoteConfig.data.proxyDomain
	if (bjm.util.config.GetUseInner() == true) then
		domain = "192.168.0.7:4040/rest"
	end

	manager.InitUnpackPlugin()

	local channel = manager.ParseChannelAndConversion(bjm.util.config.GetChannel())

	releaselog("=====channel is: " .. channel .. "=====")

	bjm.sdk.proxy.Init(
		{
			domain = domain,
			apnsDomain = sdk.RemoteConfig.data.apnsDomain,
			game_code = bjm.util.config.GetAppCode(),
			operator = operator,
			version = bjm.util.config.GetAppVersion(),
			channel = channel
		}
	)

	local plugins = bjm.util.config.GetPlugins()
	local tokensPlugins = string.split(plugins, ",")
	for i = 1, #tokensPlugins, 1 do
		local plugin = tokensPlugins[i]
		if (plugin == "hwy_ios") then
			plugin = "hwy_appstore"
		end
		local temp = string.split(plugin, "hwy_ios_app_")
		if #temp == 2 then
			local flag = tonumber(temp[2])
			if flag == 0 then
				plugin = "hwy_appstore_hd"
			elseif flag == 1 then
				plugin = "hwy_appstore_th"
			else
				plugin = "hwy_appstore_wy" .. flag
			end
		end

		if manager.IsUnpackProxySDK(plugin) == true then
			releaselog("remove from plugin list .. " .. plugin)
		else
			local params = manager.sdk_desc[plugin]
			bjm.sdk.proxy.SetupPlugin(params, plugin, channel)
		end
	end
end

---是否是appstore
manager.IsAppstore = function(plugin)
	if plugin == "hwy_appstore_hd" or plugin == "hwy_appstore_th" or plugin == "hwy_appstore" then
		return true
	else
		local temp = string.split(plugin, "hwy_appstore_wy")
		if #temp == 2 then
			return true
		end
	end
	return false
end

--[[------------------------------------------------------------------------------
-**
res update
*]]
manager.ResUpdate = function()
	local isUseOffline = bjm.util.config.GetUseOffline()
	if (bjm.sdk.RemoteConfig.IsReviewStatus() == true and bjm.sdk.RemoteConfig.IsNeedNotGetPatches() == true) then
		releaselog("is Review version, no res update")
		bjm.sdk.manager.OnResUpdateRet()
	elseif (isUseOffline == false) then
		bjm.sdk.ResUpdate.StartUpdateAsync()
	else
		releaselog("is offline version, no res update")
		bjm.sdk.manager.OnResUpdateRet()
	end
end

--[[------------------------------------------------------------------------------
-**
reset patch evn
set local res version to 0
clear all local patches
*]]
manager.ResetPatchesEvn = function ()
	local isUseOffline = bjm.util.config.GetUseOffline()
	if (isUseOffline == false) then
		bjm.sdk.ResUpdate.ResetPatchesEvn()
	else

	end
end

--[[------------------------------------------------------------------------------
-**
app update
*]]
manager.AppUpdate = function()
	bjm.sdk.AppUpdate.ShowUpdateDialog()
end

--[[------------------------------------------------------------------------------
-**
login
sid: server id
*]]
manager.Login = function(sid)
	bjm.sdk.gam.Report(bjm.global.gam.before_login)
	bjm.sdk.account.Login(sid)
end

--[[------------------------------------------------------------------------------
-**
switch account
*]]
manager.SwitchAccount = function()
	bjm.sdk.account.SwitchAccount()
end

--[[------------------------------------------------------------------------------
-**
log out
*]]
manager.Logout = function ()
	bjm.sdk.account.Logout()
end

--[[------------------------------------------------------------------------------
-**
sdk login success
*]]
manager.OnSDKLoginFinish = function(success)
	bjm.sdk.gam.Report(bjm.global.gam.sdk_login_finish)
	bjm.util.PushNotification(bjm.sdk.global.events.sdk_login_result,{success=success})
end

--[[------------------------------------------------------------------------------
-**
pay
*]]
manager.Pay = function(product_id, quantity)
	quantity = quantity or 1
	bjm.sdk.Cash.Pay(product_id, quantity)
end

--[[------------------------------------------------------------------------------
-**
set role name
*]]
manager.SetRoleName = function (role_name)
	manager.roleName = role_name
	if(bjm.util.IsWin32() == false) then
		BJMProxyUtil:SetRoleName(role_name)
	end

	bjm.sdk.gam.SetRoleName(role_name)
end

--[[------------------------------------------------------------------------------
-**
set role id
*]]
manager.SetRoleID = function (role_id)
	if(bjm.util.IsWin32() == false) then
		BJMProxyUtil:SetRoleID(role_id)
	end
end

--[[------------------------------------------------------------------------------
-**
set role level
*]]
manager.SetRoleLevel = function (role_lv)
	if(bjm.util.IsWin32() == false) then
		BJMProxyUtil:SetRoleLevel(role_lv)
	end
end

--[[------------------------------------------------------------------------------
-**
set role vocation_id
*]]
manager.SetVocation = function (vocation_id)
	if(bjm.util.IsWin32() == false) then
		BJMProxyUtil:SetVocation(vocation_id)
	end
end

--[[------------------------------------------------------------------------------
-**
set role role_party
*]]
manager.SetRoleParty = function (role_party)
	if(bjm.util.IsWin32() == false) then
		BJMProxyUtil:SetRoleParty(role_party)
	end
end

--[[------------------------------------------------------------------------------
-**
set role role_party_id
*]]
manager.SetRolePartyID = function (role_party_id)
	if(bjm.util.IsWin32() == false) then
		BJMProxyUtil:SetRolePartyID(role_party_id)
	end
end

--[[------------------------------------------------------------------------------
-**
set operator id
*]]
manager.SetOperatorID = function (operator_id)
	if(bjm.util.IsWin32() == false) then
		BJMProxyUtil:SetOprID(operator_id)
	end
end




--[[------------------------------------------------------------------------------
-**
set server id
*]]
manager.SetServerID = function (server_id)
	manager.serverID = server_id
	if(bjm.util.IsWin32() == false) then
		BJMProxyUtil:SetServerID(server_id)
	end

	bjm.sdk.gam.SetServerID(server_id)
end

--[[------------------------------------------------------------------------------
-**
set server name
*]]
manager.SetServerName = function ( sernver_name )
	if(bjm.util.IsWin32() == false) then
		BJMProxyUtil:SetServerName(sernver_name)
	end	
end

--[[------------------------------------------------------------------------------
-**
set passport
*]]
manager.SetPassport = function (passport)
	if(bjm.util.IsWin32() == false) then
		BJMProxyUtil:SetPassport(passport)
	end
end

--[[------------------------------------------------------------------------------
-**
*]]
manager.SetRefreshToken = function (refreshToken)
	if(bjm.util.IsWin32() == false) then
		BJMProxyUtil:SetRefreshToken(refreshToken)
	end
end

--[[------------------------------------------------------------------------------
-**
*]]
manager.SetAccessToken = function (accessToken)
	if(bjm.util.IsWin32() == false) then
		BJMProxyUtil:SetAccessToken(accessToken)
	end
end

--[[------------------------------------------------------------------------------
-**
*]]
manager.ShowUserCenter = function ()
	local proxyParams = BJMProxyUtil:NewBJMProxyParams()
	BJMProxyUtil:OnGameToProxyEventLua("event_show_user_center", proxyParams)
	BJMProxyUtil:ReleaseBJMProxyParams(proxyParams)
end

--[[------------------------------------------------------------------------------
-**
*]]
manager.NeedShowUserCenter = function ()
	return BJMProxyUtil:GetIsShowUserCenter()
end


--[[------------------------------------------------------------------------------
-**
is fb login
*]]
manager.IsFaceBookLogin = function()
	if(bjm.util.IsWin32() == false) then
		return BJMProxyUtil:IsFacebookLogin()
	end
	return false
end


--[[------------------------------------------------------------------------------
-call sharesdk 
-content: 
*]]
manager.UseSharesdk = function ( content , image_patch , click_url )
	if content == nil or content == "" then return end

	local os = bjm.util.device.GetOS()
	local share_name = ""
	if os == "android" then
		share_name = "hwy_android_umeng"
	elseif os == "ios" then
		share_name = "ios_sharesdk"
	else
		share_name = ""
	end
	if share_name == "" then return end
	image_patch = image_patch or ""
	click_url = click_url or ""


	local shareParams = BJMProxyUtil:NewBJMProxyParams()
	shareParams:AddParam("share_key" , "")
	shareParams:AddParam("share_secret" , "")
	shareParams:AddParam("share_name" , share_name)
	shareParams:AddParam("share_content" , content)
	shareParams:AddParam("share_image_path" , image_patch)
	shareParams:AddParam("share_url" , click_url)
	shareParams:AddParam("share_wxflag" , "0")

	BJMProxyUtil:OnGameToProxyEventLua("event_share", shareParams)
	BJMProxyUtil:ReleaseBJMProxyParams(shareParams)
end

--[[------------------------------------------------------------------------------
-**
set notifyUrl
*]]
manager.SetNotifyUrl = function (notifyUrl)
	if(bjm.util.IsWin32() == false) then
		BJMProxyUtil:SetNotifyUrl(notifyUrl)
	end
end

--[[------------------------------------------------------------------------------
-**
statistic_name is the name of this statistic
params is a table [key.value format]
*]]
manager.Statistic = function (statistic_name, params)
	if (params == nil) then
		params = {}
	end
	local proxyParams = BJMProxyUtil:NewBJMProxyParams()
	for k, v in pairs(params) do
		proxyParams:AddParam(tostring(k), tostring(v))
	end

	proxyParams:AddParam("Name", statistic_name)

	BJMProxyUtil:OnGameToProxyEventLua("event_statistic", proxyParams)
	BJMProxyUtil:ReleaseBJMProxyParams(proxyParams)
end

--[[------------------------------------------------------------------------------
-**
iap init transaction for appstore
*]]
manager.InitTransactionAppstore = function()
	releaselog("InitTransactionAppstore")
	BJMProxyUtil:OnGameToProxyEventLua("event_transaction_init")
end

--[[------------------------------------------------------------------------------
-**
on app update success
*]]
manager.OnAppUpdateRet = function()
	-- no update or cancel normal update or sdk did update
	releaselog("app update finish, go to res update")
	bjm.sdk.gam.Report(bjm.global.gam.before_res_update)
	manager.ResUpdate()
end

--[[------------------------------------------------------------------------------
-**
on res udpate success
*]]
manager.OnResUpdateRet = function()
	releaselog("res update finish, go to wait for login gui")
	manager.WaitForLoginGUI()
end

--[[------------------------------------------------------------------------------
-**
*]]
manager.OnGameLoginFinish = function()
	releaselog("on game login finish...")
	local proxyParams = BJMProxyUtil:NewBJMProxyParams()
	BJMProxyUtil:OnGameToProxyEventLua("event_game_login_finish", proxyParams)
	BJMProxyUtil:ReleaseBJMProxyParams(proxyParams)
end

--[[------------------------------------------------------------------------------
-**
go to wait for login gui
*]]
manager.WaitForLoginGUI = function()
	bjm.sdk.gam.Report(bjm.global.gam.wait_for_login_gui)
	bjm.util.PushNotification(bjm.sdk.global.events.change_to_wait_for_login_gui,{})
end

--[[------------------------------------------------------------------------------
-**
on sdk init finish
*]]
manager.OnSDKInitFinish = function()
	bjm.sdk.gam.Report(bjm.global.gam.before_app_update)
	
	if (bjm.util.IsWin32() == true) then
		-- res update
		manager.ResUpdate()
	else
		if (BJMProxyUtil ~= nil and BJMProxyUtil:IsSelfUpdate() == true) then
			releaselog("SDK has update function, go to res update")

			-- 此处判断 只有支付功能sdk 账号系统使用的是好玩友的 更新使用GOIS后台配置逻辑
			local cur_operator = bjm.util.config.GetOperator()
			cur_operator = cur_operator or ""
			if 	cur_operator == "hwy_android_egame" or
				cur_operator == "hwy_android_zhuoyou" or
				cur_operator == "hwy_android_wostore" then

		    	local isNeedAppUpdate = bjm.sdk.AppUpdate.IsNeedUpdate()
		    	if (isNeedAppUpdate == false) then
		    		manager.OnAppUpdateRet()
		    	else
		    		manager.AppUpdate()
		    	end					
			else
				manager.OnAppUpdateRet()
			end
	    else
	    	releaselog("SDK don't have app update function, go to app update")
	    	-- check if need update
	    	local isNeedAppUpdate = bjm.sdk.AppUpdate.IsNeedUpdate()
	    	if (isNeedAppUpdate == false) then
	    		manager.OnAppUpdateRet()
	    	else
	    		manager.AppUpdate()
	    	end			
	    end
	end
end

--[[------------------------------------------------------------------------------
-**
on w001 ret success
*]]
manager.OnW001Ret = function(data)
	releaselog("manager.OnW001Ret")
	if (data ~= nil) then
		if (sdk.RemoteConfig.ReceiveW001(data) == false) then
			return
		end
	end	

	bjm.sdk.gam.Report(bjm.global.gam.before_show_bulletin)
	local showBulletin = bjm.sdk.bulletin.CheckNeedShow()

	if (bjm.util.IsWin32() == true) then
		if (bjm.util.config.GetUseBulletin() == false) then
			showBulletin = false
		end
	end

	if bjm.sdk.RemoteConfig.IsReviewStatus() == true then
		showBulletin = false
	end

	local funcAfterW001 = function ()
	--if (bjm.util.IsWin32() == true) then
		--	manager.OnSDKInitFinish()
		--else
			bjm.sdk.gam.Report(bjm.global.gam.before_init_sdk)

			local useSDK = bjm.util.config.GetUseSDK()
			if (useSDK == false) then
				releaselog("not use sdk")
				manager.OnSDKInitFinish()
			else
				if manager.LoadProxyConfig() then
					releaselog("proxy sdk is configured")
					manager.InitAndSetupProxySDK()
				else
					releaselog("proxy sdk is not configured")
					manager.OnSDKInitFinish()
				end
			end
		--end
	end

	if (showBulletin == true) then
		-- by zx: if don't use delay, web node will crash with ccdirector!
		local schedule_ShowBulletin = nil
		schedule_ShowBulletin = scheduler.scheduleGlobal(function ()
			scheduler.unscheduleGlobal(schedule_ShowBulletin)
			bjm.sdk.bulletin.Show(funcAfterW001)
		end, 0.01)
	else
		funcAfterW001()
	end
end


--[[------------------------------------------------------------------------------
-**
on sdk share finish
--ntype  分享回调事件类型 1-成功 0 失败
*]]
manager.OnSDKShareFinish = function(ntype)
	bjm.util.PushNotification(bjm.sdk.global.events.sdk_fb_share_result, {ntype})
end

--[[------------------------------------------------------------------------------
-**
on sdk invite finish
--ntype  邀请好友回调事件类型 1-成功 0 失败
*]]
manager.OnSDKInviteFBFriendFinish = function(ntype)
	logi("OnSDKInviteFBFriendFinish ntype = " .. ntype)
	bjm.util.PushNotification(bjm.sdk.global.events.sdk_fb_invite_result, {ntype})
end
------------------------------------- sdk logic -------------------------------------
sdk.SDKLogic = bjm.reg.GetModule("BJMSDKLogic")

--[[------------------------------------------------------------------------------
-**
ctor
*]]
function sdk.SDKLogic:ctor()
	releaselog("SDKLogic ctor...........")
	bjm.reg.RegLogicFunction(self, bjm.global.function_type.http_ret, "w001", self.OnW001Ret)
	bjm.reg.RegLogicFunction(self, bjm.global.function_type.http_ret, "activity_conn", self.OnActivityRet)
	bjm.reg.RegLogicFunction(self, bjm.global.function_type.http_ret, "server_list_conn", self.OnServerListRet)
	bjm.reg.RegLogicFunction(self, bjm.global.function_type.http_ret, "server_list_zip_conn", self.OnServerListZipRet)
	
end

--[[------------------------------------------------------------------------------
-**
on w001 ret
*]]
function sdk.SDKLogic:OnW001Ret(connName, data)
	releaselog("on w001 ret")
	if (data == "fail") then
		local success = sdk.RemoteConfig.SendW001()
		if (success == false) then
			-- all cdns error
			manager.OnW001Fail()
			return
		end

		return
	end

	manager.OnW001Ret(data)
end

--[[------------------------------------------------------------------------------
-**
on activity ret
*]]
function sdk.SDKLogic:OnActivityRet(connName, data)
	bjm.sdk.activity.OnActivityRet(connName, data)
end

--[[------------------------------------------------------------------------------
-**
on serverlist ret
*]]
function sdk.SDKLogic:OnServerListRet(connName, data)
	bjm.sdk.ServerList.OnHttpResult(connName, data)
end

function sdk.SDKLogic:OnServerListZipRet(connName, data)
	bjm.sdk.ServerList.OnHttpResultForZip(connName, data)
end


