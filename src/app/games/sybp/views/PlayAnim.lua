
local PlayAnim = class("PlayAnim", function()
    return display.newNode()
end)



function PlayAnim:ctor(id)
    display.addSpriteFrames("textures/game_anims.plist", "textures/game_anims.png")

    local png = ANIM_LIST[id]
    if not png then
        print (id, ' not exist')
        return
    end
    local seconds1 = 0.4
    local seconds2 = 0.5
    local bg = display.newSprite("res/images/paohuzi/game/mowen.png"):addTo(self)
    local sprite1 = display.newSprite(png):addTo(self)
    local actions = transition.sequence({
        cc.DelayTime:create(1),
        cc.FadeOut:create(seconds1)
    })
    local actions2 = transition.sequence({
        cc.DelayTime:create(1),
        cc.FadeOut:create(seconds1)
    })
    bg:runAction(actions)
    sprite1:runAction(actions2)
end

return PlayAnim
