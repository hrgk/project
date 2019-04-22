local BaseAlgorithm = import("app.games.csmj.utils.BaseAlgorithm")
local FaceAnimationsData = require("app.data.FaceAnimationsData")

local BirdView = class("BirdView", function()
    return display.newSprite()
end)

local suits = {}
suits[1] = "#res/images/majiang/majiang/wan/mjb_b_"
suits[2] = "#res/images/majiang/majiang/suo/mjb_b_"
suits[3] = "#res/images/majiang/majiang/tong/mjb_b_"

function BirdView:ctor(card)
    -- dump(card)
    -- self.card_ = card
    -- -- self:createTexiao_()
    -- local path = self:clacMaJiangName_()
    -- local sprite = display.newSprite(path):addTo(self)
end

function BirdView:createTexiao_()
    local animaData = FaceAnimationsData.getCocosAnimation(16)
    -- animaData.x = self.chuPai_:getPositionX()
    -- animaData.y = self.chuPai_:getPositionY()
    gameAnim.createCocosAnimations(animaData, self)
end

function BirdView:clacMaJiangName_()
    local suit = BaseAlgorithm.getSuit(self.card_)
    local value = BaseAlgorithm.getValue(self.card_)
    return suits[suit] .. value .. ".png"
end

return BirdView 
