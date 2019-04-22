local ActionAnim = class("ActionAnim", gailun.BaseView)

function ActionAnim:ctor()
    display.addSpriteFrames("textures/actions.plist", "textures/actions.png")

end

function ActionAnim:create_(frontImage)
    assert(frontImage)
    self.spriteBottom_ = display.newSprite("#actions_bg.png"):addTo(self):hide()
    self.spriteBottom_:scale(0.3)
    self.spriteBg_ = display.newSprite("#actions_bg.png"):addTo(self)
    self.spriteBg_:scale(0.5)
    self.sprite_ = display.newSprite(frontImage):addTo(self)
end

function ActionAnim:playChi()
    self:create_("#anim_chi3.png")
    self:playAnim_()
    return self
end

function ActionAnim:playPeng()
    self:create_("#anim_peng3.png")
    self:playAnim_()
    return self
end

function ActionAnim:playGang()
    self:create_("#anim_gang3.png")
    self:playAnim_()
    return self
end

function ActionAnim:playHu()
    self:create_("#anim_hu3.png")
    self:playAnim_()
    return self
end

function ActionAnim:playZiMo()
    self:create_("#anim_zimo3.png")
    self:playAnim_()
    return self
end

function ActionAnim:playAnim_(seconds)
    local scaleSeconds = seconds or 0.4
    transition.scaleTo(self, {scale = 0.7, time = scaleSeconds, easing = "backOut"})  -- 整体缩小
    local moshuiAction = transition.sequence({
        cc.DelayTime:create(scaleSeconds / 2),
        cc.CallFunc:create(function ()  -- 墨水放大并消失
            self.spriteBottom_:show()
            transition.scaleTo(self.spriteBottom_, {time = scaleSeconds, scale = 0.8})
            transition.fadeOut(self.spriteBottom_, {time = scaleSeconds, })
        end),

        cc.DelayTime:create(scaleSeconds * 1),
        cc.CallFunc:create(function () -- 整体消失
            self.spriteBg_:hide()
            transition.fadeOut(self, {time = scaleSeconds / 2})
        end),
        cc.DelayTime:create(scaleSeconds / 2),
        cc.CallFunc:create(function ()
            self:removeFromParent()
        end)
    })
    self:runAction(moshuiAction)
end

return ActionAnim
