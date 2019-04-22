local TopView = class("TopView", gailun.BaseView)
local TYPES = gailun.TYPES
local nodes = {
    type = TYPES.ROOT, children = {
        -- {type = TYPES.LAYER, var = "layer_", size = {display.width, display.height}, ap = {0.5, 0.5}, x = display.cx, y = display.cy},
    }
}

function TopView:ctor()
    gailun.uihelper.render(self, nodes)

    -- self.layer_:setTouchEnabled(true)
    -- self.layer_:setTouchSwallowEnabled(false)

    -- self.layer_:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self.touchCall))

    self:initMask()
    self.nowTime_ = 0
end

function TopView:initMask()
    local layout = ccui.Layout:create()
    layout:setContentSize(cc.size(display.width, display.height))
    layout:setTouchEnabled(true)
    layout:setSwallowTouches(false)
    layout:addTouchEventListener(handler(self, self.touchCall))
    self:addChild(layout, 10000)

    self.layer_ = layout
end

function TopView:touchCall(sender, eventType, x, y)
    local pos = sender:getTouchMovePosition()
    if eventType == 0 then
        pos = sender:getTouchBeganPosition()
    end

    local speed = 1.5
    if eventType == 0 then
        if gailun.utils.getTime() - self.nowTime_ < 0.05 then
            return true
        end
        local effect = cc.uiloader:load("views/clickEffect.csb")
        local action = cc.CSLoader:createTimeline("views/clickEffect.csb")

        local playTime = action:getDuration()/CONFIG_FPS_NUMBERS/speed
        self:runAction(cc.Sequence:create({
            cc.DelayTime:create(playTime),
            cc.CallFunc:create(function ()
                effect:removeFromParent()
            end)
        }))

        action:setTimeSpeed(speed)
        effect:runAction(action)
        action:gotoFrameAndPlay(0, false)
        effect:setPosition(pos)
        self.layer_:addChild(effect,102)  

        self.nowTime_ = gailun.utils.getTime()
    end

    return true
end

return TopView
