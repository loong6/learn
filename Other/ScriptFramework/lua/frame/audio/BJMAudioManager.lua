---BJMAudioManager
-- @module bjm.audio


local audio = bjm.audio


---当前正在播放的音乐路径
audio.cur_music_path = ""
---当前音乐的音量
audio.cur_music_volume = 1
---当前音乐播放是否循环
audio.cur_music_b_loop = false
--是否需要控制音量大小
audio.IsControlVol = false
--控制背景音乐音量大小
audio.n_ControlMusic_Vol = 1
---控制音效的音量
audio.n_ControlEffect_Vol = 1
---播放背景音乐
audio.PlayMusic = function ( path , b_loop , b_fade)
	if b_loop==nil then b_loop=true end
	audio.cur_music_b_loop = b_loop
	if path == audio.cur_music_path then return end

	if b_fade == nil then b_fade = true end

	

	if b_fade ~= true then 
		audio.engine.PlayMusic(path, b_loop)
		audio.cur_music_path = path
		if audio.IsControlVol then
			audio.engine.SetMusicVolume(audio.cur_music_volume)
		end
	else
		audio.FadeInOutSchedulerInit( path )
	end
	
end

---暂停播放音乐
audio.StopMusic = function()
	if audio.cur_music_path == "" then return end
	audio.cur_music_path  = ""
	audio.FadeInOutSchedulerDispose()
	audio.engine.StopMusic()
end


--计时器标示
local fadeInOut_scheduleTag = nil
--是否正在消失
local is_disappear = true

local Volume_Change_Step = 0.03
--每0.1s执行的定时器函数
audio.FadeInOutSchedulerFunc = function ( dt )	
	if is_disappear == true then
		audio.cur_music_volume = audio.cur_music_volume - Volume_Change_Step
		if audio.cur_music_volume < 0 then 
			audio.cur_music_volume = 0 
			is_disappear = false
			audio.engine.PlayMusic(audio.cur_music_path, audio.cur_music_b_loop)
		end
	else
		audio.cur_music_volume = audio.cur_music_volume + Volume_Change_Step
		local vol = 1
		if audio.IsControlVol then 
			vol = audio.n_ControlMusic_Vol
		end
		if audio.cur_music_volume > vol then 
			audio.FadeInOutSchedulerDispose()
			audio.cur_music_volume = vol
		end	
	end
	audio.engine.SetMusicVolume(audio.cur_music_volume)
end

--音乐淡入/淡出 计时器
audio.FadeInOutSchedulerInit = function ( path )
	if audio.cur_music_path == ""  then
		is_disappear = false
		audio.cur_music_volume = 0
		audio.engine.PlayMusic(path, audio.cur_music_b_loop)
	else
		is_disappear = true

		if audio.IsControlVol then 
			audio.cur_music_volume = audio.n_ControlMusic_Vol
		else
			audio.cur_music_volume = 1
		end

	end

	audio.cur_music_path = path

	
	local scheduler = cc.Director:getInstance():getScheduler()
	if fadeInOut_scheduleTag ~= nil then
 	   scheduler:unscheduleScriptEntry(fadeInOut_scheduleTag)
	end
	fadeInOut_scheduleTag = scheduler:scheduleScriptFunc(audio.FadeInOutSchedulerFunc,0.01, false)
end

---dispose
audio.FadeInOutSchedulerDispose = function (  )
	local scheduler = cc.Director:getInstance():getScheduler()
	if fadeInOut_scheduleTag ~= nil then
 	   scheduler:unscheduleScriptEntry(fadeInOut_scheduleTag)
 	   fadeInOut_scheduleTag = nil 
	end
	audio.cur_music_volume = 1 
end




---静音初始化
audio.MuteInit = function ( b_music_on , b_sound_on )
	if b_music_on==nil then b_music_on=false end
	if b_sound_on==nil then b_sound_on=false end	
	audio.engine.SetMusicMute(b_music_on)
	audio.engine.SetEffectMute(b_sound_on)
end

--- 背景音乐静音开关/切换
audio.MuteMusic = function ( bool )
	audio.engine.SetMusicMute(bool)
end
--- 音效静音开关/切换
audio.MuteEffect = function ( bool )
	audio.engine.SetEffectMute(bool)
end


---音效文件路径 必须在游戏初始化的时候设置
audio.EffectFolderPath = nil

audio.EffPlayedAry = {}
---需要预先加载的音效
audio.PreEffAry = {}
---初始化预先加载音效
audio.InitPreEffAry = function ( ary )
	for i,v in ipairs(ary) do
		local path = audio.EffectFolderPath .. v
		local ID = audio.engine.PreloadEffect(path,false)
		audio.PreEffAry[v] = ID
	end
end


---播放音效
audio.PlayEffect = function ( name , b_loop )
	if audio.engine.IsEffectMute()==true then return end
	if audio.EffectFolderPath==nil then 
		cclog("please set effect Folder path ! ") 
		return
	end

	if b_loop == nil then b_loop = false end

	if audio.PreEffAry[name] ~=nil then
		audio.engine.PlayEffectByID(audio.PreEffAry[name])
		if audio.IsControlVol then
			audio.engine.SetEffectsVolume(audio.n_ControlEffect_Vol)
		end
		return
	end

	local path = audio.EffectFolderPath .. name

	local ID = audio.engine.PlayEffect(path,b_loop)
	if audio.EffPlayedAry["Effect_"..ID] == nil then
		audio.EffPlayedAry["Effect_"..ID] = ID
	end
	return ID
end

---播放音效
audio.PlayEffectHaveVolumn = function ( name , b_loop ,volumn)
	if audio.engine.IsEffectMute()==true then return end
	if audio.EffectFolderPath==nil then 
		cclog("please set effect Folder path ! ") 
		return
	end

	if b_loop == nil then b_loop = false end

	if audio.PreEffAry[name] ~=nil then
		audio.engine.PlayEffectHaveVolumnByID(audio.PreEffAry[name],b_loop,volumn)
		-- if audio.IsControlVol then
		-- 	audio.engine.SetEffectsVolume(audio.n_ControlEffect_Vol)
		-- end
		return
	end

	local path = audio.EffectFolderPath .. name

	local ID = audio.engine.PlayEffectHaveVolumn(path,b_loop,volumn)
	if audio.EffPlayedAry["Effect_"..ID] == nil then
		audio.EffPlayedAry["Effect_"..ID] = ID
	end
	return ID
end

---卸载所有音效资源
audio.UnloadAllEffects = function (  )
	for i,v in pairs(audio.EffPlayedAry) do
		audio.engine.StopEffect(v)
	end
	audio.EffPlayedAry = {}
end