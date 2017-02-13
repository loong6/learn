--[[
Author : ZangXu @Bojoy 2014
FileName: BJMNetEnv.lua
Description: 
]]

---BJMNetEnv
-- @module bjm.net.env
-- @alias net.env

local net = bjm.net

net.env = {}

--[[------------------------------------------------------------------------------
check is net available
]]
net.env.IsNetAvailable = function()
	return BJMLuaUtil:CheckIsNetworkAvailable()
end