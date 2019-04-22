local BaseAlgorithm = import("app.games.csmj.utils.BaseAlgorithm")
local MaJiangOut = class("MaJiangOut", function()
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

function MaJiangOut:ctor(card, index)
    display.addSpriteFrames("res/images/majiang/majiang.plist", "res/images/majiang/majiang.png")
    self.card_ = card
    self.index_ = index
    if self.card_ ~= nil then
        local path = self:clacMaJiangName_()
        local sprite = display.newSprite(path):addTo(self)
    end
end

function MaJiangOut:getCard()
    return self.card_
end

function MaJiangOut:clacMaJiangName_()
    local suit = BaseAlgorithm.getSuit(self.card_)
    local value = BaseAlgorithm.getValue(self.card_)
    print(self.card_, suits[suit], fangWei[self.index_], value)
    return suits[suit] .. fangWei[self.index_] .. value .. ".png"
end

return MaJiangOut 
