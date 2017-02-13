--[[
Author : Zoulisheng @Bojoy 2014
FileName: ControllerInit.lua
Description: 
]]

---ControllerInit
-- @module bjm.control

local ui = bjm.ui
ui.control = {}
local control = ui.control

---获得一个拖动控制对象
--@see bjm.ui.controller.DragController
control.GetDragControl = function (  )
	return require(bjm.PACKAGE_NAME .. ".ui.controller.DragController").new()
end