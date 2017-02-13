--[[
Author : ZangXu @Bojoy 2014
FileName: 
Description: 
]]

---BJMDebug
-- @module bjm.util

local util = bjm.util

--[[------------------------------------------------------------------------------
@param value [mixed]要输出的值
@param desciption [string] 输出内容前的文字描述
@param nesting [integer] 输出时的嵌套层级，默认为 3
@showDumpPosition[bool] 是否显示从dump出现的文件名和行数
]]
util.Dump = function (value, desciption, nesting , showDumpPosition)
    if type(nesting) ~= "number" then nesting = 3 end
    if showDumpPosition == nil then showDumpPosition = true end

    local lookupTable = {}
    local result = {}

    local function _v(v)
        if type(v) == "string" then
            v = "\"" .. v .. "\""
        end
        return tostring(v)
    end

    if showDumpPosition == true then
        local traceback = string.split(debug.traceback("", 2), "\n")
        print("dump from: " .. string.trim(traceback[3]))
    end


    local function _dump(value, desciption, indent, nest, keylen)
        desciption = desciption or "<var>"
        spc = ""
        if type(keylen) == "number" then
            spc = string.rep(" ", keylen - string.len(_v(desciption)))
        end
        if type(value) ~= "table" then
            result[#result +1 ] = string.format("%s%s%s = %s", indent, _v(desciption), spc, _v(value))
        elseif lookupTable[value] then
            result[#result +1 ] = string.format("%s%s%s = *REF*", indent, desciption, spc)
        else
            lookupTable[value] = true
            if nest > nesting then
                result[#result +1 ] = string.format("%s%s = *MAX NESTING*", indent, desciption)
            else
                result[#result +1 ] = string.format("%s%s = {", indent, _v(desciption))
                local indent2 = indent.."    "
                local keys = {}
                local keylen = 0
                local values = {}
                for k, v in pairs(value) do
                    keys[#keys + 1] = k
                    local vk = _v(k)
                    local vkl = string.len(vk)
                    if vkl > keylen then keylen = vkl end
                    values[k] = v
                end
                table.sort(keys, function(a, b)
                    if type(a) == "number" and type(b) == "number" then
                        return a < b
                    else
                        return tostring(a) < tostring(b)
                    end
                end)
                for i, k in ipairs(keys) do
                    _dump(values[k], k, indent2, nest + 1, keylen)
                end
                result[#result +1] = string.format("%s}", indent)
            end
        end
    end
    _dump(value, desciption, "- ", 1)

    for i, line in ipairs(result) do
        print(line)
    end
end

--[[------------------------------------------------------------------------------
add a debug breakpoint
]]
util.Breakpoint = function (code)
    code = code or "meet lua breakpoint"
    BJMLuaUtil:Assert(false, code)
end

--[[------------------------------------------------------------------------------
c++ assert
evaluation: bool value to be asserted
msg: msg on box
]]
util.Assert = function(evaluation, msg)
    BJMLuaUtil:Assert(evaluation, msg)
end

--[[------------------------------------------------------------------------------
short codes
]]
bp      = util.Breakpoint
dump    = util.Dump
assert  = util.Assert
