local PlayerController = import(".PlayerController")
local BaseController = import("app.controllers.BaseController")
local TableController = class("TableController", BaseController)
local BaseAlgorithm = import("app.games.hhqmt.utils.BaseAlgorithm")
local TaskQueue = require("app.controllers.TaskQueue")
local TableModel = import("app.games.hhqmt.models.PokerTable")
local PaoHuZiAlgorithm = require("app.games.hhqmt.utils.PaoHuZiAlgorithm")
local HOST_POSITION_INDEX = 1  -- 主机玩家的位置固定为1号

local ZHUANG = 1
local XIAN = 2

local TABLE_CHECKOUT = 3 --结算中
local TABLE_PLAYING = 2 --游戏进行中
local TABLE_READY = 1 --准备中
local TABLE_IDLE = 0  --空闲

-- local TABLE_TIME = 
-- {
--     -- delaySeconds, afterSeconds
--     onPlayerPass_ = {0, 0},
--     onAllPass_ = {0, 1},
--     onDealCards_ = {0, 2},
--     onPlayerChuPai_ = {0, 2},
--     onNotifyHu_ = {0, 0.5},
--     onEveryonePass_ = {0, 0.5},
--     onPlayerMoPai_ = {2, 2},
--     onUserHu_ = {0, 0},
--     onUserPao_ = {0, 3},
--     onUserWei_ = {2, 3},
--     onUserChi_ = {0, 0},
--     onUserPeng_ = {0, 0},
--     onUserTi_ = {2, 2},
--     onFirstHandTi_ = {0, 2},
--     onTianHuEnd_ = {0, 2},
--     onTianHuStart_ = {0, 2},
--     onRoundStart_ = {0, 2},
--     onTurnTo_ = {0, 0}
-- }

local TABLE_TIME = 
{
    -- delaySeconds, afterSeconds
    onPlayerPass_ = {0, 0},
    onAllPass_ = {0, 0},
    onDealCards_ = {0, 0.8},
    onPlayerChuPai_ = {0, 0.7},
    onNotifyHu_ = {0, 0},
    onEveryonePass_ = {0, 1},
    onPlayerMoPai_ = {0, 1},
    onUserHu_ = {0, 0},
    onUserPao_ = {0, 1},
    onUserWei_ = {0, 0},
    onUserChi_ = {0, 0},
    onUserPeng_ = {0, 0},
    onUserTi_ = {0, 1},
    onFirstHandTi_ = {0, 1.5},
    onTianHuEnd_ = {0, 0.5},
    onTianHuStart_ = {0, 0.5},
    onRoundStart_ = {0, 0},
    onTurnTo_ = {0, 0}
}

function TableController:ctor()
    self.table_ = TableModel.new() 
    self:init_()
    self.isTurnStart_ = false
end

function TableController:setScene(scene)
    self.scene_ = scene
end

function TableController:init_()
    self.tableView_ = app:createConcreteView("game.TableView", self.table_):addTo(self)

    self.nodePlayers_ = self.tableView_.nodePlayers_
    self.maxPlayer_ = self.table_:getMaxPlayer()
    self.hostSeatID_ = nil
    self:createSeats_(self.maxPlayer_)
    self.actionButtonsController_ = app:createConcreteController("ActionButtonsController"):addTo(self):hide()
    self.actionButtonsController_:setTable(self.table_)
end

function TableController:getProgreesView()
    return self.tableView_:getProgreesView()
end

function TableController:onEnter()
    local handlers = dataCenter:s2cCommandToNames { 
        {COMMANDS.HHQMT_ROUND_START, handler(self, self.onRoundStart_)},
        {COMMANDS.HHQMT_TURN_TO, handler(self, self.onTurnTo_)},
        {COMMANDS.HHQMT_CHU_PAI, handler(self, self.onPlayerChuPai_)},
        {COMMANDS.HHQMT_PLAYER_PASS, handler(self, self.onPlayerPass_)},
        {COMMANDS.HHQMT_BROADCAST, handler(self, self.onBroadcast_)},  -- 广播消息
        {COMMANDS.HHQMT_ONLINE_STATE, handler(self, self.onPlayerStateChanged_)},  -- 玩家网络事件广播

        {COMMANDS.HHQMT_DEAL_CARD, handler(self, self.onDealCards_)},  -- 发牌
        {COMMANDS.HHQMT_TIAN_HU_START, handler(self, self.onTianHuStart_)},  -- 开始天胡 
        {COMMANDS.HHQMT_TIAN_HU_END, handler(self, self.onTianHuEnd_)},  -- 开始结束 
        {COMMANDS.HHQMT_USER_TI, handler(self, self.onUserTi_)},  -- 玩家提 
        {COMMANDS.HHQMT_USER_PAO, handler(self, self.onUserPao_)},  -- 玩家跑
        {COMMANDS.HHQMT_USER_WEI, handler(self, self.onUserWei_)},  -- 玩家偎牌 
        {COMMANDS.HHQMT_USER_HU, handler(self, self.onUserHu_)},  -- 胡牌
        {COMMANDS.HHQMT_USER_CHI, handler(self, self.onUserChi_)},  -- 吃牌
        {COMMANDS.HHQMT_USER_PENG, handler(self, self.onUserPeng_)},  -- 碰牌
        {COMMANDS.HHQMT_USER_MO_PAI, handler(self, self.onPlayerMoPai_)},  
        {COMMANDS.HHQMT_ALL_PASS, handler(self, self.onAllPass_)},
        {COMMANDS.HHQMT_NOTIFY_HU, handler(self, self.onNotifyHu_)},  -- 通知胡牌请求
        {COMMANDS.HHQMT_OWNER_DISMISS, handler(self, self.onOwnerDismiss_)},
        {COMMANDS.HHQMT_FIRST_HAND_TI, handler(self, self.onFirstHandTi_)},
        {COMMANDS.HHQMT_HU_PASS, handler(self, self.onHuPass_)} 
    }
    gailun.EventUtils.create(self, dataCenter, self, handlers)
 
    
    self.doFlowList_ = {
        [T_IN_IDLE] = handler(self, self.doFlowInIDLE_),
        [T_IN_TIAN_HU] = handler(self, self.doFlowInTianHu_),
        [T_IN_CHU_PAI] = handler(self, self.doFlowInChuPai_),
        [T_IN_CHU_PAI_CALL] = handler(self, self.doFlowInChuPaiCall_),
        [T_IN_MO_PAI] = handler(self, self.doFlowInMoPai_),
        [T_IN_MO_PAI_CALL] = handler(self, self.doFlowInMoPaiCall_),
    }
end

function TableController:initHostPlayerEvent_()
    gailun.EventUtils.clear(self.hostPlayer_)
    local handlers = {
        {self.hostPlayer_.SIT_DOWN_EVENT, handler(self, self.onHostPlayerSitDown_)},
        {self.hostPlayer_.STAND_UP_EVENT, handler(self, self.onHostPlayerStandUp_)},
        {self.hostPlayer_.ON_CHUPAI_EVENT, handler(self, self.onChuPaiEvent_)},
        {self.hostPlayer_.ON_CHI_EVENT, handler(self, self.onChiPaiEvent_)},
        {self.hostPlayer_.ON_PENG_EVENT, handler(self, self.onPengPaiEvent_)},
        {self.hostPlayer_.ON_SHOWHIGHTLIGHT_EVENT, handler(self, self.onHightLightPaiEvent_)},
    }
    gailun.EventUtils.create(self, self.hostPlayer_, self, handlers)
end

function TableController:taskRemoveAll()
    TaskQueue.removeAll()
end

function TableController:isMyTable()
    return self.hostPlayer_:getUid() == self.table_:getOwner()
end

function TableController:onOwnerDismiss_(event)
    if event.data.code == 0 then
        dataCenter:setRoomID(0)
        dataCenter:setOwner(0)
        if self.table_:getClubID() > 0 then
            local params = {}
            params.clubID = self.table_:getClubID()
            httpMessage.requestClubHttp(params, httpMessage.GET_CLUB_INFO)
            return
        end
        app:enterHallScene()
    end
end

function TableController:onTurnStart_(event)
    self.isTurnStart_ = true
end

function TableController:onChuPaiEvent_(event)
    local data = {cards = event.card}
    dataCenter:sendOverSocket(COMMANDS.HHQMT_CHU_PAI, data)
end

function TableController:onPengPaiEvent_(event)
end 

function TableController:setScore(score)
    for i,v in ipairs(self.seats_) do
        v.view_:setScore(v:getScore() + score)
    end
end

function TableController:onHightLightPaiEvent_(event)
      self.seats_[1].view_:showHightLight(event.card, event.isHigh)
      self.seats_[2].view_:showHightLight(event.card, event.isHigh)
      self.seats_[3].view_:showHightLight(event.card, event.isHigh)
end 

function TableController:onChiPaiEvent_(event)
end 

function TableController:onExit()
    gailun.EventUtils.clear(self)
end

function TableController:getSeats()
    return self.seats_
end

function TableController:setRoomPlayerCount_()
    local count = 0
    for k,v in pairs(self.seats_) do
        if v:getPlayer():getUid() > 0 then
            count = count + 1
        end
    end
    self.table_:setCurrPlayerCount(count)
end

function TableController:showCurrFlow_(flow,data)
    self.doFlowList_[flow](flow,data)
end

function TableController:showActions(chi,peng,hu)
    self.actionButtonsController_:showActions(chi,peng,hu)
end

function TableController:doLeaveRoom(uid)
    local player = self:getPlayerById(uid)
    if not player then
        return
    end
    player:standUp()
    self.seats_[player:getSeatID()]:setUid(0)
    self:setRoomPlayerCount_()
    self:setSeatsVisible()
end

function TableController:doPlayerPass_(data)
    if data.code ~= 0  then
        print("没有轮到你操作")
        return 
    end
    self.actionButtonsController_:hideSelf()
    self.hostPlayer_:pass(data)
end

function TableController:onPlayerPass_(event)
    if event.data.isReview then
        self:doPlayerPass_(event.data)
    else
        TaskQueue.add(handler(self, self.doPlayerPass_), TABLE_TIME.onPlayerPass_[1], TABLE_TIME.onPlayerPass_[2], event.data)
    end
end

function TableController:doAllPass_(data)
    self.actionButtonsController_:hideSelf()
    local player = self:getPlayerBySeatID(data.seatID)
    if not player then
        return
    end
    local card = data.card
    self.table_:setCurCards(0,false)
    local index = self:calcPlayerIndex(data.seatID)
    player:doAllPass(data.card,index,data.inFastMode) -- 弃牌
    for k,v in pairs(self.seats_) do
        v:pass()
    end
end

function TableController:onAllPass_(event)
    if event.data.isReview then
        self:doAllPass_(event.data)
    else
        -- self:doAllPass_(event.data)
        TaskQueue.add(handler(self, self.doAllPass_), TABLE_TIME.onAllPass_[1], TABLE_TIME.onAllPass_[2], event.data)
    end
end
--[[
"<var>" = {
    "data" = {
        "action"      = "chat"
        "messageData" = 12
        "messageType" = 1
        "seatID"      = 1
    }
    "uid"  = 46495143
}
]]
function TableController:onBroadcast_(event)
    if not event.data then
        return
    end
    local data = event.data
    if data.data.action == "chat" then
        self:onPlayerChat_(data.uid, data.data)
    else
        print(data.action)
    end
end

function TableController:onPlayerStateChanged_(event)
    local player = self:getPlayerById(event.data.uid)
    if not player then
        return
    end
    player:setOffline(event.data.offline, event.data.IP)
end

function TableController:onPlayerChat_(uid, params)
    local player, toPlayer
    if params.seatID then
        player = self.seats_[params.seatID]
    end
    if params.toSeatID then
        toPlayer = self.seats_[params.toSeatID]
    end
    if not player then
        player = self:getPlayerById(uid)
    end
    if not player then
        print("TableController:onPlayerChat_(uid, params) fail!!!!")
        return
    end
    self.tableView_:showPlayerChat(player, params, toPlayer)
end

function TableController:onPlayerReady(seatID, isReady)
    if not seatID then
        return -- 服务器2次返回 第2次seatID空
    end
    local player = self:getPlayerBySeatID(seatID)
    if not player and seatID then
        printError("onPlayerReady with empty player!")
        return
    end
    player:doReady(isReady)
    player:showReady_(isReady)
    local isHost = seatID == self.hostPlayer_:getSeatID()
    if isHost then
        self:clearAfterRoundOver_()
    end
end

function TableController:clearAfterRoundOver_()
    self:resetRoundPlayer_()
end

function TableController:inShowActions()
    return self.actionButtonsController_:inShowActions()
end

function TableController:reShowCard()
    self.hostPlayer_:reCards()
end

function TableController:getAllCard()
    local allCardInfo = {{},{},{}}
    for i = 1, 3 do
        local player = self:getPlayerBySeatID(i)
        allCardInfo[i].chuCards = player:getChuCards()
        allCardInfo[i].zhuoCards = player:getZhuoCards()
        allCardInfo[i].handCards = player:getMyHandCards()
    end
    return allCardInfo
end

function TableController:clearAllCard()
    for i = 1, 3 do
        local player = self:getPlayerBySeatID(i)
        player:clearAllCard()
    end
    self.tableView_:doTPTS_({need = false})
end

function TableController:doDealCards_(data)
    self.hostPlayer_:dealCards(data.handCards)
    self.table_:setDealerSeatID(data.dealerSeatID)
    self.tableView_:stopTimer()
    self:checkHu()
end

function TableController:onDealCards_(event)
    if event.data.isReview then
        self:doDealCards_(event.data)
    else
        TaskQueue.add(handler(self, self.doDealCards_), TABLE_TIME.onDealCards_[1], TABLE_TIME.onDealCards_[2], event.data)
    end
end

function TableController:getMaxPlayer()
    return self.table_:getMaxPlayer()
end

function TableController:doRoomInfo(data)
    self.table_:setData(data)
    self.table_:setMatchType(data.config.matchType)
    self.table_:setMaxPlayer(data.config.rules.totalSeat or 3)
    if data.config.rules.totalSeat == 3 then
        display.getRunningScene():setBtnIsInGame()
    end
    if data.config.rules.totalSeat == 2 then
        self:changeUserPosByRule_()
    end
    self:showRuleInfo(data.config.rules)
    if data.status ~= TABLE_IDLE then
        self.table_:doEventForce("roundstart")
    end
    if data.status == TABLE_CHECKOUT then
        self.table_:doEventForce("roundover")
        for _,v in ipairs(self.seats_) do
            v:doRoundOver()
        end
        local seatID = self.hostPlayer_:getSeatID()
        -- self:onPlayerReady(seatID, true)
    end
    self.table_:setTid(data.tid or dataCenter:getRoomID())
    self.table_:setConfigData(data.config)
    self.table_:setOwner(data.creator or 0)
    self.table_:setFinishRound(data.roundIndex or 0,data.config.juShu)
    if data.creator == self.hostPlayer_:getUid() then
        dataCenter:setOwner(data.creator or 0)
    end
    TaskQueue.removeAll()
    if data.status ~= TABLE_PLAYING then  -- 空闲中
        self.table_:setStatus(data.status)
        self.hostPlayer_:showReady_(self.hostPlayer_:getIsReady())
        self.hostPlayer_:removeAllCards_()
        return
    end
    self:doResumeRoomInfo_(data)
end

function TableController:doResumeRoomInfo_(data)
    display.getRunningScene():setBtnIsInGame()
    self.table_:setDealerSeatID(data.dealer)
    if data.dealer ~= -1 then
        for k, player in ipairs(self.seats_) do
            if player:getSeatID() == data.dealer then
                player:setDealer(true)
            else
                player:setDealer(false)
            end
        end
    end
    if data.inFlow and data.inFlow > 0  then
        if not data.isReview  then
            self:showCurrFlow_(data.inFlow, data)
        end
    end

    self.table_:setLeftCards(data.leftCount)
    if data.operateSeats then
        for _,v in pairs(data.operateSeats) do
            if v == self.hostPlayer_:getSeatID() then
                self.actionButtonsController_:hideSelf()
                self.hostPlayer_:pass()
            end
        end
    end
end

function TableController:doFlowInIDLE_(data)
    print("doFlowInIDLE_")
end

function TableController:doFlowInTianHu_(flow,tianhudata)
    print("doFlowInTianHu_")
    local data = {card = tianhudata.currCard}
    self:doTianHuStart_({data = data})
end

function TableController:doFlowInChuPai_(flow,data)
    print("doFlowInChuPai_")
    self.actionButtonsController_:hideSelf()
    local data = {seatID = data.currSeatID,remainTime = data.remainSeconds}
    self:doTurnTo_(data)
end

function TableController:doFlowInChuPaiCall_(flow,data)
    print("doFlowInChuPaiCall_")   
    local index = self:calcPlayerIndex(data.currSeatID)
    self.table_:setCurCards(data.currCard, index, false)
    print("setcurrcard")

    for k, player in ipairs(self.seats_) do
        if player:getSeatID() ~= data.seatID then
            player:doFindChuPai(cards)
        else
            print("tab dochpai "..cards)
            player:doChuPai(cards)
        end
    end
    self:checkHu()
end

function TableController:doFlowInMoPai_(flow,data)
    print("doFlowInMoPai_")
end

function TableController:doFlowInMoPaiCall_(flow,data)
     print("T_IN_MO_PAI_CALL")
    local index = self:calcPlayerIndex(data.currSeatID)
    self.table_:setCurCards(data.currCard,index, true)    
    print("mopaisetcurrcard")

    for k, player in ipairs(self.seats_) do
        player:doMoPai(data.currCard)
    end
end

function TableController:resumeChuPai_(turnCards)
    local turnCards = turnCards or {}
    local lastHands = {}
    if turnCards[#turnCards] then
        lastHands = turnCards[#turnCards][2]
    end

    local index = self:calcPlayerIndex(data.seatID)  
    self.table_:setCurCards(lastHands, index, false)

    for i = #turnCards - 2, #turnCards do
        local v = turnCards[i]
        if v then
            local player = self:getPlayerBySeatID(v[1])
            player:doTurnto(v[2], true)
        end
    end
end

-- function TableController:resumePlayerStates_()
--     for _, player in ipairs(self.seats_) do
--         player:doRoundStart(true)resumePlayerStates_
--     end
-- end

function TableController:makeRuleString(spliter)
    local ret = self.tableView_:makeRuleString(spliter or ",")
    ret = tostring(ret)
    local ret1 = self.tableView_:makeAddRuleString(spliter or ",")
    ret1 = tostring(ret1)
    return ret .. (spliter or "") .. ret1
end

function TableController:makeGameOverString(spliter)
    local ret = self.tableView_:makeRuleString(spliter or ",")
    ret = tostring(ret)
    local ret1 = self.tableView_:makeAddRuleString(spliter or ",")
    ret1 = tostring(ret1)
    return ret, ret1
end

function TableController:makeShareRuleString(spliter)
    local ret = self.tableView_:makeRuleString(spliter or ",")
    ret = tostring(ret)
    local ret1 = self.tableView_:makeAddRuleString(spliter or ",")
    ret1 = tostring(ret1)
    ret = ret .. (spliter or "")
    if ret1 ~= "" then
        ret1 = "[".. ret1 .. "]" .. (spliter or "")
        ret = ret .. ret1
    end
    return ret
end

-- 断线重连
function TableController:resumePlayer_(player, data, isReview)
    player:setIsReady(data.isPrepare)
    player:showReady_(data.isPrepare)
    if player:isHost() then
        --display.getRunningScene():setPlayerIsReady(data.isPrepare)
    end
    if data.status ~= 2 then
        self:checkHu()
        return
    end
    player:showReady_(false)
    display.getRunningScene():setBtnIsInGame()
    player:doReconnectStart(true)
    player:setScore(data.score)
    -- 恢复手牌
    local cards = data.shouPai
    player:setCards(cards, not isReview)

    player:setZhuoCards(data.zhuoPai)
    player:setChuCards(data.chuPai)
    -- 恢复各种标志
    player:setDealer(data.dealer, true)
    dump(data,"datadatadatadata")
    player:setOffline(data.offline, data.IP, data.lastOfflineTime)

    --玩家显示操作 摸牌
    local operates = data.operates
    if operates then
        self.actionButtonsController_:showCanActions(operates)
    end

    if isReview then
        self.table_:setReviewHandCards(data.seatID, cards)
    end
    self:checkHu()
end

function TableController:calcNextSeatID_(seatID)
    local nextSeatID = seatID + 1
    if nextSeatID <= 4 then
        return nextSeatID
    end
    return 1
end

function TableController:doPlayerChuPai_(data)
    -- dump(data)
    if not data or not data.seatID then
        print("doPlayerChuPai_(not data)")
        return
    end
    if data.code == -8 then
        print("doPlayerChuPai_(data) -8")
        return
    end
    if data.code == -1 then
        print("doPlayerChuPai_(data) -1")
        return
    end
    dump(data.isReview,"data.isReviewdata.isReview")
    if self.hostPlayer_ and self.hostPlayer_:getSeatID() == data.seatID then
        return
    end
    self:doPlayerChuPai(data)
end


function TableController:doPlayerChuPai(data)
    local cards = data.cards
    local player = self:getPlayerBySeatID(data.seatID)
    if not player then
        return
    end
    
    if data.isReview then
        self.table_:doReviewChuPai(data.seatID, cards)
    end

    self.actionButtonsController_:hideSelf()
    --桌面显示公共牌
    local index = self:calcPlayerIndex(data.seatID)
    self.table_:setCurCards(data.cards,index, false)
    self.tableView_:stopTimer()

    --玩家显示操作 摸牌
    for k, player in ipairs(self.seats_) do
        if player:getSeatID() ~= data.seatID then
            player:doFindChuPai(cards)
        else
            player:doChuPai(cards, data.inFastMode, data.isReview)
        end
    end

    if not data.isReview then
        local operates = data.operates
        if #operates  > 0 then
            self.actionButtonsController_:showCanActions(operates)
        else
            print("chupai no operations")
            self.actionButtonsController_:hideSelf()        
            self.hostPlayer_:pass()
        end
    end
    self:checkHu()
end

function TableController:onPlayerChuPai_(event)
    if event.data.isReview then
        self:doPlayerChuPai_(event.data)
    else
        if event.data.code == 0 then
            TaskQueue.add(handler(self, self.doPlayerChuPai_), TABLE_TIME.onPlayerChuPai_[1], TABLE_TIME.onPlayerChuPai_[2], event.data)
        end
    end
end
     
-- 玩家提牌
function TableController:onNotifyHu_(event)
    if event.data.isReview then
        self:doNotifyHu_(event.data)
    else
        TaskQueue.add(handler(self, self.doNotifyHu_), TABLE_TIME.onNotifyHu_[1], TABLE_TIME.onNotifyHu_[2], event.data)
    end
end


function TableController:doNotifyHu_(data)
    if not data or not data.seatID then
        return
    end
    local cards = data.cards
    local player = self:getPlayerBySeatID(data.seatID)
    if not player then
        return
    end 
    --结算 
    local operates = {3}
    self.actionButtonsController_:showCanActions(operates)
    for k, player in ipairs(self.seats_) do
        if player:getSeatID() ~= data.seatID then
            player:doNotifyHu(cards)
        else
            player:doNotifyHu(cards)
        end
    end
end


-- 玩家提牌
function TableController:onEveryonePass_(event)
    if event.data.isReview then
        self:doUserPao_(event.data)
    else
        TaskQueue.add(handler(self, self.doUserPao_), TABLE_TIME.onEveryonePass_[1], TABLE_TIME.onEveryonePass_[2], event.data)
    end
end

function TableController:doPlayerMoPai_(data)
    print("用户摸牌"..data.card)
    dump(data,"ableController:doPlayerMoPai_")
    if not data or not data.seatID then
        return
    end
 
    --桌面显示公共牌
    local index = self:calcPlayerIndex(data.seatID)
    if not data.inFastMode then 
        self.table_:setCurCards(data.card,index, true)
    end
    self.table_:setLeftCards(data.leftCount)
    for k, player in ipairs(self.seats_) do
        player:doMoPai(data.card,data.seatID,data.inFastMode)
    end
     if not data.isReview then
        --玩家显示操作 摸牌
        local operates = data.operates
        if #operates > 0 then  
            self.actionButtonsController_:showCanActions(operates)
        else
            self.actionButtonsController_:hideSelf()
            self.hostPlayer_:pass()
        end
    end
    self:checkHu()
end

-- 玩家提牌
function TableController:onPlayerMoPai_(event)
    if event.data.isReview then
        self:doPlayerMoPai_(event.data)
    else
        local preTime = 0
        if event.data.isQuick == 1 then
            preTime = TABLE_TIME.onPlayerMoPai_[1]
        end
        TaskQueue.add(handler(self, self.doPlayerMoPai_), preTime, TABLE_TIME.onPlayerMoPai_[2], event.data)
    end
end

function TableController:doUserHu_(data)
    if not data or not data.seatID then
        return
    end 
    if data.isFinish == 0 and self.hostPlayer_:getSeatID() == data.seatID then
        self.actionButtonsController_:hideSelf()
        self.tableView_:stopTimer()
        return
    end 
end
function TableController:doHuPai(data)
    local huList = data.winInfo.huList
    if  not huList then
        return
    end
    local typeid = "100"
    if #huList > 0 then
        typeid = huList[1]
    end  
    local winner = data.winInfo.winner
    local player = self:getPlayerBySeatID(winner)
    if not player then
        print("noplayer")
        return
    end
    player:setHuPai(typeid)

end

-- 玩家提牌
function TableController:onUserHu_(event)
    if event.data.isReview then
        self:doUserHu_(event.data)
    else
        TaskQueue.add(handler(self, self.doUserHu_), TABLE_TIME.onUserHu_[1], TABLE_TIME.onUserHu_[2], event.data)
    end
end

function TableController:doUserPao_(data)
    if not data or not data.seatID then
        return
    end 
    self.actionButtonsController_:hideSelf()
    self.tableView_:stopTimer()
    local player = self:getPlayerBySeatID(data.seatID)
    if not player then
        return
    end

    if data.isReview then
        self.table_:doReviewPaoPai(data.seatID, data.card)
    end

    --移除当前牌
    self.table_:setCurCards(0)
    player:setPaoPai(data.card,data.index,data.isReview,data.inFastMode)
    for k, player in ipairs(self.seats_) do
        player:doFindPao()
    end
    self:checkHu()
    -- if not data.isTurnTo then
    --    
    -- end
end

-- 玩家提牌
function TableController:onUserPao_(event)
    if event.data.isReview then
        self:doUserPao_(event.data)
    else
        TaskQueue.add(handler(self, self.doUserPao_), TABLE_TIME.onUserPao_[1], TABLE_TIME.onUserPao_[2], event.data)
    end
end

-- 玩家偎牌
function TableController:doUserWei_(data)
    if not data or not data.seatID then
        return
    end 
    --self.actionButtonsController_:hideSelf()
    self.tableView_:stopTimer()
    local player = self:getPlayerBySeatID(data.seatID)
    if not player then
        return
    end

    self:refreshLeftCards_()
    if data.isReview then
        self.table_:doReviewWeiPai(data.seatID, data.card)
    end

    --移除当前牌
    self.table_:setCurCards(0)
    player:setWeiPai(data.isChou,data.card,index,data.inFastMode)

    for k, player in ipairs(self.seats_) do
        player:doFindWei(data.inFastMode)
    end
    self:checkHu()
end

-- 玩家偎牌
function TableController:onUserWei_(event)
    if event.data.isReview then
        self:doUserWei_(event.data)
    else
        local preTime = 0
        if event.data.isQuick == 1 then
            preTime = TABLE_TIME.onUserWei_[1]
        end
        TaskQueue.add(handler(self, self.doUserWei_), preTime, TABLE_TIME.onUserWei_[2], event.data)
    end
end

function TableController:doUserChi_(data)
    if not data or not data.seatID then
        return
    end 
    self.tableView_:stopTimer()
    self.actionButtonsController_:hideSelf()
 
    local player = self:getPlayerBySeatID(data.seatID)
    if not player then
        return
    end  
    if data.isFinish == 0 then
        return
    end

    if data.isReview then
        self.table_:doReviewChiPai(data.seatID, clone(data))
    end

    self.table_:setCurCards(0)
    -- dump(data)
    local chi = data.card
    local biPai = data.biPai
    for i = 1, #biPai do
        table.removebyvalue(biPai[i], chi)
        table.sort(biPai[i])
        table.insert(biPai[i], 1, chi)
    end
    dump(data.biPai,"biPaibiPaibiPaibiPai")
    dump(data.chiPai,"data.chiPaidata.chiPaidata.chiPai")
    player:doChiPai(data,data.inFastModeinFastMode)
    for k, player in ipairs(self.seats_) do
        if player:getSeatID() ~= data.seatID then
            player:doOtherChiPai(data.chiPai,data.biPai,data.card,data.inFastMode)
        end
    end
end

-- 玩家提牌
function TableController:onUserChi_(event)
    if event.data.isReview then
        self:doUserChi_(event.data)
    else
        TaskQueue.add(handler(self, self.doUserChi_), TABLE_TIME.onUserChi_[1], TABLE_TIME.onUserChi_[2], event.data)
        -- self:doUserChi_(event.data)
    end
end

function TableController:doUserPeng_(data)
    if not data or not data.seatID then
        return
    end 
    self.tableView_:stopTimer()
    self.actionButtonsController_:hideSelf()
    
    local player = self:getPlayerBySeatID(data.seatID)

    if not player then
        return
    end  
    if data.isFinish == 0 then
        return
    end

    if data.isReview then
        self.table_:doReviewPengPai(data.seatID, data.card)
    end

    --移除当前牌
    self.table_:setCurCards(0)
    local card = data.card
    player:doPengPai(card,data.inFastMode)

    for k, player in ipairs(self.seats_) do
        if player:getSeatID() ~= data.seatID then
            player:doOtherPengPai(card,data.inFastMode)
        end
    end
end

-- 玩家提牌
function TableController:onUserPeng_(event)
    if event.data.isReview then
        self:doUserPeng_(event.data)
    else
        -- self:doUserPeng_(event.data)
        TaskQueue.add(handler(self, self.doUserPeng_), TABLE_TIME.onUserPeng_[1], TABLE_TIME.onUserPeng_[2], event.data)
    end
end

function TableController:refreshLeftCards_()
    local leftCount = self.table_:getLeftCards()
    if (leftCount > 0) then
        self.table_:setLeftCards(leftCount - 1)
    end
end

-- 玩家提牌
function TableController:doUserTi_(data)
    if not data or not data.seatID then
        return
    end 
    local player = self:getPlayerBySeatID(data.seatID)
    if not player then
        return
    end

    self:refreshLeftCards_()
    if data.isReview then
        self.table_:doReviewTiPai(data.seatID, data.card)
    end

    --移除当前牌
    player:setTiPai(data.card,data.index,data.inFastMode)

    for k, player in ipairs(self.seats_) do
        player:doFindTi()
    end
    self:checkHu()
end

-- 玩家提牌
function TableController:onUserTi_(event)
    if event.data.isReview then
        self:doUserTi_(event.data)
    else
        local preTime = 0
        if event.data.isQuick == 1 then
            preTime = TABLE_TIME.onUserTi_[1]
        end
        TaskQueue.add(handler(self, self.doUserTi_), preTime, TABLE_TIME.onUserTi_[2], event.data)
    end 
end

-- 玩家提牌
function TableController:doFirstHandTi_(data)
    if not data or not data.seatID then
        return
    end 
    local player = self:getPlayerBySeatID(data.seatID)
    if not player then
        return
    end

    if data.isReview then
        self.table_:doReviewTiPai(data.seatID, clone(data.cards))
    end

    --移除当前牌
    player:setFirstHandTiPai(data.cards)
    self:checkHu()
    -- 

    -- for k, player in ipairs(self.seats_) do
    --     player:doFindFirstHandTi()
    -- end
end

-- 玩家提牌
function TableController:onFirstHandTi_(event)
    if event.data.isReview then
        self:doFirstHandTi_(event.data)
    else
        TaskQueue.add(handler(self, self.doFirstHandTi_), TABLE_TIME.onFirstHandTi_[1], TABLE_TIME.onFirstHandTi_[2], event.data)
    end 
end

function TableController:onHuPass_(event)
    if event.data.code == 0 then
        self:doHuPass_(event.data)
    end
end

function TableController:doHuPass_(data)
    self.actionButtonsController_:doHuPass(data)
end

function TableController:setFocusOn_(seatID)
    if not self.seats_[seatID] then
        return
    end
end

function TableController:doPlayerSitDown(params)
    local playerData = params
    local data = json.decode(playerData.data)
    assert(playerData and data.uid and playerData.seatID, "sitDown fail by error data")
    table.merge(playerData, data)
    local player = self:getPlayerBySeatID(params.seatID)
    if params.uid == selfData:getUid() then
        self.hostPlayer_ = player:getPlayer()
        self.actionButtonsController_:setHostPlayer(self.hostPlayer_)
        self:initHostPlayerEvent_()
        self.hostSeatID_ = player:getSeatID()
        player:setPaperCardList(self.tableView_.nodeHostMaJiang_)
    end
    player:sitDown(playerData)
    self:setRoomPlayerCount_()
    self:resumePlayer_(player, params)
    if params.isReview then return end
    self:setSeatsVisible()
end

-- 展示赢家的牌
function TableController:showPlayerCards(player, cards)
    if not cards then
        printInfo("showPlayerCards fail with no cards")
        return
    end
    if #cards ~= 2 then
        printInfo("showPlayerCards fail by cards not eq 2")
        return
    end
    local publicCards = self.table_:getPublicCards()
    if not publicCards or #publicCards ~= 5 then
        printInfo("showPlayerCards fail with publicCards not eq 5")
        return
    end
    local cards7 = clone(cards)
    table.insertto(cards7, publicCards)
    assert(cards7 and 7 == #cards7)
    local cards5, _ = MaJiangAlgorithm.search5In7ByServerCards(cards7)
    assert(cards5 and 5 == #cards5)
    player:showCards(cards)
    player:filterPokers(cards5)
    self.tableView_:filterPokers(cards5)
end

function TableController:onHostPlayerSitDown_(event)
    self:setHostSeatID_(self.hostPlayer_:getSeatID())
    self.hostPlayer_:setHostPlayer()
    print("onHostPlayerSitDown_"..self.hostPlayer_:getSeatID())
end

function TableController:onHostPlayerStandUp_(event)
    self:setHostSeatID_(nil)
end

function TableController:getPlayerBySeatID(seatID)
    return self.seats_[seatID]
end

function TableController:calcCanDoActions(...)
    return self.actionButtonsController_:calcCanDoActions(...)
end

function TableController:getPlayerById(id)
    if not id or id <= 0 then
        return
    end
    for _,v in pairs(self.seats_) do
        if v and v:getUid() == id then
            return v
        end
    end
end

function TableController:adjustMaJiang_(seatID, withMoPai, isDown)
    if not self.seats_[seatID] then
        return
    end
    local withMoPai = withMoPai or false
    if withMoPai then
        self.seats_[seatID]:adjustMaJiang(isDown)
    else
        self.seats_[seatID]:adjustMaJiangWithoutMoPai(isDown)
    end
end

function TableController:doAnte_(players)
    local ante = self.table_:getAnte()
    if ante <= 0 then
        return
    end

    local chips = 0
    self:callEveryPlayerOrderByRound(function (player)
        if false ~= table.indexof(players, player:getSeatID()) then
            chips = chips + self:doPlayerBet_(player, ante, true)
        end
    end)
    -- self.checkOutController_:collectChips({{value = 0, chips = chips}})
end

function TableController:createSeats_(number)
    self.seats_ = {}
    local number = number or 3 -- 默认3人桌
    for i=1, number do
        self.seats_[i] = PlayerController.new(i):addTo(self.nodePlayers_)
    end
end

function TableController:listeningAvatarClicked(callback)
    for _,v in ipairs(self.seats_) do
        v:setAvatarCallback(callback)
    end
end

function TableController:isHost(player)
    if not player or not self.hostSeatID_ or self.hostSeatID_ < 1 or self.hostSeatID_ > self.maxPlayer_ then
        return false
    end
    if type(player) == "number" then
        return player == self.hostSeatID_
    end
    return player:getSeatID() == self.hostSeatID_
end

function TableController:calcPlayerIndex(seatID)
    if not self.hostSeatID_ or self.hostSeatID_ < 1 or self.hostSeatID_ > self.maxPlayer_ then
        return seatID  -- 没有主玩家时，直接返回对应坐号
    end
    if self.hostSeatID_ == seatID then
        return HOST_POSITION_INDEX
    end
    local index = HOST_POSITION_INDEX + (seatID - self.hostSeatID_)
    if index > self.maxPlayer_ then
        index = index - self.maxPlayer_
    elseif index < 1 then
        index = index + self.maxPlayer_
    end
    return index
end

function TableController:setHostSeatID_(seatID)
    self.hostSeatID_ = seatID
    self:adjustSeatsPosition_()
end

function TableController:adjustSeatsPosition_(isReConnect)
    for k,v in pairs(self.seats_) do
        local index = self:calcPlayerIndex(k)
        v:setIndex(index, isReConnect)
    end
    -- self.checkOutController_:adjustBetPosition()

    local dealer = self.table_:getDealerSeatID()
    if dealer > 0 and self.seats_[dealer] then
        self.tableView_:onAdjustSeats(dealer)
    end
end

function TableController:setSeatsVisible()
    if self.hostPlayer_:isSitDown() then
        for _,v in pairs(self.seats_) do
            print("========v:isEmpty()========",v:isEmpty())
            if v:isEmpty() then
                v:hide()
            end
        end
    else
        self:showAllSeats()
    end
end

function TableController:showAllSeats()
    for k,v in pairs(self.seats_) do
        v:show()
    end
end

function TableController:searchEmptySeatID()
    local seats = {}
    for k,v in pairs(self.seats_) do
        if v:isEmpty() then
            table.insert(seats, v:getSeatID())
        end
    end
    if #seats <= 0 then
        return
    end
    return seats[math.random(1, #seats)]
end

-- 依次call玩家，顺序为从小盲位开始
function TableController:callEveryPlayerOrderByRound(func)
    local dealerSeatID = self.table_:getDealerSeatID()
    local callfunc = function (player)
        if player and not player:isEmpty() then
            if func then func(player) end
        end
    end
    for i = dealerSeatID + 1, self.table_:getMaxPlayer() do
        callfunc(self.seats_[i])
    end
    for i = 1, dealerSeatID do
        callfunc(self.seats_[i])
    end
end

function TableController:calcLeftCards_()
    local TOTAL_MAJIANG = 108
    local TOTAL_MAJIANG_NAI_ZI = 112
    local TOTAL_SEND = 53
    return TOTAL_MAJIANG - TOTAL_SEND
end

function TableController:stopTimer()
    self.tableView_:stopTimer()
end

function TableController:hideActionBar()
    self.actionButtonsController_:hideSelf()
end

function TableController:doTianHuStart_(data)
    local index = self:calcPlayerIndex(self.table_:getDealerSeatID())
    self.table_:setCurCards(data.card, index, true)
    self.table_:setTianHuStart(true)
    -- 玩家显示操作 摸牌
    local operates = data.operates
    if operates then
        self.actionButtonsController_:showCanActions(operates)
    end
    dump(data,"datadatadatadatadatadatadatadata")
    self.table_:setLeftCards(data.leftCardCount)
    for i,player in ipairs(self.seats_) do
        if player:isHost() then
            player:doTianHuStart(data.card)
            return
        end
    end
end

function TableController:doTianhuEnd_(data)
    --收张
    if data.isReview then
        -- local p = self:getPlayerBySeatID(self.table_:getDealerSeatID())
        -- p:shouzhang(self.table_:getCurCards(), data.isReview )
        self.table_:doReviewShouZhang(self.table_:getDealerSeatID(), self.table_:getCurCards())
    else
        if self.table_:getDealerSeatID() ==  self.hostPlayer_:getSeatID() then
            self.hostPlayer_:shouzhang(self.table_:getCurCards())
        end
    end
    self.table_:setCurCards(0)
    self.table_:setTianHuStart(false)
    for i,player in ipairs(self.seats_) do
        player:doTianHuEnd()
    end
end
 
function TableController:onTianHuEnd_(event)
    if event.data.isReview then
        self:doTianhuEnd_(event.data)
    else
        TaskQueue.add(handler(self, self.doTianhuEnd_), TABLE_TIME.onTianHuEnd_[1], TABLE_TIME.onTianHuEnd_[2], event.data)
    end
end

function TableController:onTianHuStart_(event)
    if event.data.isReview then
        self:doTianHuStart_(event.data)
    else
        TaskQueue.add(handler(self, self.doTianHuStart_), TABLE_TIME.onTianHuStart_[1], TABLE_TIME.onTianHuStart_[2], event.data)
    end
end

function TableController:onRoundStart_(event)
    dump(event.data,"TableController:onRoundStart_123")
    TaskQueue.continue()
    if event.data.isReview then
        self:doRoundStart_(event.data)
    else
        TaskQueue.add(handler(self, self.doRoundStart_), TABLE_TIME.onRoundStart_[1], TABLE_TIME.onRoundStart_[2], event.data)
    end
end 

function TableController:playersRoundStart_()
    for i,v in ipairs(self.seats_) do
        v:doRoundStart()
    end
end

function TableController:doRoundStart_(data)
    self.table_:setDealerSeatID(data.dealerSeatID)
    self.table_:doRoundStart()
    self:playersRoundStart_()
    
    self.table_:setFinishRound(data.seq)
    -- self.table_:saveLastCard(0, 0)
    self.actionButtonsController_:hideSelf()
end

-- 结算过程
function TableController:doRoundOver(data)
    self.actionButtonsController_:hideSelf()
    self:clearFocus_()
    self.table_:doRoundOver(data)
end

function TableController:doGameOver(data)
    self:clearFocus_()
end

local blankCards13 = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
local blankCards14 = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
function TableController:sendHandCards_(cards)
    for seatID, v in pairs(self.seats_) do
        if seatID == self.hostPlayer_:getSeatID() then
            v:showCards(cards)
        else
            if seatID == self.table_:getDealerSeatID() then
                v:showCards(clone(blankCards14))
            else
                v:showCards(clone(blankCards13))
            end
        end
    end
end

function TableController:onTurnTo_(event)
    if event.data.isReview then
        self:doTurnTo_(event.data)
    else
        TaskQueue.add(handler(self, self.doTurnTo_), TABLE_TIME.onTurnTo_[1], TABLE_TIME.onTurnTo_[2], event.data)
    end
end

function TableController:cheakOutCard()
    local cardInfo = self:getAllCard()
    local hostSeatID = self:getHostSeatID()
    local hostCards = clone(cardInfo[hostSeatID].handCards)
    local cardNum = {}
    for i = 1,#hostCards do
        local cardValue = hostCards[i]
        if cardNum[cardValue] then
            cardNum[cardValue] = cardNum[cardValue] + 1
        else
            cardNum[cardValue] = 1
        end
    end
    dump(cardNum,"cardNumcardNumcardNum")
    for i,v in pairs(cardNum) do
        print("XXXXXX",i,v)
        if v < 3 then
            return true
        end
    end
    return false
end

function TableController:checkHu(card, isHide)
    if not setData:getCDPHZTPTS() then
        return
    end

    local aimTable = display.getRunningScene():getTable()
    if isHide == true then
        if aimTable then
            return aimTable:doShowHuCard_({}) 
        end
    end

    local cardInfo = self:getAllCard()
    local cards = PaoHuZiAlgorithm.getRemainCards(
        {cardInfo[1].handCards or {},{},{}},
        {{cardInfo[1].chuCards or {},cardInfo[2].chuCards or {},cardInfo[3].chuCards or {}}},
        {{cardInfo[1].zhuoCards or {},cardInfo[2].zhuoCards or {},cardInfo[3].zhuoCards or {}}}
    )
    -- dump(cards,"cardscardscardscards")
    local hostSeatID = self:getHostSeatID()
    local hostCards = clone(cardInfo[hostSeatID].handCards)
    if card ~= nil then
        table.removebyvalue(hostCards, card)
    end
    local huCards = PaoHuZiAlgorithm.getTingPai(
        cards,
        hostCards or {},
        cardInfo[hostSeatID].zhuoCards or {}
    )
    local result = PaoHuZiAlgorithm.getCardNum(
        cardInfo,
        self.table_:getCurCards(),
        huCards
    )
    -- dump(result,"result")
    if aimTable and aimTable.doShowHuCard_ then    
        aimTable:doShowHuCard_(result) 
    end
end

function TableController:doTurnTo_(data)
    assert(data.seatID and data.remainTime)
    local seconds = math.max(data.remainTime, 10)
    local seatID = data.seatID
    self.actionButtonsController_:hideSelf()
    local player = self:getPlayerBySeatID(seatID)
    if player:isHost() then
        local aimTable = display.getRunningScene():getTable()
        if aimTable and aimTable.doShowHuCard_ then
            aimTable:doShowHuCard_({}) 
        end
    end
    player:doTurnto()
    self.tableView_:showAlarm(seatID, seconds or 10, 1)
end

function TableController:clearFocus_()
end

function TableController:resetPopUpPokers()
    self.tableView_:resetPopUpPokers()
end

function TableController:getRoomConfig()
    if self.tableView_ then
        return self.tableView_:getRoomConfig()
    end
end

function TableController:resetRoundPlayer_()
    for k,v in pairs(self.seats_) do
        if v:getPlayer() then
            v:getPlayer():resetPlayer()
        end
    end
end

function TableController:setHostPlayerState(offline)
    if self.hostPlayer_ then
        self.hostPlayer_:setOffline(offline, self.hostPlayer_:getIP())
    end
end

function TableController:getTable()
    return self.table_
end

function TableController:getHostSeatID()
    return self.hostSeatID_
end

function TableController:getDealerSeatID()
    return self.table_:getDealerSeatID()
end

function TableController:getHostPlayer()
    if self.hostPlayer_ then
        return self.hostPlayer_
    end
end

function TableController:setHostPlayerPaperCard(paperCardList)
    self:getPlayerBySeatID(self.hostSeatID_):setPaperCardList(paperCardList)
end

function TableController:showRuleInfo(rules)
    local str = ""
    if self.tableView_ then
        if rules.totalSeat == 2 then
            if rules.twoPlayerBaseXi == 0 then
                str = "21息起胡"
            else
                str = "15息起胡"
            end
        elseif rules.totalSeat == 3 then
            str = "15息起胡"
        end
        self.tableView_:showRuleInfo(str)
    end
end

function TableController:changeUserPosByRule_()
    local hostSeatID = self:getHostSeatID()
    if hostSeatID == 2 then
        local changeTo,changeFrom = 1,3
        local formPlayer = self:getPlayerBySeatID(changeFrom)
        local toPlayer = self:getPlayerBySeatID(changeTo)
        formPlayer:setIndex(self:calcPlayerIndex(changeTo))
        toPlayer:setIndex(self:calcPlayerIndex(changeFrom))
    end  
end

return TableController
