local PlayerController = import(".PlayerController")
local BaseController = import(".BaseController")
local TableController = class("TableController", BaseController)
local BaseAlgorithm = import("app.games.shuangKou.utils.BaseAlgorithm")
local ShuangKouAlgorithm = import("app.games.shuangKou.utils.ShuangKouAlgorithm")
local TaskQueue = require("app.controllers.TaskQueue")
local PokerTable = import("app.games.shuangKou.models.PokerTable")

local HOST_POSITION_INDEX = 1  -- 主机玩家的位置固定为1号

local ZHUANG = 1
local XIAN = 2

local TABLE_CHECKOUT = 3 --结算中
local TABLE_PLAYING = 2 --游戏进行中
local TABLE_READY = 1 --准备中
local TABLE_IDLE = 0  --空闲

function TableController:ctor()
    self.lastAction = 0
    self.table_ = PokerTable.new()
    self.table_:setController(self)
    self:init_()
    self.isTurnStart_ = false
    self.yaoDeQi_ = true
end

function TableController:init_()
    self.tableView_ = app:createConcreteView("game.TableView", self.table_):addTo(self)
    self.nodePlayers_ = self.tableView_.nodePlayers_
    self.maxPlayer_ = self:getMaxPlayer()
    self.hostSeatID_ = nil
    -- dump(self.maxPlayer_)
    self:createSeats_(self.maxPlayer_)
    self.actionButtonsController_ = app:createConcreteController("ActionButtonsController"):addTo(self)
end

function TableController:onEnter()
    gailun.EventUtils.clear(self)
    local handlers = dataCenter:s2cCommandToNames {
        {COMMANDS.SHUANGKOU_ROUND_START, handler(self, self.onRoundStart_)},
        {COMMANDS.SHUANGKOU_ROUND_OVER, handler(self, self.onRoundOver_)},
        {COMMANDS.SHUANGKOU_TURN_TO, handler(self, self.onTurnTo_)},
        {COMMANDS.SHUANGKOU_DEAL_CARD, handler(self, self.onDealCards_)},
        {COMMANDS.SHUANGKOU_TURN_START, handler(self, self.onTurnStart_)},
        {COMMANDS.SHUANGKOU_TURN_END, handler(self, self.onTurnEnd_)},
        {COMMANDS.SHUANGKOU_LEAVE_ROOM, handler(self, self.onLeaveRoom_)},
        {COMMANDS.SHUANGKOU_CONTRIBUTION_DE_FEN, handler(self, self.onZhaDanDeFen_)},
        {COMMANDS.SHUANGKOU_CHU_PAI, handler(self, self.onPlayerChuPai_)},
        {COMMANDS.SHUANGKOU_PLAYER_PASS, handler(self, self.onPlayerPass_)},
        {COMMANDS.SHUANGKOU_GAME_BROADCAST, handler(self, self.onBroadcast_)},  -- 广播消息
        {COMMANDS.SHUANGKOU_ONLINE_STATE, handler(self, self.onPlayerStateChanged_)},  -- 玩家网络事件广播
        {COMMANDS.SHUANGKOU_GET_PLAYER_CARDS, handler(self, self.onGetPlayerCards_)},  -- 玩家网络事件广播
        {COMMANDS.SHUANGKOU_ROUND_FLOW, handler(self, self.onRoundFlow_)},
        {COMMANDS.SHUANGKOU_OWNER_DISMISS, handler(self, self.onOwnerDismiss_)},
    }
    gailun.EventUtils.create(self, dataCenter, self, handlers)

    local cls = self.table_.class
    local handlers = {
        {cls.IDLE, handler(self, self.onTableIdle_)},
    }
    gailun.EventUtils.create(self, self.table_, self, handlers)
end

function TableController:initHostPlayerEvent_()
    --清除监听
    local handlers = {
        {self.hostPlayer_.SIT_DOWN_EVENT, handler(self, self.onHostPlayerSitDown_)},
        {self.hostPlayer_.STAND_UP_EVENT, handler(self, self.onHostPlayerStandUp_)},
        {self.hostPlayer_.ON_CHUPAI_EVENT, handler(self, self.onChuPaiEvent_)},
    }
    gailun.EventUtils.create(self, self.hostPlayer_, self, handlers)
end

function TableController:setHostPlayerState(offline)
    if self.hostPlayer_ then
        self.hostPlayer_:setOffline(offline, self.hostPlayer_:getIP())
    end
end

function TableController:taskRemoveAll()
    TaskQueue.removeAll()
end

function TableController:onOwnerDismiss_(event)
    if event.data.code == 0 then
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
end

function TableController:onTurnStart_(event)
    self.isTurnStart_ = true
end

function TableController:doTurnEnd_(data)
    self.table_:resetCurCards()
    -- for _,v in pairs(self.seats_) do
    --     v:setChuPai({})
    -- end

    self.tableView_:resetCircleCards()
end

function TableController:onTurnEnd_(event)
    self.lastAction = 0
    local seconds = 0.2
    if event.data.isReview then
        self:doTurnEnd_(event.data)
    else
        TaskQueue.add(handler(self, self.doTurnEnd_), 0, 0, event.data)
    end
end

function TableController:onZhaDanDeFen_(event)
    if event.data.isReview then
        self:doZhaDanDeFen_(event.data, nil, event.data.inFastMode)
    else
        TaskQueue.add(handler(self, self.doZhaDanDeFen_), 0, 0, event.data)
    end
end

function TableController:doZhaDanDeFen_(data)
    --dump(data,"TableController:doZhaDanDeFen_")
    local player = self:getPlayerBySeatID(data.seatID)
    player:setRoundScore(data.currScore)
    -- if data.contributionScore == nil then
        player:setGXScore(data.contributionScore)
    -- end
end

function TableController:onTableIdle_(event)
    self.actionButtonsController_:hide()
end

function TableController:getCurrPlayerCount()
    return self.table_:getCurrPlayerCount()
end

function TableController:onChuPaiEvent_(event)
    local cards = self.tableView_.nodeHostMaJiang_:getPopUpPokers()
    local data = {cards = cards}
    local bombCount = event.bombCount or {}
    data.bomb_count = bombCount

    local config = display:getRunningScene():getTable():getConfigData()
    if #self.actionButtonsController_:getHanFenList() == 0 then
        dataCenter:sendOverSocket(COMMANDS.SHUANGKOU_CHU_PAI, data)
    else
        if #bombCount == 0 then
            app:confirm("您确定不报炸翻番吗?", function (isOk)
                if isOk then
                    dataCenter:sendOverSocket(COMMANDS.SHUANGKOU_CHU_PAI, data)
                end
            end)
        else
            dataCenter:sendOverSocket(COMMANDS.SHUANGKOU_CHU_PAI, data)
        end
    end
    -- if ShuangKouAlgorithm.isBigger(cards, self.table_:getCurCards(), config) then
    --     -- dump(data)
    --     dataCenter:sendOverSocket(COMMANDS.SHUANGKOU_CHU_PAI, data)
    -- else
    --     app:showTips("出牌不符合规则，请重新选择哦!")
    --     self.tableView_.nodeHostMaJiang_:resetPopUpPokers()
    -- end
end

function TableController:onExit()
    gailun.EventUtils.clear(self)
end

function TableController:doQiangZhuang_(data)
    if data.code ~= 0 then return end
    local seatID = data.seatID
    local isQiang = data.isQiang
    for k, player in ipairs(self.seats_) do
        if k == seatID and data.code == 0 then
            player:doFlow(-1)
            player:qiangZhuang(isQiang)
        end
    end
end

function TableController:onQiangZhuang_(event)
    if event.data.isReview then
        self:doQiangZhuang_(event.data, nil, event.data.inFastMode)
    else
        TaskQueue.add(handler(self, self.doQiangZhuang_), 0, 1.5, event.data)
    end
end

function TableController:doRoundFlow_(data)
    if data.isReview then return end
    local flow = data.flow
    if data.code == SERVER_RULE_ERROR then
        return
    end
    if data.seatID == self.hostPlayer_:getSeatID() then
        self.tableView_:stopTimer()
    end
    self.actionButtonsController_:hide()
    if self.actionButtonsController_:isNeedShowFlow(data) then
        self.tableView_:showAlarm(self.hostPlayer_:getSeatID(), data.seconds or 10, flow)
    end
    if flow == T_IN_PLAYING then
        -- self.table_:setFirstHand(true)
    end
    for k,v in pairs(self.seats_) do
        v:doFlow(-1)
    end
end

function TableController:getSeats()
    return self.seats_
end

function TableController:onRoundFlow_(event)
    if event.data.isReview then
        return
    end
    TaskQueue.add(handler(self, self.doRoundFlow_), 0, 0.5, event.data)
end

function TableController:setRoomPlayerCount_()
    local count = 0
    for k,v in pairs(self.seats_) do
        print(v:getPlayer():getUid())
        if v:getPlayer():getUid() ~= 0 then
            count = count + 1
        end
    end
    self.table_:setCurrPlayerCount(count)
    self:performWithDelay(function()
        -- dump(display.getRunningScene().__cname)
        display.getRunningScene():isShowYaoqingButton()
        end,
        0.2)
end

function TableController:showCurrFlow_(flow)
    -- if flow ~= T_IN_PLAYING then
        -- self.doFlowList_[flow](flow)
    -- end
end

function TableController:onLeaveRoom_(event)
    local player = self:getPlayerById(event.data.uid)
    if not player then
        return
    end
    player:standUp()
    self:setRoomPlayerCount_()
end

function TableController:doPlayerPass_(data)
    dump(data,"datadata")
    local player = self:getPlayerBySeatID(data.seatID)
    if not player then
        return
    end
    player:pass(data.inFastMode)
end

function TableController:onPlayerPass_(event)
    if event.data.isReview then
        self:doPlayerPass_(event.data)
    else
        TaskQueue.add(handler(self, self.doPlayerPass_), 0, 0, event.data)
    end
end

function TableController:onBroadcast_(event)
    if not event.data.data then
        return
    end

    local data = event.data.data
    if data.action == "chat" then
        self:onPlayerChat_(event.data.uid, data)
    else
        dump(data.action, "TableController:onBroadcast_")
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
    local player = self:getPlayerBySeatID(seatID)
    if not player then
        printError("onPlayerReady with empty player!")
        return
    end
    local isHost = seatID == self.hostPlayer_:getSeatID()
    if isHost then
        self:clearAfterRoundOver_()
    end
    print("isReady", seatID, isReady)
    player:doReady(isReady)
end

function TableController:clearAfterRoundOver_()
    self.table_:resetCurCards()
    -- self:resetRoundPlayer_()
end

function TableController:inShowActions()
    return self.actionButtonsController_:inShowActions()
end

function TableController:getFriendPlayerSeatID()
    local seatID = self.hostPlayer_:getSeatID()
    local maxPlayer = self.table_:getMaxPlayer()
    local friendSeatID = (seatID + 1) % maxPlayer + 1

    return friendSeatID
end

function TableController:getFriendPlayer()
    local friendSeatID = self:getFriendPlayerSeatID()
    local player = self:getPlayerBySeatID(friendSeatID)
    print("friendID", friendSeatID, player:getSeatID())
    return player
end

function TableController:onGetPlayerCards_(event)
    self:bindFriendPlayerCards(event.data.cards)
end

function TableController:cleanFriendPoker()
    if self.beforeFriendPlayer then
        self.beforeFriendPlayer:setPokerListView(nil)
        self.beforeFriendPlayer = nil
    end
end

function TableController:bindFriendPlayerCards(cards)
    dump(cards)
    self:cleanFriendPoker()

    local friendPlayer = self:getFriendPlayer()

    local pokerList = self.tableView_:getNewFriendPoker()
    friendPlayer:setPokerListView(pokerList)
    friendPlayer:setCards(cards, true)
    friendPlayer:showCards()

    self.beforeFriendPlayer = friendPlayer
end

function TableController:doDealCards_(data)
    dump(data, "doDealCards_")
    self.table_:setInPublicTime(false)
    self.hostPlayer_:setCards(data.handCards)
    self.hostPlayer_:showCards()
    self.tableView_:stopTimer()
    self.table_:setDealerSeatID(data.dealerSeatID)

    self.tableView_:showPoker(data.randomPoker)

    self.hostPlayer_:setLeftCards(#data.handCards)
    self.hostPlayer_:setCallBombCount({})
    self.hostPlayer_:setCurrentBombCount({})
    local leftCards = self.hostPlayer_:getLeftCards()


    for _, player in pairs(self.seats_) do
        if player:getSeatID() ~= self.hostPlayer_:getSeatID() then
            player:setLeftCards(leftCards)
            player:setCallBombCount({})
            player:setCurrentBombCount({})
        end
    end

    self:cleanFriendPoker()

    if data.changeFrom and data.changeTo and data.changeFrom ~= 0 and data.changeTo ~= 0 then
        if data.changeFrom == self.hostPlayer_:getSeatID() then
            -- self.hostPlayer_:setSeatID(data.changeTo)
            self:setHostSeatID_(data.changeTo)
        elseif data.changeTo == self.hostPlayer_:getSeatID() then
            -- self.hostPlayer_:setSeatID(data.changeFrom)
            self:setHostSeatID_(data.changeFrom)
        end

        local fromPlayer = self:getPlayerBySeatID(data.changeFrom)
        local toPlayer = self:getPlayerBySeatID(data.changeTo)
        fromPlayer:setSeatID(data.changeTo) -- 4
        toPlayer:setSeatID(data.changeFrom) -- 1

        self.seats_[data.changeFrom],self.seats_[data.changeTo] = self.seats_[data.changeTo],self.seats_[data.changeFrom]

        for k, player in pairs(self.seats_) do
            player:setIndex(self:calcPlayerIndex(k), true)
        end
    end
end

function TableController:getTable()
    return self.table_
end

function TableController:onDealCards_(event)
    -- dump(event.data)
    if event.data.isReview then
        self:doDealCards_(event.data)
    else
        TaskQueue.add(handler(self, self.doDealCards_), 0, 0, event.data)
    end
end

function TableController:doRoomInfo(data)
    dump(data,"TableController:doRoomInfo")
    self.table_:setMaxPlayer(data.config.totalSeat or 4)
    if data.status ~= TABLE_IDLE then
        self.table_:doEventForce("roundstart")
    end
    if data.status == TABLE_CHECKOUT then
        self.table_:doEventForce("roundover")
        for seatID,v in ipairs(self.seats_) do
            v:doRoundOver()
            self:onPlayerReady(seatID, v:isReady())
        end
        local seatID = self.hostPlayer_:getSeatID()
        self:onPlayerReady(seatID, true)
    end
    self.table_:setFinishRound(data.roundIndex)
    data.config.clubID = data.clubID
    self.table_:setConfigData(data.config)
    if data.isReview then
        for i,v in ipairs(self.seats_) do
            v:initPokerList(data.config.gameMode)
            v:getPlayer():showCards()
        end
    else
        for i,v in ipairs(self.seats_) do
            if v:getUid() == self.hostPlayer_:getUid() then
                v:setPokerListView(self.tableView_.nodeHostMaJiang_)
                break
            end
        end
    end
    self.hostPlayer_:showCards()
    self.table_:setTid(data.tid or dataCenter:getRoomID())
    self.table_:setOwner(data.creator or 0)
    self.table_:setIsAgent(data.isAgent or 0)
    if data.creator == self.hostPlayer_:getUid() then
        dataCenter:setOwner(data.creator or 0)
    end
    TaskQueue.removeAll()
    if data.status == TABLE_IDLE then
        self.table_:doEventForce("idle")
        return
    end

    self.table_:setStatus(data.status)
    if data.status ~= TABLE_PLAYING then  -- 空闲中
        return
    end
    self:doResumeRoomInfo_(data)
    self.lastAction = #data.turnCards
    self:setPassBtnStatus()
end

function TableController:doResumeRoomInfo_(data)
    self.table_:setDealerSeatID(data.dealer)
    self.tableView_:showPoker(data.randomPoker, false)
    for k,v in pairs(self.seats_) do
        v:doFlow()
        if v:getUid() ~= self.hostPlayer_:getUid() then
            v:warning(v:getWarningType())
        end
    end
    if data.currSeatID == self.hostPlayer_:getSeatID() or data.currSeatID == -1 then
        if data.inFlow and data.inFlow > 0  then
            if not data.isReview  then
            end
        end
    end
    if data.currSeatID == -1 then return end
    self:performWithDelay(function()
        self:resumeChuPai_(clone(data.turnCards))
        local v = data.turnCards[#data.turnCards]
        local cards = {}
        if v and v[2] then
            cards = v[2]
        end
        self.table_:setCurCards(cards)
        self:doTurnTo_(data.currSeatID, data.remainSeconds, true)
        for _, cardsInfo in ipairs(data.turnCards) do
            self.tableView_:addCircleCards(cardsInfo[2])
        end
    end, 1)

end

function TableController:resumeChuPai_(turnCards)
    local turnCards = turnCards or {}
    local v = turnCards[#turnCards]
    if v then
        self.table_:setCurCards(v[2])
        local player = self:getPlayerBySeatID(v[1])
        player:setChuPai(v[2], true, nil, v[1])
    end
end

function TableController:resumePlayerStates_()
    for _, player in ipairs(self.seats_) do
        player:doRoundStart(true)
    end
end

function TableController:makeRuleString(spliter)
    return self.tableView_:makeRuleString(spliter or ",")
end

-- 断线重连
function TableController:resumePlayer_(player, data)
    player:doReady(data.isPrepare)
    print("断线重连")
    if data.status ~= 2 then  -- 空闲中
        return
    end
    player:doForceRoundStart(true)
    -- -- 恢复手牌
    if data.shouPai and #data.shouPai > 0 then
        player:setCards(data.shouPai, true)
    end
    -- -- 恢复各种标志
    if data.leftCards <= 10 and data.leftCards > 0 then
        data.warning = 2
    else
        data.warning = -2
    end
    player:warning(data.warning, false, true)
    player:setOffline(data.offline, data.IP)
    player:showRank(data.rank or -1, true)
    player:setRoundScore(data.score)
    player:setGXScore(data.contributionScore)
    player:setLeftCards(data.leftCards)

    player:setCallBombCount(data.callBombCount)
    player:setCurrentBombCount(data.currentBombCount)

    player:setCurrentPow(math.max(data.callBombScore, data.bombScore))

    self:performWithDelay(function ()
        print("getFriendCards1", self.table_:getStatus())
        if data.seatID == self.hostPlayer_:getSeatID() and self.hostPlayer_:getLeftCards() == 0 and data.leftCards == 0 and self.table_:getStatus() == TABLE_PLAYING then
            dataCenter:sendOverSocket(COMMANDS.SHUANGKOU_GET_PLAYER_CARDS, {seatID = self:getFriendPlayerSeatID()})
        end
    end, 0.1)
end

function TableController:getFriendCards()
    local player = self:getFriendPlayer()
    print("getFriendCards", #player:getCards(), player:getLeftCards(), self.hostPlayer_:getLeftCards(), self.table_:getStatus())
    if #player:getCards() ~= 0 or player:getLeftCards() == 0 or self.hostPlayer_:getLeftCards() ~= 0 or self.table_:getStatus() ~= TABLE_PLAYING then
        return
    end


    dataCenter:sendOverSocket(COMMANDS.SHUANGKOU_GET_PLAYER_CARDS, {seatID = self:getFriendPlayerSeatID()})
end

function TableController:calcNextSeatID_(seatID)
    local nextSeatID = seatID + 1
    if nextSeatID <= 4 then
        return nextSeatID
    end
    return 1
end

function TableController:doPlayerChuPai_(data)
    if data.code == -8 then
        app:showTips("出牌不符合规则，请重新选择哦!")
        return
    elseif data.code == -30 then
        app:showTips("当前叫分不符合规则")
        return
    elseif data.code == -31 then
        app:showTips("不可拆当前手上叫分牌")
        return
    elseif data.code == -15 then
        app:showTips("下家已报单，单张必须出牌点最大的牌！")
        return
    end
    if not data or not data.seatID then
        return
    end

    self.actionButtonsController_:setVisibleAction(false)
    self.tableView_:stopTimer()
    local cards = data.cards
    self:setFocusOn_(data.seatID)
    local player = self:getPlayerBySeatID(data.seatID)
    if not player then
        return
    end

    if data.callBombCount then
        player:setCallBombCount(data.callBombCount)
    end
    player:setCurrentBombCount(data.currentBombCount)
    player:setCurrentPow(math.max(data.callBombScore, data.bombScore))

    if data.rank ~= 0 then
        player:showRank(data.rank)
    end
    for i = 1,4 do
        if i ~= data.seatID then
            print(i)
            self:getPlayerBySeatID(i):setChuPai({})
        end
    end
    player:reduceLeftCards(#cards)
    player:setChuPai(clone(cards), data.isReConnect, data.inFastMode, data.seatID, data.isLast)
    player:doChuPai()
    
    if player:getLeftCards() <= 10 and player:getLeftCards() > 0 then
        data.warning = 2
    else
        data.warning = -2
    end

    self:performWithDelay(function ()
        self:getFriendCards()
    end, 0.1)

    player:warning(data.warning, data.inFastMode)
    self.table_:setCurCards(cards)
    if data.inFastMode then return end
    self.tableView_:playPokerAnimation(player:getIndex(), player:getSex(), clone(cards))
    self.tableView_:addCircleCards(cards)
end

function TableController:onPlayerChuPai_(event)
    self.lastAction = self.lastAction + 1
    if event.data.isReview then
        self:doPlayerChuPai_(event.data)
    else
        TaskQueue.add(handler(self, self.doPlayerChuPai_), 0, 0.1, event.data)
    end
end

function TableController:setDaiJianFenQu_(data)
    self.table_:addDaiJianFen(data.cards, data.inFastMode)
end

function TableController:setFocusOn_(seatID)
    if not self.seats_[seatID] then
        return
    end
end

function TableController:setLastCard_(seatID, card, isBuGang)
    if not seatID or not card then
        return
    end
    self.table_:saveLastCard(seatID, card, isBuGang)
end

function TableController:doPlayerSitDown(params)
    local playerData = params
    local data = json.decode(playerData.data)
    assert(playerData and data.uid and playerData.seatID, "sitDown fail by error data")
    table.merge(playerData, data)
    local player = self:getPlayerBySeatID(params.seatID)

    if params.uid == selfData:getUid() then
        self.hostPlayer_ = player:getPlayer()
        -- self.actionButtonsController_:setHostPlayer(self.hostPlayer_)
        self:initHostPlayerEvent_()
        self.hostSeatID_ = player:getSeatID()
        if params.operates and #params.operates > 0 then
            self.actionButtonsController_:showOperates(params.operates, self:getGameType())
            self.hasOP_ = true
            print("showOperates(operates)")
        else
            self.actionButtonsController_:hide()
            self.hasOP_ = false
            print("hide (operates)")
        end
    end
    player:sitDown(playerData, self.table_:isIdle())
    if params.uid == selfData:getUid() then
        player:setIndex(HOST_POSITION_INDEX)
    else
        player:setIndex(self:calcPlayerIndex(params.seatID))
    end
    player:resumePlayer(playerData)
    self:resumePlayer_(player, params)
    self:setRoomPlayerCount_()
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
    self.seats_[self:getHostPlayer():getSeatID()]:setLocalZOrder(0)
end

function TableController:onHostPlayerStandUp_(event)
    self:setHostSeatID_(nil)
end

function TableController:getPlayerBySeatID(seatID)
    return self.seats_[seatID]
end

function TableController:getPlayerByIndex(index)
    for i,v in ipairs(self.seats_) do
        if v:getIndex() == index then
            return v
        end
    end
    return
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

function TableController:onPlayAction(event)
    if 2 == event.data.code then  -- 已收到操作, 隐藏操作栏
        self.actionButtonsController_:setVisibleAction(false)
        return
    end
    if event.data.code ~= 0 then
        return
    end
    self.table_:setInPublicTime(false)  -- 公共牌时间结束
    local player = self.seats_[event.data.seatID]
    if player then
        player:doPlayAction(event.data)
    end
    local action = event.data.actType
    if ACTIONS.BU_GANG == action then
        self.table_:saveLastCard(event.data.seatID, event.data.cards[1], true)
    end
    if ACTIONS.QIANG_GANG_HU == action then
        local bePlayer = self.seats_[event.data.seatID2]
        if bePlayer then
            bePlayer:beQiangGang(self.table_:getLastCard())
        else
            printError("QIANG_GANG_HU ERROR, NOT SECOND PLAYER!")
        end
    end

    local lastSeatID = event.data.seatID2 or self.table_:getLastSeatID()
    local lastCard = self.table_:getLastCard()
    if event.data.cards2 then
        lastCard = event.data.cards2[1]
    end
    if table.indexof({ACTIONS.PENG, ACTIONS.CHI, ACTIONS.CHI_GANG}, action) ~= false then
        if self.seats_[lastSeatID] then
            self.seats_[lastSeatID]:removeChuPai(lastCard)
        end
        self.table_:removeLastCard()
        self:clearFocus_()
    end
    if ACTIONS.CHI_HU == action then
        if self.seats_[lastSeatID] then
            self.seats_[lastSeatID]:removeChuPai(lastCard)
        end
        self:clearFocus_()
    end
    if table.indexof({ACTIONS.PENG, ACTIONS.CHI, ACTIONS.CHI_GANG, ACTIONS.AN_GANG, ACTIONS.BU_GANG}, action) ~= false then
        self:adjustMaJiang_(event.data.seatID, false, event.data.isDown)
    end
    self:setTurnTo_(event.data.seatID, 0)
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
    local number = number or 4 -- 默认4人桌
    for i=1, number do
        self.seats_[i] = PlayerController.new(i):addTo(self.nodePlayers_, -i)
    end
    -- self.seats_[self:getHostPlayer():getSeatID()]:setLocalZOrder(0)
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
    if dealer == nil then return end
    if dealer > 0 and self.seats_[dealer] then
        self.tableView_:onAdjustSeats(dealer)
    end
end

function TableController:setSeatsVisible()
    if self.hostPlayer_:isSitDown() then
        for _,v in pairs(self.seats_) do
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

function TableController:getMaxPlayer()
    return self.table_:getMaxPlayer()
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

function TableController:onRoundStart_(event)
    TaskQueue.continue()
    if event.data.isReview then
        self:doRoundStart_(event.data)
    else
        TaskQueue.add(handler(self, self.doRoundStart_), 0, 0, event.data)
    end
end

function TableController:onRoundOver_(event)
    if event.data.isReview then
        self:doRoundOver(event.data)
    else
        TaskQueue.add(handler(self, self.doRoundOver), 1, 0, event.data)
    end
end

function TableController:playersRoundStart_()
    for i,v in ipairs(self.seats_) do
        v:doRoundStart()
    end
end

function TableController:doRoundStart_(data)
    self.table_:setDealerSeatID(0)
    self.table_:setStatus(TABLE_PLAYING)
    self.table_:doRoundStart()
    self:playersRoundStart_()
    -- self.table_:setFinishRound(data.seq)
    self.table_:saveLastCard(0, 0)
    self.table_:setInPublicTime(false)
    self.actionButtonsController_:show()
    self.actionButtonsController_:setVisibleAction(false)
end

-- 结算过程
function TableController:doRoundOver(data)
    self.actionButtonsController_:hide()
    self.table_:setStatus(TABLE_CHECKOUT)
    self:clearFocus_()
    self.table_:doRoundOver(data)
    for _,v in ipairs(self.seats_) do
        v:doRoundOver()
    end
end

function TableController:doGameOver(data)
    printInfo("TableController:doGameOver")
    self:clearFocus_()
end

local blankCards13 = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
local blankCards14 = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
function TableController:sendHandCards_(cards)
    for seatID, v in pairs(self.seats_) do
        print("this is seatID in here: ", seatID, self.hostPlayer_:getSeatID())
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

-- TODO: refactory turn to
function TableController:onTurnTo_(event)
    if event.data.isReview then
        self:doTurnTo_(event.data.seatID, event.data.remainTime, event.data.yaoDeQi)
        self.actionButtonsController_:hide()
    else
        TaskQueue.add(handler(self, self.doTurnTo_), 0, 0, event.data.seatID, 10, event.data.yaoDeQi)
    end
end

function TableController:doTurnTo_(seatID, seconds, yaoDeQi)
    assert(seatID and seconds)
    local seconds = math.max(seconds, 2)
    self:setTurnTo_(seatID, seconds)
    local lastCards = self.table_:getCurCards()
    local handCards = self.hostPlayer_:getCards()
    if seatID == self.hostPlayer_:getSeatID() and ((#handCards == 2 and #lastCards > 2) or (#handCards == 1 and #lastCards >= 2)) then
        app:showTips("要不起当前牌，自动过")
        TaskQueue.add(function ()
            dataCenter:sendOverSocket(COMMANDS.SHUANGKOU_PLAYER_PASS)
        end, 1, 0)
        return
    end

    self.actionButtonsController_:show()
    if seatID == self.hostPlayer_:getSeatID() then
        self.actionButtonsController_:setVisibleAction(true)
        if yaoDeQi == false then
            self.actionButtonsController_:showActions(T_IN_PLAYING, yaoDeQi)
            self:setPassBtnStatus()
            return
        end
        self.actionButtonsController_:showActions(T_IN_PLAYING)
        self:setPassBtnStatus()
        self.tableView_.nodeHostMaJiang_:setChuPaiBtnStatus()
        self.tableView_:initTishi()
    else
        self.actionButtonsController_:setVisibleAction(false)
    end
end

--出牌按钮状态
function TableController:setChuPaiBtnStatus(isCanChuPai_)
    local cards = self.tableView_.nodeHostMaJiang_:getPopUpPokers()
    local config = display:getRunningScene():getTable():getConfigData()
    -- print(ShuangKouAlgorithm.isZha(cards, config.bianPai))
    -- dump(self.hostPlayer_:getCurrentBombCount())
    local callBombCount = self.hostPlayer_:getCallBombCount()
    if #cards ~= 0 and #callBombCount == 0 and ShuangKouAlgorithm.isZha(cards, config.bianPai) then
        local handCards = self.hostPlayer_:getCards()
        local speakCardsByRatio = ShuangKouAlgorithm.getAllPropaganda(cards, handCards, config)
        local speakCards = {}
        for ratio, v in pairs(speakCardsByRatio) do
            for _, combination in pairs(v) do
                table.insert(speakCards, combination)
            end
        end

        -- if #speakCards ~= 0 then
            self.actionButtonsController_:showHanFen(speakCards)
        -- end
    else
        self.actionButtonsController_:showHanFen({})
    end

    self.actionButtonsController_:setChuPaiBtnStatus(true)
    -- self.actionButtonsController_:setChuPaiBtnStatus(isCanChuPai_)
end

--不要按钮的状态
function TableController:setPassBtnStatus()
    if self.lastAction > 0 then
        self.actionButtonsController_:setPassBtnStatus(true)
    else
        self.actionButtonsController_:setPassBtnStatus(false)
    end
end


function TableController:setTurnTo_(seatID, seconds)
    if self.seats_[seatID] then
        self.seats_[seatID]:beTurnTo(seconds)
    end
end

function TableController:clearFocus_()
end

function TableController:resetPopUpPokers()
    self.tableView_:resetPopUpPokers()
    self.actionButtonsController_:setChuPaiBtnStatus(false)
end

function TableController:getRoomConfig()
    if self.tableView_ then
        return self.tableView_:getRoomConfig()
    end
end

function TableController:finishRound()
    self:resetRoundPlayer_()
    self.tableView_:setRoundTxt()
end

function TableController:resetRoundPlayer_()
    for k,v in pairs(self.seats_) do
        if v:getPlayer() then
            v:getPlayer():resetPlayer()
        end
    end
end

function TableController:getHostPlayer()
    if self.hostPlayer_ then
        return self.hostPlayer_
    end
end

function TableController:isMyTable()
    return self:getHostPlayer():getUid() == self.table_:getOwner()
end

return TableController
