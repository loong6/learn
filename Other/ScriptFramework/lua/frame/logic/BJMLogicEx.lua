--[[
Author : ZangXu @Bojoy 2014
FileName: BJMLogicEx.lua
Description: 
]]

---BJMLogicEx
-- @module bjm.logic.Logic
-- @alias logic.Logic

local logic = bjm.logic

logic.Logic = bjm.reg.GetModule("BJMLogicEx")

--[[------------------------------------------------------------------------------
ctor
]]
function logic.Logic:ctor()
	bjm.reg.RegLogicFunction(self, bjm.global.function_type.on_loaded, "", self.OnLoaded)
	bjm.reg.RegLogicFunction(self, bjm.global.function_type.on_destroy, "", self.OnDestroy)
	bjm.reg.RegLogicFunction(self, bjm.global.function_type.on_close, "", self.OnCloseCallback)
end

--[[------------------------------------------------------------------------------
OnLoaded
]]
function logic.Logic:OnLoaded()
	cclog("logic on loaded...........")
end

--[[------------------------------------------------------------------------------
AfterMoved
]]
function logic.Logic:AfterMoved()
	cclog("logic on AfterMoved...........")
end

--[[------------------------------------------------------------------------------
OnDestroy
]]
function logic.Logic:OnDestroy()
	cclog("logic on destroy...........")
end

--[[------------------------------------------------------------------------------
OnClose
]]
function logic.Logic:OnCloseCallback()
	cclog("logic on OnCloseCallback...........")
end

