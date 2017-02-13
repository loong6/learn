--[[
Author : ZangXu @Bojoy 2014
FileName: BJMGuiManager.lua
Description: 
]]

---BJMGuiManager
-- @module bjm.ui.manager
-- @alias ui.manager

local ui = bjm.ui

ui.manager = {}

local instance = nil

local function Instance()
	if (instance ~= nil) then do return instance end end
	return BJMGuiServer:Instance()
end

--[[------------------------------------------------------------------------------
get value from params
[logic_name][logic_class_name][ui_name][pos][use_model][use_mask][zorder]
[logic_instance][style][node_parent][composite_parent][data][notity_zorder]
]]
ui.manager.Value = function (params, key)
	local ret = nil
	if (key == "logic_name") then
		ret = params.logic_name or ""

	elseif (key == "logic_class_name") then
		ret = params.logic_class_name or ""

	elseif (key == "ui_name") then
		ret = params.ui_name or ""

	elseif (key == "pos") then
		ret = params.pos or bjm.global.zero.point

	elseif (key == "use_model") then
		if (params.use_model ~= nil) then
			ret = params.use_model
		else
			ret = true
		end

	elseif (key == "use_mask") then
		if (params.use_mask ~= nil) then
			ret = params.use_mask
		else
			ret = true
		end

	elseif (key == "zorder") then
		ret = params.zorder or 0

	elseif (key == "notify_zorder") then
		ret = params.notify_zorder or 0

	elseif (key == "logic_instance") then
		ret = params.logic_instance or nil

	elseif (key == "confirm_name") then
		ret = params.confirm_name or ""

	elseif (key == "content") then
		ret = params.content or ""

	elseif (key == "use_not_show_next") then
		if (params.use_not_show_next ~= nil) then
			ret = params.use_not_show_next
		else
			ret = false
		end

	elseif (key == "button_titles") then
		ret = params.button_titles or {}
	elseif (key == "callback") then
		ret = params.callback or nil

	elseif (key == "style_instance") then
		ret = params.style_instance or nil

	elseif (key == "style_name") then
		ret = params.style_name or ""

	elseif (key == "node_parent") then
		ret = params.node_parent or nil

	elseif (key == "composite_parent") then
		ret = params.composite_parent or nil

	elseif (key == "data") then
		ret = params.data or {}

	elseif (key == "node_name") then
		ret = params.node_name or ""

	end
	do return ret end
end

local Value = ui.manager.Value

--[[------------------------------------------------------------------------------
start first scene
@param params
[logic_name][logic_class_name][ui_name][data*]
@return logic instance created
]]
ui.manager.StartFirstScene = function(params)
	local ui_name = Value(params, "ui_name")
	return Instance():StartFirstScene(
		Value(params, "logic_name"),
		Value(params, "logic_class_name"),
		ui_name, ui_name,
		Value(params, "data")
		)
end

--[[------------------------------------------------------------------------------
repalce scene
@param params
[logic_name*][logic_class_name*][ui_name][data*]
@return logic instance created
]]
ui.manager.ReplaceScene = function(params)
	local ui_name = Value(params, "ui_name")
	return Instance():ReplaceSceneWithNewUI(
		Value(params, "logic_name"),
		Value(params, "logic_class_name"),
		ui_name, ui_name,
		Value(params, "data"))
end

--[[------------------------------------------------------------------------------
push scene
@param params
[logic_name*][logic_class_name*][ui_name][data*]
@return logic instance created
]]
ui.manager.PushScene = function(params)
	local ui_name = Value(params, "ui_name")
	return Instance():PushSceneWithNewUI(
		Value(params, "logic_name"),
		Value(params, "logic_class_name"),
		ui_name, ui_name,
		Value(params, "data"))
end

--[[------------------------------------------------------------------------------
pop scene
]]
ui.manager.PopScene = function()
	Instance():PopScene()
end

--[[------------------------------------------------------------------------------
close logic
@param params
([logic_name] | [logic_instance])
]]
ui.manager.CloseLogic = function(params)
	local logic_name = Value(params, "logic_name")
	local logic_instance = Value(params, "logic_instance")
	if logic_name ~= "" then
		Instance():CloseLogicByName(logic_name)
	else
		Instance():CloseLogicByLogic(logic_instance)
	end
end

--[[------------------------------------------------------------------------------
close logic by name
logic_name
]]
ui.manager.CloseLogicByName = function(logic_name)
	Instance():CloseLogicByName(logic_name)
end

--[[------------------------------------------------------------------------------
close logic by logic instance
logic_instance
]]
ui.manager.CloseLogicByInstance = function(logic_instance)
	Instance():CloseLogicByLogic(logic_instance)
end

--[[------------------------------------------------------------------------------
open logic
@return the logic instance created
@param params
[ui_name]
[logic_name*][logic_class_name*][data*]
[pos*][use_model*][use_mask*][zorder*][notify_zorder*]
]]
ui.manager.OpenLogic = function(params)
	local ui_name = Value(params, "ui_name")
	return Instance():OpenLogic(
		Value(params, "logic_name"),
		Value(params, "logic_class_name"),
		ui_name, ui_name,
		Value(params, "pos"),
		Value(params, "use_model"),
		Value(params, "use_mask"),
		Value(params, "zorder"),
		Value(params, "notify_zorder"),
		Value(params, "data")
		)
end

--[[------------------------------------------------------------------------------
open confirm logic
@return the logic instance created
@param params
[ui_name][confirm_name][content][callback][data*]
[*button_titles][logic_name*][logic_class_name*][pos*][use_not_show_next*]
callback: lua function | signature: function class.callback(confirm_name, button_index)
button_titles: a table of button titles
]]
ui.manager.OpenConfirmLogic = function(params)
	local ui_name = Value(params, "ui_name")
	return Instance():OpenConfirmLogic(
		Value(params, "logic_class_name"),
		ui_name, ui_name,
		Value(params, "pos"),
		Value(params, "confirm_name"),
		Value(params, "content"),
		Value(params, "use_not_show_next"),
		Value(params, "callback"),
		Value(params, "button_titles"),
		Value(params, "data")
		)
end

--[[------------------------------------------------------------------------------
get string
]]
ui.manager.GetString = function (key)
	do return Instance():GetString(key) end
end

--[[------------------------------------------------------------------------------
set mask color (color 4f)
]]
ui.manager.SetMaskColor = function (color4f)
	Instance():SetMaskColor(color4f)
end

--[[------------------------------------------------------------------------------
get mask color (color 4f)
]]
ui.manager.GetMaskColor = function ()
	do return Instance():GetMaskColor() end
end

--[[------------------------------------------------------------------------------
create node by style instance
@param params
([style_instance] | [style_name])
[node_parent*][logic_instance*][composite_parent*][node_name*]
@return node(BJMNode) created
]]
ui.manager.CreateNodeFromStyle = function(params)
	local style_name = Value(params, "style_name")
	local style_instance = Value(params, "style_instance")
	if (style_name ~= "") then
		style_instance = ui.manager.GetStyle(style_name)
	end

	if (style_instance == nil) then do return nil end end

	do return Instance():CreateNodeByNodeConfig(
		style_instance,
		Value(params, "node_parent"),
		Value(params, "logic_instance"),
		Value(params, "composite_parent"),
		nil,
		true,
		Value(params, "node_name")
	) end
end

--[[------------------------------------------------------------------------------
get style from dict
@return style instance(BJMXmlNode)
]]
ui.manager.GetStyle = function(style_name)
	local _style_name = style_name
	if (type(style_name) == "table") then
		_style_name = style_name.style_name or ""
	end
	do return Instance():GetStyleConfigByName(_style_name, bjm.global.config.game_uidict) end
end


--[[------------------------------------------------------------------------------
change the node parent node 
]]
ui.manager.ChangeNodeParent = function ( node, newParent )
	if node==nil then return end
	if newParent==nil then return end
	node:retain()
	node:removeFromParent()
	newParent:addChild(node)
	node:release()
end

--[[------------------------------------------------------------------------------
set use batch render
!!!!important: only work on debug mode
]]
ui.manager.SetUseBatchRender = function (use)
	Instance():SetUseBatchRender(use)
end

--[[------------------------------------------------------------------------------
-**
set default font name
*]]
ui.manager.SetDefaultFontName = function (font_name)
	Instance():SetDefaultFontName(font_name)
end

--[[------------------------------------------------------------------------------
-**
save to file
*]]
ui.manager.SaveToFile = function (node, uri)
	BJMLuaUtil:SaveToFile(node, uri)
end

--[[------------------------------------------------------------------------------
-**
enable or disable node's touch
*]]
ui.manager.EnableNodeTouch = function (node_name, enable, composite_name)
	composite_name = composite_name or ""
	if (enable == true) then
		BJMHitTestUtil:EnableNode(node_name, composite_name)
	else
		BJMHitTestUtil:DisableNode(node_name, composite_name)
	end
end

--[[------------------------------------------------------------------------------
-**
enable all node's touch
*]]
ui.manager.EnableAllNodesTouch = function ()
	BJMHitTestUtil:EnableAllNodes()
end

--[[------------------------------------------------------------------------------
-**
node touch is disabled??
*]]
ui.manager.NodeTouchIsEnabled = function (node_name, composite_name)
	composite_name = composite_name or ""
	return BJMHitTestUtil:NodeIsEnabled(node_name, composite_name)
end