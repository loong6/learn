--[[
Author : ZangXu @Bojoy 2015
FileName: BJMMap2D.lua
Description: 
]]

---BJMMap2D
-- @module bjm.game.map2d
-- @alias game.map2d

local game = bjm.game

game.map2d = {}

local instance = nil

game.map2d.TILE_WIDTH = 48
game.map2d.TILE_HEIGHT = 32

local logicWidth = 0
local logicHeight = 0

local isDebug = false

local function Instance()
	if (instance ~= nil) then do return instance end end
	return BJMMapManager:Instance()
end


game.map2d.SetTileSize = function ( w,h )
	Instance():SetTileSize(w,h)
	game.map2d.TILE_WIDTH = w
	game.map2d.TILE_HEIGHT = h
end

--[[------------------------------------------------------------------------------
set map debug mode
]]
game.map2d.SetDebug = function(bool)
	isDebug = bool
end


--[[------------------------------------------------------------------------------
set node which will render map
]]
game.map2d.SetMapNode = function(node)
	Instance():SetMapNode(node)
end

--[[------------------------------------------------------------------------------
set node which will render map
]]
game.map2d.ClearMap = function()
	Instance():ClearMap()
end

--[[------------------------------------------------------------------------------
-**
change map
*]]
game.map2d.SwitchMap = function (mapName,resFolderName)
	if resFolderName == nil or resFolderName=="" or mapName==resFolderName then
		Instance():SwitchMap(mapName , isDebug)
	else
		Instance():SwitchMap(mapName ,resFolderName, isDebug)
	end
	

	logicWidth = Instance():GetLogicWidth()
	logicHeight = Instance():GetLogicHeight()
end




--[[------------------------------------------------------------------------------
-**
update focus position
*]]
game.map2d.UpdateFocusPos = function (focus)
	Instance():UpdateFocusPos(focus)
end

--[[------------------------------------------------------------------------------
-**
get focus position
*]]
game.map2d.GetFocusPos = function ()
	return Instance():GetFocusPos()
end

--[[------------------------------------------------------------------------------
-**
tile position to pxiel position
*]]
game.map2d.GetPixelPoint = function (tx, ty)
	local pt = cc.p(0,0)
	pt.x = tx * game.map2d.TILE_WIDTH + game.map2d.TILE_WIDTH / 2
	pt.y = ty * game.map2d.TILE_HEIGHT + game.map2d.TILE_HEIGHT / 2
	return pt
end

--[[------------------------------------------------------------------------------
-**
*]]
game.map2d.GetLogicWidth = function ()
	return Instance():GetLogicWidth()
end

--[[------------------------------------------------------------------------------
-**
*]]
game.map2d.GetLogicHeight = function ()
	return Instance():GetLogicHeight()
end


--[[------------------------------------------------------------------------------
-**
*]]
game.map2d.GetTerrainType = function (tx , ty)
	return Instance():GetTerrainType(tx , ty)
end

--[[------------------------------------------------------------------------------
-**
is a blocked area?
*]]
game.map2d.IsBlocked = function (tx, ty)
	if tx <0 or ty<0 or tx> logicWidth or ty > logicHeight then return true end 
	return Instance():IsBlocked(tx, ty)
end

--[[------------------------------------------------------------------------------
-**
reset an area to be blocked 
*]]
game.map2d.SetBlocked = function(tx, ty)
	Instance():SetBlocked(tx, ty)
end

--[[------------------------------------------------------------------------------
-**
*]]
game.map2d.IsSheltered = function (tx, ty)
	if tx <0 or ty<0 or tx> logicWidth or ty > logicHeight  then return false end 
	return Instance():IsSheltered(tx, ty)
end


--[[------------------------------------------------------------------------------
-**
reset an area to be sheltered
*]]
game.map2d.SetSheltered = function(tx, ty)
	Instance():SetSheltered(tx, ty)
end

game.map2d.ClearBlockedAndSheltered = function(tx, ty)
	Instance():ClearBlockedAndSheltered(tx, ty)
end

game.map2d.ResetDebugLayout = function()
	return Instance():ResetDebugLayout()
end


--[[------------------------------------------------------------------------------
-**
*]]
game.map2d.IsMapLoaded = function ()
	return Instance():IsMapLoaded()
end

game.map2d.GetPathFinder = function(sType)
	return Instance():GetPathFinder(sType or "")
end

game.map2d.RemovePath = function(path)
	Instance():RemovePath(path)
end


game.map2d.GetBlockValue = function(x,y)
	return Instance():GetBlockValue(x,y)
end

game.map2d.SetBlockValue = function(x,y, value)
	return Instance():SetBlockValue(x,y, value)
end


game.map2d.AddDynamicLayer = function ( zorder , resid , tileW , tileH , collomn , row,idxStr,flipStr )
	Instance():AddDynamicLayer(zorder,resid,tileW,tileH,collomn,row,idxStr,flipStr)
end



game.map2d.SetDebugResID = function(resid)
	Instance():SetDebugResID(resid)
end

game.map2d.SetTerrainResID = function(resid)
	Instance():SetTerrainResID(resid)
end


	