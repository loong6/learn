local audio = bjm.audio

audio.voice = {}

local voice = audio.voice

voice.StartVoicePlaying = function (uri, bInCall)
	if bInCall == nil then bInCall = false end
	BJMVoiceUtil:StartVoicePlaying(uri, bInCall)
end

voice.StopVoicePlaying = function ()
	BJMVoiceUtil:StopVoicePlaying()
end

voice.StartVoiceRecord = function (uri)
	return BJMVoiceUtil:StartVoiceRecord(uri)
end

voice.StopVoiceRecord = function ()
	BJMVoiceUtil:StopVoiceRecord()
end

voice.GetVolumn = function()
	return BJMVoiceUtil:GetVolumn()
end

voice.GetMicVolumn = function()
	return BJMVoiceUtil:GetMicVolumn()
end

voice.GetDuration = function(uri)
	return BJMVoiceUtil:GetDuration(uri)
end