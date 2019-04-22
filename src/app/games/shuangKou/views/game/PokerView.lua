local PokerView = class("PokerView", function()
    return display.newSprite()
    end)

PokerView.SUIT_BIG_DATA = {"#res/images/game/pokers/fangb.png", "#res/images/game/pokers/meib.png", "#res/images/game/pokers/hongb.png", "#res/images/game/pokers/heib.png"}
PokerView.SUIT_SMALL_DATA = {"#res/images/game/pokers/fangs.png", "#res/images/game/pokers/meis.png", "#res/images/game/pokers/hongs.png", "#res/images/game/pokers/heis.png"}

PokerView.KING_BIG = 520
PokerView.KING_SMALL = 518

function PokerView:ctor(card,isback)
    display.addSpriteFrames("res/images/game/pokers.plist", "res/images/game/pokers.png")

    self.posX_ = 0
    self.posY_ = 0

    self.card_ = card
    if card == 0 then
        return
    end
    if card == -1 then 
        self:makePaiBei_()
        return 
    end
    self:initPoker_()
    self:initMask_()

    self.isSelected_ = false
    self.canSelect_ = true
    self.isPink_ = false

    self.flag_ = 0
    self.isback = isback
    if isback then
        self:makePaiBei_()
    end
end

function PokerView:getPokerPos()
    if self.posX_ and self.posY_ then
        return self.posX_, self.posY_
    else
        return 0, 0
    end
end

function PokerView:setPokerFlag(flag)
	self.flag_ = flag
end

function PokerView:getPokerFlag()
	return self.flag_
end

function PokerView:initMask_()
    self.mask_ = display.newSprite()
    self.mask_:setLocalZOrder(100)
    self:addChild(self.mask_)
    self.mask_:hide()
end

function PokerView:setCard(card)
    self.card_ = card
    self:initPoker_()
end

function PokerView:setCardValue(card)
    self.card_ = card
end

function PokerView:getSuit(c) -- 获得一张牌的花色
    if c == nil then
        return
    end
    return math.round(tonumber(c) / 100)
end

function PokerView:getValue(c) -- 获得一张牌值的大小
    if c == nil then
        return
    end
    return c % 100
end

function PokerView:calcCardName_()
    local cvalue = self:getValue(self.card_)
    local csuit = self:getSuit(self.card_)
    local color
    if csuit == 5 then
        color = "#res/images/game/pokers/wang/"
    elseif csuit == 1 or csuit == 3 then
        color = "#res/images/game/pokers/hongzi/"
    else
        color = "#res/images/game/pokers/heizi/"
    end
    return csuit, color .. cvalue .. ".png"
end

function PokerView:makeDiBan_()
    self.poker_ = display.newFilteredSprite("#res/images/game/pokers/pkbg.png") -- 底
    self:addChild(self.poker_)
end

function PokerView:makeNumber_()
    local csuit, cardName = self:calcCardName_()
    local isKing = csuit == 5
    local numX = 10
    if isKing then
        numX = 14
    end
    display.newSprite(cardName):addTo(self.poker_):align(display.LEFT_TOP, numX, 220 - 14) -- 数字
end

function PokerView:makeSmallSuit_()
    local csuit = self:getSuit(self.card_)
    if csuit == 5 then
        return
    end
    display.newSprite(PokerView.SUIT_SMALL_DATA[csuit]):addTo(self.poker_):align(display.LEFT_TOP, 7, 220 - 14 - 60)
end

function PokerView:makeBigSuit_()
    local csuit = self:getSuit(self.card_)
    local suitName
    if self.KING_SMALL == self.card_ then
        suitName = "#res/images/game/pokers/xiaowang.png"
    elseif self.KING_BIG == self.card_ then
        suitName = "#res/images/game/pokers/dawang.png"
    else
        suitName = PokerView.SUIT_BIG_DATA[csuit]
    end
    display.newSprite(suitName):addTo(self.poker_):align(display.RIGHT_BOTTOM, 152, 10) -- 大花色
end

function PokerView:makePaiBei_()
    self.bg_ = display.newSprite("#res/images/game/pokers/poker_bg.png") -- 牌背
    self:addChild(self.bg_)
end

function PokerView:initPoker_()
    self:makeDiBan_()
    self:makeNumber_()
    self:makeSmallSuit_()
    self:makeBigSuit_()
    self:makePaiBei_()
    self.poker_:setVisible(false)
end

function PokerView:fanPai()
    if self.poker_ then
        self.poker_:setVisible(true)
    end
    if self.bg_ then
        self.bg_:setVisible(false)
    end
    self:opacity(255)
end

function PokerView:setBlack()
    self.poker_:setColor(cc.c3b(130, 130, 130))
end

function PokerView:getCard()
    return self.card_
end

function PokerView:showBack(bool)
    if self.bg_ then
        self.bg_:setVisible(bool)
    end
end

function PokerView:getWidth()
    return self.poker_:getContentSize().width
end

function PokerView:getHeight()
    return self.poker_:getContentSize().height
end

function PokerView:setSelected(bool)
    self.isSelected_ = bool
    self:setHighLight(false)
end

function PokerView:isSelected()
    return self.isSelected_
end

function PokerView:setHighLight(bool)
    self.isHighLight_ = bool
    self:updateView()
end

function PokerView:isHighLight()
    return self.isHighLight_
end

function PokerView:setCanSelected(bool)
    self.canSelect_ = bool
    self:updateView()
    return self
end

function PokerView:isCanSelected()
    return self.canSelect_
end

function PokerView:showPink(bool)
    self.isPink_ = bool
    self:updateView()
    return self
end

function PokerView:isPink()
    return self.isPink_
end

function PokerView:updateView()
    if not self.poker_ then
        return self
    end

    if tolua.isnull(self.poker_) then
        return self
    end

    self.poker_:clearFilter()

    if self.canSelect_ == false then
        self.poker_:setFilter(filter.newFilter("RGB", {144/255, 144/255, 144/255})) 
    elseif self.isHighLight_ == true then
        self.poker_:setFilter(filter.newFilter("RGB", {1, 243/255, 135/255})) 
    elseif self.isPink_ == true then
        self.mask_:setSpriteFrame(display.newSprite("#res/images/game/pokers/shuangkou.png"):getSpriteFrame())
        self.mask_:show()
        return
    elseif self.isPink_ == false then
        self.mask_:hide()
        return
    end

    return self
end

return PokerView 
