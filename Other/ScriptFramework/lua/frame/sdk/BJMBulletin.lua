--[[
Author : ZangXu @Bojoy 2015
FileName: BJMBulletin.lua
Description: 
用法：
uiconfig目录下必须有BulletinView.layout文件
BulletinView.layout：
View的名字必须为BulletinView, 
LogicClassName和LogicInstanceName必须为BulletinLogic，
webnode名称必须为web_node
不可以有默认的关闭按钮（close）
必须有一个按钮名称为（btn_enter)，用于关闭公告并触发后面的逻辑

可能的形式如下：
<?xml version="1.0" encoding="utf-8" standalone="yes" ?>
<UIList >
	<UI Name="BulletinView" >
		<View Name="DefaultWnd" CascadeColor="0" LocationByAnchor="1" LogicClassName="BulletinLogic" LogicInstanceName="BulletinLogic">
			<Sprite9 Anchor="0.50,0.50" LocalZOrder="-1" Pos="0.00,-68.29" Size="620.07,656.50" Image="gamereshome:image/Sprite9/sprite9_frame_2.png" Inset="60.00,35.00,10.00,10.00" />
			<Sprite9 Anchor="0.50,0.00" Pos="0.00,-42.00" Size="569.92,513.48" Image="gamereshome:image/Sprite9/sprite9_frame_4.png" Inset="30.00,30.00,10.00,10.00" />
			<Button Name="btn_enter" Anchor="0.50,0.50" Pos="0.00,-339.33" Size="210.00,82.00" TouchAction="1" Font="btn_font_30px" ImageNormal="gamereshome:image/BatchSource/common/btn_blue_1.png" LabelType="BM" Text="Enter_Game" TextOffSet="0.00,1.00" UseTitle="1" />
			<Sprite Anchor="0.50,0.50" LocalZOrder="2" Pos="0.00,273.00" Size="640.00,331.00" Image="gamereshome:image/BatchSource/notice/sprite_notice.png" />
			<WebNode Name="web_node" Anchor="0.50,0.50" CascadeColor="0" GridCol="1" GridRow="1" Layout="Grid" LocalZOrder="1" Pos="-270.00,-44.00" ScaleX="0.50" ScaleY="0.50" Size="545.00,510.00" SolidColor="255,128,128" Scale="0.50" URL="" UseBackground="0" />
		</View>

	</UI>
</UIList>


]]

require(bjm.PACKAGE_NAME .. ".util.BJMConfiguration")

local sdk = bjm.sdk
sdk.bulletin = {}
local bulletin = sdk.bulletin
bulletin.version = ""
bulletin.timeRange = ""
bulletin.funcNext = nil

local web_name_name = "web_node"
local ui_name = "BulletinView"	-- "uiconfig/BulletinView.layout"
local logic_name = "BulletinLogic"
local btn_name = "btn_enter"
local ui_uri = make_uri(bjm.global.uri.game_res_home, "uiconfig/" .. ui_name .. ".layout")

------------------------------------- register logic -------------------------------------
bjm.reg.RegModuleFromLua(logic_name, bjm.logic.Logic)
bjm.reg.RegGuiConfig(ui_name, ui_uri)

bulletin.logic = bjm.reg.GetModule("BulletinLogic")

------------------------------------- exposed functions -------------------------------------
bulletin.Init = function (version, time_range)
	bulletin.version = version
	bulletin.timeRange = time_range
	bulletin.funcNext = nil
end

--[[------------------------------------------------------------------------------
-**
check if we need show bulletin
*]]
bulletin.CheckNeedShow = function ()
	local timeTable = string.split(bulletin.timeRange, "_")
	if (#timeTable ~= 2 or timeTable[1] == nil or timeTable[2] == nil) then
		releaselog("bulletin: invalid time format")
		return false
	end

	local timeFrom = timeTable[1]
	local timeTo = timeTable[2]
	releaselog("timeFrom: " .. timeFrom .. ", timeTo: " .. timeTo)

	local pattern = "%d-%d-%d %d:%d:%d"
	local tickFrom = bjm.util.DateToTimestamp(timeFrom, pattern)
	local tickTo = bjm.util.DateToTimestamp(timeTo, pattern)
	local tickNow = os.time()

	if (tickNow < tickFrom) then
		releaselog("bulletin: not opened")		
		return false
	end

	if (tickNow > tickTo) then
		releaselog("bulletin: expired")
		return false
	end

	return true
end

--[[------------------------------------------------------------------------------
-**
show bulletin
*]]
bulletin.Show = function (func_next)
	-- check ui file exist
	if (bjm.util.io.FileExists(ui_uri) == false) then
		releaselog("bulletin's ui config file is not exist!")
		if (func_next ~= nil) then
			func_next()
		else
			releaselog("bulletin's next function is not assigned!!")
		end
		return
	end

	bulletin.funcNext = func_next
	bjm.ui.manager.OpenLogic(
		{
			ui_name = ui_name,
			use_mask = true,
			use_model = true
		})
end

--[[------------------------------------------------------------------------------
-**
*]]
bulletin.BuildUrl = function ()
	local appCode = bjm.util.config.GetAppCode()
	local opr = bjm.util.config.GetOperator()
	--test
	--local opr = "hwy_android_360"
	local domain = bjm.sdk.RemoteConfig.data.dynamicConfigUrl .. "/GameConfig/" .. appCode ..
		"/bulletin/" .. opr .. ".html?v=" .. bulletin.version
	releaselog("bulletin url: " .. domain)
	return domain
end

------------------------------------- bulletin logic -------------------------------------
--[[------------------------------------------------------------------------------
-**
*]]
function bulletin.logic:ctor()
	self.super.ctor(self)

	bjm.reg.RegLogicFunction(self, bjm.global.function_type.click_up, btn_name, self.OnEnterClick)
end

--[[------------------------------------------------------------------------------
-**
*]]
function bulletin.logic:OnLoaded()
	self.super.OnLoaded(self)

	self.webNode = tolua.cast(self:GetNodeByName(web_name_name), "BJMWebNode")

	if (self.webNode == nil) then
		releaselog("bulletin's view don't have node named web_node!")
		return
	end

	local url = bulletin.BuildUrl()
	self.webNode:ShowUrl(url)
end

--[[------------------------------------------------------------------------------
-**
*]]
function bulletin.logic:OnDestroy()
 	self.super.OnDestroy(self)
end

--[[------------------------------------------------------------------------------
-**
*]]
function bulletin.logic:OnEnterClick()
	if (bulletin.funcNext ~= nil) then
		self:Close()
		bulletin.funcNext()
	else
		releaselog("bulletin's next function is not assigned!!")
	end
end