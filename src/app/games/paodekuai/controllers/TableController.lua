local PlayerController = import(".PlayerController")
local BaseTableController = import("app.controllers.BaseTableController")
local TableController = class("TableController", BaseTableController)
local BaseAlgorithm = import("app.games.paodekuai.utils.BaseAlgorithm")
local PdkAlgorithm = import("app.games.paodekuai.utils.PdkAlgorithm")
local PokerTable = import("app.games.paodekuai.models.PokerTable")
local HOST_POSITION_INDEX = 1  -- 主机玩家的位置固定为1号

local ZHUANG = 1
local XIAN = 2

local TABLE_CHECKOUT = 3 --结算中
local TABLE_PLAYING = 2 --游戏进行中
local TABLE_READY = 1 --准备中
local TABLE_IDLE = 0  --空闲

local playerPos = {}
playerPos[1] = {-550,95}
playerPos[2] = {550, 165}
playerPos[3] = {-550, 165}

function TableController:ctor()
    self.seats_ = {}
    self.hostSeatID_ = 0
    self.table_ = PokerTable.new()
    self:init_()
    self.isTurnStart_ = false
    self.yaoDeQi_ = true
end

function TableController:init_()
    self.tableView_ = app:createConcreteView("game.PDKTableView", self.table_)
    display.getRunningScene():addGameView(self.tableView_)
end

function TableController:isMyTable()
    return self.table_:isOwner(selfData:getUid())
end

function TableController:showReady()
    self.tableView_:showReady()
end

function TableController:addPokerToTable(seatID, view, x, y)
    local point = self.tableView_.csbNode_:convertToNodeSpace(cc.p(x,y))
    view:setPosition(point.x, point.y)
    self.tableView_.csbNode_:addChild(view)
    local player = self:getPlayerBySeatID(seatID)
    local pos = playerPos[player:getIndex()]
    self.tableView_:performWithDelay(function()
        transition.moveTo(view, {x = pos[1], y = pos[2], time = 0.1,
            onComplete = function()
                player:showXianShou(view:getCard())
                view:removeSelf()
                view = nil
            end})
        transition.scaleTo(view, {scale = 0.2, time = 0.1})
        end, 0.6)
end

function TableController:setScore(score)
    for i,v in ipairs(self.seats_) do
        v.view_.score_:setString(v.player_.score_ + score)
    end
end

function TableController:gameStart()
    self.table_:setGameStart(true)
end

function TableController:getFinishRound()
    return self.table_:getRoundIndex()
end

function TableController:upDateXuanPai(data)
    if data.code ~= 0 then
        return
    end
    local player = self:getPlayerBySeatID(data.seatID)
    if not player:isHost() then
        player:showXianShou(data.card)
        return
    end
    display.getRunningScene():updateXuanPaiView(data)
end

function TableController:doXuanPai(data)
    display.getRunningScene():initXuanPaiView(data)
end

function TableController:doPlayerStateChanged(data)
    
end

function TableController:setScore(score)
    for i,v in ipairs(self.seats_) do
        v.view_.score_:setString(v.player_.score_ + score)
    end
end

function TableController:reShowCard(data)
    local player = self:getPlayerBySeatID(data.dealerSeatID)
    player:showXianShouWord(true)
    for k,v in pairs(self.seats_) do
        if v:isHost() then
            v:setHandCards(data.handCards,nil,data.is_background)
        end
        if self.table_:getRuleDetails().xianPai == 1 then
            v:warning(self.table_:getRuleDetails().cardCount, false, false, self.table_:getRuleDetails().xianPai)
        end
    end
end

function TableController:doDealCards(data)
    local player = self:getPlayerBySeatID(data.dealerSeatID)
    player:showXianShouWord(true)
    for k,v in pairs(self.seats_) do
        if v:isHost() then
            v:setHandCards(data.handCards,nil,data.is_background)
        end
        if self.table_:getRuleDetails().xianPai == 1 then
            v:warning(self.table_:getRuleDetails().cardCount, false, false, self.table_:getRuleDetails().xianPai)
        end
    end
end

function TableController:doChangePMTYPE_()
    for i,v in ipairs(self.seats_) do
        if v:getUid() == selfData:getUid() then
            v:changeMyPos()
            v:reShowHandCards(true)
            break 
        end
    end
end

function TableController:doTurnTo(data)
    -- assert(data)  remainTime
    local seconds = math.max(data.remainTime, 5)
    local index  
    for k,v in pairs(self.seats_) do
        if data.seatID == v:getSeatID() then
            v:setChuPai({})
            index = v:getIndex()
            v:setTurnTo(true)
            if v:isHost() and (data.yaoDeQi or not data.is_background) then
                v:reShowHandCards()
            end
        else
            v:setTurnTo(false)
        end
    end
    if data.seatID == self.hostSeatID_ then
        if data.yaoDeQi == false then
            return
        end
        self:showPlayController(true)
    else
        self:showPlayController(false)
    end
    self.table_:setTurnTo(index, seconds)
end

function TableController:setTurnTo(index)
    self.table_:setTurnTo(index, seconds)
end

function TableController:doRoundStart(data)
    self.table_:roundChange(data.seq)
    self:clearSeats()
end

function TableController:clearSeats()
    for i,v in ipairs(self.seats_) do
        v:roundStart()
        if v:isHost() then
            v:setHandCards({},nil,true)
        end
    end
end

function TableController:setHostPlayerState(offline)
    if self.hostPlayer_ then
        self.hostPlayer_:setOffline(offline, self.hostPlayer_:getIP())
    end
end

function TableController:onTurnStart_(event)
    self.isTurnStart_ = true
end

function TableController:doTurnEnd(data)
    self.table_:setCurrCards({})
    for _,v in pairs(self.seats_) do
        v:setChuPai(nil)
    end
end

function TableController:doZhaDanDeFen(data)
    local winnerIndex
    local loses = {}
    for i,v in ipairs(data.data) do
        if v.score > 0 then
            local player = self:getPlayerBySeatID(v.seatID)
            winnerIndex = player:getIndex()
        else
            local player = self:getPlayerBySeatID(v.seatID)
            loses[#loses+1] = player:getIndex()
        end
    end
    if SPECIAL_PROJECT then
            -- to do
        else
            self.tableController_:goldFly(winnerIndex, loses)
    end
    for i,v in ipairs(data.data) do
        local player = self:getPlayerBySeatID(v.seatID)
        local distScore = v.totalScore - player:getScore()
        player:setScore(v.totalScore, distScore)
    end
end

function TableController:onChuPaiEvent_(event)
    local cards = self.tableView_.nodeHostMaJiang_:getPopUpPokers()
    if self.table_:getFinishRound() == 1 then
        local hasHei3 = PdkAlgorithm.hasHeiSan(cards)
        local handHei3 = PdkAlgorithm.hasHeiSan(self.hostPlayer_:getCards())
        if handHei3 and not hasHei3 then
            app:showTips("第一手牌必须包含黑3!")
            return
        end
    end
    local data = {cards = cards}
    local config = dataCenter:getPokerTable():getConfigData()
    if PdkAlgorithm.isBigger(cards, self.table_:getCurCards(), config) then
        dataCenter:sendOverSocket(COMMANDS.PDK_CHU_PAI, data)
    else
        app:showTips("出牌不符合规则，请重新选择哦!")
        self.tableView_.nodeHostMaJiang_:resetPopUpPokers()
    end
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
    self:performWithDelay(function()
        display.getRunningScene():isShowYaoqingButton()
        end, 
        0.2)
end

function TableController:showCurrFlow_(flow)
    -- if flow ~= T_IN_PLAYING then
        -- self.doFlowList_[flow](flow)
    -- end
end

function TableController:doLeaveRoom(data)
    local player = self:getPlayerById(data.uid)
    if not player then
        return
    end
    player:levelRoom()
    self.seats_[player:getSeatID()] = nil
    self.table_:delPlayerCount()
end

function TableController:doPlayerPass(data)
    local player = self:getPlayerBySeatID(data.seatID)
    if not player then
        return
    end
    player:pass(data.inFastMode)
end

function TableController:doPlayerStateChanged(data)
    local player = self:getPlayerById(data.uid)
    if not player then
        return
    end
    player:setOffline(data.offline, data.IP)
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

function TableController:doResumeRoomInfo_(data)
    local index
    for k,v in pairs(self.seats_) do
        if v:getSeatID() == data.currSeatID then
            index = v:getIndex()
            v:setTurnTo(true)
            if v:isHost() then
                v:reShowHandCards()
            end
        else
            v:setTurnTo(false)
        end
        if data.config.rules.xianPai == 1 then
            v:warning(v:getWarningType(),false, false, data.config.rules.xianPai)
        end
    end
    if data.currSeatID == -1 then return end
    if data.currSeatID == self.hostSeatID_ then
        self:showPlayController(true)
    else
        self:showPlayController(false)
    end
    self.table_:roundChange(data.roundIndex)
    self.table_:setOwner(data.creator)
    self:resumeChuPai_(clone(data.turnCards))
    if index then
        self:setTurnTo(index, data.remainSeconds, true)
    end    
    self.table_:setTableSkin(setData:getPDKBgIndex())
end

function TableController:resumeChuPai_(turnCards)
    if turnCards == nil then return end
    local turnCards = turnCards or {}
    local v = turnCards[#turnCards]
    if v then
        local player = self:getPlayerBySeatID(v[1])
        self.table_:setCurrCards(v[2])
        player:setChuPai(v[2])
    end
end

-- 断线重连
function TableController:resumePlayer_(player, data)
    player:setIsReady(data.isPrepare)
    player:setOffline(data.offline, data.IP)
    if data.status ~= 2 then  -- 空闲中
        return
    end
    -- -- 恢复手牌
    if data.shouPai and #data.shouPai > 0 then
        if player:isHost() then
            player:setHandCards(data.shouPai, true,data.is_background)
        end
    end
    player:setIsReady(false)
    player:warning(data.warning, false, true, 0)
end

function TableController:doPlayerChuPai(data)
    if data.code == -8 then
        app:showTips("出牌不符合规则，请重新选择哦!")
        return
    end
    if data.code == -15 then
        app:showTips("下家已报单，单张必须出牌点最大的牌！")
        return
    end
    if not data or not data.seatID then
        return
    end
    self:showPlayController(false)
    -- self.tableView_:stopTimer()
    local cards = data.cards
    local player = self:getPlayerBySeatID(data.seatID)
    if not player then
        return
    end
    player:setChuPai(clone(cards))
    self.table_:setCurrCards(clone(cards))
    local xianPai = self.table_:getRuleDetails().xianPai
    player:warning(data.warning, data.inFastMode, false, xianPai)
    if player:isHost() then
        player:removeHandCards(clone(cards))
    end
end

function TableController:getHostSeatID()
    return self.hostSeatID_
end

function TableController:getCreator()
    return self.table_:getCreator()
end

function TableController:doPlayerSitDown(params)
    dump(params,"TableController:doPlayerSitDown")
    local playerData = params
    local data = json.decode(playerData.data)
    assert(playerData and playerData.seatID, "sitDown fail by error data")
    table.merge(playerData, data)
    print("=====doPlayerSitDown=============")
    local player 
    if self.seats_[params.seatID] == nil then
        player = PlayerController.new(playerData)
        self.seats_[params.seatID] = player
    else
        player = self.seats_[params.seatID]
        player:setPlayerParams(playerData)
    end
    if playerData.isReview then
        self.hostSeatID_ = 1
    else
        if player:getUid() == selfData:getUid() then
            self.hostSeatID_ = player:getSeatID() 
        end
    end
    self:setPlayerIndex_(self.hostSeatID_, player)
    self:resumePlayer_(player, params)
    self.table_:addPlayerCount()
end

function TableController:updatePlayerIndex_()
    local playerPos 
    for i,v in ipairs(self.seats_) do
        if v:getUid() == selfData:getUid() then
            playerPos = v:getSeatID()
            break 
        end
    end
    self:calcPlayerIndex_(playerPos)
end

function TableController:setPlayerIndex_(hostSeatID, player)
    local left = hostSeatID - 1 > 0 and hostSeatID - 1 or 3
    local right = hostSeatID + 1 < 4 and hostSeatID + 1 or 1
    local view
    if player:getSeatID() == left then
        player:setIndex(3)
        view = self.tableView_:getPlayerView(3)
        player:initPlayerView(view)
    elseif player:getSeatID() == right then
        player:setIndex(2)
        view = self.tableView_:getPlayerView(2)
        player:initPlayerView(view)
    elseif player:getSeatID() == hostSeatID then
        player:setIndex(1)
        view = self.tableView_:getPlayerView(1)
        player:initPlayerView(view)
    end
end

function TableController:getPlayerByIndex(index)
    for i,v in ipairs(self.seats_) do
        if v:getIndex() == index then
            return v
        end
    end
    return
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

function TableController:listeningAvatarClicked(callback)
    for _,v in ipairs(self.seats_) do
        v:setAvatarCallback(callback)
    end
end

function TableController:stopTimer()
    -- self.tableView_:stopTimer()
    self.table_:setTurnTo(-1)
end

-- 结算过程
function TableController:doRoundOver(data)
    self.table_:setTurnTo(-1)
    self.table_:roundOver(data)
end

function TableController:doGameOver(data)
    printInfo("TableController:doGameOver")
    self:clearFocus_()
end

function TableController:setCurrCards(...)
    self.table_:setCurrCards(...)
end

function TableController:getCurrCards()
    return self.table_:getCurrCards()
end

function TableController:initCards(...)
    self.table_:initCards(...)
end

function TableController:showPlayController(...)
    self.table_:showPlayController(...)
end

function TableController:setTurnTo(...)
    self.table_:setTurnTo(...)
end

function TableController:clearFocus_()
end

function TableController:resetPopUpPokers()
    self.tableView_:resetPopUpPokers()
end

return TableController
