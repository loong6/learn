--[[
Author : ZangXu @Bojoy 2014
FileName: BJMSocketManager.lua
Description: 
]]

---BJMSocketManager
-- @module bjm.net

require(bjm.PACKAGE_NAME .. ".net.BJMSocketTCP")

local net = bjm.net

net.sockets = {}

------------------------------------- net.sockets -------------------------------------
local sockets = net.sockets

--[[------------------------------------------------------------------------------
open new net socket manager
]]
function sockets:Open()
	self.logic = net.logic.new()
end

--[[------------------------------------------------------------------------------
set key
]]
function sockets:SetKey(key)
	if (self.gameSocket == nil) then do return end end

	self.gameSocket:SetKey(key)
end

--[[------------------------------------------------------------------------------
open game socket
]]
function sockets:ConnectGameServer(socketName, host, port, retryConnectWhenFailure, filterChain, paserType)
	if (self.gameSocket ~= nil) then
		self:CloseGameServerSocket()
	end
	self.gameSocket = bjm.net.BJMSocketTCP.new(socketName, host, port, retryConnectWhenFailure, paserType)	
	self.gameSocket:Connect()
	self.gameSocket:SetFilterChain(filterChain)
end

--[[------------------------------------------------------------------------------
open chat socket
]]
function sockets:ConnectChatServer(socketName, host, port, retryConnectWhenFailure, filterChain, paserType)
	if (self.chatSocket ~= nil) then
		self:CloseChatServerSocket()
	end
	self.chatSocket = bjm.net.BJMSocketTCP.new(socketName, host, port, retryConnectWhenFailure, paserType)
	self.chatSocket:Connect()
	self.chatSocket:SetFilterChain(filterChain)
end

--[[------------------------------------------------------------------------------
Close game socket
]]
function sockets:CloseGameServerSocket()
	if(self.gameSocket ~= nil) then
		self.gameSocket:Close()
		self.gameSocket:SetFilterChain(nil)
		self.gameSocket = nil
	end
end

--[[------------------------------------------------------------------------------
Close chat socket
]]
function sockets:CloseChatServerSocket()
	if(self.chatSocket ~= nil) then
		self.chatSocket:Close()
		self.chatSocket:SetFilterChain(nil)
		self.chatSocket = nil
	end
end

--[[------------------------------------------------------------------------------
check game socket is connected
]]
function sockets:CheckIsGameSocketConnected()
	if self.gameSocket == nil then
	 	return false
	end
	return self.gameSocket.isConnected
end

--[[------------------------------------------------------------------------------
check chat socket is connected
]]
function sockets:CheckIsChatSocketConnected()
	if self.chatSocket == nil then
	 	return false
	end
	return self.chatSocket.isConnected
end

--[[------------------------------------------------------------------------------
sent packet to game server
]]
function sockets:SendToGameServer(packet)
	if (self.gameSocket == nil or packet == nil) then do return end end
	self.gameSocket:Send(packet)
end

--[[------------------------------------------------------------------------------
send packet to chat server
]]
function sockets:SendToChatServer(packet)
	if (self.chatSocket == nil or packet == nil) then do return end end
	self.chatSocket:Send(packet)
end

------------------------------------- net logic -------------------------------------
net.logic = bjm.reg.GetModule("BJMNetLogic")
local logic = net.logic

--[[------------------------------------------------------------------------------
]]
function logic:ctor()
	cclog("net logic ctor...........")
	bjm.reg.RegLogicFunction(self, bjm.global.function_type.custom, bjm.net.BJMSocketTCP.EVENT_CLOSE, self.OnSocketClose)
	bjm.reg.RegLogicFunction(self, bjm.global.function_type.custom, bjm.net.BJMSocketTCP.EVENT_CLOSED, self.OnSocketClosed)	
	bjm.reg.RegLogicFunction(self, bjm.global.function_type.custom, bjm.net.BJMSocketTCP.EVENT_CONNECTED, self.OnSocketConnected)
	bjm.reg.RegLogicFunction(self, bjm.global.function_type.custom, bjm.net.BJMSocketTCP.EVENT_DATA, self.OnSocketData)
	bjm.reg.RegLogicFunction(self, bjm.global.function_type.custom, bjm.net.BJMSocketTCP.EVENT_CONNECT_FAILURE, self.OnFailToConnect)
	
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
	cclog("socekt[" .. data.name .. "]net.logic:OnSocketClosed")
end

--[[------------------------------------------------------------------------------
on socket close
]]
function logic:OnSocketClose(event, data)
	cclog("socekt[" .. data.name .. "]net.logic:OnSocketClose")
end

--[[------------------------------------------------------------------------------
on socket connected
]]
function logic:OnSocketConnected(event, data)
	cclog("socekt[" .. data.name .. "]net.logic:OnSocketConnected")
end

--[[------------------------------------------------------------------------------
on socket data
]]
function logic:OnSocketData(event, data)
	cclog("socekt[" .. data.name .. "]net.logic:OnSocketData")
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
sockets:Open()