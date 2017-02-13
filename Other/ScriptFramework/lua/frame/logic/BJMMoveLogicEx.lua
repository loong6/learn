--[[
Author : ZangXu @Bojoy 2014
FileName: BJMMoveLogicEx.lua
Description: 
]]

---BJMMoveLogicEx
-- @module bjm.logic.MoveLogic
-- @alias logic.MoveLogic

local logic = bjm.logic

logic.MoveLogic = bjm.reg.GetModule("BJMMoveLogicEx")

--[[------------------------------------------------------------------------------
ctor
]]
function logic.MoveLogic:ctor()
	bjm.reg.RegLogicFunction(self, bjm.global.function_type.on_loaded, "", self.OnLoaded)
	bjm.reg.RegLogicFunction(self, bjm.global.function_type.on_destroy, "", self.OnDestroy)
	bjm.reg.RegLogicFunction(self, bjm.global.function_type.on_close, "", self.OnCloseCallback)
end

--[[------------------------------------------------------------------------------
OnLoaded
]]
function logic.MoveLogic:OnLoaded()
	cclog("move logic on loaded...........")
end

--[[------------------------------------------------------------------------------
OnDestroy
]]
function logic.MoveLogic:OnDestroy()
	cclog("move logic on destroy...........")
end

--[[------------------------------------------------------------------------------
OnClose
]]
function logic.MoveLogic:OnCloseCallback()
	cclog("move logic on OnCloseCallback...........")
end