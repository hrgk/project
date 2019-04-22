local TaskQueue = require("app.controllers.TaskQueue")
local BaseScene = import("app.scenes.BaseScene")
local GameScene = class("GameScene", BaseScene)
local PlayerInfoView = import("app.views.PlayerInfoView")
local SiRenDingWei = import("app.views.SiRenDingWei")
local SanRenDingWei = import("app.views.SanRenDingWei")
local DismissRoomView = import("app.views.game.DismissRoomView")
local WenZiYuYin = import("app.views.WenZiYuYin")
local TableController = import("app.games.dao13.controllers.TableController")
local CuoPokerView = import("app.views.game.CuoPokerView")
local SelectedView = import("app.views.SelectedView")
local BIRD_SPACE_SECONDS = 1

function GameScene:ctor()
    GameScene.super.ctor(self)
    dataCenter:tryConnectSocket()
    self.name = "DAO13"
    self.gameNode_ = display.newNode():addTo(self)
    self.window_ = display.newNode():addTo(self)
    self.gameOverData_ = nil
    local node = display.newNode():addTo(self)
    TaskQueue.init(node)
    local path1 = gailun.native.getSDCardPath() .. "/" .. "1.aac"
    local path2 = gailun.native.getSDCardPath() .. "/" .. "2.aac"
    local path3 = gailun.native.getSDCardPath() .. "/" .. "3.aac"
    os.remove(path1)
    os.remove(path2)
    os.remove(path3)
    gameAudio.playMusic("sounds/niuniu/bgm.mp3", true)
    self.isCuoPai = false
    self:initSelectedView_()
    self:initRoundOverBtn_() 
    self.needDely = false
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

function GameScene:nextRound()
    if self.roundOverView_ then
        self.roundOverView_:removeSelf()
        self.roundOverView_ = nil
    end
    self.hasRoundOver_ = false
    self:isShowSelectedView(false)
    TaskQueue.continue()
    self.tableController_:clearAll()
    dataCenter:sendOverSocket(COMMANDS.DAO13_READY)
end

function GameScene:isShowSelectedView(visible)
    self.selectedView_:setVisible(visible)
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
    self.tableController_ = TableController.new()
    GameScene.super.onEnterTransitionFinish(self)
    dataCenter:resumeSocketMessage()
    -- local GameSceneTest = require("app.games.dao13.scenes.GameSceneTest")
    -- GameSceneTest.test(self)
end

function GameScene:bindSocketListeners()
    gailun.EventUtils.clear(self)
    GameScene.super.bindSocketListeners(self)
    local handlers = dataCenter:s2cCommandToNames {
        {COMMANDS.DAO13_GAME_START,handler(self, self.onGameStart_)},
        {COMMANDS.DAO13_ROUND_OVER, handler(self, self.onRoundOver_)},
        {COMMANDS.DAO13_GAME_OVER, handler(self, self.onGameOver_)},
        {COMMANDS.DAO13_READY, handler(self, self.onReady_)},
        {COMMANDS.DAO13_LEAVE_ROOM, handler(self, self.onLeaveRoom_)},
        {COMMANDS.DAO13_PLAYER_ENTER_ROOM, handler(self, self.onPlayerEnterRoom_)},
        {COMMANDS.DAO13_REQUEST_DISMISS, handler(self, self.onDismissInRequest_)},
        {COMMANDS.DAO13_PRE_ROOM_INFO, handler(self, self.onPreRoomInfo_)},
        {COMMANDS.DAO13_ROOM_INFO, handler(self, self.onRoomInfo_)},
        {COMMANDS.DAO13_DING_ZHUANG, handler(self, self.onDingZhuang_)},
        {COMMANDS.DAO13_ROUND_FLOW, handler(self, self.onRoundFlow_)},
        {COMMANDS.DAO13_CALL_SCORE, handler(self, self.onCallScore_)},
        {COMMANDS.DAO13_KAI_PAI, handler(self, self.onKaiPaiHandler_)},
        {COMMANDS.DAO13_QIANG_ZHUANG, handler(self, self.onQiangZhuangHandler_)},
        {COMMANDS.DAO13_DE_FEN, handler(self, self.onDeFenHandler_)},
        {COMMANDS.DAO13_CAN_CALL_LIST, handler(self, self.onCanCallListHandler_)},
        {COMMANDS.DAO13_BROADCAST, handler(self, self.onBroadcast_)},  -- 广播消息
        {COMMANDS.DAO13_ROUND_START, handler(self, self.onRoundStart_)},
        {COMMANDS.DAO13_FA_PAI, handler(self, self.onDealCards_)},
        {COMMANDS.DAO13_ONLINE_STATE, handler(self, self.onPlayerStateChanged_)},  -- 玩家网络事件广播
        {COMMANDS.DAO13_OWNER_DISMISS, handler(self, self.onOwnerDismiss_)},
        {COMMANDS.DAO13_SERVER_FAN_PAI, handler(self, self.onServerFanPai_)},
        {COMMANDS.DAO13_NOTIFY_LOCATION, handler(self, self.onNotifyLocation_)},
        {COMMANDS.DAO13_REQUEST_LOCATION, handler(self, self.onRequestLocation_)},
        {COMMANDS.DAO13_PLAY_CARDS, handler(self, self.onPlayeCards_)},

        {COMMANDS.DAO13_START_COMPARE_CARDS, handler(self, self.onStartCompareCards_)},
        {COMMANDS.DAO13_SHOW_HEAD_CARDS, handler(self, self.onShowHeadCards_)},
        {COMMANDS.DAO13_SHOW_MIDDLE_CARDS, handler(self, self.onShowMiddleCards_)},
        {COMMANDS.DAO13_SHOW_TAIL_CARDS, handler(self, self.onShowTailCards_)},

        {COMMANDS.DAO13_SHOW_SEPCIAL_CARDS, handler(self, self.onShowSepcialCards_)},
        {COMMANDS.DAO13_UPDATE_PLAYER_SCORE, handler(self, self.onShowPlayerScore_)},

        {COMMANDS.DAO13_DA_QIANG, handler(self, self.onShowDaQiang_)},
        {COMMANDS.DAO13_HONG_LE, handler(self, self.onShowHongLe_)},
        {COMMANDS.DAO13_HEI_LE, handler(self, self.onShowHeiLe_)},
        {COMMANDS.DAO13_UPDATE_SEPCIAL_SCORE, handler(self, self.onShowSepcialScore_)},
    }
    gailun.EventUtils.create(self, dataCenter, self, handlers)
end

function GameScene:onShowSepcialScore_(event)
    if event.data.isReview then
        self.tableController_:onShowSepcialScore_(event.data)
    else
        TaskQueue.add(handler(self.tableController_, self.tableController_.onShowSepcialScore_), 0, 0.3, event.data)
    end
end

function GameScene:initPlayerInfoView(data)
    local view = PlayerInfoView.new(data,GAME_13DAO):addTo(self)
    view:showInGameScenes()
    view:tanChuang(150)
end

function GameScene:onShowHeiLe_(event)
    if event.data.isReview then
        self.tableController_:onShowHeiLe_(event.data)
    else
        TaskQueue.add(handler(self.tableController_, self.tableController_.onShowHeiLe_), 0, 1, event.data)
    end
end

function GameScene:onShowHongLe_(event)
    if event.data.isReview then
        self.tableController_:onShowHongLe_(event.data)
    else
        TaskQueue.add(handler(self.tableController_, self.tableController_.onShowHongLe_), 0, 1, event.data)
    end
end

function GameScene:onShowDaQiang_(event)
    if event.data.isReview then
        self.tableController_:onShowDaQiang_(event.data)
    else
        TaskQueue.add(handler(self.tableController_, self.tableController_.onShowDaQiang_), 0, 1, event.data)
    end
end

function GameScene:onShowPlayerScore_(event)
    if event.data.isReview then
        self.tableController_:onShowPlayerScore_(event.data)
    else
        TaskQueue.add(handler(self.tableController_, self.tableController_.onShowPlayerScore_), 0, 0.3, event.data)
    end
end

function GameScene:onShowSepcialCards_(event)
    if event.data.isReview then
        self.tableController_:onShowSepcialCards_(event.data)
    else
        TaskQueue.add(handler(self.tableController_, self.tableController_.onShowSepcialCards_), 0, 0, event.data)
    end
end

function GameScene:onStartCompareCards_(event)
    if event.data.isReview then
        self.tableController_:onStartCompareCards_(event.data)
    else
        TaskQueue.add(handler(self.tableController_, self.tableController_.onStartCompareCards_), 0, 0.3, event.data)
    end
end

function GameScene:onShowHeadCards_(event)
    if event.data.isReview then
        self.tableController_:onShowHeadCards_(event.data)
    else
        TaskQueue.add(handler(self.tableController_, self.tableController_.onShowHeadCards_), 0, 1, event.data)
    end
end

function GameScene:onShowMiddleCards_(event)
    if event.data.isReview then
        self.tableController_:onShowMiddleCards_(event.data)
    else
        TaskQueue.add(handler(self.tableController_, self.tableController_.onShowMiddleCards_), 0, 0, event.data)
    end
end

function GameScene:onShowTailCards_(event)
    --if event.data.isReview then
        self.tableController_:onShowTailCards_(event.data)
    -- else
    --     TaskQueue.add(handler(self.tableController_, self.tableController_.onShowTailCards_), 0, 0, event.data)
    -- end
    self.needDely = true
end

function GameScene:onPlayeCards_(event)
    if event.data.isReview then
        self.tableController_:doPlayerChuPai(event.data)
    else
        TaskQueue.add(handler(self.tableController_, self.tableController_.doPlayerChuPai), 0, 0, event.data)
    end
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
        if self.dingWeiView_ and self.dingWeiView_.isOpen then
            self.dingWeiView_:removeSelf()
            self.dingWeiView_ = nil
        end
        local date = display.getRunningScene():getTable():getConfigData()
        if date.config.rules.playerCount == 2 then
            self.tableController_:showReady()
        elseif date.config.rules.playerCount == 3 then
            self.dingWeiView_ = SanRenDingWei.new(params,event.data.distances,true,GAME_13DAO):addTo(self.window_)
        elseif date.config.rules.playerCount == 4 then
            self.dingWeiView_ = SiRenDingWei.new(params,event.data.distances,true,GAME_13DAO):addTo(self.window_)
        end
        if self.dingWeiView_ ~= nil then
            self.dingWeiView_:tanChuang(150)
        end
    end
end

function GameScene:isMyTable()
    return self.tableController_:isMyTable()
end

function GameScene:onRequestLocation_(event)
    dump(event.data,"GameScene:onRequestLocation_")
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
        local date = display.getRunningScene():getTable():getConfigData()
        if date.config.rules.playerCount == 2 then
            --self.tableController_:showReady()
        elseif date.config.rules.playerCount == 3 then
            self.dingWeiView_ = SanRenDingWei.new(params,event.data.distances,true,GAME_13DAO):addTo(self.window_)
        elseif date.config.rules.playerCount == 4 then
            self.dingWeiView_ = SiRenDingWei.new(params,event.data.distances,true,GAME_13DAO):addTo(self.window_)
        end
        if self.dingWeiView_ ~= nil then
            self.dingWeiView_:tanChuang(150)
        end
    end
end

function GameScene:onServerFanPai_(event)
    if self.isCuoPai then
        self.isCuoPai = false
        self:initCuoPokerView(event.data)
        return
    end
    if event.data.isReview then
        self.tableController_:doFanPai(event.data)
    else
        TaskQueue.add(handler(self.tableController_, self.tableController_.doFanPai), 0, 0, event.data)
    end
end

function GameScene:onCleanup()
    collectgarbage("collect")
end

function GameScene:onCanCallListHandler_(event)
    if event.data.isReview then
        self.tableController_:doCanCallList(event.data)
    else
        TaskQueue.add(handler(self.tableController_, self.tableController_.doCanCallList), 0, 0, event.data)
    end
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

function GameScene:onDeFenHandler_(event)
    if event.data.isReview then
        self:doDeFenHandler_(event)
    else
        if date.config.rules.zhuangType == 2 then
            TaskQueue.add(handler(self, self.doDeFenHandler_), 0, 0, event)
        else
            TaskQueue.add(handler(self, self.doDeFenHandler_), 0, 4, event)
        end
        
    end
end

function GameScene:doDeFenHandler_(event)
   local wins = {}
   local loses = {}
   local zhuangSeatID = self.tableController_:getTable():getDealerSeatID()
   local zhuangPlayer = self.tableController_:getPlayerBySeatID(zhuangSeatID)
   for k,v in pairs(event.data) do
       local player = self.tableController_:getPlayerBySeatID(tonumber(k))
        if v > 0 then
        table.insert(wins, player:getIndex())
        elseif v < 0 then
        table.insert(loses, player:getIndex())
        end
   end
    local deleTime = 1
    if #loses > 0 and zhuangPlayer then
        self:performWithDelay(function ()
            self.tableController_:goldFly(zhuangPlayer:getIndex(), loses)
        end, deleTime)
    end
    deleTime = deleTime + 1.5
    if #wins > 0 and zhuangPlayer then
        self:performWithDelay(function ()
            for i,v in ipairs(wins) do
                self.tableController_:goldFly(v, {zhuangPlayer:getIndex()})
            end
        end, deleTime)
    end
end

function GameScene:onKaiPaiHandler_(event)
    if event.data.seatID == self.tableController_.hostSeatID_ then
        if self.cuoPokerView_ then
            self.cuoPokerView_:removeSelf()
            self.cuoPokerView_ = nil
        end
    end
    if event.data.isReview then
        self.tableController_:doKaiPai(event.data)
    else
        TaskQueue.add(handler(self.tableController_, self.tableController_.doKaiPai), 0, 1, event.data)
    end
end

function GameScene:onQiangZhuangHandler_(event)
    if event.data.isReview then
        self.tableController_:doQiangZhuang(event.data)
    else
        TaskQueue.add(handler(self.tableController_, self.tableController_.doQiangZhuang), 0, 1, event.data)
    end
end

function GameScene:onCallScore_(event)
    if event.data.isReview then
        self.tableController_:doCallScore(event.data)
    else
        TaskQueue.add(handler(self.tableController_, self.tableController_.doCallScore), 0, 1, event.data)
    end
end

function GameScene:onRoundFlow_(event)
    if event.data.isReview then
        self.tableController_:onRoundFlow(event.data)
    else
        TaskQueue.add(handler(self.tableController_, self.tableController_.onRoundFlow), 0, 0.3, event.data)
    end
end

function GameScene:onDingZhuang_(event)
    -- self.tableController_:gameStart()
    if event.data.isReview then
        self.tableController_:doDingZhuang(event.data)
    else
        TaskQueue.add(handler(self.tableController_, self.tableController_.doDingZhuang), 0, 1, event.data)
    end
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

function GameScene:onSocketClosed_()
    local seatID = self.tableController_:getHostSeatID()
    if self.tableController_ == nil then return end
    for k,v in pairs(self.tableController_:getSeats()) do
        if seatID == v:getSeatID() then
            v:setOffline(true)
        else
            v:setOffline(false)
        end
    end
end

function GameScene:onExitTransitionStart()
    dataCenter:pauseSocketMessage()
end

function GameScene:onExit()
    gailun.EventUtils.clear(self)
    transition.stopTarget(self)
    TaskQueue.clear()
end

function GameScene:onPreRoomInfo_(event)
    dump(event.data,"GameScene:onPreRoomInfo_")
    self.tableController_:doPreRoomInfo(event.data)
end

function GameScene:onRoomInfo_(event)
    dataCenter:setOwner(event.data.creator)
    gameLocalData:setGameRecordID(event.data.config.recordID)
    TaskQueue.removeAll()
    self.tableController_:doRoomInfo(event.data)
    self.resultBtn_:setVisible(false)
    self.againBtn_:setVisible(false)
    
    if self.roundOverView_ and not tolua.isnull(self.roundOverView_)  then
        self.roundOverView_:removeFromParent()
        self.roundOverView_ = nil
    end
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
            self.myIsAgreeDissmiss = true
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

function GameScene:onReady_(event)
    if event.data.code and event.data.code == -12 then
        app:showTips("人数已满，无法坐下")
        self.tableController_:setTempSeats()
        return 
    end
    TaskQueue.add(handler(self.tableController_, self.tableController_.onPlayerReady), 0, 0, event.data)
end

-- 一局结束
function GameScene:onRoundOver_(event)
    local date = display.getRunningScene():getTable():getConfigData()
    TaskQueue.add(handler(self, self.doRoundOver_), 0, 0, event.data)
    TaskQueue.add(handler(self, self.doRoundReview_), 0, -1, clone(event.data))
end

function GameScene:doRoundOver_(data)
    local buttonSeatID = self.tableController_:getTable():getDealerSeatID()
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
    self.roundOverView_:tanChuang(200)
    self:isShowSelectedView(true)
    self.selectedView_:setDefaults(1)
end

function GameScene:doRoundReview_(data)
    self.tableController_:stopTimer()
    self.tableController_:nextStart()
    self.tableController_:clearTableTip()
    local pokerTable = self.tableController_:getTable()
    local rankCount = 0
    local winnerIndex
    local loses = {}
    for _,v in pairs(checktable(data.seats)) do
        local p = self.tableController_:getPlayerBySeatID(v.seatID)
        if p then
            p:setScore(v.totalScore, v.score)
            if p:isHost() then
                p:showDouZi(v.score)
            end
            if data.hasNextRound then
                p:showDaoScore(v.score, 4)
            end
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
        event.data.seats[value.seatID].matchScore = value.matchScore
    end
    TaskQueue.add(handler(self, self.doGameOver_), 0, 0, event.data)        
end

function GameScene:doGameOver_(data)
    local daYingJiaSeats = self:searchSeatIDByMaxKey_(data.seats, "totalScore")
    local userNames = ""
    for i,v in ipairs(data.no_score_seat_id or {}) do
        local p = self.tableController_:getPlayerBySeatID(v)
        userNames = userNames .. p:getNickName()..","
    end
    if userNames ~= "" then
        local function callback(isShow)
            if isShow then
                self:showGameOver_()
            end
        end
        app:alert(userNames.."金豆不够，游戏结束",callback)
    end
    for _,v in pairs(checktable(data.seats)) do
        local p = self.tableController_:getPlayerBySeatID(v.seatID)
        v.uid = p:getUid()
        v.nickName = p:getNickName()
        v.avatar = p:getAvatar()
        v.isFangZhu = (v.uid == self.tableController_:getCreator())
        v.isDaYingJia = (v.totalScore > 0) and table.indexof(daYingJiaSeats, v.seatID) ~= false
    end
    self.gameOverData_ = data
    self.gameOverData_.finishTime = os.date("%Y-%m-%d %H:%M:%S")
    if  userNames == "" then
        self:showGameOver_()
    end
    self:isShowSelectedView(false)
end

function GameScene:showGameOver_()
    if not self.gameOverData_ then
        return
    end
    local data = self.gameOverData_
    self.tableController_:doGameOver(data)
    self.isOpenWindow_ = true
    data.ruleString = self.tableController_:makeRuleString(' ')
    data.finishTime = os.date("%Y-%m-%d %H:%M:%S")
    app:createConcreteView("game.GameOverView", data):addTo(self.window_):tanChuang(150)
    self.gameOverData_ = nil
end

function GameScene:onPlayerEnterRoom_(event)
    printInfo("GameScene:onEnterRoom_(event)")
    if not event.data then
        printInfo("if not event.data then")
        return
    end
    dump(event.data,"GameScene:onPlayerEnterRoom_")
    self.tableController_:doPlayerSitDown(event.data)
end

function GameScene:onDealCards_(event)
    dump(event.data,"onDealCards_")
    if event.data.isReview then
        self.tableController_:doFaPai(event.data)
    else
        TaskQueue.add(handler(self.tableController_, self.tableController_.doFaPai), 0, 0, event.data)
    end
end

function GameScene:getHostPlayer()
    return self.tableController_:getHostPlayer()
end

function GameScene:sendDismissRoomCMD(isAgree)
    dataCenter:sendOverSocket(COMMANDS.DAO13_REQUEST_DISMISS, {agree = isAgree})
end

function GameScene:sendDingWeiCMD()
    dataCenter:sendOverSocket(COMMANDS.DAO13_REQUEST_LOCATION)
end

function GameScene:sendTuiChuCMD()
    dataCenter:sendOverSocket(COMMANDS.DAO13_LEAVE_ROOM)
end

function GameScene:sendJieSanCMD()
    dataCenter:sendOverSocket(COMMANDS.DAO13_OWNER_DISMISS)
end

function GameScene:getRuleDetails()
    return nil
end

function GameScene:getNiuType()
    local model = self.tableController_:getTable()
    local rules = model:getRuleDetails()
    local niuType = rules.detailType
    return niuType
end

function GameScene:getTable()
    return self.tableController_:getTable()
end

function GameScene:initCuoPokerView(data)
    local function callfunc()
        self.tableController_:doFanPai(data)
        self.cuoPokerView_:removeSelf()
        self.cuoPokerView_ = nil
    end
    self.cuoPokerView_ = CuoPokerView.new(data.handCards[5],callfunc):addTo(self.window_)
end

return GameScene
