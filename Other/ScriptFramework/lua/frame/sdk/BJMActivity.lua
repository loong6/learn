--[[
Author : ZangXu @Bojoy 2014
FileName: BJMActivity.lua
Description: 
用法：
1.使用activity.SetRemoteVersion(remoteVersion)设置活动最新版本号
2.使用activity.SetCDN(cdn)设置活动http地址，设置到/dynData前面一段
3.调用activity.Load(func_show_waiting, func_hide_waiting)，参数为两个等待的UI函数，如果指定，则使用传入函数，否则使用系统的等待gui
4.外部注册bjm.sdk.global.events.sdk_activity_result，参数为success=？，通过该参数判断活动加载是否成功
5.获取活动信息：
activity.menu：菜单信息
activity.all：所有活动信息
activity.try_cdns:尝试轮询访问的活动cdn列表
activity.isTry：是否是轮询访问cdn  默认为false
]]

local sdk = bjm.sdk

sdk.activity = {}

local activity = sdk.activity
activity.remoteVersion = ""
activity.try_cdns = {}
activity.isTry = false
activity.cdn = ""
activity.menu = nil
activity.all = nil
activity.funcShowWaiting = nil
activity.funcCloseWaiting = nil

local server_list_config = "server_list_config"
local activity_conn = "activity_conn"
local local_activity_version = "local_activity_version"

--[[------------------------------------------------------------------------------
-**
set remote activity version
*]]
activity.SetRemoteVersion = function (remoteVersion)
	activity.remoteVersion = remoteVersion
end

--[[------------------------------------------------------------------------------
-**
set activity cdn
*]]
activity.SetCDN = function (cdn)
	activity.cdn = cdn
end

--[[------------------------------------------------------------------------------
-**
set activity Try cdns
*]]
activity.SetTryCDNs = function (  )
	local cdn = activity.cdn
	if cdn == "" then return end

	local strA = "http://"
	local strB = string.gsub(cdn , strA , "")
	local strB_table = string.split(strB , "/")
	local strB_First = strB_table[1]
	local strC = ""
	for i,v in ipairs( strB_table) do
		if i ~= 1 then
			strC =   strC .. "/" .. v 
		end
	end

	local try_table = string.split(bjm.sdk.RemoteConfig.data.backupDomainList , ",")
	for i,v in ipairs(try_table) do
		if v ~= strB_First then
			local tryStr = strA .. v .. strC
			table.insert(activity.try_cdns , tryStr)
		end
	end	
end

--[[------------------------------------------------------------------------------
-**
read local activity version
*]]
activity.ReadLocalVersion = function ()
	return bjm.sdk.cache.GetValue(local_activity_version .. "_" .. bjm.sdk.manager.serverID)
end

--[[------------------------------------------------------------------------------
-**
write local activity version
*]]
activity.WriteLocalVersion = function (local_version)
	bjm.sdk.cache.SetValue(local_activity_version .. "_" .. bjm.sdk.manager.serverID, local_version)
end

--[[------------------------------------------------------------------------------
-**
show waiting
*]]
local function ShowWaiting()
	if (activity.funcShowWaiting ~= nil) then
		activity.funcShowWaiting()
	else
		bjm.ui.system.ShowWaiting(GetSDKString(bjm.sdk.global.strings.sdk_activity_waiting))
	end
end

--[[------------------------------------------------------------------------------
-**
hide waiting
*]]
local function CloseWaiting()
	if (activity.funcCloseWaiting ~= nil) then
		activity.funcCloseWaiting()
	else
		bjm.ui.system.CloseWaiting()
	end
end

--[[------------------------------------------------------------------------------
-**
*]]
local function Directory()
	local directory = "bjmsdkcachehome:" .. bjm.sdk.manager.serverID
	return directory
end

--[[------------------------------------------------------------------------------
-**
prepare
*]]
activity.Prepare = function ()
	if (bjm.util.io.DirectoryExists(Directory()) == false) then
		local success = bjm.util.io.CreateDirectory(Directory())
		if (success == false) then
			releaselog("activity error: fail to create activity directory!")
			return false
		end
	end

	return true
end

--[[------------------------------------------------------------------------------
-**
push notification
*]]
activity.PushNotification = function (success)
	bjm.util.PushNotification(bjm.sdk.global.events.sdk_activity_result,{success=success})
end

--[[------------------------------------------------------------------------------
-**
load from remote By Default CDN
*]]
activity.LoadFromRemote = function ()
	if (activity.cdn == "") then
		releaselog("activity error: activity's cdn not set")
		return
	end

	if (bjm.sdk.manager.serverID == "") then
		releaselog("activity error: server id not set")
		return
	end

	local url = activity.cdn .. "/dynData/" .. bjm.sdk.manager.serverID .. "/ploy.zip?v=" .. activity.remoteVersion
	releaselog("activity log: load From :"  .. url .. "\n")
	-- send message
	ShowWaiting()
	bjm.net.http.QueryFileAsync(activity_conn, url, Directory() .. "/ploy.zip", "", "")
end


--[[------------------------------------------------------------------------------
-**
load from remote  By backup_domain_list CDN
*]]
activity.LoadFromRemoteTry = function (  )

	if #activity.try_cdns == 0 then
		releaselog("activity error:All CDN Try Fail")
		activity.PushNotification(false)
		return
	end

	if (bjm.sdk.manager.serverID == "") then
		releaselog("activity error: server id not set")
		activity.PushNotification(false)
		return
	end

	local curCdn = activity.try_cdns[1] 
	table.remove(activity.try_cdns , 1)


	local url = curCdn .. "/dynData/" .. bjm.sdk.manager.serverID .. "/ploy.zip?v=" .. activity.remoteVersion
	releaselog("activity log: load From :"  .. url .. "\n")

	-- send message
	ShowWaiting()
	bjm.net.http.QueryFileAsync(activity_conn, url, Directory() .. "/ploy.zip", "", "")
end


--[[------------------------------------------------------------------------------
-**
on activity ret
*]]
activity.OnActivityRet = function(connName, data)
	releaselog("on activity ret")

	CloseWaiting()	
	if (data == "fail") then
		if activity.isTry == true then
			activity.LoadFromRemoteTry()
		else
			releaselog("activity error: http fail")
			activity.PushNotification(false)
		end
		return
	end

	-- extract activities to bjmsdkcachehome
	local unzipSuccess = bjm.util.io.Unzip(data, Directory(), true)
	if (unzipSuccess == false) then
		if activity.isTry == true then
			activity.LoadFromRemoteTry()
		else
			releaselog("activity error: unzip fail")
			activity.PushNotification(false)
		end
		return
	end

	local success = activity.LoadFromCache()
	if (success) then
		activity.WriteLocalVersion(activity.remoteVersion)
		activity.PushNotification(true)
	else
		releaselog("activity error: load from cache error")
		activity.PushNotification(false)
	end
end

--[[------------------------------------------------------------------------------
-**
load from cache
*]]
activity.LoadFromCache = function ()
	local menu = luaxml.load(Directory() .. "/ployMenu.xml", 1)
	activity.menu = menu

	if (activity.menu == nil) then
		releaselog("fail to load activity from cache")
		return false
	end

	activity.all = {}

	releaselog("success to load activity from cache")
	for i = 1, #activity.menu, 1 do
		local desc = activity.menu[i]
		local id = desc.b
		local uri = Directory() .. "/" .. id .. ".xml"
		local _activty = luaxml.load(uri, 1)
		if (_activty == nil) then
			releaselog("fail to load activty: " .. id)
		else
			activity.all[id] = _activty
		end
	end
	--dump(activity.menu, "activity.menu")
	--dump(activity.all, "activity.all")

	return true
end

--[[------------------------------------------------------------------------------
-**
no return
*]]
activity.Load = function (func_show_waiting, func_hide_waiting)
	activity.SetTryCDNs()

	activity.funcShowWaiting = func_show_waiting
	activity.funcCloseWaiting = func_hide_waiting

	if (activity.Prepare() == false) then
		activity.PushNotification(false)
		return
	end

	local localActivityVersion = activity.ReadLocalVersion()
	releaselog("LocalActivityVersion: " .. localActivityVersion .. ", remoteVersion: " .. activity.remoteVersion)
	if (localActivityVersion ~= activity.remoteVersion) then
		-- load remote activity
		if #activity.try_cdns > 0 then
			releaselog("\ntry to load activity from server  -------- use GOIS backup_domain_list cdn\n")
			activity.isTry = true
		else
			releaselog("\ntry to load activity from server  -------- use server Default cdn\n")
			activity.isTry = false
		end
		activity.LoadFromRemote()
	else
		releaselog("try to load activity from cache")
		local success = activity.LoadFromCache()
		activity.PushNotification(success)
	end
end