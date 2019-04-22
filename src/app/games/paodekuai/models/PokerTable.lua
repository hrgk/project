local BaseTable = import("app.models.BaseTable")
local PokerTable = class("PokerTable", BaseTable)

-- 定义事件
PokerTable.CHANGE_STATE_EVENT = "CHANGE_STATE_EVENT"
PokerTable.START_EVENT = "START_EVENT"
PokerTable.WAITING_EVENT = "WAITING_EVENT"
PokerTable.ROUND_START_EVENT = "ROUND_START_EVENT"
PokerTable.ROUND_OVER_EVENT = "ROUND_OVER_EVENT"
PokerTable.DEALER_FOUND = "DEALER_FOUND"
PokerTable.KING_FOUND = "KING_FOUND"
PokerTable.TURN_TO_EVENT = "TURN_TO_EVENT"
PokerTable.CONFIG_CHANGED = "CONFIG_CHANGED"
PokerTable.TABLE_CHANGED = "TABLE_CHANGED"
PokerTable.MA_JIANG_COUNT_CHANGED = "MA_JIANG_COUNT_CHANGED"
PokerTable.FINISH_ROUND_CHANGED = "FINISH_ROUND_CHANGED"
PokerTable.ZHUANG_FEN_PAI_CHANGED = "ZHUANG_FEN_PAI_CHANGED"
PokerTable.XIAN_FEN_PAI_CHANGED = "XIAN_FEN_PAI_CHANGED"
PokerTable.GOLD_FLY_EVENT = "GOLD_FLY_EVENT"
PokerTable.DAI_JIAN_FEN_ADDED = "DAI_JIAN_FEN_ADDED"
PokerTable.DAI_JIAN_FEN_CHANGED = "DAI_JIAN_FEN_CHANGED"
PokerTable.SHOW_HUN_CARD = "SHOW_HUN_CARD"
PokerTable.SHOW_FRIEND_CARD = "SHOW_FRIEND_CARD"
PokerTable.SHOW_WU_ZHANG_BUTTON = "SHOW_WU_ZHANG_BUTTON"

function PokerTable:ctor()
    PokerTable.super.ctor(self)
end

function PokerTable:onChangeState_(event)
    local event = {name = PokerTable.CHANGE_STATE_EVENT, from = event.from, to = event.to, args = event.args}
    self:dispatchEvent(event)
end

function PokerTable:onStart_(event)
    self:dispatchEvent({name = PokerTable.START_EVENT})
end

function PokerTable:setDismiss(flag)
    self.isDismiss_ = flag
end

function PokerTable:setRoundId(roundId)
    self.roundId_ = roundId
end

function PokerTable:setCurrPlayerCount(number)
    self.currPlayerCount_ = number
end

function PokerTable:setZhuangFenPai(cards, winCards, isReConnect, inFastMode)
    self.zhuangFenPai_ = cards or {}
    self:dispatchEvent({name = PokerTable.ZHUANG_FEN_PAI_CHANGED, 
        cards = clone(cards), winCards = winCards, isReConnect = isReConnect, inFastMode = inFastMode})
end

function PokerTable:setXianFenPai(cards, winCards, isReConnect, inFastMode)
    self.xianFenPai_ = cards or {}
    self:dispatchEvent({name = PokerTable.XIAN_FEN_PAI_CHANGED, 
        cards = clone(cards), winCards = winCards, isReConnect = isReConnect, inFastMode = inFastMode})
end

function PokerTable:setCurrPlayerCount(number)
    self.currPlayerCount_ = number
end

function PokerTable:setOpenChui(openChui)
    self.openChui_ = openChui
end

function PokerTable:setDaiJianFen(cards)
    -- local tmp = {}
    -- for i,v in ipairs(checktable(cards)) do
    --     if TianZhaAlgorithm.isFenPai(v) then
    --         table.insert(tmp, v)
    --     end
    -- end
    -- self.daiJianFen_ = tmp
    -- self:dispatchEvent({name = PokerTable.DAI_JIAN_FEN_CHANGED, cards = self:getDaiJianFen()})
end

function PokerTable:addDaiJianFen(cards, inFastMode)
    -- local tmp = {}
    -- for i,v in ipairs(checktable(cards)) do
    --     if TianZhaAlgorithm.isFenPai(v) then
    --         table.insert(tmp, v)
    --     end
    -- end
    -- table.insertto(self.daiJianFen_, tmp)
    -- self:dispatchEvent({name = PokerTable.DAI_JIAN_FEN_ADDED, cards = tmp, inFastMode = inFastMode})
end

function PokerTable:setStatus(status)
    self.status_ = status
end

function PokerTable:setFirstHand(bool)
    self.firstHand_ = bool
end

function PokerTable:safeRemovePublicCards()
    if not self:isPlaying() then
        self:clearAllCards_()
    end
end

function PokerTable:setSameIP(flag)
    self.sameIP_ = flag
end

function PokerTable:saveLastCard(seatID, card, isBuGang)
    self.lastCard_ = card
    self.lastSeatID_ = seatID
    self.isBuGang_ = isBuGang or false
end

function PokerTable:removeLastCard()
    self.lastCard_ = 0
end

function PokerTable:setOwner(uid)
    self.owner_ = checkint(uid)
end

function PokerTable:isOwner(uid)
    return self.owner_ > 0 and uid == self.owner_
end

function PokerTable:clearAllCards_()
    self:setZhuangFenPai({}, {})
    self:setXianFenPai({}, {})
end

function PokerTable:setController(controller)
    self.controller_ = controller
end

function PokerTable:setInPublicTime(flag)
    self.inPublicTime_ = flag
end

function PokerTable:setTid(tid)
    if self.tid_ == tid then
        return
    end
    self.tid_ = tid
    -- self:dispatchEvent({name = PokerTable.TABLE_CHANGED, tid = tid})
    -- self:clearAllCards_()
end

function PokerTable:setFinishRound(num)
    self.finishRound_ = num
    -- self:dispatchEvent({name = PokerTable.FINISH_ROUND_CHANGED, total = self.totalRound_, num = num})
end

function PokerTable:getFinishRound()
    return self.finishRound_ 
end

function PokerTable:setDealerSeatID(seatID, index)
    self.dealerSeatID_ = seatID
    self:dispatchEvent({name = PokerTable.DEALER_FOUND, seatID = seatID, index = index})
end

function PokerTable:setHunSeatID(seatID)
    self.hunSeatID_ = seatID
end

function PokerTable:getPoolCount()
    if not self.pools_ then
        return 0
    end
    return #self.pools_
end

function PokerTable:getConfigData()
    return self.tableConfig_
end

-- 获得本轮跟注所需要的筹码值
function PokerTable:getRoundCallChips(myBet)
    return self.turnMaxBet_ - myBet
end

function PokerTable:onTurnTo(seatID, seconds)
    self:setCurrSeatID(seatID, seconds)
end

function PokerTable:setCurrSeatID(seatID, seconds)
    self.currSeatID_ = seatID
    self:dispatchEvent({name = PokerTable.TURN_TO_EVENT, seatID = seatID, seconds = seconds})
end

function PokerTable:isMyTurn(seatID)
    return seatID and seatID > 0 and seatID == self.currSeatID_
end

function PokerTable:saveUser(user)
    self.watchList_[user.uid] = user
end

function PokerTable:clearAllUserInfo()
    self.watchList_ = {}
end

function PokerTable:getUserInfo(uid)
    return self.watchList_[uid]
end

function PokerTable:clearUserInfo(uid)
    self.watchList_[uid] = nil
end

function PokerTable:setCurrFlow(flow)
    self.currFlow_ = flow
end

return PokerTable
