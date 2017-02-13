--[[
Author : ZangXu @Bojoy 2014
FileName: BJMInit.lua
Description: int bjm lua framework
]]

-- cocos 2d initialize
require "cocos2d.Cocos2d"
require "cocos2d.Cocos2dConstants"

local CURRENT_MODULE_NAME = ...
-- declare bjm namespace --
bjm 		= bjm 			or {}
bjm.PACKAGE_NAME = string.sub(CURRENT_MODULE_NAME, 1, -9)

-- declare sub namespaces --
bjm.util 	= bjm.util 		or {}
bjm.ui 		= bjm.ui 		or {}
bjm.logic 	= bjm.logic 	or {}
bjm.app 	= bjm.app 		or {}
bjm.global 	= bjm.global 	or {}
bjm.reg 	= bjm.reg 		or {}
bjm.ani		= bjm.ani		or {}
bjm.data	= bjm.data		or {}
bjm.audio	= bjm.audio		or {}
bjm.sdk		= bjm.sdk		or {}
bjm.net		= bjm.net		or {}
bjm.game    = bjm.game      or {}

bjm.useReleaseMsgBox = false

-- don't mess up require sequence!! --
require(bjm.PACKAGE_NAME .. ".util.BJMUtilInit")
require(bjm.PACKAGE_NAME .. ".global.BJMGlobalConstant")
require(bjm.PACKAGE_NAME .. ".app.BJMAppInit")
require(bjm.PACKAGE_NAME .. ".reg.BJMRegInit")
require(bjm.PACKAGE_NAME .. ".ui.BJMUIInit")
require(bjm.PACKAGE_NAME .. ".logic.BJMLogicInit")
require(bjm.PACKAGE_NAME .. ".ani.BJMAniInit")
require(bjm.PACKAGE_NAME .. ".util.BJMFactory")
require(bjm.PACKAGE_NAME .. ".data.BJMDataInit")
require(bjm.PACKAGE_NAME .. ".audio.BJMAudioInit")
require(bjm.PACKAGE_NAME .. ".sdk.BJMSDKInit")
require(bjm.PACKAGE_NAME .. ".net.BJMNetInit")
require(bjm.PACKAGE_NAME .. ".game.BJMGameInit")

-- add lua error callback
function __G__TRACKBACK__(msg)
	if (msg == nil) then
		do return end
	end

	msg = tostring(msg)
	local stack = debug.traceback()

	local error = "----------------------------------------\n"
	error = error .. msg .. "\n"
	error = error .. stack
	error = error .. "\n----------------------------------------\n"

	cclog(error)
	
	if (buglyReportLuaException ~= nil) then
		buglyReportLuaException(msg, stack)
	end

	if (bjm.useReleaseMsgBox == true) then
		BJMLuaUtil:ReleaseMessageBox("lua error", error)
	else
		BJMLuaUtil:DebugMessageBox("lua error", error)	
	end
    
end

bjm.sdk.gam.Init(true)
bjm.sdk.gam.Report(bjm.global.gam.game_start)




