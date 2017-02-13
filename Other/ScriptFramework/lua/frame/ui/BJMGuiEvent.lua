--[[
Author : ZangXu @Bojoy 2014
FileName: BJMGuiEvent.lua
Description: 
]]

---BJMGuiEvent
-- @module bjm.ui.event
-- @alias ui.event

local ui = bjm.ui

ui.event = {}

local instance = nil

local TAG_TOUCH_ACTION = 10000
local action_table = {}

local function Instance()
	if (instance ~= nil) then do return instance end end
	return BJMGuiEventServer:Instance()
end

--[[------------------------------------------------------------------------------
ctor
]]
function ui.event:ctor()
	Instance():RegisterScriptHandler(self.OnGuiEvent)
end

--[[------------------------------------------------------------------------------
-**
index: [1, 9]
a action
*]]
function ui.event:SetTouchAction(index, action, actionDuration)
	action:retain()
	action_table[index] = action
	Instance():RegisterTouchActionScriptHandler(index, 
		function (node) 
			if (node ~= nil) then
				local hasAction = false
				local touchAction = node:getActionByTag(TAG_TOUCH_ACTION)
				if (touchAction ~= nil) then
					hasAction = true
					if (touchAction:isDone() == true) then
						touchAction:startWithTarget(node)
						return
					end
				end
				if (hasAction == false) then
					local touchActionIndex = node:GetTouchAction()
					local _action = action_table[touchActionIndex]
					if (_action ~= nil) then
						_action = _action:clone()
						if (_action ~= nil) then
							_action:setTag(TAG_TOUCH_ACTION)
							node:runAction(_action)
						end
					else
						cclog("no touch action found at " .. touchActionIndex)
						return
					end
				end
			end
		end, actionDuration)
end

--[[------------------------------------------------------------------------------
OnGuiEvent override me 
]]
function ui.event.OnGuiEvent(event_type, logic_name, logic_type, node_name, node_type, comp_name)
end