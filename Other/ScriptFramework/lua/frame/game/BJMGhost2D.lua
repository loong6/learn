--[[
Author : ZangXu @Bojoy 2015
FileName: BJMGhost2D.lua
Description: 
base class of all object on the map
]]


local Ghost2D = class("BJMGhost2D")

--[[------------------------------------------------------------------------------
-**
*]]
function Ghost2D:ctor()
	self.body = nil
	self.type = -1
	self.tx = 0
	self.ty = 0
	self.id = 0
	self.staticID = 0
end

--[[------------------------------------------------------------------------------
-**
*]]
function Ghost2D:Init()

end

--[[------------------------------------------------------------------------------
-**
*]]

function Ghost2D:FindPath(from, to, pathType)
	self:RemovePath()
	local pathFinder = bjm.game.map2d.GetPathFinder(pathType)
	if pathFinder then
		self.path = pathFinder:PathFinding(from, to)
	else
		return nil
	end
	return self.path
end

function Ghost2D:GetPath()
	return self.path
end

function Ghost2D:RemovePath()
	if self.path then
		bjm.game.map2d.RemovePath(self.path)
	end
	self.path = nil
end


--[[------------------------------------------------------------------------------
-**
*]]
function Ghost2D:NeedReorder()
	return true
end

--[[------------------------------------------------------------------------------
-**
*]]
function Ghost2D:Attach(target, order)
	if (target == nil or self.body == nil) then
		cclog("ghost attach failed!")
		return
	end

	order = order or 1
	target:addChild(self.body, order)
end

--[[------------------------------------------------------------------------------
-**
*]]
function Ghost2D:Detach(target)
	if (target == nil or self.body == nil) then
		cclog("ghost attachme failed!")
		return
	end
	self.body:removeAllChildren()
	self.body:release()
	target:removeChild(self.body, true)
	self.body = nil

	self:RemovePath()
end

--[[------------------------------------------------------------------------------
-**
*]]
function Ghost2D:AttachMe(child)
	if (target == nil or self.body == nil) then
		cclog("ghost attachme failed!")
		return
	end

	self.body:addChild(child)
end

------------------------------------- move functions -------------------------------------
--[[------------------------------------------------------------------------------
-**
*]]
function Ghost2D:Update()
	-- override me!
end

--[[------------------------------------------------------------------------------
-**
*]]
function Ghost2D:GetBody()
	return self.body
end

--[[------------------------------------------------------------------------------
-**
*]]
function Ghost2D:GetMapPosition()
	local pt = self:GetSpritePosition()

	local winSize = cc.Director:getInstance():getWinSize()
	return cc.p(pt.x, winSize.height - pt.y)
end

--[[------------------------------------------------------------------------------
-**
*]]
function Ghost2D:SetMapPosition(dir, tx, ty)
	if (self.body == nil) then
		return
	end


	local pt = bjm.game.map2d.GetPixelPoint(tx, ty)
	local winSize = cc.Director:getInstance():getWinSize()
	pt = cc.p(pt.x, winSize.height - pt.y)
	self.body:setPosition(pt)
end

--[[------------------------------------------------------------------------------
-**
*]]
function Ghost2D:GetSpritePosition()
	if (self.body == nil) then
		return cc.p(0,0)
	end

	return self.body:getPosition2D()
end

--[[------------------------------------------------------------------------------
-**
*]]
function Ghost2D:SetGhostZOrder(zorder)
	self:SetZOrder(zorder)
end

--[[------------------------------------------------------------------------------
-**
*]]
function Ghost2D:SetZOrder(zorder)
	if (self.body == nil) then
		return
	end
	self.body:setLocalZOrder(zorder)
end

--[[------------------------------------------------------------------------------
-**
*]]
function Ghost2D:GetZOrder()
	return self.body:getLocalZOrder()
end

--[[------------------------------------------------------------------------------
-**
*]]
function Ghost2D:IsSelected(touchPos)
	if (self.body ~= nil and self.type ~= -1) then
		local pos = self.body:convertToNodeSpace(touchPos)
		local size = self.body:getContentSize()
		local rect = cc.rect(0,0,contentSize.width,contentSize.height)
		if (cc.rectContainsPoint(rect, pos) == true) then
			return true
		end
	end

	return false
end

return Ghost2D