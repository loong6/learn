--[[
Author : ZangXu @Bojoy 2014
FileName: BJMEncrypt.lua
Description: 
]]

---BJMEncrypt
-- @module bjm.util.encrypt

local util = bjm.util

--require "bit"

require(bjm.PACKAGE_NAME .. ".global.BJMGlobalConstant")
--require(bjm.PACKAGE_NAME .. ".net.BJMPacketBuffer")
require(bjm.PACKAGE_NAME .. ".util.BJMByteArray")

util.encrypt = {}

local encrypt = util.encrypt

--[[------------------------------------------------------------------------------
set key
]]
encrypt.SetKey = function(encryptType, key)
	BJMEncryptUtil:SetKey(encryptType, key)
end

--[[------------------------------------------------------------------------------
encode
return result
]]
encrypt.Encode = function(encryptType, content)
	return BJMEncryptUtil:Encode(encryptType, content)
end

--[[------------------------------------------------------------------------------
decode
return result
]]
encrypt.Decode = function(encryptType, content)
	return BJMEncryptUtil:Decode(encryptType, content)
end

--[[------------------------------------------------------------------------------
set key - bojoy encrypty
]]
encrypt.SetKeyBojoy = function(key)
	encrypt.SetKey(bjm.global.encrypt.bojoy, key)
end


--[[------------------------------------------------------------------------------
encode - bojoy encrypt
return result
]]
encrypt.EncodeBojoy = function(content)
	return encrypt.Encode(bjm.global.encrypt.bojoy, content)
end

--[[------------------------------------------------------------------------------
decode - bojoy encrypt
return result
]]
encrypt.DecodeBojoy = function(content)
	return encrypt.Decode(bjm.global.encrypt.bojoy, content)
end

--[[------------------------------------------------------------------------------
encode - base64 encrypt
return result
]]
encrypt.EncodeBase64 = function(content)
	return BJMBase64:Encode(content)
end

--[[------------------------------------------------------------------------------
decode - base64 encrypt
return result
]]
encrypt.DecodeBase64 = function(content)
	return BJMBase64:Decode(content)
end