local BaseItem = import("app.views.BaseItem")
local NaoZhong = class("NaoZhong",BaseItem)

function NaoZhong:ctor()
    NaoZhong.super.ctor(self)
end

function NaoZhong:setNode(node)
    self.csbNode_ = node
    self:initElement_()
    local params = {}
    params.text = "0"
    params.font = "fonts/zs.fnt"
    params.align = cc.TEXT_ALIGNMENT_RIGHT
    self.timer_ = display.newBMFontLabel(params)
    self.timer_:setPosition(-2, -8)
    self.csbNode_:addChild(self.timer_)
end

function NaoZhong:setTimer(num)
    self.timer_:setString(num)
    self.csbNode_:show()
    self.endedTime_ = gailun.utils.getTime() + num
    self:startTime(num)
end

function NaoZhong:setVisible(visible)
    self.csbNode_:setVisible(visible)
end

function NaoZhong:startTime(num)
    local actions = {}
    local interval = 0.2
    local count = clone(num) / interval
    for i = 1, count do
        table.insert(actions, cc.CallFunc:create(function ()
            -- num = num - 1
            local remainTime = math.floor(self.endedTime_ - gailun.utils.getTime())
            remainTime = math.max(remainTime, 0)
            self.timer_:setString(remainTime)
        end))
        table.insert(actions, cc.DelayTime:create(interval))
    end
    table.insert(actions, cc.CallFunc:create(function ()
        -- self.csbNode_:hide()
    end))
    self.csbNode_:runAction(transition.sequence(actions))
end

function NaoZhong:getPos()
    return self.csbNode_:getPosition()
end

function NaoZhong:setPos(x,y)
    self.csbNode_:setPosition(x, y)
end

function NaoZhong:stop()
    self.timer_:setString("")
    self.csbNode_:hide()
    transition.stopTarget(self.csbNode_)
end

function NaoZhong:setPos(x,y)
    self.csbNode_:setPosition(x, y)
end

return NaoZhong 
