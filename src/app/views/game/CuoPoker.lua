local BaseAlgorithm = import("app.games.niuniu.utils.BaseAlgorithm")
local CuoPoker = class("CuoPoker", function()
    return display.newSprite()
end)
local path = "res/images/game/cuoCards/"
function CuoPoker:ctor(card)
    local suit = BaseAlgorithm.getSuit(card)
    local value = BaseAlgorithm.getValue(card)
    local bg = "heitao"
    if suit == 1 then
        bg = "fangkuai"
    elseif suit == 2 then
        bg = "meihua"
    elseif suit == 3 then
        bg = "hongtao"
    end
    bg = bg .. value .. ".png"

    local num1 = "red_"
    if suit == 2 or suit == 4 then
        num1 = "black_"
    end
    num1 = num1 .. value .. ".png"
    local back = display.newSprite(path..bg):addTo(self)
    self.number1_ = display.newSprite(path..num1):addTo(self):pos(-210,310)--:hide()
    self.number2_ = display.newSprite(path..num1):addTo(self):pos(210,-310)--:hide()
    if value == 18 or value == 20 then
        self.number1_:setPositionY(220)
        self.number2_:setPositionY(-220)
    end
    self.number2_:setScale(-1)
    self.number1_:hide()
    self.number2_:hide()
end

function CuoPoker:showNumber()
    self.number1_:show()
    self.number2_:show()
end

return CuoPoker 
