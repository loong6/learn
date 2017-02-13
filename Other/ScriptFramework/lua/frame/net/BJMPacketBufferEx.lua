--[[
Author : ZangXu @Bojoy 2014
FileName: BJMPacketBufferExEx.lua
Description: 
	BJMPacketBufferEx receive the byte stream and analyze them, then pack them into a message packet.
]]

---BJMPacketBufferEx
-- @module bjm.net.buf
-- @alias BJMPacketBufferEx

require(bjm.PACKAGE_NAME .. ".util.BJMEncrypt")
local sproto = require (bjm.PACKAGE_NAME .. ".net.sproto.sproto")

bjm.net.bufex = class("BJMPacketBufferExEx")

local BJMPacketBufferEx = bjm.net.bufex

require(bjm.PACKAGE_NAME .. ".util.BJMByteArray")
local BJMByteArray = bjm.util.BJMByteArray

BJMPacketBufferEx.ENDIAN = BJMByteArray.ENDIAN_BIG
BJMPacketBufferEx.PACKET_MAX_LEN = 102400000

--[[
packet bit structure
]]

--- package flag at start, 1byte per flag
BJMPacketBufferEx.HEAD_LEN_RECEIVE = 2

--[[------------------------------------------------------------------------------
ctor
]]
function BJMPacketBufferEx:ctor()
	self:Init()
	self._key = nil
	self._socket = nil
	self._filterChain = nil
end

--[[------------------------------------------------------------------------------
-**
*]]
function BJMPacketBufferEx:SetProto(host, request)
	self.host = host
	self.request = request
end

--[[------------------------------------------------------------------------------
set key
]]
function BJMPacketBufferEx:SetKey(key)
	self._key = key
	--dump(self, "self being set key")
end

--[[------------------------------------------------------------------------------
set socket
]]
function BJMPacketBufferEx:SetSocket(socket)
	self._socket = socket
end

--[[------------------------------------------------------------------------------
-**
set filter chain
*]]
function BJMPacketBufferEx:SetFilterChain(filterChain)
	self._filterChain = filterChain
end

--[[------------------------------------------------------------------------------
init
]]
function BJMPacketBufferEx:Init()
	self._buf = BJMPacketBufferEx._CreateBuffer()
end

--[[------------------------------------------------------------------------------
get
]]
function BJMPacketBufferEx._CreateBuffer()
	return BJMByteArray.new(BJMPacketBufferEx.ENDIAN)
end

--[[------------------------------------------------------------------------------
create packet
@param msgId int
@param peer short
]]
function BJMPacketBufferEx.CreatePacket(msgId, peer)
  local packet = BJMPacketBufferEx._CreateBuffer()
  packet:WriteInt(0)
  packet:WriteShort(msgId)
  if (peer == nil) then peer = 0 end
  packet:WriteShort(peer)
  return packet
end

--[[------------------------------------------------------------------------------
parse packets
]]
function BJMPacketBufferEx:ParsePackets(byteString)
    self._buf:SetPos(self._buf:GetLen() + 1)
    self._buf:WriteBuf(byteString)
    self._buf:SetPos(1)
    local parse_cnt = 0

 

    local __preLen = BJMPacketBufferEx.HEAD_LEN_RECEIVE
    while self._buf:GetAvailable() >= __preLen do
    	parse_cnt = parse_cnt + 1
    	-- local s_t = bjm.net.BJMSocketTCPEx.GetTime()
	    -- parse_cnt = parse_cnt +1 
	    -- if parse_cnt > 10 then break end

    	--cclog("pos 1: " .. self._buf:GetPos())
    	--print("available: " .. self._buf:GetAvailable())
  		local packetLen = self._buf:ReadShort()
  		--print("packetLen: " .. packetLen)
  		if (packetLen > 300) then
  			cclog("packet is large, len: " .. packetLen)
  		end
	    local __bodyLen = packetLen - BJMPacketBufferEx.HEAD_LEN_RECEIVE

	    if (self._buf:GetAvailable() + 2) < (__bodyLen + BJMPacketBufferEx.HEAD_LEN_RECEIVE) then
	          cclog("received data is not enough, waiting... need " .. __bodyLen .. ", get " .. self._buf:GetAvailable())
	          self._buf:SetPos(self._buf:GetPos() - 2)
	          break
	    end



	    if __bodyLen <= BJMPacketBufferEx.PACKET_MAX_LEN then
	    	--self._buf:SetPos(3)
			local tmpBuff = self._buf:ReadLenStringBytes(packetLen)
			 -- local s_t_2 = bjm.net.BJMSocketTCPEx.GetTime()
			--self._buf:SetPos(3 + packetLen)
			--cclog("Pos 3: " .. self._buf:GetPos())
			local __, name, tag, content = self.host:dispatch(tmpBuff)

			-- local s_t_3 = bjm.net.BJMSocketTCPEx.GetTime()

	    	local __msgId  = tag

	    	local packet = {
	    		proto = name,
		        id = tostring(__msgId),
		        content = content
	    	}

	    	-- if id~=1002  then
	    	-- 	dump(packet, "packet", 5)
	    	-- end
	    	

	    	local needDiscard = false
	    	if (self._filterChain ~= nil) then
	    		needDiscard = self._filterChain:DoFilter(packet)
	    	end

	    	if (needDiscard ~= true) then
	    		bjm.util.PushNotification(tostring(__msgId), packet)
	    	else
	    		cclog("packet is discard...")
	    	end
	    	-- collectgarbage("collect")
	    	--cclog("Pos 2: " .. self._buf:GetPos())
	  	-- local e_t = bjm.net.BJMSocketTCPEx.GetTime()
	  	
	  	
	  	-- cclog("---packet.id="..packet.id.."---before Dispatch=" ..(s_t_2-s_t) .."  dispath cast=" .. (s_t_3 - s_t_2).."-total time=" .. (e_t-s_t))	    	
	    end




    end	-- end of while
    -- collectgarbage("collect")

    -- clear buffer on exhausted
    if self._buf:GetAvailable() <= 0 then
        self:Init()
    else
	    -- some datas in buffer yet, write them to a new blank buffer.
	    -- printf("cache incomplete buff,len: %u, available: %u", self._buf:getLen(), self._buf:getAvailable())
	    cclog("cache incomplete buf")
	    local __tmp = BJMPacketBufferEx._CreateBuffer()
	    self._buf:ReadBytes(__tmp, 1, self._buf:GetAvailable())
	    self._buf = __tmp
  	end


end


return BJMPacketBufferEx
