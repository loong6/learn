--[[
Author : ZangXu @Bojoy 2014
FileName: BJMMultiplexLogicEx.lua
Description: 
]]

---BJMMultiplexLogicEx
-- @module bjm.logic.MultiplexLogic
-- @alias logic.MultiplexLogic

local logic = bjm.logic

logic.MultiplexLogic = bjm.reg.GetModule("BJMMultiplexLogicEx")

--[[------------------------------------------------------------------------------
ctor
]]
function logic.MultiplexLogic:ctor()
	bjm.reg.RegLogicFunction(self, bjm.global.function_type.on_loaded, "", self.OnLoaded)
	bjm.reg.RegLogicFunction(self, bjm.global.function_type.on_destroy, "", self.OnDestroy)
	bjm.reg.RegLogicFunction(self, bjm.global.function_type.on_close, "", self.OnCloseCallback)
end

--[[------------------------------------------------------------------------------
OnLoaded
]]
function logic.MultiplexLogic:OnLoaded()
	cclog("multiplex logic on loaded...........")
end

--[[------------------------------------------------------------------------------
OnDestroy
]]
function logic.MultiplexLogic:OnDestroy()
	cclog("multiplex logic on destroy...........")
end

--[[------------------------------------------------------------------------------
OnCloseCallback
]]
function logic.MultiplexLogic:OnCloseCallback()
	cclog("multiplex logic on OnCloseCallback...........")
end