local BaseView = import("app.views.BaseView")
local SetView = class("SetView", BaseView)

function SetView:ctor(isInGame)
    SetView.super.ctor(self)
    if isInGame then
        self.tuiChuGame_:hide()
        self.jieSanFangJian_:show()
    else
        self.tuiChuGame_:show()
        self.jieSanFangJian_:hide()
    end
    -- self.tuiChuGame_:hide()
    -- self.jieSanFangJian_:hide()
    self:initMusicState_()
    self:initSoundState_()
end

function SetView:initMusicState_()
    if tonumber(setData:getMusicState()) == 1 then
        self.openMusic_:show()
        self.closeMusic_:hide()
        gameAudio.resumeMusic()
    else
        self.openMusic_:hide()
        self.closeMusic_:show()
        gameAudio.pauseMusic()
    end
end

function SetView:initSoundState_()
    if tonumber(setData:getSoundState()) == 1 then
        self.openSound_:show()
        self.closeSound_:hide()
    else
        self.openSound_:hide()
        self.closeSound_:show()
    end
end

function SetView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/setView.csb"):addTo(self)
    self.csbNode_:setPosition(display.cx, display.cy)
end

function SetView:jieSanFangJianHandler_()
    display.getRunningScene():sendDismissRoomCMD(true)
    self:closeHandler_()
end

function SetView:tuiChuGameHandler_()
end

function SetView:openMusicHandler_(button)
    button:hide()
    self.closeMusic_:show()
    setData:setMusicState(2)
    gameAudio.pauseMusic()
end

function SetView:closeMusicHandler_(button)
    button:hide()
    self.openMusic_:show()
    setData:setMusicState(1)
    gameAudio.resumeMusic()
end

function SetView:openSoundHandler_(button)
    button:hide()
    self.closeSound_:show()
    setData:setSoundState(2)
end

function SetView:closeSoundHandler_(button)
    button:hide()
    self.openSound_:show()
    setData:setSoundState(1)
end

return SetView 
