local JWPushButton = class("JWPushButton", cc.ui.UIPushButton)

function JWPushButton:ctor(images, options)
    JWPushButton.super.ctor(self, images, options)
    self.autoGray_ = false
    self.autoScale_ = nil
    self.autoOpacity_ = nil
    self.originScale_ = self:getScale()
    
    self:onButtonStateChanged(handler(self, self.onStateChanged_))
    self:onButtonPressed(handler(self, self.onPressed_))
    self:onButtonRelease(handler(self, self.onRelease_))
end

-- 禁用时自动按钮变灰
function JWPushButton:setAutoGray(flag)
    self.autoGray_ = flag
end

-- 当点击时自动放大，按起时自动恢复原大小
function JWPushButton:setAutoScale(scale)
    self.autoScale_ = scale
end

-- 当点击时自动变透明一点，按起时自动恢复原透明度
function JWPushButton:setAutoOpacity(opacity)
    self.autoOpacity_ = opacity
end

function JWPushButton:setSoundEffect(sound)
    self.soundEffect_ = sound
end

function JWPushButton:onStateChanged_(event)
    if not self.autoGray_ then
        return
    end

    if event.state == 'disabled' then
        self:replaceSprite_(true)
    else
        self:replaceSprite_(false)
    end
end

function JWPushButton:getStateImage_()
    local state = self.fsm_:getState()
    local image = self.images_[state]

    if not image then
        for _, s in pairs(self:getDefaultState_()) do
            image = self.images_[s]
            if image then break end
        end
    end
    return image
end

function JWPushButton:removeAllSprites_()
    for i,v in ipairs(self.sprite_) do
        v:removeFromParent(true)
    end
    self.sprite_ = {}
end

function JWPushButton:replaceSprite_(isGray)
    assert(not self.scale9_)
    local image = self:getStateImage_()
    if not image then
        return
    end

    self:removeAllSprites_()
    if isGray then
        self.sprite_[1] = display.newGraySprite(image)
    else
        self.sprite_[1] = display.newSprite(image)
    end
    if self.sprite_[1].setFlippedX then
        if self.flipX_ then
            self.sprite_[1]:setFlippedX(self.flipX_ or false)
        end
        if self.flipY_ then
            self.sprite_[1]:setFlippedY(self.flipY_ or false)
        end
    end
    self:addChild(self.sprite_[1], self.IMAGE_ZORDER)

    for i,v in ipairs(self.sprite_) do
        v:setAnchorPoint(self:getAnchorPoint())
        v:setPosition(0, 0)
    end
end

function JWPushButton:onPressed_(event)
    self:stopAllActions()
    if self.autoScale_ then
        local scale = self:getScale()
        self.sprite_[1]:runAction(cc.ScaleTo:create(0.08, scale * self.autoScale_))
    end
    if self.autoOpacity_ then
        local opacity = self:getOpacity()
        self.sprite_[1]:setOpacity(opacity * self.autoOpacity_)
    end
    if self.soundEffect_ and string.len(self.soundEffect_) > 0 then
        gameAudio.playSound(self.soundEffect_, false)
    end
end

function JWPushButton:onRelease_(event)
    self:stopAllActions()
    if self.autoOpacity_ then
        local opacity = self:getOpacity()
        self.sprite_[1]:setOpacity(opacity)
    end
    if self.autoScale_ then
        self.sprite_[1]:runAction(cc.ScaleTo:create(0.04, self.originScale_))
    end
end

return JWPushButton
