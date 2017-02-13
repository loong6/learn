--[[
Author : ZangXu @Bojoy 2015
FileName: BJMHttpLogicEx.lua
Description: 
]]

local net = bjm.net
net.HttpLogic = bjm.reg.GetModule("BJMHttpLogicEx")

------------------------------------- functions imposed -------------------------------------
--[[------------------------------------------------------------------------------
-**
task state
*]]
local task_state = 
{
	running = "running",
	to_pause = "to_pause",
	to_cancel = "to_cancel",
	to_restart = "to_restart",
	paused = "paused",
	finish = "finish",
	error = "error",
	none = "none"
}

--[[------------------------------------------------------------------------------
-**
start downloading a file
if from_scratch is not assigned and relative temp file exists, we continue last downloading
params:
conn: connection_name (just a name to identify a http connection)
remote_url: url of file you want to download
local_uri: location where to save the file downloaded
http_header: http_header param in a http protocol
from_scratch: if true, we start download file without using any cached data
*]]
function net.HttpLogic:StartDownload(conn, remote_url, local_uri, http_header)
	if (self:ThreadsAvailable() == false) then
		cclog("no idle threads")
		return
	end

	local task = self.tasks[conn]
	if (task ~= nil) then
		cclog("StartDownload: current state is: " .. task.state)

		if (task.state == task_state.to_pause or
			task.state == task_state.to_cancel) then
			-- intermediate state, do nothing
			cclog("try to start download when state is to_pause or to_cancel")
			return
		end

		if (task.state == task_state.running or
			task.state == task_state.finish) then
			cclog("try to start download when state is running or finish, error?")
			return
		end
	end	

	http_header = http_header or ""

	local task = self:NewTaskInfo(
		conn,
		remote_url,
		local_uri,
		http_header
		)
	task.state = task_state.running

	self:StartDownloading(
		conn,
		remote_url,
		local_uri,
		http_header,
		false)
end

--[[------------------------------------------------------------------------------
-**
stop downloading and clean up cache
*]]
function net.HttpLogic:CancelDownload(conn)
	local task = self.tasks[conn]
	if (task == nil) then
		cclog("try to cancel a task which is not exist! error?")
		return
	end	

	cclog("CancelDownload: current state is: " .. task.state)

	if (task.state == task_state.to_cancel) then
		-- do real cancel in c's callback
		return
	end

	if (task.state == task_state.to_pause or 
		task.state == task_state.to_restart) then
		-- stop is not done in c, we change state here
		task.state = task_state.to_cancel
		return
	end

	if (task.state == task_state.finish or
		task.state == task_state.paused or
		task.state == task_state.error) then
		self:RemoveTask(conn)
		return
	end

	task.state = task_state.to_cancel
	self:StopDownloading(conn, false)
end

--[[------------------------------------------------------------------------------
-**
pause downloading, cached file won't be deleted
*]]
function net.HttpLogic:PauseDownload(conn)
	local task = self.tasks[conn]
	if (task == nil) then
		cclog("try to pause a task which is not exist! error?")
		return
	end	

	cclog("PauseDownload: current state is: " .. task.state)

	if (task.state == task_state.to_pause) then
		return
	end

	if (task.state == task_state.to_cancel or
		task.state == task_state.to_restart) then
		-- stop is not done in c, we change state here
		task.state = task_state.to_pause
		return
	end

	if (task.state == task_state.paused) then
		cclog("try to pause a task which is already paused")
		return
	end

	if (task.state == task_state.finish or
		task.state == task_state.error) then
		cclog("invalid task state in PauseDownload: " .. task.state)
		return
	end

	task.state = task_state.to_pause
	self:StopDownloading(conn, false)
end

--[[------------------------------------------------------------------------------
-**
resume downloading
*]]
function net.HttpLogic:ResumeDownload(conn)
	if (self:ThreadsAvailable() == false) then
		cclog("no idle threads")
		return
	end

	local task = self.tasks[conn]
	if (task == nil) then
		cclog("try to resume a task which is not exist! error?")
		return
	end	

	cclog("ResumeDownload: current state is: " .. task.state)

	if (task.state == task_state.to_pause or
		task.state == task_state.to_cancel or
		task.state == task_state.to_restart) then
		cclog("task is in to_pause state, ignore resume request")
		return
	end

	if (task.state == task_state.running or 
		task.state == task_state.finish) then
		cclog("invalid task state in ResumeDownload: " .. task.state)
		return
	end

	task.state = task_state.running
	self:StartDownloading(
		conn,
		task.remote_url,
		task.local_uri,
		task.http_header,
		false)	
end

--[[------------------------------------------------------------------------------
-**
restart downloading
*]]
function net.HttpLogic:RestartDownload(conn)
	local task = self.tasks[conn]
	if (task == nil) then
		cclog("try to restart a task which is not exist! error?")
		return
	end	

	cclog("RestartDownload: current state is: " .. task.state)

	if (task.state == task_state.to_restart) then
		return
	end

	if (task.state == task_state.to_pause or
		task.state == task_state.to_cancel) then
		-- stop is not done in c, we change state here
		task.state = task_state.to_restart
		return
	end

	if (task.state == task_state.paused or
		task.state == task_state.finish or
		task.state == task_state.error) then
		self.tasks[conn].state = task_state.running
		if (self:ThreadsAvailable() == false) then
			cclog("no idle threads")
			return
		end
		self:StartDownloading(
			conn, 
			self.tasks[conn].remote_url, 
			self.tasks[conn].local_uri, 
			self.tasks[conn].http_header, 
			true)
		return
	end

	task.state = task_state.to_restart
	self:StopDownloading(conn, false)	
end

--[[------------------------------------------------------------------------------
-**
remove task info
you can't remove task which is running
you can only remote task which is in state: pause, cancel, finish, error
if you need to do this, you should use CancelDownload
*]]
function net.HttpLogic:RemoveTask(conn)
	local task = self.tasks[conn]
	if (task == nil) then
		cclog("try to remote a task which is not exist! error?")
		return
	end

	if (task.state == task_state.running or 
		task.state == task_state.to_restart or
		task.state == task_state.to_pause) then
		cclog("can't remove a task when this task is running or in a intermediate state!")
		return
	end

	local localUri = task.local_uri
	local localTmpUri = localUri .. ".tmp"

	if (bjm.util.io.FileExistsFileSystem(localTmpUri) == true) then
		bjm.util.io.DeleteFile(localTmpUri)
	end

	self.tasks[conn] = nil
end


--[[------------------------------------------------------------------------------
-**
get running threads count
*]]
function net.HttpLogic:GetRunningThreadsCount()
	return BJMHttpUtil:GetRunningThreadsCount()
end

--[[------------------------------------------------------------------------------
-**
get max threads count
*]]
function net.HttpLogic:GetMaxThreadsCount()
	return BJMHttpUtil:GetMaxThreadsCount()
end

--[[------------------------------------------------------------------------------
-**
threads available
*]]
function net.HttpLogic:ThreadsAvailable()
	local max = self:GetMaxThreadsCount()
	local running = self:GetRunningThreadsCount()

	return (max > running)
end

--[[------------------------------------------------------------------------------
ctor
]]
function net.HttpLogic:ctor()
	cclog("HttpLogic ctor...")

	bjm.reg.RegLogicFunction(self, bjm.global.function_type.on_loaded, 							"", self.OnLoaded)
	bjm.reg.RegLogicFunction(self, bjm.global.function_type.on_destroy, 						"", self.OnDestroy)

	bjm.reg.RegLogicFunction(self, bjm.global.function_type.http_download, 						"", self.OnDownload)
	bjm.reg.RegLogicFunction(self, bjm.global.function_type.http_download_finish, 				"", self.OnDownloadFinish)
	bjm.reg.RegLogicFunction(self, bjm.global.function_type.http_download_error, 				"", self.OnDownloadError)
	bjm.reg.RegLogicFunction(self, bjm.global.function_type.http_download_stop, 				"", self.OnDownloadStop)

	self.tasks = {}
end

--[[------------------------------------------------------------------------------
-**
new task info
*]]
function net.HttpLogic:NewTaskInfo(conn, remote_url, local_uri, http_header)
	self.tasks[conn] = {
		conn = conn,
		remote_url = remote_url,
		local_uri = local_uri,
		http_header = http_header,
		kb_downloaded = 0,
		kb_total = 0,
		kb_speed = 0,
		state = task_state.none
	}
	return self.tasks[conn]
end

------------------------------------- all callbacks from c -------------------------------------
--[[------------------------------------------------------------------------------
OnLoaded
]]
function net.HttpLogic:OnLoaded()
	cclog("http logic on loaded...........")
end

--[[------------------------------------------------------------------------------
OnDestroy
]]
function net.HttpLogic:OnDestroy()
	cclog("http logic on destroy...........")

	for k,task in pairs(self.tasks) do
		if (task.state == task_state.running) then
			task.state = task_state.to_pause
			-- by zx self is invalid here, i don't know why..
			BJMHttpUtil:StopDownloadFileBreakpointEx(task.conn, false)
		end
	end
end

--[[------------------------------------------------------------------------------
]]
function net.HttpLogic:OnDownload(conn, kb_downloaded, kb_total, kb_speed)
	--cclog(string.format("OnDownload conn:%s, kb_downloaded:%.2f, kb_total:%.2f, kb_speed:%.2f", conn, kb_downloaded, kb_total, kb_speed))

	local task = self.tasks[conn]
	if (task == nil) then
		cclog("unkown error: task is nil when OnDownload")
		return
	end

	if (task.state ~= task_state.running and 
		task.state ~= task_state.to_pause and
		task.state ~= task_state.to_cancel and
		task.state ~= task_state.to_restart) then
		cclog("wrong state in net.HttpLogic:OnDownload, state should be running, to_pause, to_cancel or to_restart, current is " .. 
			self.tasks[conn].state)
		return
	end

	task.kb_downloaded = kb_downloaded
	task.kb_total = kb_total
	task.kb_speed = kb_speed
end

--[[------------------------------------------------------------------------------
]]
function net.HttpLogic:OnDownloadFinish(conn, kb_total)
	cclog(string.format("OnDownloadFinish conn:%s, kb_total:%.2f", conn, kb_total))

	local task = self.tasks[conn]
	if (task == nil) then
		cclog("unkown error: task is nil when OnDownloadFinish")
		return
	end

	task.state = task_state.finish
end

--[[------------------------------------------------------------------------------
]]
function net.HttpLogic:OnDownloadError(conn, error)
	cclog(string.format("OnDownloadError conn:%s, error:%d", conn, error))

	local task = self.tasks[conn]
	if (task == nil) then
		cclog("unkown error: task is nil when OnDownloadError")
		return
	end

	task.state = task_state.error
end

--[[------------------------------------------------------------------------------
]]
function net.HttpLogic:OnDownloadStop(conn, kb_downloaded, kb_total)
	cclog(string.format("OnDownloadStop conn:%s, kb_downloaded:%.2f, kb_total:%.2f", 
		conn, kb_downloaded, kb_total))

	local task = self.tasks[conn]
	if (task == nil) then
		cclog("unkown error: task is nil when OnDownloadStop")
		return
	end

	-- state can only be: to_cancel,to_pause,to_restart

	cclog("cur state: " .. task.state)

	-- restart
	if (task.state == task_state.to_restart) then
		-- restart this local_uri
		if (self:ThreadsAvailable() == false) then
			cclog("no idle threads")
			return
		end
		self.tasks[conn].state = task_state.running
		self:StartDownloading(
			conn, 
			self.tasks[conn].remote_url, 
			self.tasks[conn].local_uri, 
			self.tasks[conn].http_header, 
			true)
		return
	end

	-- cancel
	if (task.state == task_state.to_cancel) then
		self:RemoveTask(conn)
		return
	end

	-- to_pause
	if (task.state == task_state.to_pause) then
		task.state = task_state.paused
		return
	end
end