--[[
Author : ZangXu @Bojoy 2014
FileName: BJMReg.lua
Description: 
help app register modules
]]

---BJMReg
-- @module bjm.reg

require(bjm.PACKAGE_NAME .. ".util.BJMFactory")

local reg = bjm.reg

--- all modules registered
reg.modules = {}

--- default creators --
reg.creators = 
{
	Logic = bjm.util.factory.Logic,
	MoveLogic = bjm.util.factory.MoveLogic,	
	MultiplexLogic = bjm.util.factory.MultiplexLogic,
	ScrollLogic = bjm.util.factory.ScrollLogic,
	NetLogic = bjm.util.factory.NetLogic,
	ConfirmLogic = bjm.util.factory.ConfirmLogic,
	UpdateLogic = bjm.util.factory.UpdateLogic,
	SDKLogic = bjm.util.factory.SDKLogic,
	HttpLogic = bjm.util.factory.HttpLogic
}

--[[------------------------------------------------------------------------------
register module inherited form c
]]
function reg.RegModuleFromC(moduleClass, moduleType)
	local module = class(moduleClass, reg.creators[moduleType])
	reg.modules[moduleClass] = module
end

--[[------------------------------------------------------------------------------
register module inherited from lua
]]
function reg.RegModuleFromLua(moduleClass, luaModule)
	local module = class(moduleClass, luaModule)
	reg.modules[moduleClass] = module
end

--[[------------------------------------------------------------------------------
register module inherited from custom module
]]
function reg.RegModuleFromCustom(moduleClass, luaModuleName)
	local module = class(moduleClass, function ()
		return reg.GetModule(luaModuleName).new()
	end)
	reg.modules[moduleClass] = module
end

--[[------------------------------------------------------------------------------
create module by module class
]]
function reg.CreateModule(moduleClass)
	return reg.modules[moduleClass].new()
end

--[[------------------------------------------------------------------------------
get module by module class
]]
function reg.GetModule(moduleClass)
	local module = reg.modules[moduleClass]
	return module
end

--[[------------------------------------------------------------------------------
register gui config
]]
function reg.RegGuiConfig(config_name, config_uri)
	BJMLuaUtil:RegisterGuiConfig(config_name, config_uri)
end


--[[------------------------------------------------------------------------------
register logic callback functions
]]
function reg.RegLogicFunction(logic, func_type, func_identity, func)
	if logic == nil then do return end end
	if (func == nil) then
		cclog("error: in reg.RegLogicFunction, func is nil")
		print(debug.traceback())
	end	
	logic:RegisterScriptFunc(func_type, func_identity, func)
end

--[[------------------------------------------------------------------------------
register logic callback functions
only actived loigc can receive message
]]
function reg.RegLogicFunctionEx(logic, func_type, func_identity, func)
	if logic == nil then do return end end
	logic:RegisterScriptFuncEx(func_type, func_identity, func, true)
end

--[[------------------------------------------------------------------------------
Setup
]]
function reg.Setup()
	BJMLuaUtil:RegisterCreatorHandler(reg.CreateModule)	
	reg.RegModuleFromC("BJMLogicEx", bjm.global.module.logic)
	reg.RegModuleFromC("BJMConfirmLogicEx", bjm.global.module.confirm_logic)
	reg.RegModuleFromC("BJMMoveLogicEx", bjm.global.module.move_logic)
	reg.RegModuleFromC("BJMMultiplexLogicEx", bjm.global.module.multiplex_logic)
	reg.RegModuleFromC("BJMScrollLogicEx", bjm.global.module.scroll_logic)
	reg.RegModuleFromC("BJMNetLogic", bjm.global.module.net_logic)
	reg.RegModuleFromC("BJMUpdateLogicEx", bjm.global.module.update_logic)
	reg.RegModuleFromC("BJMSDKLogic", bjm.global.module.sdk_logic)
	reg.RegModuleFromC("BJMHttpLogicEx", bjm.global.module.http_logic)
end

------------------------------------- do register -------------------------------------
reg.Setup()