local PokerTable = class("PokerTable", gailun.JWModelBase)
local PaoHuZiAlgorithm = require("app.games.sybp.utils.PaoHuZiAlgorithm")

-- 定义事件
PokerTable.CHANGE_STATE_EVENT = "CHANGE_STATE_EVENT"
PokerTable.START_EVENT = "START_EVENT"
PokerTable.WAITING_EVENT = "WAITING_EVENT"
PokerTable.ROUND_START_EVENT = "ROUND_START_EVENT"
PokerTable.ROUND_OVER_EVENT = "ROUND_OVER_EVENT"
PokerTable.DEALER_FOUND = "DEALER_FOUND"
PokerTable.TURN_TO_EVENT = "TURN_TO_EVENT"
PokerTable.CONFIG_CHANGED = "CONFIG_CHANGED"
PokerTable.TABLE_CHANGED = "TABLE_CHANGED"
PokerTable.CARDSNUM_CHANGED = "CARDSNUM_CHANGED"
PokerTable.FINISH_ROUND_CHANGED = "FINISH_ROUND_CHANGED"
PokerTable.GOLD_FLY_EVENT = "GOLD_FLY_EVENT"
PokerTable.CURR_CARD_CHANGE = "CURR_CARD_CHANGE"
PokerTable.CURR_CARD_FAGUANG = "CURR_CARD_FAGUANG"
PokerTable.SHOW_DI_PAI = "SHOW_DI_PAI"
PokerTable.SHOW_HAND_PAI = "SHOW_HAND_PAI"
PokerTable.CLEAR_ROUND_OVER_SHOW_PAI = "CLEAR_ROUND_OVER_SHOW_PAI"
PokerTable.SHOW_HUANGZHUANG = "SHOW_HUANGZHUANG"
PokerTable.RESET_ROUND_TABLE = "RESET_ROUND_TABLE"
	
PokerTable.TABLE_BG_CHANGE = "TABLE_BG_CHANGE" --切换桌面
PokerTable.HXTS = "HXTS" --胡息提示
PokerTable.TPTS = "TPTS" --听牌提示
PokerTable.CARD_TYPE = "CARD_TYPE" --改变牌类型
PokerTable.CARD_LAYOUT = "CARD_LAYOUT" --改变牌类型
PokerTable.SHOW_HU_CARD = "SHOW_HU_CARD" --显示胡牌
-- 回放
PokerTable.REVIEW_HAND_CARDS = "REVIEW_HAND_CARDS"
PokerTable.REVIEW_CHU = "REVIEW_CHU"
PokerTable.REVIEW_CHI = "REVIEW_CHI"
PokerTable.REVIEW_PENG = "REVIEW_PENG"
PokerTable.REVIEW_WEI = "REVIEW_WEI"
PokerTable.REVIEW_PAO = "REVIEW_PAO"
PokerTable.REVIEW_TI = "REVIEW_TI"
PokerTable.REVIEW_SHOUZHANG = "REVIEW_SHOUZHANG"
-- 回放

-- 定义属性
PokerTable.schema = clone(cc.mvc.ModelBase.schema)
-- PokerTable.schema["id"] = {"number", 0} -- Id，默认0
PokerTable.schema["tid"] = {"number", 0} -- Id，默认-1
PokerTable.schema["owner"] = {"number", 0} -- 所有者玩家ID
PokerTable.schema["maxPlayer"] = {"number", 3}
PokerTable.schema["currPlayerCount"] = {"number", 0}
PokerTable.schema["roundId"] = {"number", 0}  -- 局号
PokerTable.schema["dealerSeatID"] = {"number", 0}  -- 庄家坐位ID
PokerTable.schema["currSeatID"] = {"number", 0}  -- 当前玩家坐位ID
PokerTable.schema["watchList"] = {"table", {}}  -- 桌子内所有的玩家数据
PokerTable.schema["totalRound"] = {"number", 0}   -- 总局数
PokerTable.schema["zhuangXian"] = {"boolean", false}      -- 允许庄闲玩法
PokerTable.schema["finishRound"] = {"number", 0}      -- 完成局数
PokerTable.schema["lastCard"] = {"number", 0}      -- 最后所出的牌
PokerTable.schema["lastSeatID"] = {"number", 0}      -- 最后所出的坐位ID
PokerTable.schema["sameIP"] = {"boolean", false}  -- 是否有同IP玩家在游戏
PokerTable.schema["curCards"] = {"table", {}}  -- 当前打出的牌
PokerTable.schema["currFlow"] = {"number", 0}  -- 当前标记
PokerTable.schema["status"] = {"number", 0} --状态标志
PokerTable.schema["isDismiss"] = {"boolean", false} -- 是否已解散
PokerTable.schema["clubID"] = {"number", 0} 

PokerTable.schema["baseTun"] = {"number", 1} -- 起胡
PokerTable.schema["limitScore"] = {"number", 150} 
PokerTable.schema["ruleType"] = {"number", 1}
PokerTable.schema["matchType"] = {"number", 1}


function PokerTable:ctor(properties)
    PokerTable.super.ctor(self, checktable(properties))
    self:initStateMachine_()
    self:createGetters(PokerTable.schema)
end

function PokerTable:initStateMachine_()
    self:addComponent("components.behavior.StateMachine")
    self.fsm__ = self:getComponent("components.behavior.StateMachine")
    self:setStates_()
end

function PokerTable:doChangeTableBg_(index)
    local event = {name = PokerTable.TABLE_BG_CHANGE, aimIndex = index}
    self:dispatchEvent(event)
end

function PokerTable:doTPTS_(res)
    local event = {name = PokerTable.TPTS, need = res}
    self:dispatchEvent(event)
end

function PokerTable:doHXTS_(res)
    local event = {name = PokerTable.HXTS, need = res}
    self:dispatchEvent(event)
end

function PokerTable:doChangeCardType_(index)
    local event = {name = PokerTable.CARD_TYPE, index = index}
    setData:setCDPHZCardType(index)
    self:dispatchEvent(event)
end

function PokerTable:doChangeLayout_(index)
    local event = {name = PokerTable.CARD_LAYOUT, index = index}
    setData:setCDPHZCardLayout(index)
    self:dispatchEvent(event)
end

function PokerTable:doShowHuCard_(hucard)
    local event = {name = PokerTable.SHOW_HU_CARD, hucard = hucard}
    self:dispatchEvent(event)
end


function PokerTable:setStates_()
    -- 设定状态机的默认事件
    local defaultEvents = {
        {name = "start", from = {"none", "checkout", "waiting", "playing"}, to = "idle"}, -- 初始化后，桌子处于空闲状态
        {name = "roundstart", from = {"idle", "checkout", "waiting"}, to = "playing"}, -- 开始游戏
        {name = "roundover", from = "playing", to = "checkout"}, -- 游戏结算
    }

    -- 设定状态机的默认回调
    local defaultCallbacks = {
        onchangestate = handler(self, self.onChangeState_),
        onstart = handler(self, self.onStart_),
        onroundstart = handler(self, self.onRoundStart_),
        onroundover = handler(self, self.onRoundOver_),
    }

    self.fsm__:setupState({
        events = defaultEvents,
        callbacks = defaultCallbacks
    })

    self.fsm__:doEvent("start") -- 启动状态机
end

function PokerTable:setTianHuStart(bool)
    self.isTianHuStart_ = bool
end

function PokerTable:isTianHuStart()
    return self.isTianHuStart_
end

function PokerTable:setClubID(clubID)
    self.clubID_ = clubID
end

function PokerTable:doRoundStart()
    self:tryDoEvent_("roundstart")
    self.winnerList_ = {}
    self:resetRoundTable()
end

function PokerTable:getState()
    return self.fsm__:getState()
end

function PokerTable:doEventForce(eventName, ...)
    return self.fsm__:doEventForce(eventName, ...)
end

function PokerTable:tryDoEvent_(eventName, ...)
    if self.fsm__:canDoEvent(eventName) then
        self.fsm__:doEvent(eventName, ...)
    end
end

function PokerTable:doRoundOver(data)
    self:tryDoEvent_("roundover", data)
end

function PokerTable:doRest(seconds)
    self:tryDoEvent_("rest", seconds)
end

function PokerTable:onChangeState_(event)
    local event = {name = PokerTable.CHANGE_STATE_EVENT, from = event.from, to = event.to, args = event.args}
    self:dispatchEvent(event)
end

function PokerTable:onStart_(event)
    self:dispatchEvent({name = PokerTable.START_EVENT})
end

function PokerTable:onRoundStart_(event)
    self:dispatchEvent({name = PokerTable.ROUND_START_EVENT})
    self:clearAllCards_()
end

function PokerTable:onRoundOver_(event)
    self:dispatchEvent({name = PokerTable.ROUND_OVER_EVENT})
    self.dealerSeatID_ = 0
end

function PokerTable:showHuangZhuang()
    self:dispatchEvent({name = PokerTable.SHOW_HUANGZHUANG})
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

function PokerTable:setStatus(status)
    self.status_ = status
end

function PokerTable:safeRemovePublicCards()
    if not self:isPlaying() then
        self:clearAllCards_()
    end
end

function PokerTable:setSameIP(flag)
    self.sameIP_ = flag
end

function PokerTable:setMatchType(matchType)
    self.matchType_ = matchType
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
end

function PokerTable:setController(controller)
    self.controller_ = controller
end

function PokerTable:setTid(tid)
    if self.tid_ == tid then
        return
    end
    self.tid_ = tid
    self:dispatchEvent({name = PokerTable.TABLE_CHANGED, tid = tid})
    self:clearAllCards_()
end

function PokerTable:setLeftCards(cardsnum)
    if self.cardsnum_ == cardsnum then
        return
    end
    self.cardsnum_ = cardsnum
    self:dispatchEvent({name = PokerTable.CARDSNUM_CHANGED, cardsnum = cardsnum})
    self:clearAllCards_()
end

function PokerTable:getLeftCards()
    return self.cardsnum_
end

function PokerTable:setTid(tid)
    if self.tid_ == tid then
        return
    end
    self.tid_ = tid
    self:dispatchEvent({name = PokerTable.TABLE_CHANGED, tid = tid})
    self:clearAllCards_()
end

function PokerTable:setFinishRound(num)
    self.finishRound_ = num
    self:dispatchEvent({name = PokerTable.FINISH_ROUND_CHANGED, total = self.totalRound_, num = num})
end

function PokerTable:isPlaying()
    return self.fsm__:getState() == "playing"
end

function PokerTable:inCheckOut()
    return self.fsm__:getState() == "checkout"
end

function PokerTable:isIdle()
    return self.fsm__:getState() == "idle"
end

function PokerTable:isWaiting()
    return self.fsm__:getState() == "waiting"
end

function PokerTable:setDealerSeatID(seatID, index)
    self.dealerSeatID_ = seatID
    self:dispatchEvent({name = PokerTable.DEALER_FOUND, seatID = seatID, index = index})
end

function PokerTable:getDealerSeatID()
    return self.dealerSeatID_
end

function PokerTable:getPoolCount()
    if not self.pools_ then
        return 0
    end
    return #self.pools_
end

--[[
"msg" = {
    "config" = {
        "juShu"        = 8
    }
}
]]
function PokerTable:setConfigData(data)
    self.configData_ = data
    data.totalRound = data.juShu
    PaoHuZiAlgorithm.setMinHuXi(10)
    self:setProperties(self.configData_)
    self:dispatchEvent({name = PokerTable.CONFIG_CHANGED, data = data})
    if data.matchType == 1 then
        display.getRunningScene().tableController_:setScore(display.getRunningScene():getLockScore())
    end
end

function PokerTable:getConfigData()
    return self.configData_ 
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

function PokerTable:setMaxPlayer(number)
    self.maxPlayer_ = number
    print("PokerTable:setMaxPlayer",self.maxPlayer_)
end

function PokerTable:setData(data)
    self.data_ = data
end

function PokerTable:getClubID()
    return self.data_.clubID
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

function PokerTable:setCurCards(card,index,isMo) 
    self.curCards_ = card 
    self:dispatchEvent({name = PokerTable.CURR_CARD_CHANGE, card = card, index = index, isMo = isMo})
end

function PokerTable:curCardfaGuang() 
    self:dispatchEvent({name = PokerTable.CURR_CARD_FAGUANG, card = card, index = index})
end

function PokerTable:showDiPai(cards, huList, winner, huCard) 
    self:dispatchEvent({name = PokerTable.SHOW_DI_PAI, cards = cards, index = index, huList = huList, winner = winner, huCard = huCard})
end

function PokerTable:showRoundOverHandCard(cards,x,y,index,winnerInfo,isWinner) 
    self:dispatchEvent({name = PokerTable.SHOW_HAND_PAI, cards = cards, index = index, x = x, y = y, winnerInfo = winnerInfo,isWinner = isWinner})
end

function PokerTable:clearRoundOverShowPai() 
    self:dispatchEvent({name = PokerTable.CLEAR_ROUND_OVER_SHOW_PAI})
end

function PokerTable:getCurCards()
    return self.curCards_ 
end

function PokerTable:resetCurCards()
    self.curCards_ = 0
end

function PokerTable:setCurrFlow(flow)
    self.currFlow_ = flow
end

function PokerTable:resetRoundTable()
    self:dispatchEvent({name = PokerTable.RESET_ROUND_TABLE})
end

function PokerTable:goldFly(data, callfunc)
    self:dispatchEvent({name = PokerTable.GOLD_FLY_EVENT, data = data, callfunc = callfunc})
end

-- 回放
function PokerTable:setReviewHandCards(seatID, cards) 
    self:dispatchEvent({name = PokerTable.REVIEW_HAND_CARDS, seatID = seatID, cards = cards})
end

function PokerTable:doReviewChuPai(seatID, card) 
    self:dispatchEvent({name = PokerTable.REVIEW_CHU, seatID = seatID, card = card})
end

function PokerTable:doReviewChiPai(seatID, data) 
    self:dispatchEvent({name = PokerTable.REVIEW_CHI, seatID = seatID, data = data})
end

function PokerTable:doReviewPengPai(seatID, card) 
    self:dispatchEvent({name = PokerTable.REVIEW_PENG, seatID = seatID, card = card})
end

function PokerTable:doReviewWeiPai(seatID, card) 
    self:dispatchEvent({name = PokerTable.REVIEW_WEI, seatID = seatID, card = card})
end

function PokerTable:doReviewPaoPai(seatID, card) 
    self:dispatchEvent({name = PokerTable.REVIEW_PAO, seatID = seatID, cards = card})
end

function PokerTable:doReviewTiPai(seatID, cards)  -- 起手提有多张
    self:dispatchEvent({name = PokerTable.REVIEW_TI, seatID = seatID, cards = cards})
end

function PokerTable:doReviewShouZhang(seatID, card)
    self:dispatchEvent({name = PokerTable.REVIEW_SHOUZHANG, seatID = seatID, card = card})
end
-- 回放

return PokerTable
