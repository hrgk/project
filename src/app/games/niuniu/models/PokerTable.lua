local BaseTable = import("app.models.BaseTable")
local PokerTable = class("PokerTable", BaseTable)
PokerTable.DEALER_FOUND = "DEALER_FOUND"
PokerTable.FLOW = "FLOW"
PokerTable.SHOU_GAME_START_BTN = "SHOU_GAME_START_BTN"
PokerTable.GAME_TIPS_EVENT = "GAME_TIPS_EVENT"

function PokerTable:ctor()
    PokerTable.super.ctor(self)
end

function PokerTable:showGameTips(tipsType, isZhuang)
    self:dispatchEvent({name = PokerTable.GAME_TIPS_EVENT, tipsType = tipsType, isZhuang = isZhuang})
end

function PokerTable:showGameStartBtn(bool)
    self:dispatchEvent({name = PokerTable.SHOU_GAME_START_BTN, isShow = bool})
end

function PokerTable:setDismiss(flag)
    self.isDismiss_ = flag
end

function PokerTable:setRoundId(roundId)
    self.roundId_ = roundId
end

function PokerTable:setPlayerCount(playerCount)
    self.playerCount_ = playerCount
end

function PokerTable:getPlayerCount(playerCount)
    return self.playerCount_
end

function PokerTable:setCurrPlayerCount(number)
    self.currPlayerCount_ = number
end

function PokerTable:setStatus(status)
    self.status_ = status
end

function PokerTable:setOwner(uid)
    self.owner_ = checkint(uid)
end

function PokerTable:isOwner(uid)
    return self.owner_ > 0 and uid == self.owner_
end

function PokerTable:setController(controller)
    self.controller_ = controller
end

function PokerTable:setDealerSeatID(seatID, index)
    self.dealerSeatID_ = seatID
    self:dispatchEvent({name = PokerTable.DEALER_FOUND, seatID = seatID, index = index})
end

function PokerTable:getDealerSeatID()
    return self.dealerSeatID_
end

function PokerTable:setFlow(flow, callList)
    self.currFlow_ = flow
    self:dispatchEvent({name = PokerTable.FLOW, flow = flow, callList = callList})
end

function PokerTable:getFlow(flow)
   return self.currFlow_
end

return PokerTable
