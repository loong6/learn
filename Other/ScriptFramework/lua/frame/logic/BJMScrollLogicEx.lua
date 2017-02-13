--[[
Author : ZangXu @Bojoy 2014
FileName: BJMScrollLogicEx.lua
Description: 
]]

---BJMScrollLogicEx
-- @module bjm.logic.ScrollLogic
-- @alias logic.ScrollLogic

local logic = bjm.logic

logic.ScrollLogic = bjm.reg.GetModule("BJMScrollLogicEx")

--[[------------------------------------------------------------------------------
ctor
]]
function logic.ScrollLogic:ctor()
	bjm.reg.RegLogicFunction(self, bjm.global.function_type.on_loaded, "", self.OnLoaded)
	bjm.reg.RegLogicFunction(self, bjm.global.function_type.on_destroy, "", self.OnDestroy)
	bjm.reg.RegLogicFunction(self, bjm.global.function_type.on_close, "", self.OnCloseCallback)
end

--[[------------------------------------------------------------------------------
OnLoaded
]]
function logic.ScrollLogic:OnLoaded()
	cclog("scroll logic on loaded...........")
end

--[[------------------------------------------------------------------------------
OnDestroy
]]
function logic.ScrollLogic:OnDestroy()
	cclog("scroll logic on destroy...........")
end

--[[------------------------------------------------------------------------------
OnCloseCallback
]]
function logic.ScrollLogic:OnCloseCallback()
	cclog("scroll logic on OnCloseCallback...........")
end