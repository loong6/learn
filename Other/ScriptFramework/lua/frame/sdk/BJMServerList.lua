--[[
Author : ZangXu @Bojoy 2014
FileName: BJMServerList.lua
Description: 
用法：
1.直接调用ServerList.Load方法，返回服务器的config lua表
2.加载后也可以直接调用bjm.sdk.ServerList.config获取服务器列表

异步用法：
ServerList.LoadAsync
注册回调：
用法如下
bjm.sdk.global.events.sdk_serverlist_result
bjm.reg.RegLogicFunction(self, bjm.global.function_type.custom, bjm.sdk.global.events.sdk_serverlist_result, self.OnServerListResult)
可能的处理方式:
function XXLogic:OnServerListResult(name, ret)
	local success = ret.success
	if (success == true) then
		-- 成功获取serverlist，直接取bjm.sdk.ServerList.config就可以了
    else
    	releaselog("no server list found")
	end	
end
]]

local sdk = bjm.sdk

sdk.ServerList = {}
sdk.ServerList.config = nil



local ServerList = sdk.ServerList


local server_list_config = "server_list_config"
local server_list_conn = "server_list_conn"
local server_list_zip_conn = "server_list_zip_conn"
local local_server_list_version = "local_server_list_version"

--[[------------------------------------------------------------------------------
-**
default position is:
gamereshome:dataconfig/server_list.json
*]]
ServerList.LoadFromPackage = function ()
	ServerList.config = bjm.data.json.AddConfigFile(server_list_config, "gamereshome:dataconfig/server_list.json", false)

	SendError(bjm.global.err.fail_to_retrieve_serverlist)	
end

--[[------------------------------------------------------------------------------
-**
load from remote
*]]
-- ServerList.LoadFromRemote = function ()
-- 	if (bjm.sdk.RemoteConfig.data.dynamicConfigUrl == "") then
-- 		releaselog("ServerList:dynamicConfigUrl not set")
-- 		return
-- 	end

-- 	local url = bjm.sdk.RemoteConfig.data.dynamicConfigUrl .. 
-- 	"/version/" .. bjm.util.config.GetAppCode() .. "/client/" .. 
-- 	bjm.util.config.GetOperator() .. "/" .. 
-- 	bjm.util.config.GetSSFString() .. "/server_list.json?" .. bjm.sdk.RemoteConfig.data.serverListVersion

-- 	-- send message
-- 	bjm.util.SetUseLockWhenPush(false)
-- 	local success, data = bjm.net.http.QueryStringSync(server_list_conn, url, "", "")
-- 	bjm.util.SetUseLockWhenPush(true)
-- 	if (success == true) then
-- 		-- load server list first
-- 		ServerList.config = bjm.data.json.AddConfigString(server_list_config, data, false)
-- 		if (ServerList.config ~= nil) then
-- 			-- save file
-- 			success = bjm.util.io.WriteFile("bjmsdkcachehome:server_list.json", data)
-- 			if (success == true) then
-- 				-- save to cache
-- 				bjm.sdk.cache.SetValue(local_server_list_version, bjm.sdk.RemoteConfig.data.serverListVersion)
-- 				return true
-- 			end	
-- 		end
-- 	end

-- 	return false
-- end

--[[------------------------------------------------------------------------------
-**
show waiting
*]]
local function ShowWaiting()
	if (ServerList.funcShowWaiting ~= nil) then
		ServerList.funcShowWaiting()
	else
		bjm.ui.system.ShowWaiting(GetSDKString(bjm.sdk.global.strings.sdk_serverlist_waiting))
	end
end

--[[------------------------------------------------------------------------------
-**
hide waiting
*]]
local function CloseWaiting()
	if (ServerList.funcCloseWaiting ~= nil) then
		ServerList.funcCloseWaiting()
	else
		bjm.ui.system.CloseWaiting()
	end
end

--[[------------------------------------------------------------------------------
-**
load from remote
*]]
ServerList.LoadFromRemoteAsync = function ()

	local cdn = bjm.sdk.RemoteConfig.curHost--bjm.sdk.RemoteConfig.CDNToTry()
	if (cdn == nil) then
	--	releaselog("SERVER_LIST error:All CDN Try Fail")
	--	ServerList.LoadFromLocal()
		return false
	end

	ShowWaiting()

	local url = cdn .. 
	"/version/" .. bjm.util.config.GetAppCode() .. "/client/" .. 
	bjm.util.config.GetOperator() .. "/" .. 
	bjm.util.config.GetSSFString() .. "/server_list.json?" .. bjm.sdk.RemoteConfig.data.serverListVersion
	print(url)
	bp()

	bjm.net.http.SetQueryStringTimeOut(30)
	-- send message 
	bjm.net.http.QueryStringAsync(server_list_conn, url, "", "")
	return true
end

--[[------------------------------------------------------------------------------
-**
load zip from remote
*]]
ServerList.LoadZipFromRemoteAsync = function ()

	local cdn = bjm.sdk.RemoteConfig.curHost--bjm.sdk.RemoteConfig.CDNToTry()
	if (cdn == nil) then
	--	releaselog("SERVER_LIST error:All CDN Try Fail")
	--	ServerList.LoadFromLocal()
		return false
	end

	ShowWaiting()

	local url = cdn .. 
	"/version/" .. bjm.util.config.GetAppCode() .. "/client/" .. 
	bjm.util.config.GetOperator() .. "/" .. 
	bjm.util.config.GetSSFString() .. "/server_list.zip?" .. bjm.sdk.RemoteConfig.data.serverListVersion
	bjm.net.http.SetQueryStringTimeOut(30)
	-- send message 
	bjm.net.http.QueryFileAsync(server_list_zip_conn, url, make_uri(bjm.global.uri.bjm_sdk_cache_home,"server_list.zip"), "")
	return true
end

--[[------------------------------------------------------------------------------
-**
load from cache
*]]
ServerList.LoadFromCache = function ()
	ServerList.config = bjm.data.json.AddConfigFileFromFileSystem(server_list_config, make_uri(bjm.global.uri.bjm_sdk_cache_home,"server_list.json"), false)
end

--[[------------------------------------------------------------------------------
-**
return server list config
*]]
-- ServerList.Load = function ()
-- 	local isDebug = false
-- 	local localServerListVersion = bjm.sdk.cache.GetValue(local_server_list_version)
-- 	releaselog("ServerList:LocalServerListVersion: " .. localServerListVersion .. ", RemoteServerListVersion: " .. bjm.sdk.RemoteConfig.data.serverListVersion)
-- 	if isDebug == false then
-- 		if (localServerListVersion ~= bjm.sdk.RemoteConfig.data.serverListVersion) then
-- 			-- load remote server list
-- 			releaselog("ServerList:try to load server list from server")
-- 			local success = ServerList.LoadFromRemote()
-- 			if (success == true and ServerList.config ~= nil) then
-- 				releaselog("ServerList:success to load server list from server")
-- 				return ServerList.config
-- 			else
-- 				releaselog("ServerList:fail to load server list from server")
-- 			end
-- 		else
-- 			releaselog("ServerList:try to load server list from cache")
-- 			ServerList.LoadFromCache()
-- 			if (ServerList.config ~= nil) then
-- 				releaselog("success to load server list from cache")
-- 				return ServerList.config
-- 			else
-- 				releaselog("ServerList:fail to load server list from cache")
-- 			end
-- 		end
-- 	end

-- 	releaselog("ServerList:load server list from package")
-- 	ServerList.LoadFromPackage()
-- 	if (ServerList.config == nil) then
-- 		releaselog("ServerList:fail to load server list from package!!!")
-- 	end

-- 	return ServerList.config
-- end

--[[------------------------------------------------------------------------------
-**
fail to load from local
*]]
ServerList.LoadFromLocal = function ()
	releaselog("ServerList:try to load server list from cache")
	ServerList.LoadFromCache()
	if (ServerList.config ~= nil) then
		releaselog("ServerList:success to load server list from cache")
		return ServerList.config
	else
		releaselog("ServerList:fail to load server list from cache")
	end

	releaselog("ServerList:load server list from package")
	ServerList.LoadFromPackage()
	if (ServerList.config == nil) then
		releaselog("ServerList:fail to load server list from package!!!")
	end
	return ServerList.config
end

--[[------------------------------------------------------------------------------
-**
push notification
*]]
ServerList.PushNotification = function ()
	local success = (ServerList.config ~= nil)
	bjm.util.PushNotification(bjm.sdk.global.events.sdk_serverlist_result,{success=success})
end

--[[------------------------------------------------------------------------------
-** 
load server_list.zip
*]]
ServerList.OnHttpResultForZip = function (conn, data)
	releaselog("ServerList:OnHttpResult\n")
	CloseWaiting()
	if (data ~= "fail") then
		--unzip server_list.zip
		releaselog("ServerList:Success to get result from remote server\n")
		local unzipSuccess = bjm.util.io.Unzip(data, make_uri(bjm.global.uri.bjm_sdk_cache_home,"") , true)
		if (unzipSuccess == true) then
			releaselog("ServerList:Success unzip server_list.zip\n")
			-- load server list first
			ServerList.config = bjm.data.json.AddConfigFile(server_list_config, make_uri(bjm.global.uri.bjm_sdk_cache_home,"server_list.json"),true)
			if ServerList.config ~= nil then
				releaselog("ServerList:Success load server_list.json\n")
				-- save to cache
				bjm.sdk.cache.SetValue(local_server_list_version, bjm.sdk.RemoteConfig.data.serverListVersion)
				ServerList.PushNotification()
			else
				local msg = "ServerList:Fail load server_list.json"
				if (buglyReportLuaException ~= nil) then
					buglyReportLuaException(msg, nil)
				end
				BJMLuaUtil:DebugMessageBox("lua assert", msg)
				ServerList.LoadFromRemoteAsync()
			end
		else
			local msg = "ServerList:Fail unzip server_list.zip"
		 	
			if (buglyReportLuaException ~= nil) then
				buglyReportLuaException(msg, nil)
			end
			ServerList.LoadFromRemoteAsync()
		end
	else
		local msg = "ServerList:Fail to get result from remote server_list.zip"
		if (buglyReportLuaException ~= nil) then
			buglyReportLuaException(msg, nil)
		end
		ServerList.LoadFromRemoteAsync()
	end
end

--[[------------------------------------------------------------------------------
-** 
load server_list.json
*]]
ServerList.OnHttpResult = function (conn, data)
	releaselog("ServerList:OnHttpResult\n")
	CloseWaiting()
	if (data ~= "fail") then
		releaselog("ServerList:Fail to get result from remote server\n")
		-- load server list first
		ServerList.config = bjm.data.json.AddConfigString(server_list_config, data, false)
		if (ServerList.config ~= nil) then
			-- save file
			success = bjm.util.io.WriteFile(make_uri(bjm.global.uri.bjm_sdk_cache_home,"server_list.json"), data)
			if (success == true) then
				-- save to cache
				bjm.sdk.cache.SetValue(local_server_list_version, bjm.sdk.RemoteConfig.data.serverListVersion)
				ServerList.PushNotification()
				return
			end	
		else
			--ServerList.LoadFromRemoteAsync()
			--return
		end
	else
		--ServerList.LoadFromRemoteAsync()
		--return
	end

	ServerList.LoadFromLocal()
	ServerList.PushNotification()
end

--[[------------------------------------------------------------------------------
-**
return server list config
*]]
ServerList.LoadAsync = function (func_show_waiting, func_hide_waiting)

	ServerList.funcShowWaiting = func_show_waiting
	ServerList.funcCloseWaiting = func_hide_waiting

	local localServerListVersion = bjm.sdk.cache.GetValue(local_server_list_version)
	releaselog("ServerList:LocalServerListVersion: " .. localServerListVersion .. ", RemoteServerListVersion: " .. bjm.sdk.RemoteConfig.data.serverListVersion)
	if (localServerListVersion ~= bjm.sdk.RemoteConfig.data.serverListVersion) then
		-- load remote server list
		releaselog("ServerList:try to load server list from server")
		local success = ServerList.LoadZipFromRemoteAsync()
		if (success == false) then
			local msg = "ServerList:fail to load server list from server cause curHost"
			if (buglyReportLuaException ~= nil) then
				buglyReportLuaException(msg, nil)
			end
		else
			return
		end
	end

	ServerList.LoadFromLocal()
	ServerList.PushNotification()
end