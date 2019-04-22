local BaseAlgorithm = require("app.games.ldfpf.utils.BaseAlgorithm")
local PaoHuZiAlgorithm = require("app.games.ldfpf.utils.PaoHuZiAlgorithm")
local Player = class("Player", gailun.JWModelBase)

-- 定义事件
Player.CHANGE_STATE_EVENT = "CHANGE_STATE_EVENT"
Player.POKER_FOUND = "POKER_FOUND"
Player.HAND_CARDS_CHANGED = "HAND_CARDS_CHANGED"
Player.DEAL_CARDS = "DEAL_CARDS"
Player.HAND_CARDS_CHUPAI = "HAND_CARDS_CHUPAI"
Player.SHOW_TMP_MOPAI = "SHOW_TMP_MOPAI" -- 临时摸牌
Player.SHOU_ZHANG = "SHOU_ZHANG"  -- 收张
Player.RESUME_ZHUO_CARDS = "RESUME_ZHUO_CARDS" -- 桌牌改变事件
Player.RESUME_CHU_PAI = "RESUME_CHU_PAI"  -- 出牌改变事件
Player.ROUND_START_CLEAR = "ROUND_START_CLEAR"  --一局开始清理
Player.HAND_CARDS_REMOVED = "HAND_CARDS_REMOVED"  -- 手牌减少事件
-- Player.HAND_CARD_SORT = "HAND_CARD_SORT"  -- 手牌排序事件HAND_CARD_SORT
Player.WAI_PAI_CHANGED = "WAI_PAI_CHANGED"  -- 外牌改变事件
Player.WAI_PAI_ADDED = "WAI_PAI_ADDED"  -- 外牌增加事件 
Player.CHI_CHANGED = "CHI_CHANGED"  -- 吃改变事件
Player.CHU_PAI_ADDED = "CHU_PAI_ADDED"  -- 出牌增加事件
Player.INDEX_CHANGED = "INDEX_CHANGED"  -- 位置有变事件
Player.SIT_DOWN_EVENT = "SIT_DOWN_EVENT"  -- 坐下事件
Player.STAND_UP_EVENT = "STAND_UP_EVENT"  -- 站起事件
Player.SCORE_CHANGED = "SCORE_CHANGED"  -- 当前积分改变事件
Player.TOTALSCORE_CHANGED = "TOTALSCORE_CHANGED" --总积分改变事件
Player.GOLD_CHANGED = "GOLD_CHANGED"  -- 金币改变事件
Player.DIAMOND_CHANGED = "DIAMOND_CHANGED"  -- 钻石改变事件
Player.ON_AVATAR_CLICKED = "ON_AVATAR_CLICKED"  -- 头像点击事件
Player.SHOW_READY = "SHOW_READY"
Player.ON_CHUPAI_EVENT = "ON_CHUPAI_EVENT"  -- 抛出出牌事件
Player.CHU_PAI_CHANGED = "CHU_PAI_CHANGED"  -- 出牌改变事件

Player.ON_CHI_EVENT = "ON_CHI_EVENT"  -- 抛出吃事件
Player.CHI_CHANGE_EVENT = "CHI_CHANGE_EVENT"  -- 吃牌增加事件

Player.ON_PENG_EVENT = "ON_PENG_EVENT"  -- 抛出碰事件
Player.PENG_CHANGE_EVENT = "PENG_CHANGE_EVENT"  -- 碰牌增加事件

Player.ON_HU_EVENT = "ON_HU_EVENT"  -- 抛出胡事件
Player.HU_CHANGE_EVENT = "HU_CHANGE_EVENT"  -- 胡牌增加事件
 
Player.PAO_CHANGE_EVENT = "PAO_CHANGE_EVENT"  -- 跑牌改变事件

Player.ON_GUO_EVENT = "ON_GUO_EVENT"  -- 抛出过事件
Player.ALL_PASS_CHANGE = "ALL_PASS_CHANGE"  -- 抛出过事件

Player.WEI_CHANGE_EVENT = "WEI_CHANGE_EVENT"  -- 偎牌增加事件
Player.TI_CHANGE_EVENT = "TI_CHANGE_EVENT"  -- 提牌增加事件
Player.FIRST_TI_CHANGE_EVENT = "FIRST_TI_CHANGE_EVENT"  -- 起手提牌增加事件

Player.ON_SHOWHIGHTLIGHT_EVENT = "ON_SHOWHIGHTLIGHT_EVENT"  -- 抛出高亮牌事件

Player.ON_FLOW_EVENT = "ON_FLOW_EVENT"  --显示王
Player.ON_ROUND_OVER = "ON_ROUND_OVER"  --一局游戏结束
Player.ON_SETDEAR_EVENT = "ON_SETDEAR_EVENT"
Player.ON_QIPAI_EVENT = "ON_QIPAI_EVENT" --显示弃牌
Player.ON_DANIAO_EVENT = "ON_DANIAO_EVENT" --显示打鸟
Player.ON_ROUND_OVER_SHOW_POKER = "ON_ROUND_OVER_SHOW_POKER" 
Player.ON_STOP_RECORD_VOICE = "ON_STOP_RECORD_VOICE" 
Player.ON_PLAY_RECORD_VOICE = "ON_PLAY_RECORD_VOICE"
Player.OFFLINE_EVENT = "OFFLINE_EVENT"
Player.PASS_EVENT = "PASS_EVENT"
Player.TURN_TO_OUT = "TURN_TO_OUT"

Player.TI_PAI = "TI_PAI"

-- 定义属性
Player.schema = clone(cc.mvc.ModelBase.schema)
Player.schema["uid"] = {"number", 0} -- ID，默认0
Player.schema["userName"] = {"string"} -- 字符串类型，没有默认值
Player.schema["nickName"] = {"string", ""} -- 字符串类型，没有默认值
Player.schema["avatar"] = {"string", ""} -- 头像地址
Player.schema["gold"]    = {"number", 0} -- 数值类型，默认值 0
Player.schema["diamond"]    = {"number", 0} -- 钻石，默认值 0
Player.schema["score"]       = {"number", 0}  -- 当前得分分数
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
Player.schema['lockGold'] = {"number", 0} -- 金币

Player.schema['chuPai'] = {"table", {}} -- 玩家的出牌

Player.schema['isReady'] = {"boolean", false} -- 是否已举手

Player.schema['isOffline'] = {'boolean', false}  -- 是否已离线

Player.schema['loginTime'] = {'number', 0}  -- 漏胡列表
Player.schema['roundCount'] = {'number', 0}  -- 漏胡列表
Player.schema['address'] = {'string', ""}  -- 地址
-- 将服务器发的信息压扁一下，以方便设置属性
local function toClientProperties(properties)
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
round_start     局开始 
tianhu         天胡

起手提
turn_to_out     被轮到出牌
otherout 发现有人出牌
mo_pai_guo        摸牌弃牌
da_pai_guo           操作打牌
peng            碰牌
chi             吃牌
pao             跑牌
wei             偎牌
ti              提牌
hu              胡牌 
round_over      局结束

玩家状态列表
none            无状态
idle            空闲中(未坐下)
waiting         等待中
ready           准备中(未开局)
wait_call       等待被呼叫 
chu_pai_thinking  出牌操作思考中
thinking        吃碰过胡操作思考中 
checkout        结算中
qi              放弃本局
{name = "", from = {""}, to = ""},
]]
--状态必须变化  可以多对一 不能一到多
function Player:setStates_()
    local defaultEvents = {
        {name = "start", from = "none", to = "idle"}, -- 初始化后，玩家处于空闲状态
        {name = "reconnect", from = {"waiting", "ready", "checkout"}, to = "wait_call"},
        {name = "round_start", from = {"waiting", "ready", "checkout"}, to = "wait_call"},
        {name = "sitdown", from = {"idle"}, to = "waiting"},
        {name = "ready", from = {"waiting", "checkout"}, to = "ready"},
        {name = "unready", from = {"ready"}, to = "waiting"},
        {name = "standup", from = {"waiting", "ready"}, to = "idle"},
  
        {name = "tianhustart", from = {"wait_call"}, to = "tianhuthinking"},
        {name = "tianhuend", from = {"tianhuthinking"}, to = "wait_call"},--收张
        {name = "turntoout", from = {"wait_call"}, to = "chu_pai_thinking"},
        {name = "chu", from = {"chu_pai_thinking"}, to = "wait_call"},  
        {name = "qi", from = {"chu_pai_thinking","thinking"}, to = "waiting"},
        --发现有人出牌
        {name = "otherout", from = {"wait_call"}, to = "thinking"},
        {name = "mopai", from = {"wait_call"}, to = "thinking"}, 
        {name = "chi", from = {"thinking"}, to = "wait_call"},
        {name = "otherchi", from = {"thinking"}, to = "wait_call"},
        {name = "peng", from = {"thinking"}, to = "wait_call"},
        {name = "otherpeng", from = {"thinking"}, to = "wait_call"},
        {name = "otherpao", from = {"thinking"}, to = "wait_call"},
        {name = "otherwei", from = {"thinking"}, to = "wait_call"},
        {name = "otherti", from = {"thinking"}, to = "wait_call"},
        {name = "guo", from = {"thinking", "tianhuthinking"}, to = "wait_call"},
        -- {name = "hu", from = {"tianhuthinking","thinking"}, to = "wait_call"},
        {name = "notifyhu", from = {"wait_call"}, to = "thinking"},
        {name = "otherhu", from = {"thinking","tianhuthinking"}, to = "wait_call"},
        {name = "round_over", from = {"tianhuthinking", "thinking", "wait_call","checkout"}, to = "checkout"}, 
    }

    -- 设定状态机的默认回调
    local defaultCallbacks = {
        onchangestate = handler(self, self.onChangeState_),
        onround_start = handler(self, self.onRoundStart_),
        onround_over = handler(self, self.onRoundOver_),
        onstandup = handler(self, self.onStandUp_),
        onbeforestandup = handler(self, self.onBeforeStandUp_),
        onsitdown = handler(self, self.onSitDown_),

        onchu = handler(self, self.onChuPai_),
        onotherout = handler(self, self.onFindChuPai_),
        onotherchi = handler(self,self.doFindChiPai),
        onchi = handler(self,self.onChiPaiExcecute_),
        onotherpeng = handler(self,self.doOtherPengPaiFinish),
        onpeng = handler(self,self.onPengPaiExcecute_),
        onguo = handler(self,self.setPass_),
        onhu = handler(self,self.setHuPai),
        onturntoout = handler(self,self.turnToOut),
        onqi = handler(self,self.onQIPai),
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

function Player:isReady()
    return self.isReady_
end

function Player:getIsReady()
    return self.isReady_
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

function Player:isOutCarding()
    return  self.fsm__:getState() == "chu_pai_thinking"
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

function Player:getClubScore()
    if self.clubScore_ then
        return self.clubScore_
    else
        return 0
    end
end

function Player:setClubScore(Score)
    if Score == nil then
        self.clubScore_ = 0
    else
        self.clubScore_ = Score
    end
end

function Player:shouzhang(card, isReview)
    table.insert(self.cards_,card)
    self:dispatchEvent({name = Player.SHOU_ZHANG, card = card, isReview = isReview})
end

function Player:setOffline(offline, ip, lastOfflineTime)
    self.IP_ = ip
    local rawOffline = self.isOffline_
    self.isOffline_ = offline
    self:dispatchEvent({name = Player.OFFLINE_EVENT, offline = offline, IP = ip, lastOfflineTime = lastOfflineTime, isChanged = rawOffline ~= offline})
end


function Player:setOldIP(ip)
    if self.IP_ == nil or self.IP_ == '' then
        self.IP_ = ip
    end
end

function Player:getNickName()
    return gailun.utf8.formatNickName(self.nickName_, 10, '..')
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

function Player:standup()
    self:tryDoEvent_("standup")
end

function Player:turnToOut(seconds)
    self:dispatchEvent({name = Player.TURN_TO_OUT})
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

-- function Player:doCheckOut(score)
--     self:checkOutData(score)
--     local eventName = "round_over"
--     if self.fsm__:canDoEvent(eventName) then
--         self.fsm__:doEvent(eventName)
--     end
-- end

function Player:onRoundStart_(event)
    self:removeAllCards_()
    self.isCheckOut_ = false
    local isReConnect = false
    if event.args then
        isReConnect = event.args[1]
    end
    if isReConnect then  -- 重连时不再扣台费
        return
    end

    self:setDealer(-1) 
    self:stopRecordVoice()
    self:showRoundOverPoker(nil)
    self.cards_ = {}
end

function Player:gameOver()
    self:removeAllCards_()
    self.isCheckOut_ = false
    local isReConnect = false
    -- if event.args then
    --     isReConnect = event.args[1]
    -- end
    if isReConnect then  -- 重连时不再扣台费
        return
    end
    self:showRoundOverPoker(nil)
    self:setDealer(-1)
    self:stopRecordVoice()
    self.cards_ = {}
end

function Player:resetPlayer()
    self:removeAllCards_()
    self.isCheckOut_ = false
    local isReConnect = false
    -- if event.args then
    --     isReConnect = event.args[1]
    -- end
    if isReConnect then  -- 重连时不再扣台费
        return
    end
    self:showRoundOverPoker(nil)
    self:setDealer(-1)
    self:stopRecordVoice()
    self.cards_ = {}
end

function Player:removeAllCards_()
    self:dispatchEvent({name = Player.ROUND_START_CLEAR, cards = nil})
end

function Player:onRoundOver_(event)
    -- self:removeAllCards_()
end

function Player:doRoundOver(event)
    self:tryDoEvent_('round_over')
end

function Player:onSitDown_(event)
    self:dispatchEvent({name = Player.SIT_DOWN_EVENT, seatID = self.seatID_})
end

function Player:onStandUp_(event)
    self:setSeatID(0)
    self:tryDoEvent_("standup")
    -- self:dispatchEvent({name = Player.STAND_UP_EVENT})
    gameAudio.playSound("standup.mp3")
end

function Player:onBeforeStandUp_(event)
    if not self:isPlaying() then
        self:setScore(0)
    end
end

function Player:forceStandUp()
    self.fsm__:doEventForce("standup")
    -- self:tryDoEvent_("standup")
end

function Player:sitDown()
    self:tryDoEvent_("sitdown")
    -- self:dispatchEvent({name = Player.SIT_DOWN_EVENT, seatID = self.seatID_})
end

function Player:showReady_(isReady)
    self:dispatchEvent({name = Player.SHOW_READY, isReady = isReady})
end

function Player:doReady(isReady)
    self:setIsReady(isReady)
    if isReady then
        self:tryDoEvent_("ready")
    else
        self:tryDoEvent_("unready")
    end
end

function Player:doChuPai(card,inFastModem, isReview)
    if isReview then
        self.fsm__:doEventForce("chu", card, inFastMode)
    else
        self:tryDoEvent_("chu", card,inFastMode)
    end
end

function Player:doTianHuStart(card)
    self:tryDoEvent_("tianhustart", card)
    gameAudio.playCDPHZHumanSound(card..".mp3", self.sex_)
end

function Player:doTianHuEnd(card)
    self:tryDoEvent_("tianhuend", card)
end

function Player:doFindChuPai(card)
    self:tryDoEvent_("otherout", card)
end

function Player:doEventForce(eventName, ...)
    return self.fsm__:doEventForce(eventName, ...)
end

-- 轮到玩家
function Player:doFindPao()
    self:tryDoEvent_("otherpao")
end

function Player:doFindWei()
    self:tryDoEvent_("otherwei")
end

function Player:doFindTi()
    self:tryDoEvent_("otherti")
end

function Player:doNotifyHu_()
    self:tryDoEvent_("notifyhu")
end

-- 轮到玩家
function Player:doTurnto()
    self:tryDoEvent_("turntoout")
end

function Player:doQiPai()
    self:tryDoEvent_("qi")
end

-- 轮到玩家
function Player:doMoPai(card,seatID,inFastMode)
    self:tryDoEvent_("mopai")
    if self.seatID_ == seatID and (not inFastMode) then  
        gameAudio.playCDPHZHumanSound(card..".mp3", self.sex_)
    end
end

function Player:pass(inFastMode)
    self:tryDoEvent_("guo")
end

function Player:tryDoEvent_(eventName, ...)
    print("==========self.fsm__:canDoEvent(eventName)============",self.fsm__:canDoEvent(eventName))
    print("==========self.fsm__:getState============",self.fsm__:getState())
    if self.fsm__:canDoEvent(eventName) then
        return self.fsm__:doEvent(eventName, ...)
    end
end

-- 设置出牌
function Player:doFindChiPai(event)
    -- local chiPai = event.args[1]
    -- local biPai = event.args[2]
    -- local card = event.args[3]
end

function Player:doChiPai(data)
    self:tryDoEvent_("chi",data)
end

function Player:doOtherChiPai(chiPai, biPai,card)
    self:tryDoEvent_("otherchi",chiPai, biPai,card)
end


function Player:onChangeState_(event)
    -- printInfo("===========Player:onChangeState"..self.seatID_.. event.from.." to:"..event.to)
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

function Player:getShowParams()
    local params = {
        uid = self.uid_,
        nickName = self.nickName_,
        IP = self.IP_,
        avatar = self:getAvatarName(),
        sex = self.sex_,
        roundCount = self.roundCount_,
        loginTime = self.loginTime_,
        seatID = self.seatID_,
        address = self.address_
    }
    return params
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

function Player:setScore(score,isLdfpf)
    local rawScore = self.score_
    local lockGold = isLdfpf == true and 0 or self.lockGold_
    self.score_ = self.score_ + score
    self:dispatchEvent({name = Player.SCORE_CHANGED, score = score + lockGold, from = rawScore + lockGold})
end

function Player:setTotalScore(totalScore)
    self.totalScore_ = totalScore
    local lockGold = self.lockGold_
    self:dispatchEvent({name = Player.TOTALSCORE_CHANGED, score = totalScore + lockGold, from = rawScore + lockGold})
end

function Player:getScore()
    return self.score_ + self.lockGold_
end

function Player:getTotalScore()
    return self.totalScore_ + self.lockGold_
end

-- 设置出牌
function Player:setPaoPai(card, index,isReConnect, inFastMode)
    self:addZhuoMianPaoPai(card)
    if not inFastMode then    
        gameAudio.playCDPHZHumanSound("pao.mp3", self.sex_)
        self:removeCardsFromHand_({card,card,card,card})-- 3张是起手偎，如果手牌没有了就只删两张
    end

    self:dispatchEvent({name = Player.PAO_CHANGE_EVENT, card = card, index = index, isReConnect = isReConnect, inFastMode = inFastMode})
end


function Player:doPengPai(card,inFastMode)
    self:tryDoEvent_("peng",card,inFastMode)
end

function Player:doOtherPengPai(card)
    self:tryDoEvent_("otherpeng",card)
end

-- 发现碰牌
function Player:doOtherPengPaiFinish(event)
end

-- 设置出牌
function Player:onPengPaiExcecute_(event)
    local card = event.args[1]
    local inFastMode = event.args[2]
    if not inFastMode then
        gameAudio.playCDPHZHumanSound("peng.mp3", self.sex_)
    end
    self:removeCardsFromHand_({card,card})-- 3张是起手偎，如果手牌没有了就只删两张
    self:addZhuoMianPai({card,card,card},nil,CTYPE_PENG)
    self:dispatchEvent({name = Player.PENG_CHANGE_EVENT, card = card, isReConnect = isReConnect, inFastMode = inFastMode})
end

function Player:doAllPass(card,index,inFastMode)
    self:addChuPai(card)
    self:dispatchEvent({name = Player.ALL_PASS_CHANGE, card = card,index = index, isReConnect = isReConnect, inFastMode = inFastMode})
end

-- 设置出牌
function Player:onChiPaiExcecute_(event)
    local data = event.args[1]
    local chiPai = data.chiPai
    local biPai = data.biPai
    local card = data.card
    local inFastMode = data.inFastMode
    if not inFastMode then
        gameAudio.playCDPHZHumanSound("chi.mp3", self.sex_)  
        --将吃牌放第一张
        table.removebyvalue(chiPai, card)

        --删除手牌    --加桌面牌
        self:removeCardsFromHand_(chiPai)
        table.insert(chiPai,1,card)
        self:addZhuoMianPai(chiPai)
        for _,v in ipairs(biPai) do
            self:removeCardsFromHand_(v)
            self:addZhuoMianPai(v)
        end    
    end
    dump(chiPai)
    dump(card)
    self:dispatchEvent({name = Player.CHI_CHANGE_EVENT, chiPai = chiPai, biPai = biPai, card = card, isReConnect = data.isReConnect, inFastMode = data.inFastMode})
end

-- 设置出牌
function Player:setWeiPai(isChou, card,isReConnect, inFastMode)
    --臭偎没有
    if not inFastMode then
        gameAudio.playCDPHZHumanSound("wei.mp3", self.sex_)    
        self:removeCardsFromHand_({card,card,card})-- 3张是起手偎，如果手牌没有了就只删两张
        self:addZhuoMianPai({card,card,card},nil,CTYPE_WEI)
    end

    self:dispatchEvent({name = Player.WEI_CHANGE_EVENT, card = card, isChou = isChou, isReConnect = isReConnect, inFastMode = inFastMode})
end

function Player:doWeiPai()
    -- self:tryDoEvent_("pao")
end

-- 设置提牌
function Player:setTiPai(card, index,isReConnect, inFastMode)
     if not inFastMode then
        gameAudio.playCDPHZHumanSound("ti.mp3", self.sex_)
        self:addZhuoMianPaoPai(card, nil, true)
        self:removeCardsFromHand_({card,card,card,card})-- 3张是起手偎，如果手牌没有了就只删两张
    end
    self:dispatchEvent({name = Player.TI_CHANGE_EVENT, card = card, index = index, isReConnect = isReConnect, inFastMode = inFastMode})
end

-- 设置提牌
function Player:setFirstHandTiPai(cards)
    gameAudio.playCDPHZHumanSound("ti.mp3", self.sex_)
    for _,card in pairs(cards) do
        self:addZhuoMianPaoPai(card, nil, true)
        self:removeCardsFromHand_({card,card,card,card})-- 3张是起手偎，如果手牌没有了就只删两张
    end
    self:dispatchEvent({name = Player.FIRST_TI_CHANGE_EVENT, cards = cards, index = index, isReConnect = isReConnect, inFastMode = inFastMode})
end

-- 设置出牌
function Player:setPass_(isReConnect, inFastMode)
    self:dispatchEvent({name = Player.PASS_EVENT, inFastMode = inFastMode})
end

-- 设置出牌
function Player:setHuPai(typeid)
    if not inFastMode then
        gameAudio.playCDPHZHumanSound("hu.mp3", self.sex_)
    end
    self:dispatchEvent({name = Player.HU_CHANGE_EVENT, typeid = typeid, inFastMode = inFastMode})
end

function Player:doHuPai()
    self:tryDoEvent_("hu")
end

function Player:doOtherHuPai()
    self:tryDoEvent_("otherhu")
end

-- 设置吃
function Player:setChi(cards, isReConnect, inFastMode)
    self:removeCardsFromHand_(cards)
    self:dispatchEvent({name = Player.CHI_CHANGED_EVENT, cards = cards, isReConnect = isReConnect, inFastMode = inFastMode})
end

-- 添加桌面牌
function Player:addZhuoMianPai(cards, dennyAnim, type)
    assert(cards)
    cards = clone(cards)
    if not self.zhuoMiancards_ then
        self.zhuoMiancards_ = {}
    end
    if not type then
        if PaoHuZiAlgorithm.calcHuXiWei(cards) > 0 then
            type = CTYPE_WEI
        elseif PaoHuZiAlgorithm.calcHuXiPeng(cards) > 0 then
            type = CTYPE_PENG
        elseif PaoHuZiAlgorithm.calcHuXi2710(cards) > 0 then
            type = CTYPE_2710
        elseif BaseAlgorithm.isShun(cards) then
            type = CTYPE_SHUN
        elseif BaseAlgorithm.isDaXiaoDa(cards) then
            type = CTYPE_DA_XIAO_DA
        end
    end
    if type == nil then
        dump(cards)
        assert(type)
    end

    table.insert(cards, 1, type)
    table.insert(self.zhuoMiancards_,cards)
end

function Player:isHostPlayer()
    return self.uid_ == selfData:getUid()
end

function Player:setHostPlayer()
    self.isHost = true
end

-- 添加桌面牌
function Player:addZhuoMianPaoPai(card, index, isTi)
    assert(card)
    if not self.zhuoMiancards_ then
        self.zhuoMiancards_ = {}
    end
    local action = isTi and CTYPE_TI or CTYPE_PAO
    for k,v1 in ipairs(self.zhuoMiancards_) do
        for i,v in ipairs(v1) do
            if v == card then
                v1[1] = action
                table.insert(v1,card)
                return 
            end
        end
    end
    table.insert(self.zhuoMiancards_,{action, card,card,card,card})
end

-- 添加出牌
function Player:addChuPai(card, dennyAnim)
    assert(card and card > 0)
    table.insert(self.chuPai_, card)
end

function Player:removeCardsFromHand_(cards)
    if not self.cards_ then
        print("not host removeCardsFromHand_(cards)")
        return
    end
    if cards == nil then return end
    for i = 1, #cards do
        table.removebyvalue(self.cards_, cards[i])
    end
end

function Player:addPoker(card)
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

function Player:showMoPai(card, needFlip)
    self:dispatchEvent({name = Player.SHOW_TMP_MOPAI, card = card})
end

function Player:setCards(cards, isRconnect)
    self.cards_ = clone(cards)
    self:showCards(isRconnect)
end

function Player:setZhuoCards(cards)
    self.zhuoMiancards_ = clone(cards)
    self:dispatchEvent({name = Player.RESUME_ZHUO_CARDS, cards = cards})
end

function Player:setChuCards(cards)
    self.chuPai_ = clone(cards)
    self:dispatchEvent({name = Player.RESUME_CHU_PAI, cards = cards})
end

function Player:getChuCards()
    return clone(self.chuPai_)
end

function Player:clearAllCard()
    self.zhuoMiancards_ = {}
    self.chuPai_ = {}
    self.cards_ = {}
end

function Player:getZhuoCards()
    local temp = clone(self.zhuoMiancards_)
    return temp
end

function Player:getMyHandCards()
    return clone(self.cards_)
end

function Player:dealCards(cards)    
    self.cards_ = clone(cards)
    self:dispatchEvent({name = Player.DEAL_CARDS, cards = cards})
end

function Player:reCards()   
    local cards = clone(self.cards_) 
    self:dispatchEvent({name = Player.DEAL_CARDS, cards = cards})
end

function Player:removeCards()
    self:dispatchEvent({name = Player.HAND_CARDS_CHANGED, cards = nil})
end

function Player:showCards(isRconnect)
    local cards = clone(self.cards_)
    self:dispatchEvent({name = Player.HAND_CARDS_CHANGED, cards = cards, isRconnect = isRconnect})
end


function Player:chupai(card)
    self:dispatchEvent({name = Player.ON_CHUPAI_EVENT, card = card})
end

function Player:peng(inFastMode)
    self:dispatchEvent({name = Player.ON_PENG_EVENT})
  
end

function Player:hu(inFastMode)
    self:dispatchEvent({name = Player.ON_HU_EVENT})
end 

function Player:showHightLight(card,isHigh) 
    self:dispatchEvent({name = Player.ON_SHOWHIGHTLIGHT_EVENT,card = card,isHigh = isHigh})
end

function Player:sortCards()
    self.isTips_ = false
    self.tipsCount_  = 0
    self.tipsCards_ = {}
    self.tipsCount_  = 0
    self.tipsCards_ = {}
    self.isTips_ = false
    -- self:dispatchEvent({name = Player.HAND_CARD_SORT, })
end

function Player:doCardsEvent_(eventName, cards, action)
    self:setCards(checktable(cards))
    self:dispatchEvent({name = eventName, cards = cards, action = action, huPai = nil})
end

function Player:dispatchChuPaiEvent()
    self.isTips_ = false
    self.tipsCount_  = 0
    self.tipsCards_ = {}
    self:dispatchEvent({name = Player.ON_CHUPAI_EVENT})
end

function Player:tishi()
end

function Player:setDealer(bool, jokerInHand)
    self.isDealer_ = bool
    self:dispatchEvent({name = Player.ON_SETDEAR_EVENT, isDealer = bool})    
end

function Player:showQiPai(bool)
    self.QiPai = bool
    self:dispatchEvent({name = Player.ON_QIPAI_EVENT, isQiPai = bool})    
end

function Player:showDaNiao(bool)
    self.DaNiao = bool
    self:dispatchEvent({name = Player.ON_DANIAO_EVENT, isDaNiao = bool})    
end

function Player:doFlow(flag)
    self:dispatchEvent({name = Player.ON_FLOW_EVENT, flag = flag})
end

function Player:showRoundOverPoker(cards)
    self:dispatchEvent({name = Player.ON_ROUND_OVER_SHOW_POKER, cards = cards})
end

function Player:playRecordVoice(time)
    self:dispatchEvent({name = Player.ON_PLAY_RECORD_VOICE, time = time})
end

function Player:stopRecordVoice()
    self:dispatchEvent({name = Player.ON_STOP_RECORD_VOICE})
end

function Player:onFindChuPai_(event)
    --发现别人打牌，进入操作状态
end

function Player:doTiPai(event)
    self:dispatchEvent({name = Player.TI_PAI})
end

-- 摸牌与打牌区别
function Player:onChuPai_(event)
    local card = event.args[1]
    local inFastMode = event.args[2]
    if self.cards_ then  
        table.removebyvalue(self.cards_, card)
    end
    if not inFastMode then
        gameAudio.playCDPHZHumanSound(card..".mp3", self.sex_)
    end
    self:dispatchEvent({name = Player.CHU_PAI_CHANGED, card = card, inFastMode = inFastMode})

end

function Player:onQIPai(event)
    
end

return Player
