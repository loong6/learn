--[[
Author : ZangXu @Bojoy 2014
FileName: BJMProxySDKManager.lua
Description: 
]]

---BJMProxySDKManager
-- @module bjm.sdk.proxy

require(bjm.PACKAGE_NAME .. ".util.BJMDevice")
require(bjm.PACKAGE_NAME .. ".util.BJMConfiguration")
require(bjm.PACKAGE_NAME .. ".net.BJMHttpManager")
require(bjm.PACKAGE_NAME .. ".sdk.BJMSDKManager")
require(bjm.PACKAGE_NAME .. ".sdk.BJMSDKCache")

local sdk = bjm.sdk

sdk.proxy = {}

local proxy = sdk.proxy
proxy.useGoogleConversion = false
proxy.useMtaConversion = false
proxy.useBaiduConversion = false
proxy.useInmobiConversion = false
proxy.useDmpConversion = false

--[[------------------------------------------------------------------------------
]]
local function _GetStringSyncFn(connName, url, post)
    releaselog("==> _GetStringSyncFn")
   	post = post or ""
    bjm.util.SetUseLockWhenPush(false)
    local success, data = bjm.net.http.QueryStringSync(connName, url, post, "")
    bjm.util.SetUseLockWhenPush(true)
    return data
end

--[[------------------------------------------------------------------------------
]]
local function _GetStringAsyncFn(connName, url)
    releaselog("==> _GetStringAsyncFn")
    bjm.net.http.QueryStringAsync(connName, url, "", "")
end

--[[------------------------------------------------------------------------------
]]
local function _ShowWaitingFn(show)
    releaselog("==> _ShowWaitingFn")
    if show == true then
    	if (bjm.sdk.manager.showWaitingFunc ~= nil) then
    		bjm.sdk.manager.showWaitingFunc()
    	end
    else
    	if (bjm.sdk.manager.hideWaitingFunc ~= nil) then
    		bjm.sdk.manager.hideWaitingFunc()
    	end
    end
end 

--[[------------------------------------------------------------------------------
]]
local function _ShowNotificationFn()
    releaselog("==> _ShowNotificationFn")
end

--[[------------------------------------------------------------------------------
]]
local function _ShowErrorBoxFn()
    releaselog("==> _ShowErrorBoxFn")
end

--[[------------------------------------------------------------------------------
]]
local function _ReadValueFn(key)
    return bjm.sdk.cache.GetValue(key)
end

--[[------------------------------------------------------------------------------
]]
local function _WriteValueFn(key, value)
    bjm.sdk.cache.SetValue(key, value)
end

--[[------------------------------------------------------------------------------
]]
local function _OnProxyToGameEventFn(event, plugin_name)
    releaselog("==> _OnProxyToGameEventFn : " .. event)
    -- SDK init succ
    if event == "event_init_finish" then
    	bjm.sdk.manager.OnSDKInitFinish()

    	do return end
    end

    -- SDK logout succ
    if event == "event_logout_finish" then
        releaselog("===========>event_logout_finish")
    	BJMProxyUtil:Reset()
    	BJMLuaUtil:Restart()
    	do return end
    end

    -- SDK pay fail
    if event == "event_pay_fail_finish" then

    	do return end
    end

    -- SDK login succ
    if event == "event_login_finish" then
    	bjm.sdk.manager.OnSDKLoginFinish(true)
    	do return end
    end

    -- sdk pay success
    if event == "event_cash_finish" then
    	bjm.util.PushNotification(bjm.sdk.global.events.sdk_cash_success,{})
    end

    if event == "event_push_token" then
        bjm.util.PushNotification(bjm.sdk.global.events.sdk_push_token, {plugin_name})
    end

    if event == "event_blog_result" then
        bjm.util.PushNotification(bjm.sdk.global.events.sdk_share_result, {plugin_name})
    end
    if event == "event_cafe_joined" then
        bjm.util.PushNotification(bjm.sdk.global.events.sdk_event_cafe_joined, {plugin_name})
    end
    if event == "event_cafe_article" then
        bjm.util.PushNotification(bjm.sdk.global.events.sdk_event_cafe_article, {plugin_name})
    end
    if event == "event_cafe_comment" then
        bjm.util.PushNotification(bjm.sdk.global.events.sdk_event_cafe_comment, {plugin_name})
    end

    ---绑定解绑
    if event == "event_bind_info" then
        bjm.util.PushNotification("event_bind_info", {plugin_name})
    end
    --绑定替换
    if event == "event_rep_bind_msg" then
        bjm.util.PushNotification("event_rep_bind_msg", {plugin_name})
    end
    --绑定替换成功
    if event == "event_replacebind_finsh" then
        bjm.util.PushNotification("event_replacebind_finsh", {plugin_name})
    end

    if event == "get_invite_info" then
        bjm.util.PushNotification(bjm.sdk.global.events.sdk_event_get_invite_info, {plugin_name})
    end
     if event == "active_invite_info" then
        bjm.util.PushNotification(bjm.sdk.global.events.sdk_event_active_invite_info, {plugin_name})
    end
     if event == "get_awards_info" then
        bjm.util.PushNotification(bjm.sdk.global.events.sdk_event_get_awards_info, {plugin_name})
    end
     if event == "active_awards_info" then
        bjm.util.PushNotification(bjm.sdk.global.events.sdk_event_active_awards_info, {plugin_name})
    end
    ---绑定解绑
    if event == "event_bind_info" then
        bjm.util.PushNotification("event_bind_info", {plugin_name})
    end
    --绑定替换
    if event == "event_rep_bind_msg" then
        bjm.util.PushNotification("event_rep_bind_msg", {plugin_name})
    end
    --绑定替换成功
    if event == "event_replacebind_finsh" then
        bjm.util.PushNotification("event_replacebind_finsh", {plugin_name})
    end

    --初始化事件状态
    if event == "event_unbind_all" then
        bjm.util.PushNotification("event_unbind_all", {plugin_name})
    end
    ---退出游戏
    if event == "event_exit_game" then
        bjm.util.PushNotification("event_exit_game", {plugin_name})
    end
    ---FB邀请好友成功
    if event == "event_invite_success" then
        bjm.sdk.manager.OnSDKInviteFBFriendFinish(1)
    end
    ---FB邀请好友失败
    if event == "event_invite_failed" then
        bjm.sdk.manager.OnSDKInviteFBFriendFinish(0)
    end
    --FB 好友列表回复状态
    if event == "event_fb_friendlist" then
        bjm.util.PushNotification(bjm.sdk.global.events.event_fb_friendlist)
    end
    if event == "event_fb_friendlist_fail" then
        bjm.util.PushNotification(bjm.sdk.global.events.event_fb_friendlist_fail)
    end
    ---FB分享成功
    if event == "event_share_success" then
        bjm.sdk.manager.OnSDKShareFinish(1)
    end
    ---FB分享失败
    if event == "event_share_failed" then
        bjm.sdk.manager.OnSDKShareFinish(0)
    end
    --FB登入成功
    if event == "event_fblogin_success" then
        bjm.util.PushNotification(bjm.sdk.global.events.event_fblogin_success)
    end

    ---sdk bind mobile event
    if event == "event_bind_success" --sdk bind mobile suc
        or event == "event_unbind_success" --sdk unbind mobile succ
        or event == "event_send_bind_code" -- sdk send bind a verification code result,the result obtained through the method:GetBindMsg()
        or event == "event_send_unbind_code"-- sdk send unbind a verification code result,the result obtained through the method:GetBindMsg()
        or event == "event_bind_action" --sdk bind mobile state
     then
        bjm.util.PushNotification(bjm.sdk.global.events.sdk_bind_mobile_event, {event_name = event})
    end

     if event == "get_invite_info"
        or event == "active_invite_info"
        or event == "get_awards_info"
        or event == "active_awards_info"
     then
        bjm.util.PushNotification(bjm.sdk.global.events.sdk_event_invite_info, {event_name = event})
    end
end

--[[------------------------------------------------------------------------------
get value from params
[domain][game_code][device_code][pc][operator][device][mac][model][version][channel][plugin][use_hor].
]]
proxy.Value = function (params, key)
	local ret = nil
	if (key == "domain") then
		ret = params.domain or ""

    elseif (key == "apnsDomain") then
        ret = params.apnsDomain or ""        

	elseif (key == "game_code") then
		ret = params.game_code or ""

	elseif (key == "pc") then
		ret = params.pc or ""

	elseif (key == "operator") then
		ret = params.operator or ""

	elseif (key == "mac") then
		ret = params.mac or bjm.util.device.GetMac() or ""

	elseif (key == "model") then
		ret = params.model or bjm.util.device.GetModel() or ""

	elseif (key == "device_code") then
		ret = params.device_code or bjm.util.device.GetCode() or ""

	elseif (key == "version") then
		ret = params.version or ""

	elseif (key == "channel") then
		ret = params.channel or ""

	elseif (key == "plugin") then
		ret = params.plugin or ""

	elseif (key == "use_hor") then
		if (params.use_hor ~= nil) then
			ret = params.use_hor
		else
			ret = 1
		end
	end

	do return ret end
end

local Value = proxy.Value

proxy.GetPlugins = function(plugin)
    local params = string.split(plugin, ",")
    local temp  = ""
    for i, v in ipairs(params) do
        local tempv = string.split(v, "hwy_ios_app_")
        if #tempv == 2 then
            v = "hwy_ios"
        end
        if i > 1 then
            temp = temp .. ","
        end
        temp = temp .. v
    end
    return temp
end

--[[------------------------------------------------------------------------------
init proxy
[domain][game_code][operator][version][channel]
]]
proxy.Init = function(params)
	releaselog("Proxy SDK:: init")
	local domain = Value(params, "domain")
	local apnsDomain = Value(params, "apnsDomain")
	local gameCode =  bjm.util.config.GetAppCode()
	local operator = bjm.util.config.GetOperator()
	local pc = operator
	local mac = bjm.util.device.GetMac()
	local model = bjm.util.device.GetModel()
	local deviceCode = bjm.util.device.GetCode()
	local version = bjm.util.config.GetAppVersion()
	local channel = params.channel
	local plugin = bjm.util.config.GetPlugins()
	local useVer = 1
	if (bjm.util.device.GetUseHor() == true) then
		useVer = 0
	end
    local pluginProxy = bjm.sdk.proxy.GetPlugins(plugin)

	BJMProxyUtil:InitLuaProxy(
		domain, 
		apnsDomain,
		gameCode, 
		pc, 
		operator, 
		deviceCode, 
		mac, 
		model, 
		version, 
		channel, 
		pluginProxy,
        useVer, 
        _GetStringSyncFn, 
        _GetStringAsyncFn, 
        _ShowWaitingFn, 
        _ShowNotificationFn, 
        _ShowErrorBoxFn, 
        releaselog, 
        _OnProxyToGameEventFn, 
        _WriteValueFn,
        _ReadValueFn)

	BJMProxyUtil:SetUseInner(bjm.util.config.GetUseInner())
	BJMProxyUtil:SetIsInReviewState(bjm.sdk.RemoteConfig.IsReviewStatus())



	releaselog("Proxy SDK::Init: \n" .. 
		"domain: " .. domain .. "\n" ..
		"gameCode: " .. gameCode .. "\n" ..
		"pc: " .. pc .. "\n" ..
		"operator: " .. operator .. "\n" ..
		"deviceCode: " .. deviceCode .. "\n" ..
		"mac: " .. mac .. "\n" ..
		"model: " .. model .. "\n" ..
		"version: " .. version .. "\n" ..
		"channel: " .. channel .. "\n" ..
		"plugin: " .. plugin .. "\n" ..
        "pluginProxy: " .. pluginProxy .. "\n")

	if (plugin == "" or operator == "") then
		bjm.ui.system.ShowErrorBox("Use sdk is true, but plugin or operator is empty. Check .ini. (do you set operator or plugins?)")	
		return
	end

	if (bjm.util.IsWin32() == true) then
		-- check if plugin or operator is valid
		if (plugin ~= "hwy_android" and plugin ~= "bojoy" and pluginProxy ~= "hwy_ios" and plugin ~= "hwy_ios" ) then
            bp(pluginProxy)
			bjm.ui.system.ShowErrorBox("Use sdk is true, but plugin is not valid. Valid config can be: hwy_android or hwy_ios or bojoy")
			return
		end
		if (operator ~= "hwy_android" and operator ~= "hwy_ios" and operator ~= "bojoy" and bjm.sdk.manager.IsAppstore(operator) == false ) then
			bjm.ui.system.ShowErrorBox("Use sdk is true, but operator is not valid. Valid config can be: hwy_android or hwy_ios or bojoy")
			return
		end
	end
end

--[[------------------------------------------------------------------------------*
parse XGParam
]]
proxy.ParseXGParam = function(proxyParams)
	local XGParamInfo 	= bjm.util.config.GetXGParam()
	releaselog(XGParamInfo)
	if XGParamInfo == "" or XGParamInfo == nil then return false end

	local  tempTab = string.split(XGParamInfo, ",")
	if #tempTab ~= 2 then return false end

	proxyParams:AddParam("ios_xgpush_id", tempTab[1])
	proxyParams:AddParam("ios_xgpush_key", tempTab[2])

	return true
end

--[[------------------------------------------------------------------------------
parse googleParam
]]
proxy.ParseChannelParam = function(params, proxyParams, channel, key)
    if channel == nil or channel == "" then return end
    if key == "use_google_conversion" then

        local keyTab = {
            "google_conversion_id",
            "google_download_code",
            "google_download_cash",
            "google_register_code",
            "google_register_cash",
        }
        for i, v in ipairs(keyTab) do
            local configs = params[v]
            local tab = string.split(configs, ",")
            for j, k in ipairs(tab) do
                local config = string.split(k, "|")
                if tostring(config[2]) == tostring(channel) then
                    value = config[1]
                    params[v] = value
                    proxyParams:AddParam(v, value)
                    break
                end
            end
        end
    end
end

---loadShareSDKParams
--方便不同平台配置不同参数
proxy.shareParams = {}
proxy.LoadShareSDKParams = function(paramKey, paramValue, pluginName)
    local reset     = false

    local keyTab = {
            "share_qq_id",
            "share_qq_key",
            "share_wechat_id",
            "share_wechat_secret",
            "share_sinawebo_key",
            "share_sinawebo_secret",
            "share_tencentwebo_key",
            "share_tencentwebo_secret",
        }

    if pluginName == "ios_sharesdk" or pluginName == "android_sharesdk" or pluginName == "hwy_android_umeng" then
        reset   = true
    end

    local function _IsExist(paramName)
        for i, v in ipairs(keyTab) do
            if paramName == v then return true end
        end
        return false
    end

    if reset == false then
        if paramValue ~= nil and paramValue ~= "" then
            if _IsExist(paramKey) == true then
                proxy.shareParams[paramKey] = paramValue
            end
        end
    else
        return proxy.shareParams[paramKey]
    end
end


--[[------------------------------------------------------------------------------
setup plugin
]]
proxy.SetupPlugin = function(params, pluginName, channel)
    params = params or {}

	local proxyParams = BJMProxyUtil:NewBJMProxyParams()
	releaselog("Proxy SDK::SetupPlugin: \n")
    for k, v in pairs(params) do
    	local key = tostring(k)
    	local value = tostring(v)
    	--releaselog("key: " .. key .. ", value: " .. value .. "\n")
        local valueTemp = bjm.sdk.proxy.LoadShareSDKParams(key, value, pluginName)
        if valueTemp ~= nil then
            value = valueTemp
        end
        if string.find(value, "|") == nil then
            proxyParams:AddParam(key, value)
        end
    end

    if pluginName == "ios_xgpush" then
    	if bjm.sdk.proxy.ParseXGParam(proxyParams) == false then
    		releaselog("error: xgpush param not set")
    	end
    end

    -- add use google conversion flag to params
    local key = "use_google_conversion"
    local value = "0"
    if (proxy.useGoogleConversion == true) then
    	value = "1"
        bjm.sdk.proxy.ParseChannelParam(params, proxyParams, channel, key)
    end
    params[key] = value
    proxyParams:AddParam(key, value)

    -- add use mta conversion flag to params
    key = "use_mta_conversion"
    value = "0"
    if (proxy.useMtaConversion == true) then
    	value = "1"
    end
    params[key] = value
    proxyParams:AddParam(key, value)

    -- add use baidu conversion flag to params
    key = "use_baidu_conversion"
    value = "0"
    if (proxy.useBaiduConversion == true) then
    	value = "1"
    end
    params[key] = value
    proxyParams:AddParam(key, value) 

    -- add use inmobi conversion flag to params
    key = "use_inmobi_conversion"
    value = "0"
    if (proxy.useInmobiConversion == true) then
    	value = "1"
    end
    params[key] = value
    proxyParams:AddParam(key, value) 

    -- add use dmp conversion flag to params
    key = "use_dmp_conversion"
    value = "0"
    if (proxy.useDmpConversion == true) then
        value = "1"
    end
    params[key] = value
    proxyParams:AddParam(key, value) 

    if (pluginName == nil) then
        releaselog("error: plugin name is nil")
        pluginName = ""
    end

    if pluginName == "hwy_appstore" or pluginName == "hwy_android"  or bjm.sdk.manager.IsAppstore(pluginName)==true then
        key     = "gf_app_game_id"
        value   = bjm.util.config.GetAppID()
        params[key] = value
        proxyParams:AddParam(key, value) 

        key     = "gf_app_operator"
        value   = bjm.util.config.GetOperator()
        params[key] = value
        proxyParams:AddParam(key, value) 
    end
   
    if bjm.sdk.manager.IsAppstore(pluginName) == true then
        params["PluginName"] = "hwy_appstore"
        proxyParams:AddParam("PluginName", "hwy_appstore")
    else
        params["PluginName"] = pluginName
        proxyParams:AddParam("PluginName", pluginName)
    end
    dump(params, "sdk params")


    BJMProxyUtil:InitPluginsLua(proxyParams)
    BJMProxyUtil:ReleaseBJMProxyParams(proxyParams)
end

--[[------------------------------------------------------------------------------
login
]]
proxy.Login = function(serverID)
	releaselog("Proxy SDK::Login: serverID: " .. serverID)
	local proxyParams = BJMProxyUtil:NewBJMProxyParams()	
	proxyParams:AddParam("server_id", serverID)
	BJMProxyUtil:OnGameToProxyEventLua("event_login", proxyParams)
	BJMProxyUtil:ReleaseBJMProxyParams(proxyParams)
end

--[[------------------------------------------------------------------------------
-**
*]]
proxy.Logout = function()
	releaselog("Proxy SDK::Logout")
	local proxyParams = BJMProxyUtil:NewBJMProxyParams()
	BJMProxyUtil:OnGameToProxyEventLua("event_logout", proxyParams)
	BJMProxyUtil:ReleaseBJMProxyParams(proxyParams)
end