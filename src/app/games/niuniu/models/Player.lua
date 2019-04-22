local BasePlayer = import("app.models.BasePlayer")
local Player = class("Player", BasePlayer)
Player.CALL_SCORE = "CALL_SCORE"
Player.KAI_PAI = "KAI_PAI"
Player.MING_PAI = "MING_PAI"
Player.QIANG_ZHUANG = "QIANG_ZHUANG"
Player.SHOW_ZHUANG_KUANG = "SHOW_ZHUANG_KUANG"
function Player:ctor()
    Player.super.ctor(self)
end

function Player:showZhuangKuang(bool, isAnima)
    self:dispatchEvent({name = Player.SHOW_ZHUANG_KUANG,isShow = bool, isAnima = isAnima})
end

function Player:isQiangZhuang()
    return self.callDealer_
end

function Player:qiangZhuang(callScore,isReConnect)
    self.callDealer_ = callScore
    self:dispatchEvent({name = Player.QIANG_ZHUANG,callScore = callScore,isReConnect = isReConnect})
end

function Player:setCallDealer(callScore)
    self.callDealer_ = callScore
    self:dispatchEvent({name = Player.QIANG_ZHUANG,callScore = callScore,isReConnect = true})
end

function Player:getCallDealer()
    return self.callDealer_
end

function Player:kaiPai(cards, niuType, isShow)
    local tempCards = cards or self.cards_
    local typeType = niuType or self.niuType_
    self.niuType_ = typeType
    if #tempCards == 1 then
        self:addCardToCards(tempCards[1])
    end
    self:dispatchEvent({name = Player.KAI_PAI,isShow = isShow, cards = tempCards, niuType = self.niuType_})
end 

function Player:setIsKaiPai(bool)
    self.isKaiPai_ = bool
end

function Player:isKaiPai()
    return self.isKaiPai_
end

function Player:addCardToCards(card)
    table.insert(self.cards_, 5, card)
    table.removebyvalue(self.cards_, -1)
end

function Player:setNiuType(niuType)
    self.niuType_ = niuType
end

function Player:getNiuType()
    return self.niuType_
end

function Player:mingPai(cards)
    self.cards_ = cards
    if #cards == 4 then
        table.insert(cards, -1)
    end
    self:dispatchEvent({name = Player.MING_PAI,cards = cards})
end

function Player:getRealCount()
    local count = 0
    if self.cards_ == nil then
        return count
    end
    for i,v in ipairs(self.cards_) do
        if v ~= -1 then
            count = count + 1
        end
    end
    return count
end

function Player:setShowCards(isShow)
    self.isShowCards_ = isShow
end

function Player:isShowCards()
    return self.isShowCards_
end

function Player:setCanCallScore(canCallScore)
    self.canCallScore_ = canCallScore
end

function Player:getCanCallScore()
    return self.canCallScore_
end

function Player:setCallScore(score)
    self.callScore_ = score
    self:dispatchEvent({name = Player.CALL_SCORE, score = score})
end

function Player:getCallScore()
    return self.callScore_
end

function Player:roundStart()
    self:showZhuangKuang(false)
    self:qiangZhuang(-1)
    self:setCanCallScore(-1)
    self:setCallScore(-1)
    self:kaiPai({})
    self:setIsReady(false)
    self:setTurnTo(false)
end

function Player:roundOver()
    -- self:setCallScore(-1)
    -- self:setChuPai({})
    -- self:setTurnTo(false)
    -- self:setIsReady(false)
end

function Player:getNickName()
    return gailun.utf8.formatNickName(self.nickName_, 12, '..')
end

function Player:removeAllCards_()
    self:removeCards()
    self:setChuPai(nil)
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

function Player:playRecordVoice(time)
    self:dispatchEvent({name = Player.ON_PLAY_RECORD_VOICE, time = time})
end

function Player:stopRecordVoice()
    self:dispatchEvent({name = Player.ON_STOP_RECORD_VOICE})
end


return Player
