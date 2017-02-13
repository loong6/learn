--[[
Author : ZangXu @Bojoy 2014
FileName: BJMHttpManager.lua
Description: 
]]

---BJMHttpManager
-- @module bjm.net.http
-- @alias net.http

local net = bjm.net

net.http = {}

--[[------------------------------------------------------------------------------
set use https
if open_https is true, open use https .if not, close use https
the default is true
]]
net.http.SetUseHttps = function (open_https)
	if open_https ~= nil then
		BJMLuaUtil:SetUseHttps(open_https)
	end
end

--[[------------------------------------------------------------------------------
query string sync
@return success, retData
]]
net.http.QueryStringSync = function(connName, url, postData, httpHeader)
	local success, retData = BJMHttpUtil:QueryStringSync(connName, url, postData, httpHeader, "")
	return success, retData
end

--[[------------------------------------------------------------------------------
query string async
no return
]]
net.http.QueryStringAsync = function(connName, url, postData, httpHeader)
	BJMHttpUtil:QueryStringAsync(connName, url, postData, httpHeader, "")
end

--[[------------------------------------------------------------------------------
query file sync
@return success
]]
net.http.QueryFileSync = function(connName, url, fileUri, postData, httpHeader)
	local success = BJMHttpUtil:QueryFileSync(connName, url, fileUri, postData, httpHeader, "")
	return success
end

--[[------------------------------------------------------------------------------
query file async
no return
]]
net.http.QueryFileAsync = function(connName, url, fileUri, postData, httpHeader)
	BJMHttpUtil:QueryFileAsync(connName, url, fileUri, postData, httpHeader, "")
end

--[[------------------------------------------------------------------------------
query file sync using breakpoint download
no return
]]
net.http.QueryFileSyncBreakpoint = function(connName, url, fileUri, httpHeader, fromScratch)
	BJMHttpUtil:QueryFileSyncBreakpoint(connName, url, fileUri, httpHeader, fromScratch)
end

--[[------------------------------------------------------------------------------
query file async using breakpoint download
]]
net.http.QueryFileAsyncBreakpoint = function(connName, url, fileUri, httpHeader, fromScratch)
	BJMHttpUtil:QueryFileAsyncBreakpoint(connName, url, fileUri, httpHeader, fromScratch)
end

--[[------------------------------------------------------------------------------
query file size
@return file size
]]
net.http.QueryFileSize = function(url, httpHeader)
	return BJMHttpUtil:QueryFileSize(url, httpHeader)
end

--[[------------------------------------------------------------------------------
-**
upload file sync
if fileUri is empty, use fileData and fileDataLen
@return success, retData
*]]
net.http.UploadFileSync = function(connName, url, formKey, fileUri, fileData, fileDataLen, contentType, httpHeader)
	return BJMHttpUtil:UploadFileSync(connName, url, formKey, fileUri, fileData, fileDataLen, contentType, httpHeader, "")
end

--[[------------------------------------------------------------------------------
-**
upload file async
if fileUri is empty, use fileData and fileDataLen
no return
*]]
net.http.UploadFileAsync = function(connName, url, formKey, fileUri, fileData, fileDataLen, contentType, httpHeader)
	BJMHttpUtil:UploadFileAsync(connName, url, formKey, fileUri, fileData, fileDataLen, contentType, httpHeader, "")
end

--[[------------------------------------------------------------------------------
-**
upload files sync
@return success, retData
*]]
net.http.UploadFilesSync = function(connName, url, param_names, param_values, file_names, file_uris, contentType, httpHeader)
	return BJMHttpUtil:UploadFilesSync(connName, url, param_names, param_values, file_names, file_uris, contentType, httpHeader)
end

--[[------------------------------------------------------------------------------
-**
upload files async
no return
*]]
net.http.UploadFilesAsync = function(connName, url, param_names, param_values, file_names, file_uris, contentType, httpHeader)
	BJMHttpUtil:UploadFilesAsync(connName, url, param_names, param_values, file_names, file_uris, contentType, httpHeader, "")
end

--[[------------------------------------------------------------------------------
-**
cancel query file
no return
*]]
net.http.CancelQueryFile = function(connName)
	BJMHttpUtil:CancelQueryFile(connName)
end

--[[------------------------------------------------------------------------------
-**
set QueryString TimeOut
*]]
net.http.SetQueryStringTimeOut = function(nTimeout)
	BJMHttpUtil:SetQueryStringTimeOut(nTimeout)
end

--[[------------------------------------------------------------------------------
-**
set QueryFile TimeOut
*]]
net.http.SetQueryFileTimeOut = function(nTimeout)
	BJMHttpUtil:SetQueryFileTimeOut(nTimeout)
end

------------------------------------- thread pool version -------------------------------------