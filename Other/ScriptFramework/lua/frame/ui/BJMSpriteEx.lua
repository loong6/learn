--[[
Author : ZangXu @Bojoy 2014
FileName: BJMSpriteEx.lua
Description: BJMSprite Extension
]]

---BJMSprite
-- @module bjm.ui.Sprite

local ui = bjm.ui
ui.Sprite = BJMSprite

--[[------------------------------------------------------------------------------
-**
load from from url
*]]
function ui.Sprite:SetRemoteRes(logic, url, cache_uri, http_header, force_use_remote)
	force_use_remote = force_use_remote or false
	if (force_use_remote == false and bjm.util.io.FileExistsFileSystem(cache_uri) == true) then
		self:SetResID(cache_uri)
		self:Update()
		do return end
	end

	if (logic == nil) then
		cclog("logic can't be nil!")
		return
	end
	http_header = http_header or ""
	local logic_name = logic:GetLogicName()
	if logic_name == nil then return end

	local hash = tostring(bjm.util.HashCode(url))
	bjm.net.http.QueryFileAsync(hash, url, cache_uri, "", http_header)

	if (logic.remoteResTable == nil) then
		logic.remoteResTable = {}
	end

	logic.remoteResTable[hash] = self

	-- register clean up function
	self._logic 	= logic
	self._hash 		= hash
	self._logic_name = logic_name
	if (self.OnDestroy == nil) then
		self.OnDestroy = function (_self)
			if (_self._logic ~= nil) then
				if (_self._logic.remoteResTable ~= nil and _self._hash ~= nil) then
					_self._logic.remoteResTable[_self._hash] = nil
				end
			end
		end
	end
	self:RegisterOnDestroyScriptFunc(self.OnDestroy)

	local regFuncHeadCode = "return function (logic) \n logic.On" .. hash .. " = function(self, conn, data)\n"
	local regFuncBody = [[
		if (data == "fail") then
			do return end
		end
		if (self.OnHash ~= nil) then
			self:OnHash(conn, data)
		end
	end
	end
	]]
	
	local f = loadstring(regFuncHeadCode .. regFuncBody)
	f()(logic)
	local regCode = "return function (logic) \n bjm.reg.RegLogicFunction(logic, bjm.global.function_type.http_ret, '" .. 
		hash .. "', logic.On" .. hash .. ") end\n"
	f = loadstring(regCode)
	f()(logic)

	if (logic.OnHash == nil) then
		logic.OnHash = function (self, hash, uri)
			if (self.remoteResTable == nil) then
				cclog("remote res table is nil")
				do return end
			end
			local sprite = self.remoteResTable[hash]
			if (sprite == nil) then
				cclog("sprite destroyed before net image retrieved...")
				do return end
			end
			local logicname = sprite._logic_name
			if logicname == nil then
				cclog("logicname is nil ... ")
				return
			end
			local curLogic = bjm.logic.manager.FindLogic(logicname)
			if curLogic == nil then
				cclog("Logic destroyed before net image retrieved 1...")
				return
			end

			if curLogic ~= self then
				cclog("Logic destroyed before net image retrieved 2...")
				return
			end

			sprite:SetResID(uri)
			sprite:Update()
		end
	end
end