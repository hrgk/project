local JWSlider = class("JWSlider", function ()
    return display.newNode()
end)

local uihelper = import(".uihelper")

JWSlider.PERCENT_CHANGED_EVENT = "PERCENT_CHANGED_EVENT"

--[[
options 可以有以下值
bg: 背景图片
scale9: 背景图片的缩放
capInsets: 背景图片的九宫格区
direction: timer的移动方向
percent: 初始百分比
bar: 进度条图片
button: 滑块按钮图片
buttonMargin: number 滑块与最大最小坐标之间的间隙像素
]]
function JWSlider:ctor(options)
    cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()

    assert(options.bar and options.button, "bar and button must be set.")
    options.progressType = display.PROGRESS_TIMER_BAR  -- 由于是slider，所以固定为长条形
    if options.bg then
        local params = {filename = options.bg, options = {scale9 = options.scale9, capInsets = options.capInsets}}
        uihelper.createSprite(params):addTo(self)
    end

    self.direction_ = options.direction or display.LEFT_TO_RIGHT
    self.progress_ = uihelper.createProgressTimer(options):addTo(self)
    self.spriteBar_ = display.newSprite(options.button):addTo(self)
    self.buttonMargin_ = options.buttonMargin or 0

    self:initTouch_()
    self:setPercentageView_(options.percent or 0, false)
end

function JWSlider:getBarPositionByPercent_(percent)
    local size = self.progress_:getContentSize()
    local height = size.height - 2 * self.buttonMargin_
    local width = size.width - 2 * self.buttonMargin_
    local percent = math.min(percent, 100)
    percent = math.max(0, percent)
    percent = percent / 100
    if self.direction_ == display.BOTTOM_TO_TOP then
        return 0, percent * height - height / 2
    elseif self.direction_ == display.TOP_TO_BOTTOM then
        return 0, (percent * height - height / 2) * -1
    elseif self.direction_ == display.LEFT_TO_RIGHT then
        return percent * width - width / 2, 0
    elseif self.direction_ == display.RIGHT_TO_LEFT then
        return (percent * width - width / 2) * -1, 0
    end
    return 0, 0
end

function JWSlider:getPercentByPosition_(touchX, touchY)
    local size = self.progress_:getContentSize()
    local visibleHeight = size.height - 2 * self.buttonMargin_
    local visibleWidth = size.width - 2 * self.buttonMargin_
    local p = self.progress_:convertToNodeSpace(cc.p(touchX, touchY))
    local x, y = p.x, p.y
    y = math.min(size.height - self.buttonMargin_, y)
    y = math.max(self.buttonMargin_, y)
    x = math.min(size.width - self.buttonMargin_, x)
    x = math.max(self.buttonMargin_, x)
    y = y - self.buttonMargin_
    x = x - self.buttonMargin_
    if self.direction_ == display.BOTTOM_TO_TOP then
        return math.round(y / visibleHeight * 100)
    elseif self.direction_ == display.TOP_TO_BOTTOM then
        return math.round((1 - y / visibleHeight) * 100)
    elseif self.direction_ == display.LEFT_TO_RIGHT then
        return math.round(x / visibleWidth * 100)
    elseif self.direction_ == display.RIGHT_TO_LEFT then
        return math.round((1 - x / visibleWidth) * 100)
    end
    return 0
end

function JWSlider:getPercentage()
    return self.progress_:getPercentage()
end

function JWSlider:getBarPosition()
    return self:convertToWorldSpace(cc.p(self.spriteBar_:getPosition()))
end

function JWSlider:setPercentage(percent, eventName)
    self:stopMove_()
    if self.progress_:getPercentage() == percent and not eventName then
        return
    end
    self:setPercentageView_(percent, eventName ~= 'moved')
    self:dispatchEvent({name = JWSlider.PERCENT_CHANGED_EVENT, percent = percent, source = eventName})
    return self
end

function JWSlider:stopMove_()
    transition.stopTarget(self.spriteBar_)
    transition.stopTarget(self.progress_)
end

function JWSlider:setPercentageView_(percent, withAction)
    local x, y = self:getBarPositionByPercent_(percent)
    self.progress_:setPercentage(percent)
    self.spriteBar_:pos(x, y)
    return self
end

function JWSlider:onPercentChanged(callback)
    return self:addEventListener(JWSlider.PERCENT_CHANGED_EVENT, callback)
end

function JWSlider:initTouch_()
    self.progress_:setTouchEnabled(true)
    self.progress_:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self.onProgressTouched_))

    self.spriteBar_:setTouchEnabled(true)
    self.spriteBar_:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self.onBarTouched_))
end

function JWSlider:onProgressTouched_(event)
    if event.name == "began" then
        self:onProgressTouching_(event)
        return true
    else
        return self:onProgressTouching_(event)
    end
end

function JWSlider:onBarTouched_(event)
    if event.name == "began" then
        self:onBarTouching_(event)
        return true
    else
        return self:onBarTouching_(event)
    end
end

function JWSlider:onProgressTouching_(event)
    self:setPercentage(self:getPercentByPosition_(event.x, event.y), event.name)
end

function JWSlider:onBarTouching_(event)
    self:setPercentage(self:getPercentByPosition_(event.x, event.y), event.name)
end

return JWSlider
