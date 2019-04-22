local BaseAlgorithm = import("app.games.csmj.utils.BaseAlgorithm")
local MaJiangChi = class("MaJiangChi", function()
    return display.newSprite()
end)

local suits = {}
suits[1] = "#res/images/majiang/majiang/wan/mj_"
suits[2] = "#res/images/majiang/majiang/suo/mj_"
suits[3] = "#res/images/majiang/majiang/tong/mj_"

local fangWei = {}
fangWei[1] = "b"
fangWei[2] = "r"
fangWei[3] = "t"
fangWei[4] = "l"

local mjBgPath = "#res/images/majiang/majiang/mjbgd_"

function MaJiangChi:ctor(card, index, isShowValue)
    display.addSpriteFrames("res/images/majiang/majiang.plist", "res/images/majiang/majiang.png")
    self.card_ = card
    self.index_ = index
    local path = self:clacMaJiangName_(isShowValue)
    local sprite = display.newSprite(path):addTo(self)
end

function MaJiangChi:getCard()
    return self.card_
end

function MaJiangChi:clacMaJiangName_(isShowValue)
    if isShowValue == false then
        return mjBgPath .. fangWei[self.index_] .. ".png" 
    end
    local suit = BaseAlgorithm.getSuit(self.card_)
    local value = BaseAlgorithm.getValue(self.card_)
    return suits[suit] ..fangWei[self.index_] .. "_" .. value .. ".png"
end

return MaJiangChi 
