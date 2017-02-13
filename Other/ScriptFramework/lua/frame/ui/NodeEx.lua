--[[
Author : ZangXu @Bojoy 2014
FileName: NodeEx.lua
Description:  Extension of cc.Node
]]

---Node
-- @module bjm.ui.Node

local ui = bjm.ui
ui.Node = cc.Node

function ui.Node:getPosition2D()
	return cc.p(self:getPositionX(), self:getPositionY())
end