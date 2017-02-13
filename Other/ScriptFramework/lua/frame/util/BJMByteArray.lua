--[[
Serialzation bytes stream like ActionScript flash.utils.ByteArray.
It depends on lpack.
A sample: https://github.com/zrong/lua#ByteArray

see http://underpop.free.fr/l/lua/lpack/
see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/utils/ByteArray.html
author zrong(zengrong.net)

Creation 2013-11-14
Last Modification 2014-01-01
]]

---BJMByteArray
-- @module bjm.util.BJMByteArray

bjm.util.BJMByteArray = class("BJMByteArray")

local BJMByteArray = bjm.util.BJMByteArray

BJMByteArray.ENDIAN_LITTLE = "ENDIAN_LITTLE"
BJMByteArray.ENDIAN_BIG = "ENDIAN_BIG"
BJMByteArray.radix = {[10]="%03u",[8]="%03o",[16]="%02X"}

require("pack")

--- Return a string to display.
-- @param self 
-- If self is BJMByteArray, read string from self. 
-- Else, treat self as byte string.
-- @param __radix radix of display, value is 8, 10 or 16, default is 10.
-- @param __separator default is " ".
-- @return string, number
function BJMByteArray.ToString(self, __radix, __separator)
	__radix = __radix or 16 
	__radix = BJMByteArray.radix[__radix] or "%02X"
	__separator = __separator or " "
	local __fmt = __radix..__separator
	local __format = function(__s)
		return string.format(__fmt, string.byte(__s))
	end
	if type(self) == "string" then
		return string.gsub(self, "(.)", __format)
	end
	local __bytes = {}
	for i=1,#self._buf do
		__bytes[i] = __format(self._buf[i])
	end
	return table.concat(__bytes) ,#__bytes
end

---ctor
function BJMByteArray:ctor(__endian)
	self._endian = __endian
	self._buf = {}
	self._pos = 1
end

---GetLen
function BJMByteArray:GetLen()
	return #self._buf
end

---GetAvailable
function BJMByteArray:GetAvailable()
	return #self._buf - self._pos + 1
end

---GetPos
function BJMByteArray:GetPos()
	return self._pos
end

---SetPos
function BJMByteArray:SetPos(__pos)
	self._pos = __pos
	return self
end

---GetEndian
function BJMByteArray:GetEndian()
	return self._endian
end

---SetEndian
function BJMByteArray:SetEndian(__endian)
	self._endian = __endian
end

--- Get all byte array as a lua string.
-- Do not update position.
function BJMByteArray:GetBytes(__offset, __length)
	__offset = __offset or 1
	__length = __length or #self._buf
	--printf("getBytes,offset:%u, length:%u", __offset, __length)
	return table.concat(self._buf, "", __offset, __length)
end

--- Get pack style string by lpack.
-- The result use BJMByteArray.getBytes to get is unavailable for lua socket.
-- E.g. the #self:_buf is 18, but #BJMByteArray.getBytes is 63.
-- I think the cause is the table.concat treat every item in BJMByteArray._buf as a general string, not a char.
-- So, I use lpack repackage the BJMByteArray._buf, theretofore, I must convert them to a byte number.
function BJMByteArray:GetPack(__offset, __length)
	__offset = __offset or 1
	__length = __length or #self._buf

	local __s = ""
	local offset = __offset

	--lituo
	--fix 'too many results to unpack'
	--unpack has a limit with 8000 defined in luaconf.h LUAI_MAXCSTACK, use loop to get result string
	while offset <= __length do
		local n = __length - offset + 1
		if n > 1024 then n = 1024 end 

		local __t = {}
		for i=1,n do
			__t[#__t+1] = string.byte(self._buf[offset+i-1])
		end
		local __fmt = self:_getLC("b"..#__t)
		__s = __s .. string.pack(__fmt, unpack(__t))

		offset = offset + n
	end

	return __s
end

--- rawUnPack perform like lpack.pack, but return the BJMByteArray.
function BJMByteArray:RawPack(__fmt, ...)
	local __s = string.pack(__fmt, ...)
	self:writeBuf(__s)
	return self
end

--- rawUnPack perform like lpack.unpack, but it is only support FORMAT parameter.
-- Because BJMByteArray include a position itself, so we haven't to save another.
function BJMByteArray:RawUnPack(__fmt)
	-- read all of bytes.
	local __s = self:GetBytes(self._pos)
	local __next, __val = string.unpack(__s, __fmt)
	-- update position of the BJMByteArray
	self._pos = self._pos + __next
	-- Alternate value and next
	return __val, __next
end

---Read & Write functions
--@section file

---ReadBool
function BJMByteArray:ReadBool()
	-- When char > 256, the readByte method will show an error.
	-- So, we have to use readChar
	return self:ReadChar() ~= 0
end

---WriteBool
function BJMByteArray:WriteBool(__bool)
	if __bool then 
		self:WriteByte(1)
	else
		self:WriteByte(0)
	end
	return self
end

---ReadDouble
function BJMByteArray:ReadDouble()
	local __, __v = string.unpack(self:ReadBuf(8), self:_getLC("d"))
	return __v
end

---WriteDouble
function BJMByteArray:WriteDouble(__double)
	local __s = string.pack( self:_getLC("d"), __double)
	self:WriteBuf(__s)
	return self
end

---ReadFloat
function BJMByteArray:ReadFloat()
	local __, __v = string.unpack(self:ReadBuf(4), self:_getLC("f"))
	return __v
end

---WriteFloat
function BJMByteArray:WriteFloat(__float)
	local __s = string.pack( self:_getLC("f"),  __float)
	self:writeBuf(__s)
	return self
end

---ReadInt
function BJMByteArray:ReadInt()
	local __, __v = string.unpack(self:ReadBuf(4), self:_getLC("i"))
	return __v
end

---WriteInt
function BJMByteArray:WriteInt(__int)
	local __s = string.pack( self:_getLC("i"),  __int)
	self:WriteBuf(__s)
	return self
end

---ReadUInt
function BJMByteArray:ReadUInt()
	local __, __v = string.unpack(self:ReadBuf(4), self:_getLC("I"))
	return __v
end

---WriteUInt
function BJMByteArray:WriteUInt(__uint)
	local __s = string.pack(self:_getLC("I"), __uint)
	self:WriteBuf(__s)
	return self
end

---ReadShort
function BJMByteArray:ReadShort()
	local __, __v = string.unpack(self:ReadBuf(2), self:_getLC("h"))
	return __v
end

---WriteShort
function BJMByteArray:WriteShort(__short)
	local __s = string.pack( self:_getLC("h"),  __short)
	self:WriteBuf(__s)
	return self
end

---ReadUShort
function BJMByteArray:ReadUShort()
	local __, __v = string.unpack(self:ReadBuf(2), self:_getLC("H"))
	return __v
end

---WriteUShort
function BJMByteArray:WriteUShort(__ushort)
	local __s = string.pack(self:_getLC("H"),  __ushort)
	self:WriteBuf(__s)
	return self
end

---ReadLong
function BJMByteArray:ReadLong()
	local __, __v = string.unpack(self:ReadBuf(8), self:_getLC("l"))
	return __v
end

---WriteLong
function BJMByteArray:WriteLong(__long)
	local __s = string.pack( self:_getLC("l"),  __long)
	self:WriteBuf(__s)
	return self
end

---ReadULong
function BJMByteArray:ReadULong()
	local __, __v = string.unpack(self:ReadBuf(4), self:_getLC("L"))
	return __v
end

---WriteULong
function BJMByteArray:WriteULong(__ulong)
	local __s = string.pack( self:_getLC("L"), __ulong)
	self:WriteBuf(__s)
	return self
end

---ReadUByte
function BJMByteArray:ReadUByte()
	local __, __val = string.unpack(self:ReadRawByte(), "b")
	return __val
end

---WriteUByte
function BJMByteArray:WriteUByte(__ubyte)
	local __s = string.pack("b", __ubyte)
	self:WriteBuf(__s)
	return self
end

---ReadLuaNumber
function BJMByteArray:ReadLuaNumber(__number)
	local __, __v = string.unpack(self:ReadBuf(8), self:_getLC("n"))
	return __v
end

---WriteLuaNumber
function BJMByteArray:WriteLuaNumber(__number)
	local __s = string.pack(self:_getLC("n"), __number)
	self:WriteBuf(__s)
	return self
end

---ReadStringBytes
function BJMByteArray:ReadStringBytes()
	local __len = self:ReadShort()
	--assert(__len, "Need a length of the string!")
	if __len == 0 then return "" end
	self:_CheckAvailable()
	local __, __v = string.unpack(self:ReadBuf(__len), self:_getLC("A"..__len))
	self._pos = self._pos + __len
	return __v
end

function BJMByteArray:ReadLenStringBytes(__len)
	self:_CheckAvailable()
	local __, __v = string.unpack(self:ReadBuf(__len), self:_getLC("A"..__len))
	return __v
end

---WriteStringBytes
function BJMByteArray:WriteStringBytes(__string)
	local len = string.len(__string)
	self:WriteShort(len)
	local __s = string.pack(self:_getLC("A"), __string)
	self:WriteBuf(__s)
	return self
end

--- DO NOT use this method, it's inefficient.
-- Alternatively use ReadStringBytes.
function BJMByteArray:ReadString()
	-- cclog("pos1: " .. self._pos)
	local __len = self:ReadShort()
	-- cclog("ReadString len: " .. __len)
	-- cclog("pos2: " .. self._pos)
	-- cclog("#self._buf=" .. #self._buf)

	--assert(__len, "Need a length of the string!")
	if __len == 0 then return "" end
	self:_CheckAvailable()
	local __bytes = ""
	for i=self._pos, (self._pos + __len-1) do
		local __byte = string.byte(self._buf[i])
		__bytes = __bytes .. string.char(__byte)
	end
	self._pos = self._pos + __len
	--cclog("pos3: " .. self._pos)
	return __bytes
end

---WriteString
function BJMByteArray:WriteString(__string)
	local len = string.len(__string)
	cclog("len------------" .. len)
	self:WriteShort(len)
	self:WriteBuf(__string)
	return self
end

---ReadStringUInt
function BJMByteArray:ReadStringUInt()
	self:_CheckAvailable()
	local __len = self:ReadUInt()
	return self:ReadStringBytes(__len)
end

---WriteStringUInt
function BJMByteArray:WriteStringUInt(__string)
	self:WriteUInt(#__string)
	self:WriteStringBytes(__string)
	return self
end

--- The length of size_t in C/C++ is mutable.
-- In 64bit os, it is 8 bytes.
-- In 32bit os, it is 4 bytes.
function BJMByteArray:ReadStringSizeT()
	self:_CheckAvailable()
	local __s = self:RawUnPack(self:_getLC("a"))
	return  __s
end

--- Perform rawPack() simply.
function BJMByteArray:WriteStringSizeT(__string)
	self:RawPack(self:_getLC("a"), __string)
	return self
end

---ReadStringUShort
function BJMByteArray:ReadStringUShort()
	self:_CheckAvailable()
	local __len = self:ReadUShort()
	return self:ReadStringBytes(__len)
end

---WriteStringUShort
function BJMByteArray:WriteStringUShort(__string)
	local __s = string.pack(self:_getLC("P"), __string)
	self:WriteBuf(__s)
	return self
end

--- Read some bytes from buf
-- @return a bit string
function BJMByteArray:ReadBytes(__bytes, __offset, __length)
	--assert(iskindof(__bytes, "BJMByteArray"), "Need a BJMByteArray instance!")
	local __selfLen = #self._buf
	local __availableLen = __selfLen - self._pos
	__offset = __offset or 1
	if __offset > __selfLen then __offset = 1 end
	__length = __length or 0
	if __length == 0 or __length > __availableLen then __length = __availableLen end
	__bytes:SetPos(__offset)
	for i=__offset,__offset+__length do
		__bytes:WriteRawByte(self:ReadRawByte())
	end
end

--- Write some bytes into buf
function BJMByteArray:WriteBytes(__bytes, __offset, __length)
	--assert(iskindof(__bytes, "BJMByteArray"), "Need a BJMByteArray instance!")
	local __bytesLen = __bytes:GetLen()
	if __bytesLen == 0 then return end
	__offset = __offset or 1
	if __offset > __bytesLen then __offset = 1 end
	local __availableLen = __bytesLen - __offset
	__length = __length or __availableLen
	if __length == 0 or __length > __availableLen then __length = __availableLen end
	local __oldPos = __bytes:GetPos()
	__bytes:SetPos(__offset)
	for i=__offset,__offset+__length do
		self:WriteRawByte(__bytes:ReadRawByte())
	end
	__bytes:SetPos(__oldPos)
	return self
end

--- Actionscript3 readByte == lpack readChar
-- A signed char
function BJMByteArray:ReadChar()
	local __, __val = string.unpack( self:ReadRawByte(), "c")
	return __val
end

---WriteChar
function BJMByteArray:WriteChar(__char)
	self:WriteRawByte(string.pack("c", __char))
	return self
end

--- Use the lua string library to get a byte
-- A unsigned char
function BJMByteArray:ReadByte()
	return string.byte(self:ReadRawByte())
end

--- Use the lua string library to write a byte.
-- The byte is a number between 0 and 255, otherwise, the lua will get an error.
function BJMByteArray:WriteByte(__byte)
	self:WriteRawByte(string.char(__byte))
	return self
end

---ReadRawByte
function BJMByteArray:ReadRawByte()
	self:_CheckAvailable()
	local __byte = self._buf[self._pos]
	self._pos = self._pos + 1
	return __byte
end

---WriteRawByte
function BJMByteArray:WriteRawByte(__rawByte)
	if self._pos > #self._buf+1 then
		for i=#self._buf+1,self._pos-1 do
			self._buf[i] = string.char(0)
		end
	end
	self._buf[self._pos] = string.sub(__rawByte, 1,1)
	self._pos = self._pos + 1
	return self
end

--- Read a byte array as string from current position, then update the position.
function BJMByteArray:ReadBuf(__len)
	--printf("readBuf,len:%u, pos:%u", __len, self._pos)
	local __ba = self:GetBytes(self._pos, self._pos + __len - 1)
	self._pos = self._pos + __len
	return __ba
end

--- Write a encoded char array into buf
function BJMByteArray:WriteBuf(__s)
	for i=1,#__s do
		self:WriteRawByte(__s:sub(i))
	end
	return self
end

---Encode & Compress functions
--@section file

--- Encode
function BJMByteArray:Encode(key, offset)
	local _offset = offset or 0
	local bytes = string.pack_encode(self:GetPack(), self:GetLen(), _offset, key:GetPack(), key:GetLen())
	self:SetPos(1)
	local n = #bytes
	for i = 1, #bytes, 1 do
		self:WriteRawByte(bytes:sub(i))	
	end
end

--- Decode
function BJMByteArray:Decode(key, offset)
	local _offset = offset or 0
	local bytes = string.pack_decode(self:GetPack(), self:GetLen(), _offset, key:GetPack(), key:GetLen())
	self:SetPos(1)
	for i = 1, #bytes, 1 do
		self:WriteRawByte(bytes:sub(i))	
	end
end

--- Encode2
function BJMByteArray:Encode2(key, offset)
	local _offset = offset or 0
	local bytes = string.pack_encode2(self:GetPack(), self:GetLen(), _offset, key:GetPack(), key:GetLen())
	self:SetPos(1)
	local n = #bytes
	for i = 1, #bytes, 1 do
		self:WriteRawByte(bytes:sub(i))	
	end
end

--- Decode2
function BJMByteArray:Decode2(key, offset)
	local _offset = offset or 0
	local bytes = string.pack_decode2(self:GetPack(), self:GetLen(), _offset, key:GetPack(), key:GetLen())
	self:SetPos(1)
	for i = 1, #bytes, 1 do
		self:WriteRawByte(bytes:sub(i))	
	end
end

--- Compress
function BJMByteArray:Compress(offset)
	local _offset = offset or 0
	local bytes = string.pack_compress(self:GetPack(), self:GetLen(), _offset)
	self:SetPos(1)
	self._buf = {}
	for i = 1, #bytes, 1 do
		self:WriteRawByte(bytes:sub(i))	
	end
	self:SetPos(offset + 1)
end

--- Uncompress
function BJMByteArray:Uncompress(offset)
	local _offset = offset or 0
	local bytes = string.pack_uncompress(self:GetPack(), self:GetLen(), _offset)

	self:SetPos(1)
	self._buf = {}
	for i = 1, #bytes, 1 do
		--dump(bytes:sub(i), "bytes:sub(i)")
		self:WriteRawByte(bytes:sub(i))	
	end
	self:SetPos(offset + 1)
end

--- Uncompress2
function BJMByteArray:Uncompress2(offset)
	local _offset = offset or 0
	return BJMPack:UnCompress(self:GetPack(), self:GetLen(), _offset)
end

----------------------------------------
-- private
----------------------------------------

-- CheckAvailable
-- @local
function BJMByteArray:_CheckAvailable()
	--assert(#self._buf >= self._pos, string.format("End of file was encountered. pos: %d, len: %d.", self._pos, #self._buf))
end

-- Get Letter Code
-- @local
function BJMByteArray:_getLC(__fmt)
	__fmt = __fmt or ""
	if self._endian == BJMByteArray.ENDIAN_LITTLE then
		return "<"..__fmt
	elseif self._endian == BJMByteArray.ENDIAN_BIG then
		return ">"..__fmt
	end
	return "="..__fmt
end