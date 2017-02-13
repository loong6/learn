--[[
Author : ZangXu @Bojoy 2014
FileName: BJMFactory.lua
Description: 
]]

---BJMFactory
-- @module bjm.util.factory

local util = bjm.util
util.factory = {}
local factory = util.factory

--[[------------------------------------------------------------------------------
create a BJMLogic
]]
factory.Logic = function ()
	do return BJMLogic:Create() end
end

--[[------------------------------------------------------------------------------
create a BJMConfirmLogic
]]
factory.ConfirmLogic = function ()
	do return BJMConfirmLogic:Create() end
end


--[[------------------------------------------------------------------------------
create a BJMMoveLogic
]]
factory.MoveLogic = function ()
	do return BJMMoveLogic:Create() end
end

--[[------------------------------------------------------------------------------
create a BJMMultiplexLogic
]]
factory.MultiplexLogic = function ()
	do return BJMMultiplexLogic:Create() end
end

--[[------------------------------------------------------------------------------
create a BJMScrollLogic
]]
factory.ScrollLogic = function ()
	do return BJMScrollLogic:Create() end
end

--[[------------------------------------------------------------------------------
create a net logic
]]
factory.NetLogic = function ()
	do return BJMLogic:Create() end
end

--[[------------------------------------------------------------------------------
create a sdk logic
]]
factory.SDKLogic = function ()
	do return BJMLogic:Create() end
end

--[[------------------------------------------------------------------------------
create a update logic
]]
factory.UpdateLogic = function ()
	do return BJMUpdateLogic:Create() end
end

--[[------------------------------------------------------------------------------
-**
create a http logic
*]]
factory.HttpLogic = function ()
	do return BJMHttpLogic:Create() end
end

--[[------------------------------------------------------------------------------
get value from params
@param params
[name][size][priority]
]]
factory.Value = function (params, key)
	local ret = nil
	if (key == "name") then
		ret = params.name or ""

	elseif (key == "size") then
		ret = params.size or bjm.global.zero.size

	elseif (key == "priority") then
		ret = params.priority or 0

	elseif (key == "res_id") then
		ret = params.res_id or ""

	elseif (key == "shader_type") then
		ret = params.complete_action or bjm.global.shader.default

	elseif (key == "auto_play") then
		if (params.auto_play ~= nil) then
			ret = params.auto_play
		else
			ret = true
		end
	elseif (key == "loop") then
		if (params.loop ~= nil) then
			ret = params.loop
		else
			ret = false
		end
	elseif (key == "reverse") then
		if (params.reverse ~= nil) then
			ret = params.reverse
		else
			ret = false
		end
	elseif (key == "complete_action") then
		ret = params.complete_action or bjm.global.complete_action.remove

	elseif (key == "playback_event") then
		if (params.playback_event ~= nil) then
			ret = params.playback_event
		else
			ret = true
		end	

	elseif (key == "text") then
		ret = params.text or ""

	elseif (key == "font_size") then
		ret = params.font_size or 24

	elseif (key == "font_name") then
		ret = params.font_name or "simhei"

	elseif (key == "alignment") then
		ret = params.alignment or 0

	elseif (key == "line_width") then
		ret = params.lineWidth or 0

	elseif (key == "vertical_space") then
		ret = params.vertical_space or 0

	elseif (key == "animation_name") then
		ret = params.animation_name or ""

	elseif (key == "frame_index") then
		ret = params.frame_index or ""

	elseif (key == "last_duration") then
		ret = params.last_duration or ""

	elseif (key == "use_event") then
		if (params.use_event ~= nil) then
			ret = params.use_event
		else
			ret = false
		end
	elseif (key == "res_json") then
		ret = params.res_json or ""
	elseif (key == "res_atlas") then
		ret = params.res_atlas or ""
	elseif (key == "skin_name") then
		ret = params.skin_name or ""
	elseif(key == "time_scale") then
		ret = params.time_scale or 1
	end

	do return ret end
end

local Value = util.factory.Value

--[[------------------------------------------------------------------------------
create node by style instance
@param params
([style_instance] | [style_name])
[node_parent*][logic_instance*][composite_parent*][node_name*]
@return node(BJMNode) created
]]
factory.StyleNode = function (params)
	do return bjm.ui.manager.CreateNodeFromStyle(params) end
end

--[[------------------------------------------------------------------------------
get style by name
@param params
[style_name]
]]
factory.Style = function (params)
	do return bjm.ui.manager.GetStyle(params) end
end

--[[------------------------------------------------------------------------------
create a node :
@param params
[name][size][priority]
]]
factory.Node = function (params)
	if (params == nil) then do return nil end end
	return BJMNode:Create(
		Value(params, "name"),
		Value(params, "size"),
		Value(params, "priority")
		)
end

--[[------------------------------------------------------------------------------
create a sprite :
@param params
[name][size][priority]
[use_plist][res_id][plist_id][use_grey]
]]
factory.Sprite = function (params)
	if (params == nil) then do return nil end end
	return BJMSprite:Create(
		Value(params, "name"),
		Value(params, "size"),
		Value(params, "priority"),
		Value(params, "res_id"),
		Value(params, "shader_type")
		)
end


-- 	char * szName,
-- 	Size szContent,
-- 	int priority,
-- 	char * szResID,
-- 	bool bAutoPlay,
-- 	bool bLoop,
-- 	bool bReverse,
-- 	int nCompleteAction;
factory.GAF = function (params)
	if (params == nil) then do return nil end end
	local a =  BJMGAFAnimation:Create(
		Value(params, "name"),
		Value(params, "size"),
		Value(params, "priority"),
		Value(params, "res_id"),
		Value(params, "auto_play"),
		Value(params, "loop"),
		Value(params, "reverse"),
		Value(params, "complete_action")
		)
	a:EnablePlaybackEvent(Value(params, "playback_event"))
	return a
end

--[[------------------------------------------------------------------------------
create label ttf :
[text][font_size][font_name][alignment][line_width][vertical_space]
--]]
factory.LabelTTF = function (params)
	if (params == nil) then do return nil end end
	local label = BJMLabel:CreateWithTTF(
		Value(params, "text"),
		Value(params, "font_size"),
		Value(params, "font_name"),
		Value(params, "alignment"),
		Value(params, "line_width"),
		Value(params, "vertical_space")
		)
	return label
end

--[[------------------------------------------------------------------------------
-**
create particle
*]]
factory.Particle = function (params)
	if (params == nil) then do return nil end end
	local particle = BJMParticle:Create(
		Value(params, "name"),
		Value(params, "size"),
		Value(params, "priority"),
		Value(params, "res_id")
		)
	return particle
end

--[[------------------------------------------------------------------------------
-**
create frame animation
*]]
factory.FrameAnimationEx = function (params)
	if (params == nil) then do return nil end end
	local frameAnimation = BJMFrameAnimation:CreateEx(
		Value(params, "name"),
		Value(params, "size"),
		Value(params, "priority"),
		Value(params, "res_id"),
		Value(params, "frame_index"),
		Value(params, "last_duration"),
		Value(params, "auto_play"),
		Value(params, "loop"),
		Value(params, "use_event"),
		Value(params, "complete_action")
		)
	return frameAnimation
end


--[[------------------------------------------------------------------------------
-**
create frame animation
*]]
factory.FrameAnimation = function (params)
	if (params == nil) then do return nil end end
	local frameAnimation = BJMFrameAnimation:Create(
		Value(params, "name"),
		Value(params, "size"),
		Value(params, "priority"),
		Value(params, "res_id"),
		Value(params, "auto_play"),
		Value(params, "use_event"),
		Value(params, "complete_action")
		)
	return frameAnimation
end

--[[------------------------------------------------------------------------------
-**
create skeleton animation
*]]
factory.Skeleton = function (params)
	if (params == nil) then do return nil end end
	local skeletonAnimation = BJMSkeleton:Create(
		Value(params, "name"),
		Value(params, "size"),
		Value(params, "priority"),
		Value(params, "res_json"),
		Value(params, "res_atlas"),
		Value(params, "time_scale"),
		Value(params, "skin_name"),
		Value(params, "animation_name"),
		Value(params, "auto_play"),
		Value(params, "loop"),
		Value(params, "complete_action")
		)
	return skeletonAnimation
end
