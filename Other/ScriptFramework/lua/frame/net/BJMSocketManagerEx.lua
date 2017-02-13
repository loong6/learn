--[[
Author : ZangXu @Bojoy 2014
FileName: BJMSocketManager.lua
Description: 
]]

---BJMSocketManager
-- @module bjm.net

require(bjm.PACKAGE_NAME .. ".net.BJMSocketTCPEx")

local net = bjm.net

net.socketsEx = {}

------------------------------------- net.socketsEx -------------------------------------
local socketsEx = net.socketsEx

--[[------------------------------------------------------------------------------
open new net socket manager
]]
function socketsEx:Open()
	self.logic = net.logic.new()
end

--[[------------------------------------------------------------------------------
set key
]]
function socketsEx:SetKey(key)
	if (self.gameSocket == nil) then do return end end

	self.gameSocket:SetKey(key)
end

--[[------------------------------------------------------------------------------
open game socket
]]
function socketsEx:ConnectGameServer(socketName, proto, host, port, retryConnectWhenFailure, filterChain)
	if (self.gameSocket ~= nil) then
		self:CloseGameServerSocket()
	end
	self.gameSocket = bjm.net.BJMSocketTCPEx.new(socketName, proto, host, port, retryConnectWhenFailure)
	
	self.gameSocket:Connect()
	self.gameSocket:SetFilterChain(filterChain)
end

--[[------------------------------------------------------------------------------
Close game socket
]]
function socketsEx:CloseGameServerSocket()
	if(self.gameSocket ~= nil) then
		self.gameSocket:Close()
		self.gameSocket:SetFilterChain(nil)
		self.gameSocket = nil
	end
end

--[[------------------------------------------------------------------------------
check game socket is connected
]]
function socketsEx:CheckIsGameSocketConnected()
	if self.gameSocket == nil then
	 	return false
	end
	return self.gameSocket.isConnected
end

--[[------------------------------------------------------------------------------
sent packet to game server
]]
function socketsEx:SendToGameServer(protoName, packet)
	if (self.gameSocket == nil or packet == nil) then do return end end
	self.gameSocket:Send(protoName, packet)
end

------------------------------------- net logic -------------------------------------
net.logic = bjm.reg.GetModule("BJMNetLogic")
local logic = net.logic

--[[------------------------------------------------------------------------------
]]
function logic:ctor()
	cclog("net logic ctor...........")
	bjm.reg.RegLogicFunction(self, bjm.global.function_type.custom, bjm.net.BJMSocketTCPEx.EVENT_CLOSE, self.OnSocketClose)
	bjm.reg.RegLogicFunction(self, bjm.global.function_type.custom, bjm.net.BJMSocketTCPEx.EVENT_CLOSED, self.OnSocketClosed)	
	bjm.reg.RegLogicFunction(self, bjm.global.function_type.custom, bjm.net.BJMSocketTCPEx.EVENT_CONNECTED, self.OnSocketConnected)
	bjm.reg.RegLogicFunction(self, bjm.global.function_type.custom, bjm.net.BJMSocketTCPEx.EVENT_DATA, self.OnSocketData)
	bjm.reg.RegLogicFunction(self, bjm.global.function_type.custom, bjm.net.BJMSocketTCPEx.EVENT_CONNECT_FAILURE, self.OnFailToConnect)
	
	--bjm.reg.RegLogicFunction(self, bjm.global.function_type.on_destroy, "", self.OnDestroy)
end

--[[------------------------------------------------------------------------------
]]
function logic:OnDestroy()
	cclog("net logic on destroy...........")
end

--[[------------------------------------------------------------------------------
on socket closed
]]
function logic:OnSocketClosed(event, data)
	cclog("socektEx[" .. data.name .. "]net.logic:OnSocketClosed")
end

--[[------------------------------------------------------------------------------
on socket close
]]
function logic:OnSocketClose(event, data)
	cclog("socektEx[" .. data.name .. "]net.logic:OnSocketClose")
end

--[[------------------------------------------------------------------------------
on socket connected
]]
function logic:OnSocketConnected(event, data)
	cclog("socektEx[" .. data.name .. "]net.logic:OnSocketConnected")
end

--[[------------------------------------------------------------------------------
on socket data
]]
function logic:OnSocketData(event, data)
	cclog("socektEx[" .. data.name .. "]net.logic:OnSocketData")
end

--[[------------------------------------------------------------------------------
on fail to connect
]]
function logic:OnFailToConnect(event, data)
	cclog("socekt[" .. data.name .. "]net.logic:OnFailToConnect")
end

--[[------------------------------------------------------------------------------
open
]]
socketsEx:Open()