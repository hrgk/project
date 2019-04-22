local BaseAlgorithm = require("app.games.fhhzmj.utils.BaseAlgorithm")
local ZZAlgorithm = require("app.games.fhhzmj.utils.ZZAlgorithm")
local Player = class("Player", gailun.JWModelBase)

-- 定义事件
Player.CHANGE_STATE_EVENT = "CHANGE_STATE_EVENT"
Player.MA_JIANG_FOUND = "MA_JIANG_FOUND"
Player.HAND_CARDS_CHANGED = "HAND_CARDS_CHANGED"
Player.HAND_CARD_REMOVED = "HAND_CARD_REMOVED"  -- 手牌减少事件
Player.WAI_PAI_CHANGED = "WAI_PAI_CHANGED"  -- 外牌改变事件
Player.WAI_PAI_ADDED = "WAI_PAI_ADDED"  -- 外牌增加事件
Player.CHU_PAI_CHANGED = "CHU_PAI_CHANGED"  -- 出牌改变事件
Player.CHU_PAI_ADDED = "CHU_PAI_ADDED"  -- 出牌增加事件
Player.INDEX_CHANGED = "INDEX_CHANGED"  -- 位置有变事件
Player.SIT_DOWN_EVENT = "SIT_DOWN_EVENT"  -- 坐下事件
Player.STAND_UP_EVENT = "STAND_UP_EVENT"  -- 站起事件
Player.SCORE_CHANGED = "SCORE_CHANGED"  -- 积分改变事件
Player.GOLD_CHANGED = "GOLD_CHANGED"  -- 金币改变事件
Player.DIAMOND_CHANGED = "DIAMOND_CHANGED"  -- 钻石改变事件
Player.ON_HU_EVENT = "ON_HU_EVENT"  -- 胡牌事件
Player.ON_TING_EVENT = "ON_TING_EVENT" -- 听牌事件
Player.ON_BU_GANG_EVENT = "ON_BU_GANG_EVENT"  -- 补杠事件发生
Player.ON_AVATAR_CLICKED = "ON_AVATAR_CLICKED"  -- 头像点击事件
Player.SHOW_READY = "SHOW_READY"
Player.ON_SCORE_CHANGE_EVENT = "ON_SCORE_CHANGE_EVENT"
Player.ON_RECONNECT_FOCUSON = "ON_RECONNECT_FOCUSON"
Player.ON_ZHUANQUAN = "ON_ZHUANQUAN"
Player.ON_STOP_ZHUANQUAN = "ON_STOP_ZHUANQUAN"
Player.ON_STOP_RECORD_VOICE = "ON_STOP_RECORD_VOICE" 
Player.ON_PLAY_RECORD_VOICE = "ON_PLAY_RECORD_VOICE"
Player.OFFLINE_EVENT = "OFFLINE_EVENT"
Player.CHUI = "CHUI"  -- 锤
Player.ON_FLOW_EVENT = "ON_FLOW_EVENT"  --显示王
Player.ON_RESET_PLAYER = "ON_RESET_PLAYER"  --显示王
Player.ON_TAN_PAI = "ON_TAN_PAI"
Player.TAN_PAI_ADDED = "TAN_PAI_ADDED"
Player.TAN_PAI_RESUME= "TAN_PAI_RESUME"
Player.CHU_PAI_COUNT = "CHU_PAI_COUNT"
Player.GAME_TG = "GAME_TG"
Player.AUTO_OUT_CARD = "AUTO_OUT_CARD"
-- 定义属性
Player.schema = clone(cc.mvc.ModelBase.schema)
Player.schema["uid"] = {"number", 0} -- ID，默认0
Player.schema["userName"] = {"string"} -- 字符串类型，没有默认值
Player.schema["nickName"] = {"string", ""} -- 字符串类型，没有默认值
Player.schema["avatar"] = {"string", ""} -- 头像地址
Player.schema["gold"]    = {"number", 0} -- 数值类型，默认值 0
Player.schema["diamond"]    = {"number", 0} -- 钻石，默认值 0
Player.schema["score"]       = {"number", 0}  -- 分数
Player.schema["sex"]       = {"number", SEX_MALE}
Player.schema["seatID"]       = {"number", 0}  -- 坐位号
Player.schema["IP"]       = {"string", ""}  -- IP地址
Player.schema['isChui'] = {'number', -1}  -- 是否锤

Player.schema['index'] = {"number", 1}  -- 玩家对象的实际显示位置索引
Player.schema['cards'] = {"table", {}}  -- 玩家手牌
Player.schema['isCheckOut'] = {"boolean", false}  -- 是否已结算
Player.schema['token'] = {"string", ''} -- 玩家token
Player.schema['status'] = {"number", 0} -- 玩家在线状态
Player.schema['isLockCard'] = {"int", 0} -- 玩家手牌是否锁定

Player.schema['waiPai'] = {"table", {}} -- 玩家的外牌
Player.schema['chuPai'] = {"table", {}} -- 玩家的出牌

Player.schema['lastCard'] = {"number", 0} -- 玩家的最后摸的一张牌
Player.schema['isFirstHand'] = {"boolean", false} -- 是不是第一手摸牌

Player.schema['isReady'] = {"boolean", false} -- 是否已举手

Player.schema['louHu'] = {'number', 0}  -- 漏胡列表
Player.schema['loginTime'] = {'number', 0}  -- 漏胡列表
Player.schema['roundCount'] = {'number', 0}  -- 漏胡列表

-- 将服务器发的信息压扁一下，以方便设置属性
local function toClientProperties(properties)
    print(properties)
    return properties
end

function Player:ctor(properties)
    Player.super.ctor(self, toClientProperties(properties))
    self:initStateMachine_()
    self:createGetters(Player.schema)
    self.isHost = false

end

function Player:initStateMachine_()
    self:addComponent("components.behavior.StateMachine")
    self.fsm__ = self:getComponent("components.behavior.StateMachine")
    self:setStates_()
end

function Player:resetAllSchema()
    self:removeAllCards_()
    self:resetStates()
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
mo_pai          摸牌
chu             出牌
other_chu       其他人出牌
chi             吃
peng            碰
chiGang         吃杠(从别人手里杠到的)
buGang          补杠(碰完后再摸到一张)
anGang          暗杠(自己摸到的4张)
chiHu           吃胡
ziMo            自摸胡
qiangGangHu     抢杠胡
guo             过（公共牌时选择不操作)
zhua_liao       抓鸟
fang_pao        放炮
round_start     局开始
round_over      局结束
game_over       整局结束


玩家状态列表
none            无状态
idle            空闲中(未坐下)
waiting         等待中
ready           准备中(未开局)
wait_call       等待被呼叫
public_thinking 公共牌思考中
thinking        出牌思考中
in_hu           胡牌中
in_fang_pao     放炮中
in_zhua_liao    抓鸟中
{name = "", from = {""}, to = ""},
]]
function Player:setStates_()
    local defaultEvents = {
        {name = "start", from = "none", to = "idle"}, -- 初始化后，玩家处于空闲状态
        {name = "sitdown", from = {"idle"}, to = "waiting"},
        {name = "ready", from = {"waiting", "wait_next"}, to = "ready"},
        {name = "unready", from = {"ready"}, to = "waiting"},
        {name = "standup", from = {"waiting", "ready"}, to = "idle"},
        {name = "turnto", from = {"wait_call"}, to = "thinking"},

        -- {name = "mo_pai", from = {"wait_call"}, to = "thinking"},
        {name = "chu", from = {"thinking"}, to = "wait_call"},
        {name = "other_chu", from = {"wait_call"}, to = "public_thinking"},
        {name = "chi", from = {"public_thinking"}, to = "thinking"},
        {name = "peng", from = {"public_thinking"}, to = "thinking"},
        {name = "anGang", from = {"public_thinking", "thinking"}, to = "wait_call"},
        {name = "buGang", from = {"public_thinking", "thinking"}, to = "wait_call"},
        {name = "chiGang", from = {"public_thinking", "thinking"}, to = "wait_call"},
        {name = "chiHu", from = {"public_thinking", "thinking"}, to = "in_hu"},
        {name = "ziMo", from = {"public_thinking", "thinking"}, to = "in_hu"},
        {name = "qiangGangHu", from = {"public_thinking", "thinking"}, to = "in_hu"},
        {name = "guo", from = {"public_thinking"}, to = "wait_call"},
        {name = "zhua_liao", from = {"in_hu"}, to = "in_zhua_liao"},
        {name = "fang_pao", from = {"wait_call"}, to = "in_fang_pao"},
        {name = "round_over", from = {"in_hu", "thinking", "in_zhua_liao", "in_fang_pao", "public_thinking", "wait_call"}, to = "wait_next"},
        {name = "round_start", from = {"waiting", "wait_next", "ready"}, to = "wait_call"},
        {name = "game_over", from = {"in_hu", "in_fang_pao", "in_zhua_liao", "thinking", "public_thinking"}, to = "waiting"},
        {name = "reconnect", from = {"idel", "waiting", "ready", "checkout"}, to = "wait_call"},

    }

    -- 设定状态机的默认回调
    local defaultCallbacks = {
        onchangestate = handler(self, self.onChangeState_),
        onround_start = handler(self, self.onRoundStart_),
        onround_over = handler(self, self.onRoundOver_),
        onstandup = handler(self, self.onStandUp_),
        onreconnect = handler(self, self.onReconnect_),
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

function Player:setIP(ip)
    self.IP_ = ip
end

function Player:getIP()
    return self.IP_
end

function Player:getChuPai()
    return self.chuPai_
end

function Player:setChuPaiCount_(chuPaiCount)
    self:dispatchEvent({name = Player.CHU_PAI_COUNT, chuPaiCount = chuPaiCount})
end

function Player:onActionTanPai(data, isReview)
    if data.cards then
        local cards = data.cards
        self.cardsBeforeTanPai_ = clone(self.cards_)
        self.tanPai_ = {}
        self.isTanPai_ = true
        local data = clone(data)
        table.insert(self.tanPai_, data)
        self:dispatchEvent({name = Player.TAN_PAI_ADDED, data = data, isReview = isReview, index = 1, huNameList = huNameList})
    end
end

function Player:setOffline(offline, ip)
    self.IP_ = ip
    local rawOffline = self.isOffline_
    self.isOffline_ = offline
    self:dispatchEvent({name = Player.OFFLINE_EVENT, offline = offline, IP = ip, isChanged = rawOffline ~= offline})
end

function Player:setOldIP(ip)
    if self.IP_ == nil or self.IP_ == '' then
        self.IP_ = ip
    end
end

function Player:showReady_(isReady)
    self:dispatchEvent({name = Player.SHOW_READY, isReady = isReady})
end

function Player:getAllAnGang()
    local cards = {}
    local tmp = {}
    for _,v in ipairs(checktable(self.cards_)) do
        if tmp[v] then
            tmp[v] = tmp[v] + 1
        else
            tmp[v] = 1
        end
    end
    for k,v in pairs(tmp) do
        if 4 == v and v ~= BaseAlgorithm.NAI_ZI then
            table.insert(cards, k)
        end
    end
    return cards
end

function Player:doFlow(flag)
    print("player doflow "..flag)
    self:dispatchEvent({name = Player.ON_FLOW_EVENT, flag = flag})
end

function Player:chui(flag, isRecon, inFastMode)
    print("Player:chui",flag)
    self.isChui_ = flag
    self:dispatchEvent({name = Player.CHUI, isChui = flag, isRecon = isRecon, inFastMode = inFastMode})
end

function Player:checkTingPai()
    local isTingPai = ZZAlgorithm.isTingPai(self.cards_,display.getRunningScene():getTable():getAllowSevenPairs())
    self:dispatchEvent({name = Player.ON_TING_EVENT, isTing = isTingPai})
end

function Player:getNickName()
    return gailun.utf8.formatNickName(self.nickName_, 10, '..')
end

function Player:setNickName(nickName)
    self.nickName_ = nickName
end

function Player:getFullNickName()
    return self.nickName_
end

function Player:setLouHu(louHu)
    self.louHu_ = louHu or 0
end

function Player:addLouHu(card)
    assert(card and card >= 0)
    -- table.insert(self.louHu_, card)
    self.louHu_ = card
end

function Player:doPlayAction(data)
    if table.indexof({MJ_ACTIONS.CHI, MJ_ACTIONS.PENG, MJ_ACTIONS.CHI_GANG}, data.actType) ~= false then
        self:setLouHu(nil) -- 这些动作都要清除手上漏胡牌列表
    end
    local methodName = "onAction" .. string.ucfirst(data.actType) .. "_"
    if type(self[methodName]) == "function" then
        self[methodName](self, data)
    else
        printError("doPlayAction with no methods")
    end
end

function Player:setCards(cards, isRconnect)
    self.cards_ = cards    
    local card = nil
    if not isDown and cards and 14 == #cards then
        card = cards[14]
        table.remove(cards, #cards)
    end
    self:doCardsEvent_(Player.HAND_CARDS_CHANGED, cards, isDown, action)
    if card then
        self:addMaJiang(card, isDown)
    end
end

function Player:onActionGuo_(data)
    self:tryDoEvent_("guo")
end

function Player:onActionChi_(data)
    if self.isTanPai_ then
        self:resumeTanPai(data.isReview)
    end
    self:setLouHu(nil) -- 这些动作都要清除手上漏胡牌列表q'q
    self:setLastCard(0)
    self:tryDoEvent_("chi")
    local card = data.card
    for _, v in ipairs(data.cards) do
        self:removeCardFromHand_(v)
    end
    table.insert(data.cards, 2, card)
    self:addWaiPai({action = MJ_ACTIONS.CHI, dennyAnim = data.dennyAnim, cards = data.cards})
end

function Player:isHostPlayer()
    return self.isHost or false
end

function Player:setHostPlayer()
    self.isHost = true
end

function Player:onActionPeng_(data)
    if self.isTanPai_ then
        self:resumeTanPai(data.isReview)
    end
    self:setLouHu(nil) -- 这些动作都要清除手上漏胡牌列表q'q
    self:setLastCard(0)
    self:tryDoEvent_("peng")
    local card = data.cards[1]
    for i=1,2 do  -- 删除对应的牌张
        self:removeCardFromHand_(card)
    end
    self:addWaiPai({action = MJ_ACTIONS.PENG, dennyAnim = data.dennyAnim, cards = {card, card, card}})
end

function Player:onActionGang_(data)
    print("onActionGang")
    if self.isTanPai_ then
        self:resumeTanPai(data.isReview)
    end
    local action = data.act
    if action == MJ_ACTIONS.AN_GANG then
        self:onActionAnGang_(data)
        elseif  action == MJ_ACTIONS.BU_GANG then
        self:onActionBuGang_(data)
        elseif  action == MJ_ACTIONS.CHI_GANG then
        self:onActionChiGang_(data)
    end
end

function Player:onActionBuGang_(data)
    self:tryDoEvent_("buGang")
    if self.isTanPai_ then
        self:resumeTanPai(data.isReview)
    end
    local card = data.card
    self:removeCardFromHand_(card)
    for i,v in ipairs(checktable(self.waiPai_)) do
        if v.action == MJ_ACTIONS.PENG and v.cards[1] == card then
            v.action = MJ_ACTIONS.BU_GANG
            table.insert(v.cards, card)
            self:setWaiPai(self.waiPai_)
            self:dispatchEvent({name = Player.ON_BU_GANG_EVENT})
            break
        end
    end
end

function Player:onActionChiGang_(data)
    self:tryDoEvent_("chiGang")
    local card = data.card
    for i=1,3 do  -- 删除对应的牌张
        self:removeCardFromHand_(card)
    end
    local seatID = display.getRunningScene():getTable():getLastSeatID()
    self:addWaiPai({action = data.act, dennyAnim = data.dennyAnim, cards = {card, card, card, card}, seatID = seatID})
end

function Player:showScoreAnim(score)
    self:dispatchEvent({name = Player.ON_SCORE_CHANGE_EVENT, score = score})
end

function Player:onActionAnGang_(data)
    self:tryDoEvent_("anGang")
    local card = data.card
    for i=1,4 do  -- 删除对应的牌张
        self:removeCardFromHand_(card)
    end
    self:addWaiPai({action = data.act, dennyAnim = data.dennyAnim, cards = {card, card, card, card}})
    -- self:doCardsEvent_(Player.HAND_CARDS_CHANGED, self.cards_, false)

end

-- 添加外牌
function Player:addTanPai(data)
    assert(data)
end

-- 添加外牌
function Player:resumeTanPai(isReview)
    print("isReview")
    self.cards_ = clone(self.cardsBeforeTanPai_)
    self.tanPai_ = {}
    self.isTanPai_ = false
    self:dispatchEvent({name = Player.TAN_PAI_RESUME, data = self.cards_})
    local isDown = false
    if self.isReview_ then
        isDown = true
    end
    print("resuemTanPai")
    self:showCards(self.cards_, isDown)
end

function Player:onActionHu_(data)
    if self.isTanPai_ then
        self:resumeTanPai(data.isReivew)
    end
    local action = MJ_ACTIONS.CHI_HU
    if data.isZiMo then
        action = MJ_ACTIONS.ZI_MO
    elseif data.isQiangGangHu then
        action = MJ_ACTIONS.QIANG_GANG_HU
    end
    data.cards = data.shouPai
    data.action = action
    if action == MJ_ACTIONS.CHI_HU then
        self:onActionChiHu_(data)
        elseif  action == MJ_ACTIONS.ZI_MO then
        self:onActionZiMo_(data)
        elseif  action == MJ_ACTIONS.QIANG_GANG_HU then
        self:onActionQiangGangHu_(data)
    end
    self.preSeatID_ = data.preSeatID
end

function Player:getPreSeatID()
    return self.preSeatID_ or 0
end

function Player:onActionChiHu_(data)
    self:tryDoEvent_("chiHu")
    print("Player:onActionChiHu_(data)")
    self:showCards(data.cards, true, data.action)
end

function Player:onActionZiMo_(data)
    self:tryDoEvent_("ziMo")
    print("Player:onActionZiMo_(data)")
    self:showCards(data.cards, true, data.action)
end

function Player:onActionQiangGangHu_(data)
    self:tryDoEvent_("qiangGangHu")
    print("Player:onActionQiangGangHu_(data)")
    self:doCardsEvent_(Player.HAND_CARDS_CHANGED, data.cards, true, data.action)
    self:addMaJiang(data.huCards[1], true)
end

function Player:beQiangGang(card)
    for _,v in ipairs(self.waiPai_) do
        if v.action == MJ_ACTIONS.BU_GANG and v.cards and v.cards[1] == card then
            v.action = MJ_ACTIONS.PENG
            table.remove(v.cards)
            self:setWaiPai(self.waiPai_)
            return
        end
    end
end

function Player:onActionZhuaNiao_(data)
    print("Player:onActionZhuaNiao(data)")
end

function Player:standup()
    self:tryDoEvent_("standup")
end

function Player:beTurnTo(seconds)
    self:tryDoEvent_("turnto", seconds)
    if self.isTanPai_ then
        self:resumeTanPai(isReview)
    end
end

-- 轮到玩家
function Player:doTurnto()
    self:tryDoEvent_("turnto")
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

function Player:doCheckOut(score)
    self:checkOutData(score)
    local eventName = "round_over"
    if self.fsm__:canDoEvent(eventName) then
        self.fsm__:doEvent(eventName)
    end
end

function Player:onRoundStart_(event)
    print("onRoundStart() player:")
    self.isCheckOut_ = false
    self.isFirstHand_ = true
    local isReConnect = false
    if event.args then
        isReConnect = event.args[1]
    end
    if isReConnect then  -- 重连时不再扣台费
        return
    end
end

function Player:gameOver()
    self:removeAllCards_()
end

function Player:onReconnect_(event)
    print("player onReconnect(status)")
    -- self:removeAllCards_()
    self.isCheckOut_ = false
    self.isFirstHand_ = true
    local isReConnect = false
    if event.args then
        isReConnect = event.args[1]
    end
end

function Player:removeAllCards_()
    if self.isTanPai_ then
        self:resumeTanPai()
    end
    self:removeCards()
    self:setWaiPai({})
    self:setLouHu(nil)
    self:setChuPai(nil)
end

function Player:removeAllCards()
    self:removeAllCards_()
end

function Player:onRoundOver_(event)
    self:removeAllCards_()
    self.isFirstHand_ = false
end

function Player:doRoundOver()
    -- self:onRoundOver_()
end

function Player:onSitDown_(event)
    self:dispatchEvent({name = Player.SIT_DOWN_EVENT, seatID = self.seatID_})
end

function Player:onStandUp_(event)
    self:setSeatID(0)
    self:dispatchEvent({name = Player.STAND_UP_EVENT})
    gameAudio.playSound("standup.mp3")
end

function Player:onBeforeStandUp_(event)
    if not self:isPlaying() then
        self:setScore(0)
    end
end

function Player:resetPlayer()
    self:removeAllCards_()

    self:dispatchEvent({name = Player.ON_RESET_PLAYER})
    self.isCheckOut_ = false
    local isReConnect = false
    -- if event.args then
    --     isReConnect = event.args[1]
    -- end
    if isReConnect then  -- 重连时不再扣台费
        return
    end
    self.isLocked_ = false
    -- self:showRoundOverPoker(nil)
    -- self:setDealer(-1)
    self.cards_ = {}
end

function Player:forceStandUp()
    self.fsm__:doEventForce("standup")
end

function Player:sitDown()
    self:tryDoEvent_("sitdown")
end

function Player:doReady(isReady)
    self:setIsReady(isReady)
    if isReady then
        self:tryDoEvent_("ready")
    else
        self:tryDoEvent_("unready")
    end
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
    print("seatID:"..self.seatID_.."changeState:"..event.from.." tostate:"..event.to)
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

function Player:getShowParams()
    local params = {
        uid = self.uid_,
        nickName = self.nickName_,
        IP = self.IP_,
        avatar = self:getAvatarName(),
        sex = self.sex_,
        roundCount = self.roundCount_,
        loginTime = self.loginTime_,
        seatID = self.seatID_
    }
    return params
end

-- 当批量设置玩家参数时，基类默认的setProperties不会引发相应的值的改变事件，也就无法自动更新
-- 这里引入一个setMulti的方法，只要是系统有 setXXX相关的方法，注意XXX第一个字母大写，则先调用
-- 自身的方法，这样来发出事件
function Player:setMulti(params)
    local params = toClientProperties(params) 
    local fuTb = {}
    for k,v in pairs(params) do
        local funcName = "set" .. string.ucfirst(k)
        if self[funcName] and type(self[funcName]) == "function" then
            -- self[funcName](self, v)
            table.insert(fuTb, {self[funcName], v})
        end
    end
    if #fuTb > 0 then
        local offlineIndex = 0
        for i=1, #fuTb do
            if fuTb[i][1] == self.setOffline then
                offlineIndex = i
            else
                fuTb[i][1](self, fuTb[i][2])
            end
        end

        -- if offlineIndex > 0 then
        --     self:setOffline(fuTb[offlineIndex][2], self:getIP())
        -- end
    end
    Player.super.setProperties(self, params)
end

function Player:setSeatID(seatID)
    self.seatID_ = seatID
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
    self.score_ = score
    self:dispatchEvent({name = Player.SCORE_CHANGED, score = score, from = rawScore})
end

-- 设置外牌
function Player:setWaiPai(cards)
    self.waiPai_ = clone(cards) or {}
    self:dispatchEvent({name = Player.WAI_PAI_CHANGED, data = self.waiPai_})
end

function Player:canChiHu(card, allowSevenPairs)
    -- if self.louHu_ and table.indexof(self.louHu_, card) ~= false then  -- 漏胡不准胡
    -- if self.louHu_ and table.nums(self.louHu_) > 0 then
    if self.louHu_ and self.louHu_ > 0 then
        return false
    end
    return ZZAlgorithm.canChiHu(self:getCards(), card, allowSevenPairs)
end

function Player:canZiMoHu(allowSevenPairs)
    return ZZAlgorithm.canZiMoHu(self:getCards(), allowSevenPairs, self:getIsFirstHand())
end

function Player:getIsFirstHand()
    return self.isFirstHand_ and #self.chuPai_ == 0 and #self.waiPai_ == 0
end

-- 计算自己可以的暗杠列表
function Player:calcAnGang()
    local cards = self:getCards()  -- 克隆返回
    local testCards = clone(cards)
    local cards = table.unique(cards)
    local result = {}
    for _,v in pairs(cards) do
        if v ~= BaseAlgorithm.NAI_ZI and 4 == table.removebyvalue(testCards, v, true) then
            table.insert(result, {action = MJ_ACTIONS.AN_GANG, cards = {v, v, v, v}})
        end
    end
    return result
end

function Player:calcBuGang()
    local list = self:getWaiPai()  -- 克隆返回
    local result = {}
    for _,v in ipairs(list) do
        if MJ_ACTIONS.PENG == v.action and v.cards[1] == self.lastCard_ then
            local cards = {self.lastCard_, self.lastCard_, self.lastCard_, self.lastCard_}
            table.insert(result, {action = MJ_ACTIONS.BU_GANG, cards = cards, highLight = 1})
        end
    end
    return result
end

function Player:canChiGang(publicCard)
    if publicCard == BaseAlgorithm.NAI_ZI then  -- 懒子不能杠
        return false
    end
    local cards = self:getCards()  -- 克隆返回
    if 3 == table.removebyvalue(cards, publicCard, true) then
        return true
    end
    return false
end

function Player:canPeng(publicCard)
    print("canPeng(publicCard)", publicCard)

    if publicCard == BaseAlgorithm.NAI_ZI then  -- 懒子不能碰
        return false
    end
    local cards = self:getCards()  -- 克隆返回
    dump(cards)
    if 2 <= table.removebyvalue(cards, publicCard, true) then
        return true
    end
    return false
end

function Player:canAnGang()
    local cards = self:getCards()  -- 克隆返回
    local testCards = clone(cards)
    local cards = table.unique(cards)
    for _,v in pairs(cards) do
        local count = table.removebyvalue(testCards, v, true)
        if v ~= BaseAlgorithm.NAI_ZI and 4 == count then
            return true
        end
    end
    return false
end

function Player:canBuGang()
    local list = self:getWaiPai()  -- 克隆返回
    for _,v in ipairs(list) do
        if MJ_ACTIONS.PENG == v.action and v.cards[1] == self.lastCard_ then
            return true
        end
    end
    return false
end

-- 添加外牌
function Player:addWaiPai(data)
    assert(data)
    local data = clone(data)
    table.insert(self.waiPai_, data)
    self:dispatchEvent({name = Player.WAI_PAI_ADDED, data = data, index = #self.waiPai_})


    if not inFastMode then
        -- local action =  data.action
        -- local soundName = nil
        -- if MJ_ACTIONS.PENG == action then
        --     soundName = "peng" .. math.random(5)
        -- elseif MJ_ACTIONS.CHI == action then
        --     soundName = "chi" .. math.random(3)
        -- elseif MJ_ACTIONS.ZI_MO == action then
        --     soundName = "zimo" .. math.random(2)
        -- elseif MJ_ACTIONS.CHI_HU == action or action == MJ_ACTIONS.QIANG_GANG_HU then
        --     soundName = "dianpao" .. math.random(3)
        --     if action == MJ_ACTIONS.QIANG_GANG_HU then
        --         soundName = "dianpao" .. 3
        --     end
        -- elseif MJ_ACTIONS.AN_GANG == action or MJ_ACTIONS.CHI_GANG == action or MJ_ACTIONS.BU_GANG == action then
        --     if MJ_ACTIONS.CHI_GANG == action then
        --         soundName = "gang" .. 2
        --     else
        --         soundName = "gang" .. 1
        --     end
        -- end

        -- if soundName then
        --     gameAudio.playHumanSound("mj" .. soundName .. ".mp3", self.sex_)  
        -- end
    end
end

-- 设置出牌
function Player:setChuPai(cards,onlyShowCards)
    self.chuPai_ = cards or {}
    self:dispatchEvent({name = Player.CHU_PAI_CHANGED, cards = cards, onlyShowCards = onlyShowCards})
end

-- 添加出牌
function Player:addChuPai(card, dennyAnim)
    assert(card and card > 0)
    table.insert(self.chuPai_, card)
    self:dispatchEvent({name = Player.CHU_PAI_ADDED, card = card, dennyAnim = dennyAnim})
    self:removeCardFromHand_(card)
end

-- CSMJ添加杠牌
function Player:addGangPai(cards)

end

function Player:removeCardFromHand_(card)
    if 0 >= table.removebyvalue(self.cards_, card, false) then
        table.removebyvalue(self.cards_, 0, false)
    end

    self:dispatchEvent({name = Player.HAND_CARD_REMOVED, card = card})
    self:checkTingPai()
end

function Player:removeCardFromChuPai_(card)
    for i = #self.chuPai_, 1, -1 do
        if card == self.chuPai_[i] then
            table.remove(self.chuPai_, i)
            break
        end
    end
    self:setChuPai(self.chuPai_)
end

function Player:addMaJiang(card, isDown)
    self:setLastCard(card)
    table.insert(self.cards_, card)
    local event = {
        name = Player.MA_JIANG_FOUND,
        isDown = isDown,
        card = card,
    }
    self:dispatchEvent(event)
    self:checkTingPai()
end

function Player:onMoPai(card, isDown, handCards)
    print("Player:onMoPai")
    if self.isTanPai_ then
        self:resumeTanPai()
    end
    self:showCards(handCards, isDown)
    self:addMaJiang(card, isDown)
end

function Player:safeRemoveCards()
    if self:isPlaying() and not (self:getState() == 'in_winning' or self:getState() == 'in_losing') then
        return
    end
    self:removeCards()
end

function Player:setCards_(cards)
    self.cards_ = cards
end

function Player:setLastCard(card)
    self.lastCard_ = card
end

function Player:removeCards()
    self:doCardsEvent_(Player.HAND_CARDS_CHANGED, nil)
    self:checkTingPai()
end

function Player:showCards(cards, isDown, action, num)
    local card = nil
    num = checknumber(num)
    if cards then
        local allNum = #cards + num
        if num == 0 then
            self.waiPai_ = self.waiPai_ or {}
            allNum = allNum + #self.waiPai_ * 3
        end

        if allNum == 14 then
            card = cards[#cards]
            table.remove(cards, #cards)
        end
    end
    self:doCardsEvent_(Player.HAND_CARDS_CHANGED, cards, isDown, action)
    self:checkTingPai()
    if card then
        self:addMaJiang(card, isDown)
    end
end

function Player:doCardsEvent_(eventName, cards, isDown, action)
    self:setCards_(checktable(cards))
    local card
    if action == MJ_ACTIONS.CHI_HU then
        card = display.getRunningScene():getTable():getLastCard()
    end
    self:dispatchEvent({name = eventName, cards = cards, isDown = isDown, action = action, huPai = card})
end

function Player:setReconnectFocusOn()
    self:dispatchEvent({name = Player.ON_RECONNECT_FOCUSON})
end

function Player:setHuPai(data)
    if not inFastMode then
        local soundName = "hu" .. math.random(2)
        if data.isZiMo then
            local soundName = "zimo" .. math.random(2)
        elseif data.isQiangGangHu > 0 then
            soundName = "dianpao3"
        else
            soundName = "dianpao" .. math.random(3)
        end
        -- gameAudio.playHumanSound(soundName .. ".mp3", self.sex_)
    end
end

function Player:playRecordVoice(time)
    self:dispatchEvent({name = Player.ON_PLAY_RECORD_VOICE, time = time})
end

function Player:stopRecordVoice()
    self:dispatchEvent({name = Player.ON_STOP_RECORD_VOICE})
end

function Player:playVoice(url)
    local event = {name = BasePlayer.PLAY_VOICE, url = url}
    self:dispatchEvent(event)
end

function Player:stopZhuanQuanAction()
    self:dispatchEvent({name = Player.ON_STOP_ZHUANQUAN})
end

function Player:zhuanQuanAction()
    self:dispatchEvent({name = Player.ON_ZHUANQUAN})
end

function Player:setUid(uid)
    self.uid_ = uid
end

function Player:getUid()
    return self.uid_ or 0
end

function Player:onGameTG_(isLock)
    self.isLocked_ = isLock
    self:dispatchEvent({name = Player.GAME_TG, isLock = isLock})
end

function Player:isLocked()
    return self.isLocked_
end

function Player:checkTingPaiByRemoveCard(card)
    local temp = clone(self.cards_)
    if type(card) == "number" then
        table.insert(temp,card)
    elseif type(card) == "table" then
        table.insert(temp,card[1])
    end
    local cardNum = {}
    local canGangValue = {}
    for i = 1,#temp do
        local cardValue = temp[i] 
        if cardNum[cardValue] then
            cardNum[cardValue] = cardNum[cardValue] + 1
            if cardNum[cardValue] == 4 then
                table.insert(canGangValue,cardValue)
            end
        else
            cardNum[cardValue] = 1
        end
    end
    local result = {}
    for i = 1,#temp do
        if table.indexof(canGangValue,temp[i]) == false then
            table.insert(result,temp[i])
        end
    end
    return ZZAlgorithm.isTingPai(result,display.getRunningScene():getTable():getAllowSevenPairs())
end

function Player:autoOutCard_()
    self:dispatchEvent({name = Player.AUTO_OUT_CARD})
end

return Player
