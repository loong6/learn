---BJMActionManager
-- @module bjm.ani

local ani = bjm.ani



--[[------------------------------------------------------------------------------
jump like a jelly
@param params
[strength 0-0.5 default 0.2][jump_high][duration] [ originScale  初始化的scale值].
@return cc.action
]]
ani.JellyJump = function(params)
	params = params or {}
	local strength = params.strength or 0.2
	local jump_high = params.jump_high or 20
	local duration = params.duration or 0.5
	local originScale = params.originScale or 1

	local dur1 = duration/0.5*0.1
	local dur2 = duration/0.5*0.3

	local scaleX = originScale+strength
	local scaleY = originScale-strength

	local scale1 = cc.ScaleTo:create(dur1,scaleX,scaleY)
	local scale2 = cc.ScaleTo:create(dur2,originScale,originScale)
	local jumpAct = cc.JumpBy:create(duration,cc.p(0,0),jump_high,1)
	local spwanAct = cc.Spawn:create(scale2,jumpAct)
	local sequenceAct = cc.Sequence:create(scale1,spwanAct)
	return sequenceAct
end

--[[------------------------------------------------------------------------------
zoom like a jelly ,usually used in clickUp
@param params
[scale_x  default 0.8][scale_y default 0.8][duration default 1.1] [delay default 0.1 ] [ originScale  初始化的scale值].
@return cc.action
]]
ani.JellyZoom = function(params)
	params = params or {}
	local scale_x = params.scale_x or 0.8
	local scale_y = params.scale_y or 0.8
	local duration = params.duration or 1.1
	local delay = params.delay or 0.1
	local originScale = params.originScale or 1.0
	local isFromSmall = params.fromSmall or false
	
	local spwanAct = nil
	if(isFromSmall == true) then
		scale_x = 1.1
		scale_y = 1.1
	end

	local act1 = cc.EaseElasticOut:create(cc.ScaleTo:create(duration,scale_x,scale_y))
	local act2 = cc.EaseElasticOut:create(cc.ScaleTo:create(duration,originScale,originScale))
	local sequenceAct = cc.Sequence:create(cc.DelayTime:create(delay),act2)
	spwanAct = cc.Spawn:create(act1,sequenceAct)

	return spwanAct
end


--[[------------------------------------------------------------------------------
 node appear as a seal
]]
ani.SealAppear = function (callBack,originScaleX,originScaleY, isFromSmall)
	originScaleX = originScaleX or 1.0
	originScaleY = originScaleY or 1.0
	isFromSmall  = isFromSmall  or false

	local function resetFunc(node)
		if(isFromSmall == true) then
			node:setScaleX(originScaleX*0.1)
			node:setScaleY(originScaleY*0.1)
		else
			node:setScaleX(originScaleX*5)
			node:setScaleY(originScaleY*5)
		end
	end

	local function callBackFunc()
		if callBack~=nil then callBack() end
	end

	local actAry = {}
	table.insert(actAry,cc.CallFunc:create(resetFunc))
	table.insert(actAry,cc.ScaleTo:create(0.10,originScaleX,originScaleY))
	if callBack~=nil then
		table.insert(actAry,cc.CallFunc:create(callBackFunc))
	end
	table.insert(actAry,ani.JellyZoom({originScale=originScaleX,fromSmall=isFromSmall}))
	
	local seqAct = cc.Sequence:create(actAry)
	return seqAct
end

--[[------------------------------------------------------------------------------
1st. the node setPosition to the start Point
2nd. the node moving to the origin Position
@param params
[shift_x][shift_y][isEase][duration][easeType].
]]
ani.MoveFrom = function(params)
	params = params or {}
	local shiftX = params.shift_x or 0
	local shiftY = params.shift_y or 0
	local isEase = params.isEase or false
	local easeType = params.easeType or 1

	local function posResetFunc(node,t)
		local tableX = t.shiftX or 0
		local tableY = t.shiftY or 0

		if (tableX~= 0) then
			local originX = node:getPositionX()
			node:setPositionX(originX-tableX)
		end
		if (tableY ~= 0) then
			local originY = node:getPositionY()
			node:setPositionY(originY+tableY)
		end
	end
	local callFunc = cc.CallFunc:create(
							posResetFunc,
							{shiftX = shiftX,shiftY = shiftY}
							)



	local duration = params.duration or 0.5
	local moveAct = cc.MoveBy:create(duration,cc.p(shiftX,(0-shiftY)))

	if (isEase == true) then
		if easeType == 1 then
			return cc.Sequence:create(callFunc,cc.EaseElasticOut:create(moveAct))
		elseif easeType == 2 then
			return cc.Sequence:create(callFunc,cc.EaseExponentialOut:create(moveAct))
		else

		end

		
	else 
		return cc.Sequence:create(callFunc,moveAct)
	end
end

--[[------------------------------------------------------------------------------
character appear as a typewriter Label use
@param params
[string= origin str][speed = default 0.06].
]]
ani.LabelTypewriter = function (params)
	params = params or {}
	if params.string == nil then return end
	if params.string == "" then return end
	local speed = params.speed or 0.06
	local curStr = params.string

	local strLen = string.utf8Len(curStr)
	local strIdx = 1
	local actAry = {}
	while strIdx<=strLen do
		
		local function LabelShowStr(node,data)
			node = bjm.util.cast(node,"BJMLabel")
			if node~=nil and node.SetString ~=nil then
				node:SetString(data.str)
			end
		end
	
		local showStr = string.utf8Sub(curStr,0,strIdx)
		local callFunc = cc.CallFunc:create(LabelShowStr,{str=showStr})
		local delayAct = cc.DelayTime:create(speed)
		table.insert(actAry,delayAct)
		table.insert(actAry,callFunc)
		strIdx = strIdx+1
	end
	return cc.Sequence:create(actAry)
end


---open logic by moveAction
ani.LogicOpenFromDirection = function ( tarLogic , callFuncAfter , direction )
	if direction == nil then direction="left" end

	local DefaultWnd = tarLogic:GetView()
	DefaultWnd:setVisible(false)	

	local function startFunc()
		DefaultWnd:setVisible(true)
	end
	local function endFunc()
		if callFuncAfter~=nil then callFuncAfter() end
	end

	local screenSize = cc.Director:getInstance():getVisibleSize()

	local seqTable = {}
	table.insert(seqTable,cc.DelayTime:create(0.05))
	table.insert(seqTable,cc.CallFunc:create(startFunc))
	if direction=="left" then
		table.insert(seqTable,ani.MoveFrom({shift_x = screenSize.width ,duration = 0.4,isEase = false}))
	elseif direction=="right" then
		table.insert(seqTable,ani.MoveFrom({shift_x = -screenSize.width ,duration = 0.4,isEase = false}))
	elseif direction=="top" then
		table.insert(seqTable, ani.MoveFrom({shift_y = screenSize.height ,duration = 0.4,isEase = false}))
	elseif direction=="bottom" then
		table.insert(seqTable, ani.MoveFrom({shift_y = -screenSize.height ,duration = 0.4,isEase = false}))
	elseif direction == "seal_from_big" then
		table.insert(seqTable, ani.SealAppear(endFunc))
	elseif direction == "seal_from_small" then
		table.insert(seqTable, ani.SealAppear(endFunc,nil,nil,true))
	end

	if(direction ~= "seal_from_big" and direction ~= "seal_from_small") then
		table.insert(seqTable,cc.DelayTime:create(0.05))
		table.insert(seqTable,cc.CallFunc:create(endFunc))
	end
	local act = cc.Sequence:create(seqTable)
	DefaultWnd:runAction(act)
end

---close logic by moveAction
ani.LogicCloseToDirection = function (tarLogic , callFuncAfter , direction)
	if direction==nil then direction="left" end
	local function closeFunc()
		if callFuncAfter~=nil then callFuncAfter() end
		tarLogic:Close()
	end

	local screenSize = cc.Director:getInstance():getVisibleSize()
	local seqTable = {}
	if direction=="left" then
		table.insert(seqTable,cc.MoveBy:create(0.2,cc.p(-screenSize.width,0)))
	elseif direction=="right" then
		table.insert(seqTable,cc.MoveBy:create(0.2,cc.p(screenSize.width,0)))
	elseif direction=="top" then
		table.insert(seqTable,cc.MoveBy:create(0.2,cc.p(0,screenSize.height)))
	elseif direction=="bottom" then	
		table.insert(seqTable,cc.MoveBy:create(0.2,cc.p(0,-screenSize.height)))
	end
	table.insert(seqTable ,cc.DelayTime:create(0.1) )
	table.insert(seqTable,cc.CallFunc:create(closeFunc))
	local act = cc.Sequence:create(seqTable)

	local DefaultWnd = tarLogic:GetView()
	DefaultWnd:stopAllActions()
	DefaultWnd:runAction(act)
end


---logic 打开的时候动作  从小变大
ani.LogicOpenFromSmall = function ( tarLogic ,callFuncAfter)
	local DefaultWnd = tarLogic:GetView()
	DefaultWnd:setVisible(false)

	local function startFunc(node)
		node:setScaleX(0.3)
		node:setScaleY(0.3)
		DefaultWnd:setVisible(true)
	end

	local function endFunc()
		if callFuncAfter~=nil then callFuncAfter() end
	end

	local actStart = cc.CallFunc:create(startFunc)
	local act1 = cc.ScaleTo:create(0.2,1.1,1.1)
	local act2 = cc.ScaleTo:create(0.05,1,1)
	local actEnd = cc.CallFunc:create(endFunc)

	local act = cc.Sequence:create(actStart,act1,act2,actEnd)

	DefaultWnd:runAction(act)
end

---logic 关闭的时候动作  从大变小  callFuncAfter=关闭之后的调用函数
ani.LogicCloseToSmall = function ( tarLogic ,callFuncAfter)
	local DefaultWnd = tarLogic:GetView()
	DefaultWnd:stopAllActions()
	local function hideFunc()
		DefaultWnd:setVisible(false)
	end

	local function closeFunc()
		if callFuncAfter~=nil then callFuncAfter() end
		tarLogic:Close()
	end

	local actEnd = cc.CallFunc:create(closeFunc)
	local act1 = cc.ScaleTo:create(0.2,0.0,0.0)

	local dealyAct = cc.DelayTime:create(0.1)
	local hideCall = cc.CallFunc:create(hideFunc)

	local act = cc.Sequence:create(act1,hideCall,dealyAct,actEnd)
	DefaultWnd:runAction(act)
end