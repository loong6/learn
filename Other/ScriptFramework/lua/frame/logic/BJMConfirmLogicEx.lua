--[[
Author : Zoulisheng @Bojoy 2014
FileName: BJMConfirmLogicEx.lua
Description: 
]]

---BJMConfirmLogicEx
-- @module bjm.logic.ConfirmLogic
-- @alias logic.ConfirmLogic

local logic = bjm.logic

logic.ConfirmLogic = bjm.reg.GetModule("BJMConfirmLogicEx")

--[[------------------------------------------------------------------------------
ctor
]]
function logic.ConfirmLogic:ctor()
	bjm.reg.RegLogicFunction(self, bjm.global.function_type.on_loaded, "", self.OnLoaded)
	bjm.reg.RegLogicFunction(self, bjm.global.function_type.on_destroy, "", self.OnDestroy)
end

--[[------------------------------------------------------------------------------
OnLoaded
]]
function logic.ConfirmLogic:OnLoaded()
	cclog("confirm logic on loaded...........")
end

--[[------------------------------------------------------------------------------
OnDestroy
]]
function logic.ConfirmLogic:OnDestroy()
	cclog("confirm logic on destroy...........")
end