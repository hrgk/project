local GameAudio = {}

function GameAudio.appendSexPath(file, sex)
    if SEX_MALE == sex then
        return string.format("sounds/male/%s", file)
    else
        return string.format("sounds/female/%s", file)
    end
end

function GameAudio.appendNGSexPath(file, sex)
    if SEX_MALE == sex then
        return string.format("sounds/niugui_male/%s", file)
    else
        return string.format("sounds/niugui_female/%s", file)
    end
end

function GameAudio.playMusic(file, isLoop)
    if not file then
        return
    end
    if audio.isMusicPlaying() then
        audio.stopMusic(true)
    end
    audio.playMusic(file, loop)

    if setData:getMusicState() == "2" or not gameConfig:get(CONFIG_MUSIC_ON) then
        return GameAudio.pauseMusic()
    end
end

function GameAudio.pauseMusic()
    return audio.pauseMusic()
end

function GameAudio.stopMusic()
    return audio.stopMusic()
end

function GameAudio.resumeMusic()
    return audio.resumeMusic()
end

function GameAudio.playSound(file)
    if tostring(setData:getSoundState()) == "2" then
        return
    end
    if not gameConfig:get(CONFIG_SOUND_ON) then
        return
    end
    return audio.playSound(file)
end

function GameAudio.setMusicVolume(volume)
    if audio.getMusicVolume() == volume then
        return
    end
    return audio.setMusicVolume(volume)
end

function GameAudio.stopSounds()
    return audio.pauseAllSounds()
end

function GameAudio.resumeSounds()
    return audio.resumeAllSounds()
end

function GameAudio.setSoundsVolume(volume)
    if audio.getSoundsVolume() == volume then
        return
    end
    return audio.setSoundsVolume(volume)
end

function GameAudio.vibrate()
    if gameConfig:get(CONFIG_VIBRATE_ON) then
        return gailun.native.vibrate()
    end
end

function GameAudio.setSoundFlag(flag)
    gameConfig:set(CONFIG_SOUND_ON, flag)
    if not flag then
        return audio.stopAllSounds()
    end
end

function GameAudio.setMusicFlag(flag)
    gameConfig:set(CONFIG_MUSIC_ON, flag)
    if not flag then
        return audio.pauseMusic()
    end
end

function GameAudio.setVibrateFlag(flag)
    gameConfig:set(CONFIG_VIBRATE_ON, flag)
end

local soundList = {"shaoyang_", "common_"}
local sexList = {"cd_female", "cd_male"}
function GameAudio.playHumanSound(sound, sex)
    -- local soundType = gameConfig:get(CONFIG_DEFAULT_HUMAN_SOUND)
    -- if not soundList[soundType] then
    --     printInfo("if not soundList[soundType] then, sound not exist")
    --     return
    -- end
    if 2 == sex then
        sex = 0
    end
    if not sexList[sex + 1] then
        printInfo("sex sound is not exist!")
        return
    end

    local soundPath = string.format("sounds/%s/%s", sexList[sex + 1], sound)
    return GameAudio.playSound(soundPath)
end

local quickSexList = {"female", "male"}
function GameAudio.playQuickChat(sound, sex)
    if 2 == sex then
        sex = 0
    end
    if not quickSexList[sex + 1] then
        printInfo("sex sound is not exist!")
        return
    end

    local soundPath = string.format("sounds/quickChat/%s/%s", quickSexList[sex + 1], sound)
    return GameAudio.playSound(soundPath)
end

local tzSexList = {"shaoyang_female", "shaoyang_male"}
function GameAudio.playTZHumanSound(sound, sex)
    local soundType = gameConfig:get(CONFIG_DEFAULT_HUMAN_SOUND)
    if not soundList[soundType] then
        printInfo("if not soundList[soundType] then, sound not exist")
        return
    end
    if 2 == sex then
        sex = 0
    end
    if not tzSexList[sex + 1] then
        printInfo("sex sound is not exist!")
        return
    end

    local soundPath = string.format("sounds/tianzha/%s/%s", tzSexList[sex + 1], sound)
    return GameAudio.playSound(soundPath)
end

local pdkSexList = {"female", "male"}
function GameAudio.playPDKHumanSound(sound, sex)
    if 2 == sex then
        sex = 0
    end
    if not pdkSexList[sex + 1] then
        printInfo("sex sound is not exist!")
        return
    end
    local soundPath = string.format("sounds/paodekuai/%s/%s", pdkSexList[sex + 1], sound)
    GameAudio.playSound(soundPath)
end

local dtzSexList = {"female", "male"}
function GameAudio.playDTZHumanSound(sound, sex)
    if 2 == sex then
        sex = 0
    end
    if not dtzSexList[sex + 1] then
        printInfo("sex sound is not exist!")
        return
    end
    local soundPath = string.format("sounds/datongzi/%s/%s", dtzSexList[sex + 1], sound)
    print(soundPath)
    GameAudio.playSound(soundPath)
end

local dtzSexList = {"female", "male"}
function GameAudio.playShuangKouHumanSound(sound, sex)
    if 2 == sex then
        sex = 0
    end
    if not dtzSexList[sex + 1] then
        printInfo("sex sound is not exist!")
        return
    end
    local soundPath = string.format("sounds/shuangKou/%s/%s", dtzSexList[sex + 1], sound)
    print(soundPath)
    GameAudio.playSound(soundPath)
end

local ph = {}
ph[1] = {"female", "male"}
ph[2] = {"female_yx", "male_yx"}
local pdkSexList = {"female", "male"}
function GameAudio.playYXPHHumanSound(sound, sex, index)
    local soundType = gameConfig:get(CONFIG_DEFAULT_HUMAN_SOUND)
    if not soundList[soundType] then
        printInfo("if not soundList[soundType] then, sound not exist")
        return
    end
    if 2 == sex then
        sex = 0
    end
    if not pdkSexList[sex + 1] then
        printInfo("sex sound is not exist!")
        return
    end

    local soundPath = string.format("sounds/yxph/%s/%s", ph[index][sex + 1], sound)
    print("=========soundPath==================", soundPath)
    return GameAudio.playSound(soundPath .. ".mp3")
end

local pdkSexList = {"female", "male"}
function GameAudio.playMJHumanSound(sound, sex)
    local soundType = gameConfig:get(CONFIG_DEFAULT_HUMAN_SOUND)
    if not soundList[soundType] then
        printInfo("if not soundList[soundType] then, sound not exist")
        return
    end
    if 2 == sex then
        sex = 0
    end
    if not pdkSexList[sex + 1] then
        printInfo("sex sound is not exist!")
        return
    end

    local soundPath = string.format("sounds/majiang/%s/%s", pdkSexList[sex + 1], sound)
    return GameAudio.playSound(soundPath)
end

function GameAudio.playNiuNiuHumanSound(sound, sex)
    local soundType = gameConfig:get(CONFIG_DEFAULT_HUMAN_SOUND)
    if not soundList[soundType] then
        printInfo("if not soundList[soundType] then, sound not exist")
        return
    end
    if 2 == sex then
        sex = 0
    end
    if not pdkSexList[sex + 1] then
        printInfo("sex sound is not exist!")
        return
    end

    local soundPath = string.format("sounds/niuniu/%s/%s", pdkSexList[sex + 1], sound)
    return GameAudio.playSound(soundPath)
end

function GameAudio.playCDPHZHumanSound(sound, sex)
    local soundType = gameConfig:get(CONFIG_DEFAULT_HUMAN_SOUND)
    if not soundList[soundType] then
        printInfo("if not soundList[soundType] then, sound not exist")
        return
    end
    if 2 == sex then
        sex = 0
    end
    if not pdkSexList[sex + 1] then
        printInfo("sex sound is not exist!")
        return
    end

    local soundPath = string.format("sounds/cdphz/%s/%s", pdkSexList[sex + 1], sound)
    return GameAudio.playSound(soundPath)
end

function GameAudio.playYZCHZHumanSound(sound, sex)
    local soundType = gameConfig:get(CONFIG_DEFAULT_HUMAN_SOUND)
    if not soundList[soundType] then
        printInfo("if not soundList[soundType] then, sound not exist")
        return
    end
    if 2 == sex then
        sex = 0
    end
    if not pdkSexList[sex + 1] then
        printInfo("sex sound is not exist!")
        return
    end

    local soundPath = string.format("sounds/yzchz/%s/%s", pdkSexList[sex + 1], sound)
    return GameAudio.playSound(soundPath)
end

function GameAudio.playHHPHZHumanSound(sound, sex)
    local soundType = gameConfig:get(CONFIG_DEFAULT_HUMAN_SOUND)
    if not soundList[soundType] then
        printInfo("if not soundList[soundType] then, sound not exist")
        return
    end
    if 2 == sex then
        sex = 0
    end
    if not pdkSexList[sex + 1] then
        printInfo("sex sound is not exist!")
        return
    end

    local soundPath = string.format("sounds/hhphz/%s/%s", pdkSexList[sex + 1], sound)
    return GameAudio.playSound(soundPath)
end

-- 播放麻将牌的声音提示
function GameAudio.playMaJiangSound(card, sex)
    if not card or 0 == card then
        return
    end

    local format = "mj%d.mp3"
    local sound = string.format(format, card)

    if card == 21 then
        sound = "yaoji.mp3"
    end
    return GameAudio.playMJHumanSound(sound, sex)
end

local actionList = {
    chi = {"chi1.mp3", "chi2.mp3", "chi3.mp3"},
    peng = {"peng1.mp3", "peng2.mp3", "peng3.mp3", "peng4.mp3"},
    gang = {"gang1.mp3", "gang2.mp3"},
    hu = {"hu1.mp3", "hu2.mp3"},
    dianpao = {"dianpao1.mp3", "dianpao2.mp3", "dianpao3.mp3"},
    qiangganghu = {"dianpao3.mp3"},
    zimo = {"zimo1.mp3", "zimo2.mp3",},
    bu = {"buzhang.mp3"},
}
-- 播放动作音效
function GameAudio.playActionSound(action, sex)
    if not actionList[action] then
        return
    end
    if type(actionList[action]) == "table" then
        local sound = actionList[action][math.random(1, #actionList[action])]
        return GameAudio.playMJHumanSound(sound, sex)
    end
    if type(actionList[action]) == "string" then
        return GameAudio.playMJHumanSound(actionList[action], sex)
    end
end

function GameAudio.stopEffect(handle)
    if handle then
        local sharedEngine = cc.SimpleAudioEngine:getInstance()
        sharedEngine:stopEffect(handle)
    end
end

function GameAudio.playPokerEffect(data)
    local name = POKER_AUDIO_NAMES[data.type]
    if not name then
        return
    end
    if data.type == TianZhaCardType.DAN_ZHANG or data.type == TianZhaCardType.DUI_ZI then
        name = string.format(name, data.value)
    elseif data.type == TianZhaCardType.SAN_ZHANG then
        name = string.format(name, data.count - 3)
    elseif data.type == TianZhaCardType.SI_DAI_SAN then
        name = string.format(name, data.count - 4)
    end
    GameAudio.playTZHumanSound(name, data.sex)
end


return GameAudio
