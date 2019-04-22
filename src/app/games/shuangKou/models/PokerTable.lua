local PokerTable = class("PokerTable", gailun.JWModelBase)

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
PokerTable.IDLE = "IDLE"


-- 定义属性
PokerTable.schema = clone(cc.mvc.ModelBase.schema)
-- PokerTable.schema["id"] = {"number", 0} -- Id，默认0
PokerTable.schema["tid"] = {"number", 0} -- Id，默认-1
PokerTable.schema["owner"] = {"number", 0} -- 所有者玩家ID
PokerTable.schema["maxPlayer"] = {"number", 4}
PokerTable.schema["currPlayerCount"] = {"number", 0}
PokerTable.schema["roundId"] = {"number", 0}  -- 局号
PokerTable.schema["dealerSeatID"] = {"number", 0}  -- 庄家坐位ID
PokerTable.schema["hunSeatID"] = {"number", 0}  -- 庄家坐位ID
PokerTable.schema["currSeatID"] = {"number", 0}  -- 当前玩家坐位ID
PokerTable.schema["watchList"] = {"table", {}}  -- 桌子内所有的玩家数据
PokerTable.schema["totalRound"] = {"number", 0}   -- 总局数
PokerTable.schema["zhuangXian"] = {"boolean", false}      -- 允许庄闲玩法
PokerTable.schema["finishRound"] = {"number", 0}      -- 完成局数
PokerTable.schema["lastCard"] = {"number", 0}      -- 最后所出的牌
PokerTable.schema["lastSeatID"] = {"number", 0}      -- 最后所出的坐位ID
PokerTable.schema["inPublicTime"] = {"boolean", false}      -- 是否在公共牌时间
PokerTable.schema["sameIP"] = {"boolean", false}  -- 是否有同IP玩家在游戏
PokerTable.schema["curCards"] = {"table", {}}  -- 当前打出的牌
PokerTable.schema["currFlow"] = {"number", 0}  -- 当前标记
PokerTable.schema["firstHand"] = {"boolean", false} --第一手牌
PokerTable.schema["status"] = {"number", 0} --状态标志
PokerTable.schema["openChui"] = {"boolean", true} --是否锤
PokerTable.schema["isDismiss"] = {"boolean", false} -- 是否已解散
PokerTable.schema["isAgent"] = {"number", 0} -- 是否为代开

PokerTable.schema["zhuangFenPai"] = {"table", {}}  -- 庄家所捡分牌
PokerTable.schema["xianFenPai"] = {"table", {}}  -- 庄家的捡分牌
PokerTable.schema["daiJianFen"] = {"table", {}}  -- 待捡分牌

PokerTable.schema["shangXiaHunCards"] = {"table", {}}  -- 上下混牌
PokerTable.schema["hunCard"] = {"number", 0} --混牌
PokerTable.schema["friendCard"] = {"number", 0} --朋友牌
PokerTable.schema["mustDenny"] = {"number", 0} --是否必须压
PokerTable.schema["tableConfig"] = {"table", {}} --房间配置
PokerTable.schema["gameType"] = {"number", GAME_SHUANGKOU} --房间配置

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

function PokerTable:setStates_()
    -- 设定状态机的默认事件
    local defaultEvents = {
        {name = "start", from = {"none", "checkout", "waiting", "playing"}, to = "idle"}, -- 初始化后，桌子处于空闲状态
        {name = "roundstart", from = {"idle", "checkout", "waiting"}, to = "playing"}, -- 开始游戏
        {name = "roundover", from = "playing", to = "checkout"}, -- 游戏结算
        {name = "idle", from = {"none"}, to = "idle"}, -- 空闲中
    }

    -- 设定状态机的默认回调
    local defaultCallbacks = {
        onchangestate = handler(self, self.onChangeState_),
        onstart = handler(self, self.onStart_),
        onroundstart = handler(self, self.onRoundStart_),
        onroundover = handler(self, self.onRoundOver_),
        onidle = handler(self, self.onIdle_),
    }

    self.fsm__:setupState({
        events = defaultEvents,
        callbacks = defaultCallbacks
    })

    self.fsm__:doEvent("start") -- 启动状态机
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
    self:setDaiJianFen(nil)
end

function PokerTable:onIdle_(event)
    self:dispatchEvent({name = PokerTable.IDLE})
end

function PokerTable:setDismiss(flag)
    self.isDismiss_ = flag
end

function PokerTable:setRoundId(roundId)
    self.roundId_ = roundId
end

function PokerTable:setMaxPlayer(number)
    self.maxPlayer_ = number
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

function PokerTable:setIsAgent(isAgent)
    self.isAgent_ = isAgent
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
    self:dispatchEvent({name = PokerTable.TABLE_CHANGED, tid = tid})
    self:clearAllCards_()
end

function PokerTable:setMustDenny(num)
    self.mustDenny_ = num
end

function PokerTable:getMustDenny()
    return self.mustDenny_
end

function PokerTable:setFinishRound(num)
    self.finishRound_ = num
    -- self:dispatchEvent({name = PokerTable.FINISH_ROUND_CHANGED, total = self.totalRound_, num = num})
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

function PokerTable:setHunSeatID(seatID)
    self.hunSeatID_ = seatID
end

function PokerTable:getPoolCount()
    if not self.pools_ then
        return 0
    end
    return #self.pools_
end

function PokerTable:setConfigData(data)
    dump(data,"datadatadatadata")
    local ruleDetails = data.rules
    self.tableConfig_ = {
        clubID = data.clubID or 0,
        consumeType = data.consumeType,
        maxPlayer = ruleDetails.totalSeat,
        -- mustDenny = ruleDetails.mustDenny,
        totalSeat = ruleDetails.totalSeat,
        -- totalScore = ruleDetails.totalScore,
        showCard = ruleDetails.showCard,
        randomDealer = ruleDetails.randomDealer,
        bianPai = ruleDetails.bianPai,
        juShu = data.juShu,
        contribution = ruleDetails.contribution,
        -- overBonus = ruleDetails.overBonus,
        -- cardCount = ruleDetails.cardCount
    }

    self:setMustDenny(ruleDetails.mustDenny)
    self:setProperties(self.tableConfig_)
    self:dispatchEvent({name = PokerTable.CONFIG_CHANGED, data = self.tableConfig_})
end

function PokerTable:getClubID()
    return self.tableConfig_.clubID
end

function PokerTable:getRoomRuleInfo()
    local str = ""
    local skInfo = {"常规双扣 ","百变双扣 ","千变双扣 "}
    str = str .. skInfo[self.tableConfig_.bianPai+1]
    local gxInfo = {"无进贡 ","有进贡 "}
    str = str .. gxInfo[self.tableConfig_.contribution+1]
    return str
end

function PokerTable:getPlayerCountInfo()
    if self.tableConfig_.maxPlayer_ == 4 then
        return "4人打筒子"
        elseif self.tableConfig_.maxPlayer_ == 2 then
        return "2人打筒子"
    end
    return "3人打筒子"
end

function PokerTable:getPlayerCount()
    -- dump(self.tableConfig_)
    if self.tableConfig_.maxPlayer_ == 4 then
        return 4
    elseif self.tableConfig_.maxPlayer_ == 2 then
        return 2
    end
    return 3
end

function PokerTable:getOverScoreInfo()
    return (self.tableConfig_.totalScore or 0)  .. "分"
end

function PokerTable:getOverBonusInfo()
    if self.tableConfig_.overBonus == 0 then
        return ""
    end

    return "终局奖励" .. (self.tableConfig_.overBonus or 0)  .. "分"
end

function PokerTable:getShowCardsInfo()
    if self.tableConfig_.showCard == 1 then
        return "显示牌数"
    end

    return ""
end

function PokerTable:getRandomDealerInfo()
    if self.tableConfig_.randomDealer == 1 then
        return "随机出头"
    end

    return ""
end

function PokerTable:getPaiZhangInfo()
    return (self.tableConfig_.cardCount or 0) .. "副牌"
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

function PokerTable:setCurCards(cards)
    self.curCards_ = cards
end

function PokerTable:resetCurCards()
    self.curCards_ = {}
end

function PokerTable:setCurrFlow(flow)
    self.currFlow_ = flow
end

function PokerTable:resetRoundTable()
    self:setFirstHand(false)
end

function PokerTable:goldFly(data, callfunc)
    self:dispatchEvent({name = PokerTable.GOLD_FLY_EVENT, data = data, callfunc = callfunc})
end

return PokerTable
