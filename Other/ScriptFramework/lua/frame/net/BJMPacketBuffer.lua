--[[
Author : ZangXu @Bojoy 2014
FileName: BJMPacketBuffer.lua
Description: 
	BJMPacketBuffer receive the byte stream and analyze them, then pack them into a message packet.
]]

---BJMPacketBuffer
-- @module bjm.net.buf
-- @alias BJMPacketBuffer

require(bjm.PACKAGE_NAME .. ".util.BJMEncrypt")

bjm.net.buf = class("BJMPacketBuffer")

local BJMPacketBuffer = bjm.net.buf

require(bjm.PACKAGE_NAME .. ".util.BJMByteArray")
local BJMByteArray = bjm.util.BJMByteArray

BJMPacketBuffer.ENDIAN = BJMByteArray.ENDIAN_BIG
BJMPacketBuffer.PACKET_MAX_LEN = 102400000

--[[
packet bit structure
]]

--- package flag at start, 1byte per flag
BJMPacketBuffer.FLAG_LEN = 4
-- type of message, 1byte
BJMPacketBuffer.TYPE_LEN = 2
--- length of peer
BJMPacketBuffer.PEER_LEN = 2
--- error of message body, int
BJMPacketBuffer.ERRNO_LEN = 2
--- head len send
BJMPacketBuffer.HEAD_LEN_SEND = 8
--- head len receive
BJMPacketBuffer.HEAD_LEN_RECEIVE = 10

--[[------------------------------------------------------------------------------
ctor
]]
function BJMPacketBuffer:ctor()
	self:Init()
	self._key = nil
	self._socket = nil
	self._filterChain = nil
end

--[[------------------------------------------------------------------------------
set key
]]
function BJMPacketBuffer:SetKey(key)
	self._key = key
	--dump(self, "self being set key")
end

--[[------------------------------------------------------------------------------
set socket
]]
function BJMPacketBuffer:SetSocket(socket)
	self._socket = socket
end

--[[------------------------------------------------------------------------------
-**
set filter chain
*]]
function BJMPacketBuffer:SetFilterChain(filterChain)
	self._filterChain = filterChain
end

--[[------------------------------------------------------------------------------
init
]]
function BJMPacketBuffer:Init()
	self._buf = BJMPacketBuffer._CreateBuffer()
end

--[[------------------------------------------------------------------------------
get
]]
function BJMPacketBuffer._CreateBuffer()
	return BJMByteArray.new(BJMPacketBuffer.ENDIAN)
end

--[[------------------------------------------------------------------------------
create packet
@param msgId int
@param peer short
]]
function BJMPacketBuffer.CreatePacket(msgId, peer)
  local packet = BJMPacketBuffer._CreateBuffer()
  packet:WriteInt(0)
  packet:WriteShort(msgId)
  if (peer == nil) then peer = 0 end
  packet:WriteShort(peer)
  return packet
end

--[[------------------------------------------------------------------------------
parse packets
]]
function BJMPacketBuffer:ParsePackets(byteString)
    self._buf:SetPos(self._buf:GetLen() + 1)
    self._buf:WriteBuf(byteString)
    self._buf:SetPos(1)
    local __preLen = BJMPacketBuffer.HEAD_LEN_RECEIVE
    -- print("start analyzing... buffer len: %u, available: %u", self._buf:getLen(), self._buf:getAvailable())
    -- print("start analyzing... buffer len: ".. self._buf:getLen().." available:"..self._buf:getAvailable())
    while self._buf:GetAvailable() >= __preLen do
    	--cclog("pos 1: " .. self._buf:GetPos())
  		local packetLen = self._buf:ReadInt()
  		--cclog("pos 2: " .. self._buf:GetPos())
  		--cclog("1")
  		--cclog("packet len: " .. packetLen)
  		if (packetLen > 300) then
  			cclog("packet is larget, len: " .. packetLen)
  		end
	    local __bodyLen = packetLen - BJMPacketBuffer.HEAD_LEN_RECEIVE

	    if (self._buf:GetAvailable() + 4) < (__bodyLen + BJMPacketBuffer.HEAD_LEN_RECEIVE) then
	          cclog("received data is not enough, waiting... need " .. __bodyLen .. ", get " .. self._buf:GetAvailable())
	          -- print("buf:", self._buf:toString())
	          self._buf:SetPos(self._buf:GetPos() - 4)
	      --    cclog("Pos 3: " .. self._buf:GetPos())
	          break
	    end

	    --cclog("2")
	    if __bodyLen <= BJMPacketBuffer.PACKET_MAX_LEN  then
	    	local tmpBuff = BJMPacketBuffer._CreateBuffer()
	    	--cclog("3")
	    	-- cclog("Pos 4_1: " .. self._buf:GetPos())
	    	self._buf:ReadBytes(tmpBuff, 1, packetLen - 5)
	    	-- cclog("Pos 4: " .. self._buf:GetPos())

			if (self._key ~= nil) then
				-- decode
				--cclog("decode")
				tmpBuff:Decode(self._key, 0)
			end
			--cclog("4")

			tmpBuff:SetPos(1)
	    	local __msgId  = tmpBuff:ReadShort()
	   		cclog("msgId:================"..__msgId)
	    	local __peer = tmpBuff:ReadShort()
	    	local __errno = tmpBuff:ReadShort()

	    	local packet = {
		        id = tostring(__msgId),
		        peer = __peer,
		        errno = __errno,
		        len = packetLen - BJMPacketBuffer.HEAD_LEN_RECEIVE,
		        content = tmpBuff
	    	}

	    	local needDiscard = false
	    	if (self._filterChain ~= nil) then
	    		needDiscard = self._filterChain:DoFilter(packet)
	    	end

	    	if (needDiscard ~= true) then
	    		bjm.util.PushNotification(tostring(__msgId), packet)
	    	else
	    		cclog("packet is discard...")
	    	end
	     	--cclog("Pos 2: " .. self._buf:GetPos())
	    end
    end	-- end of while

    

    -- clear buffer on exhausted
    if self._buf:GetAvailable() <= 0 then
    	cclog("self._buf:GetAvailable() <= 0 go init")
        self:Init()
    else
	    -- some datas in buffer yet, write them to a new blank buffer.
	    -- printf("cache incomplete buff,len: %u, available: %u", self._buf:getLen(), self._buf:getAvailable())
	    cclog("cache incomplete buf")
	    local __tmp = BJMPacketBuffer._CreateBuffer()
	    --cclog("Pos 5: " .. self._buf:GetPos())
	    self._buf:ReadBytes(__tmp, 1, self._buf:GetAvailable())
	    --cclog("Pos 6: " .. self._buf:GetPos())
	    self._buf = __tmp
	    -- printf("tmp len: %u, availabl: %u", __tmp:getLen(), __tmp:getAvailable())
	    -- printf("buf:", __tmp:toString())
  	end

end

function BJMPacketBuffer:ParsePackets2(byteString)
    self._buf:SetPos(self._buf:GetLen() + 1)
    self._buf:WriteBuf(byteString)
    self._buf:SetPos(1)
    local __preLen = BJMPacketBuffer.HEAD_LEN_RECEIVE
    -- print("start analyzing... buffer len: %u, available: %u", self._buf:getLen(), self._buf:getAvailable())
    -- print("start analyzing... buffer len: ".. self._buf:getLen().." available:"..self._buf:getAvailable())
    while self._buf:GetAvailable() >= __preLen do
    	--cclog("pos 1: " .. self._buf:GetPos())
  		local packetLen = self._buf:ReadInt()
  		--cclog("pos 2: " .. self._buf:GetPos())
  		--cclog("1")
  		--cclog("packet len: " .. packetLen)
  		if (packetLen > 300) then
  			cclog("packet is larget, len: " .. packetLen)
  		end
	    local __bodyLen = packetLen - BJMPacketBuffer.HEAD_LEN_RECEIVE

	    if (self._buf:GetAvailable() + 4) < (__bodyLen + BJMPacketBuffer.HEAD_LEN_RECEIVE) then
	          cclog("received data is not enough, waiting... need " .. __bodyLen .. ", get " .. self._buf:GetAvailable())
	          -- print("buf:", self._buf:toString())
	          self._buf:SetPos(self._buf:GetPos() - 4)
	      --    cclog("Pos 3: " .. self._buf:GetPos())
	          break
	    end

	    if __bodyLen <= BJMPacketBuffer.PACKET_MAX_LEN  then
	    	local tmpBuff = BJMPacketBuffer._CreateBuffer()
	    	self._buf:ReadBytes(tmpBuff, 1, packetLen - 5)

	    	tmpBuff:SetPos(1)
	    	local __msgId  = tmpBuff:ReadShort()
	    	local __peer = tmpBuff:ReadShort()
	    	local __errno = tmpBuff:ReadShort()
	    	local __compress = 0
	    	local __encrypt = 0
	    	if __bodyLen > 0 then
	    		__compress = tmpBuff:ReadByte()
		    	__encrypt = tmpBuff:ReadByte()
		    	if (self._key ~= nil and __encrypt == 1) then
		    		-- cclog("decode ....")
					tmpBuff:Decode2(self._key, 2+2+2+1+1)
		    		tmpBuff:SetPos(2+2+2+1+1+1)
				end
		    end

	    	local packet = {
		        id = tostring(__msgId),
		        peer = __peer,
		        errno = __errno,
		        compress = __compress,
		        len = packetLen - BJMPacketBuffer.HEAD_LEN_RECEIVE,
		        content = tmpBuff
	    	}

	    	if packet.compress == 1 then
	    		cclog("uncompress ...")
	    		packet.content = tmpBuff:Uncompress2(8)
	    	end

	    	local needDiscard = false
	    	if (self._filterChain ~= nil) then
	    		needDiscard = self._filterChain:DoFilter(packet)
	    	end

	    	if (needDiscard ~= true) then
	    		bjm.util.PushNotification(tostring(__msgId), packet)
	    	else
	    		cclog("packet is discard...")
	    	end
	     	--cclog("Pos 2: " .. self._buf:GetPos())
	    end
    end	-- end of while

    

    -- clear buffer on exhausted
    if self._buf:GetAvailable() <= 0 then
    	-- cclog("self._buf:GetAvailable() <= 0 go init")
        self:Init()
    else
	    -- some datas in buffer yet, write them to a new blank buffer.
	    -- printf("cache incomplete buff,len: %u, available: %u", self._buf:getLen(), self._buf:getAvailable())
	    cclog("cache incomplete buf")
	    local __tmp = BJMPacketBuffer._CreateBuffer()
	    --cclog("Pos 5: " .. self._buf:GetPos())
	    self._buf:ReadBytes(__tmp, 1, self._buf:GetAvailable())
	    --cclog("Pos 6: " .. self._buf:GetPos())
	    self._buf = __tmp
	    -- printf("tmp len: %u, availabl: %u", __tmp:getLen(), __tmp:getAvailable())
	    -- printf("buf:", __tmp:toString())
  	end

end


return BJMPacketBuffer
