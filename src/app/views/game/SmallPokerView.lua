local PokerView = import(".PokerView")
local SmallPokerView = class("SmallPokerView", PokerView)
local BaseAlgorithm = require("app.games.paodekuai.utils.BaseAlgorithm")

local GRAY_FILTERS = {"GRAY", {0.2, 0.3, 0.5, 0.1}}

function SmallPokerView:makeDiBan_()
    self.poker_ = display.newFilteredSprite("#res/images/game/pokers/pkbg_s.png") -- 底
    self:addChild(self.poker_)
end

function SmallPokerView:makeNumber_()
    local csuit, cardName = self:calcCardName_()
    local isKing = csuit == 5
    local numX, scale = 5, 0.45
    if isKing then
        numX = 7
        scale = 0.42
    end
    display.newFilteredSprite(cardName):addTo(self.poker_):align(display.LEFT_TOP, numX, 57):scale(scale)
end

function SmallPokerView:makeSmallSuit_()
    local csuit = self:getSuit(self.card_)
    if csuit == 5 then
        return
    end
    display.newFilteredSprite(PokerView.SUIT_SMALL_DATA[csuit]):addTo(self.poker_):align(display.LEFT_TOP, 3, 57 - 29):scale(0.5)
end

function SmallPokerView:makeBigSuit_()
    local suitName
    if self.KING_SMALL == self.card_ then
        suitName = "#xiaowang.png"
    elseif self.KING_BIG == self.card_ then
        suitName = "#dawang.png"
    else
        return
    end
    display.newFilteredSprite(suitName):addTo(self.poker_):align(display.RIGHT_BOTTOM, 44, 5):scale(0.25)
end

function SmallPokerView:initPoker_()
    self:makeDiBan_()
    self:makeNumber_()
    self:makeSmallSuit_()
    self:makeBigSuit_()
end

function SmallPokerView:setGray()
    local filters, params = unpack(GRAY_FILTERS)
    if params and #params == 0 then
        params = nil
    end
    local filters = filter.newFilter(filters, params)
    self.poker_:setFilter(filters)
    local nodes = self.poker_:getChildren()
    for _,v in pairs(nodes) do
        v:setFilter(filters)
    end
end

function SmallPokerView:clearGray()
    self.poker_:clearFilter()
    local nodes = self.poker_:getChildren()
    for _, v in pairs(nodes) do
        v:clearFilter()
    end
end

return SmallPokerView
