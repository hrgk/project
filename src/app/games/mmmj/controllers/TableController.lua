local PlayerController = import("app.games.mmmj.controllers.PlayerController")
local BaseController = import("app.controllers.BaseController")
local TableController = class("TableController", BaseController)
local BaseAlgorithm = import("app.games.mmmj.utils.BaseAlgorithm")
local TaskQueue = require("app.controllers.TaskQueue")
local MaJiangTable = import("app.games.mmmj.models.MaJiangTable")

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
--     onUserGang_ = {2, 2},
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
    onAllPass_ = {0, 0.5},
    onDealCards_ = {0, 0.5},
    onPlayerChuPai_ = {0, 0.7},
    onNotifyHu_ = {0, 0},
    onEveryonePass_ = {0, 0.5},
    onPlayerMoPai_ = {0, 0},
    onUserHu_ = {0, 0},
    doPublicTime_ = {0, 0},
    onUserWei_ = {0, 1},
    onUserChi_ = {0, 0},
    onUserPeng_ = {0, 0},
    onUserGang_ = {0, 1},
    onFirstHandTi_ = {0, 1.5},
    onTianHuEnd_ = {0, 1.5},
    onTianHuStart_ = {0, 1.5},
    onRoundStart_ = {0, 0},
    onTurnTo_ = {0, 0},
    onCSMJUserAfterGang_ = {3, 0.7},
    doBeginChui_ = {0, 0},
    doPlayerChui_ = {0, 0},
    onUserBu_ = {0, 0},
    onCSTanPai_ = {1, 4},
    onMJHaiDi_ = {0, 0},
    onMJPlayerOperate_ = {0, 0}
}

function TableController:ctor()
    self.table_ = MaJiangTable.new()
    self.isReview_ = false
    self:init_()
    self.isTurnStart_ = false
    self.currentMoCard_ = 0
    self.playerInfo = {}
end

function TableController:init_()
    self.tableView_ = app:createConcreteView("game.TableView", self.table_, self):addTo(self)
    self.hostSeatID_ = 0
    self.nodePlayers_ = self.tableView_.nodePlayers_
    self.maxPlayer_ = 4
    self:createSeats_(self.maxPlayer_)
    self.actionButtonsController_ = app:createConcreteController("ActionButtonsController", self:getGameType()):addTo(self):hide()
    self.actionButtonsController_:setTable(self.table_)
end

function TableController:onEnter()
    local handlers = dataCenter:s2cCommandToNames { 
        {COMMANDS.MMMJ_ROUND_START, handler(self, self.onRoundStart_)},
        {COMMANDS.MMMJ_TURN_TO, handler(self, self.onTurnTo_)},
        {COMMANDS.MMMJ_CHU_PAI, handler(self, self.onPlayerChuPai_)},
        {COMMANDS.MMMJ_PLAYER_PASS, handler(self, self.onPlayerPass_)},
        {COMMANDS.MMMJ_BROADCAST, handler(self, self.onBroadcast_)},  -- 广播消息
        {COMMANDS.MMMJ_ONLINE_STATE, handler(self, self.onPlayerStateChanged_)},  -- 玩家网络事件广播
        {COMMANDS.MMMJ_PUBLIC_TIME, handler(self, self.onPublicTime_)},  -- 公共牌时间

        {COMMANDS.MMMJ_DEAL_CARD, handler(self, self.onDealCards_)},  -- 发牌
        -- {COMMANDS.MMMJ_USER_GANG, handler(self, self.onUserGang_)},  -- 玩家提 
        {COMMANDS.MMMJ_USER_HU, handler(self, self.onUserHu_)},  -- 胡牌
        {COMMANDS.MMMJ_USER_CHI, handler(self, self.onUserChi_)},  -- 吃牌
        {COMMANDS.MMMJ_USER_PENG, handler(self, self.onUserPeng_)},  -- 碰牌
        {COMMANDS.MMMJ_USER_MO_PAI, handler(self, self.onPlayerMoPai_)},  
        {COMMANDS.MMMJ_NOTIFY_HU, handler(self, self.onNotifyHu_)},  -- 通知胡牌请求
        {COMMANDS.MMMJ_OWNER_DISMISS, handler(self, self.onOwnerDismiss_)},
        -- -- {COMMANDS.MMMJ_PLAY_ACTION, handler(self, self.onPlayAction_)},
        {COMMANDS.MMMJ_UPDATE_SCORE, handler(self, self.onUpdateScore_)},

        {COMMANDS.MMMJ_USER_AFTER_GANG, handler(self, self.onCSMJUserAfterGang_)},
        {COMMANDS.MMMJ_PLAYER_SHOW_CARDS, handler(self, self.onCSTanPai_)},
        {COMMANDS.MMMJ_USER_AN_GANG, handler(self, self.onUserGang_)},
        {COMMANDS.MMMJ_USER_MING_GANG, handler(self, self.onUserGang_)},
        {COMMANDS.MMMJ_USER_GONG_GANG, handler(self, self.onUserGang_)},
        {COMMANDS.MMMJ_USER_BU_CARD, handler(self, self.onUserBu_)},
        {COMMANDS.MMMJ_USER_MING_BU, handler(self, self.onUserBu_)},
        {COMMANDS.MMMJ_USER_GONG_BU, handler(self, self.onUserBu_)},
        {COMMANDS.MMMJ_HAI_DI, handler(self, self.onMJHaiDi_)},
        {COMMANDS.MMMJ_PLAYER_OPERATES, handler(self, self.onMJPlayerOperate_)},
        {COMMANDS.MMMJ_GET_ALL_PLAYER_CARDS, handler(self, self.onGetAllPlayerCards_)},

    }
    gailun.EventUtils.create(self, dataCenter, self, handlers)
    
    self.doFlowList_ = {
        [MMMJ_T_IN_IDLE] = handler(self, self.doFlowInIDLE_),
        [MMMJ_T_IN_CHU_PAI] = handler(self, self.doFlowInChuPai_),
        [MMMJ_T_IN_PUBLIC_OPRATE] = handler(self, self.doFlowInChuPaiCall_),
        [MMMJ_T_IN_MO_PAI] = handler(self, self.doFlowInMoPai_),
        [MMMJ_T_IN_MO_PAI_CALL] = handler(self, self.doFlowInMoPaiCall_),
        [MMMJ_T_IN_MING_GANG_PAI_CALL] = handler(self, self.doFlowInQiangGangHuCall_),
        [MMMJ_T_IN_GONG_GANG_PAI_CALL] = handler(self, self.doFlowInQiangGangHuCall_),
        [MMMJ_T_IN_AN_GANG_PAI_CALL] = handler(self, self.doFlowInQiangGangHuCall_),
        -- [CS_MMMJ_T_IN_GANG_PAI_CALL] = handler(self, self.doFlowInQiangGangHuCall_),
        [MMMJ_T_IN_OTHER_GANG_PAI_CALL] = handler(self, self.doFlowInQiangGangHuCall_),
        [MMMJ_T_IN_WILL_BEGIN_OPTION] = handler(self, self.doFlowInBeginOptionCall_),
        [MMMJ_T_IN_HAI_DI] = handler(self, self.doFlowInHaidiChoosCall_),
        [MMMJ_T_IN_HAI_DI_CALL] = handler(self, self.doFlowInHaiDiCall_),
        [CS_T_IN_BEFORE_CHU_PAI] = handler(self, self.doFlowInBeforeChuPai_),
    }

    print("TableController:onEnter")
end

function TableController:initHostPlayerEvent_()
    gailun.EventUtils.clear(self.hostPlayer_)
    local handlers = {
        {self.hostPlayer_.SIT_DOWN_EVENT, handler(self, self.onHostPlayerSitDown_)},
        {self.hostPlayer_.STAND_UP_EVENT, handler(self, self.onHostPlayerStandUp_)},
        {self.hostPlayer_.ON_TING_EVENT, handler(self, self.onHostPlayerTingEvent_)},
    }
    gailun.EventUtils.create(self, self.hostPlayer_, self, handlers)
end

function TableController:taskRemoveAll()
    TaskQueue.removeAll()
end

function TableController:getProgreesView()
    return self.tableView_:getProgreesView()
end

function TableController:setPlayerCard(seatID,cards)
    local player = self:getPlayerBySeatID(seatID)
    player:sitDown(seatID, {uid = 123})
    player:setChuPai(cards,true)
end

function TableController:onOwnerDismiss_(event)
    if event.data.code == 0 then
        dataCenter:setRoomID(0)
        dataCenter:setOwner(0)
        if self.table_:getClubID() > 0 then
            local params = {}
            params.clubID = self.table_:getClubID()
            params.floor = gameData:getClubFloor()
            httpMessage.requestClubHttp(params, httpMessage.GET_CLUB_INFO)
            return
        end
        app:enterHallScene()
    end
end

function TableController:onTurnStart_(event)
    self.isTurnStart_ = true
end

function TableController:setScore(score)
    for i,v in ipairs(self.seats_) do
        v.view_:setScore(v.player_.score_+score)
    end
end

function TableController:onGetAllPlayerCards_(event)
    local data = event.data
    local player = self.seats_[data.seatID]
    if player == nil then
        return
    end

    local isRight = true
    for k, v in ipairs(player:getOutCards()) do
        if data.outCards[k] ~= v then
            isRight = false
            break
        end
    end

    -- isRight = false
    if isRight == true then
        print(data.seatID, "玩家数据正确")
        return
    end

    player:setChuPai(data.outCards)
    dump(data.outCards, "出牌错误，重设")
end

function TableController:onChuPaiEvent_(event)
    local data = {cards = event.card}
    dataCenter:sendOverSocket(COMMANDS.MMMJ_CHU_PAI, data)
end

function TableController:onPengPaiEvent_(event)
end 

function TableController:onHightLightPaiEvent_(event)
      self.seats_[1].view_:showHightLight(event.card, event.isHigh)
      self.seats_[2].view_:showHightLight(event.card, event.isHigh)
      self.seats_[3].view_:showHightLight(event.card, event.isHigh)
      self.seats_[4].view_:showHightLight(event.card, event.isHigh)
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
        if v:getPlayer() then
            count = count + 1
        end
    end
    self.table_:setCurrPlayerCount(count)
end

function TableController:showCurrFlow_(flow,data)
    print(flow)
    self.doFlowList_[flow](flow,data)
end

function TableController:doLeaveRoom(uid)
    local player = self:getPlayerById(uid)
    if not player then
        return
    end
    player:standUp()
    -- self.seats_[player:getSeatID()] = nil
    self:setRoomPlayerCount_()
    self:setSeatsVisible()
end

function TableController:doPlayerPass_(data)
    if data.code == -8  then
        print("没有轮到你操作")
        return 
    end
    self.actionButtonsController_:hideSelf()
    if data.seatID == self.hostSeatID_ then
        local player = self:getPlayerBySeatID(data.seatID)
        if player:isLocked() and self.currentMoCard_ > 0 then
            self.tableView_:performWithDelay(function()
                dataCenter:sendOverSocket(COMMANDS.MMMJ_CHU_PAI, {
                    cards = self.currentMoCard_
                })
                local info = {}
                info.code = 0
                info.cards = self.currentMoCard_
                info.isDown = true
                info.seatID = player:getSeatID()
                self:doPlayerChuPai(info)
                self.currentMoCard_ = 0
                end, 1)
        end
    end
end

function TableController:onUpdateScore_(event)
    if event.data.isReview then
        self:doUpdateScore_(event.data)
    else
        TaskQueue.add(handler(self, self.doUpdateScore_), TABLE_TIME.onPlayerPass_[1], TABLE_TIME.onPlayerPass_[2], event.data)
    end
end

function TableController:doUpdateScore_(data)
    if data.code ~= 0 then
        return
    end
    local scoreInfo = data.scoreInfo
    for _,v in pairs(scoreInfo) do
        local player = self:getPlayerBySeatID(v.seatID)
        v.posX, v.posY = player:getPlayerPosition()
        v.totalScore = v.currScore
        player:setScore(v.currScore)
        v.score = v.updateScore
        v.winType = 0
        if v.score > 0 then
            v.winType = 1
        elseif v.score < 0 then
            v.winType = -1
        end 
    end

    local actionGoldFly = cc.CallFunc:create(function ()
        self.table_:goldFly(data.scoreInfo)
    end)

    local actionDelay = cc.DelayTime:create(0.01)
    local actions = {}
    table.insert(actions, actionDelay)
    table.insert(actions, actionGoldFly)
    local sequence = transition.sequence(actions)
    self:runAction(sequence)
end

function TableController:doUpdateScore(data)
    self:doUpdateScore_(data)
end

function TableController:onPlayerPass_(event)
    if event.data.isReview then
        self:doPlayerPass_(event.data)
    else
        TaskQueue.add(handler(self, self.doPlayerPass_), TABLE_TIME.onPlayerPass_[1], TABLE_TIME.onPlayerPass_[2], event.data)
    end
end

function TableController:doAllPass_(data)
    -- self.actionButtonsController_:hideSelf()()()()()
    -- local player = self:getPlayerBySeatID(data.seatID)
    -- if not player then
    --     return
    -- end
    -- local card = data.card
    -- self.table_:setCurCards(0,false)
    -- local index = self:calcPlayerIndex(data.seatID)
    -- player:doAllPass(data.card,index,data.inFastMode) -- 弃牌
    -- for k,v in pairs(self.seats_) do
    --     v:pass()
    -- end
end

function TableController:onPlayAction_(event)
    print("onPlayAction(event)")
    if event.data.isReview then
        self:doPlayAction(event.data)
    else
        TaskQueue.add(handler(self, self.doPlayAction), TABLE_TIME.onPlayerPass_[1], TABLE_TIME.onPlayerPass_[2], event.data)
    end
end

function TableController:doPlayAction(data)
    dump(data, "doPlayAction")
    if 2 == data.code then  -- 已收到操作, 隐藏操作栏
        self.actionButtonsController_:hideSelf()
        return
    end
    if data.code ~= 0 then
        return
    end
    self.table_:setInPublicTime(false)  -- 公共牌时间结束
    local player = self.seats_[data.seatID]
    if player then
        player:doPlayAction(data)
    end
    local action = data.actType
    if CSMJ_ACTIONS.BU_GANG == action then
        self.table_:saveLastCard(data.seatID, data.cards, true)
    end
    if CSMJ_ACTIONS.QIANG_GANG_HU == action then
        local bePlayer = self.seats_[data.seatID2]
        if bePlayer then
            bePlayer:beQiangGang(self.table_:getLastCard())
        else
            printError("QIANG_GANG_HU ERROR, NOT SECOND PLAYER!")
        end
    end

    local lastSeatID = data.seatID2 or self.table_:getLastSeatID()
    local lastCard = self.table_:getLastCard()
    if data.cards2 then
        lastCard = data.cards2[1]
    end
    if table.indexof({CSMJ_ACTIONS.PENG, CSMJ_ACTIONS.CHI, CSMJ_ACTIONS.CHI_GANG}, action) ~= false then
        if self.seats_[lastSeatID] then
            self.seats_[lastSeatID]:removeChuPai(lastCard)
        end
        self.table_:removeLastCard()
        self:clearFocus_()
    end
    if CSMJ_ACTIONS.CHI_HU == action then
        if self.seats_[lastSeatID] then
            self.seats_[lastSeatID]:removeChuPai(lastCard)
        end
        self:clearFocus_()
    end
    if CSMJ_ACTIONS.ZHUA_NIAO == action then
        self.table_:setBirds(data.cards)
    end
    if table.indexof({CSMJ_ACTIONS.PENG, CSMJ_ACTIONS.CHI, CSMJ_ACTIONS.CHI_GANG, CSMJ_ACTIONS.AN_GANG, CSMJ_ACTIONS.BU_GANG}, action) ~= false then
        self:adjustMaJiang_(data.seatID, false, data.isDown)
    end
    self:setTurnTo_(data.seatID, 0)
end

function TableController:setTurnTo_(seatID, seconds, isPublicTime, isMoPai, isReview)
    if self.seats_[seatID] then
        self.table_:onTurnTo(seatID, seconds, isMoPai, self.seats_[seatID]:getIndex())
    end
    local Review = isReview or false
    print("·TableController:setTurnTo_===============··")
    print(self.isReview_)
    if self.seats_[seatID] then
        self.seats_[seatID]:beTurnTo(seconds, self.isReview_)
    end

    if not isPublicTime then
        for k, v in ipairs(self.seats_) do
            if k ~= seatID then
                v:stopZhuanQuanAction()
            else
                v:zhuanQuanAction(seconds)
            end
        end
    else
        if isPublicTime == 1 then
            for k, v in ipairs(self.seats_) do
                if k == seatID then
                    v:stopZhuanQuanAction()
                else
                    if k == self.hostPlayer_:getSeatID() then
                        if self.hasOP_ then
                            v:zhuanQuanAction(seconds)
                        else
                            v:stopZhuanQuanAction()
                        end
                    else 
                        v:zhuanQuanAction(seconds)
                    end
                end
            end
        end
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

function TableController:setHostPlayerState(offline)
    if self.hostPlayer_ then
        self.hostPlayer_:setOffline(offline, self.hostPlayer_:getIP())
    end
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
    local isHost = seatID == self.hostPlayer_:getSeatID()
    -- if isHost then
    --     self:clearAfterRoundOver_()
    -- end
    player:doReady(isReady)
    -- if (self.table_:isPlaying()) then
    --     player:showReady_(false)
    -- else
    --     player:showReady_(isReady)
    -- end
end

function TableController:clearAfterRoundOver_()
    self:resetRoundPlayer_()
end

function TableController:inShowActions()
    print("TableController:inShowActions()")
    return self.actionButtonsController_:inShowActions()
end

function TableController:doDealCards_(data)
    display.getRunningScene():piaoFenSelectHide_()
    local dealerSeatID = data.dealerSeatID
    self:playRoundStart_(dealerSeatID)
    self:playersRoundStart_()

    if data.isReview then
    else
        self:sendHandCards_(data.handCards)
    end
    self.table_:saveLastCard(0, 0)
    self.table_:setInPublicTime(false)
    self.table_:setMaJiangCount(self:calcLeftCards_())
    if dealerSeatID == self.hostPlayer_:getSeatID() then
        print("TableController:doDealCards_()actionButtonsController_whow")
        self.actionButtonsController_:showActions(self:getGameType())
    else
        print("TableController:doDealCards_()actionButtonsController_")
        self.actionButtonsController_:hideSelf()
    end
    self:hideReady(data)
    
end

function TableController:hideReady(data)
    if data.isReview then
        if data.cmdSeatID == self.hostPlayer_:getSeatID() then
            for k, v in ipairs(self.seats_) do
                v:showReady_(false)
            end
            self:stopAllZhuanQuanAction()
        end
    else
        for k, v in ipairs(self.seats_) do
            v:showReady_(false)
        end
        self:stopAllZhuanQuanAction()
    end
end


function TableController:onDealCards_(event)
    if event.data.isReview then
        self:doDealCards_(event.data)
    else
        TaskQueue.add(handler(self, self.doDealCards_), TABLE_TIME.onDealCards_[1], TABLE_TIME.onDealCards_[2], event.data)
    end
end

function TableController:doRoomInfo(data)
    self.table_:setConfigData(data.config)
    self.table_:setQiangZhiHuPai(data.config.rules.qiangZhiHuPai)
    self.table_:setOwner(data.creator or 0)
    self.table_:setTid(data.tid or dataCenter:getRoomID())
    self.table_:setClubID(data.clubID)
    for _, params in pairs(self.playerInfo) do
        self:doPlayerSitDownByInfo(params)
    end
    self.playerInfo = {}
    if data.creator == self.hostPlayer_:getUid() then
        dataCenter:setOwner(data.creator or 0)
    end
    self.table_:setFinishRound(data.roundIndex or 0)
    if data.leftCount then
        local count = data.leftCount or 0
        self.table_:setMaJiangCount(count)
    end

    if data.handCards then
        self.hostPlayer_:showCards(data.handCards)
    end
    if data.louHuPai then
        self.hostPlayer_:setLouHu(data.louHuPai)
    end
    local isBuGang = (data.lastAct and data.lastAct == CSMJ_ACTIONS.BU_GANG)
    if data.lastCards then
        self:setLastCard_(data.lastSeatID, data.lastCards, isBuGang)
        if #data.lastCards > 1 then
            local player = self:getPlayerBySeatID(data.turn)
            player:setInGangState(true)
        end
    end
    if data.status ~= TABLE_PLAYING then  -- 空闲中
        self.hostPlayer_:showReady_(self.hostPlayer_:getIsReady())
        self.hostPlayer_:removeAllCards_()
        self:stopAllZhuanQuanAction()
        for k, v in ipairs(self.seats_) do
            v:removeAllCards()
        end
        if data.status == TABLE_CHECKOUT then
            display.getRunningScene():piaoFenSelectHide_()
        end
        return
    end


    self:doResumeRoomInfo_(data)

    if data.isLastCardExist == 1 and data.lastSeatID then
        local player = self:getPlayerBySeatID(data.lastSeatID)
        if player then
            player:setReconnectFocusOn()
        end
    end
end

function TableController:doResumeRoomInfo_(data)
    if data.inFlow and data.inFlow > 0  then
        self:showCurrFlow_(data.inFlow, data)
    end

    if data.middleHu == 1 then
        self.tableView_:showBanBanHu(true)
    end
end

function TableController:doFlowInBeginOptionCall_(flow,data)
     print("111111111111doFlowInBeginOptionCall_") 
     for k,v in pairs(self.seats_) do
        if v:getSeatID() == self.hostPlayer_:getSeatID() and self.hostPlayer_:getIsChui() == -1 then
            
            self.tableView_:showChuiTool(true)
        end
        if v:getPlayer():getIsChui() ~= -1 then
            v:doFlow(-1)
        else
            v:doFlow(flow)
        end
    end


    local dealerSeatID = data.dealer
    self:playRoundStart_(dealerSeatID)
    self:playersRoundStart_()
end

function TableController:doFlowInHaidiChoosCall_(flow,data)
     print("doFlowInHaidiChoosCall_")
     dump(data)
     for k,v in pairs(self.seats_) do
        print(v:getSeatID()..self.hostPlayer_:getSeatID()..data.turn)
        if v:getSeatID() == self.hostPlayer_:getSeatID() and self.hostPlayer_:getSeatID() == data.turn then
            print("showhidi")
            self.tableView_:showHaiDiTool(true)
        end
        if v:getPlayer():getIsChui() ~= -1 then
            v:doFlow(-1)
        else
            v:doFlow(flow)
        end
    end


    local dealerSeatID = data.dealer
    self:playRoundStart_(dealerSeatID)
    self:playersRoundStart_()
end
function TableController:doFlowInHaiDiCall_(flow,data)
     print("doFlowInHaidiCall_")
     dump(data)
     local dealerSeatID = data.dealer
    self:playRoundStart_(dealerSeatID)   
    self:resumePlayerStates_()

    self.table_:setInPublicTime(false)
    self.table_:setMaJiangCount(data.leftCount)
    -- self.seats_[data.turn]:addMaJiang(data.card or 0, data.isDown) -- 已经再playersitdown 处理了
    self.seats_[data.turn]:setLouHu(nil)  -- 清空漏胡列表

    self:setTurnTo_(data.turn, 10, nil, true)
end

function TableController:doFlowInIDLE_(data)
    print("doFlowInIDLE_")
end

function TableController:doFlowInChuPai_(flow,data)
    local dealerSeatID = data.dealer
    self:playRoundStart_(dealerSeatID)
    print("·doFlowInChuPai_··")

    self:resumePlayerStates_()
    self.actionButtonsController_:hideSelf()
    local dataTurnTo = {seatID = data.turn, remainTime = data.remainSeconds}
    self:doTurnTo_(dataTurnTo)
end

function TableController:doFlowInChuPaiCall_(flow,data)
    local dealerSeatID = data.dealer
    self:playRoundStart_(dealerSeatID)   
    self:resumePlayerStates_()

     self.table_:setInPublicTime(inPublicTime)
    local turntodata = {seatID = data.turn, remainTime = data.remainTime or 0, isPublicTime = 0}
    self:doTurnTo_(turntodata)
    local specialAct = data.specialAct or 0
    -- if inPublicTime and 0 == specialAct then
    --     self.actionButtonsController_:showActions(self:getGameType())
    -- end
    self.setLastCard_(data.lastSeatID, data.lastCards)
    self:setTurnTo_(self.table_:getLastSeatID(), data.remainSeconds, 1)
    self.table_:setInPublicTime(true)
    -- self.actionButtonsController_:showActions(self:getGameType())
    print(self.table_:getQiangZhiHuPai(), "shit")
    if data.operates and #data.operates >0 then
        self.actionButtonsController_:showOperates(data.operates, self:getGameType(), self.table_:getQiangZhiHuPai())
    end
end

function TableController:doFlowInMoPai_(flow,data)
    self:resumePlayerStates_()

    print("doFlowInMoPai_")
    

end

function TableController:doFlowInQiangGangHuCall_(flow,data)
    local dealerSeatID = data.dealer
    self:playRoundStart_(dealerSeatID)   
    self:resumePlayerStates_()
    self.table_:setInPublicTime(false)
    self.table_:setMaJiangCount(data.leftCount)
    self.seats_[data.turn]:setLouHu(nil)  -- 清空漏胡列表
    -- self:setTurnTo_(data.turn, 10, nil, true)
    print("doFlowInQiangGangHuCall_")
end

function TableController:doFlowInMoPaiCall_(flow,data)
    dump(data, "T_IN_MO_PAI_CALL")  
    local dealerSeatID = data.dealer
    self:playRoundStart_(dealerSeatID)   
    self:resumePlayerStates_()

    self.table_:setInPublicTime(false)
    self.table_:setMaJiangCount(data.leftCount)
    -- self.seats_[data.turn]:addMaJiang(data.card or 0, data.isDown) -- 已经再playersitdown 处理了
    self.seats_[data.turn]:setLouHu(nil)  -- 清空漏胡列表
    -- if data.card and data.card > 0 then -- 已经再playersitdown 处理了
    --     self.actionButtonsController_:showOperates(data.operates, self:getGameType())
    -- else
    --     self.actionButtonsController_:hide()()()
    -- end

    self:setTurnTo_(data.turn, 10, nil, true)
    -- self:setTurnTo_(data.turn)

end
function TableController:doFlowInBeforeChuPai_(flow,data)
    dump(data, "doFlowInBeforeChuPai_")  
    local dealerSeatID = data.dealer
    self:playRoundStart_(dealerSeatID)   
    self:resumePlayerStates_()

    self.seats_[data.turn]:setLouHu(nil)  -- 清空漏胡列表
 
   if data.operates and #data.operates >0 then
        self.actionButtonsController_:showOperates(data.operates, self:getGameType(), self.table_:getQiangZhiHuPai())
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

function TableController:resumePlayerStates_()
    for _, player in ipairs(self.seats_) do
        if player:isLocked() then
            player:doRoundStart(true)
            player:onGangLock(true)
        else
            player:doRoundStart(true)
        end
    end
end

function TableController:resumePlayerReconnect_()
    for _, player in ipairs(self.seats_) do
        player:doReconnect(true)
    end
end

function TableController:makeRuleString(spliter)
    local ret = self.tableView_:makeRuleString(spliter or ",")
    ret = tostring(ret)
    -- local ret1 = self.tableView_:makeAddRuleString(spliter or ",")
    -- ret1 = tostring(ret1)
    return ret -- .. (spliter or "") .. ret1
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

function TableController:isSortBird()
    return self.tableView_:isSortBird()
end

function TableController:isNoBird()
    return self.tableView_:isNoBird()
end

function TableController:getRoomInfo()
    return self.tableView_:getRoomInfo()
end

function TableController:resumePlayer_(player, data)
    local cardCount = checkint(data.countCard)
    if data.isPrepare then
        player:doReady(true)
        player:setIsReady(true)
    else
        player:setIsReady(false)
        player:showReady_(false)
    end
    if data.status ~= 2 then
        return
    end
    player:doReconnectStart(true)
    -- player:chui(data.chui, true)
    if data.lock then
        player:onGangLock(data.lock)
    end
    player:setOffline(data.offline, data.IP)

    if data.outCards then  -- 恢复出牌
        player:setChuPai(data.outCards)
    end
    local num = 0
    if data.chengPai then  -- 恢复外牌
        local waiPai = {}
        for _,v in ipairs(data.chengPai) do
            if v.actType == CSMJ_ACTIONS.PENG then
                table.insert(waiPai, {action = v.actType, cards = {v.cards[1], v.cards[2], v.cards[3]}, seatID = v.seatID})
            elseif v.actType == CSMJ_ACTIONS.AN_GANG or v.actType == CSMJ_ACTIONS.BU_GANG or v.actType == CSMJ_ACTIONS.CHI_GANG then
                table.insert(waiPai, {action = v.actType, cards = {v.cards[1], v.cards[2], v.cards[3], v.cards[4]}, seatID = v.seatID})
            elseif v.actType == CSMJ_ACTIONS.CHI then
                table.insert(waiPai, {action = v.actType, cards = v.cards, seatID = v.seatID})
            end
        end
        player:setWaiPai(waiPai)
        num = #data.chengPai * 3
    end

    local isDown = data.isDown
    if not player:isHost() and 0 < cardCount then  -- 恢复手牌
        local cards = {}
        for i = 1, cardCount do
            table.insert(cards, 0)
        end
        player:showCards(cards, isDown, nil, num)
    end
    if data.handCards then
        player:showCards(data.handCards, isDown, nil, num)
        if #data.handCards == 14 or 
            #data.handCards == 11 or 
            #data.handCards == 8 or
            #data.handCards == 5 or
            #data.handCards == 2
            then
            self.table_:setInPublicTime(false)
        end
    end
    if data.piao_data and data.status and data.status == 2 then
        if data.piao_data[1].score == -1 then
            local event = {}
            event.data = {}
            event.data.piao_time = data.time
            display.getRunningScene():piaoFenSelectShow_(event.data)
        else
            for i = 1,#data.piao_data do
                local event = {}
                event.data = {}
                event.data.score = data.piao_data[i].score
                event.data.seat_id = data.piao_data[i].seat_id
                display.getRunningScene():showPiaoResult_(event)
            end
        end
    end
    if data.status and data.status == 2 then
        local dataInfo = {} 
        dataInfo.cards = nil
        dataInfo.huNameList = nil
        if data.cards then
            dataInfo.cards = data.cards
        end
        if data.showCards then
            dataInfo.cards = data.showCards
        end
        if data.huNameList then
            dataInfo.huNameList = data.huNameList
        end
        if dataInfo.cards and dataInfo.huNameList then
            player:onActionTanPai(dataInfo,self.isReview_,true)
        end
    end
end

function TableController:calcNextSeatID_(seatID)
    local nextSeatID = seatID + 1
    if nextSeatID <= 4 then
        return nextSeatID
    end
    return 1
end

function TableController:setLastCard_(seatID, card, isBuGang)
    if not seatID or not card then
        return
    end
    self.table_:saveLastCard(seatID, card, isBuGang)
end

function TableController:doPlayerChuPai_(data)
    if not data then
        return
    end
    
    if data.code ~= 0 then
        app:enterLoginScene()
    end

    if not data.seatID then
        return
    end

    if (not data.isReview) and (self.hostPlayer_:getSeatID() == data.seatID) then
        return
    end
    self:doPlayerChuPai(data)
end

function TableController:doPlayerChuPai(data)
    self:setLastCard_(data.seatID, {data.cards})
    self:adjustMaJiang_(data.seatID, true, data.isDown)
    self:setFocusOn_(data.seatID)
    local player = self:getPlayerBySeatID(data.seatID)
    player:addChuPai(data.cards, data.dennyAnim)

    for k, v in ipairs(self.seats_) do
        if k == data.seatID then
            v:stopZhuanQuanAction()
        else
            if not data.isReview and k == self.hostPlayer_:getSeatID() then
                self.seats_[self.hostPlayer_:getSeatID()]:stopZhuanQuanAction()
            else
                v:zhuanQuanAction(seconds)
            end
        end
    end
    self.tableView_:stopEffect()
end

function TableController:onPlayerChuPai_(event)
    if event.data.isReview then
        self:doPlayerChuPai_(event.data)
    else
        -- self:doPlayerChuPai_(event.data)
        TaskQueue.add(handler(self, self.doPlayerChuPai_), TABLE_TIME.onPlayerChuPai_[1], TABLE_TIME.onPlayerChuPai_[2], event.data)
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

    print("doNotifyHu_actionButtonsController_")
    self.actionButtonsController_:showCanActions(operates)
    for k, player in ipairs(self.seats_) do
        if player:getSeatID() ~= data.seatID then
            player:doNotifyHu(cards)
        else
            player:doNotifyHu(cards)
        end
    end
end

function TableController:doPlayerChui_(data)
    dump(data)
    if data.code ~= 0 then return end
    local seatID = data.seatID
    local isChui = data.chui

    if data.seatID == self.hostPlayer_:getSeatID() then
        self.tableView_:showChuiTool(false)
    end
    for k, player in ipairs(self.seats_) do
        if k == seatID then 
            player:chui(isChui, nil, data.inFastMode)
            player:doFlow(-1)
            if isChui == 2 then
                gameAudio.playHumanSound("chui.mp3", player:getSex())
            elseif isChui == 1 then
                gameAudio.playHumanSound("buchui.mp3", player:getSex())
            end
            break
        end
    end
end

function TableController:doBeginChui_(data)
    print("用户开始锤")
    self.tableView_:showChuiTool(true)
   for k,v in pairs(self.seats_) do
       v:doFlow(2)
    end
end

-- 玩家提牌
function TableController:onsBeginChui_(event)
    if event.data.isReview then
        self:doBeginChui_(event.data)
    else
        local preTime = 0
        if event.data.isQuick == 1 then
            preTime = TABLE_TIME.doBeginChui_[1]
        end
        TaskQueue.add(handler(self, self.doBeginChui_), preTime, TABLE_TIME.doBeginChui_[2], event.data)
    end
end

function TableController:onPlayerChui_(event)
    if event.data.isReview then
        self:doPlayerChui_(event.data)
    else
        local preTime = 0
        if event.data.isQuick == 1 then
            preTime = TABLE_TIME.doPlayerChui_[1]
        end
        TaskQueue.add(handler(self, self.doPlayerChui_), preTime, TABLE_TIME.doPlayerChui_[2], event.data)
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
    self.table_:setInPublicTime(false)
    self.table_:setMaJiangCount(data.leftCount)
    local isDown = false
    if data.isReview then 
        isDown = true
    end
    local player = self.seats_[data.seatID]
    if data.handCards then
        player:resumeTanPai()
        player:onMoPai(data.card or 0, isDown, data.handCards)
    else
        player:addMaJiang(data.card or 0, isDown)
        player:resumeTanPai(self.isReview_)
    end
   
    self.seats_[data.seatID]:setLouHu(nil)  -- 清空漏胡列表
    self.currentMoCard_ = data.card
    if data.operates and #data.operates >0 then
        self.actionButtonsController_:showOperates(data.operates, self:getGameType(), self.table_:getQiangZhiHuPai())
    else
        self.actionButtonsController_:hideSelf()
        if player:isLocked() and player:isHost() then
            self.tableView_:performWithDelay(function()
                dataCenter:sendOverSocket(COMMANDS.MMMJ_CHU_PAI, {
                    cards = data.card
                })
                local info = {}
                info.code = 0
                info.cards = data.card
                info.isDown = true
                info.seatID = player:getSeatID()
                self:doPlayerChuPai(info)
                self.currentMoCard_ = 0
                end, 1)
        end
    end
    self:setTurnTo_(data.seatID, 20, nil, true, false, data.isReivew)
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

function TableController:getHuInfo()
    self.huInfo_ = self.huInfo_ or {}
    for i=1, #self.huInfo_ do
        local v = self.huInfo_[i]
        local index = i
        local preIndex = i
        local player = self:getPlayerBySeatID(v.seatID)
        local prePlayer = self:getPlayerBySeatID(v.preSeatID)
        if player then
            index = player:getIndex()
        end
        if prePlayer then
            preIndex = prePlayer:getIndex()
        end
        v.index = index
        v.preIndex = preIndex
    end
    return {isTongPao = self.isTongPao_, isSortBird = self:isSortBird(), huInfo = self.huInfo_}
end

function TableController:doUserHu_(data)
    self.isTongPao_ = false
    self.huInfo_ = {}
    print("douserhu")
    dump(data)
    if data.code == -8 then
        return
    end
    if data.huInfo then
        if 0 == data.huInfo.isFinish then  -- 已收到操作, 隐藏操作栏
            self.actionButtonsController_:hideSelf()
            return
        end
    end
    if data.code ~= 0 then
        return
    end
    self.table_:setInPublicTime(false)  -- 公共牌时间结束

    local huInfo = clone(data.huInfo)
    dump(huInfo)
    self.huInfo_ = clone(data.huInfo)
    huInfo = checktable(huInfo)
    self.isTongPao_ = #huInfo > 1
    for i=1, #huInfo do
        local player = self.seats_[huInfo[i].seatID]
        if player then
            player:onActionHu(huInfo[i])
        end
    end

    self:clearFocus_()
    self.tableView_:stopEffect()
end

function TableController:isOneBrid()
    return self.tableView_:isOneBrid()
end

function TableController:doHuPai(data)
    local winner = clone(data.winInfo.winner)
    winner = checktable(winner)

    for i=1, #winner do
        local player = self:getPlayerBySeatID(winner[i])
        if player then
            player:setHuPai(data)
        end
    end
end

-- 玩家提牌
function TableController:onUserHu_(event)
    if event.data.isReview then
        self:doUserHu_(event.data)
    else
        local time2 = TABLE_TIME.onUserHu_[2]
        -- if self:isNoBird() then
        --     time2 = -1
        --     display.getRunningScene():onShowTempOK_(0.5)
        -- end
        TaskQueue.add(handler(self, self.doUserHu_), TABLE_TIME.onUserHu_[1], time2, event.data)
    end
end

function TableController:doCSTanPai_(data)
    local diceList = clone(data.diceList)
    if not data.isReview then 
        self.tableView_:doDiceAnim(diceList, true, 1)
    else
        self.tableView_:doDiceAnim(diceList, true, 0)
    end
    self.tableView_:showBanBanHu(true)
    for k,v in pairs(data.seats) do
        local player = self:getPlayerBySeatID(v.seatID)
        if player then
            player:onActionTanPai(v, data.isReview)
        end
    end
end

-- 玩家提牌
function TableController:onCSTanPai_(event)
    if event.data.isReview then
        self:doCSTanPai_(event.data)
    else
        TaskQueue.add(handler(self, self.doCSTanPai_), TABLE_TIME.onCSTanPai_[1], TABLE_TIME.onCSTanPai_[2], event.data)
    end
end

function TableController:doPublicTime_(data)
    dump(data, "doPublicTime_")
    self.table_:setInPublicTime(true)
    self.table_:setMaJiangCount(data.leftCount)
    -- self.seats_[data.seatID]:addMaJiang(data.card or 0, data.isDown)
    -- self.seats_[data.seatID]:setLouHu(nil)  -- 清空漏胡列表

    for k, v in ipairs(self.seats_) do
        if k ~= data.seatID then
            v:zhuanQuanAction()
        else
            v:stopZhuanQuanAction()
        end
    end
    
    if data.operates and #data.operates >0 then
        self.actionButtonsController_:showOperates(data.operates, self:getGameType(), self.table_:getQiangZhiHuPai())
    else
        self.actionButtonsController_:hideSelf()
        if not data.isReview and self.seats_[self.hostPlayer_:getSeatID()] then
            self.seats_[self.hostPlayer_:getSeatID()]:stopZhuanQuanAction()
        end
    end
end

-- 玩家提牌
function TableController:onPublicTime_(event)
    print("onPublicTime_(event)")
    if event.data.isReview then
        self:doPublicTime_(event.data)
    else
        TaskQueue.add(handler(self, self.doPublicTime_), TABLE_TIME.doPublicTime_[1], TABLE_TIME.doPublicTime_[2], event.data)
    end
end

function TableController:doMJPlayerOperate_(data)
    dump(data, "doMJPlayerOperate_")
    -- self.seats_[data.seatID]:addMaJiang(data.card or 0, data.isDown)
    -- self.seats_[data.seatID]:setLouHu(nil)  -- 清空漏胡列表

    for k, v in ipairs(self.seats_) do
        if k ~= data.seatID then
            v:zhuanQuanAction()
        else
            v:stopZhuanQuanAction()
        end
    end
    
    if data.operates and #data.operates >0 then
        self.actionButtonsController_:showOperates(data.operates, self:getGameType(), self.table_:getQiangZhiHuPai())
    else
        self.actionButtonsController_:hideSelf()
        if self.seats_[self.hostPlayer_:getSeatID()] then
            self.seats_[self.hostPlayer_:getSeatID()]:stopZhuanQuanAction()
        end
    end
end

-- 玩家提牌
function TableController:onMJPlayerOperate_(event)
    print("onPublicTime_(event)")
    if event.data.isReview then
        self:doMJPlayerOperate_(event.data)
    else
        TaskQueue.add(handler(self, self.doMJPlayerOperate_), TABLE_TIME.onMJPlayerOperate_[1], TABLE_TIME.onMJPlayerOperate_[2], event.data)
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
    if data.isFinish == 0 then  -- 已收到操作, 隐藏操作栏
        self.actionButtonsController_:hideSelf()
        return
    end
    if data.code == -8 then
        return
    end
    self.table_:setInPublicTime(false)  -- 公共牌时间结束
    local player = self.seats_[data.seatID]
    if player then
        local chiData = {
            action =  CSMJ_ACTIONS.CHI,
            cards = data.operateCards,
            card = data.card,
            dennyAnim = false,
        }
        player:onActionChi(chiData)
    end

    local lastSeatID = data.fromSeatID or self.table_:getLastSeatID()
    local lastCard = self.table_:getLastCard()
    if data.card then
        lastCard = data.card
    end
    if self.seats_[lastSeatID] then
        self.seats_[lastSeatID]:removeChuPai(lastCard)
    end
    self.table_:removeLastCard()
    self:clearFocus_()
    if data.seatID == self.hostPlayer_:getSeatID() then
        local cards = clone(self.hostPlayer_:getCards())
        BaseAlgorithm.sort(cards)
        local card = cards[#cards]
        table.remove(cards,#cards)
        self.seats_[data.seatID]:onMoPai(card or 0, isDown, cards)
    else
        self:adjustMaJiang_(data.seatID, false, true)
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
    if data.isFinish == 0 then  -- 已收到操作, 隐藏操作栏
        self.actionButtonsController_:hideSelf()
        return
    end
    if data.code == -8 then
        return
    end

    self.actionButtonsController_:hideSelf()
    self.table_:setInPublicTime(false)  -- 公共牌时间结束
    local player = self.seats_[data.seatID]
    if player then
        local pengdata = {
        action =  CSMJ_ACTIONS.PENG,
        cards = {data.card,data.card,data.card},
        dennyAnim = false,
        }
        player:onActionPeng(pengdata)
    end

    local lastSeatID = data.fromSeatID or self.table_:getLastSeatID()
    local lastCard = self.table_:getLastCard()
    if data.card then
        lastCard = data.card
    end
    if self.seats_[lastSeatID] then
        self.seats_[lastSeatID]:removeChuPai(lastCard)
    end
    self.table_:removeLastCard()
    self:clearFocus_() 
    if  data.seatID == self.hostPlayer_:getSeatID() then
        local cards = clone(self.hostPlayer_:getCards())
        BaseAlgorithm.sort(cards)
        local card = cards[#cards]
        table.remove(cards,#cards)
        self.seats_[data.seatID]:onMoPai(card or 0, isDown, cards)
    else
        self:adjustMaJiang_(data.seatID, false, true)
    end
end

-- 玩家提牌
function TableController:onUserPeng_(event)
    if event.data.isReview then
        self:doUserPeng_(event.data)
    else
        self:doUserPeng_(event.data)
    end
end

function TableController:refreshLeftCards_()
    local leftCount = self.table_:getLeftCards()
    if (leftCount and leftCount > 1) then
        self.table_:setLeftCards(leftCount - 1)
    end
end

-- 玩家提牌
function TableController:doUserGang_(data)
    local diceList = {math.random(1,6), math.random(1,6)}
    self.tableView_:doDiceAnim(diceList, false, 1)

    if data.isFinish == 0 then  -- 已收到操作, 隐藏操作栏
        self.actionButtonsController_:hideSelf()
        return
    end
    self.table_:setInPublicTime(false)  -- 公共牌时间结束
    local player = self.seats_[data.seatID]
    if player then
        if self.table_:getLastCard() ~= 0 and #self.table_:getLastCard() > 1 then
            player:setInGangState(true)
        end
        player:onActionGang(data)
    end
    local action = data.act
    if CSMJ_ACTIONS.BU_GANG == action then
        self.table_:saveLastCard(data.seatID, {data.card}, true)
    end

    local lastSeatID = data.fromSeatId or self.table_:getLastSeatID()
    local lastCard = self.table_:getLastCard()

    lastCard = data.card

    if table.indexof({CSMJ_ACTIONS.PENG, CSMJ_ACTIONS.CHI, CSMJ_ACTIONS.CHI_GANG}, action) ~= false or (data.fromSeatId and data.fromSeatId ~= self.hostPlayer_:getSeatID()) then
        if self.seats_[lastSeatID] then
            self.seats_[lastSeatID]:removeChuPai(lastCard)
        end
        self.table_:removeLastCard()
        self:clearFocus_()
    end
   
    if table.indexof({CSMJ_ACTIONS.PENG, CSMJ_ACTIONS.CHI, CSMJ_ACTIONS.CHI_GANG, CSMJ_ACTIONS.AN_GANG, CSMJ_ACTIONS.BU_GANG, CSMJ_ACTIONS.BU_ZHANG}, action) ~= false then
        self:adjustMaJiang_(data.seatID, false, data.isDown)
    end
end

-- 玩家提牌
function TableController:onUserGang_(event)
    if event.data.isReview then
        self:doUserGang_(event.data)
    else
        local preTime = 0
        -- if event.data.isQuick == 1 then
        --     preTime = TABLE_TIME.onUserGang_[1]
        -- end

        TaskQueue.add(handler(self, self.doUserGang_), TABLE_TIME.onUserGang_[1], TABLE_TIME.onUserGang_[2], event.data)
    end 
end

-- 玩家提牌
function TableController:doUserBu_(data)
    dump(data, "TableController:doUserBu_(")
    if data.isFinish == 0 then  -- 已收到操作, 隐藏操作栏
        self.actionButtonsController_:hideSelf()
        return
    end
    self.table_:setInPublicTime(false)  -- 公共牌时间结束
    local player = self.seats_[data.seatID]
    if player then
        player:onActionBu(data)
    end
    local action = data.act
    if CSMJ_ACTIONS.MING_BU == action then
        self.table_:saveLastCard(data.seatID, {data.card}, true)
    end

    local lastSeatID = data.fromSeatId or self.table_:getLastSeatID()
    local lastCard = self.table_:getLastCard()

    lastCard = data.card

    if table.indexof({CSMJ_ACTIONS.PENG, CSMJ_ACTIONS.CHI, CSMJ_ACTIONS.CHI_GANG, GONG_BU}, action) ~= false or (data.fromSeatId and data.fromSeatId ~= self.hostPlayer_:getSeatID()) then
        if self.seats_[lastSeatID] then
            self.seats_[lastSeatID]:removeChuPai(lastCard)
        end
        self.table_:removeLastCard()
        self:clearFocus_()
    end
   
    if table.indexof({CSMJ_ACTIONS.PENG, CSMJ_ACTIONS.CHI, CSMJ_ACTIONS.CHI_GANG, CSMJ_ACTIONS.AN_GANG, CSMJ_ACTIONS.BU_GANG, CSMJ_ACTIONS.BU_ZHANG, CSMJ_ACTIONS.GONG_BU, CSMJ_ACTIONS.AN_BU, CSMJ_ACTIONS.MING_BU}, action) ~= false then
        self:adjustMaJiang_(data.seatID, false, data.isDown)
    end
    -- self:setTurnTo_(data.seatID, 0)

     for _,v in pairs(checktable(data.seats)) do
        local p = self:getPlayerBySeatID(v.seatID)
        p:setScore(v.nowScore)
        -- v:showScoreAnim(v.score)
    end
end

-- 玩家提牌
function TableController:onUserBu_(event)
    print("onUserBu_")
    if event.data.isReview then
        self:doUserBu_(event.data)
    else
        local preTime = 0
        if event.data.isQuick == 1 then
            preTime = TABLE_TIME.onUserBu_[1]
        end

        self:doUserBu_(event.data)
        -- TaskQueue.add(handler(self, self.doUserBu_), preTime, TABLE_TIME.onUserBu_[2], event.data)
    end 
end

-- 海底
function TableController:doMJHaidi_(data)
    dump(data, "TableController:doMJHaidi_(")
    
    if data.seatID  == self.hostPlayer_:getSeatID() then
        self.tableView_:showHaiDiTool(true)
    end    
    if data.isFinish == 1 then
        self.tableView_:showHaiDiTool(false)
    end
    for k,v in pairs(self.seats_) do
        v:onGangLock(true)
    end
end

-- 海底
function TableController:onMJHaiDi_(event)
    print("onUserBu_")
    if event.data.isReview then
        self:doMJHaidi_(event.data)
    else
        local preTime = 0
        if event.data.isQuick == 1 then
            preTime = TABLE_TIME.onMJHaidi_[1]
        end

        self:doMJHaidi_(event.data)
        -- TaskQueue.add(handler(self, self.onMJHaiDi_), preTime, TABLE_TIME.onMJHaiDi_[2], event.data)
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

function TableController:setFocusOn_(seatID)
    if not self.seats_[seatID] then
        return
    end
end

function TableController:doPlayerSitDown(params)
    local rule = self:getRoomConfig()
    if rule and rule.ruleDetails then
        self:doPlayerSitDownByInfo(params)
    else
        table.insert(self.playerInfo,params)
    end
end

function TableController:doPlayerSitDownByInfo(params)
    local playerData = params
    local data = json.decode(playerData.data)
    assert(playerData and data.uid and playerData.seatID, "sitDown fail by error data")
    table.merge(playerData, data)
    local player = self:getPlayerBySeatID(params.seatID)
    self:setRoomPlayerCount_()
    if params.uid == selfData:getUid() then
        self.hostPlayer_ = player:getPlayer()
        self.actionButtonsController_:setHostPlayer(self.hostPlayer_)
        self:initHostPlayerEvent_()
        self.hostSeatID_ = player:getSeatID()        
        if params.operates and #params.operates > 0 then
            self.table_:saveLastCard(self.hostSeatID_, {params.operates[1].operate_info[1].card})
            self.actionButtonsController_:showOperates(params.operates, self:getGameType(), self.table_:getQiangZhiHuPai())
            self.hasOP_ = true
        else
            -- self.actionButtonsController_:hideSelf()
            self.hasOP_ = false
        end
    end
    player:sitDown(params.seatID, playerData)
    self:changeUserPosByRule_()
    self:resumePlayer_(player, params)
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

function TableController:onHostPlayerTingEvent_(event)
    if not event.isReview then
        self.table_:showTingButton(event.isTing)
    end
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
        print("adjustMaJiang_ return")
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
        self.seats_[i] = PlayerController.new(i, self.tableView_.nodeHostMaJiang_):addTo(self.nodePlayers_, -i)
        self.seats_[i]:setTable(self.table_)
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
    if self.hostPlayer_ and self.hostPlayer_:isSitDown() then
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

function TableController:calcLeftCards_()
    local config = self.tableView_:getRoomConig()
    local TOTAL_MAJIANG = 108
    local TOTAL_MAJIANG_NAI_ZI = 112
    local num = TOTAL_MAJIANG
    if config.isLaiZi then
        num = TOTAL_MAJIANG_NAI_ZI
    end

    local TOTAL_SEND = 53
    return num - TOTAL_SEND
end

function TableController:stopTimer()
    self.tableView_:stopTimer()
end

function TableController:hideActionBar()
    self.actionButtonsController_:hideSelf()         
    print("hide (operates)1")
end

function TableController:doTianHuStart_(data)

end

function TableController:doTianhuEnd_(data)

end
 
function TableController:onTianHuEnd_(event)

end

function TableController:onTianHuStart_(event)

end

function TableController:onRoundStart_(event)
    TaskQueue.continue()
    if event.data.isReview then
        self:doRoundStart_(event.data)
    else
        TaskQueue.add(handler(self, self.doRoundStart_), TABLE_TIME.onRoundStart_[1], TABLE_TIME.onRoundStart_[2], event.data)
    end
end 

function TableController:playersRoundStart_()
    for i,v in ipairs(self.seats_) do
        v:doRoundStart(false)
    end
end

function TableController:playRoundStart_(dealerSeatID)
    local dealerIndex = self:calcPlayerIndex(dealerSeatID)
    print("playRoundStart_"..dealerIndex)
    self.table_:doRoundStart(dealerSeatID, dealerIndex)
end

function TableController:doRoundStart_(data)
    self.isGameOver = false
    local dealerSeatID = data.dealerSeatID
    self:playRoundStart_(dealerSeatID)
    self:playersRoundStart_()
    self.table_:setFinishRound(data.seq)
end

-- 结算过程
function TableController:doRoundOver(data)
    self.actionButtonsController_:hideSelf()
    self.tableView_:hideDirectorController()            
    print("3hide (operates)")

    self:clearFocus_()
    self.table_:doRoundOver(data)

    self:stopAllZhuanQuanAction()
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
                v:showCards(clone(blankCards13))
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

function TableController:getAllPlayerOutCards()
    local cards = {}

    for k, playerController in ipairs(self.seats_) do
        cards[k] = {}
        local playerCards = playerController:getOutCards()
        for index, card in ipairs(playerCards) do
            table.insert(cards[k], card)
        end
    end

    return cards
end

function TableController:checkOutCards(outCards)
    local playerCards = self:getAllPlayerOutCards()
    for _, v in ipairs(outCards) do
        local cards = playerCards[v.seatID]
        if cards == nil or v.outCardLen ~= #cards then
            return false
        end
    end

    return true
end

function TableController:doTurnTo_(data)
    if data.outCards ~= nil then
        local isRight = self:checkOutCards(data.outCards)
        if not isRight then
            dataCenter:sendOverSocket(COMMANDS.MMMJ_GET_ALL_PLAYER_CARDS)
        end
    end
    -- dump(data, "doTurnTo_")
    local seatID = data.seatID
    local seconds = data.remainTime
    assert(seatID)
    self:setTurnTo_(seatID, seconds, data.isPublicTime, data.isReview)
    -- if seatID == self.hostPlayer_:getSeatID() then
    --     if self.hostPlayer_:getLastCard() > 0 then  -- 摸牌后操作
    --         self.actionButtonsController_:showActions(self:getGameType())
    --     else  -- 出牌中
    --         self.actionButtonsController_:hide()           
    --          print("hide (operates)4")

    --     end
    -- end
end

function TableController:onCSMJUserAfterGang_(event)
    local data = event.data
    -- if data.isReview then
        -- self:doCSMJUserAfterGang_(data)
    -- else
        TaskQueue.add(handler(self, self.doCSMJUserAfterGang_), TABLE_TIME.onCSMJUserAfterGang_[1], TABLE_TIME.onCSMJUserAfterGang_[2], data)
    -- end
end

function TableController:doCSMJUserAfterGang_(data)
    dump(data, "TableController:doCSMJUserAfterGang_")
    local cards = data.cards
    self:setLastCard_(data.seatID, data.cards)
    self:adjustMaJiang_(data.seatID, true, data.isDown)
    self:setFocusOn_(data.seatID)
    local player = self:getPlayerBySeatID(data.seatID)
    player:addAfterGangPai(data.cards, data.dennyAnim)
    self.tableView_:showAfterGangPaiAnim_(data.cards)
    for k, v in ipairs(self.seats_) do
        if k == data.seatID then
            v:stopZhuanQuanAction()
        else
            if k == self.hostPlayer_:getSeatID() then
                self.seats_[self.hostPlayer_:getSeatID()]:stopZhuanQuanAction()
            else
                v:zhuanQuanAction(seconds)
            end
        end
    end

    self.tableView_:stopEffect()
end

function TableController:clearFocus_()
    self.tableView_:focusOff()
end

function TableController:resetPopUpPokers()
    self.tableView_:resetPopUpPokers()
end

function TableController:getTableView()
    return self.tableView_
end

function TableController:getRoomConfig()
    return self.table_:getConfigData()
end

function TableController:resetRoundPlayer_()
    for k,v in pairs(self.seats_) do
        if v:getPlayer() then
            v:getPlayer():resetPlayer()
        end
    end
end

function TableController:stopAllZhuanQuanAction()
    for k, v in ipairs(self.seats_) do
        v:stopZhuanQuanAction()
    end
end

function TableController:getGameType()
    local ret = 1
    if self.tableView_ then
    end
    return ret
end

function TableController:getTable()
    return self.table_
end 

function TableController:getHostSeatID()
    return self.hostSeatID_
end

function TableController:getHostPlayer()
    return self.hostPlayer_
end

function TableController:isMyTable()
    return self:getHostPlayer():getUid() == self.table_:getOwner()
end

function TableController:changeUserChuPaiCount_()
    local rule = self:getRoomConfig()
    if rule and rule.ruleDetails and rule.ruleDetails.totalSeat and rule.ruleDetails.totalSeat == 2 
        and rule.ruleDetails.fullPai and rule.ruleDetails.fullPai == 1 then
        for i = 1,4 do
            local player = self:getPlayerBySeatID(i)
            player:setChuPaiCount_(15)
        end
    end
end

function TableController:changeUserPosByRule_()
    local rule = self:getRoomConfig()
    dump(rule,"rulerule")
    if rule and rule.ruleDetails and rule.ruleDetails.totalSeat and rule.ruleDetails.totalSeat == 2 then
        local hostSeatID = self:getHostSeatID()
        local changeTo,changeFrom
        if hostSeatID == 1 then
            changeTo,changeFrom = 2,3
        elseif hostSeatID == 2 then
            changeTo,changeFrom = 1,4
        end
        local formPlayer = self:getPlayerBySeatID(changeFrom)
        local toPlayer = self:getPlayerBySeatID(changeTo)
        formPlayer:setIndex(self:calcPlayerIndex(changeTo))
        toPlayer:setIndex(self:calcPlayerIndex(changeFrom))
    end
    self:changeUserChuPaiCount_()
    
end

return TableController
