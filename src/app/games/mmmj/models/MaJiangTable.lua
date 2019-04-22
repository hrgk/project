local MaJiangTable = class("MaJiangTable", gailun.JWModelBase)

-- 定义事件
MaJiangTable.CHANGE_STATE_EVENT = "CHANGE_STATE_EVENT"
MaJiangTable.START_EVENT = "START_EVENT"
MaJiangTable.WAITING_EVENT = "WAITING_EVENT"
MaJiangTable.ROUND_START_EVENT = "ROUND_START_EVENT"
MaJiangTable.ROUND_OVER_EVENT = "ROUND_OVER_EVENT"
MaJiangTable.DEALER_FOUND = "DEALER_FOUND"
MaJiangTable.TURN_TO_EVENT = "TURN_TO_EVENT"
MaJiangTable.CONFIG_CHANGED = "CONFIG_CHANGED"
MaJiangTable.TABLE_CHANGED = "TABLE_CHANGED"
MaJiangTable.MA_JIANG_COUNT_CHANGED = "MA_JIANG_COUNT_CHANGED"
MaJiangTable.FINISH_ROUND_CHANGED = "FINISH_ROUND_CHANGED"
MaJiangTable.MA_JIANG_HIGH_LIGHT = "MA_JIANG_HIGH_LIGHT"
MaJiangTable.FOCUS_ON = "FOCUS_ON"
MaJiangTable.GOLD_FLY_EVENT = "GOLD_FLY_EVENT"
MaJiangTable.SHOW_TING_BUTTON = "SHOW_TING_BUTTON"
-- 定义属性
MaJiangTable.schema = clone(cc.mvc.ModelBase.schema)
-- MaJiangTable.schema["id"] = {"number", 0} -- Id，默认0
MaJiangTable.schema["tid"] = {"number", 0} -- Id，默认-1
MaJiangTable.schema["owner"] = {"number", 0} -- 所有者玩家ID
MaJiangTable.schema["maxPlayer"] = {"number", 4}
MaJiangTable.schema["currPlayerCount"] = {"number", 0}

MaJiangTable.schema["roundId"] = {"number", 0}  -- 局号
MaJiangTable.schema["dealerSeatID"] = {"number", 0}  -- 庄家坐位ID
MaJiangTable.schema["currSeatID"] = {"number", 0}  -- 当前玩家坐位ID
MaJiangTable.schema["watchList"] = {"table", {}}  -- 桌子内所有的玩家数据
MaJiangTable.schema["clubID"] = {"number", 0} 
MaJiangTable.schema["maJiangType"] = {"number", 0}  -- 麻将类型 1 转转 2 长麻
MaJiangTable.schema["totalRound"] = {"number", 0}   -- 总局数
MaJiangTable.schema["huType"] = {"number", 0}       -- 胡牌类型 1 允许吃胡 2 自摸胡
MaJiangTable.schema["birdCount"] = {"number", 0}    -- 抓鸟数
MaJiangTable.schema["allowSevenPairs"] = {"boolean", false} -- 允许7对
MaJiangTable.schema["isLaiZi"] = {"boolean", false}         -- 是否癞子
MaJiangTable.schema["zhuangXian"] = {"boolean", false}      -- 允许庄闲玩法

MaJiangTable.schema["maJiangCount"] = {"number", 0}      -- 桌面麻将牌张数
MaJiangTable.schema["finishRound"] = {"number", 0}      -- 完成局数
MaJiangTable.schema["ruleDetails"] = {"table", {}}  
MaJiangTable.schema["lastCard"] = {"number", 0}      -- 最后所出的牌
MaJiangTable.schema["lastSeatID"] = {"number", 0}      -- 最后所出的坐位ID
MaJiangTable.schema["inPublicTime"] = {"boolean", false}      -- 是否在公共牌时间
MaJiangTable.schema["birds"] = {"table", {}}  -- 鸟牌们
MaJiangTable.schema["isBuGang"] = {"boolean", false}      -- 是否是补杠牌
MaJiangTable.schema["qiangZhiHuPai"] = {"number", 0}      -- 是否强制胡

MaJiangTable.schema["sameIP"] = {"boolean", false}  -- 是否有同IP玩家在游戏

function MaJiangTable:ctor(properties)
    MaJiangTable.super.ctor(self, checktable(properties))
    self:initStateMachine_()
    self:createGetters(MaJiangTable.schema)
end

function MaJiangTable:setClubID(clubID)
    self.clubID_ = clubID
end

function MaJiangTable:initStateMachine_()
    self:addComponent("components.behavior.StateMachine")
    self.fsm__ = self:getComponent("components.behavior.StateMachine")
    self:setStates_()
end

function MaJiangTable:setStates_()
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

function MaJiangTable:resetAllSchema()
    for field, v in pairs(MaJiangTable.schema) do
        self[field .. '_'] = v[2]
    end
    self.fsm__:doEventForce("start")
end

function MaJiangTable:setQiangZhiHuPai(bool)
    self.qiangZhiHuPai_ = bool
end

function MaJiangTable:doRoundStart(dealerSeatID, dealerIndex)
    self:setDealerSeatID(dealerSeatID, dealerIndex)
    self:tryDoEvent_("roundstart")
end

function MaJiangTable:getState()
    return self.fsm__:getState()
end

function MaJiangTable:tryDoEvent_(eventName, ...)
    print("MaJiangTable:tryDoEvent_(eventName, ...)"..eventName)
    if self.fsm__:canDoEvent(eventName) then
        print("MaJiangTable: do it!")
        self.fsm__:doEvent(eventName, ...)
    end
end

function MaJiangTable:doRoundOver(data)
    self:setMaJiangCount(0)
    self:tryDoEvent_("roundover", data)
end

function MaJiangTable:doRest(seconds)
    self:tryDoEvent_("rest", seconds)
end

function MaJiangTable:onChangeState_(event)
    local event = {name = MaJiangTable.CHANGE_STATE_EVENT, from = event.from, to = event.to, args = event.args}
    self:dispatchEvent(event)
end

function MaJiangTable:onStart_(event)
    self:dispatchEvent({name = MaJiangTable.START_EVENT})
end

function MaJiangTable:onRoundStart_(event)
    self:dispatchEvent({name = MaJiangTable.ROUND_START_EVENT})
    self:clearAllCards_()
end

function MaJiangTable:safeRemovePublicCards()
    if not self:isPlaying() then
        self:clearAllCards_()
    end
end

function MaJiangTable:setSameIP(flag)
    self.sameIP_ = flag
end

function MaJiangTable:saveLastCard(seatID, card, isBuGang)
    self.lastCard_ = card
    self.lastSeatID_ = seatID
    self.isBuGang_ = isBuGang or false
end

function MaJiangTable:removeLastCard()
    self.lastCard_ = 0
end

function MaJiangTable:setOwner(uid)
    self.owner_ = checkint(uid)
end

function MaJiangTable:isMyTable(seatID)
    if self.creator_ == seatID then
        return true
    end
    return false
end

function MaJiangTable:isOwner(uid)
    return self.owner_ > 0 and uid == self.owner_
end

function MaJiangTable:onRoundOver_(event)
    self:dispatchEvent({name = MaJiangTable.ROUND_OVER_EVENT})
    self.dealerSeatID_ = 0
end

function MaJiangTable:clearAllCards_()
    self.birds_ = {}
end

function MaJiangTable:setController(controller)
    self.controller_ = controller
end

function MaJiangTable:setInPublicTime(flag)
    dump(flag, "setInPublicTime(flag)")
    self.inPublicTime_ = flag
end

function MaJiangTable:setBirds(cards)
    self.birds_ = cards
end

function MaJiangTable:setTid(tid)
    if self.tid_ == tid then
        return
    end

    self.tid_ = tid
    self:dispatchEvent({name = MaJiangTable.TABLE_CHANGED, tid = tid})

    self:clearAllCards_()
end

function MaJiangTable:setMaJiangCount(count)
    self.maJiangCount_ = count
    self:dispatchEvent({name = MaJiangTable.MA_JIANG_COUNT_CHANGED, count = count})
end

function MaJiangTable:setMaJiangLight(card,flag)
    self:dispatchEvent({name = MaJiangTable.MA_JIANG_HIGH_LIGHT, card = card,flag = flag})
end

function MaJiangTable:setFinishRound(num)
    self.finishRound_ = num
    self:dispatchEvent({name = MaJiangTable.FINISH_ROUND_CHANGED, total = self.totalRound_, num = num})
end

function MaJiangTable:getRoundParams()
    return self.finishRound_, self.totalRound_
end

function MaJiangTable:setCurrPlayerCount(number)
    self.currPlayerCount_ = number
end

function MaJiangTable:setCurrPlayerCount(number)
    self.currPlayerCount_ = number
end

function MaJiangTable:isPlaying()
    return self.fsm__:getState() == "playing"
end

function MaJiangTable:isIdle()
    return self.fsm__:getState() == "idle"
end

function MaJiangTable:isWaiting()
    return self.fsm__:getState() == "waiting"
end

function MaJiangTable:setDealerSeatID(seatID, index)
    self.dealerSeatID_ = seatID
    self:dispatchEvent({name = MaJiangTable.DEALER_FOUND, seatID = seatID, index = index})
end

function MaJiangTable:getPoolCount()
    if not self.pools_ then
        return 0
    end
    return #self.pools_
end

--[[
   "birdCount"   = 6
[LUA-print] -     "gameType"    = 12
[LUA-print] -     "limitScore"  = 14
[LUA-print] -     "ruleDetails" = {
[LUA-print] -         "afterGangCardsCount" = 2
[LUA-print] -         "beginHuList" = {
[LUA-print] -             1 = "qiShouSiZhang"
[LUA-print] -             2 = "liuLiuShun"
[LUA-print] -             3 = "queYiSe"
[LUA-print] -             4 = "banBanHu"
[LUA-print] -             5 = "sanTong"
[LUA-print] -             6 = "jieJieGao"
[LUA-print] -             7 = "danSeYiZhiHua"
[LUA-print] -         }
[LUA-print] -         "birdCount"           = 6
[LUA-print] -         "birdScoreType"       = 1
[LUA-print] -         "haiDiType"           = 2
[LUA-print] -         "limitScore"          = 14
[LUA-print] -         "zhuangType"          = 0
[LUA-print] -     }

]]
function MaJiangTable:setConfigData(data)
    self.configData_ = {
        maJiangType = data.gameType,
        consumeType = data.consumeType,
        totalRound = data.totalRound,
        limitScore = data.rules.limitScore,
        birdCount = data.rules.birdCount,
        ruleDetails = data.rules,
        beginHuList = data.rules.beginHuList,
        ruleType = data.ruleType,
        birdScoreType = data.rules.birdScoreType,
        haiDiType = data.rules.haiDiType,
        zhuangType = data.rules.zhuangType,
        juShu = data.juShu,
        piao_type = data.rules.piao_type,
        matchConfig = data.matchConfig,
        matchType = data.matchType
    }
    self.configData_.ruleDetails.birdType = data.rules.birdType
    self.totalRound_ = data.juShu
    self.huType_ = data.rules.huType
    self:setProperties(self.configData_)
    self:dispatchEvent({name = MaJiangTable.CONFIG_CHANGED, data = self.configData_})
    display.getRunningScene().tableController_:setScore(display.getRunningScene():getLockScore())
end

function MaJiangTable:getConfigData()
    return self.configData_
end

-- 获得本轮跟注所需要的筹码值
function MaJiangTable:getRoundCallChips(myBet)
    return self.turnMaxBet_ - myBet
end

function MaJiangTable:onTurnTo(seatID, seconds, isMopai, index)
    self:setCurrSeatID(seatID, seconds, isMopai,index)
end

function MaJiangTable:setCurrSeatID(seatID, seconds, isMopai, index)
    if not isMopai then
        self.currSeatID_ = seatID
    end
    self:dispatchEvent({name = MaJiangTable.TURN_TO_EVENT, seatID = seatID,index = index, seconds = seconds})
end

function MaJiangTable:clearCurrSeatID()
    self.currSeatID_ = nil
end

function MaJiangTable:isMyTurn(seatID)
    -- print("csmj majiangtabel ismyturn")
    return seatID and seatID > 0 and seatID == self.currSeatID_
end

function MaJiangTable:saveUser(user)
    self.watchList_[user.uid] = user
end

function MaJiangTable:clearAllUserInfo()
    self.watchList_ = {}
end

function MaJiangTable:getUserInfo(uid)
    return self.watchList_[uid]
end

function MaJiangTable:clearUserInfo(uid)
    self.watchList_[uid] = nil
end

function MaJiangTable:setFocusOn(x, y)
    self:dispatchEvent({name = MaJiangTable.FOCUS_ON, x = x, y = y})
end

function MaJiangTable:setDismiss(flag)
    self.isDismiss_ = flag
end

function MaJiangTable:goldFly(data, callfunc)
    self:dispatchEvent({name = MaJiangTable.GOLD_FLY_EVENT, data = data, callfunc = callfunc})
end

function MaJiangTable:showTingButton(isShow)
    self:dispatchEvent({name = MaJiangTable.SHOW_TING_BUTTON,isShow = isShow})
end

return MaJiangTable
