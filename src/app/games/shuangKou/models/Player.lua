local BaseAlgorithm = require("app.games.shuangKou.utils.BaseAlgorithm")
local ShuangKouAlgorithm = require("app.games.shuangKou.utils.ShuangKouAlgorithm")
local Player = class("Player", gailun.JWModelBase)

-- 定义事件
Player.CHANGE_STATE_EVENT = "CHANGE_STATE_EVENT"
Player.POKER_FOUND = "POKER_FOUND"
Player.HAND_CARDS_CHANGED = "HAND_CARDS_CHANGED"
Player.LEFT_CARDS_CHANGED = "LEFT_CARDS_CHANGED"
Player.HAND_CARDS_CHUPAI = "HAND_CARDS_CHUPAI"
Player.HAND_CARDS_REMOVED = "HAND_CARDS_REMOVED"  -- 手牌减少事件
Player.HAND_CARD_SORT = "HAND_CARD_SORT"  -- 手牌排序事件HAND_CARD_SORT
Player.WAI_PAI_CHANGED = "WAI_PAI_CHANGED"  -- 外牌改变事件
Player.WAI_PAI_ADDED = "WAI_PAI_ADDED"  -- 外牌增加事件
Player.CHU_PAI_CHANGED = "CHU_PAI_CHANGED"  -- 出牌改变事件
Player.CHU_PAI_ADDED = "CHU_PAI_ADDED"  -- 出牌增加事件
Player.INDEX_CHANGED = "INDEX_CHANGED"  -- 位置有变事件
Player.SIT_DOWN_EVENT = "SIT_DOWN_EVENT"  -- 坐下事件
Player.STAND_UP_EVENT = "STAND_UP_EVENT"  -- 站起事件
Player.SCORE_CHANGED = "SCORE_CHANGED"  -- 当前积分改变事件
Player.ROUND_SCORE_CHANGED = "ROUND_SCORE_CHANGED"  -- 此局盈利分
Player.ROUND_GONG_XIAN_CHANGED = "ROUND_GONG_XIAN_CHANGED"  -- 贡献分改变
Player.TONG_SCORE_CHANGED = "TONG_SCORE_CHANGED"  -- 当前筒分变动
Player.TOTALSCORE_CHANGED = "TOTALSCORE_CHANGED" --总积分改变事件
Player.GOLD_CHANGED = "GOLD_CHANGED"  -- 金币改变事件
Player.DIAMOND_CHANGED = "DIAMOND_CHANGED"  -- 钻石改变事件
Player.SHOW_RANK_EVENT = "SHOW_RANK_EVENT"  -- 钻石改变事件
Player.ON_AVATAR_CLICKED = "ON_AVATAR_CLICKED"  -- 头像点击事件
Player.ON_CHUPAI_EVENT = "ON_CHUPAI_EVENT"  -- 抛出出牌事件
Player.ON_TIPS_EVENT = "ON_TIPS_EVENT"  --提示牌型事件
Player.ON_KING_SHOW = "ON_KING_SHOW"  --显示王
Player.ON_FLOW_EVENT = "ON_FLOW_EVENT"  --显示王
Player.ON_ROUND_START = "ON_ROUND_START"  --一局游戏结束
Player.ON_ROUND_OVER = "ON_ROUND_OVER"  --一局游戏结束
Player.ON_PASS_EVENT = "ON_PASS_EVENT"  --一局游戏结束
Player.ON_SETDEAR_EVENT = "ON_SETDEAR_EVENT"
Player.ON_SHOWHEISAN_EVENT = "ON_SHOWHEISAN_EVENT"
Player.ON_RANK_EVENT = "ON_RANK_EVENT"
Player.ON_ROUND_OVER_SHOW_POKER = "ON_ROUND_OVER_SHOW_POKER"
Player.ON_KING_OUT = "ON_KING_OUT"
Player.ON_STOP_RECORD_VOICE = "ON_STOP_RECORD_VOICE"
Player.ON_PLAY_RECORD_VOICE = "ON_PLAY_RECORD_VOICE"
Player.OFFLINE_EVENT = "OFFLINE_EVENT"
Player.HIDE_ALL_FLAGS_EVENT = "HIDE_ALL_FLAGS_EVENT"
Player.XUAN_DUI_YOU = "XUAN_DUI_YOU"
Player.SHOW_TEAM_FLAG= "SHOW_TEAM_FLAG"
Player.SHOW_POKER_BACK = "SHOW_POKER_BACK"
Player.ON_SHOW_NIU = "ON_SHOW_NIU"
Player.SHOW_HUCARD_IN_REVIEW = "SHOW_HUCARD_IN_REVIEW"
Player.SHOW_HUI_SE_CARD = "SHOW_HUI_SE_CARD"
Player.SHOW_WIN_FLAG = "SHOW_WIN_FLAG"
Player.SHOW_CARD_NUMBER = "SHOW_CARD_NUMBER"
Player.SHOW_DUI_YOU_PAI = "SHOW_DUI_YOU_PAI"
Player.ZHA_DAN_DE_FEN = "ZHA_DAN_DE_FEN"
Player.GUAN_LONG = "GUAN_LONG"
Player.CURRENT_BOMB_COUNT = "CURRENT_BOMB_COUNT"
Player.CALL_BOMB_COUNT = "CALL_BOMB_COUNT"

Player.CURRENT_POW = "CURRENT_POW"

Player.PASS = "PASS"  -- 过
Player.WARNING = "WARNING"  -- 报警

-- 定义属性
Player.schema = clone(cc.mvc.ModelBase.schema)
Player.schema["uid"] = {"number", 0} -- ID，默认0
Player.schema["userName"] = {"string"} -- 字符串类型，没有默认值
Player.schema["nickName"] = {"string", ""} -- 字符串类型，没有默认值
Player.schema["avatar"] = {"string", ""} -- 头像地址
Player.schema["gold"]    = {"number", 0} -- 数值类型，默认值 0
Player.schema["diamond"]    = {"number", 0} -- 钻石，默认值 0
Player.schema["score"]       = {"number", 0}  -- 当前得分分数
Player.schema["roundScore"]       = {"number", 0}  -- 当前得分分数
Player.schema["tongScore"]       = {"number", 0}  -- 当前得分分数
Player.schema["totalScore"]       = {"number", 0}  -- 总得分分数
Player.schema["sex"]       = {"number", SEX_MALE}
Player.schema["seatID"]       = {"number", 0}  -- 坐位号
Player.schema["isDealer"]       = {"boolean", false}  -- 是否庄家
Player.schema["IP"]       = {"string", ""}  -- IP地址
Player.schema["phone"]       = {"string", "13800138000"}  -- 手机号agent
Player.schema["agent"]       = {"number", 0}  -- 是否代理
Player.schema['index'] = {"number", 1}  -- 玩家对象的实际显示位置索引
Player.schema['cards'] = {"table", {}}  -- 玩家手牌
Player.schema['isCheckOut'] = {"boolean", false}  -- 是否已结算
Player.schema['token'] = {"string", ''} -- 玩家token

Player.schema['chuPai'] = {"table", {}} -- 玩家的出牌

Player.schema['lastCard'] = {"number", 0} -- 玩家的最后摸的一张牌
Player.schema['isFirstHand'] = {"boolean", false} -- 是不是第一手摸牌

Player.schema['isReady'] = {"boolean", false} -- 是否已举手
Player.schema['team'] = {"number", -1} -- 有天炸

Player.schema['sortByType'] = {'number', CARDS_MORE_BOMB_SORT}  -- 1,自然排序 2,牌型排序 3,炸弹最多排序
Player.schema['isFanQiang'] = {'number', -1}  -- 是反枪
Player.schema['isChui'] = {'number', -1}  -- 是否锤
Player.schema['isDou'] = {'number', -1}  -- 是否抖
Player.schema['isFanDou'] = {'number', -1}  -- 是否反抖
Player.schema['isKaiQiang'] = {'number', -1}  -- 是否开枪
Player.schema['warningType'] = {'number', 0}  -- 0， 1报单  2报双
Player.schema['tipsCount'] = {'number', 0}  -- 提示计数
Player.schema['isTips'] = {'boolean', false}  -- 是否已提示
Player.schema['isOffline'] = {'boolean', false}  -- 是否已离线
Player.schema['sortList'] = {"table", {}}  -- 排序列表
Player.schema['leftCards'] = {"number", 0}  -- 排序列表
Player.schema['currentBombCount'] = {"table", {}}  -- 当前已经出的炸弹
Player.schema['callBombCount'] = {"table", {}}  -- 当前叫的炸弹
Player.schema['currentPow'] = {"number", 0}  -- 当前叫的炸弹

-- 将服务器发的信息压扁一下，以方便设置属性
local function toClientProperties(properties)
    return properties
end

function Player:ctor(properties)
    Player.super.ctor(self, toClientProperties(properties))
    self:initStateMachine_()
    self:createGetters(Player.schema)
end

function Player:initStateMachine_()
    self:addComponent("components.behavior.StateMachine")
    self.fsm__ = self:getComponent("components.behavior.StateMachine")
    self:setStates_()
end

function Player:resetStates()
    if not self.fsm__ then
        return
    end
    self.fsm__:setupState({})
    self:setStates_()
end

--[[
玩家身上可能发生的事件列表, 注意每一个事件发生时，玩家的状态的变化
start           开始|创建
sitdown         坐下
ready           准备
unready         取消准备
standup         站起
turnto          被轮到
chu             出牌
guo             过（公共牌时选择不操作)
round_start     局开始
round_over      局结束


玩家状态列表
none            无状态
idle            空闲中(未坐下)
waiting         等待中
ready           准备中(未开局)
wait_call       等待被呼叫
thinking        出牌思考中
checkout        结算中
{name = "", from = {""}, to = ""},
]]
function Player:setStates_()
    local defaultEvents = {
        {name = "start", from = "none", to = "idle"}, -- 初始化后，玩家处于空闲状态
        {name = "sitdown", from = {"idle"}, to = "waiting"},
        {name = "ready", from = {"waiting", "checkout"}, to = "ready"},
        {name = "unready", from = {"ready"}, to = "waiting"},
        {name = "standup", from = {"waiting", "ready"}, to = "idle"},
        {name = "turnto", from = {"wait_call"}, to = "thinking"},
        {name = "chu", from = {"thinking"}, to = "wait_call"},
        {name = "guo", from = {"thinking"}, to = "wait_call"},
        {name = "round_over", from = {"thinking", "wait_call"}, to = "checkout"},
        {name = "round_start", from = {"waiting", "ready", "checkout"}, to = "wait_call"},
    }

    -- 设定状态机的默认回调
    local defaultCallbacks = {
        onchangestate = handler(self, self.onChangeState_),
        onround_start = handler(self, self.onRoundStart_),
        onround_over = handler(self, self.onRoundOver_),
        onstandup = handler(self, self.onStandUp_),
        onbeforestandup = handler(self, self.onBeforeStandUp_),
        onsitdown = handler(self, self.onSitDown_),
    }

    self.fsm__:setupState({
        events = defaultEvents,
        callbacks = defaultCallbacks
    })

    self.fsm__:doEvent("start") -- 启动状态机
end

function Player:canExit()
    if self.fsm__:getState() == "idle" then
        return true
    end
    return self:canStandUp()
end

function Player:setIsReady(flag)
    self.isReady_ = flag
end

function Player:isSitDown()
    return false == table.indexof({'none', 'idle'}, self.fsm__:getState())
end

function Player:canStandUp()
    return self.fsm__:canDoEvent("standup")
end

function Player:getState()
    return self.fsm__:getState()
end

function Player:getFuDou()
    return self.isPrimary_
end

function Player:isPlaying()
    return false == table.indexof({'none', 'idle', 'waiting', 'wait_next'}, self.fsm__:getState())
end

function Player:isPlayingState(state)
    return false == table.indexof({'none', 'idle', 'waiting', 'wait_next'}, state)
end

function Player:getPublicData()
    local params = self:getShowParams()
    params.IP = nil
    return params
end

function Player:setOffline(offline, ip)
    self.IP_ = ip
    local rawOffline = self.isOffline_
    self.isOffline_ = offline
    self:dispatchEvent({name = Player.OFFLINE_EVENT, offline = offline, IP = ip, isChanged = rawOffline ~= offline})
end

function Player:setCurrentPow(pow)
    self.currentPow_ = pow
    self:dispatchEvent({name = Player.CURRENT_POW, pow = pow, callBombCount = (self.callBombCount_ or {})})
end

function Player:setSortByType(bool)
    self.sortByType_ = bool
end

function Player:getSortByType(bool)
    return self.sortByType_
end

function Player:setOldIP(ip)
    if self.IP_ == nil or self.IP_ == '' then
        self.IP_ = ip
    end
end

function Player:getNickName()
    -- self.nickName_ = "患难生生的发发发是短发短发水电费水电费的风格"
    return gailun.utf8.formatNickName(self.nickName_, 12, '..')
end

function Player:getFullNickName()
    return self.nickName_
end

function Player:setLouHu(louHu)
    self.louHu_ = louHu or {}
end

function Player:addLouHu(card)
    assert(card and card >= 0)
    table.insert(self.louHu_, card)
end

function Player:doPlayAction(data)
    if table.indexof({ACTIONS.CHI, ACTIONS.PENG, ACTIONS.CHI_GANG}, data.actType) ~= false then
        self:setLouHu(nil) -- 这些动作都要清除手上漏胡牌列表
    end
    local methodName = "onAction" .. string.ucfirst(data.actType) .. "_"
    if type(self[methodName]) == "function" then
        self[methodName](self, data)
    else
        printError("doPlayAction with no methods")
    end
end

function Player:onActionGuo_(data)
    self:tryDoEvent_("guo")
end

function Player:standup()
    self:tryDoEvent_("standup")
end

function Player:beTurnTo(seconds)
    self:tryDoEvent_("turnto", seconds)
end

function Player:checkOutData(winChips, exp)
    local exp = exp or 0
    local isWin = winChips > 0

    if self.isCheckOut_ then
        return isWin
    end

    self.isCheckOut_ = true
    return isWin
end

function Player:onRoundStart_(event)
    self:removeAllCards_()
    self.isCheckOut_ = false
    self.isFirstHand_ = true
    self:setCurrentPow(0)
    self:showWinFlg(-1)
    self:setDealer(-1)
    self:warning(-1)
    self:stopRecordVoice()
    self:showRoundOverPoker(nil)
    self.cards_ = {}
    self.isTips_ = false
    self.tipsCount_  = 0
    self.tipsCards_ = {}
    self:setGXScore(0)

    self:dispatchEvent({name = Player.ON_ROUND_START})
end

function Player:gameOver()
    self:removeAllCards_()
    self.isCheckOut_ = false
    self.isFirstHand_ = true
    local isReConnect = false
    -- if event.args then
    --     isReConnect = event.args[1]
    -- end
    if isReConnect then  -- 重连时不再扣台费
        return
    end
    self:showRoundOverPoker(nil)
    self:setDealer(-1)
    self:warning(-1)
    self:stopRecordVoice()
    self:hideAllFlags_()
    self.cards_ = {}
    self.isTips_ = false
    self.tipsCount_  = 0
    self.tipsCards_ = {}
end

function Player:resetPlayer()
    self:removeAllCards_()
    self.isCheckOut_ = false
    self.isFirstHand_ = true
    local isReConnect = false
    if isReConnect then  -- 重连时不再扣台费
        return
    end
    self:showWinFlg(-1)
    self:showRoundOverPoker(nil)
    self:setDealer(-1)
    self:hideAllFlags_()
    self:warning(-1)
    self:stopRecordVoice()
    self.cards_ = {}
    self.isTips_ = false
    self.tipsCount_  = 0
    self.tipsCards_ = {}
end

function Player:removeAllCards_()
    self:removeCards()
    self:setChuPai({})
end

function Player:onRoundOver_(event)
    -- self:removeAllCards_()
    self.roundScore_ = 0
    self.isFirstHand_ = false
    self:dispatchEvent({name = Player.ON_ROUND_OVER})
end

function Player:onSitDown_(event)
    self:dispatchEvent({name = Player.SIT_DOWN_EVENT, seatID = self.seatID_, nickName = self.nickName_})
end

function Player:showRank(rank, isReConnect)
    self:dispatchEvent({name = Player.ON_RANK_EVENT, rank = rank, isReConnect = isReConnect})
end

function Player:onStandUp_(event)
    local before = self.seatID_
    self:setSeatID(0)
    self:dispatchEvent({name = Player.STAND_UP_EVENT, seatID = before})
    gameAudio.playSound("standup.mp3")
end

function Player:onBeforeStandUp_(event)
    if not self:isPlaying() then
        self:setScore(0)
    end
end

function Player:forceStandUp()
    self.fsm__:doEventForce("standup")
end

function Player:sitDown()
    self:tryDoEvent_("sitdown")
end

function Player:doReady(isReady)
    printInfo("Player:doReady(isReady): " .. self:getState())
    self:setIsReady(isReady)
    if isReady then
        self:tryDoEvent_("ready")
    else
        self:tryDoEvent_("unready")
    end
end

function Player:isReady()
    return self.isReady_
end

function Player:doWaitCall()
    self:doEventForce("guo")
end

function Player:doChuPai()
    self:tryDoEvent_("chu")
end

function Player:doEventForce(eventName, ...)
    return self.fsm__:doEventForce(eventName, ...)
end

function Player:tryDoEvent_(eventName, ...)
    printInfo("Player:tryDoEvent_(eventName, ...)" .. eventName)
    if self.fsm__:canDoEvent(eventName) then
        return self.fsm__:doEvent(eventName, ...)
    end
end

function Player:onChangeState_(event)
    local event = {name = Player.CHANGE_STATE_EVENT, from = event.from, to = event.to, args = event.args}
    self:dispatchEvent(event)
end

function Player:getAvatarName()
    return self:getAvatarNameBySexAndAvatar(self.sex_, self.avatar_)
end

function Player:getAvatarNameBySexAndAvatar(sex, avatar)
    if avatar and string.len(avatar) > 0 then
        return avatar
    end
    return "res/images/common/defaulthead.png"
end

function Player:reduceLeftCards(cardsCount)
    if self.leftCards_ == -1 then
        return
    end

    local before = self.leftCards_

    self.leftCards_ = self.leftCards_ - cardsCount
    self:dispatchEvent({name = Player.LEFT_CARDS_CHANGED, from = before, to = self.leftCards_})
end

function Player:setLeftCards(leftCards)
    self.leftCards_ = leftCards
    self:dispatchEvent({name = Player.LEFT_CARDS_CHANGED, to = self.leftCards_})
end

function Player:getLeftCards()
    return self.leftCards_
end

function Player:getShowParams()
    local params = {
        uid = self.uid_,
        nickName = self.nickName_,
        IP = self.IP_,
        avatar = self:getAvatarName(),
        sex = self.sex_,
    }
    return params
end

function Player:getCurrentBombCount()
    return self.currentBombCount_
end

function Player:getCallBombCount()
    return self.callBombCount_
end

function Player:bombCountChange()
    self:dispatchEvent({name = Player.CURRENT_BOMB_COUNT, bombCount = clone(self.currentBombCount_), callBombCount = clone(self.callBombCount_)})
end

function Player:setCurrentBombCount(bombCount)
    self.currentBombCount_ = bombCount

    self:bombCountChange()
end

function Player:setCallBombCount(bombCount)
    if bombCount == nil then
        return
    end
    self.callBombCount_ = bombCount

    self:bombCountChange()
    self:dispatchEvent({name = Player.CALL_BOMB_COUNT, bombCount = clone(self.currentBombCount_), callBombCount = clone(self.callBombCount_)})
end

-- 当批量设置玩家参数时，基类默认的setProperties不会引发相应的值的改变事件，也就无法自动更新
-- 这里引入一个setMulti的方法，只要是系统有 setXXX相关的方法，注意XXX第一个字母大写，则先调用
-- 自身的方法，这样来发出事件
function Player:setMulti(params)
    local params = toClientProperties(params)
    for k,v in pairs(params) do
        local funcName = "set" .. string.ucfirst(k)
        if self[funcName] and type(self[funcName]) == "function" then
            self[funcName](self, v)
        end
    end
    Player.super.setProperties(self, params)
end

function Player:setUid(uid)
    self.uid_ = uid
end

function Player:setSeatID(seatID)
    self.seatID_ = seatID
end

function Player:getSeatID()
    return self.seatID_
end

function Player:setIndex(index, flag)
    self.index_ = index
    self:dispatchEvent({name = Player.INDEX_CHANGED, index = index, withAction = flag})
end

function Player:addGold(gold)
    return self:setGold(self:getGold() + gold)
end

function Player:setGold(gold)
    local rawGold = self.gold_
    self.gold_ = gold
    self:dispatchEvent({name = Player.GOLD_CHANGED, gold = gold, from = rawGold})
end

function Player:setDiamond(diamond)
    local rawDiamond = self.diamond_
    self.diamond_ = diamond
    self:dispatchEvent({name = Player.DIAMOND_CHANGED, diamond = diamond, from = rawDiamond})
end

function Player:setScore(score)
    local rawScore = self.score_
    print(score, self.seatID_)
    self.score_ = score
    self:dispatchEvent({name = Player.SCORE_CHANGED, score = score, from = rawScore, seatID = self.seatID_})
end

function Player:setRoundScore(score)
    local rawScore = self.roundScore_
    self.roundScore_ = score
    self:dispatchEvent({name = Player.ROUND_SCORE_CHANGED, score = score, from = rawScore, seatID = self.seatID_})
end

function Player:setGXScore(score)
    self.gxScore_ = score
    self:dispatchEvent({name = Player.ROUND_GONG_XIAN_CHANGED, score = score, seatID = self.seatID_})
end

function Player:setTongScore(score)
    local rawScore = self.tongScore_
    self.tongScore_ = score
    self:dispatchEvent({name = Player.TONG_SCORE_CHANGED, score = score, from = rawScore, seatID = self.seatID_})
end

function Player:setTotalScore(totalScore)
    self.totalScore_ = totalScore
    self:dispatchEvent({name = Player.TOTALSCORE_CHANGED, score = totalScore, from = rawScore})
end

-- 设置外牌
function Player:setWaiPai(cards)
    self.waiPai_ = clone(cards) or {}
    self:dispatchEvent({name = Player.WAI_PAI_CHANGED, data = self.waiPai_})
end

function Player:getIsFirstHand()
    return self.isFirstHand_ and #self.chuPai_ == 0 and #self.waiPai_ == 0
end

-- 添加外牌
function Player:addWaiPai(data)
    assert(data and data.action and #data.cards <= 4)
    local data = clone(data)
    table.insert(self.waiPai_, data)
    self:dispatchEvent({name = Player.WAI_PAI_ADDED, data = data, index = #self.waiPai_})
end

-- 出牌动作
function Player:setChuPai(cards, isReConnect, inFastMode, seatID, isLast)
    if seatID == display:getRunningScene():getHostPlayer():getSeatID() then
        self:removeCardsFromHand_(cards)
    end
    self:dispatchEvent({name = Player.CHU_PAI_CHANGED, isLast = isLast, seatID = seatID, cards = cards, isReConnect = isReConnect, inFastMode = inFastMode})
end

function Player:setDuiYouChuPai(cards, isReConnect, inFastMode, seatID, count)
    self:dispatchEvent({name = Player.DUI_YOU_CHU_PAI_CHANGED, count = count ,seatID = seatID,cards = cards, isReConnect = isReConnect, inFastMode = inFastMode})
end

-- 添加出牌
function Player:addChuPai(card, dennyAnim)
    assert(card and card > 0)
    table.insert(self.chuPai_, card)
end

function Player:removeCardsFromHand_(cards)
    if cards == nil then return end
    for i = 1, #cards do
        table.removebyvalue(self.cards_, cards[i])
    end
end

function Player:removeCardFromChuPai_(card)
    for i = #self.chuPai_, 1, -1 do
        if card == self.chuPai_[i] then
            table.remove(self.chuPai_, i)
            break
        end
    end
end

function Player:addPoker(card)
    self:setLastCard(card)
    table.insert(self.cards_, card)
    local event = {
        name = Player.POKER_FOUND,
        card = card,
    }
    self:dispatchEvent(event)
end

function Player:safeRemoveCards()
    if self:isPlaying() and not (self:getState() == 'in_winning' or self:getState() == 'in_losing') then
        return
    end
    self:removeCards()
end

function Player:setCards(cards, isReConnect)
    self.cards_ = cards
    self.isReConnect_ = isReConnect

    if isReConnect ~= true then
        self:setCallBombCount({})
        self:setCurrentBombCount({})
    end
end

function Player:setLastCard(card)
    self.lastCard_ = card
end

function Player:removeCards()
    self:dispatchEvent({name = Player.HAND_CARDS_CHANGED, cards = nil})
end

function Player:showCards()
    self.sortList_ = {}
    self:dispatchEvent({name = Player.HAND_CARDS_CHANGED, cards = self.cards_, isReConnect = self.isReConnect_})
end

function Player:warning(flag, inFastMode, isReConnect)
    self.warningType_ = flag
    self:dispatchEvent({name = Player.WARNING, warningType = flag, inFastMode = inFastMode, isReConnect = isReConnect})
end

function Player:getNextPlayer()
    local nextSeatID = 1
    if self.seatID_ == 1 then
        nextSeatID = 2
    elseif self.seatID_ == 2 then
        nextSeatID = 3
    elseif self.seatID_ == 3 then
        nextSeatID =1
    end
    return nextSeatID
end

function Player:pass(inFastMode)
    if not inFastMode then
        gameAudio.playHumanSound("buyao.mp3", self.sex_)
    end
    self:tryDoEvent_("guo")
    self:dispatchEvent({name = Player.PASS, inFastMode = inFastMode})
    self.isTips_ = false
    self.tipsCount_  = 0
    self.tipsCards_ = {}
end

function Player:sortCards()
    self.isTips_ = false
    self.tipsCount_  = 0
    self.tipsCards_ = {}
    self:setSortByType(self:getSortByType() + 1)
    if self:getSortByType() > SK_CARDS_REVERT_SORT then
        self:setSortByType(SK_CARDS_ZI_RAN_SORT)
    end
    self.tipsCount_  = 0
    self.tipsCards_ = {}
    self.isTips_ = false
    self:dispatchEvent({name = Player.HAND_CARD_SORT, })
end

function Player:doCardsEvent_(eventName, cards, action)
    self:setCards(checktable(cards))
    local card
    if action == ACTIONS.CHI_HU then
        card = display:getRunningScene():getTable():getLastCard()
    end
    self:dispatchEvent({name = eventName, cards = cards, action = action, huPai = card})
end

function Player:dispatchChuPaiEvent(event)
    self.isTips_ = false
    self.tipsCount_  = 0
    self.tipsCards_ = {}
    self:dispatchEvent({name = Player.ON_CHUPAI_EVENT, bombCount = event.bombCount})
end

function Player:dispatchXuanDuiYou()
    self:dispatchEvent({name = Player.XUAN_DUI_YOU})
end

function Player:tishi()
    self:dispatchEvent({name = Player.ON_TIPS_EVENT})
end

function Player:passEvent()
    self:dispatchEvent({name = Player.ON_PASS_EVENT})
end

function Player:setDealer(bool, jokerInHand)
    self.isDealer_ = bool
    self:dispatchEvent({name = Player.ON_SETDEAR_EVENT, isDealer = bool})
end

function Player:doFlow(flag)
    self:dispatchEvent({name = Player.ON_FLOW_EVENT, flag = flag})
end

function Player:playerHeiSan()
    self:dispatchEvent({name = Player.ON_SHOWHEISAN_EVENT})
end

function Player:showRoundOverPoker(cards)
    local tempCards = {}
    if cards and #cards > 0 then
        tempCards  = ShuangKouAlgorithm.sort(1,cards)
    end
    self:dispatchEvent({name = Player.ON_ROUND_OVER_SHOW_POKER, cards = tempCards})
end

function Player:playRecordVoice(time)
    self:dispatchEvent({name = Player.ON_PLAY_RECORD_VOICE, time = time})
end

function Player:stopRecordVoice()
    self:dispatchEvent({name = Player.ON_STOP_RECORD_VOICE})
end

function Player:hideAllFlags_()
    self:dispatchEvent({name = Player.HIDE_ALL_FLAGS_EVENT})
end

function Player:setQiangZhuang(isQianged)
    self.isQianged_ = isQianged
end

function Player:isQiangZhuang()
    return self.isQianged_
end

function Player:showWinFlg(score)
    self:dispatchEvent({name = Player.SHOW_WIN_FLAG, score = score})
end

function Player:showZhaDanDeFen(score)
    self:dispatchEvent({name = Player.ZHA_DAN_DE_FEN, score = score})
end

function Player:guanLong()
    self:dispatchEvent({name = Player.GUAN_LONG})
end

function Player:showPokerBack(isShow)
    self:dispatchEvent({name = Player.SHOW_POKER_BACK, isShow = isShow})
end

return Player
