local BaseScene = import("app.scenes.BaseScene")
local GameBaseScene = class("GameBaseScene", BaseScene)

function GameBaseScene:ctor()
    GameBaseScene.super.ctor(self)
    self.gamesReady_ = {}
    self.gamesReady_[GAME_PAODEKUAI] = COMMANDS.PDK_READY
    self.gamesReady_[GAME_BCNIUNIU] = COMMANDS.NIUNIU_READY
    self.gamesReady_[GAME_MJZHUANZHUAN] = COMMANDS.MJ_READY
    --self.gamesReady_[GAME_MJCHANGSHA] = COMMANDS.CS_MJ_READY
    self.gamesReady_[GAME_DA_TONG_ZI] = COMMANDS.DTZ_READY
    self.gamesReady_[GAME_CDPHZ] = COMMANDS.CDPHZ_READY
    self.gamesReady_[GAME_MJHONGZHONG] = COMMANDS.HZMJ_READY
    self.gamesReady_[GAME_YZCHZ] = COMMANDS.YZCHZ_READY
    self.gamesReady_[GAME_SHUANGKOU] = COMMANDS.SHUANGKOU_READY
    self.gamesReady_[GAME_13DAO] = COMMANDS.DAO13_READY
    -- self.gamesReady_[GAME_ZJH] = COMMANDS.JINHUA_READY

    self.gamesUnReady_ = {}
    self.gamesUnReady_[GAME_PAODEKUAI] = COMMANDS.PDK_UNREADY
    self.gamesUnReady_[GAME_BCNIUNIU] = COMMANDS.NIUNIU_UNREADY
    self.gamesUnReady_[GAME_MJZHUANZHUAN] = COMMANDS.MJ_UNREADY
    --self.gamesUnReady_[GAME_MJCHANGSHA] = COMMANDS.CS_MJ_UNREADY
    self.gamesUnReady_[GAME_DA_TONG_ZI] = COMMANDS.DTZ_UNREADY
    self.gamesUnReady_[GAME_CDPHZ] = COMMANDS.CDPHZ_UNREADY
    self.gamesUnReady_[GAME_MJHONGZHONG] = COMMANDS.HZMJ_UNREADY
    self.gamesUnReady_[GAME_YZCHZ] = COMMANDS.YZCHZ_UNREADY
    self.gamesUnReady_[GAME_SHUANGKOU] = COMMANDS.SHUANGKOU_UNREADY
    self.gamesUnReady_[GAME_13DAO] = COMMANDS.DAO13_UNREADY

    self.gamesChangeSeat_ = {}
    self.gamesChangeSeat_[GAME_MJZHUANZHUAN] = COMMANDS.MJ_CHANGE_SIT
    --self.gamesChangeSeat_[GAME_MJCHANGSHA] = COMMANDS.CS_MJ_CHANGE_SIT
    self.gamesChangeSeat_[GAME_MJHONGZHONG] = COMMANDS.HZMJ_CHANGE_SIT

    self:initBtns_()
    -- self:doUnReadyHandler_()
    -- self:playBgm(true, setData:getGameBGMIndex())
end

function GameBaseScene:initBtns_()
    self.buttonReady_ = ccui.Button:create("res/images/game/button_playagain.png", "res/images/game/button_playagain.png")
    self.buttonReady_:setAnchorPoint(0.5,0.5)
    self.buttonReady_:setSwallowTouches(true)  
    self.buttonReady_:setName("ready")
    self:addChild(self.buttonReady_,1)
    self.buttonReady_:addTouchEventListener(handler(self, self.onButtonTouch_))
    self.buttonReady_:setPosition(display.cx, display.cy-200)
    self.buttonReady_:hide()
    self.buttonNoReady_ = ccui.Button:create("res/images/game/noReady.png", "res/images/game/noReady.png")
    self.buttonNoReady_:setAnchorPoint(0.5,0.5)
    self.buttonNoReady_:setSwallowTouches(true)  
    self.buttonNoReady_:setName("noReady")
    self.buttonNoReady_:setPosition(display.cx, display.cy-200)
    self:addChild(self.buttonNoReady_,1)
    self.buttonNoReady_:addTouchEventListener(handler(self, self.onButtonTouch_))
    self.buttonNoReady_:hide()

    self.buttonCopyRoomInfo_ = ccui.Button:create("res/images/game/copyRoomInfo.png", "res/images/game/copyRoomInfo.png")
    self.buttonCopyRoomInfo_:setAnchorPoint(0.5,0.5)
    self.buttonCopyRoomInfo_:setSwallowTouches(true)  
    self:addChild(self.buttonCopyRoomInfo_,1)
    self.buttonCopyRoomInfo_:setName("copyInfo")
    self.buttonCopyRoomInfo_:setPosition(display.cx, display.cy-300)
    self.buttonCopyRoomInfo_:addTouchEventListener(handler(self, self.onButtonTouch_))
    self.buttonCopyRoomInfo_:hide()
end

function GameBaseScene:initChangeBtn_()
    self.buttonChangeSeat_ = ccui.Button:create("res/images/game/button_changeSeatID.png", "res/images/game/button_changeSeatID.png")
    self.buttonChangeSeat_:setAnchorPoint(0.5,0.5)
    self.buttonChangeSeat_:setSwallowTouches(true)  
    self:addChild(self.buttonChangeSeat_,1)
    self.buttonChangeSeat_:setName("changeSeat")
    self.buttonChangeSeat_:setPosition(display.cx+200,  display.cy-200)
    self.buttonChangeSeat_:addTouchEventListener(handler(self, self.onButtonTouch_))
    self.buttonNoReady_:setPositionX(display.cx-200)
    self.buttonReady_:setPositionX(display.cx-200)
end

function GameBaseScene:initShaiZiBtn()
    self.buttonDaGu_ = ccui.Button:create("res/images/majiang/btn_daGu.png", "res/images/majiang/btn_daGu.png")
    self.buttonDaGu_:setAnchorPoint(0.5,0.5)
    self.buttonDaGu_:setSwallowTouches(true)  
    self:addChild(self.buttonDaGu_,1)
    self.buttonDaGu_:setName("daGu")
    self.buttonDaGu_:setPosition(display.cx, display.cy-70)
    self.buttonDaGu_:addTouchEventListener(handler(self, self.onButtonTouch_))
    self.buttonDaGu_:hide()
    self:initWaitingShaiZi()
end

function GameBaseScene:initWaitingShaiZi()
    self.waitingShaiZi_ = ccui.ImageView:create("res/images/majiang/waitingShaiZi/1.png")
    self:addChild(self.waitingShaiZi_,1)
    self.waitingShaiZi_:setPosition(display.cx, display.cy)
    self.waitingShaiZi_:hide()
end

function GameBaseScene:showWaitingShaiZi()
    self.waitingShaiZi_:show()
    self.waitingShaiZiIndex_ = 1
    local sequence =
        transition.sequence(
        {
            cc.DelayTime:create(0.3),
            cc.CallFunc:create(
                function()
                    self.waitingShaiZiIndex_ = self.waitingShaiZiIndex_ + 1
                    if self.waitingShaiZiIndex_ > 4 then
                        self.waitingShaiZiIndex_ = 1
                    end
                    local picName = string.format("res/images/majiang/waitingShaiZi/%d.png", self.waitingShaiZiIndex_)
                    self.waitingShaiZi_:loadTexture(picName)
                end
            )
        }
    )
    self.waitingShaiZi_:runAction(cc.RepeatForever:create(sequence))
end

function GameBaseScene:hideWaitingShaiZi()
    self.waitingShaiZi_:hide()
    self.waitingShaiZi_:stopAllActions()
end

function GameBaseScene:setDaGuVisible(bool)
    self.buttonDaGu_:setVisible(bool)
end

function GameBaseScene:onButtonTouch_(sender, eventType)
    if eventType == 0 then
        -- self:onTouchBegin_()
        sender:scale(0.9)
    elseif eventType == 1 then
        -- self:onTouchMoved_()
    elseif eventType == 2 then
        sender:scale(1)
        self:onTouchEnded_(sender)
    elseif eventType == 3 then
        -- self:onTouchCancel_(sender)
    end
end

function GameBaseScene:onTouchEnded_(sender)
    if sender:getName() == "ready" then
        sender:hide()
        self.buttonNoReady_:show()
        dataCenter:sendOverSocket(self.gamesReady_[self.gameType_])
    elseif sender:getName() == "noReady" then
        self.buttonReady_:show()
        sender:hide()
        dataCenter:sendOverSocket(self.gamesUnReady_[self.gameType_])
    elseif sender:getName() == "copyInfo" then
        gailun.native.copy(self:getTable():getTid())
        app:showTips("复制成功!")
    elseif sender:getName() == "daGu" then
        --dataCenter:sendOverSocket(COMMANDS.CS_MJ_PLAYER_DIE_POINT)
    elseif sender:getName() == "changeSeat" then
        dataCenter:sendOverSocket(self.gamesChangeSeat_[self.gameType_])
    end
end

function GameBaseScene:hideChangeSit()
    if self.buttonChangeSeat_ and not tolua.isnull(self.buttonChangeSeat_) then
        self.buttonChangeSeat_:setVisible(false)
        self.buttonNoReady_:setPositionX(display.cx)
        self.buttonReady_:setPositionX(display.cx)
    end
end

function GameBaseScene:doUnReadyHandler_()
    local handlers = dataCenter:s2cCommandToNames {
        --{COMMANDS.CS_MJ_UNREADY, handler(self, self.onUnReady_)},
        -- {COMMANDS.PDK_UNREADY, handler(self, self.onUnReady_)},
        -- {COMMANDS.NIUNIU_UNREADY, handler(self, self.onUnReady_)},
        {COMMANDS.MJ_UNREADY, handler(self, self.onUnReady_)},
        -- {COMMANDS.DTZ_UNREADY, handler(self, self.onUnReady_)},
        -- {COMMANDS.CDPHZ_UNREADY, handler(self, self.onUnReady_)},
        {COMMANDS.HZMJ_UNREADY, handler(self, self.onUnReady_)},
        -- {COMMANDS.SHUANGKOU_UNREADY, handler(self, self.onUnReady_)},
        -- {COMMANDS.DAO13_UNREADY, handler(self, self.onUnReady_)},
        --{COMMANDS.CS_MJ_NOTIFY_PLAYER_DIE_POINT, handler(self, self.onNotifyPlayerDiePoint_)},
        --{COMMANDS.CS_MJ_PLAYER_DIE_POINT, handler(self, self.onPlayerDiePoint_)},
    }
    gailun.EventUtils.create(self, dataCenter, self, handlers)
end

function GameBaseScene:onNotifyPlayerDiePoint_(event)
    self:setDaGuVisible(true)
    self:showWaitingShaiZi()
end

function GameBaseScene:onPlayerDiePoint_(event)
    self:setDaGuVisible(false)
    self:hideWaitingShaiZi()
    self.tableController_:doPlayShaiZi(event.data)
end

function GameBaseScene:onUnReady_(event)
    local p = self.tableController_:getPlayerBySeatID(event.data.seatID)
    p:doReady(event.data.isPrepare)
end

function GameBaseScene:setPlayerIsReady(isReady)
    print("=======setPlayerIsReady===========", isReady)
    self.buttonReady_:setVisible(not isReady)
    self.buttonNoReady_:setVisible(isReady)
    self.buttonCopyRoomInfo_:setVisible(true)
end

function GameBaseScene:getLockScore()
    return 0
end

function GameBaseScene:setBtnIsInGame()
    print("=================setBtnIsInGame======================")
    self.buttonReady_:setVisible(false)
    self.buttonNoReady_:setVisible(false)
    self.buttonCopyRoomInfo_:setVisible(false)
    if self.buttonChangeSeat_ and not tolua.isnull(self.buttonChangeSeat_) then
        self.buttonChangeSeat_:setVisible(false)
    end
end

return GameBaseScene 
