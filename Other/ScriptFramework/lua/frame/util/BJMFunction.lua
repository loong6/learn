--[[
Author : ZangXu @Bojoy 2014
FileName: BJMFunction.lua
Description: 
]]

---BJMFunction
-- @module bjm.util

local util = bjm.util

--[[------------------------------------------------------------------------------
cast with type checking
]]
function util.cast(obj, to_type)
    if obj == nil then return nil end

    if obj.GetType then
        local t = obj:GetType()
        return tolua.cast(obj, t)
    else
        return tolua.cast(obj, to_type)
    end
end

--[[------------------------------------------------------------------------------
cclog implementation in lua
]]
function util.log (...)
    local content = string.format(...)
    print(content)
end

--[[------------------------------------------------------------------------------
-**
log when is release built
*]]
function releaselog(...)
    local content = string.format(...)
    BJMLuaUtil:LogRelease(content)
end

--[[------------------------------------------------------------------------------
cclog
]]
function cclog(...)
    bjm.util.log(...)
end

--[[------------------------------------------------------------------------------
convert a cstring to BJMString
]]
function util.toBJMString(cstr)
	return BJMString:FromCStr(cstr)
end

--[[------------------------------------------------------------------------------
convert a BJMString to cstring
]]
function util.toCString(bjmStr)
	return bjmStr.AsCharPtr()
end

--[[------------------------------------------------------------------------------
test lua error
]]
function testLuaError()
    local a = nil + 1
end

--[[------------------------------------------------------------------------------
test lua error
]]
function testSelfReport()
    local msg = "This is self report."
    if (buglyReportLuaException ~= nil) then
        buglyReportLuaException("51", msg)
    end
    BJMLuaUtil:DebugMessageBox("lua assert", msg)
end

--[[------------------------------------------------------------------------------
-**
hash code
*]]
function util.HashCode(str)
    return BJMLuaUtil:HashCode(str)
end

--[[------------------------------------------------------------------------------
hex to rgb
]]
function util.HexToRGB(hex)  
    local red = string.sub(hex, 1, 2)  
    local green = string.sub(hex, 3, 4)  
    local blue = string.sub(hex, 5, 6)  
     
    red = tonumber(red, 16) / 255  
    green = tonumber(green, 16) / 255  
    blue = tonumber(blue, 16) / 255  
    return cc.c3b(red, green, blue)  
end 

--[[------------------------------------------------------------------------------
rgb to hex
]]
function util.RGBToHex(rgb)  
    local r = rgb.r
    local g = rgb.g
    local b = rgb.b
    return "#"..string.format("%02X",r)..string.format("%02X",g)..string.format("%02X",b)
end

--[[------------------------------------------------------------------------------
-**
restart
*]]
function util.Restart()
    if(bjm.util.config.GetUseSDK() == true) then
        bjm.sdk.account.SwitchAccount()
        BJMProxyUtil:DestroyProxy()
    end
    releaselog("===========>util.Restart")
    BJMLuaUtil:Restart()
end

--[[------------------------------------------------------------------------------
-**
get adapt type
*]]
function util.GetAdaptType()
    local curAdaptType = BJMSDKCacheServer:Instance():GetValue(bjm.global.sdk.strings.adapttype)

    if (curAdaptType == "") then
        curAdaptType = BJMLuaUtil:GetAdaptType()
    end

    return curAdaptType
end

--[[------------------------------------------------------------------------------
-**
toogle adapt type
*]]
function util.ToogleAdaptType()  
    local curAdaptType = util.GetAdaptType()

    local to = ""
    if (curAdaptType == bjm.global.adapt_type.showall) then
        to = bjm.global.adapt_type.exactfit
    elseif (curAdaptType == bjm.global.adapt_type.exactfit) then
        to = bjm.global.adapt_type.showall
    end

    if (to == "") then
        return
    end

    BJMLuaUtil:ResetAdaptType(to)

    BJMSDKCacheServer:Instance():SetValue(bjm.global.sdk.strings.adapttype, to)
end


--[[------------------------------------------------------------------------------
-**
discard unused resource
*]]
function util.DiscardUnusedResource(type)
    if (type == nil) then
        type = bjm.global.memory.all
    end

    BJMLuaUtil:DiscardUnusedResource(type)
end

--[[------------------------------------------------------------------------------
-**
unload unused resource
*]]
function util.UnLoadUnusedResource(type)
    if (type == nil) then
        type = bjm.global.memory.all
    end

    BJMLuaUtil:UnLoadUnusedResource(type)
end


--[[------------------------------------------------------------------------------
字符串的指定替换
~~~ lua
[WARNING] 字符串里面的{n}是从{0}开始的 
s = "{0}对{1}进行了{2},{0}很开心 ,{1}很受伤"
s = string.bjm_format(s,"Jack","Mike","kiss")
@param input [string]输入字符串
@return s
]]
function string.bjm_format(input,...)
    local t = {...}
    local len = #t
    local param_t
    local param_len 
    if len == 1 and type(t[1]) == "table" then
        param_t = t[1]
        param_len = #param_t
    else
        param_t = t
        param_len = len
    end
    local function ReplaceFunc(s)
        local i = tonumber(string.sub(s,2,-2)) + 1
        if i > param_len then
            return s
        else
            return param_t[i]
        end
    end     
    input = string.gsub(input,"{%d+}",ReplaceFunc)
    return input
end

--[[------------------------------------------------------------------------------
用指定字符或字符串分割输入字符串，返回包含分割结果的数组

~~~ lua

local input = "Hello,World"
local res = string.split(input, ",")
-- res = {"Hello", "World"}

local input = "Hello-+-World-+-Quick"
local res = string.split(input, "-+-")
-- res = {"Hello", "World", "Quick"}

~~~

@param input [string]输入字符串
@param delimiter [string]分割标记字符或字符串

@return array 包含分割结果的数组
]]
function string.split(input, delimiter)
    if input == nil or input=="" then return {} end
    input = tostring(input)
    delimiter = tostring(delimiter)
    if (delimiter=='') then return false end
    local pos,arr = 0, {}
    -- for each divider found
    for st,sp in function() return string.find(input, delimiter, pos, true) end do
        table.insert(arr, string.sub(input, pos, st - 1))
        pos = sp + 1
    end
    table.insert(arr, string.sub(input, pos))
    return arr
end

--[[--

去除输入字符串头部的空白字符，返回结果

~~~ lua

local input = "  ABC"
print(string.ltrim(input))
-- 输出 ABC，输入字符串前面的两个空格被去掉了

~~~

空白字符包括：

-   空格
-   制表符 \t
-   换行符 \n
-   回到行首符 \r

@param input [string]输入字符串

@return [string]结果

@see string.rtrim, string.trim

]]
function string.ltrim(input)
    return string.gsub(input, "^[ \t\n\r]+", "")
end

--[[--

去除输入字符串尾部的空白字符，返回结果

~~~ lua

local input = "ABC  "
print(string.ltrim(input))
-- 输出 ABC，输入字符串最后的两个空格被去掉了

~~~

@param input [string]输入字符串

@return [string]结果

@see string.ltrim, string.trim

]]
function string.rtrim(input)
    return string.gsub(input, "[ \t\n\r]+$", "")
end

--[[--

去掉字符串首尾的空白字符，返回结果

@param input [string]输入字符串

@return [string]结果

@see string.ltrim, string.rtrim

]]
function string.trim(input)
    input = string.gsub(input, "^[ \t\n\r]+", "")
    return string.gsub(input, "[ \t\n\r]+$", "")
end

--[[--
url decode, see http://lua-users.org/wiki/StringRecipes
]]
function string.url_decode(str)
  str = string.gsub (str, "+", " ")
  str = string.gsub (str, "%%(%x%x)",
      function(h) return string.char(tonumber(h,16)) end)
  str = string.gsub (str, "\r\n", "\n")
  return str
end

--[[--
url decode, see http://lua-users.org/wiki/StringRecipes
]]
function string.url_encode(str)
  if (str) then
    str = string.gsub (str, "\n", "\r\n")
    str = string.gsub (str, "([^%w %-%_%.%~])",
        function (c) return string.format ("%%%02X", string.byte(c)) end)
    str = string.gsub (str, " ", "+")
  end
  return str	
end


local function utf8Iter(s, i)
    if i >= #s then return end
    local b, nbytes = s:byte(i+1,i+1), 1

    -- determine width of the codepoint by counting the number of set bits in the first byte
    -- warning: there is no validation of the following bytes!
    if     b >= 0xc0 and b <= 0xdf then nbytes = 2 -- 1100 0000 to 1101 1111
    elseif b >= 0xe0 and b <= 0xef then nbytes = 3 -- 1110 0000 to 1110 1111
    elseif b >= 0xf0 and b <= 0xf7 then nbytes = 4 -- 1111 0000 to 1111 0111
    elseif b >= 0xf8 and b <= 0xfb then nbytes = 5 -- 1111 1000 to 1111 1011
    elseif b >= 0xfc and b <= 0xfd then nbytes = 6 -- 1111 1100 to 1111 1101
    elseif b <  0x00 or  b >  0x7f then error(("Invalid codepoint: 0x%02x"):format(b))
    end
    return i+nbytes, s:sub(i+1,i+nbytes), nbytes
end

local function utf8Chars(s)
    return utf8Iter,s,0
end

--[[--遍历utf8字符串字符
--用法:  
    for _, c in bjm.util.Utf8Chars(str) do
        --do someting with c
    end
]]
util.Utf8Chars = utf8Chars

--获得utf8编码的string字符串的个数
function string.utf8Len(s)
    -- assumes sane utf8 string: count the number of bytes that is *not* 10xxxxxx
    local _, c = s:gsub('[^\128-\191]', '')
    return c
end
--截取utf8编码的string
function string.utf8Sub(s, i, j)
    local l = string.utf8Len(s)
    j = j or l
    if i < 0 then i = l + i + 1 end
    if j < 0 then j = l + j + 1 end
    if j < i then return '' end

    local k, t = 1, {}
    for _, c in utf8Chars(s) do
        if k >= i then t[#t+1] = c end
        if k >= j then break end
        k = k + 1
    end
    return table.concat(t)
end

--分割utf8编码的string
function string.utf8Split(s, i)
    local l = string.utf8Len(s)
    if i < 0 then i = l + i + 1 end

    local k, pos = 1, 0
    for byte in utf8Chars(s) do
        if k > i then break end
        pos, k = byte, k + 1
    end
    return s:sub(1, pos), s:sub(pos+1, -1)
end


function string.utf8Reverse(s)
    local t = {}
    for _, c in utf8Chars(s) do
        table.insert(t, 1, c)
    end
    return table.concat(t)
end

--- 获取utf8编码字符串正确长度的方法
-- @param str
-- @return number
function string.utf8Len(str)
    local len = #str;
    local left= len;
    local cnt = 0;
    local arr={0,0xc0,0xe0,0xf0,0xf8,0xfc};
    while left ~= 0 do
        local tmp=string.byte(str,-left);
        local i=#arr;
        while arr[i] do
            if tmp>=arr[i] then left=left-i;break;end
            i=i-1;
        end
        cnt=cnt+1;
    end
    return cnt;
end

--[[------------------------------------------------------------------------------
-**
escape
*]]
function string.escapeUrl(s)
    return BJMLuaUtil:Escape(s)
end



--计算2点之间的直线距离
function math.TowPointDistance(po1,po2)
    local dis = math.sqrt(math.pow((po1.x-po2.x),2)+math.pow((po1.y-po2.y),2))
    return dis
end





--[[------------------------------------------------------------------------------
check is a module loaded
]]
function util.IsModuleLoaded(module)
    if (package.loaded[module] ~= nil) then
        do return true end
    end
    do return false end
end

--[[------------------------------------------------------------------------------
unload a module
]]
function util.UnloadModule(module)
    if (package.loaded[module] ~= nil) then
        package.loaded[module] = nil
    end
end

--[[------------------------------------------------------------------------------
make uri
location can be "apphome" "cachehome" ...
it's defined in BJMGlobalConstant.lua => global.uri
]]
function util.MakeUri(location, specify)
    do return location .. ":" .. specify end
end

--[[------------------------------------------------------------------------------
short code for util.MakeUri
]]
make_uri = util.MakeUri

--[[------------------------------------------------------------------------------
push notification
if target_logic is nil, notification will be sent to all logics
data can be nil
]]
function util.PushNotification(notification_name, data, target_logic)
    if data==nil then data = {} end
    BJMLuaUtil:PushNotification(target_logic, notification_name, data)
end

--[[------------------------------------------------------------------------------
push notification at once
if target_logic is nil, notification will be sent to all logics
data can be nil
]]
function util.PushNotificationAtOnce(notification_name, data, target_logic)
    BJMLuaUtil:PushNotificationAtOnce(target_logic, notification_name, data)
end

--[[------------------------------------------------------------------------------
notification use lock?
WARNING: don't call this function unless you know what it does!!!
]]
function util.SetUseLockWhenPush(use_lock)
    BJMLuaUtil:SetUseLockWhenPush(use_lock)
end


--[[------------------------------------------------------------------------------
get game string
]]
function util.GetGameString(string_name)
    do return BJMLuaUtil:GetGameString(string_name) end
end

--[[------------------------------------------------------------------------------
get sdk string
]]
function util.GetSDKString(string_name)
    do return BJMLuaUtil:GetSDKString(string_name) end
end

--[[------------------------------------------------------------------------------
uri to path
]]
function util.UriToPath(uri)
    do return BJMLuaUtil:UriToPath(uri) end
end

--[[------------------------------------------------------------------------------
path to uri
]]
function util.PathToUri(path, pre)
    do return BJMLuaUtil:PathToUri(path, pre) end
end

--[[------------------------------------------------------------------------------
make md5
]]
function util.MakeMD5(content)
    return BJMLuaUtil:MakeMD5(content)
end

--[[------------------------------------------------------------------------------
make file md5
]]
function util.MakeFileMD5(uri)
    return BJMLuaUtil:MakeFileMD5(uri)
end

local targetPlatform = cc.Application:getInstance():getTargetPlatform() 

--[[------------------------------------------------------------------------------
is win32
]]
function util.GetPlatform()
    return targetPlatform
end

--[[------------------------------------------------------------------------------
is win32
]]
function util.IsWin32()
    if (targetPlatform == cc.PLATFORM_OS_WINDOWS) then
        return true
    end

    return false
end

--[[------------------------------------------------------------------------------
is android
]]
function util.IsAndroid()
    if (targetPlatform == cc.PLATFORM_OS_ANDROID) then
        return true
    end

    return false
end

--[[------------------------------------------------------------------------------
is ios
]]
function util.IsIos()
    if (targetPlatform == cc.PLATFORM_OS_IPHONE or targetPlatform == cc.PLATFORM_OS_IPAD) then
        return true
    end

    return false
end

--[[------------------------------------------------------------------------------
is ipad
]]
function util.IsIPad()
    if (targetPlatform == cc.PLATFORM_OS_IPAD) then
        return true
    end

    return false
end

--[[------------------------------------------------------------------------------
is iphone
]]
function util.IsIphone()
    if (targetPlatform == cc.PLATFORM_OS_IPHONE) then
        return true
    end

    return false
end

--[[------------------------------------------------------------------------------
-**
date to timestamp
*]]
function util.DateToTimestamp(date, pattern)
    return BJMLuaUtil:DateToTimeStamp(date, pattern)
end

--[[------------------------------------------------------------------------------
-**
setup basic configs
*]]
function util.SetupBasicConfig()
    return BJMLuaUtil:SetupBasicConfig()
end

function util.SetBasicConfigValue(key,value)
    BJMLuaUtil:SetBasicConfigValue(key,value)
end

--[[------------------------------------------------------------------------------
-**
*]]
function util.RegisterFrameUpdateFunc(func)
    BJMLuaUtil:RegisterFrameUpdateFunc(func)
end

--[[------------------------------------------------------------------------------
打印调试信息

### 用法示例

~~~ lua

printLog("WARN", "Network connection lost at %d", os.time())

~~~

@param tag [string] 调试信息的 tag
@param fmt [string] 调试信息格式
@param ... [mixed ...] 更多参数
]]
function printLog(tag, fmt, ...)
    local t = {
        "[",
        string.upper(tostring(tag)),
        "] ",
        string.format(tostring(fmt), ...)
    }
    print(table.concat(t))
end

--[[------------------------------------------------------------------------------
输出 tag 为 ERR 的调试信息

@param fmt [string] 调试信息格式
@param ... [mixed ...] 更多参数

]]
function printError(fmt, ...)
    printLog("ERR", fmt, ...)
    print(debug.traceback("", 2))
end

--[[------------------------------------------------------------------------------
输出 tag 为 INFO 的调试信息

@param fmt [string] 调试信息格式
@param ... [mixed ...] 更多参数
]]
function printInfo(fmt, ...)
    printLog("INFO", fmt, ...)
end

--[[------------------------------------------------------------------------------
-**
*]]
function AppendLog(content)
    BJMLuaUtil:AppendLog(content)
end

--[[------------------------------------------------------------------------------
-**
*]]
function SendError(errCode)
    errCode = errCode or 2
    if (bjm.util.IsWin32() == false) then
        BJMLuaUtil:SendLuaError(errCode)
    end    
end

--[[------------------------------------------------------------------------------
将timestamp转换为与本机时区无关的日期
用法：timestamp 为服务器传来的unix时间戳
      timezone  为服务器的时区, 为空默认为东八区
]]
function util.date(timestamp, timezone)
    if not timezone then
        timezone = 8
    end

    --注意os.time小于0时会返回nil, 这里获取1970.1.2然后减去1天
    local local_diff = os.difftime(timestamp, os.time(os.date("!*t", timestamp)))

    local local_ts = timestamp + timezone * 3600 - local_diff

    return os.date("*t", local_ts)
end

--[[------------------------------------------------------------------------------
将tab转换为与本机时区无关的时间戳
用法：tab          可以为一个table包含年月日时分秒，也可以为空
      timezone     偏移时区, 为空默认为东八区
]]
function util.time(tab, timezone)
    if not timezone then
        timezone = 8
    end

    --注意os.time小于0时会返回nil, 这里获取1970.1.2然后减去1天
   

    local timestamp = os.time(tab)

     local local_diff = os.difftime(timestamp, os.time(os.date("!*t", timestamp)))

    return timestamp - timezone * 3600 + local_diff
end

