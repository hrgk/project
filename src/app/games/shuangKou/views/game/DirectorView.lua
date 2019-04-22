local TYPES = gailun.TYPES
local Nodes = {
    type = TYPES.ROOT,
    children = {
        {type = TYPES.NODE, var = "nodeDirection_", children = {
            {type = TYPES.SPRITE, var = "alarmClock_", filename = "res/images/paodekuai/game/time_bg.png"},
        }},
        {type = TYPES.LABEL_ATLAS, y=-5, var = "labelSeconds_", filename = "res/images/tianzha/fonts/game_destoryroom.png", options = {text="", w = 18, h = 32, startChar = "0"}, ap = {0.5, 0.5}},
    },
}

local DirectorView = class("DirectorView", gailun.BaseView)

DirectorView.ON_TICK = "ON_TICK"
DirectorView.TIMEOUT = "TIMEOUT"

local TICK_SECONDS = 1  -- 步进的单位时间

function DirectorView:ctor(table)
    cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()
    gailun.uihelper.render(self, Nodes)
end

function DirectorView:onEnter()
end

function DirectorView:onExit()
    gailun.EventUtils.clear(self)
end

-- 倒计时
function DirectorView:start(seatID, seconds)
    self.seatID = seatID
    self:stop()
    self:show()
    self.labelSeconds_:show()
    -- self.labelSeconds_:setString(" ")
    local seconds = seconds or 0
    self.seconds_ = seconds
    self:showLeftSeconds_(seconds)
    self:schedule(handler(self, self.tickByDeltaTime_), TICK_SECONDS)
end

function DirectorView:showLeftSeconds_(seconds)
    local str = string.format("%02d", math.round(seconds or 0))
    self.labelSeconds_:setString(str)
end

function DirectorView:tickByDeltaTime_()
    self.seconds_ = self.seconds_ - TICK_SECONDS
    local showSeconds = self.seconds_
    showSeconds = math.max(showSeconds, 0)
    self:showLeftSeconds_(showSeconds)
    self:dispatchEvent({name = DirectorView.ON_TICK, leftSeconds = self.seconds_, lightIndex = self.seatID})
    if self.seconds_ <= 0 then
        self:dispatchEvent({name = DirectorView.TIMEOUT})
        self:hide()
    end
end

-- 停止计时器
function DirectorView:stop()
    -- self.labelSeconds_:hide()
    self:stopAllActions()
    transition.stopTarget(self)
end

return DirectorView
