
local BaseAlgorithm = require("app.games.hzmajiang.utils.BaseAlgorithm")
local HuAnim = class("HuAnim", function()
    return display.newNode()
end)

function HuAnim:ctor()
    self:setCascadeOpacityEnabled(true)

    local seconds1, seconds2 = 0.3, 3

    display.addSpriteFrames("textures/game_anims.plist", "textures/game_anims.png")
    local long_guang = display.newSprite("res/images/ani/longguang.png"):addTo(self)
    local light1 = BaseAlgorithm.createPingPongLight(seconds1, 1.01, 0.99)
    long_guang:runAction(light1)
    display.newSprite("res/images/ani/long.png"):addTo(self)

    local hu_guang = display.newSprite("res/images/ani/huguang.png"):addTo(self):pos(-10, 20)
    hu_guang:setVisible(false)

    local hu = display.newSprite("res/images/ani/hu.png"):addTo(self):pos(-10, 20)
    hu:pos(-20, 80)
    hu:setScale(2.5)
    hu:setOpacity(0.7 * 255)

    local function showHuLight()
        local light2 = BaseAlgorithm.createPingPongLight(seconds1, 1.02, 0.98)
        hu_guang:runAction(light2)
        hu_guang:setVisible(true)
    end

    transition.execute(hu, cc.ScaleTo:create(seconds1 * 2, 1), {
        easing = "bounceOut",
        onComplete = showHuLight
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

return HuAnim
