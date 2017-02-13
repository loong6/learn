--[[
Author : ZangXu @Bojoy 2014
FileName: BJMAudioEngine.lua
Description: 
]]

---BJMAudioEngine
-- @module bjm.audio.engine

local audio = bjm.audio
audio.engine = {}
local engine = audio.engine

--instance
local instance = nil

local function Instance()
    if (instance ~= nil) then do return instance end end
    return BJMAudioEngine:Instance()
end


--[[------------------------------------------------------------------------------
StopAllEffects
]]
function engine.StopAllEffects()
    Instance():StopAllEffects()
end

--[[------------------------------------------------------------------------------
GetMusicVolume
]]
function engine.GetMusicVolume()
    return Instance():GetBackgroundMusicVolume()
end

--[[------------------------------------------------------------------------------
IsMusicPlaying
]]
function engine.IsMusicPlaying()
    return Instance():IsBackgroundMusicPlaying()
end

--[[------------------------------------------------------------------------------
GetEffectsVolume
]]
function engine.GetEffectsVolume()
    return Instance():GetEffectsVolume()
end

--[[------------------------------------------------------------------------------
SetMusicVolume
]]
function engine.SetMusicVolume(volume)
    Instance():SetBackgroundMusicVolume(volume)
end

--[[------------------------------------------------------------------------------
StopEffect
]]
function engine.StopEffect(id)
    Instance():StopEffect(id)
end

--[[------------------------------------------------------------------------------
StopMusic
]]
function engine.StopMusic()
    Instance():StopBackgroundMusic()
end

--[[------------------------------------------------------------------------------
PlayMusic
]]
function engine.PlayMusic(filename, isLoop)
    local loopValue = false
    if nil ~= isLoop then
        loopValue = isLoop
    end
    Instance():PlayBackgroundMusic(filename, loopValue)
end

--[[------------------------------------------------------------------------------
PauseAllEffects
]]
function engine.PauseAllEffects()
    Instance():PauseAllEffects()
end

--[[------------------------------------------------------------------------------
PreloadMusic
]]
function engine.PreloadMusic(filename)
    Instance():PreloadBackgroundMusic(filename)
end

--[[------------------------------------------------------------------------------
ResumeMusic
]]
function engine.ResumeMusic()
    Instance():ResumeBackgroundMusic()
end

--[[------------------------------------------------------------------------------
SetMusicMute
]]
function engine.SetMusicMute(bool)
    Instance():SetMusicMute(bool)
end

--[[------------------------------------------------------------------------------
IsMusicMute
]]
function engine.IsMusicMute()
    return  Instance():IsMusicMute()
end


--[[------------------------------------------------------------------------------
PlayEffect
]]
function engine.PlayEffect(filename, isLoop)
    local loopValue = false
    if nil ~= isLoop then
        loopValue = isLoop
    end
    return Instance():PlayEffect(filename, loopValue, 1, 0)
end

--[[------------------------------------------------------------------------------
PlayEffectByID
]]
function engine.PlayEffectByID(id, isLoop)
    local loopValue = false
    if nil ~= isLoop then
        loopValue = isLoop
    end
    Instance():PlayEffectByID(id, loopValue, 1, 0)
end

--[[------------------------------------------------------------------------------
PlayEffectHaveVolumn
]]
function engine.PlayEffectHaveVolumn(filename, isLoop,volumn)
    local loopValue = false
    if nil ~= isLoop then
        loopValue = isLoop
    end
    return Instance():PlayEffectHaveVolumn(filename, loopValue, 1, 0 ,volumn)
end

--[[------------------------------------------------------------------------------
PlayEffectHaveVolumnByID
]]
function engine.PlayEffectHaveVolumnByID(id, isLoop,volumn)
    local loopValue = false
    if nil ~= isLoop then
        loopValue = isLoop
    end
    Instance():PlayEffectHaveVolumnByID(id, loopValue, 1, 0 ,volumn)
end

--[[------------------------------------------------------------------------------
SetEffectsVolumeByID
]]
function engine.SetEffectsVolumeByID(ID,volumn)
    Instance():SetEffectsVolumeByID(ID,volumn)
end

--[[------------------------------------------------------------------------------
PreloadEffect
]]
function engine.PreloadEffect(filename)
    return Instance():PreloadEffect(filename)
end

--[[------------------------------------------------------------------------------
SetEffectsVolume
]]
function engine.SetEffectsVolume(volume)
    Instance():SetEffectsVolume(volume)
end

--[[------------------------------------------------------------------------------
PauseEffect
]]
function engine.PauseEffect(id)
    Instance():PauseEffect(id)
end

--[[------------------------------------------------------------------------------
ResumeAllEffects
]]
function engine.ResumeAllEffects()
    Instance():ResumeAllEffects()
end

--[[------------------------------------------------------------------------------
PauseMusic
]]
function engine.PauseMusic()
    Instance():PauseBackgroundMusic()
end

--[[------------------------------------------------------------------------------
ResumeEffect
]]
function engine.ResumeEffect(id)
    Instance():ResumeEffect(id)
end

--[[------------------------------------------------------------------------------
SetEffectMute
]]
function engine.SetEffectMute(bool)
    Instance():SetEffectMute(bool)
end

--[[------------------------------------------------------------------------------
IsEffectMute
]]
function engine.IsEffectMute()
    return  Instance():IsEffectMute()
end