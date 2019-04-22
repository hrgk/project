local RemindView = class("RemindView", gailun.BaseView)
local CHANGE_TINE = 0.2
local CHANGE_SCLAE = 0.1

function RemindView:ctor(imagePath, x, y)
    self:show(imagePath)
    -- self:setPosition(data.x, data.y)
end

function RemindView:show(url)
    local back = display.newSprite(url)
    self:addChild(back)
    back:setScale(CHANGE_SCLAE)
    transition.scaleTo(back, {scale = 1, time = CHANGE_TINE, easing = "backout", onComplete = function ( ... )
        self:close(back)
    end})
end

function RemindView:close(back)
    self:performWithDelay(function ( ... )
        transition.scaleTo(back, {scale = CHANGE_SCLAE, time = CHANGE_TINE, easing = "backout", onComplete = function ( ... )
            self:removeAllChildren()
            self:removeFromParent()
        end})
    end, 2)
end

return RemindView
