local TaskQueue = require("app.controllers.TaskQueue")
local BaseScene = import("app.scenes.BaseScene")
local GameScene = class("GameScene", BaseScene)
local PlayerInfoView = import("app.views.PlayerInfoView")
local SanRenDingWei = import("app.views.SanRenDingWei")
local DismissRoomView = import("app.views.game.DismissRoomView")
local WenZiYuYin = import("app.views.WenZiYuYin")
local TableController = import("app.games.niuniu.controllers.TableController")
local CuoPokerView = import("app.views.game.CuoPokerView")
local BaseAlgorithm = import("app.games.niuniu.utils.BaseAlgorithm")
local BIRD_SPACE_SECONDS = 1

function GameScene:ctor()
    GameScene.super.ctor(self)
    dataCenter:tryConnectSocket()
    self.name = "NIUNIU"
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
    app:initMusicState_()
    self.isCuoPai = false
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

function GameScene:initPlayerInfoView(data)
    local view = PlayerInfoView.new(data,GAME_BCNIUNIU):addTo(self)
    view:showInGameScenes()
    view:tanChuang(150)
end

function GameScene:addGameView(view)
    self.gameNode_:addChild(view)
end

function GameScene:onEnterTransitionFinish()
    self.tableController_ = TableController.new()
    GameScene.super.onEnterTransitionFinish(self)
    dataCenter:resumeSocketMessage()
end

function GameScene:bindSocketListeners()
    GameScene.super.bindSocketListeners(self)
    local handlers = dataCenter:s2cCommandToNames {
        {COMMANDS.NIUNIU_GAME_START,handler(self, self.onGameStart_)},
        {COMMANDS.NIUNIU_ROUND_OVER, handler(self, self.onRoundOver_)},
        {COMMANDS.NIUNIU_GAME_OVER, handler(self, self.onGameOver_)},
        {COMMANDS.NIUNIU_READY, handler(self, self.onReady_)},
        {COMMANDS.NIUNIU_LEAVE_ROOM, handler(self, self.onLeaveRoom_)},
        {COMMANDS.NIUNIU_PLAYER_ENTER_ROOM, handler(self, self.onPlayerEnterRoom_)},
        {COMMANDS.NIUNIU_REQUEST_DISMISS, handler(self, self.onDismissInRequest_)},
        {COMMANDS.NIUNIU_PRE_ROOM_INFO, handler(self, self.onPreRoomInfo_)},
        {COMMANDS.NIUNIU_ROOM_INFO, handler(self, self.onRoomInfo_)},
        {COMMANDS.NIUNIU_DING_ZHUANG, handler(self, self.onDingZhuang_)},
        {COMMANDS.NIUNIU_ROUND_FLOW, handler(self, self.onRoundFlow_)},
        {COMMANDS.NIUNIU_CALL_SCORE, handler(self, self.onCallScore_)},
        {COMMANDS.NIUNIU_KAI_PAI, handler(self, self.onKaiPaiHandler_)},
        {COMMANDS.NIUNIU_QIANG_ZHUANG, handler(self, self.onQiangZhuangHandler_)},
        {COMMANDS.NIUNIU_DE_FEN, handler(self, self.onDeFenHandler_)},
        {COMMANDS.NIUNIU_CAN_CALL_LIST, handler(self, self.onCanCallListHandler_)},
        {COMMANDS.NIUNIU_BROADCAST, handler(self, self.onBroadcast_)},  -- 广播消息
        {COMMANDS.NIUNIU_ROUND_START, handler(self, self.onRoundStart_)},
        {COMMANDS.NIUNIU_FA_PAI, handler(self, self.onDealCards_)},
        {COMMANDS.NIUNIU_ONLINE_STATE, handler(self, self.onPlayerStateChanged_)},  -- 玩家网络事件广播
        {COMMANDS.NIUNIU_OWNER_DISMISS, handler(self, self.onOwnerDismiss_)},
        {COMMANDS.NIUNIU_SERVER_FAN_PAI, handler(self, self.onServerFanPai_)},
    }
    gailun.EventUtils.create(self, dataCenter, self, handlers)
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

function GameScene:onDeFenHandler_(event)
    if event.data.isReview then
        self:doDeFen_(event.data)
    else
        TaskQueue.add(handler(self, self.doDeFen_), 0, 0, event.data)
    end
end

function GameScene:doDeFen_(data)
   local wins = {}
   local loses = {}
   local zhuangSeatID = self.tableController_:getTable():getDealerSeatID()
   local zhuangPlayer = self.tableController_:getPlayerBySeatID(zhuangSeatID)
   for k,v in pairs(data) do
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
        TaskQueue.add(handler(self.tableController_, self.tableController_.doKaiPai), 0, 0, event.data)
    end
end

function GameScene:onQiangZhuangHandler_(event)
    if event.data.isReview then
        self.tableController_:doQiangZhuang(event.data)
    else
        TaskQueue.add(handler(self.tableController_, self.tableController_.doQiangZhuang), 0, 0, event.data)
    end
end

function GameScene:onCallScore_(event)
    if event.data.isReview then
        self.tableController_:doCallScore(event.data)
    else
        TaskQueue.add(handler(self.tableController_, self.tableController_.doCallScore), 0, 0, event.data)
    end
end

function GameScene:onRoundFlow_(event)
    if event.data.isReview then
        self.tableController_:onRoundFlow(event.data)
    else
        TaskQueue.add(handler(self.tableController_, self.tableController_.onRoundFlow), 0, 0, event.data)
    end
end

function GameScene:onDingZhuang_(event)
    -- self.tableController_:gameStart()
    if event.data.isReview then
        self.tableController_:doDingZhuang(event.data)
    else
        TaskQueue.add(handler(self.tableController_, self.tableController_.doDingZhuang), 0, 0, event.data)
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
    self.tableController_:doPreRoomInfo(event.data)
end

function GameScene:onRoomInfo_(event)
    gameLocalData:setGameRecordID(event.data.config.recordID)
    dataCenter:setOwner(event.data.creator)
    TaskQueue.removeAll()
    self.roomInfo_ = event.data
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
    TaskQueue.add(handler(self, self.doRoundReview_), 0, 0, clone(event.data))
end

function GameScene:doRoundReview_(data)
    self.tableController_:stopTimer()
    self.tableController_:nextStart()
    local pokerTable = self.tableController_:getTable()
    local rankCount = 0
    local winnerIndex
    local loses = {}
    local deleTime = 1
    self:performWithDelay(function()
        for _,v in pairs(checktable(data.seats)) do
            local p = self.tableController_:getPlayerBySeatID(v.seatID)
            if p then
                p:setScore(v.totalScore, v.score)
            end
        end
    end, deleTime)
    if not self.tableController_:isStanding() then
        -- 不用自动准备
        -- self:performWithDelay(function()
        --     dataCenter:sendOverSocket(COMMANDS.NIUNIU_READY)
        -- end, 10)
    -- else
    --     self.tableController_:clearStanding()
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
    event.data.roomInfo = self.roomInfo_
    TaskQueue.add(handler(self, self.doGameOver_), 3, 0, event.data)
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
end

function GameScene:showGameOver_()
    if not self.gameOverData_ then
        return
    end
    local data = self.gameOverData_
    self.tableController_:doGameOver(data)
    self.isOpenWindow_ = true
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
    if self.tableController_:isStanding() then
        self.tableController_:showCard_()
    end
end

function GameScene:onNotifyLocation_(event)
    print("onNotifyLocation_")
    if not event.data then
        return
    end 
    SanRenDingWei.new(params,distances,iskaiju,GAME_BCNIUNIU):addTo(self.window_)
end

function GameScene:onDealCards_(event)
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
    dataCenter:sendOverSocket(COMMANDS.NIUNIU_REQUEST_DISMISS, {agree = isAgree})
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
