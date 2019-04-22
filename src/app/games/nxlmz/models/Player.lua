local BaseAlgorithm = require("app.games.nxlmz.utils.BaseAlgorithm")
local ZMZAlgorithm = require("app.games.nxlmz.utils.ZMZAlgorithm")
local BasePlayer = import("app.models.BasePlayer")
local Player = class("Player", BasePlayer)

-- 定义事件
Player.CHANGE_STATE_EVENT = "CHANGE_STATE_EVENT"
Player.POKER_FOUND = "POKER_FOUND"
Player.HAND_CARDS_CHANGED = "HAND_CARDS_CHANGED"
Player.HAND_CARDS_CHUPAI = "HAND_CARDS_CHUPAI"
Player.HAND_CARD_SORT = "HAND_CARD_SORT"  -- 手牌排序事件HAND_CARD_SORT
Player.INDEX_CHANGED = "INDEX_CHANGED"  -- 位置有变事件
Player.SIT_DOWN_EVENT = "SIT_DOWN_EVENT"  -- 坐下事件
Player.STAND_UP_EVENT = "STAND_UP_EVENT"  -- 站起事件
Player.SCORE_CHANGED = "SCORE_CHANGED"  -- 当前积分改变事件
Player.TOTALSCORE_CHANGED = "TOTALSCORE_CHANGED" --总积分改变事件
Player.DIAMOND_CHANGED = "DIAMOND_CHANGED"  -- 钻石改变事件
Player.ON_AVATAR_CLICKED = "ON_AVATAR_CLICKED"  -- 头像点击事件
Player.ON_CHUPAI_EVENT = "ON_CHUPAI_EVENT"  -- 抛出出牌事件
Player.ON_TIPS_EVENT = "ON_TIPS_EVENT"  --提示牌型事件
Player.ON_KING_SHOW = "ON_KING_SHOW"  --显示王
Player.ON_FLOW_EVENT = "ON_FLOW_EVENT"  --显示王
Player.ON_ROUND_OVER = "ON_ROUND_OVER"  --一局游戏结束
Player.ON_SETDEAR_EVENT = "ON_SETDEAR_EVENT"
Player.ON_SHOWHEISAN_EVENT = "ON_SHOWHEISAN_EVENT" 
Player.ON_ROUND_OVER_SHOW_POKER = "ON_ROUND_OVER_SHOW_POKER" 
Player.OFFLINE_EVENT = "OFFLINE_EVENT"
Player.SHOW_POKER_BACK = "SHOW_POKER_BACK"
Player.SHOW_HUCARD_IN_REVIEW = "SHOW_HUCARD_IN_REVIEW"
Player.SHOW_CARD_NUMBER = "SHOW_CARD_NUMBER"
Player.ZHA_DAN_DE_FEN = "ZHA_DAN_DE_FEN"
Player.GUAN_LONG = "GUAN_LONG"
Player.INIT_HAND_CARDS = "INIT_HAND_CARDS"
Player.CHANGE_MY_POS = "CHANGE_MY_POS"
Player.RESET_HAND_CARDS = "RESET_HAND_CARDS"
Player.WARNING = "WARNING"  -- 报警
Player.DO_CHU_PAI = "DO_CHU_PAI"  -- 玩家点出牌
Player.DO_TI_SHI = "DO_TI_SHI"  -- 玩家点提示
Player.REMOVE_HAND_CARDS = "REMOVE_HAND_CARDS"
Player.CLICK_TABLE = "CLICK_TABLE"
Player.SHOU_XIAN_SHOU = "SHOU_XIAN_SHOU"
Player.SHOU_XIAN_SHOU_WORD = "SHOU_XIAN_SHOU_WORD"
function Player:ctor()
    Player.super.ctor(self)
end

function Player:setTuoGuan(bool)
    self.isTuoGuan_ = bool
end

function Player:isTuoGuan()
    return self.isTuoGuan_
end

function Player:showXianShou(card)
    self:dispatchEvent({name = Player.SHOU_XIAN_SHOU, card = card})
end

function Player:showXianShouWord(isShow)
    self:dispatchEvent({name = Player.SHOU_XIAN_SHOU_WORD, isShow = isShow})
end

function Player:roundStart()
    self:setIsReady(false)
    self:showXianShouWord(false)
    self:setChuPai({})
    self:setTurnTo(false)
    self:warning(-1)
    self:showXianShou(-1)
    self:showRoundOverPoker(nil)
end

function Player:roundOver()
    self:setChuPai({})
    self:setTurnTo(false)
    self:showXianShouWord(false)
    self:setIsReady(false)
    self:warning(-1)
    self:showXianShou(-1)
    self:showRoundOverPoker(nil)
end

function Player:setOldIP(ip)
    if self.IP_ == nil or self.IP_ == '' then
        self.IP_ = ip
    end
end

function Player:getNickName()
    return gailun.utf8.formatNickName(self.nickName_, 12, '..')
end

function Player:getFullNickName()
    return self.nickName_
end

function Player:removeAllCards_()
    self:removeCards()
    self:setChuPai(nil)
end

function Player:onSitDown_(event)
    self:dispatchEvent({name = Player.SIT_DOWN_EVENT, seatID = self.seatID_})
end

function Player:onStandUp_(event)
    self:setSeatID(0)
    self:dispatchEvent({name = Player.STAND_UP_EVENT})
end

function Player:getHandCardBack()
    return self.isHandCardBack
end

function Player:setHandCards(cards,isReConnect,isBack)
    self.cards_ = clone(cards)
    self.isHandCardBack = isBack
    self:dispatchEvent({name = Player.INIT_HAND_CARDS, cards = cards, isReConnect = isReConnect,isBack = isBack})
end

function Player:changeMyPos()
    self:dispatchEvent({name = Player.CHANGE_MY_POS})
end

function Player:reShowHandCards(isNeedReset)
    if not isNeedReset then
        self.isHandCardBack = false
    end
    self:dispatchEvent({name = Player.RESET_HAND_CARDS, cards = self.cards_,isReConnect = true,isNeedReset = isNeedReset})
end

function Player:onChangeState_(event)
    local event = {name = Player.CHANGE_STATE_EVENT, from = event.from, to = event.to, args = event.args}
    self:dispatchEvent(event)
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

function Player:warning(flag, inFastMode, isReConnect, xianPai)
    self.warningType_ = flag
    self:dispatchEvent({name = Player.WARNING, warningType = flag, xianPai = xianPai, inFastMode = inFastMode, isReConnect = isReConnect})
end 

function Player:getWarningType()
    return self.warningType_
end

function Player:pass(inFastMode)
    self:dispatchEvent({name = Player.PASS, inFastMode = inFastMode})
end

function Player:playerHeiSan()
    self:dispatchEvent({name = Player.ON_SHOWHEISAN_EVENT})
end

function Player:showRoundOverPoker(cards)
    local tempCards = cards
    if cards and #cards > 0 then 
        tempCards  = ZMZAlgorithm.sort(cards)    
    end
    self:dispatchEvent({name = Player.ON_ROUND_OVER_SHOW_POKER, cards = tempCards})
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

function Player:doChuPai()
    self:dispatchEvent({name = Player.DO_CHU_PAI})
end

function Player:doTiShi()
    self:dispatchEvent({name = Player.DO_TI_SHI})
end

function Player:clickTable(event)
    self:dispatchEvent({name = Player.CLICK_TABLE,clickInfo = event})
end

function Player:removeHandCards(cards)
    for i,v in ipairs(cards) do
        table.removebyvalue(self.cards_, v)
    end
    self:dispatchEvent({name = Player.REMOVE_HAND_CARDS, cards = cards})
end

function Player:getNextPlayer()
    local rule = display.getRunningScene():getRuleDetails()
    local nextSeatID = 1
    if rule.playerCount == 3 then
        if self.seatID_ == 1 then
            nextSeatID = 2
        elseif self.seatID_ == 2 then
            nextSeatID = 3
        elseif self.seatID_ == 3 then
            nextSeatID =1
        end
    elseif rule.playerCount == 2 then
        if self.seatID_ == 1 then
            nextSeatID = 2
        elseif self.seatID_ == 2 then
            nextSeatID = 1
        end
    end
    return nextSeatID
end

return Player
