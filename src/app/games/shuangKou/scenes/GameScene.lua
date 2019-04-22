local BaseAlgorithm = require("app.games.shuangKou.utils.BaseAlgorithm")
local DismissRoomView = import("app.views.game.DismissRoomView")
local Nodes = import("..data.GameSceneNodes")
local TaskQueue = require("app.controllers.TaskQueue")
local BaseScene = import("app.scenes.BaseScene")
local SiRenDingWei = import("app.views.SiRenDingWei")
local SanRenDingWei = import("app.views.SanRenDingWei")
local SelectedView = import("app.views.SelectedView")
local WenZiYuYin = import("app.views.WenZiYuYin")
local GameOverView = require("app.games.shuangKou.views.game.GameOverView")

local GameScene = class("GameScene", BaseScene)

local BIRD_SPACE_SECONDS = 1

function GameScene:ctor()
    GameScene.super.ctor(self)
    dataCenter:tryConnectSocket()
    self.name = "SHUANGKOU"
    gailun.uihelper.render(self, Nodes.layers)
    self.gameOverData_ = nil
    self.playerIPList_ = {}
    self:onAllLoaded_()
    local node = display.newNode():addTo(self)
    TaskQueue.init(node)
    local path1 = cc.FileUtils:getInstance():getWritablePath() .. "/" .. "1.aac"
    local path2 = cc.FileUtils:getInstance():getWritablePath() .. "/" .. "2.aac"
    local path3 = cc.FileUtils:getInstance():getWritablePath() .. "/" .. "3.aac"
    os.remove(path1)
    os.remove(path2)
    os.remove(path3)
    -- gameAudio:stopMusic()
    gameAudio.playMusic("sounds/niuniu/bgm.mp3", true)
    app:initMusicState_()
    self:initRoundOverBtn_()
    self.isMenuOpen_ = false
    self.isPlaying_ = false
end

function GameScene:onEnterTransitionFinish()
    printInfo("GameScene:onEnterTransitionFinish")
    GameScene.super.onEnterTransitionFinish(self)
    self:checkSocketConnected_()
    self:schedule(handler(self, self.checkSocketConnected_), 2)
    self:onBgLoaded_()
    dataCenter:resumeSocketMessage()
end

function GameScene:bindSocketListeners()
    GameScene.super.bindSocketListeners(self)
    local handlers = dataCenter:s2cCommandToNames {
        {COMMANDS.SHUANGKOU_ROUND_OVER, handler(self, self.onRoundOver_)},
        {COMMANDS.SHUANGKOU_GAME_OVER, handler(self, self.onGameOver_)},
        {COMMANDS.SHUANGKOU_READY, handler(self, self.onReady_)},
        {COMMANDS.SHUANGKOU_LEAVE_ROOM, handler(self, self.onLeaveRoom_)},
        {COMMANDS.SHUANGKOU_PLAYER_ENTER_ROOM, handler(self, self.onPlayerEnterRoom_)},
        {COMMANDS.SHUANGKOU_REQUEST_DISMISS, handler(self, self.onDismissInRequest_)},
        {COMMANDS.SHUANGKOU_ROOM_INFO, handler(self, self.onRoomInfo_)},
        {COMMANDS.SHUANGKOU_CHECK_CHOU_JIANG, handler(self, self.onCheckChouJiang_)},
        {COMMANDS.SHUANGKOU_CHOU_JIANG, handler(self, self.onChouJiang_)},
        {COMMANDS.SHUANGKOU_GAME_BROADCAST, handler(self, self.onGameBroadcast_)},
        {COMMANDS.SHUANGKOU_NOTIFY_LOCATION, handler(self, self.onNotifyLocation_)},
        {COMMANDS.SHUANGKOU_REQUEST_LOCATION, handler(self, self.onRequestLocation_)},
    }
    gailun.EventUtils.create(self, dataCenter, self, handlers)
end

function GameScene:initRoundOverBtn_()  --jxfj
    self.againBtn_ = ccui.Button:create("res/images/paohuzi/roundOver/playAgain.png", "res/images/paohuzi/roundOver/playAgain.png")
    self.againBtn_:setAnchorPoint(0.5,0.5)
    self.againBtn_:setSwallowTouches(false)
    self.againBtn_:setPosition(display.right - 150, display.bottom + 50)    
    self.layerTop_:addChild(self.againBtn_)
    self.againBtn_:setName("again")
    self.againBtn_:addTouchEventListener(handler(self, self.onButtonClick_))

    self.resultBtn_ = ccui.Button:create("res/images/paohuzi/roundOver/lookRezult.png", "res/images/paohuzi/roundOver/lookRezult.png")
    self.resultBtn_:setAnchorPoint(0.5,0.5)
    self.resultBtn_:setSwallowTouches(false)  
    self.resultBtn_:setPosition(display.right - 150, display.bottom + 50)  
    self.layerTop_:addChild(self.resultBtn_)
    self.resultBtn_:setName("result")
    self.resultBtn_:addTouchEventListener(handler(self, self.onButtonClick_))

    self.resultBtn_:hide()
    self.againBtn_:hide()
end

function GameScene:showOverBtn_(visible)
    self.resultBtn_:setVisible(visible)
    self.againBtn_:setVisible(not visible)
end

function GameScene:onButtonClick_(item, eventType)
    if eventType == 2 or eventType == 3 then
        item:setScale(1)
        if eventType == 2 then
            if item:getName() == "again" then
                TaskQueue.continue()
                self:nextRound()
                self.resultBtn_:hide()
                self.againBtn_:hide()
            elseif item:getName() == "result" then
                TaskQueue.continue()
                self.resultBtn_:hide()
                self.againBtn_:hide()
                self:showJieSuanSelectView(false)
                if self.roundOverView_ then
                    self.roundOverView_:removeSelf()
                    self.roundOverView_ = nil
                end
            end
        end
    elseif eventType == 0 then
        gameAudio.playSound("sounds/common/sound_button_click.mp3")
        item:setScale(0.9)
    end
end

function GameScene:onCleanup()
    collectgarbage("collect")
end

function GameScene:checkSocketConnected_()
    if not CHECK_NETWORK then
        return
    end
    if not dataCenter:isSocketReady() then
        dataCenter:tryConnectSocket()
    end
end

function GameScene:onBgLoaded_(texture)
    gailun.uihelper.render(self, Nodes.bg, self.layerBG_)
end

function GameScene:setHostPlayerState(offline)
    if self.tableController_ then
        self.tableController_:setHostPlayerState(offline)
    end
end

function GameScene:initBackGroud_(data)
    local sprite = display.newSprite("res/images/game.png")
    self.bgSprite_:addChild(sprite)
end

function GameScene:onAllLoaded_()
    self.tableController_ = app:createConcreteController("TableController"):addTo(self.layerTable_)
    gailun.uihelper.render(self, Nodes.menuLayerTree, self.layerMenu_)
    self:onEnter_()
end

function GameScene:onEnter_()
    gailun.EventUtils.clear(self)
    gailun.uihelper.setTouchHandler(self.layerBG_, handler(self, self.onBgClicked_))
    local cls = self.tableController_:getTable().class
    local handlers = {
        {cls.CHANGE_STATE_EVENT, handler(self, self.onTableStateChanged_)},
    }
    gailun.EventUtils.create(self, self.tableController_:getTable(), self, handlers)

    self:onEnterTransitionFinish_()

    -- dataCenter:setGameSceneCallBack(handler(self, self.onSocketClosed_))
end

function GameScene:onChouJiang_(event)
    local p = self.tableController_:getPlayerBySeatID(event.data.seatID)
    if self.hongBaoView_ then
        event.data.endX,  event.data.endY= p:getPlayerPosition()
        self.hongBaoView_:openHongBao(event.data)
    end
    self:showZhongJiangView_(p:getUid(), p:getNickName(), event.data.diamond, event.data.long_time)
end

function GameScene:onCheckChouJiang_(event)
    if self.hongBaoView_ == nil then
        self.hongBaoView_ = app:createView("game.HongBaoView", event.data):addTo(self)
    end
end

function GameScene:onGameBroadcast_(event)
    -- self:showZhongJiangView_(event.data.uid, event.data.nickname, event.data.diamond, event.data.long_time)
end

function GameScene:showZhongJiangView_(userId, nickName, diamond, holdTime)
    local message = "恭喜玩家：" .. nickName .. "开房抽奖喜获钻石" .. diamond .. "个"
    if CHANNEL_CONFIGS.BROADCAST then
        if self.hongBaoZhongJiangView_ == nil then
            self.hongBaoZhongJiangView_ = app:createView("game.HongBaoZhongJiangView"):addTo(self):update(message, holdTime)
        else
            self.hongBaoZhongJiangView_:update(message, event.data.long_time)
        end
    end
end

function GameScene:getController()
    return self.tableController_
end

function GameScene:getSeats()
    return self.tableController_:getSeats()
end

function GameScene:onSocketClosed_()
    local seatID = self:getHostPlayer():getSeatID()
    if self.tableController_ == nil then return end
    for k,v in pairs(self.tableController_:getSeats()) do
        if seatID == v:getSeatID() then
            v:setOffline(true)
        else
            v:setOffline(false)
        end
    end
end

function GameScene:onEnterTransitionFinish_()
    dataCenter:startKeepOnline()
    self:showOnStateIdle_()
    self.buttonDismiss_:onButtonClicked(handler(self, self.onDismissClicked_))
    self.buttonQuitRomm_:onButtonClicked(handler(self, self.onQuitRoomClicked_))
    self.buttonConfig_:onButtonClicked(handler(self, self.onConfigClicked_))
    -- self.buttonChat_:onButtonClicked(handler(self, self.onChatClicked_))
    self.buttonInvite_:onButtonClicked(handler(self, self.onInviteClicked_))
    -- self.buttonSort_:onButtonClicked(handler(self, self.onSortClicked_))
    -- self.buttonToWechat_:onButtonClicked(handler(self, self.onToWechatClicked_))
    self.buttonVoice_:setView(self.buttonVoiceView_)
    self.buttonOK_:onButtonClicked(handler(self, self.onButtonOKClicked_))
    self.buttonMenu_:onButtonClicked(handler(self, self.onMenuClicked_))
    self.buttonWanFa_:onButtonClicked(handler(self, self.onWanFa_))
    self.btnMenu_:hide()
    self.buttonDingWei_:onButtonClicked(handler(self, self.onLocationClicked_))
    self.buttonRefresh_:onButtonClicked(handler(self, self.onRefreshClicked_))
    self.buttonHuaYu_:onButtonClicked(handler(self, self.onHuaYuClicked_))
    self.buttonZl_:onButtonClicked(handler(self, self.onZlClicked_))

    -- self.buttonHuaYu_:hide()
    -- self.buttonZl_:hide()

     -- self.buttonReconnect_:onButtonClicked(handler(self, self.onReconnectClicked_))
    -- self.buttonSort_:align(cc.p(1, 0), display.width, 30)
    -- self.buttonConfig_:hide()
    self.canSort_ = true

    -- app:createGrid(self)
    gameAudio.playMusic("sounds/niuniu/bgm.mp3", true)

    -- dataCenter:setAutoEnterRoom(false)
    self.tableController_:listeningAvatarClicked(handler(self, self.onAvatarClicked_))
    -- self:bindReturnKeypad_()
    -- self.buttonDingWei_:setVisible(CHANNEL_CONFIGS.DING_WEI)


end

function GameScene:onZlClicked_(event)
    selfData:setNowRoomID(dataCenter:getRoomID())
    self:enterQianScene()
end

function GameScene:onEnter()
    if DEBUG  > 0 then
        local GameSceneTest = require("app.games.shuangKou.scenes.GameSceneTest")
        GameSceneTest.test(self)
    end
end

function GameScene:onHuaYuClicked_(event)
    if self.yuYinView_ == nil or tolua.isnull(self.yuYinView_) then
    
        self.yuYinView_ = WenZiYuYin.new(self.isSendQuickChat_):addTo(self.layerWindows_)
    end
    self.yuYinView_:show()
    self.yuYinView_:tanChuang(100)
end

function GameScene:onWanFa_(event)
    local date = display.getRunningScene():getTable():getConfigData()
    display.getRunningScene():initWanFa(GAME_SHUANGKOU,date)
end

function GameScene:onMenuClicked_(event)
    local date = display.getRunningScene():getTable():getConfigData()
    if self.isPlaying_ then
        local height = self.btnMenu_:getContentSize().height
        self.buttonDismiss_:hide()
        self.buttonQuitRomm_:hide()
        self.buttonZl_:hide()
        self.buttonConfig_:setPositionY(height*0.3)
        self.buttonDingWei_:setPositionY(height*0.7)
        if date.totalSeat <= 2 then
            self.buttonDingWei_:hide()
            self.btnMenu_:setSpriteFrame(display.newSprite("res/images/game/btnBg1.png"):getSpriteFrame())
            self.btnMenu_:setContentSize(cc.size(180, 90))
            local height = self.btnMenu_:getContentSize().height
            self.buttonConfig_:setPositionY(height*0.5)
        end
    else
        if date.totalSeat <= 2 then
            self.buttonDingWei_:hide()
            if display.getRunningScene():getTable():getClubID() > 0 then
                self.btnMenu_:setContentSize(cc.size(180, 200))
            else
                self.btnMenu_:setContentSize(cc.size(180, 170))
                local height = self.btnMenu_:getContentSize().height
                self.buttonConfig_:setPositionY(height*0.7)
                self.buttonDismiss_:setPositionY(height*0.3)
                self.buttonQuitRomm_:setPositionY(height*0.3)
            end
        end
    end
    self.isMenuOpen_ = not self.isMenuOpen_
    self.btnMenu_:setVisible(self.isMenuOpen_)
end

function GameScene:onLocationClicked_(event)
    dataCenter:sendOverSocket(COMMANDS.SHUANGKOU_REQUEST_LOCATION)
end

function GameScene:onRefreshClicked_(event)
    dataCenter:setConnectGameSceneCallBack(nil)
    app:enterLoginScene()
end

function GameScene:getTable()
    return self.tableController_:getTable()
end

function GameScene:onToWechatClicked_(event)
    local params = {
        packageName = "com.tencent.mm",
        enterName = "wechat"
    }
    gailun.native.enterApp(params)
end

function GameScene:onQuitRoomClicked_(event)
    local msg = "亲，确定要退出房间么？"
    local function callback(bool)
        if bool then
            selfData:setNowRoomID(0)
            dataCenter:sendOverSocket(COMMANDS.SHUANGKOU_LEAVE_ROOM)
        end
    end
    app:confirm(msg, callback)
end


function GameScene:sendTuiChuCMD()
    dataCenter:sendOverSocket(COMMANDS.SHUANGKOU_LEAVE_ROOM)
end

function GameScene:sendJieSanCMD()
    dataCenter:sendOverSocket(COMMANDS.SHUANGKOU_OWNER_DISMISS)
end

function GameScene:onSortClicked_(event)
    if self.canSort_ then
        self.player_:sortCards()
        self.tableController_:resetPopUpPokers()
        self.canSort_ = false

        self:performWithDelay(function ()
        self.canSort_ = true
        end,1)
    end
end

function GameScene:onVoiceClicked_(event)
    app:createView("game.VoiceRecordView"):addTo(self.layerWindows_)
end



function GameScene:onButtonOKClicked_(event)
    self.buttonOK_:hide()
    TaskQueue.continue()
end

function GameScene:onReturnClicked_()
    if self:getHostPlayer():canExit() then
        if self.tableController_:getTable():isOwner(self:getHostPlayer():getUid()) or self:showOnStateIdle_() then
            self:onDismissClicked_()
        else
            self:onQuitRoomClicked_()
        end
    else
        app:showTips("游戏中不能退出房间！")
        self.isKeyClick_ = false
    end
end

function GameScene:onExitTransitionStart()
    dataCenter:pauseSocketMessage()
    gameAudio.stopMusic()
end

function GameScene:onExit()
    gailun.EventUtils.clear(self)
    transition.stopTarget(self)
    TaskQueue.clear()
end

function GameScene:onRoomInfo_(event)
    -- dump(event.da/ta)
    gameLocalData:setGameRecordID(event.data.config.recordID)
    dataCenter:setOwner(event.data.creator)
    self.tableController_:doRoomInfo(event.data)
    if event.data.status > 0 then
        self:onStatePlaying_()
    else
        self:showOnStateIdle_(event.data)
    end
    -- self:initBackGroud_(event.data.config)
end

function GameScene:onPlayAction_(event)
    self.tableController_:onPlayAction(event)
    if event.data.code ~= 0 then
        return
    end
end

function GameScene:showDissmissResult_(params)
    local isDissmiss = params.result == true
    local agrees = {}
    local disagrees = {}
    local function formatNickName_(list, result)
        if not list or #list < 1 then
            return
        end
        for i,v in ipairs(list) do
            local p = self.tableController_:getPlayerBySeatID(v)
            if p then
                table.insert(result, string.format("【%s】", p:getNickName()))
            end
        end
    end
    formatNickName_(params.yesSeatIDs, agrees)
    formatNickName_(params.noSeatIDs, disagrees)
    local tips = "经玩家%s同意，房间解散成功。"
    if isDissmiss then
        tips = string.format(tips, table.concat(agrees, ","))
    else
        tips = "玩家%s拒绝解散房间，房间解散失败。"
        tips = string.format(tips, table.concat(disagrees, ","))
    end
    app:alert(tips)
    self.tableController_:getTable():setDismiss(isDissmiss)
    if isDissmiss then
        if self.roundOverView_ and not tolua.isnull(self.roundOverView_) then
            self.roundOverView_:setIsGameOver(true)
        end
    end
end

function GameScene:onDismissInRequest_(event)
    if event.data.result ~= nil then
        self:showDissmissResult_(event.data)
        if self.disMissView_ then
            self.disMissView_:removeSelf()
            self.disMissView_ = nil
        end
        return
    end
    if self.disMissView_ == nil then
        self.disMissView_ = DismissRoomView.new():addTo(self.layerWindows_)
        self.disMissView_:tanChuang()
    end
    local names = {}
    local myIsAgree = false
    local myIsRefuse = false
    for i,v in ipairs(event.data.yesSeatIDs) do
        local player = self.tableController_:getPlayerBySeatID(v)
        if player:getUid() == selfData:getUid() then
            myIsAgree = true
        end
        table.insert(names, player:getNickName())
    end
    local noNames = {}
    for i,v in ipairs(event.data.noSeatIDs) do
        local player = self.tableController_:getPlayerBySeatID(v)
        if player:getUid() == selfData:getUid() then
            myIsRefuse = true
        end
        table.insert(noNames, player:getNickName())
    end

    self.disMissView_:setUserNames(names, noNames, myIsAgree, myIsRefuse)
    self.disMissView_:startTime(event.data.remainTime)
end

function GameScene:onChatClicked_(event)
    self.isOpenWindow_ = true
    app:createConcreteView("game.ChatView"):addTo(self.layerWindows_)
end

function GameScene:onInviteClicked_(event)
    local data = self.tableController_:getRoomConfig()
    data.fen = 1
    local playerTable = self.tableController_:getTable()
    local str = "%s,快来玩吧！"
    local roomId = playerTable:getTid()
    local playerCount = playerTable:getCurrPlayerCount()
    local msg = playerTable:getRoomRuleInfo()
    local queRenMsg = playerCount .. "缺"  .. (4 - playerCount)
    local title = "金华双扣 房间号【" .. roomId .. "】" .. queRenMsg
    local description = msg .. "速度来玩！"
    local ruleString = msg
    -- StaticConfig:get("shareURL") or ServerDefense.getBaseURL(),
    local function callback()
    end
    display.getRunningScene():shareWeiXin(title, description, 0,callback)
end

function GameScene:showOnStateIdle_(data)
    local pokerTable = self.tableController_:getTable()
    self:showInvite_()
    if pokerTable:isOwner(selfData:getUid()) and pokerTable:getIsAgent() ~= 1 then  -- 房主才显示此按钮
        self.buttonDismiss_:show()
        self.buttonQuitRomm_:hide()
    elseif data and data.clubID > 0 then
        self.buttonQuitRomm_:show()
        self.buttonDismiss_:hide()
    else
        self.buttonQuitRomm_:show()
        self.buttonDismiss_:hide()
    end
    self.buttonOK_:hide()
    self:showVoiceChat_()
end

function  GameScene:isShowSortButton(bool)
    self.buttonSort_:setVisible(bool)
    self.isShowSortButton_ = bool
end

function GameScene:showVoiceChat_()
    if not CHANNEL_CONFIGS.CHAT then
        self.buttonVoice_:hide()
        return
    end
    self.buttonVoice_:show()
end

function GameScene:showChat_()
    if not CHANNEL_CONFIGS.CHAT then
        self.buttonChat_:hide()
        return
    end
    -- self.buttonChat_:show()
end

function GameScene:showInvite_()
    if not CHANNEL_CONFIGS.SHARE then
        self.buttonInvite_:hide()
        return
    end
    self.buttonInvite_:show()
end

function GameScene:onNotifyLocation_(event)
    if not event.data then
        return
    end
    self:showLocationTips_(event.data, true)
end

function GameScene:onRequestLocation_(event)
    if not event.data then
        return
    end
    self:showLocationTips_(event.data, false)
end

function GameScene:showLocationTips_(data, iskaiju)
    if data.code == 0 then
        local params = {}
        for i,v in ipairs(self.tableController_.seats_) do
            local obj = {}
            obj.ip = v:getIP()
            obj.uid = v:getUid()
            obj.name = v:getNickName()
            obj.avatar = v:getAvatarName()
            table.insert(params, obj)
        end
        if self.dingWeiView_ and self.dingWeiView_.isOpen then
            self.dingWeiView_:removeSelf()
            self.dingWeiView_ = nil
        end
        if 4 == self:getTable():getMaxPlayer() then
            self.dingWeiView_ = SiRenDingWei.new(params, data.distances,true,GAME_SHUANGKOU):addTo(self.layerWindows_)
        elseif 3 == self:getTable():getMaxPlayer() then
            self.dingWeiView_ = SanRenDingWei.new(params, data.distances,true,GAME_SHUANGKOU):addTo(self.layerWindows_)
        end
        
        if self.dingWeiView_ ~= nil then
            self.dingWeiView_:tanChuang(150)
        end
    end
end

function GameScene:onStateIdle_(event)
    self.isPlaying_ = false
    self:showOnStateIdle_()
end

function GameScene:showOnStatePlaying_()
    self.buttonInvite_:hide()
    self.buttonDismiss_:hide()
    self.buttonQuitRomm_:hide()
    self.buttonOK_:hide()
    self.buttonConfig_:show()
    self:showChat_()
    self:showVoiceChat_()
end

function GameScene:getPlayerBySeatID(seatID)
    return self.tableController_:getPlayerBySeatID(seatID)
end

function GameScene:finishRound()
    self.tableController_:finishRound()
end

function GameScene:onStatePlaying_(event)
    self.isPlaying_ = true
    self:showOnStatePlaying_()
end

function GameScene:onTableStateChanged_(event)
    local state = event.to
    printInfo("GameScene:onTableStateChanged_(event)" .. state)
    if state == "playing" then
        self:onStatePlaying_(event)
    elseif state == "idle" then
        self:onStateIdle_(event)
    elseif state == "checkout" then
        -- self:onStateCheckout_(event)
    else
        printInfo("Unknown Table State Of: " .. state)
    end
end

function GameScene:onDismissClicked_(event)
    local msg = ""
    if CHANNEL_CONFIGS.DIAMOND then
        msg = "解散房间不扣钻石，是否确定解散？"
    else
        msg = "即将解散房间，是否确定解散？"
    end

    local function callback(bool)
        if bool then
            selfData:setNowRoomID(0)
            dataCenter:sendOverSocket(COMMANDS.SHUANGKOU_OWNER_DISMISS)
        end
    end
    app:confirm(msg, callback)
end

function GameScene:onAvatarClicked_(params)
    if params.isInvite then
        self:onInviteClicked_()
        return
    end

    self.layerWindows_:removeAllChildren()
    self.isOpenWindow_ = true
    local view = app:createView("PlayerInfoView", params):addTo(self.layerWindows_)
    -- view:getPlayerInfoContent():pos(params.x, params.y)
    view:tanChuang(100)
    -- view:showKick()
    view:showInGameScenes()
end

function GameScene:onLeaveRoom_(event)
    if not event.data then
        return
    end
    local uid = event.data.uid
    if uid ~= self:getHostPlayer():getUid() then
        return
    end
    if 1 == event.data.code then  -- 这是房间解散
        dataCenter:setAutoEnterRoom(false)
        dataCenter:setRoomID(0)
        --app:alert("房间已解散，谢谢！", function ()
        app:enterHallScene()
        --end)
        return
    end
    if 3 == event.data.code then  -- 这是房间结束解散
        dataCenter:setAutoEnterRoom(false)
        dataCenter:setRoomID(0)
        return
    end
    if 2 == event.data.code then  -- 被踢出
        dataCenter:setAutoEnterRoom(false)
        dataCenter:setRoomID(0)
        app:alert("您已被房主踢出此房间，请选择其它房间进行游戏！", function ()
            app:enterHallScene()
        end)
        return
    end
    if self.tableController_:getTable():getConfigData().clubID > 0  then
        app:showLoading("正在返回俱乐部")
        local params = {}
        params.clubID = self.tableController_:getTable():getConfigData().clubID
        params.floor = gameData:getClubFloor()
        httpMessage.requestClubHttp(params, httpMessage.GET_CLUB_INFO)
    else
        app:enterHallScene()
    end
end

function GameScene:doReady_(data)
    if not data then
        return
    end
    if 0 ~= data.code then
        return
    end
    if data.seatID == self:getHostPlayer():getSeatID() then
        self.layerWindows_:removeAllChildren()
        self.layerTop_:setTouchEnabled(false) 
    end
    local isReady = data.isPrepare
    self.tableController_:onPlayerReady(data.seatID, isReady)
end

function GameScene:onReady_(event)
    TaskQueue.add(handler(self, self.doReady_), 0, 0, event.data)
end

function GameScene:clearRoundResult_()
    if not self.roundResultView_ then
        return
    end
    if tolua.isnull(self.roundResultView_) then
        self.roundResultView_ = nil
        return
    end
    self.roundResultView_:removeFromParent()
    self.roundResultView_ = nil
end

function GameScene:doRoundOver_(data)
    dump(data,"GameScene:doRoundOver_")
    self.layerTop_:setTouchEnabled(false)
    local buttonSeatID = self:getTable():getDealerSeatID()
    data.hostSeatID = self:getHostPlayer():getSeatID()
    local rankCount = 0
    local isZhuangShangYou = false
    for _,v in pairs(checktable(data.seats)) do
        local p = self.tableController_:getPlayerBySeatID(v.seatID)
        if buttonSeatID == 0 then

        else
            v.isZhuang = buttonSeatID == v.seatID
        end
        if v.isZhuang and v.rank == 1 then
            isZhuangShangYou = true
        end
        v.nickName = p:getNickName()
        v.avatar = p:getAvatarName()
        v.zhuangID = buttonSeatID
        if self:getHostPlayer():getSeatID() ~= v.seatID then
            v.isHost = false
        else
            v.isHost = true
        end
        v.hostUid = self:getHostPlayer():getUid()
        v.uid = p:getPlayer():getUid()
    end
    self.tableController_:doRoundOver(data)
    local isGameOver = not data.hasNextRound
    self:showOverBtn_(isGameOver)
    self.roundOverView_ = app:createConcreteView("game.RoundOverView", data, isGameOver):addTo(self.layerWindows_)
end

-- 一局结束
function GameScene:onRoundOver_(event)
    if event.data.finishType == 3 then  -- 提前结束
        app:showTips("大局已定，提前结束！")
    end
    dump(event.data,"onRoundOver_onRoundOver_")
    --self:doRoundReview_(event.data)
    TaskQueue.add(handler(self, self.doRoundReview_), 0, -1, clone(event.data))
    TaskQueue.add(handler(self, self.doRoundOver_), 0, -1, event.data)
end

function GameScene:doRoundReview_(data)
    dump(data,"GameScene:doRoundReview_")
    self.tableController_:stopTimer()
    local pokerTable = self.tableController_:getTable()
    local rankCount = 0
    for _,v in pairs(checktable(data.seats)) do
        local p = self.tableController_:getPlayerBySeatID(v.seatID)
        p:setScore(v.totalScore)
        p:showWinFlg(v.score)
        v.winType = 0
        v.posX, v.posY = p:getPlayerPosition()
        if v.score > 0 then
            v.winType = 1
        elseif v.score < 0 then
            v.winType = -1
        end
        if p:getUid() ~= self:getHostPlayer():getUid() then
            p:showRoundOverPoker(v.handCards)
        end
        if data.finishType ~= 2 then
            if pokerTable:getConfigData().cardCount == 15 then
                if v.cards == 15 then
                    p:guanLong()
                end
            elseif pokerTable:getConfigData().cardCount == 16 then
                if v.cards == 16 then
                    p:guanLong()
                end
            end
        end
        p:warning(-2)
    end
    print("XXXXXXXXXXXXXXXXXX22222222222")
    -- pokerTable:goldFly(data.seats,TaskQueue.continue)
    -- self.buttonOK_:show()
    self:performWithDelay(function()
        TaskQueue.continue()
        -- self:onButtonOKClicked_()
        self:showJieSuanSelectView(true)
    end, 0.5)
end

function GameScene:searchSeatIDByMaxKey_(data, key)
    local list = {}
    local max = 0
    for _,v in pairs(checktable(data)) do
        max = math.max(v[key], max)
    end
    for _,v in pairs(checktable(data)) do
        if max == v[key] then
            table.insert(list, v.seatID)
        end
    end
    return list
end

-- 整局游戏结束
function GameScene:onGameOver_(event)
    selfData:setNowRoomID(0)
    print("---------------onGameOver_------------------")
    TaskQueue.add(handler(self, self.doGameOver_), 0, 0, event.data)
end

function GameScene:doGameOver_(data)
    print("---------------doGameOver_------------------")
    -- local daYingJiaSeats = self:searchSeatIDByMaxKey_(data.seats, "totalScore")
    -- local zhaDanSeats = self:searchSeatIDByMaxKey_(data.seats, "bombCount")
    -- local guanSeats = self:searchSeatIDByMaxKey_(data.seats, "guanCount")
    self.layerTop_:setTouchEnabled(true)
    for _,v in pairs(checktable(data.seats)) do
        local p = self.tableController_:getPlayerBySeatID(v.seatID)
        v.uid = p:getUid()
        if v.uid == selfData:getUid() then
            v.isHost = true
        else
            v.isHost = false
        end
        v.nickName = p:getNickName()
        v.avatar = p:getAvatarName()
        v.isFangZhu = (v.uid == self.tableController_:getTable():getOwner())
        -- v.isDaYingJia = (v.totalScore > 0) and table.indexof(daYingJiaSeats, v.seatID) ~= false
        -- v.isGuanKing = (v.guanCount > 0) and table.indexof(guanSeats, v.seatID) ~= false
        -- v.isBombKing = (v.bombCount > 0) and table.indexof(zhaDanSeats, v.seatID) ~= false
    end
    self.gameOverData_ = data
    self.gameOverData_.ruleString = self.tableController_:makeRuleString(' ')
    self.gameOverData_.finishTime = os.date("%Y-%m-%d %H:%M:%S")
    self:showGameOver_()
end

function GameScene:showGameOver_()
    if not self.gameOverData_ then
        return
    end
    local data = self.gameOverData_
    self.tableController_:doGameOver(data)
    self.isOpenWindow_ = true
    local gameOverView = GameOverView.new(data)
    self.layerWindows_:addChild(gameOverView)
    self.gameOverData_ = nil
end

function GameScene:startEnterHall_()
    app:enterHallScene()
end
function GameScene:onFeedbackClicked_(event)
    print("TODO: onFeedbackClicked_")
end

function GameScene:onEnterRoom_(event)
    if event.data.code ~= 0 then
        dataCenter:setRoomID(0)
        app:enterHallScene()
        return
    end
    local roomID = event.data.roomID
    dataCenter:setRoomID(roomID)
    self.tableController_:getTable():setTid(roomID)
end

function GameScene:getHostPlayer()
    return self.tableController_:getHostPlayer()
end

function GameScene:getFriendPlayer()
    return self.tableController_:getFriendPlayer()
end

function GameScene:onPlayerEnterRoom_(event)
    printInfo("GameScene:onEnterRoom_(event)")
    if not event.data then
        printInfo("if not event.data then")
        return
    end
    -- if DEBUG  > 0 then
    --     local temp = json.decode(event.data.data)
    --     temp.nickName = temp.uid..""
    --     dump(temp,"temp")
    --     event.data.data = json.encode(temp)
    --     dump(event.data,"event.dataevent.data")
    -- end
    self.tableController_:doPlayerSitDown(event.data)
end

function GameScene:isShowYaoqingButton()
    if self.tableController_:getCurrPlayerCount() < self.tableController_:getMaxPlayer() then
        self:showInvite_()
    else
        self.buttonInvite_:hide()
    end
end

-- 此功能暂缓开发
function GameScene:onWaitBigBlindsClicked_(event)
    local selected = event.target:isButtonSelected()
end

function GameScene:onConfigClicked_(event)
    self.isOpenWindow_ = true
    -- app:createView("game.GameSettingView"):addTo(self.layerWindows_)
    self:showGameSheZhi(true)
end

function GameScene:closeWindow()
    self:performWithDelay(function()
        self.isOpenWindow_ = false
        end, 0.2)
end

function GameScene:sendDismissRoomCMD(isAgree)
    dataCenter:sendOverSocket(COMMANDS.SHUANGKOU_REQUEST_DISMISS, {agree = isAgree})
end

function GameScene:onBgClicked_(event)
    printf("{%.3f, %.3f, %d, %d}", event.x / display.width, event.y / display.height, event.x, event.y)
    print("GameScene:onBgClicked_(event)")
    self.tableController_:resetPopUpPokers()
    self.btnMenu_:hide()
    self.isMenuOpen_ = false
    if self.yuYinView_ then
        if tolua.isnull(self.yuYinView_) then return end
        self.yuYinView_:hide()
    end
end

function GameScene:onExitClicked_(event)
    if not self:getHostPlayer():canExit() then
        app:alert("您正在游戏中，请先站起后再退出～")
        return
    end
    dataCenter:sendOverSocket(COMMANDS.QUIT_TABLE)
end

function GameScene:searchEmptySeatID()
    return self.tableController_:searchEmptySeatID()
end

function GameScene:isMyTable()
    return self.tableController_:isMyTable()
end

function GameScene:showJieSuanSelectView(visible)
    if self.jieSuanSelect_ == nil then
        self.jieSuanSelect_ = SelectedView.new(handler(self, self.jieSuanHandler_)):addTo(self.layerTop_,99):pos(display.cx, display.bottom + 50)
    end
    self.jieSuanSelect_:setDefaults(1)
    self.jieSuanSelect_:setVisible(visible)
end

function GameScene:jieSuanHandler_(index)
    if index == 1 then
        if self.roundOverView_ then
            self.roundOverView_:show()
        elseif self.gameOverView_ then
            self.gameOverView_:show()
        else
            TaskQueue.continue()
        end
    else
        if self.roundOverView_ then
            self.roundOverView_:hide()
        elseif self.gameOverView_ then
            self.gameOverView_:hide()
        end
    end
end

function GameScene:nextRound()
    self:showJieSuanSelectView(false)
    if self.roundOverView_ then
        self.roundOverView_:removeSelf()
        self.roundOverView_ = nil
    end
    self:finishRound()
    self.hasRoundOver_ = false
    self.tableController_:doRoundOver()
    self.tableController_:clearAfterRoundOver_()
    local pokerTable = self.tableController_:getTable()
    dataCenter:sendOverSocket(COMMANDS.SHUANGKOU_READY)
end

return GameScene
