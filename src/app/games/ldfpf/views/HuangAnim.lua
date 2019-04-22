
local BaseAlgorithm = require("app.games.ldfpf.utils.BaseAlgorithm")
local HuangAnim = class("HuangAnim", function()
    return display.newNode()
end)

function HuangAnim:ctor()
    self:setCascadeOpacityEnabled(true)

    local seconds1, seconds2 = 0.3, 1

    display.addSpriteFrames("textures/game_anims.plist", "textures/game_anims.png")

    local hu = display.newSprite("res/images/paohuzi/ani/huangzhuang.png"):addTo(self):pos(-10, 20)
    hu:pos(-20, 80)
    hu:setScale(2.5)
    hu:setOpacity(0.7 * 255)

    transition.execute(hu, cc.ScaleTo:create(seconds1 * 2, 1), {
        easing = "bounceOut",
    })
    transition.moveTo(hu, {x = -10, y = 20, time = seconds1})
    transition.fadeTo(hu, {opacity = 255, time = seconds1})

    transition.execute(self, cc.FadeTo:create(seconds1, 0), {
        delay = seconds2,
        easing = "out",
        onComplete = function()
            self:removeSelf()
        end,
    })
end

return HuangAnim
