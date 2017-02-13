--[[
Author : ZangXu @Bojoy 2014
FileName: BJMSystemGui.lua
Description: 
]]

---BJMSystemGui
-- @module bjm.ui.system
-- @alias ui.manager

local ui = bjm.ui

ui.system = {}

local waiting = nil

--[[------------------------------------------------------------------------------
-**
create or show waiting
*]]
ui.system.ShowWaiting = function(content)
	if (waiting == nil) then
		waiting = BJMSystemWaiting:CreateAndShow(content)
	else
		waiting:SetContent(content)
	end
end

--[[------------------------------------------------------------------------------
-**
close waiting
*]]
ui.system.CloseWaiting = function()
	if (waiting ~= nil) then
		waiting:Close()
		waiting = nil
	end
end

--[[------------------------------------------------------------------------------
-**
create or show dialog
buttons is a table
*]]
ui.system.ShowDialog = function(title, content, callback, buttons)
	BJMSystemDialog:CreateAndShow(
		title,
		content,
		callback,
		buttons
		)
end

--[[------------------------------------------------------------------------------
-**
create or show dialog
buttons is a table
*]]
ui.system.ShowErrorBox = function(content)
	BJMSystemDialog:CreateAndShow(
		"error",
		content,
		function(index)

		end,
		{"OK"}
		)
end

--[[------------------------------------------------------------------------------
-**
open image selector
compressFormat can be "jpg" or "png"
callback signature:
function callback (outputUri, success)

scale_callback signature:
function scale_callback (width, height)
	-- reset width and height
	return "width,height"
end

quality: [15, 100]
if outputWidth and outputHeight are all zero, image won't be cropped.
*]]
ui.system.OpenImageSelector = function (outputWidth, outputHeight, scale_callback, compressFormat, quality, outputUri, callback, use_camera)
	compressFormat = compressFormat or "jpg"
	use_camera = use_camera or false
	if (scale_callback == nil) then
		scale_callback = function ()
			return "0,0"
		end
	end

	BJMSystemImageSelector:CreateAndShow(
		outputWidth,
		outputHeight,
		scale_callback,
		compressFormat,
		quality,
		outputUri,
		callback,
		use_camera
		)
end

--[[------------------------------------------------------------------------------
-**
open gallery
ary_uri is array of file uri (only support files on file system)
*]]
ui.system.OpenGallery = function(ary_uri, start_index)
	start_index = start_index or 0
	
	BJMSystemGallery:CreateAndShow(ary_uri, start_index)
end


--[[------------------------------------------------------------------------------
-**
open datepicker
*]]
ui.system.OpenDatePicker = function(date, callback)
	BJMDatePicker:CreateAndShow(date, callback)
end

--[[------------------------------------------------------------------------------
-**
open QRCode scanner
*]]
ui.system.OpenQRCodeScanner = function(callback)
	BJMQRCode:CreateAndShow(callback)
end

--[[------------------------------------------------------------------------------
-**
generate QRCode
*]]
ui.system.GenerateQRCode = function(strData, imageURI)
	BJMQRCode:GenerateImage(strData, imageURI)
end