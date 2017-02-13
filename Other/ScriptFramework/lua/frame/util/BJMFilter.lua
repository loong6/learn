--[[
Author : ZangXu @Bojoy 2014
FileName: BJMFilter.lua
Description: 
]]

---BJMFilter
-- @module bjm.util.filter

------------------------------------- BJMFilter -------------------------------------
bjm.util.filter = class("BJMFilter")
local Filter = bjm.util.filter

--[[------------------------------------------------------------------------------
-**
*]]
function Filter:ctor()

end

--[[------------------------------------------------------------------------------
-**
do filter
return if the request should be discard
*]]
function Filter:DoFilter(request)
	return false
end

------------------------------------- BJMFilterChain -------------------------------------
bjm.util.filterChain = class("BJMFilterChain")
local FilterChain = bjm.util.filterChain

--[[------------------------------------------------------------------------------
-**
*]]
function FilterChain:ctor()
	self.filters = {}
end

--[[------------------------------------------------------------------------------
-**
add new filter
*]]
function FilterChain:AddFilter(filter)
	table.insert(self.filters, filter)
end

--[[------------------------------------------------------------------------------
-**
do filter
return if the request should be discard
*]]
function FilterChain:DoFilter(request)
	local count = #self.filters
	for i = 1, count, 1 do
		local filter = self.filters[i]
		local needDiscard = filter:DoFilter(request)
		if (needDiscard) then
			do return true end
		end
	end

	return false
end