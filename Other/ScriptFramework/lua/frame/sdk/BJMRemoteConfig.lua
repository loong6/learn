--[[
Author : ZangXu @Bojoy 2014
FileName: BJMRemoteConfig.lua
Description: 
module.data.enablePay (enable_pay)
module.data.resUrl (res_url)
module.data.resVersion (res_version)
module.data.newestVersion (app_version)
module.data.updateType (update_type)
0: no update
1: force update
2: normal update
module.data.downloadUrl (app_download_url)
module.data.gamDomain (domain_gam)
module.data.apnsDomain(domain_apns)
module.data.preStatus (pre_status)
module.data.reviewStatus (review_status)
module.data.proxyDomain (domain_proxy)
module.data.dynamicConfigUrl (domain_dyn_conf)
module.data.serverListVersion (server_list_version)
module.data.reportGam (gam_report)
module.data.kefuUrl(mobile_kf_url)
module.data.serviceUrl(url_kefu)
module.data.crashReportDomain(domain_crash)
module.data.bulletinVersion (version_bulletin)
module.data.bulletinTimeRange (bulletin_date) [公告开始结束时间 2014-07-15 00:00:00_2014-07-16 10:00:00]
module.data.useCDNAccelerate (use_cdn_accelerate)

]]

---BJMRemoteConfig
-- @module bjm.sdk.RemoteConfig
-- @alias module

require(bjm.PACKAGE_NAME .. ".sdk.BJMGAM")
require(bjm.PACKAGE_NAME .. ".sdk.BJMBulletin")
require(bjm.PACKAGE_NAME .. ".sdk.BJMAppUpdate")

local sdk = bjm.sdk

sdk.RemoteConfig = {}
local module = sdk.RemoteConfig
module.data = {}

--[[------------------------------------------------------------------------------
init current module
]]
module.Init = function()
	module.cdns 	= nil
	module.try 		= 1
	module.curHost 	= nil
	module.lastIndex= 0
end

--[[------------------------------------------------------------------------------
prepare cdn candidates from local list
]]
module.PrepareCDN = function()
	releaselog("BJMEngine: Prepare cdns...")
	if (module.cdns ~= nil) then
		do return true end
	end

	local cdnsJson = bjm.data.json.AddConfigFile("cdns", bjm.global.uri.bjm_game_sdk_home .. ":cdns.json", false)
	if (cdnsJson == nil) then
		releaselog("fail to load local cdns description")
		do return false end
	end

	local hosts = cdnsJson.host
	module.cdns = string.split(hosts, ",")
	if (module.cdns == nil) then
		releaselog("fail to parse local cdns description")
		do return false end
	else
		releaselog("success to parse local cdns description")
		dump(module.cdns, "module.cdns")	
	end

	do return true end
end

--[[------------------------------------------------------------------------------
-**
*]]
module.ResetCDNToTry = function()
	module.try = 1
end

--[[------------------------------------------------------------------------------
try next cdn
]]
module.CDNToTry = function()
	local hostsCount = #module.cdns
	if (module.try > hostsCount) then
		do return nil end
	end

	if module.try == 1 and module.lastIndex ~= 0 then
		return module.curHost
	end

	local curIndex = module.lastIndex + 1
	if curIndex == hostsCount + 1 then
		curIndex = 1
	end

	local ret = module.cdns[curIndex]
	module.curHost 	= ret
	module.lastIndex= curIndex 
	module.try = module.try + 1
	do return ret end
end


--[[------------------------------------------------------------------------------
get IsReviewStatus
]]
module.IsReviewStatus = function()
	local isReviewStatus= false

	local newestVersion = bjm.sdk.RemoteConfig.data.newestVersion
	local currentVersion= bjm.util.config.GetAppVersion()

	local isOld = bjm.sdk.AppUpdate.ValidVersionIsOld(newestVersion, currentVersion)

	if isOld == true and bjm.sdk.RemoteConfig.data.reviewStatus == true then
		isReviewStatus = true
	end

	return isReviewStatus
end
--[[------------------------------------------------------------------------------
get IsNeedGetPatches(Only used in review status is open)
]]
module.IsNeedNotGetPatches = function()
	return module.data.unPatches
end

--[[------------------------------------------------------------------------------
set resPath
]]
module.SetResPath = function()
	if (module.data.resUrl == "") then
		module.data.resPath = ""
		return
	end

	local strUrl 	= string.gsub(module.data.resUrl , "http://" , "")
	local urlConfigs= string.split(strUrl , "/")
	local strResPath= ""
	for i,v in ipairs(urlConfigs) do
		if i ~= 1 and v ~= nil and v ~= "" then
			strResPath =   strResPath .. v .. "/"
		end
	end
	module.data.resPath = strResPath
end

--[[------------------------------------------------------------------------------
PrePare Res CDN List
]]
module.PrepareResCDNList = function()
	module.data.cndtable = {}
	if module.data.cdnlist == nil then return end
	if module.data.cdnlist == "" then return end
	local lists = string.split(module.data.cdnlist, ",")
	for i, v in ipairs(lists) do
		local config = string.split(v, "$")
		local cdnItem = { 
					name 	= config[1],
					cdnurl 	= config[2]
					}
		table.insert(module.data.cndtable, cdnItem)
	end
end

--[[------------------------------------------------------------------------------
send w001 message
]]
module.SendW001 = function()
	bjm.sdk.gam.Report(bjm.global.gam.send_w001)

	local success = module.PrepareCDN()
	if (success == false) then
		SendError(bjm.global.err.fail_to_prepare_cdn)
		do return false end
	end

	local cdn = module.CDNToTry()
	if (cdn == nil) then
		releaselog("all cdn candidates fail")
		bjm.sdk.manager.OnW001Fail()
		do return false end
	end

	cdn = "http://" .. cdn

	-- prepare message
	local appVersion = bjm.util.config.GetAppVersion()
	local appCode = bjm.util.config.GetAppCode()
	local pc = bjm.util.config.GetOperator()
	local ssf = bjm.util.config.GetSSFString()
	local time = tostring(os.time())

	local url = cdn .. "/version/" .. appCode .. "/client/" .. pc .. "/" .. ssf .. "/clientConf.json?" .. time

	-- set timeout message
	bjm.net.http.SetQueryStringTimeOut(15)
	-- send message
	bjm.net.http.QueryStringAsync("w001", url, "", "")

	local isUseOffline = bjm.util.config.GetUseOffline()
	if (isUseOffline == false) then
		bjm.ui.system.ShowWaiting(bjm.util.GetSDKString(bjm.sdk.global.strings.w001_waiting))
	end	

	do return true end
end

module.CheckStatusInfo = function(statusContent, defaultValue)
	if statusContent == nil then
		return defaultValue
	end
	if tonumber(statusContent) == 0 then
		return false
	end
	return true
end

--[[------------------------------------------------------------------------------
receive w001 message
]]
module.ReceiveW001 = function(content)
	bjm.sdk.gam.Report(bjm.global.gam.receive_w001)

	local w001Json = bjm.data.json.AddConfigString("w001", content, false)

	if (w001Json == nil) then
		releaselog("Error: bad w001 return!")
		module.SendW001()
		return false
	end
	if (w001Json.update_type == nil) then
		w001Json.update_type = 0
	end

	bjm.sdk.gam.Report(bjm.global.gam.parse_w001_success)
	
	module.data.enablePay 			= module.CheckStatusInfo(w001Json.enable_pay, true)
	module.data.resUrl 				= w001Json.res_url or ""
	module.data.resVersion 			= tonumber(w001Json.res_version) or 0
	module.data.newestVersion 		= w001Json.app_version or "0.0.0"
	module.data.updateType 			= tonumber(w001Json.update_type) or 0
	module.data.downloadUrl 		= w001Json.app_download_url or ""
	module.data.preStatus 			= module.CheckStatusInfo(w001Json.pre_status, false)
	module.data.reviewStatus 		= module.CheckStatusInfo(w001Json.review_status, false)
	module.data.useCDNAccelerate 	= module.CheckStatusInfo(w001Json.use_cdn_accelerate, false)
	module.data.backupDomainList    = w001Json.backup_domain_list or ""
	module.data.dynamicConfigUrl 	= w001Json.domain_dyn_conf or ""
	module.data.serverListVersion 	= w001Json.server_list_version or "00000000"
	module.data.kefuUrl				= w001Json.mobile_kf_url or ""
	module.data.serviceUrl 			= w001Json.url_kefu or ""
	module.data.sdkType				= w001Json.sdk_type or ""
	module.data.wapRecharge			= w001Json.wap_recharge or ""
	module.data.reportGam 			= module.CheckStatusInfo(w001Json.gam_report, false)
	module.data.gamDomain 			= w001Json.domain_gam or ""
	module.data.proxyDomain 		= w001Json.domain_proxy or ""
	module.data.apnsDomain 			= w001Json.domain_apns or "http://mobile.apns.9917.com"
	module.data.crashReportDomain 	= w001Json.crash_domain or ""
	module.data.bulletinVersion 	= w001Json.version_bulletin or ""
	module.data.bulletinTimeRange 	= w001Json.bulletin_date
	module.data.cdnlist 			= w001Json.cdn_list or ""
	module.data.cdnDNSPodApi 		= w001Json.cdn_dnspod_api or ""
	module.data.openHttps			= module.CheckStatusInfo(w001Json.open_https, false)
	module.data.unPatches			= module.CheckStatusInfo(w001Json.open_notuse_patches, false)

	if (bjm.util.config.GetUseInner() == true) then module.data.openHttps = false end
	
	bjm.net.http.SetUseHttps(false)--module.data.openHttps)
	module.SetResPath()
	module.PrepareResCDNList()
	if (bjm.util.IsWin32() == true) then
		module.data.reportGam = false
	end
	
	if module.data.apnsDomain == "" then
		module.data.apnsDomain = "http://mobile.apns.9917.com"
	end
	if (string.sub(module.data.apnsDomain, 1, 7) ~= "http://") then
		module.data.apnsDomain = "http://" .. module.data.apnsDomain
	end
	
	if (module.data.proxyDomain ~= "" and string.sub(module.data.proxyDomain, 1, 7) == "http://") then
		module.data.proxyDomain = string.sub(module.data.proxyDomain, 8, string.len(module.data.proxyDomain))
	end

	-- init gam here
	bjm.sdk.gam.Init(module.data.reportGam)
	bjm.sdk.gam.SetGamDomain(module.data.gamDomain)

	-- crash domain
	--if (bjm.util.config.GetUseCrashReport() == true) then
	--	BJMCrashServer:Instance():SetGAMDomain(module.data.crashReportDomain)
	--end

	-- bulletins
	bjm.sdk.bulletin.Init(module.data.bulletinVersion, module.data.bulletinTimeRange)

	dump(module.data, "remote config data")

	local isUseOffline = bjm.util.config.GetUseOffline()
	if (isUseOffline == false) then
		bjm.ui.system.CloseWaiting()
	end

	-- by lituo
	-- save raw w001 json table, hwy may read extra data configed from oss
	module.data.w001Json = w001Json
	
	return true
end

