--[[
For quick-cocos2d-x
BJMSocketTCPEx lua
@author zrong (zengrong.net)
Creation: 2013-11-12
Last Modification: 2013-12-05
see http://cn.quick-x.com/?topic=quickkydsocketfzl
]]

---BJMSocketTCPEx
-- @module bjm.net.BJMSocketTCPEx

local SOCKET_TICK_TIME = 0.05 			-- check socket data interval
local SOCKET_RECONNECT_TIME = 5			-- socket reconnect try interval
local SOCKET_CONNECT_FAIL_TIMEOUT = 3	-- socket failure timeout

local STATUS_CLOSED = "closed"
local STATUS_NOT_CONNECTED = "Socket is not connected"
local STATUS_ALREADY_CONNECTED = "already connected"
local STATUS_ALREADY_IN_PROGRESS = "Operation already in progress"
local STATUS_TIMEOUT = "timeout"

require(bjm.PACKAGE_NAME .. ".util.BJMScheduler")

local scheduler = bjm.util.BJMScheduler
local socket = require "socket.core"
local sproto = require(bjm.PACKAGE_NAME .. ".net.sproto.sproto")

require(bjm.PACKAGE_NAME .. ".net.BJMPacketBufferEx")

bjm.net.BJMSocketTCPEx = class("BJMSocketTCPExEx")

local BJMSocketTCPEx = bjm.net.BJMSocketTCPEx

BJMSocketTCPEx.EVENT_DATA = "SOCKET_TCP_DATA"
BJMSocketTCPEx.EVENT_CLOSE = "SOCKET_TCP_CLOSE"
BJMSocketTCPEx.EVENT_CLOSED = "SOCKET_TCP_CLOSED"
BJMSocketTCPEx.EVENT_CONNECTED = "SOCKET_TCP_CONNECTED"
BJMSocketTCPEx.EVENT_CONNECT_FAILURE = "SOCKET_TCP_CONNECT_FAILURE"
BJMSocketTCPEx.EVENT_NO_NET_WORK = "EVENT_NO_NET_WORK"

BJMSocketTCPEx._VERSION = socket._VERSION
BJMSocketTCPEx._DEBUG = socket._DEBUG

---GetTime
function BJMSocketTCPEx.GetTime()
	return socket.gettime()
end

---ctor
function BJMSocketTCPEx:ctor(__socket_name, proto, __host, __port, __retryConnectWhenFailure)
    self.host = __host
    self.port = __port
    self.proto = proto
    self.proto_host = sproto.new(self.proto.s2c):host "package"
	self.proto_request = self.proto_host:attach(sproto.new(self.proto.c2s))
	self.tickScheduler = nil			-- timer for data
	self.reconnectScheduler = nil		-- timer for reconnect
	self.connectTimeTickScheduler = nil	-- timer for connect timeout
	self.name = __socket_name
	self.tcp = nil
	self.isRetryConnect = __retryConnectWhenFailure
	self.isConnected = false
	self.buf = bjm.net.bufex.new()
	self.buf:SetProto(self.proto_host, self.proto_request)

	self.buf:SetSocket(self)
end

--[[------------------------------------------------------------------------------
-**
set filter chain
*]]
function BJMSocketTCPEx:SetFilterChain(filterChain)
	self.buf:SetFilterChain(filterChain)
end

---SetKey
function BJMSocketTCPEx:SetKey(key)
	self.buf:SetKey(key)
end

---SetName
function BJMSocketTCPEx:SetName( __name)
	self.name = __name
	return self
end

---SetTickTime
function BJMSocketTCPEx:SetTickTime(__time)
	SOCKET_TICK_TIME = __time
	return self
end

---SetReconnTime
function BJMSocketTCPEx:SetReconnTime(__time)
	SOCKET_RECONNECT_TIME = __time
	return self
end

---SetConnFailTime
function BJMSocketTCPEx:SetConnFailTime(__time)
	SOCKET_CONNECT_FAIL_TIMEOUT = __time
	return self
end

---Connect
function BJMSocketTCPEx:Connect(__host, __port, __retryConnectWhenFailure)
	if __host then self.host = __host end
	if __port then self.port = __port end
	if __retryConnectWhenFailure ~= nil then self.isRetryConnect = __retryConnectWhenFailure end
	--assert(self.host or self.port, "Host and port are necessary!")
	printInfo("%s.Connect(%s, %d)", self.name, self.host, self.port)
	self.tcp = socket.tcp()
	self.tcp:settimeout(0)

	local function __CheckConnect()
		local __succ = self:_Connect()
		if __succ then
			self:_OnConnected()
		end
		return __succ
	end

	if not __CheckConnect() then
		-- check whether connection is success
		-- the connection is failure if socket isn't connected after SOCKET_CONNECT_FAIL_TIMEOUT seconds
		local __ConnectTimeTick = function ()
			--printInfo("%s.connectTimeTick", self.name)
			if self.isConnected then return end
			self.waitConnect = self.waitConnect or 0
			self.waitConnect = self.waitConnect + SOCKET_TICK_TIME
			if self.waitConnect >= SOCKET_CONNECT_FAIL_TIMEOUT then
				self.waitConnect = nil
				self:Close()
				self:_ConnectFailure()
			end
			__CheckConnect()
		end
		self.connectTimeTickScheduler = scheduler.scheduleGlobal(__ConnectTimeTick, SOCKET_TICK_TIME)
	end
end

--[[------------------------------------------------------------------------------
Send
@param data BJMPacketBuffer
]]
function BJMSocketTCPEx:Send(protoName, data)
	--assert(self.isConnected, self.name .. " is not connected.")
	if (data == nil) then 
		cclog("BJMSocketTCPEx:Send null data")
		do return end
	end

	-- check net work
	if (bjm.util.device.CheckIsNetworkAvailable() == false) then
	    cclog("msg(" .. protoName .. "): spot no network when trying to send package")
		bjm.util.PushNotification(BJMSocketTCPEx.EVENT_NO_NET_WORK, {id=protoName , type="net_available"})
		do return end
	end

	if (bjm.net.socketsEx:CheckIsGameSocketConnected() == false) then
		bjm.util.PushNotification(BJMSocketTCPEx.EVENT_NO_NET_WORK, {id=protoName , type="socket_closed"})
		do return end
	end


	local pack = self.proto_request(protoName, data)
	local buff = bjm.net.bufex._CreateBuffer()
	buff:WriteShort(#pack)
	buff:WriteBuf(pack)

	self.tcp:send(buff:GetPack())
end

---Close
function BJMSocketTCPEx:Close( ... )
	printInfo("%s.Close", self.name)
	self.tcp:close()
	if self.connectTimeTickScheduler then scheduler.unscheduleGlobal(self.connectTimeTickScheduler) end
	if self.tickScheduler then scheduler.unscheduleGlobal(self.tickScheduler) end
	bjm.util.PushNotification(BJMSocketTCPEx.EVENT_CLOSE, {name=self.name})
end

--- Disconnect on user's own initiative.
function BJMSocketTCPEx:Disconnect()
	self:_Disconnect()
	self.isRetryConnect = false -- initiative to disconnect, no reconnect.
end

--------------------
-- private
--------------------

-- When connect a connected socket server, it will return "already connected"
-- see: http://lua-users.org/lists/lua-l/2009-10/msg00584.html
function BJMSocketTCPEx:_Connect()
	local __succ, __status = self.tcp:connect(self.host, self.port)
	--print("%s._connect:", self.name, __succ, __status)
	return __succ == 1 or __status == STATUS_ALREADY_CONNECTED
end

--_Disconnect
function BJMSocketTCPEx:_Disconnect()
	self.isConnected = false
	self.tcp:shutdown()
	bjm.util.PushNotification(BJMSocketTCPEx.EVENT_CLOSED, {name=self.name})
end

--_OnDisconnect
function BJMSocketTCPEx:_OnDisconnect()
	printInfo("%s._OnDisConnect", self.name)
	self.isConnected = false
	bjm.util.PushNotification(BJMSocketTCPEx.EVENT_CLOSED, {name=self.name})
	self:_Reconnect()
end

-- connecte success, cancel the connection timerout timer
function BJMSocketTCPEx:_OnConnected()
	printInfo("%s._OnConnectd", self.name)

	self.isConnected = true
	bjm.util.PushNotification(BJMSocketTCPEx.EVENT_CONNECTED, {name=self.name})
	if self.connectTimeTickScheduler then scheduler.unscheduleGlobal(self.connectTimeTickScheduler) end

	local __Tick = function()
		while true do
			-- if use "*l" pattern, some buffer will be discarded, why?
			local __body, __status, __partial = self.tcp:receive("*a")	-- read the package body

			--print("body:", __body, "__status:", __status, "__partial:", __partial)
    	    if __status == STATUS_CLOSED or __status == STATUS_NOT_CONNECTED then
    	    	cclog("lua state is: " .. __status)
		    	self:Close()
		    	if self.isConnected then
		    		self:_OnDisconnect()
		    	else
		    		self:_ConnectFailure()
		    	end
		    	-- by zx
		    	-- to get the last message from server
		   		--return
	    	end
		    if 	(__body and string.len(__body) == 0) or
				(__partial and string.len(__partial) == 0)
			then return end
			if __body and __partial then __body = __body .. __partial end
			--bjm.util.PushNotification(BJMSocketTCPEx.EVENT_DATA, {data=(__partial or __body), partial=__partial, body=__body})

			-- dump({data=(__partial or __body), partial=__partial, body=__body}, "data")

			-- dump(__partial, "partial")

			-- local len = __partial:GetInt()
			-- cclog("len: " .. len)
			self.buf:ParsePackets(__partial or __body)
		end
	end

	-- start to read TCP data
	self.tickScheduler = scheduler.scheduleGlobal(__Tick, SOCKET_TICK_TIME)
end

--_ConnectFailure
function BJMSocketTCPEx:_ConnectFailure(status)
	printInfo("%s._connectFailure", self.name)
	bjm.util.PushNotification(BJMSocketTCPEx.EVENT_CONNECT_FAILURE, {name=self.name})
	self:_Reconnect()
end

-- if connection is initiative, do not reconnect
function BJMSocketTCPEx:_Reconnect(__immediately)
	if not self.isRetryConnect then return end
	printInfo("%s._reconnect", self.name)
	if __immediately then self:Connect() return end
	if self.reconnectScheduler then scheduler.unscheduleGlobal(self.reconnectScheduler) end
	local __DoReConnect = function ()
		self:Connect()
	end
	self.reconnectScheduler = scheduler.performWithDelayGlobal(__DoReConnect, SOCKET_RECONNECT_TIME)
end
