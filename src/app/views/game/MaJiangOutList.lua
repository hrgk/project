local MaJiangDownOutList = import(".MaJiangDownOutList")
local MaJiangLeftOutList = import(".MaJiangLeftOutList")
local MaJiangUpOutList = import(".MaJiangUpOutList")
local MaJiangRightOutList = import(".MaJiangRightOutList")
local MaJiangOutList = class("MaJiangOutList", function()
    return display.newSprite()
end)

function MaJiangOutList:ctor(cards, index)
    self.index_ = index
    if index == 1 then
        self.outList_ = MaJiangDownOutList.new(cards, index)
    elseif index == 2 then
        self.outList_ = MaJiangRightOutList.new(cards, index)
    elseif index == 3 then
        self.outList_ = MaJiangUpOutList.new(cards, index)
    elseif index == 4 then
        self.outList_ = MaJiangLeftOutList.new(cards, index)
    end
    self:addChild(self.outList_)
end

function MaJiangOutList:tanPai(cards)
    self.outList_:tanPai(cards)
end

function MaJiangOutList:addMaJiang(card)
    self.outList_:addMaJiang(card)
end

function MaJiangOutList:delMaJiang(card)
    self.outList_:delMaJiang(card)
end

return MaJiangOutList 
