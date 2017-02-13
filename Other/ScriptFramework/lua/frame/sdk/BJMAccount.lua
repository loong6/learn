--[[
Author : ZangXu @Bojoy 2014
FileName: BJMAccount.lua
Description: 
]]

require(bjm.PACKAGE_NAME .. ".sdk.BJMSDKManager")

local sdk = bjm.sdk
sdk.account = {}
local account = sdk.account

--[[------------------------------------------------------------------------------
-**
login
*]]
account.Login = function(sid)
	releaselog("bjm.sdk.account.Login............")
	if (sid == nil) then sid = "" end
	local proxyParams = BJMProxyUtil:NewBJMProxyParams()	

	proxyParams:AddParam("server_id", sid)
	BJMProxyUtil:OnGameToProxyEventLua("event_login", proxyParams)
	BJMProxyUtil:ReleaseBJMProxyParams(proxyParams)

	bjm.sdk.manager.SetServerID(sid)
end

--[[------------------------------------------------------------------------------
-**
log out
*]]
account.Logout = function()
	bjm.sdk.proxy.Logout()
end

--[[------------------------------------------------------------------------------
-**
Switch Account
*]]
account.SwitchAccount = function()
	bjm.sdk.proxy.Logout()
end

--[[------------------------------------------------------------------------------
-**
*]]