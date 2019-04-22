local TYPES = gailun.TYPES
local nodeTree = {
    type = TYPES.ROOT,
    children = {
        {type = TYPES.SPRITE, var = "spriteArrow_", filename = "res/images/majiang/game/focus_arrow.png", ap = {0.5, 0}},
    },
}

local MOVE_Y = 30
local MOVE_SECONDS = 0.5
local FocusArrowView = class("FocusArrowView", gailun.BaseView)

function FocusArrowView:ctor(table)
    self:setCascadeOpacityEnabled(true)
    gailun.uihelper.render(self, nodeTree)
end

function FocusArrowView:createActions_(x, y)
    local seconds = MOVE_SECONDS
    local actionMoveTo = cc.MoveBy:create(seconds, cc.p(x, y)) --移动
    local fade1 = cc.FadeTo:create(seconds, 128)
    local actionMoveBack = actionMoveTo:reverse() -- 反向移动
    local fade2 = cc.FadeTo:create(seconds, 255) -- 反向透明
    local action1 = cc.Spawn:create(actionMoveTo, fade1)
    local action2 = cc.Spawn:create(actionMoveBack, fade2)
    local sequence = transition.sequence({ --按顺序来执行
        action1,
        action2,
    })
    return cc.RepeatForever:create(sequence) --一直重复
end

function FocusArrowView:focusOn(x, y)
    self:show()
    -- x = display.cx
    -- y = display.cy
    self:pos(x, y)
    self:cleanup()
    self:runAction(self:createActions_(0, MOVE_Y))
end

function FocusArrowView:stop()
    self:cleanup()
    self:hide()
end

return FocusArrowView
