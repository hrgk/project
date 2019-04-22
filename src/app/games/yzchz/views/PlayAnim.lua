
local PlayAnim = class("PlayAnim", function()
    return display.newNode()
end)



function PlayAnim:ctor(id)
    display.addSpriteFrames("textures/game_anims.plist", "textures/game_anims.png")

    local png = ANIM_YZCHZ_LIST[id]
    if not png then
        print (id, ' not exist')
        return
    end
    local seconds1 = 0.4
    local seconds2 = 0.5
    local bg = display.newSprite("res/images/paohuzi/game/mowen.png"):addTo(self)
    bg:setScale(1.1)
    transition.scaleTo(bg, {scale = 1, time = seconds1})
    local sprite1 = display.newSprite(png):addTo(self)
    sprite1:setScale(3)
    sprite1:setOpacity(0.7 * 255)
    transition.execute(sprite1, cc.ScaleTo:create(seconds1, 1.5), {
        easing = "elasticOut",
        onComplete = function()
            local sprite2 = display.newSprite(png):addTo(self)
            transition.fadeOut(sprite2, {time = seconds2})
            transition.execute(sprite2, cc.ScaleTo:create(seconds2, 3), {
                easing = "out",
                onComplete = function()
                    self:removeSelf()
                end
            })
        end,
    })
    transition.fadeTo(sprite1, {opacity = 255, time = seconds1})
end

return PlayAnim
