local BaseView = import("app.views.BaseView")
local SetViewNew = class("SetViewNew", BaseView)
local SetPHZView = import("app.views.hall.GameSetView.SetPHZView")
local SetPDKView = import("app.views.hall.GameSetView.SetPDKView")
local SetMJView = import("app.views.hall.GameSetView.SetMJView")
local SetNNView = import("app.views.hall.GameSetView.SetNNView")
local gameHMConf = {}
gameHMConf[GAME_PAODEKUAI] = SetPDKView
gameHMConf[GAME_CDPHZ] = SetPHZView
gameHMConf[GAME_HHQMT] = SetPHZView
gameHMConf[GAME_SYBP] = SetPHZView
gameHMConf[GAME_LDFPF] = SetPHZView
gameHMConf[GAME_FHHZMJ] = SetMJView
gameHMConf[GAME_HSMJ] = SetMJView
gameHMConf[GAME_FHLMZ] = SetPDKView
gameHMConf[GAME_MJZHUANZHUAN] = SetMJView
gameHMConf[GAME_MJHONGZHONG] = SetMJView
--gameHMConf[GAME_BCNIUNIU] = SetNNView

function SetViewNew:ctor(isInGame,gameType)
    print("=============isInGame,gameType=====================",isInGame,gameType)
    SetViewNew.super.ctor(self)
    self.isInGame_ = isInGame
    self.gameType_  = gameType
    self.PanelYY = self.csbNode_:getChildByName("Panel_YY")
    self.PanelHM = self.csbNode_:getChildByName("Panel_HM")
    self:getElements(self.PanelYY)
    self.jsbq_:setSelected(setData:getJZBQ())
    if isInGame then
        self.tuiChuGame_:hide()
        self.qieHuan_:hide()
        self.jieSanFangJian_:show()
    else
        self.tuiChuGame_:show()
        self.qieHuan_:show()
        self.jieSanFangJian_:hide()
        if "ios" == device.platform then
            self.tuiChuGame_:hide()
            self.qieHuan_:setPositionX(self.jieSanFangJian_:getPositionX())
        end     
    end
    self:initPanelHM(gameType)
    if self.isShowTeShu then
        self:YYHandler_()
    else
        self.PanelYY:setVisible(true)
    end
    self:initMusicState_()
    self:initSoundState_()
    self.musicePres_:addEventListener(handler(self, self.musicePresHandler_))
    self.soundPres_:addEventListener(handler(self, self.soundPresHandler_))
    --self:initMusicBtns_()
end

function SetViewNew:initPanelHM(gameType)
    local gameSetView = gameHMConf[gameType]
    if gameSetView then
        self.isShowTeShu = true
        self.PanelHM = gameSetView.new(gameType):addTo(self.csbNode_):pos(0,0)
        if GAME_CDPHZ == gameType or GAME_SYBP == gameType or GAME_HHQMT == gameType or GAME_LDFPF == gameType then --水滴特效开关
            self.waterTX_:show()
            self.waterTXTip_:show()
            local isShowWaterTX = setData:getCDPHZWaterTX() == 1
            self.waterTX_:setSelected(isShowWaterTX)
        end
    end 
end

function SetViewNew:initMusicBtns_()
    self.musicBtnList_ = {}
    self.musicBtnList_[1] = self.music1_
    self.musicBtnList_[2] = self.music2_
    self.musicBtnList_[3] = self.music3_
    self.musicBtnList_[4] = self.music4_
    local index = 0
    if self.isInGame_ then
        index = setData:getGameBGMIndex()
    else
        index = setData:getBGMIndex()
    end
    self:updateMusicBtn_(tonumber(index))
end

function SetViewNew:updateMusicBtn_(index)
    for i,v in ipairs(self.musicBtnList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
end
-- music1
function SetViewNew:music1Handler_()
    self:updateMusicBtn_(1)
    if self.isInGame_ then
        setData:setGameBGMIndex(1)
    else
        setData:setBGMIndex(1)
    end
    display.getRunningScene():playBgm(self.isInGame_, 1)
end

function SetViewNew:music2Handler_()
    self:updateMusicBtn_(2)
    if self.isInGame_ then
        setData:setGameBGMIndex(2)
    else
        setData:setBGMIndex(2)
    end
    display.getRunningScene():playBgm(self.isInGame_, 2)
end

function SetViewNew:music3Handler_()
    self:updateMusicBtn_(3)
    if self.isInGame_ then
        setData:setGameBGMIndex(3)
    else
        setData:setBGMIndex(3)
    end
    display.getRunningScene():playBgm(self.isInGame_, 3)
end

function SetViewNew:music4Handler_()
    self:updateMusicBtn_(4)
    if self.isInGame_ then
        setData:setGameBGMIndex(4)
    else
        setData:setBGMIndex(4)
    end
    display.getRunningScene():playBgm(self.isInGame_, 4)
end

function SetViewNew:musicBtnHandler_(item)
    if item:isSelected() then
        gameAudio.setMusicVolume(0)
        setData:setMusicIsCLose(1)
        self.musicePres_:setPercent(0)
    else
        setData:setMusicIsCLose(0)
        gameAudio.setMusicVolume(tonumber(setData:getMusicState())/100)
        self.musicePres_:setPercent(tonumber(setData:getMusicState()))
    end
end

function SetViewNew:soundBtnHandler_(item)
    if item:isSelected() then
        gameAudio.setSoundsVolume(0)
        setData:setSoundIsCLose(1)
        self.soundPres_:setPercent(0)
    else
        setData:setSoundIsCLose(0)
        gameAudio.setSoundsVolume(tonumber(setData:getSoundState())/100)
        self.soundPres_:setPercent(tonumber(setData:getSoundState()))
    end
end

function SetViewNew:initMJState_()
    for i=1,4 do
        if i == setData:getCDPHZBgIndex() then
            local x,y = self["ptbg"..i.."_"]:getPosition()
            self.ptmask_:setPosition(x, y)
        end
    end
end


function SetViewNew:getElements(node)
    if self.scaleX > self.scaleY then
        self.itemScale = self.scaleY
        self.backScale = self.scaleX
    else
        self.itemScale = self.scaleX
        self.backScale = self.scaleY
    end
    for k,v in pairs(node:getChildren()) do
        local x, y = v:getPosition()
        local vInfo = string.split(v:getName(), "_")
        local itemName
        if vInfo[2] then
            itemName =  vInfo[2] .. "_"
            self[itemName] = v
        end
        local itemType = vInfo[1]
        print(itemType, itemName,vInfo[3])
        if itemType == "btn" or itemType == "checkBox" then
            v.currScale = self.itemScale
            v:setScale(self.itemScale)
            self.buttonScale_ = v:getScale()
            if vInfo[2] then
                local funcName = vInfo[2].."Handler_"
                if self[funcName] then
                    self:buttonRegister(v, handler(self, self[funcName]))
                end
                if vInfo[3] == "ns" then
                    v.sound = "ns"
                    v.offScale = 1
                else
                    v.offScale = 0.9
                end
            end
        elseif itemType == "back" then   
            v:setScale(self.backScale)
        else
            v:setScale(self.itemScale)
        end
        v:setPosition(x * self.itemScale, y*self.itemScale)
    end
end

function SetViewNew:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/setViewNew.csb"):addTo(self)
    self.csbNode_:setPosition(display.cx, display.cy)
end

function SetViewNew:qieHuanHandler_()
    gameCache:set("autoToken", "")
    app:enterLoginScene()
end

function SetViewNew:initMusicState_()
    if tonumber(setData:getMusicIsCLose()) == 1 then
        gameAudio.setMusicVolume(0)
        self.musicePres_:setPercent(0)
        self.musicBtn_:setSelected(true)
    else
        self.musicePres_:setPercent(tonumber(setData:getMusicState()))
        gameAudio.setMusicVolume(tonumber(setData:getMusicState())/100)
        self.musicBtn_:setSelected(false)
    end
end

function SetViewNew:initSoundState_()
    if tonumber(setData:getSoundIsCLose()) == 1 then
        gameAudio.setSoundsVolume(0)
        self.soundPres_:setPercent(0)
        self.soundBtn_:setSelected(true)
    else
        self.soundPres_:setPercent(tonumber(setData:getSoundState()))
        gameAudio.setSoundsVolume(tonumber(setData:getSoundState())/100)
        self.soundBtn_:setSelected(false)
    end
end

function SetViewNew:jsbqHandler_(item)
    setData:setJZBQ(item:isSelected())
end

function SetViewNew:musicePresHandler_(item, stype)
    setData:setMusicState(item:getPercent())
    gameAudio.setMusicVolume(item:getPercent()/100)
    if item:getPercent() == 0 then
        self.musicBtn_:setSelected(true)
    else
        self.musicBtn_:setSelected(false)
    end
end

function SetViewNew:soundPresHandler_(item, stype)
    setData:setSoundState(item:getPercent())
    gameAudio.setSoundsVolume(item:getPercent()/100)
    if item:getPercent() == 0 then
        self.soundBtn_:setSelected(true)
    else
        self.soundBtn_:setSelected(false)
    end
end

function SetViewNew:openSoundHandler_(button)
    
end

function SetViewNew:closeSoundHandler_(button)
    
end

function SetViewNew:jieSanFangJianHandler_()
    display.getRunningScene():sendDismissRoomCMD(true)
    self:closeHandler_()
end

function SetViewNew:tuiChuGameHandler_()
    if "ios" ~= device.platform then
        app:exit()
    end 
end


function SetViewNew:YYHandler_()
    if not self.isShowTeShu then
        return 
    end
    local aimVis = self.ShowYY_:isVisible()
    if aimVis then
        return
    end
    aimVis = not aimVis 
    self.ShowYY_:setVisible(aimVis == true)
    self.hideYY_:setVisible(aimVis == false)
    self.ShowHM_:setVisible(aimVis == false)
    self.hideHM_:setVisible(aimVis == true)
    self.PanelYY:setVisible(aimVis)
    self.PanelHM:setVisible(not aimVis)
end

function SetViewNew:HMHandler_()
    if not self.isShowTeShu then
        return 
    end
    local aimVis = self.ShowYY_:isVisible()
    if not aimVis then
        return
    end
    aimVis = not aimVis 
    self.ShowYY_:setVisible(aimVis == true)
    self.hideYY_:setVisible(aimVis == false)
    self.ShowHM_:setVisible(aimVis == false)
    self.hideHM_:setVisible(aimVis == true)
    self.PanelYY:setVisible(aimVis)
    self.PanelHM:setVisible(not aimVis)
end

function SetViewNew:waterTXHandler_(item)
    local isSelect = item:isSelected()
    display.getRunningScene():setClickViewVisible_(isSelect)
    setData:setCDPHZWaterTX(isSelect and 1 or 0)
end

return SetViewNew 
