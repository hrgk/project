local TYPES = gailun.TYPES

local adjsut_num = 0
local Nodes = {
    type = TYPES.ROOT,
    children = {
        {type = TYPES.SPRITE, filename = "res/images/majiang/game/2D/direction_bg.png"},
        {type = TYPES.NODE, var = "nodeDirection_", children = {
            {type = TYPES.SPRITE, var = "spriteLightEast_", filename = "res/images/majiang/game/2D/direction_east.png",  ap = {0.5, 0.5}},
            {type = TYPES.SPRITE, var = "spriteLightSouth_", filename = "res/images/majiang/game/2D/direction_south.png", ap = {0.5, 0.5}},
            {type = TYPES.SPRITE, var = "spriteLightWest_", filename = "res/images/majiang/game/2D/direction_west.png",  ap = {0.5, 0.5}},
            {type = TYPES.SPRITE, var = "spriteLightNorth_", filename = "res/images/majiang/game/2D/direction_north.png", ap = {0.5, 0.5}},
        }},
        -- {type = TYPES.SPRITE, var = "spriteDian", filename = "res/images/majiang/game/direction_dian.png"},
        -- {type = TYPES.LABEL_ATLAS, var = "labelSeconds_", filename = "fonts/game_timer.png", options = {text="", w = 18, h = 32, startChar = "0"},y = 10, ap = {0.5, 0.5}},
    },
}

local Director2DView = class("Director2DView", gailun.BaseView)

Director2DView.ON_TICK = "ON_TICK"
Director2DView.TIMEOUT = "TIMEOUT"

local TICK_SECONDS = 1  -- 步进的单位时间

function Director2DView:ctor(table)
    cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()
    gailun.uihelper.render(self, Nodes)
    self.turnDirection_ = 0
    --self:setPositionY(self:getPositionY()-20)
end

function Director2DView:onEnter()
end

function Director2DView:onExit()
    gailun.EventUtils.clear(self)
    self:removeAllEventListeners()
end

-- 下右上左分别对应的需要旋转的角度
local directionAngels = {90, 180, -90, 0}
function Director2DView:turnDirection(direction)
    if direction == self.turnDirection_ then
        return
    end
    self.turnDirection_ = direction
    self.nodeDirection_:setRotation(0)
    self.nodeDirection_:setRotation(directionAngels[direction])
end

local directions = {"spriteLightSouth_", "spriteLightEast_", "spriteLightNorth_", "spriteLightWest_"}
function Director2DView:showLight(direction)
    print("============showLight==================",direction)
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

function Director2DView:lightAnim_(sprite)
    sprite:setVisible(true)
    local sequence = transition.sequence({ --按顺序来执行
        cc.FadeTo:create(0.4, 50),
        cc.FadeTo:create(0.4, 255),
        cc.DelayTime:create(0.2),
    })
    sprite:runAction(cc.RepeatForever:create(sequence))
end

function Director2DView:stopLightAnim_()
    for i,v in ipairs(directions) do
        local sprite = self[v]
        if sprite then
            sprite:setVisible(false)
            transition.stopTarget(sprite)
        end
    end
end

-- 倒计时
function Director2DView:start(direction, seconds, playerCount)
    self:stop()
    -- self.labelSeconds_:show()
    local seconds = seconds or 0
    self:showLight(direction)
    self.seconds_ = seconds
    -- self:showLeftSeconds_(seconds)
    -- self:schedule(handler(self, self.tickByDeltaTime_), TICK_SECONDS)
end

function Director2DView:showLeftSeconds_(seconds)
    -- local str = string.format("%02d", math.round(seconds or 0))
    -- self.labelSeconds_:setString(str)
end

function Director2DView:tickByDeltaTime_()
    self.seconds_ = self.seconds_ - TICK_SECONDS
    local showSeconds = self.seconds_
    showSeconds = math.max(showSeconds, 0)
    self:showLeftSeconds_(showSeconds)
    self:dispatchEvent({name = Director2DView.ON_TICK, leftSeconds = self.seconds_, lightIndex = self.lightIndex_})
    if self.seconds_ <= 0 then
        self:dispatchEvent({name = Director2DView.TIMEOUT})
    end
end

-- 停止计时器
function Director2DView:stop()
    self:stopLightAnim_()
    -- self.labelSeconds_:hide()
    self:stopAllActions()
    transition.stopTarget(self)
end

return Director2DView
