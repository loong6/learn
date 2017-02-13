--[[
Author : Zoulisheng @Bojoy 2014
FileName: DragController.lua
Description: 
	拖拽控制器
]]

---DragController
-- @module bjm.controller.DragController
-- @alias controller

local controller = class('DragController')




function controller:ctor()
	--是否已经开始拖拽
	self.IsStarted = false
	--被拖拽的node
	self.DragNode = nil	
	--拖动的信息
	self.DragInfo = nil
	--可以被响应的区间的table
	self.RespondAreaTable = {}
	--当前所在的响应区域
	self.CurInAreaInfoID = nil
end


---初始化
--dragNode 用来显示拖拽的节点
function controller:Init(dragNode)
	self.DragNode = dragNode
end

---添加通用响应信息
-- logic    	= self,             	logic
-- endFunc  	= DragTableOnEnd    	在区域内结束拖动的回调
function controller:AddCommonRespond(info)
	self.common_respond = info
end

---添加一个响应区域
-- @usage
-- info 包括以下
-- logic    	= self,             	logic
-- name     	= GetTableName(i),  	区域的名称
-- rec      	= respondRec,       	区域的响应矩形
-- enterFunc	= DragTableOnEnter, 	进入区域的回调
-- leaveFunc	= DragTableOnLeave, 	离开区域的回调
-- endFunc  	= DragTableOnEnd    	在区域内结束拖动的回调
function controller:AddRespondArea(info)
	table.insert(self.RespondAreaTable,info)
end

---获得拖动的信息
function controller:GetDragInfo(  )
	return self.DragInfo
end


---拖动开始
function controller:Start(info)
	self.IsStarted = true
	self.DragInfo = info
end

---更新
function controller:Update(pos)
	if self.IsStarted==false then return end
	self.DragNode:setVisible(true)
	self.DragNode:setPosition(pos)

	--如果已经在某个响应区域内，只需要判断离开
	if self.CurInAreaInfoID~=nil then
		local info = self.RespondAreaTable[self.CurInAreaInfoID]
		local isIn = cc.rectContainsPoint(info.rec,pos)
		if isIn == false then
			if self.RespondAreaTable[self.CurInAreaInfoID].leaveFunc~=nil then
				self.RespondAreaTable[self.CurInAreaInfoID].leaveFunc(info.logic,info.name)
			end
			self.CurInAreaInfoID = nil 
		end
		return 
	end

	--如果没有激活任何一个响应区间，则反复循环，直到激活
	for i,v in ipairs(self.RespondAreaTable) do
		local isIn = cc.rectContainsPoint(v.rec,pos)
		if isIn==true then
			if v.enterFunc~=nil then
				v.enterFunc(v.logic,v.name)
			end
			self.CurInAreaInfoID = i
			return 
		end
	end

end


---结束
function controller:End()

	--如果已经在某个响应区域内，执行end回调
	if self.CurInAreaInfoID~=nil then
		local info = self.RespondAreaTable[self.CurInAreaInfoID]
		if self.RespondAreaTable[self.CurInAreaInfoID].endFunc~=nil then
			self.RespondAreaTable[self.CurInAreaInfoID].endFunc(info.logic,info.name)
		end
	end

	local common = self.common_respond
	if common ~= nil and self.DragInfo ~= nil then
		common.endFunc(common.logic,self.DragInfo)
	end

	self.DragNode:setVisible(false)
	self.IsStarted = false
	self.DragInfo = nil
	self.CurInAreaInfoID = nil
end



return controller