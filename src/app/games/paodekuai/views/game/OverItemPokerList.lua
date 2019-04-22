local OverItemPokerList = class("OverItemPokerList", gailun.BaseView)
local PdkAlgorithm = require("app.games.paodekuai.utils.PdkAlgorithm")
local BaseAlgorithm = require("app.games.paodekuai.utils.BaseAlgorithm")
local POKER_DIST = 30

function OverItemPokerList:ctor()
    OverItemPokerList.super.ctor(self)
end

function OverItemPokerList:setHandCards(handCardsList)
    if #handCardsList == 0 then return end
    self.outPokerContent_ = display.newSprite():addTo(self)
    local list = {}
    local offsetX = 20
    for i,cards in ipairs(handCardsList) do
        local tempCards = PdkAlgorithm.sort(1, cards)
        local item = self:createCardsContent_(tempCards):addTo(self.outPokerContent_)
        list[#list+1] = item
    end
    for i=1,#list do
        local item = list[i]
        if i~=1 then
            item:setPositionX(list[i-1].width+list[i-1]:getPositionX()+offsetX)
            self.outPokerContent_.width = list[i-1].width+list[i-1]:getPositionX()+offsetX
        else
            self.outPokerContent_.width = item.width
        end
    end
    if not self.outPokerContent_.width then
        self.outPokerContent_.width = 0
    end
    self.outPokerContent_:setPositionY(35)
end

function OverItemPokerList:createCardsContent_(cards, isHui)
    if cards == nil then return end
    local content = display.newSprite()
    local width = 0
    for i,v in ipairs(cards) do
        local x, y = self:clacPokerPos_(total, i)
        width = width + POKER_DIST
        local poker = app:createConcreteView("SmallPokerView", v):pos(x, y):addTo(content)
        poker:fanPai()
        if isHui then
            poker:showHuiSe(isHui)  
        end
    end
    content.width = width
    return content
end

function OverItemPokerList:setShengYuCards(cards)
    if #cards == 0 then return end
    local tempCards = PdkAlgorithm.sort(1,cards)
    self.shengYuContent_ = display.newSprite():addTo(self)
    local item = self:createCardsContent_(tempCards,true):addTo(self.shengYuContent_)
    if self.outPokerContent_ then
        self.shengYuContent_:setPosition(0,-35)
    end
end

function OverItemPokerList:clacPokerPos_(total, index)
    local x = index * POKER_DIST - 200
    local y = 0
    return x, y
end

return OverItemPokerList 
