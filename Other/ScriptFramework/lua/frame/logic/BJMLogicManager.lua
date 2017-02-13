--[[
Author : ZangXu @Bojoy 2014
FileName: BJMLogicManager.lua
Description: 
]]

---BJMLogicManager
-- @module bjm.logic.manager
-- @alias logic.manager

local logic = bjm.logic

logic.manager = {}

local instance = nil

local function Instance()
	if (instance ~= nil) then do return instance end end
	return BJMLogicManager:Instance()
end

--[[------------------------------------------------------------------------------
add a logic instance to manager
]]
logic.manager.AddLogic = function(logic)
	Instance():AddLogic(logic)
end

--[[------------------------------------------------------------------------------
remove a logic instance from manager
]]
logic.manager.RemoveLogicByInstance = function(logic_instance)
	Instance():RemoveLogic(logic_instance)
end

--[[------------------------------------------------------------------------------
remove a logic instance from manager by name
@return the removed logic instance
]]
logic.manager.RemoveLogicByName = function(logic_name)
	return Instance():RemoveLogicByName(logic_name)
end

--[[------------------------------------------------------------------------------
remove a logic instance
@param params
([logic_name] | [logic_instance])
]]
logic.manager.RemoveLogic = function(params)
	if (params.logic_instance ~= nil) then
		do return Instance():RemoveLogic(params.logic_instance) end
	else
		do return Instance():RemoveLogicByName(params.logic_name) end
	end
end

--[[------------------------------------------------------------------------------
find logic at top level
@return the logic instance found
]]
logic.manager.FindTopLogic = function(logic_name)
	return Instance():FindTopLogic(logic_name)
end

--[[------------------------------------------------------------------------------
find logic at any level (recursive search)
@return the logic instance found
]]
logic.manager.FindLogic = function(logic_name)
	return Instance():FindLogic(logic_name)
end

--[[------------------------------------------------------------------------------
list logics
@return all logics' names
]]
logic.manager.ListLogics = function()
	local logicNames = Instance():ListLogics()
	return string.split(logicNames, ";")
end


