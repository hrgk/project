local BaseTable = class("BaseTable",nil)
BaseTable.INIT_TABLE_INFO = "INIT_TABLE_INFO"
BaseTable.IS_SHOW_PALYCONTROLLER = "IS_SHOW_PALYCONTROLLER"
BaseTable.BE_TURNTO = "BE_TURNTO"
BaseTable.INIT_CARDS = "INIT_CARDS"
BaseTable.CURR_CARDS = "CURR_CARDS"
BaseTable.CHU_PAI = "CHU_PAI"
BaseTable.GAME_START = "GAME_START"
BaseTable.TI_SHI = "TI_SHI"
BaseTable.ROUND_CHANGE = "ROUND_CHANGE"
BaseTable.ROUND_START = "ROUND_START"
BaseTable.ROUND_OVER = "ROUND_OVER"
BaseTable.GOLD_FLY = "GOLD_FLY"
BaseTable.FACE_PLAY = "FACE_PLAY"
BaseTable.CHANGE_SKIN = "CHANGE_SKIN"

function BaseTable:ctor()
    cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()
    self.currPlayerCount_ = 0
end

function BaseTable:setData(data)
    self.data_ = data
    self.tableConfig_ = data
    self.tid_ = data.tid
    self.creator_ = data.creator
    self.roundIndex_ = data.roundIndex
    self.totalRound_ = data.config.juShu
    self.status_ = data.status
    self.config_ = data.config
    self.clubID_ = data.clubID
    self.ruleDetails_ = data.config.rules
    self:changeConf()
    local event = {name = BaseTable.INIT_TABLE_INFO, data = data}
    self:dispatchEvent(event)
    display.getRunningScene().tableController_:setScore(display.getRunningScene():getLockScore())
    if display.getRunningScene().tableController_.sitDownHide then
        display.getRunningScene().tableController_:sitDownHide()
    end
end

function BaseTable:changeConf()
end

function BaseTable:getData()
    return self.data_
end

function BaseTable:getConfig()
    return self.config_
end

function BaseTable:getConfigData()
    return self.tableConfig_
end

function BaseTable:getCurrPlayerCount()
    return self.currPlayerCount_
end

function BaseTable:addPlayerCount()
    self.currPlayerCount_ = self.currPlayerCount_ + 1
end

function BaseTable:delPlayerCount()
    self.currPlayerCount_ = self.currPlayerCount_ - 1
end

function BaseTable:getTotalRound()
    return self.totalRound_
end

function BaseTable:isMyTable(seatID)
    if self.creator_ == seatID then
        return true
    end
    return false
end

function BaseTable:facePlay(info)
    local event = {name = BaseTable.FACE_PLAY, info = info}
    self:dispatchEvent(event)
end

function BaseTable:goldFly(winner, loses)
    local event = {name = BaseTable.GOLD_FLY, winner = winner, loses = loses}
    self:dispatchEvent(event)
end

function BaseTable:roundOver()
    self:showPlayController(false)
    self:setCurrCards({})
    local event = {name = BaseTable.ROUND_OVER}
    self:dispatchEvent(event)
end

function BaseTable:roundStart()
    self:showPlayController(false)
    self:setCurrCards({})
    print("===========ROUND_START===========")
    local event = {name = BaseTable.ROUND_START}
    self:dispatchEvent(event)
end

function BaseTable:tishi()
    local event = {name = BaseTable.TI_SHI}
    self:dispatchEvent(event)
end

function BaseTable:roundChange(round)
    local event = {name = BaseTable.ROUND_CHANGE, round = round}
    self:dispatchEvent(event)
end

function BaseTable:setGameStart(bool, flow)
    self.isGameStart_ = bool
    local event = {name = BaseTable.GAME_START, flow = flow}
    self:dispatchEvent(event)
end

function BaseTable:isGameStart()
    return self.isGameStart_
end

function BaseTable:removeHandCards(cards)
    local event = {name = BaseTable.REMOVE_HAND_CARDS, cards = cards}
    self:dispatchEvent(event)
end

function BaseTable:setChuPai()
    local event = {name = BaseTable.CHU_PAI}
    self:dispatchEvent(event)
end

function BaseTable:initCards(cards,isReConnect)
    self.cards_ = clone(cards)
    local event = {name = BaseTable.INIT_CARDS, cards = cards, isReConnect = isReConnect}
    self:dispatchEvent(event)
end

function BaseTable:getHandCards()
    return self.cards_
end

function BaseTable:setTurnTo(index, seconds, isTurn)
    dump("============setTurnTo===============")
    local event = {name = BaseTable.BE_TURNTO, seconds = seconds, index = index, isTurn = isTurn}
    self:dispatchEvent(event)
end

function BaseTable:showPlayController(bool, cType)
    local event = {name = BaseTable.IS_SHOW_PALYCONTROLLER, isShow = bool, cType = cType}
    self:dispatchEvent(event)
end

function BaseTable:getConfig()
    return self.config_
end

function BaseTable:getRuleDetails()
    return self.ruleDetails_
end

function BaseTable:getTid()
    return self.tid_
end
function BaseTable:setStatus(status)
    self.status_ = status
end

function BaseTable:getStatus()
    return self.status_
end

function BaseTable:getCreator()
    return self.creator_
end

function BaseTable:getClubID()
    return self.clubID_
end

function BaseTable:setRoundIndex(roundIndex)
    self.roundIndex_ = roundIndex
end

function BaseTable:getRoundIndex()
    return self.roundIndex_
end

function BaseTable:setCurrCards(cards)
    self.currCards_ = cards
end

function BaseTable:getCurrCards()
    return self.currCards_ or {}
end

function BaseTable:setTableSkin(index)
    local event = {name = BaseTable.CHANGE_SKIN, index = index}
    self:dispatchEvent(event)
end

return BaseTable 
