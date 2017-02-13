--[[
Author : ZangXu @Bojoy 2014
FileName: BJMGAM.lua
Description: 
]]

require(bjm.PACKAGE_NAME .. ".util.BJMDevice")
require(bjm.PACKAGE_NAME .. ".util.BJMConfiguration")
require(bjm.PACKAGE_NAME .. ".net.BJMHttpManager")
require(bjm.PACKAGE_NAME .. ".sdk.BJMSDKConstant")

local sdk = bjm.sdk

sdk.gam = {}

local gam = sdk.gam
gam.inited = false

local local_first_report_time = "gam_first_report_time"
local local_gam_step = "gam_step"
local local_gam_guid = "gam_guid"
local min_step = -100
local gam_conn = "gam_conn"
local game_start_step = 50
local gam_domain_default = GAM_DOMAIN_DEFAULT or "http://gam.9917.com" --GAM_DOMAIN_DEFAULT should set before core/app.lua require("bjm.BJMInit")


--[[------------------------------------------------------------------------------
-**
init basic params
*]]
gam.Init = function (report)
	gam.report = report

	if (gam.inited == false) then
		gam.appID = bjm.util.config.GetAppID()
		gam.serverID = ""
		gam.osCode = bjm.util.device.GetOSCode()
		gam.roleName = ""
		gam.appVersion = bjm.util.config.GetAppVersion()
		gam.mac = bjm.util.device.GetMac()
		gam.os = bjm.util.device.GetOS()
		gam.model = bjm.util.device.GetModel()
		gam.operator = bjm.util.config.GetOperator()
		gam.domain = gam_domain_default
		gam.deviceCode = bjm.util.device.GetCode()
		gam.resolution = bjm.util.device.GetResolution()
		gam.phoneNumber = bjm.util.device.GetPhoneNumber()
		gam.inited = true
		if gam.mac == "" or nil then
			gam.mac = gam.ReadLocalGuid()
		end
	end
	
end

--[[------------------------------------------------------------------------------
-**
set role name
*]]
gam.SetRoleName = function (role_name)
	gam.roleName = role_name

	if (buglySetUserId ~= nil) then
		if gam.roleName and gam.serverID then
			buglySetUserId(gam.serverID.."#"..gam.roleName)
		end
	end
end

--[[------------------------------------------------------------------------------
-**
set server id
*]]
gam.SetServerID = function (server_id)
	gam.serverID = server_id

	if (buglySetUserId ~= nil) then
		if gam.roleName and gam.serverID then
			buglySetUserId(gam.serverID.."#"..gam.roleName)
		end
	end
end

--[[------------------------------------------------------------------------------
-**
set gam domain
*]]
gam.SetGamDomain = function (gam_domain)
	if (gam_domain == "" or gam_domain == nil) then
		do return end
	end
	gam.domain = gam_domain
end

--[[------------------------------------------------------------------------------
-**
read first report time
if first report time is not exist in local, save current time and return this time
*]]
gam.FirstReportTime = function ()
	local needSaveTime = false
	local time = bjm.sdk.cache.GetValue(local_first_report_time)
	if (time == "" or time == nil) then
		time = os.time()
		needSaveTime = true
	end

	if (needSaveTime == true) then
		bjm.sdk.cache.SetValue(local_first_report_time, time)
	end

	return time
end

--[[------------------------------------------------------------------------------
-**
read step from cache
*]]
gam.ReadLocalStep = function ()
	local localStep = bjm.sdk.cache.GetValue(local_gam_step)
	if (localStep == "" or nil) then
		localStep = min_step
	end

	return localStep
end

--[[------------------------------------------------------------------------------
-**
write step from cache
*]]
gam.WriteLocalStep = function (step)
	releaselog("gam: new step: " .. step)
	bjm.sdk.cache.SetValue(local_gam_step, step)
end

--[[------------------------------------------------------------------------------
-**
read Guid from cache
*]]
gam.ReadLocalGuid = function ()
	local localGiud = bjm.sdk.cache.GetValue(local_gam_guid)
	if (localGiud == "" or nil) then
		localGiud = bjm.util.device.GetGuid()
		gam.WriteLocalGuid(localGiud)
	end

	return localGiud
end

--[[------------------------------------------------------------------------------
-**
write Guid from cache
*]]
gam.WriteLocalGuid = function (guid)
	releaselog("gam: new guid: " .. guid)
	bjm.sdk.cache.SetValue(local_gam_guid, guid)
end

--[[------------------------------------------------------------------------------
-**
*]]
gam.Report = function (step)
	if (gam.report == nil or gam.report == false) then
		return
	end

	step = tonumber(step)

	local firstReportTime = gam.FirstReportTime()
	if (firstReportTime == "" or firstReportTime == nil) then
		releaselog("fail to read or save gam report time!")
		return
	end

	local localStep = tonumber(gam.ReadLocalStep())
	if (localStep < step) then
		-- do report
		local url = gam.domain .. "/collect/game/mobileConfig.do?" 
		local post = "time=" .. firstReportTime .. "&productid=" .. gam.appID ..
					"&device=" .. gam.deviceCode .. "&mac=" .. gam.mac .. "&model=" .. gam.model ..
					"&resolution=" .. gam.resolution .. "&os=" .. gam.os ..
					"&number=" .. gam.phoneNumber .. "&state=" .. step ..
					"&updateTime=" .. os.time() .. "&pfcode=" .. gam.operator ..
					"&appversion=" .. gam.appVersion .. "&verifyKey=" .. 
					bjm.util.MakeMD5(firstReportTime .. gam.appID .. gam.mac .. bjm.sdk.global.md5) -- gam.model ..

		bjm.net.http.QueryStringAsync(gam_conn, url, post, "")

		-- write local step
		gam.WriteLocalStep(step)
	end
end

--[[------------------------------------------------------------------------------
-**
*]]
gam.GameReport = function (step)
	step = game_start_step + step
	gam.Report(step)
end