--[[
Author : ZangXu @Bojoy 2014
FileName: BJMAppConfig.lua
Description: 
app config
1. should add project c search path
]]

---BJMAppConfig
-- @module bjm.app

local app = bjm.app

--- global app config
app.config = {}


--[[------------------------------------------------------------------------------
add c search path
path should be uri
]]
function app.AddSearchPath(path)
	BJMLuaUtil.AddSearchPath(path)	
end
