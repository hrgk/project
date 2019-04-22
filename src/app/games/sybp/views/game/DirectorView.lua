local TYPES = gailun.TYPES
local Nodes = {
    type = TYPES.ROOT,
    children = {
        {type = TYPES.SPRITE, var = "bg_", filename = "res/images/paodekuai/game/time_bg.png", ap = {0.5, 0.5}},
        -- {type = TYPES.LABEL_ATLAS, var = "labelSeconds_", filename = "fonts/timenum.png", options = {text="", w = 36, h = 45, startChar = "0"}, ap = {0.5, 0.5}},
    },
}


local fanFnt = {type = gailun.TYPES.BM_FONT_LABEL, options={text="0",UILabelType = 1,font = "fonts/zs.fnt",} , ap = {0.5, 0.5}}

local NumberRoller = gailun.NumberRoller.new()
NumberRoller:setFormatHandler(tostring)
local DirectorView = class("DirectorView", gailun.BaseView)

DirectorView.ON_TICK = "ON_TICK"
DirectorView.TIMEOUT = "TIMEOUT"

local TICK_SECONDS = 1  -- 步进的单位时间

function DirectorView:ctor(table)
	cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()
    gailun.uihelper.render(self, Nodes)
    self.labelSeconds_ = gailun.uihelper.createBMFontLabel(fanFnt):addTo(self):pos(0,-3)
    self.labelSeconds_:setAnchorPoint(0.5,0.5)
end

function DirectorView:onEnter()
end

function DirectorView:onExit()
    gailun.EventUtils.clear(self)
end

-- 倒计时
function DirectorView:start(seconds)
    self:stop()
    self.labelSeconds_:show()
    local seconds = seconds or 0
    self.seconds_ = seconds
    self:showLeftSeconds_(seconds)
    self:schedule(handler(self, self.tickByDeltaTime_), TICK_SECONDS)
end

function DirectorView:showLeftSeconds_(seconds)
    self.seconds = seconds or 0
    local str = string.format("%d", math.round(seconds or 0))
    
    local sequence = transition.sequence({
        cc.ScaleTo:create(0.1, 0.1),
        -- cc.DelayTime:create(0.1),
        cc.CallFunc:create(function()
            self.labelSeconds_:setString(str) 
            end),
        cc.ScaleTo:create(0.1, 1),
        nil
    })
    self.labelSeconds_:runAction(sequence)
end

function DirectorView:setScoreWithRoller_(score, fromScore)
    NumberRoller:run(self.labelSeconds_, score + 1, score)
end

function DirectorView:tickByDeltaTime_()
    self.seconds_ = self.seconds_ - TICK_SECONDS
    local showSeconds = self.seconds_
    showSeconds = math.max(showSeconds, 0)
    self:showLeftSeconds_(showSeconds)
    self:dispatchEvent({name = DirectorView.ON_TICK, leftSeconds = self.seconds_})
    if self.seconds_ <= 0 then
        if self.timeOverFunc then
            self.timeOverFunc()
        end
        --self:dispatchEvent({name = DirectorView.TIMEOUT})
    end
end

-- 停止计时器
function DirectorView:stop()
    -- self.labelSeconds_:hide()
    self:stopAllActions()
    transition.stopTarget(self)
end

function DirectorView:setTimeOverFunc(callback)
    self.timeOverFunc = callback
end

return DirectorView
