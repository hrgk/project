local BaseAlgorithm = require("app.games.paodekuai.utils.BaseAlgorithm")
local TaskQueue = require("app.controllers.TaskQueue")
local BaseScene = import("app.scenes.BaseScene")
local GameScene = class("GameScene", BaseScene)
local SanRenDingWei = import("app.views.SanRenDingWei")
local XuanPaiView = import("app.games.paodekuai.views.game.XuanPaiView")
local DismissRoomView = import("app.views.game.DismissRoomView")
local PlayerInfoView = import("app.views.PlayerInfoView")
local WenZiYuYin = import("app.views.WenZiYuYin")
local SelectedView = import("app.views.SelectedView")


local TableController = import("app.games.paodekuai.controllers.TableController")
local BIRD_SPACE_SECONDS = 1
function GameScene:ctor()
    GameScene.super.ctor(self)
    dataCenter:tryConnectSocket()
    self.name = "PAODEKUAI"
    self.gameNode_ = display.newNode():addTo(self)
    self.window_ = display.newNode():addTo(self)
    self.gameOverData_ = nil
    local path1 = gailun.native.getSDCardPath() .. "/" .. "1.aac"
    local path2 = gailun.native.getSDCardPath() .. "/" .. "2.aac"
    local path3 = gailun.native.getSDCardPath() .. "/" .. "3.aac"
    os.remove(path1)
    os.remove(path2)
    os.remove(path3)
    gameAudio.playMusic("sounds/niuniu/bgm.mp3", true)
    self:initSelectedView_()
    self:initRoundOverBtn_() 
end

function GameScene:initRoundOverBtn_()  --jxfj
    self.againBtn_ = ccui.Button:create("res/images/paohuzi/roundOver/playAgain.png", "res/images/paohuzi/roundOver/playAgain.png")
    self.againBtn_:setAnchorPoint(0.5,0.5)
    self.againBtn_:setSwallowTouches(true)
    self.againBtn_:setPosition(display.right - 250, display.bottom + 50)    
    self:addChild(self.againBtn_,99)
    self.againBtn_:setName("again")
    self.againBtn_:addTouchEventListener(handler(self, self.onButtonClick_))

    self.resultBtn_ = ccui.Button:create("res/images/paohuzi/roundOver/lookRezult.png", "res/images/paohuzi/roundOver/lookRezult.png")
    self.resultBtn_:setAnchorPoint(0.5,0.5)
    self.resultBtn_:setSwallowTouches(true)  
    self.resultBtn_:setPosition(display.right - 250, display.bottom + 50)  
    self:addChild(self.resultBtn_,99)
    self.resultBtn_:setName("result")
    self.resultBtn_:addTouchEventListener(handler(self, self.onButtonClick_))

    self.resultBtn_:hide()
    self.againBtn_:hide()
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

function GameScene:showOverBtn_(visible)
    self.resultBtn_:setVisible(visible)
    self.againBtn_:setVisible(not visible)
end

function GameScene:initSelectedView_()
    self.selectedView_ = SelectedView.new(handler(self, self.selectedHandler_))
    self.selectedView_:hide()
    self.selectedView_:setDefaults(1)
    self.selectedView_:pos(display.left+350,display.bottom + 50)
    self:addChild(self.selectedView_, 100)
end

function GameScene:selectedHandler_(index)
    if self.roundOverView_ == nil then
        return
    end
    if index == 2 then
        self.roundOverView_:hide()
    else
        self.roundOverView_:show()
    end
end

function GameScene:isShowSelectedView(visible)
    self.selectedView_:setVisible(visible)
end

function GameScene:initWenYuYin()
    if self.yuYinView_ == nil then
        self.yuYinView_ = WenZiYuYin.new():addTo(self,1)
    end
    self.yuYinView_:show()
    self.yuYinView_:tanChuang(100)
end

function GameScene:hideWenYuYin()
    if self.yuYinView_ then
        self.yuYinView_:hide()
    end
end

function GameScene:addGameView(view)
    self.gameNode_:addChild(view)
end

function GameScene:onEnterTransitionFinish()
    local node = display.newNode():addTo(self)
    TaskQueue.init(node)
    self.tableController_ = TableController.new()
    GameScene.super.onEnterTransitionFinish(self)
    dataCenter:resumeSocketMessage()
    local GameSceneTest = require("app.games.paodekuai.scenes.GameSceneTest")
    GameSceneTest.test(self)
end

function GameScene:bindSocketListeners()
    GameScene.super.bindSocketListeners(self)
    local handlers = dataCenter:s2cCommandToNames {
        {COMMANDS.PDK_GAME_START,handler(self, self.onGameStart_)},
        {COMMANDS.PDK_ROUND_OVER, handler(self, self.onRoundOver_)},
        {COMMANDS.PDK_GAME_OVER, handler(self, self.onGameOver_)},
        {COMMANDS.PDK_READY, handler(self, self.onReady_)},
        {COMMANDS.PDK_LEAVE_ROOM, handler(self, self.onLeaveRoom_)},
        {COMMANDS.PDK_PLAYER_ENTER_ROOM, handler(self, self.onPlayerEnterRoom_)},
        {COMMANDS.PDK_REQUEST_DISMISS, handler(self, self.onDismissInRequest_)},
        {COMMANDS.PDK_ROOM_INFO, handler(self, self.onRoomInfo_)},
        {COMMANDS.PDK_ROUND_FLOW, handler(self, self.onRoundFlow_)},
        -- {COMMANDS.CHANGE_SERVER, handler(self, self.onChangeServer_)},
        -- {COMMANDS.PDK_CHECK_CHOU_JIANG, handler(self, self.onCheckChouJiang_)},
        -- {COMMANDS.PDK_CHOU_JIANG, handler(self, self.onChouJiang_)},
        {COMMANDS.PDK_XUAN_PAI, handler(self, self.onXuanPaiHandler_)},
        {COMMANDS.PDK_NOTIFY_LOCATION, handler(self, self.onNotifyLocation_)},
        {COMMANDS.PDK_REQUEST_LOCATION, handler(self, self.onRequestLocation_)},

        {COMMANDS.PDK_ROUND_START, handler(self, self.onRoundStart_)},
        {COMMANDS.PDK_TURN_TO, handler(self, self.onTurnTo_)},
        {COMMANDS.PDK_DEAL_CARD, handler(self, self.onDealCards_)},
        {COMMANDS.PDK_TURN_START, handler(self, self.onTurnStart_)},
        {COMMANDS.PDK_TURN_END, handler(self, self.onTurnEnd_)},
        {COMMANDS.PDK_ZHA_DAN_DE_FEN, handler(self, self.onZhaDanDeFen_)},
        {COMMANDS.PDK_CHU_PAI, handler(self, self.onPlayerChuPai_)},
        {COMMANDS.PDK_PLAYER_PASS, handler(self, self.onPlayerPass_)},
        {COMMANDS.PDK_BROADCAST, handler(self, self.onBroadcast_)},  -- 广播消息
        {COMMANDS.PDK_ONLINE_STATE, handler(self, self.onPlayerStateChanged_)},  -- 玩家网络事件广播
        {COMMANDS.PDK_OWNER_DISMISS, handler(self, self.onOwnerDismiss_)},
    }
    gailun.EventUtils.create(self, dataCenter, self, handlers)
end

function GameScene:onCleanup()
    collectgarbage("collect")
end

function GameScene:onXuanPaiHandler_(event)
    if event.data.isReview then
        self.tableController_:upDateXuanPai(event.data)
    else
        TaskQueue.add(handler(self.tableController_, self.tableController_.upDateXuanPai), 0, 0, event.data)
    end
end

function GameScene:onRoundFlow_(event)
    if event.data.flow == 2 then
        if event.data.isReview then
            self.tableController_:doXuanPai(event.data)
        else
            TaskQueue.add(handler(self.tableController_, self.tableController_.doXuanPai), 0, 0, event.data)
        end
    end
end

function GameScene:addPokerToTable(seatID, view, x, y)
    self.tableController_:addPokerToTable(seatID, view, x, y)
end

function GameScene:updateXuanPaiView(data)
    self.xuanPaiView_:update(data)
end

function GameScene:initXuanPaiView(data)
    self.xuanPaiView_ = XuanPaiView.new(data)
    self:addChild(self.xuanPaiView_,100)
    self.xuanPaiView_:tanChuang(200)
end

function GameScene:setHostPlayerState(offline)
    if self.tableController_ then
        self.tableController_:setHostPlayerState(offline)
    end
end

function GameScene:onGameStart_(event)
    self.tableController_:gameStart()
end

function GameScene:onBroadcast_(event)
    self.tableController_:doBroadcast(event.data)
end

function GameScene:onPlayerStateChanged_(event)
    self.tableController_:doPlayerStateChanged(event.data)
end

function GameScene:onPlayerPass_(event)
    if event.data.isReview then
        self.tableController_:doPlayerPass(event.data)
    else
        TaskQueue.add(handler(self.tableController_, self.tableController_.doPlayerPass), 0, 0, event.data)
    end
end

function GameScene:onPlayerChuPai_(event)
    if event.data.isReview then
        self.tableController_:doPlayerChuPai(event.data)
    else
        TaskQueue.add(handler(self.tableController_, self.tableController_.doPlayerChuPai), 0, 0.3, event.data)
    end
end

function GameScene:onZhaDanDeFen_(event)
    if event.data.isReview then
        self.tableController_:doZhaDanDeFen(event.data, nil, event.data.inFastMode)
    else
        TaskQueue.add(handler(self.tableController_, self.tableController_.doZhaDanDeFen), 0, 1, event.data)
    end
end

function GameScene:onTurnEnd_(event)
    local seconds = 0.8
    if event.data.isReview then
        self.tableController_:doTurnEnd(event.data)
    else
        TaskQueue.add(handler(self.tableController_, self.tableController_.doTurnEnd), seconds, 0, event.data)
    end
end

function GameScene:onTurnStart_(event)
    self.isTurnStart_ = true
end

function GameScene:onDealCards_(event)
    if event.data.isReview then
        self.tableController_:doDealCards(event.data)
    else
        TaskQueue.add(handler(self.tableController_, self.tableController_.doDealCards), 0, 2, event.data)
    end
end

function GameScene:onTurnTo_(event)
    -- if self.tableController_:getHostSeatID() == event.data.seatID then
    --     if not event.data.is_background then
    --         --刷新手牌
    --         self.tableController_:getPlayerBySeatID(event.data.seatID):reShowHandCards()
    --     end
    -- end

    if event.data.isReview then
        self.tableController_:doTurnTo(data)
    else
        -- TaskQueue.add(handler(self.tableController_, self.tableController_.doTurnTo), 0, 0.2, event.data.seatID, event.data.remainTime, event.data.yaoDeQi)
        TaskQueue.add(handler(self.tableController_, self.tableController_.doTurnTo), 0, 0.2, event.data)
    end
end

function GameScene:onRoundStart_(event)
    TaskQueue.continue()
    if event.data.isReview then
        self.tableController_:doRoundStart(event.data)
    else
        TaskQueue.add(handler(self.tableController_, self.tableController_.doRoundStart), 0, 0, event.data)
    end
    self.selectedView_:hide()
end

function GameScene:onOwnerDismiss_(event)
    self.tableController_:doOwnerDismiss(event.data)
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
        self.hongBaoView_ = app:createView("game.HongBaoView", event.data):addTo(self.window_)
    end
end

function GameScene:onGameBroadcast_(event)
    self:showZhongJiangView_(event.data.uid, event.data.nickname, event.data.diamond, event.data.long_time)
end

function GameScene:showZhongJiangView_(userId, nickName, diamond, holdTime)
    local message = "恭喜玩家：" .. nickName .. "开房抽奖喜获钻石" .. diamond .. "个"
    if CHANNEL_CONFIGS.BROADCAST then
        if self.hongBaoZhongJiangView_ == nil then
            self.hongBaoZhongJiangView_ = app:createView("game.HongBaoZhongJiangView"):addTo(self.window_):update(message, holdTime)
        else
            self.hongBaoZhongJiangView_:update(message, event.data.long_time)                                                                                                                                         
        end
    end
end

function GameScene:onChangeServer_(event)
    local host = event.data.host
    local port = event.data.port
    dataCenter:setHostAndPort(host, port)
    dataCenter:setChangeServer(true)
    dataCenter:setRoomID(0)
end

function GameScene:onReconnectClicked_(event)
    TaskQueue.removeAll()
    app:enterScene("LoadScene")
end

function GameScene:onToWechatClicked_(event)
    local params = {
        packageName = "com.tencent.mm",
        enterName = "wechat"
    }
    gailun.native.enterApp(params)
end

function GameScene:onVoiceClicked_(event)
    app:createView("game.VoiceRecordView"):addTo(self.window_)
end



function GameScene:onButtonOKClicked_(event)
    self.buttonOK_:hide()
    TaskQueue.continue()
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
    dataCenter:setOwner(event.data.creator)
    gameLocalData:setGameRecordID(event.data.config.recordID)
    TaskQueue.removeAll()
    self.tableController_:doRoomInfo(event.data)
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
        -- if self.roundOverView_ and not tolua.isnull(self.roundOverView_) then
        --     self.roundOverView_:setIsGameOver(true)
        -- end
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
        self.disMissView_ = DismissRoomView.new():addTo(self.window_)
        self.disMissView_:tanChuang()
    end
    local names = {}
    local myIsAgree = false
    local myIsRefuse = false
    for i,v in ipairs(event.data.yesSeatIDs) do
        local player = self.tableController_:getPlayerBySeatID(v)
        if player:isHost() then
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

function GameScene:onNotifyLocation_(event)
    print("onNotifyLocation_")
    if not event.data then
        return
    end 
    if event.data.code == 0 then
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
        if date.config.rules.playerCount == 2 then
            self.tableController_:showReady()
        else
            if self.dingWeiView_ and self.dingWeiView_.isOpen then
                self.dingWeiView_:removeSelf()
                self.dingWeiView_ = nil
            end
            self.dingWeiView_ = SanRenDingWei.new(params,event.data.distances,true,GAME_PAODEKUAI):addTo(self.window_)
            self.dingWeiView_:tanChuang(150)
        end 
        
    end
end

function GameScene:onRequestLocation_(event)
    if event.data.code == 0 then
        local params = {}
        for i,v in ipairs(self.tableController_.seats_) do
            local obj = {}
            obj.ip = v:getIP()
            obj.uid = v:getUid()
            obj.name = v:getNickName()
            obj.avatar = v:getAvatar()
            table.insert(params, obj)
        end
        if self.dingWeiView_ and self.dingWeiView_.isOpen then
            self.dingWeiView_:removeSelf()
            self.dingWeiView_ = nil
        end
        self.dingWeiView_ = SanRenDingWei.new(params,event.data.distances,false,GAME_PAODEKUAI):addTo(self.window_)
        self.dingWeiView_:tanChuang(150)
    end
end

function GameScene:onStateIdle_(event)
    self:showOnStateIdle_()
end

function GameScene:showOnStatePlaying_()
    -- self.buttonInvite_:hide()
    -- self.buttonDismiss_:hide()
    -- self.buttonQuitRomm_:hide()
    -- self.buttonOK_:hide()
    -- self.buttonConfig_:show()
    -- self:showChat_()
    -- self:showVoiceChat_()
end

function GameScene:finishRound()
    self.tableController_:finishRound()
end

function GameScene:onStatePlaying_(event)
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

function GameScene:onJieSan()
    local msg = ""
    if CHANNEL_CONFIGS.DIAMOND then       
        msg = "解散房间不扣钻石，是否确定解散？"
    else
        msg = "即将解散房间，是否确定解散？"
    end
    app:createView("game.DismissRoomView", msg, function (isOK)
        self.isKeyClick_ = false
            if isOK then
                dataCenter:sendOverSocket(COMMANDS.PDK_OWNER_DISMISS)
            end
        end):addTo(self.window_)
end

function GameScene:initPlayerInfoView(data)
    local view = PlayerInfoView.new(data,GAME_PAODEKUAI):addTo(self)
    view:showInGameScenes()
    view:tanChuang(150)
end

function GameScene:onReady_(event)
    TaskQueue.add(handler(self.tableController_, self.tableController_.onPlayerReady), 0, 0, event.data)
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
    local buttonSeatID =self.tableController_:getCreator()
    data.hostSeatID = self.tableController_:getHostSeatID()
    local rankCount = 0
    local isZhuangShangYou = false
    for _,v in pairs(checktable(data.seats)) do
        local p = self.tableController_:getPlayerBySeatID(v.seatID)
        if buttonSeatID == 0 then
            
        else
            v.isZhuang = buttonSeatID == v.seatID
        end
        v.nickName = p:getNickName()
        v.avatar = p:getAvatar()
        v.zhuangID = buttonSeatID
        if data.hostSeatID ~= v.seatID then
            v.isHost = false
        else
            v.isHost = true
        end
        v.hostUid = selfData:getUid()
        v.uid = p:getPlayer():getUid()
    end
    self.tableController_:doRoundOver(data)
    local isGameOver = not data.hasNextRound
    self:showOverBtn_(isGameOver)
    self.roundOverView_ = app:createConcreteView("game.RoundOverView", data, isGameOver):addTo(self.window_)
    -- self.roundOverView_:hide()
    self.roundOverView_:tanChuang(200)
    self.selectedView_:setDefaults(1)
end

function GameScene:showRoundOver()
    self.roundOverView_:tanChuang(200)
    self.roundOverView_:show()
end

-- 一局结束
function GameScene:onRoundOver_(event)
    TaskQueue.add(handler(self, self.doRoundOver_), 0, 0, event.data)
    TaskQueue.add(handler(self, self.doRoundReview_), 0, -1, clone(event.data))
end



function GameScene:doRoundReview_(data)
    self.tableController_:stopTimer()
    self.tableController_:doRoundOver()
    local pokerTable = self.tableController_:getTable()
    local rankCount = 0
    local winnerIndex = 0
    local loses = {}
    for _,v in pairs(checktable(data.seats)) do
        local p = self.tableController_:getPlayerBySeatID(v.seatID)
        local distScore = v.totalScore - p:getScore()
        p:setScore(v.totalScore, distScore)
        p:showRoundOverPoker(v.handCards)
        p:warning(-1)
        if #v.handCards == 0 then
            winnerIndex = p:getIndex()
        elseif #v.handCards > 1 then
            loses[#loses+1] = p:getIndex()
        end
    end
    if #loses > 0 and winnerIndex > 0 then
        if SPECIAL_PROJECT then
            -- to do
        else
            self.tableController_:goldFly(winnerIndex, loses)
        end
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
        if event.data.seats[value.seatID] then
            event.data.seats[value.seatID].matchScore = value.matchScore
        end
    end
    TaskQueue.add(handler(self, self.doGameOver_), 0, 0, event.data)
end

function GameScene:doGameOver_(data)
    local daYingJiaSeats = self:searchSeatIDByMaxKey_(data.seats, "totalScore")
    local zhaDanSeats = self:searchSeatIDByMaxKey_(data.seats, "bombCount")
    local guanSeats = self:searchSeatIDByMaxKey_(data.seats, "guanCount")
    for _,v in pairs(checktable(data.seats)) do
        local p = self.tableController_:getPlayerBySeatID(v.seatID)
        v.uid = p:getUid()
        if v.seatID == self.tableController_:getHostSeatID() then
            v.isHost = true
        else
            v.isHost = false
        end
        v.nickName = p:getNickName()
        v.avatar = p:getAvatar()
        v.isFangZhu = (v.uid == self.tableController_:getCreator())
        v.isDaYingJia = (v.totalScore > 0) and table.indexof(daYingJiaSeats, v.seatID) ~= false
    end
    self.gameOverData_ = data
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
    local view = app:createConcreteView("game.GameOverView", data)
    self:addChild(view, 101)
    view:tanChuang(200)
    self.gameOverData_ = nil
end

function GameScene:onPlayerEnterRoom_(event)
    printInfo("GameScene:onEnterRoom_(event)")
    dump(event.data,"xxxxxonPlayerEnterRoom_")
    if not event.data then
        printInfo("if not event.data then")
        return
    end
    self.tableController_:doPlayerSitDown(event.data)
end

function GameScene:getHostPlayer()
    return self.tableController_:getHostPlayer()
end

function GameScene:getCurrCards()
    return self.tableController_:getCurrCards()
end

function GameScene:getTable()
    return self.tableController_.table_
end

function GameScene:getRuleDetails()
    if self.tableController_ then
        return self.tableController_.table_:getRuleDetails()
    end
end

function GameScene:getPlayerBySeatID(seatID)
    return self.tableController_:getPlayerBySeatID(seatID)
end

function GameScene:sendDismissRoomCMD(isAgree)
    dataCenter:sendOverSocket(COMMANDS.PDK_REQUEST_DISMISS, {agree = isAgree})
end

function GameScene:sendXuanPaiCMD()
    dataCenter:sendOverSocket(COMMANDS.PDK_XUAN_PAI)
end

function GameScene:sendDingWeiCMD()
    dataCenter:sendOverSocket(COMMANDS.PDK_REQUEST_LOCATION)
end

function GameScene:sendTuiChuCMD()
    dataCenter:sendOverSocket(COMMANDS.PDK_LEAVE_ROOM)
end

function GameScene:sendJieSanCMD()
    dataCenter:sendOverSocket(COMMANDS.PDK_OWNER_DISMISS)
end

function GameScene:isMyTable()
    return self.tableController_:isMyTable()
end

function GameScene:clickTable(event)
    local player = self:getHostPlayer()
    if player then
        player:clickTable(event)
    end
end

function GameScene:continueTask()
    TaskQueue.continue()
end

function GameScene:nextRound()
    if self.roundOverView_ then
        self.roundOverView_:removeSelf()
        self.roundOverView_ = nil
    end
    self.hasRoundOver_ = false
    self:isShowSelectedView(false)
    -- self.tableController_:doRoundOver(data)
    -- self.tableController_:clearAfterRoundOver_()
    -- local pokerTable = self.tableController_:getTable()
    -- pokerTable:clearRoundOverShowPai()
    TaskQueue.continue()
    self.tableController_:clearSeats()
    dataCenter:sendOverSocket(COMMANDS.PDK_READY)
end

return GameScene
