--[[
Author : ZangXu @Bojoy 2014
FileName: BJMAppCallback.lua
Description: 
deal some application callbacks
1. app will e
]]

---BJMAppCallback
-- @module bjm.app

local app = bjm.app

--- global app callbacks
app.callback = {}

local instance = nil

local function Instance()
	if (instance ~= nil) then do return instance end end
	return BJMAppCallback:Instance()
end

--[[------------------------------------------------------------------------------
ctor
]]
function app.callback:ctor()
	Instance():RegisterKeyBoardScriptFunc(self.OnKeyboardEnter)
	Instance():RegisterApplicationDidEnterBackgroundScripttFunc(self.OnApplicationDidEnterBackground)
	Instance():RegisterApplicationWillEnterForegroundScriptFunc(self.OnApplicationWillEnterForeground)
end

--[[------------------------------------------------------------------------------
keyboard
]]
function app.callback.OnKeyboardEnter(key , is_press)
	--cclog("app.callback.OnKeyboardEnter: " .. key)
end



--[[------------------------------------------------------------------------------
-**
application did enter background
*]]
function app.callback.OnApplicationDidEnterBackground()
	cclog("app.callback.OnApplicationDidEnterBackground")
end

--[[------------------------------------------------------------------------------
-**
application will enter foreground
*]]
function app.callback.OnApplicationWillEnterForeground()
	cclog("app.callback.OnApplicationWillEnterForeground")
end
