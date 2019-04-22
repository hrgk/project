local TableController = import(".TableController")
local ReViewPlayerController = import(".ReViewPlayerController")
local ReViewTableController = class("ReViewTableController", TableController)
local ShuangKouAlgorithm = import("app.games.shuangKou.utils.ShuangKouAlgorithm")
local PokerTable = import("app.games.shuangKou.models.PokerTable")
local TaskQueue = require("app.controllers.TaskQueue")

function ReViewTableController:ctor(hostPlayer,userNum)
    self.lastAction = 0
    self.table_ = PokerTable.new()
    self.table_:setController(self)
    self:init_()
    self.isTurnStart_ = false
    self.yaoDeQi_ = true
end

function ReViewTableController:getFriendPlayerSeatID()
    -- local seatID = self.hostPlayer_:getSeatID()
    -- local maxPlayer = self.table_:getMaxPlayer()
    -- local friendSeatID = (seatID + 1) % maxPlayer + 1

    return 1
end

function ReViewTableController:getFriendCards()
    return {}
end

function ReViewTableController:init_()
    self.tableView_ = app:createConcreteView("review.ReViewTableView", self.table_):addTo(self)
    self.nodePlayers_ = self.tableView_.nodePlayers_
    self.maxPlayer_ = self.table_:getMaxPlayer()
    self.hostSeatID_ = nil
    self:createSeats_(self.maxPlayer_)
    self.actionButtonsController_ = app:createConcreteController("ActionButtonsController"):addTo(self):hide()
end

function ReViewTableController:doTurnTo_(seatID, seconds, yaoDeQi)
    assert(seatID and seconds)
    local seconds = math.max(seconds, 2)
    self:setTurnTo_(seatID, seconds)
    -- self.actionButtonsController_:show()
end

function ReViewTableController:doPlayerSitDown(params)
    local playerData = params
    local data = json.decode(playerData.data)
    assert(playerData and data.uid and playerData.seatID, "sitDown fail by error data")
    table.merge(playerData, data)
    local player = self:getPlayerBySeatID(params.seatID)
    player:sitDown(playerData, self.table_:isIdle())
    self.tableView_:countingScoreBindPlayer(player:getPlayer())
    player:resumePlayer(playerData)
    self:resumePlayer_(player, params)
     if self.selfID_ == player:getUid() then
        self.hostPlayer_ = player:getPlayer()
    end
end

-- 断线重连
function ReViewTableController:resumePlayer_(player, data)
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
end

function ReViewTableController:doHunCard(data)
    self.table_:showHunPai(data.hunCard)
    local obj = NiuGuiAlgorithm.getHunPai(data.hunCard)
    self.table_:setShangXiaHun(obj)
    self.table_:setDealerSeatID(data.dealerSeatID)
    self.tableView_:showDealerAtIndex_(data.dealerSeatID)
    self.tableView_.buttonRank_:hide()
end

function ReViewTableController:resetPlayer()
    for i,v in ipairs(self.seats_) do
        if v and v:getPlayer() then
            v:getPlayer():gameOver()
        end
    end
end

function ReViewTableController:doRoomInfo(data)
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
        self:onPlayerReady(seatID, true)
    end
    self.table_:setFinishRound(data.roundIndex)
    data.config.clubID = data.clubID
    self.table_:setConfigData(data.config)
        for i,v in ipairs(self.seats_) do
            -- v:initPokerList(data.config.gameMode)
            v:getPlayer():showCards()
        end
    self.table_:setTid(data.tid or dataCenter:getRoomID())
    self.table_:setOwner(data.creator or 0)
    self.table_:setIsAgent(data.isAgent or 0)
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

function ReViewTableController:createSeats_(number)
    self.seats_ = {}
    local number = number or self.userNum -- 默认3人桌
    for i=1, number do
        self.seats_[i] = ReViewPlayerController.new(i):addTo(self.nodePlayers_, -i)
    end
end

return ReViewTableController
