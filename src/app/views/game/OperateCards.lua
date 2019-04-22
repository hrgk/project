local BaseAlgorithm = import("app.games.csmj.utils.BaseAlgorithm")
local OperateCards = class("OperateCards", function()
    return display.newSprite()
end)

local suits = {}
suits[1] = "#res/images/majiang/majiang/wan/mj_"
suits[2] = "#res/images/majiang/majiang/suo/mj_"
suits[3] = "#res/images/majiang/majiang/tong/mj_"

local fangWei = {}
fangWei[1] = "c_"
fangWei[2] = "r_"
fangWei[3] = "t_"
fangWei[4] = "l_"

function OperateCards:ctor(card, index)
    display.addSpriteFrames("res/images/majiang/majiang.plist", "res/images/majiang/majiang.png")
    self.card_ = card
    self.index_ = index
    local path = self:clacMaJiangName_()
    local sprite = display.newSprite(path):addTo(self)
end

function OperateCards:getCard()
    return self.card_
end

function OperateCards:clacMaJiangName_()
    local suit = BaseAlgorithm.getSuit(self.card_)
    local value = BaseAlgorithm.getValue(self.card_)
    return suits[suit] ..fangWei[self.index_] .. value .. ".png"
end

return OperateCards  
