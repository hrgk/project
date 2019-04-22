local TYPES = gailun.TYPES

local adjsut_num = 0
local Nodes = {
    type = TYPES.ROOT,
    children = {
        {type = TYPES.SPRITE, filename = "res/images/majiang/game/direction_bg.png"},
        {type = TYPES.NODE, var = "nodeDirection_", children = {
            -- {type = TYPES.SPRITE, filename = "res/images/majiang/game/direction_bg1.png"},
            {type = TYPES.SPRITE, var = "spriteLightEast1_", filename = "res/images/majiang/game/direction_east1.png",  ap = {0.5, 0.5}},
            {type = TYPES.SPRITE, var = "spriteLightSouth1_", filename = "res/images/majiang/game/direction_south1.png",  ap = {0.5, 0.5}},
            {type = TYPES.SPRITE, var = "spriteLightWest1_", filename = "res/images/majiang/game/direction_west1.png",  ap = {0.5, 0.5}},
            {type = TYPES.SPRITE, var = "spriteLightNorth1_", filename = "res/images/majiang/game/direction_north1.png", y = adjsut_num, ap = {0.5, 0.5}},

            {type = TYPES.SPRITE, var = "spriteLightEast_", filename = "res/images/majiang/game/direction_east.png",  ap = {0.5, 0.5}},
            {type = TYPES.SPRITE, var = "spriteLightSouth_", filename = "res/images/majiang/game/direction_south.png", ap = {0.5, 0.5}},
            {type = TYPES.SPRITE, var = "spriteLightWest_", filename = "res/images/majiang/game/direction_west.png",  ap = {0.5, 0.5}},
            {type = TYPES.SPRITE, var = "spriteLightNorth_", filename = "res/images/majiang/game/direction_north.png", ap = {0.5, 0.5}},
        }},
        -- {type = TYPES.SPRITE, var = "spriteDian", filename = "res/images/majiang/game/direction_dian.png"},
        {type = TYPES.LABEL_ATLAS, var = "labelSeconds_", filename = "fonts/game_timer.png", options = {text="", w = 18, h = 32, startChar = "0"}, ap = {0.5, 0.5}},
    },
}

local DirectorView = class("DirectorView", gailun.BaseView)

DirectorView.ON_TICK = "ON_TICK"
DirectorView.TIMEOUT = "TIMEOUT"

local TICK_SECONDS = 1  -- 步进的单位时间

function DirectorView:ctor(table)
    cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()
    gailun.uihelper.render(self, Nodes)
    self.turnDirection_ = 0
    self:setScale(0.7)
end

function DirectorView:onEnter()
end

function DirectorView:onExit()
    gailun.EventUtils.clear(self)
    self:removeAllEventListeners()
end

-- 下右上左分别对应的需要旋转的角度
local directionAngels = {90, 180, -90, 0}
function DirectorView:turnDirection(direction)
    if direction == self.turnDirection_ then
        return
    end
    self.turnDirection_ = direction
    self.nodeDirection_:setRotation(0)
    self.nodeDirection_:setRotation(directionAngels[direction])
end

local directions = {"spriteLightSouth_", "spriteLightEast_", "spriteLightNorth_", "spriteLightWest_"}
function DirectorView:showLight(direction)
    self.lightIndex_ = direction
    if not directions[direction] then
        self:stopLightAnim_()
        return
    end
    for i,v in ipairs(directions) do
        local sprite = self[v]
        if sprite then
            sprite:setVisible(false)
            transition.stopTarget(sprite)
            if i == direction then
                self:lightAnim_(sprite)
            end
        end
    end
end

function DirectorView:lightAnim_(sprite)
    sprite:setVisible(true)
    local sequence = transition.sequence({ --按顺序来执行
        cc.FadeTo:create(0.4, 50),
        cc.FadeTo:create(0.4, 255),
        cc.DelayTime:create(0.2),
    })
    sprite:runAction(cc.RepeatForever:create(sequence))
end

function DirectorView:stopLightAnim_()
    for i,v in ipairs(directions) do
        local sprite = self[v]
        if sprite then
            sprite:setVisible(false)
            transition.stopTarget(sprite)
        end
    end
end

-- 倒计时
function DirectorView:start(direction, seconds)
    self:stop()
    -- self.labelSeconds_:show()
    local seconds = seconds or 0
    self:showLight(direction)
    self.seconds_ = seconds
    self:showLeftSeconds_(seconds)
    -- self:schedule(handler(self, self.tickByDeltaTime_), TICK_SECONDS)
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
    self:dispatchEvent({name = DirectorView.ON_TICK, leftSeconds = self.seconds_, lightIndex = self.lightIndex_})
    if self.seconds_ <= 0 then
        self:dispatchEvent({name = DirectorView.TIMEOUT})
    end
end

-- 停止计时器
function DirectorView:stop()
    self:stopLightAnim_()
    self.labelSeconds_:hide()
    self:stopAllActions()
    transition.stopTarget(self)
end

return DirectorView
