local BaseLayer = require("app.views.base.BaseDialog")
local SettingView = class("SettingView", BaseLayer)

local TYPES = gailun.TYPES
local nodes = {
    type = TYPES.ROOT, children = {
    {type = TYPES.NODE, var = "mainLayer_", size = {display.width, display.height}, ap = {0, 0}, children = {
        {type = TYPES.SPRITE, filename = "res/images/sz_bg.png",  var = "rootLayer_", x = display.cx, y = display.cy, scale9 = true, size = {700, 480}, capInsets = cc.rect(100, 100, 100, 100),
            children = {
                {type = TYPES.SPRITE, filename = "res/images/common/sz_yx.png", ppx = 0.25, ppy = 0.65, ap = {0.5, 0.5}},
                {type = TYPES.SPRITE, filename = "res/images/common/sz_sy.png", ppx = 0.25, ppy = 0.4, ap = {0.5, 0.5}},
                -- {type = TYPES.SPRITE, filename = "#sz_sz_word.png", ppx = 0.5, ppy = 0.82, ap = {0.5, 0.5}},
                
                {type = TYPES.BUTTON, var = "buttonQuitGame_", autoScale = 0.9, normal = "res/images/hall/settingQuit.png", 
                    options = {}, ppx = 0.5, ppy = 0.15 },
                
                {type = TYPES.BUTTON, var = "buttonSound_", autoScale = 0.9, normal = "res/images/common/sound_open.png", options = {}, ppx = 0.72, ppy = 0.65},
                {type = TYPES.BUTTON, var = "buttonMusic_", autoScale = 0.9, normal = "res/images/common/music_open.png", options = {}, ppx = 0.72, ppy = 0.4},
                

                {type = TYPES.CHECK_BOX, var = "progressSound_", images = {on = "res/images/common/sound_close_btn.png", off = "res/images/common/sound_open_btn.png"}, 
                    options = {}, ppx = 0.5, ppy = 0.65},

                {type = TYPES.CHECK_BOX, var = "progressMusic_", images = {on = "res/images/common/sound_close_btn.png", off = "res/images/common/sound_open_btn.png"}, 
                    options = {}, ppx = 0.5, ppy = 0.4},
                }
        },
        {type = TYPES.SPRITE, filename = "res/images/common/grxx_title.png", ppx = 0.5, ppy = 0.82},
        {type = TYPES.SPRITE, filename = "res/images/common/sz_sz_word.png", ppx = 0.5, ppy = 0.825},
        {type = TYPES.BUTTON, var = "buttonClosed_", autoScale = 0.9, normal = "res/images/common/closebutton.png", 
                    options = {}, ppx = 0.77, ppy = 0.81 },
    }
    }}
}

function SettingView:ctor()
    SettingView.super.ctor(self)
    self:addMaskLayer(self, 100)
    gailun.uihelper.render(self,nodes)
    self.progressSound_:onButtonStateChanged(handler(self, self.onProgressSoundChanged_))
    self.progressMusic_:onButtonStateChanged(handler(self, self.onProgressMusicChanged_))

    self.buttonClosed_:onButtonClicked(handler(self,self.onClose_))
    self.buttonQuitGame_:onButtonClicked(handler(self,self.onButtonQuitGameClicked_))

    self.buttonSound_:onButtonClicked(handler(self, self.onSoundClicked_))
    self.buttonMusic_:onButtonClicked(handler(self, self.onMusicClicked_))

    self:initView_()
    self:androidBack()
    self.dialogLayer_:hide()
end

function SettingView:initView_()
    local soundOn = gameConfig:get(CONFIG_SOUND_ON)
    local musicOn = gameConfig:get(CONFIG_MUSIC_ON)
    local soundVolume = gameConfig:get(CONFIG_SOUND_VOLUME)
    local musicVolume = gameConfig:get(CONFIG_MUSIC_VOLUME)
    self.progressMusic_:setButtonSelected(musicOn)
    self.progressSound_:setButtonSelected(soundOn)
    if not soundOn then
        self.buttonSound_:setButtonImage('pressed', "res/images/common/sound_close.png")
        self.buttonSound_:setButtonImage('normal', "res/images/common/sound_close.png")
    else
        self.buttonSound_:setButtonImage('pressed', "res/images/common/sound_open.png")
        self.buttonSound_:setButtonImage('normal', "res/images/common/sound_open.png")
    end
    if not musicOn then
        self.buttonMusic_:setButtonImage('pressed', "res/images/common/music_close.png")
        self.buttonMusic_:setButtonImage('normal', "res/images/common/music_close.png")
    else
        self.buttonMusic_:setButtonImage('pressed', "res/images/common/music_open.png")
        self.buttonMusic_:setButtonImage('pressed', "res/images/common/music_open.png")
    end
        -- gailun.uihelper.setTouchHandler(self.mainLayer_, function (event)
        -- self:removeFromParent()
    -- end)
end

function SettingView:onSoundClicked_(event)
    local isTrue = gameConfig:get(CONFIG_SOUND_ON)
    if not isTrue then
        self.buttonSound_:setButtonImage('pressed', "res/images/common/sound_open.png")
        self.buttonSound_:setButtonImage('normal', "res/images/common/sound_open.png")
        self.progressSound_:setButtonSelected(true)
        gameConfig:set(CONFIG_SOUND_VOLUME, 100)
        gameConfig:set(CONFIG_SOUND_ON, true)
    else
        self.buttonSound_:setButtonImage('pressed', "res/images/common/sound_close.png")
        self.buttonSound_:setButtonImage('normal', "res/images/common/sound_close.png")
        self.progressSound_:setButtonSelected(false)
        -- gameConfig:set(CONFIG_SOUND_VOLUME, 0)
        gameAudio.stopSounds()
        gameConfig:set(CONFIG_SOUND_ON, false)
        gameConfig:set(CONFIG_SOUND_VOLUME, 0)
    end
end

function SettingView:onMusicClicked_(event)
    local isPlay = gameConfig:get(CONFIG_MUSIC_ON)
    if not isPlay then
        self.buttonMusic_:setButtonImage('normal', "res/images/common/music_open.png")
        self.progressMusic_:setButtonSelected(true)
        gameAudio.resumeMusic()
        gameConfig:set(CONFIG_MUSIC_ON, true)
        gameConfig:set(CONFIG_MUSIC_VOLUME, 1)
        if not audio.isMusicPlaying() then
            gameAudio.playMusic("sounds/music1.mp3")
        end
        if tonumber(setData:getMusicIsCLose()) == 1 then
            gameAudio.setMusicVolume(0)
        else
            gameAudio.setMusicVolume(tonumber(setData:getMusicState())/100)
        end
    else
        self.buttonMusic_:setButtonImage('normal', "res/images/common/music_close.png")
        self.progressMusic_:setButtonSelected(false)
        gameAudio.pauseMusic()
        gameConfig:set(CONFIG_MUSIC_ON, false)
        gameConfig:set(CONFIG_MUSIC_VOLUME, 0)
        gameAudio.setMusicVolume(0)
    end
end

function SettingView:onProgressSoundChanged_(event)
    if event.state == "on" then
        self.buttonSound_:setButtonImage('normal', "res/images/common/sound_open.png")
        self.buttonSound_:setButtonImage('pressed', "res/images/common/sound_open.png")
        --self.buttonSound_:setButtonSelected(true)
        gameConfig:set(CONFIG_SOUND_VOLUME, 100)
        gameConfig:set(CONFIG_SOUND_ON, true)
    elseif event.state == "off" then
        self.buttonSound_:setButtonImage('pressed', "res/images/common/sound_close.png")
        self.buttonSound_:setButtonImage('normal', "res/images/common/sound_close.png")
        gameConfig:set(CONFIG_SOUND_ON, false)
        gameAudio.stopSounds()
        gameConfig:set(CONFIG_SOUND_VOLUME, 0)
        --self.buttonSound_:setButtonSelected(false)
    end
end

function SettingView:onProgressMusicChanged_(event)
    if event.state == "on" then
        self.buttonMusic_:setButtonImage('pressed', "res/images/common/music_open.png")
        self.buttonMusic_:setButtonImage('normal', "res/images/common/music_open.png")
        gameAudio.resumeMusic()
        gameConfig:set(CONFIG_MUSIC_VOLUME, 1)
        gameConfig:set(CONFIG_MUSIC_ON, true)
        if not audio.isMusicPlaying() then
            gameAudio.playMusic("sounds/music1.mp3")
        end
        if tonumber(setData:getMusicIsCLose()) == 1 then
            gameAudio.setMusicVolume(0)
        else
            gameAudio.setMusicVolume(tonumber(setData:getMusicState())/100)
        end
    elseif event.state == "off" then
        self.buttonMusic_:setButtonImage('pressed', "res/images/common/music_close.png")
        self.buttonMusic_:setButtonImage('normal', "res/images/common/music_close.png")
        gameConfig:set(CONFIG_MUSIC_ON, false)
        gameAudio.pauseMusic()
        gameConfig:set(CONFIG_MUSIC_VOLUME, 0)
        gameAudio.setMusicVolume(0)
        --self.buttonMusic_:setButtonSelected(false)
    end
end

function SettingView:onClose_(event)
    display.getRunningScene():closeWindow()
    self:removeFromParent(true)
end

function SettingView:onButtonQuitGameClicked_(event)
    gameCache:set("autoToken", "")
    app:enterLoginScene()
end

return SettingView
