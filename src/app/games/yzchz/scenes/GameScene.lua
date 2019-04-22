local BaseAlgorithm = require("app.games.yzchz.utils.BaseAlgorithm")
local Nodes = import("..data.uidata.GameSceneNodes")
local TaskQueue = require("app.controllers.TaskQueue")
local BaseScene = import("app.scenes.BaseScene")
local SanRenDingWei = import("app.views.SanRenDingWei")
local SiRenDingWei = import("app.views.SiRenDingWei")
local DismissRoomView = import("app.views.game.DismissRoomView")
local WenZiYuYin = import("app.views.WenZiYuYin")
local PlayerInfoView = import("app.views.PlayerInfoView")

local SelectedView = import("app.views.SelectedView")

local GameScene = class("GameScene", BaseScene)

-- 算法测试用例
-- require ("app.games.yzchz.utils.PaoHuZiTest")

local BIRD_SPACE_SECONDS = 1

function GameScene:ctor()
    dataCenter:tryConnectSocket()
    GameScene.super.ctor(self)
    gailun.uihelper.render(self, Nodes.layers)
    self.name = "YZCHZ"
    self.gameOverData_ = nil
    self.playerIPList_ = {}
    local node = display.newNode():addTo(self)
    TaskQueue.clear()
    TaskQueue.init(node)
    local path1 = gailun.native.getSDCardPath() .. "/" .. "1.aac"
    local path2 = gailun.native.getSDCardPath() .. "/" .. "2.aac"
    local path3 = gailun.native.getSDCardPath() .. "/" .. "3.aac"
    os.remove(path1)
    os.remove(path2)
    os.remove(path3)
    self.isSendQuickChat_ = false
    self.hasRoundOver_ = false
    self.isMenuOpen_ = false
    self.isPlaying_ = false
    self:initRoundOverBtn_() 

end

function GameScene:initRoundOverBtn_()  --jxfj

    self.againBtn_ = ccui.Button:create("res/images/paohuzi/roundOver/playAgain.png", "res/images/paohuzi/roundOver/playAgain.png")
    self.againBtn_:setAnchorPoint(0.5,0.5)
    self.againBtn_:setSwallowTouches(false)
    self.againBtn_:setPosition(display.right - 250, display.bottom + 50)    
    self.layerTop_:addChild(self.againBtn_)
    self.againBtn_:setName("again")
    self.againBtn_:addTouchEventListener(handler(self, self.onButtonClick_))

    self.resultBtn_ = ccui.Button:create("res/images/paohuzi/roundOver/lookRezult.png", "res/images/paohuzi/roundOver/lookRezult.png")
    self.resultBtn_:setAnchorPoint(0.5,0.5)
    self.resultBtn_:setSwallowTouches(false)  
    self.resultBtn_:setPosition(display.right - 250, display.bottom + 50)  
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

function GameScene:onEnterTransitionFinish()
    self:bindSocketListeners()
    self:bindEvent()
    self:checkSocketConnected_()
    self:schedule(handler(self, self.checkSocketConnected_), 2)
    display.addSpriteFrames("textures/game_face.plist", "textures/game_face.png")
    display.addSpriteFrames("textures/game_anims.plist", "textures/game_anims.png")

    self:onBgLoaded_()
    self:onAllLoaded_()
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
    -- display.newSprite(texture):addTo(self.layerBG_):pos(display.cx, display.cy)
    -- self.spriteTable_ = display.newSprite(texture):addTo(self.layerTable_):pos(display.cx, display.cy)
end

function GameScene:onAllLoaded_()
    self.tableController_ = app:createConcreteController("TableController"):addTo(self.layerTable_)
    self.tableController_:setScene(self)
    gailun.uihelper.render(self, Nodes.menuLayerTree, self.layerMenu_)
    self:onEnter_()
end

function GameScene:onEnter_()
    gailun.uihelper.setTouchHandler(self.layerBG_, handler(self, self.onBgClicked_))
    gailun.uihelper.setTouchHandler(self.bgSprite_, handler(self, self.onBgClicked_))

    local handlers = dataCenter:s2cCommandToNames {
        {COMMANDS.YZCHZ_ROUND_OVER, handler(self, self.onRoundOver_)},
        {COMMANDS.YZCHZ_GAME_OVER, handler(self, self.onGameOver_)},
        {COMMANDS.YZCHZ_READY, handler(self, self.onReady_)},
        {COMMANDS.YZCHZ_LEAVE_ROOM, handler(self, self.onLeaveRoom_)},
        {COMMANDS.YZCHZ_PLAYER_ENTER_ROOM, handler(self, self.onPlayerEnterRoom_)},
        {COMMANDS.YZCHZ_REQUEST_DISMISS, handler(self, self.onDismissInRequest_)},
        {COMMANDS.YZCHZ_ROOM_INFO, handler(self, self.onRoomInfo_)},
        {COMMANDS.YZCHZ_NOTIFY_LOCATION, handler(self, self.onNotifyLocation_)},
        {COMMANDS.YZCHZ_REQUEST_LOCATION, handler(self, self.onRequestLocation_)},
    }
    gailun.EventUtils.create(self, dataCenter, self, handlers)

    local cls = self.tableController_:getTable().class
    local handlers = {
        {cls.CHANGE_STATE_EVENT, handler(self, self.onTableStateChanged_)},
    }
    gailun.EventUtils.create(self, self.tableController_:getTable(), self, handlers)

    self:onEnterTransitionFinish_()
    dataCenter:setDisconnectedGameSceneCallBack(handler(self, self.onSocketClosed_))
    dataCenter:setConnectGameSceneCallBack(handler(self, self.onSocketConnected_))
end

function GameScene:getHostPlayer()
    return self.tableController_:getHostPlayer()
end

function GameScene:setHostPlayerPaperCard(paperCardList)
    self.tableController_:setHostPlayerPaperCard(paperCardList)
end

function GameScene:checkHu(card, isHide)
    self.tableController_:checkHu(card, isHide)
end

function GameScene:onSocketClosed_()
    -- self.isDisconnected_ = true
    -- local seatID = dataCenter:getHostPlayer():getSeatID()
    -- if self.tableController_ == nil then return end
    -- self:setHostPlayerState(true)
    -- for k,v in pairs(self.tableController_:getSeats()) do
    --     if seatID == v:getSeatID() then
    --         v:setOffline(true)
    --     else
    --         v:setOffline(false)
    --     end
    -- end
end

function GameScene:onSocketConnected_()
    self:setHostPlayerState(false)
    if self.isDisconnected_ then
        self.isDisconnected_ = false
        -- self:onReconnectClicked_()
        return true
    else
        return false
    end
end

function GameScene:setHostPlayerState(offline)
    if self.tableController_ then
        self.tableController_:setHostPlayerState(offline)
    end
end

function GameScene:onConfigCard_(event)
     dump(event.data)
end

function GameScene:onReconnectClicked_(event)
    dataCenter:setDisconnectedGameSceneCallBack(nil)
    dataCenter:setConnectGameSceneCallBack(nil)
    app:enterLoginScene()
end

function GameScene:onChangeServer_(event)
    local host = event.data.host
    local port = event.data.port
    dataCenter:setHostAndPort(host, port)
    dataCenter:setChangeServer(true)
    dataCenter:setRoomID(0)
end

function GameScene:onEnterTransitionFinish_()
    dataCenter:startKeepOnline()
    self:showOnStateIdle_()
  
    
   
    self.buttonReconnect_:onButtonClicked(handler(self, self.onReconnectClicked_))
    self.buttonStart_:onButtonClicked(handler(self, self.onStartClicked_))
    self.buttonStart_:hide()
    self.buttonInvite_:onButtonClicked(handler(self, self.onInviteClicked_))
    self.buttonVoice_:setView(self.buttonVoiceView_)
    self.buttonHuaYu_:onButtonClicked(handler(self, self.onHuaYuClicked_))
    self.buttonTiPai_:onButtonClicked(handler(self, self.onTiPaiClicked_))
   
    -- self.buttonToWechat_:onButtonClicked(handler(self, self.onToWechatClicked_))
    -- self.buttonVoice_:hide()
    self.buttonOK_:onButtonClicked(handler(self, self.onButtonOKClicked_))
    self.canSort_ = true
    self.buttonCardConfig_:hide()
    if DEBUG > 0 then
        local GameSceneTest = require("app.games.yzchz.scenes.GameSceneTest")
        GameSceneTest.test(self)
    end
    -- app:createGrid(self)
    -- gameAudio.playMusic("sounds/music2.mp3")
    gameAudio.stopMusic()
    dataCenter:resumeSocketMessage()
    dataCenter:setAutoEnterRoom(false)
    self.tableController_:listeningAvatarClicked(handler(self, self.onAvatarClicked_))
    self:bindReturnKeypad_()
end

function GameScene:onWanFa_(event)
    local date = display.getRunningScene():getTable():getConfigData()
    display.getRunningScene():initWanFa(GAME_YZCHZ,date)
end

function GameScene:onStartClicked_()
    self.buttonStart_:hide()
    dataCenter:sendOverSocket(COMMANDS.YZCHZ_READY)
end

function GameScene:onDingWeiClicked_(event)
    dataCenter:sendOverSocket(COMMANDS.YZCHZ_REQUEST_LOCATION)
end

function GameScene:onHuaYuClicked_(event)
    if self.yuYinView_ == nil then
        self.yuYinView_ = WenZiYuYin.new(self.isSendQuickChat_):addTo(self.layerWindows_)
    end
    self.yuYinView_:show()
    self.yuYinView_:tanChuang(100)
end

function GameScene:onVoiceClicked_(event)
    app:createView("game.VoiceRecordView"):addTo(self.layerWindows_)
end

function GameScene:onSettingClicked_(event)
    app:createView("hall.SettingView"):addTo(self.layerWindows_)
end

function GameScene:onToWechatClicked_(event)
    local params = {
        packageName = "com.tencent.mm",
        enterName = "wechat"
    }
    gailun.native.enterApp(params)
end

function GameScene:onButtonOKClicked_(event)
    self.buttonOK_:hide()
    self.tableController_:clearAfterRoundOver_()
    TaskQueue.continue()

    local pokerTable = self.tableController_:getTable()
    pokerTable:clearRoundOverShowPai()
end

function GameScene:bindReturnKeypad_()
    if "android" ~= device.platform then
        return
    end
    self:setKeypadEnabled(true)
    self:addNodeEventListener(cc.KEYPAD_EVENT, function (event)
        if event.key == "back" then
            self:onReturnClicked_()
        end
    end)
end

function GameScene:onReturnClicked_()
    -- 这个方法不存在  建一个  防止报错
end

function GameScene:onExitTransitionStart()
    dataCenter:pauseSocketMessage()
    gameAudio.stopMusic()
    TaskQueue.clear()

    dataCenter:setDisconnectedGameSceneCallBack(nil)
    dataCenter:setConnectGameSceneCallBack(nil)
end

function GameScene:onExit()
    gailun.EventUtils.clear(self)
    transition.stopTarget(self)
    TaskQueue.clear()
end

function GameScene:onRoomInfo_(event)
    gameLocalData:setGameRecordID(event.data.config.recordID)
    dataCenter:setOwner(event.data.creator)
    self.tableController_:doRoomInfo(event.data)
    local juShu = event.data.wanChengJuShu or 0
    if event.data.status > 0 or (juShu > 0 and juShu < dataCenter:getPokerTable():getTotalRound()) then
        self:onStatePlaying_()
    else
        self:showOnStateIdle_()
        self.tableController_:getProgreesView():showOnStateIdle_()
    end
    if self.tableController_:getMaxPlayer() == 4 then
        self:showPlayer4View()
    end
    local texture = cc.Director:getInstance():getTextureCache():addImage("res/images/yzchz/logo"..  event.data.config.ruleType .. ".png")
    self.gameNameLogn_:setTexture(texture)
end

function GameScene:showPlayer4View()
    self.buttonVoice_:setPositionY(display.bottom + 120)
    self.buttonHuaYu_:setPositionY(display.bottom + 190)
    self.buttonReconnect_:setPosition(display.right - 210,display.height-40)
    self.tableController_:showPalyer4View()
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
    local tips = "经玩家\n%s\n同意，房间解散成功。"
    if isDissmiss then
        tips = string.format(tips, table.concat(agrees, "\n"))
    else
        tips = "玩家\n%s\n拒绝解散房间，房间解散失败。"
        tips = string.format(tips, table.concat(disagrees, "\n"))
    end
    app:alert(tips)
    self:getTable():setDismiss(isDissmiss)
    if isDissmiss then
        if self.roundOverView_ and not tolua.isnull(self.roundOverView_) then
            self.roundOverView_:setIsGameOver(true)
        else
            TaskQueue.continue()
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
        self.disMissView_ = DismissRoomView.new():addTo(self.layerTop_, 100)
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
        if player:isHost() then
            myIsRefuse = true
        end
        table.insert(noNames, player:getNickName())
    end
    self.disMissView_:setUserNames(names, noNames, myIsAgree, myIsRefuse)
    self.disMissView_:startTime(event.data.remainTime)
end

function GameScene:onChatClicked_(event)
    app:createView("game.ChatView"):addTo(self.layerWindows_)
end

function GameScene:onInviteClicked_(event)
    local data = self.tableController_:getRoomConfig() or {}
    data.fen = 1
    local str = "%s,快来玩吧！"
    local roomId = self:getTable():getTid()
    local playerCount = self:getTable():getCurrPlayerCount()
    local round = data.totalRound or 8
    local totPlayer = self.tableController_:getMaxPlayer() 
    local queRenMsg = playerCount .. "缺" .. (totPlayer-playerCount)
    local title = "永州扯胡子 房间号【" .. roomId .. "】" .. queRenMsg
    local descriptionString = self.tableController_:makeShareRuleString(",")
    local description = round .."局," .. (descriptionString or "") .. "速度来玩！"
    local function callback()
    end
    display.getRunningScene():shareWeiXin(title, description, 0,callback)
end

function GameScene:showOnStateIdle_()
    self:showInvite_()
    -- self.tableController_:getProgreesView():showOnStateIdle_()
    self.buttonTiPai_:hide()
    self.buttonHuaYu_:hide()
    self.buttonVoice_:hide()
    self.buttonOK_:hide()
    -- self:showVoiceChat_()
end

function  GameScene:isShowSortButton(bool)
    self.isShowSortButton_ = bool
end

function GameScene:showVoiceChat_()
    if not CHANNEL_CONFIGS.CHAT then
        self.buttonVoice_:hide()
        return
    end
    self.buttonVoice_:show()
end

function GameScene:showInvite_()
    if not CHANNEL_CONFIGS.SHARE then
        self.buttonInvite_:hide()
        -- self.buttonToWechat_:hide()
        return
    end
    self.buttonInvite_:show()
end

function GameScene:showIPTips_()
    local params = {}
    for i=1,3 do
        local p = self.tableController_:getPlayerBySeatID(i)
        table.insert(params, p:getShowParams() or {})
    end
    local list = {}
    local hostIP = dataCenter:getHostPlayer():getIP()
    for k,v in pairs(params) do
        if v.IP and string.len(v.IP) > 0 and v.IP ~= hostIP and string.len(hostIP) > 0 then
            if not list[v.IP] then
                list[v.IP] = {string.format("%s", v.nickName)}
            else
                table.insert(list[v.IP], string.format("%s", v.nickName))
            end
        end
    end
    local showList = {}
    for _,v in pairs(list) do
        if #v > 1 then
            table.insert(showList, string.format("玩家:%s为同一IP地址", table.concat(v, ',')))
        end
    end
    if table.nums(showList) > 0 then
        self:performWithDelay(function ()
            self:clearLayerWindows_()
            app:createView("game.IPTipsView", showList):addTo(self.layerWindows_)
        end, 1)
    end
end

function GameScene:onNotifyLocation_(event)
    self:showLocationTips_(event.data, true)
end

function GameScene:onRequestLocation_(event)
    self:showLocationTips_(event.data, false)
end

function GameScene:showLocationTips_(data,iskaiju)
    print("onNotifyLocation_")
    if not data then
        return
    end 
    if data.code == 0 then
        local params = {}
        for i,v in ipairs(self.tableController_.seats_) do
            local obj = {}
            obj.ip = v:getIP()
            obj.uid = v:getUid()
            obj.name = v:getNickName()
            obj.avatar = v:getAvatar()
            table.insert(params, obj)
        end
        local date = display.getRunningScene():getTable():getConfigData()
        if self.dingWeiView_ and self.dingWeiView_.isOpen then
            self.dingWeiView_:removeSelf()
            self.dingWeiView_ = nil
        end
        if date.rules.totalSeat == 2 then
            self.buttonStart_:show()
        elseif date.rules.totalSeat == 3 then
            self.dingWeiView_ = SanRenDingWei.new(params,data.distances,iskaiju,GAME_YZCHZ):addTo(self.layerWindows_)
            self.dingWeiView_:tanChuang(150)
        elseif date.rules.totalSeat == 4 then
            self.dingWeiView_ = SiRenDingWei.new(params,data.distances,iskaiju,GAME_YZCHZ):addTo(self.layerWindows_)
            self.dingWeiView_:tanChuang(150)
        end 
    end
end

function GameScene:onStateIdle_(event)
    self.isPlaying_ = false
    self:showOnStateIdle_()
end

function GameScene:showOnStatePlaying_()
    self.tableController_:getProgreesView():showOnStatePlaying_()
    self.buttonInvite_:hide()
    self.buttonTiPai_:show()
    self.buttonOK_:hide()
    self.buttonHuaYu_:show()
    self.buttonVoice_:show()
    -- self:showVoiceChat_()
end

function GameScene:onStatePlaying_(event)
    self.isPlaying_ = true
    self:showOnStatePlaying_()
end

function GameScene:showOnStatePlaying()
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
    else
        printInfo("Unknown Table State Of: " .. state)
    end
end



function GameScene:onAvatarClicked_(params)
    if params.isInvite then
        self:onInviteClicked_()
        return
    end

    self:clearLayerWindows_()
    local view = app:createView("PlayerInfoView", params):addTo(self.layerWindows_)
    view:tanChuang(100)
    view:showInGameScenes()
end

function GameScene:onLeaveRoom_(event)
    if not event.data then
        return
    end
    local uid = event.data.uid
    if uid ~= selfData:getUid() then
        self.tableController_:doLeaveRoom(uid)
        self:closeDingWeiView()
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
    
    dataCenter:setRoomID(0)
    if self:getTable():getClubID() > 0 then
        local params = {}
        params.clubID = self:getTable():getClubID()
        params.floor = gameData:getClubFloor()
        httpMessage.requestClubHttp(params, httpMessage.GET_CLUB_INFO)
        return 
    end
    app:enterHallScene()
end

function GameScene:doReady_(data)
    if not data then
        return
    end

    if data.seatID == self.tableController_:getHostSeatID() then
        self:clearLayerWindows_()
    end
    local isReady = data.isPrepare
    self.tableController_:onPlayerReady(data.seatID, isReady)
end

function GameScene:onReady_(event)
    self.tableController_:clearAllCard()
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
    self:showJieSuanSelectView(true)
    local buttonSeatID = self.tableController_:getDealerSeatID()
    data.hostSeatID =  self.tableController_:getHostSeatID()
    if data.winInfo.winner then
        local winplayer = self.tableController_:getPlayerBySeatID(data.winInfo.winner)
        data.winType = winplayer:getIndex()
    end
    for _,v in pairs(checktable(data.seats)) do
        local p = self.tableController_:getPlayerBySeatID(v.seatID)
        if buttonSeatID == 0 then
        else
            v.isZhuang = buttonSeatID == v.seatID
        end
        v.nickName = p:getNickName()
        v.avatar = p:getAvatar()
        v.zhuangID = buttonSeatID
        v.isWinner = v.seatID == data.winInfo.winner
        if self.tableController_:getHostSeatID() ~= v.seatID then
            v.isHost = false
        else
            v.isHost = true
        end
        -- v.hostUid = dataCenter:getHostPlayer():getUid()
        v.uid = p:getPlayer():getUid()
    end
    local isGameOver = not data.hasNextRound
    self:showOverBtn_(isGameOver)
    data.tableController_ = self.tableController_
    self.roundOverView_ = app:createConcreteView("game.CDPHZRoundOver", data, isGameOver):addTo(self.layerWindows_)
    self.roundOverView_:tanChuang(150)
end

-- 一局结束
function GameScene:onRoundOver_(event)
    self.hasRoundOver_ = true
    TaskQueue.add(handler(self, self.doRoundReview_), 0, 0, clone(event.data))
    if event.data.finishType ~= 1 then
        if event.data.isHuangZhuang == 1 then
            TaskQueue.add(handler(self, self.doRoundOver_), 3, -1, event.data)
        else
            TaskQueue.add(handler(self, self.doRoundOver_), 5, -1, event.data)
        end
            
    end
    self.tableController_:clearAllCard()
end

function GameScene:doRoundReview_(data)
    self.tableController_:stopTimer()
    self.tableController_:hideActionBar()
   
    local pokerTable = self.tableController_:getTable()
    for _,v in pairs(checktable(data.seats)) do
        local p = self.tableController_:getPlayerBySeatID(v.seatID)
        p:doRoundOver(v)
    end
    if data.spare_card and #data.spare_card > 1 then
        data.seats[3] = {}
        data.seats[3].handCards = data.spare_card
        data.seats[3].seatID = 3
    end
    if data.isHuangZhuang == 1 then
        --黄庄啦
        pokerTable:showHuangZhuang()
        for _,v in pairs(checktable(data.seats)) do
            local p = self.tableController_:getPlayerBySeatID(v.seatID)
            if p:getUid() == 0 then
                p:getEmptyPlayerPos(p:getIndex())
                v.posX, v.posY = p:getPlayerPosition()
            else
                v.posX, v.posY = p:getPlayerPosition()
            end
            if self.tableController_:getHostSeatID() ~= v.seatID then
                pokerTable:showRoundOverHandCard(v.handCards,v.posX,v.posY,p:getIndex(),nil,false)
            end  
        end
    else
        if data.winInfo.huList then
            self.tableController_:doHuPai(data)
        end
            for _,v in pairs(checktable(data.seats)) do
                local p = self.tableController_:getPlayerBySeatID(v.seatID)
                v.posX, v.posY = p:getPlayerPosition()
                if p:getUid() == 0 then
                    p:getEmptyPlayerPos(p:getIndex())
                    v.posX, v.posY = p:getPlayerPosition()
                else
                    v.posX, v.posY = p:getPlayerPosition()
                end
                if v.totalScore then
                    p:doRoundOver(v)
                    p:setScore(v.totalScore)
                end
                if self.tableController_:getHostSeatID() ~= v.seatID then
                    local isWinner = false
                    if v.seatID == data.winInfo.winner then
                        isWinner = true
                    end            
                    pokerTable:showRoundOverHandCard(v.handCards,v.posX,v.posY,p:getIndex(),data.winInfo,isWinner)
                end  
            end
        local p = self.tableController_:getPlayerBySeatID(data.winInfo.winner,hu)
        pokerTable:showDiPai(data.leftCards,data.winInfo.huList, p, data.winInfo.huCard,data.winInfo.xingCard)
    end
    if data.finishType == 1 then
        TaskQueue.continue()
        self.jieSuanSelect_:hide()
        return
    end
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
    for key,value in ipairs(event.data.match) do
        event.data.seats[value.seatID].matchScore = value.matchScore
    end
    if self.roundOverView_ then
        self:showOverBtn_(true)
    end
    TaskQueue.add(handler(self, self.doGameOver_), 0, -1, event.data)
end

function GameScene:doGameOver_(data)
    local daYingJiaSeats = self:searchSeatIDByMaxKey_(data.seats, "totalScore")
    local mingTangWangScore = 0
    local huPaiWangScore = 0
    for k,v in pairs(checktable(data.seats)) do
        if v.mingTangCount > mingTangWangScore then
            mingTangWangScore = v.mingTangCount
        end
        if v.winCount > huPaiWangScore then
            huPaiWangScore = v.winCount
        end
    end

    for k,v in pairs(checktable(data.seats)) do
        local p = self.tableController_:getPlayerBySeatID(v.seatID)
        v.uid = p:getUid()
        if v.seatID == self.tableController_:getHostSeatID() then
            v.isHost = true
        else
            v.isHost = false
        end
        v.isFangZhu = (v.uid == self:getTable():getOwner())
        v.nickName = p:getNickName()
        v.avatar = p:getAvatar()
        -- v.isFangZhu = (v.uid == dataCenter:getPokerTable():getOwner())
        v.isDaYingJia = (v.totalScore > 0) and table.indexof(daYingJiaSeats, v.seatID) ~= false
        v.isHuPaiWang  = false
        v.isMingTangWang = false
        if v.mingTangCount == mingTangWangScore and mingTangWangScore > 0 then
           v.isMingTangWang = true
        end
        if v.winCount == huPaiWangScore  and huPaiWangScore > 0 then
            v.isHuPaiWang  = true
        end
    end
    self.gameOverData_ = data
    self.gameOverData_.ruleString, self.gameOverData_.addRuleString = self.tableController_:makeGameOverString(' ')
    self.gameOverData_.finishTime = os.date("%Y-%m-%d %H:%M:%S")
    self:showGameOver_()
end

function GameScene:showGameOver_()
    if not self.gameOverData_ then
        return
    end
    local data = self.gameOverData_
    self.tableController_:doGameOver(data)
    self.gameOverView_ = app:createConcreteView("game.GameOverView", data):addTo(self.layerWindows_):tanChuang(150)
    self.gameOverData_ = nil
end

function GameScene:startEnterHall_()
    app:enterHallScene()
end

function GameScene:onAboutClicked_(event)
    if not self.windowAbout_ then
        self.windowAbout_ = app:createView("windows.AboutWindow"):addTo(self):hide()
    else
        self.windowAbout_:hide()
    end
    self.windowAbout_:fadeJumpIn()
end

function GameScene:onHelpClicked_(event)
    if not self.windowHelp_ then
        self.windowHelp_ = app:createView("windows.HelpWindow"):addTo(self):hide()
    else
        self.windowHelp_:hide()
    end
    self.windowHelp_:fadeJumpIn()
end

function GameScene:onLoginReturn_(event)
    if event.data.code ~= 0 then
        app:enterLoginScene()
        return
    end
    app:clearLoading()
    if dataCenter:getRoomID() > 0 then
        dataCenter:sendEnterRoom(dataCenter:getRoomID())
    else
        app:enterHallScene()
    end
end

function GameScene:onPlayerEnterRoom_(event)
    if not event.data then
        return
    end
    self.tableController_:doPlayerSitDown(event.data)
end

-- 此功能暂缓开发
function GameScene:onWaitBigBlindsClicked_(event)
    local selected = event.target:isButtonSelected()
end

function GameScene:onBgClicked_(event)
    printf("{%.3f, %.3f, %d, %d}", event.x / display.width, event.y / display.height, event.x, event.y)
    -- self.tableController_:resetPopUpPokers()
    if self.yuYinView_ then
        self.yuYinView_:hide()
    end
    self.tableController_:getProgreesView():menuHide_()
    self.isMenuOpen_ = false
end

function GameScene:onQuitRoomClicked_(event)
    local msg = "亲，确定要退出房间么？"
    local function callback(bool)
        if bool then
            selfData:setNowRoomID(0)
            dataCenter:sendOverSocket(COMMANDS.YZCHZ_LEAVE_ROOM)
        end
    end
    app:confirm(msg, callback)
end

function GameScene:onDismissClicked_(event)
    if not self:getTable():isOwner(selfData:getUid()) then
        app:showTips("只能房主解散游戏")
        return 
    end
    local msg = ""
    if CHANNEL_CONFIGS.DIAMOND then       
        msg = "解散房间不扣钻石，是否确定解散？"
    else
        msg = "即将解散房间，是否确定解散？"
    end
    local function callback(bool)
        if bool then
            selfData:setNowRoomID(0)
            dataCenter:sendOverSocket(COMMANDS.YZCHZ_OWNER_DISMISS)
        end
    end
    app:confirm(msg, callback)
end


-- function GameScene:onConfigClicked_(event)
--     if self.setView_ == nil or tolua.isnull(self.setView_) then
--         self.setView_ = app:createView("hall.SetViewNew",true,true)
--         self.setView_:addTo(self.layerWindows_)
--     end
-- end

function GameScene:onMenuClicked_(event)
    dump("GameScene:onMenuClicked_GameScene:onMenuClicked_")
    self.isMenuOpen_ = not self.isMenuOpen_
    return self.isPlaying_, self.isMenuOpen_
end

function GameScene:onExitClicked_(event)
    if not dataCenter:getHostPlayer():canExit() then
        app:alert("您正在游戏中，请先站起后再退出～")
        return
    end
    dataCenter:sendOverSocket(COMMANDS.QUIT_TABLE)
end

function GameScene:onTiPaiClicked_(event)
    self.tableController_:getHostPlayer():doTiPai()
end

function GameScene:searchEmptySeatID()
    return self.tableController_:searchEmptySeatID()
end

function GameScene:clearLayerWindows_()
    self.layerWindows_:removeAllChildren()
    self.roundOverView_ = nil
    self.dismissWindow_ = nil
    self.yuYinView_ = nil
end

function GameScene:getTable()
    return self.tableController_:getTable()
end

function GameScene:isMyTable()
    return self.tableController_:isMyTable()
end

function GameScene:sendTuiChuCMD()
    dataCenter:sendOverSocket(COMMANDS.YZCHZ_LEAVE_ROOM)
end

function GameScene:sendJieSanCMD()
    dataCenter:sendOverSocket(COMMANDS.YZCHZ_OWNER_DISMISS)
end

function GameScene:sendDismissRoomCMD(isAgree)
    dataCenter:sendOverSocket(COMMANDS.YZCHZ_REQUEST_DISMISS, {agree = isAgree})
end

function GameScene:showJieSuanSelectView(visible)
    if self.jieSuanSelect_ == nil then
        self.jieSuanSelect_ = SelectedView.new(handler(self, self.jieSuanHandler_)):addTo(self.layerTop_,99):pos(display.left+350,display.bottom + 50)
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
    self.hasRoundOver_ = false
    self.tableController_:doRoundOver(data)
    self.tableController_:clearAfterRoundOver_()
    local pokerTable = self.tableController_:getTable()
    pokerTable:clearRoundOverShowPai()
    dataCenter:sendOverSocket(COMMANDS.YZCHZ_READY)
end

return GameScene
