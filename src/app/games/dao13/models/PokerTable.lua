local BaseTable = import("app.models.BaseTable")
local PokerTable = class("PokerTable", BaseTable)
PokerTable.DEALER_FOUND = "DEALER_FOUND"
PokerTable.FLOW = "FLOW"
PokerTable.SHOU_GAME_START_BTN = "SHOU_GAME_START_BTN"
PokerTable.GAME_TIPS_EVENT = "GAME_TIPS_EVENT"
PokerTable.SHOW_ROUND_ANI = "SHOW_ROUND_ANI"
function PokerTable:ctor()
    PokerTable.super.ctor(self)
end

function PokerTable:showRoundAni(info)
    self:dispatchEvent({name = PokerTable.SHOW_ROUND_ANI, info = info})
end

function PokerTable:showGameTips(tipsType, isZhuang)
    self:dispatchEvent({name = PokerTable.GAME_TIPS_EVENT, tipsType = tipsType, isZhuang = isZhuang})
end

function PokerTable:showGameStartBtn(bool)
    self:dispatchEvent({name = PokerTable.SHOU_GAME_START_BTN, isShow = bool})
end

function PokerTable:changeConf()
    if self.ruleDetails_.roundType == 1 then
        self.config_.juShu = 0
    end
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
    print("setOwner",uid)
    self.owner_ = checkint(uid)
end

function PokerTable:isOwner(uid)
    dump(self.owner_,"self.owner_self.owner_")
    return self.owner_ > 0 and uid == self.owner_
end

function PokerTable:setController(controller)
    self.controller_ = controller
end

function PokerTable:setDealerSeatID(seatID, index, randomPoker,hideAni,callBack)
    self.dealerSeatID_ = seatID
    self:dispatchEvent({name = PokerTable.DEALER_FOUND, seatID = seatID, index = index,randomPoker = randomPoker,hideAni = hideAni,callBack = callBack})
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

function PokerTable:makeRuleString(spliter)
    local data = self.ruleDetails_
    dump(data,"TableView:makeRuleString")
    local list = {}
    table.insert(list,"十三道")
    local jfInfo = {"长跑记分","打捆记分"}
    table.insert(list,  jfInfo[data.roundType+1])
    local msInfo = {"随机庄模式","无庄模式","轮庄模式"}
    table.insert(list,  msInfo[data.zhuangType])
    table.insert(list,  data.playerCount .. "人")
    if data.specialType == 1 then
        table.insert(list,"特殊牌型")
    end
    return table.concat(list, spliter)
   
end

return PokerTable
