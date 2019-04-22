local PokerList = import(".PokerList")
local HandPokerList = class("HandPokerList", PokerList)
local POKER_WIDTH = 118
local POKER_HEIGHT = 164
local SELECTED_HEIGHT = 40

function HandPokerList:ctor()
    HandPokerList.super.ctor(self)
    self:setTouchEnabled(true)
    self:setTouchSwallowEnabled(false)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self.onTouch_))
end

function HandPokerList:isInPokers_(x, y)
    local nodes = self:getChildren()
    for _,v in ipairs(nodes) do
        if cc.rectContainsPoint(v:getCascadeBoundingBox(), cc.p(x, y)) then
            return true
        end
    end
    return false
end

function HandPokerList:onTouch_(event)
    if event.name == "began" then
        self:onTouchBegin_(event)
    elseif event.name == "moved" then
        self:onTouchMoved_(event)
    elseif event.name == "ended" then
        self:onTouchEnded_(event)
    end
    return true
end

function HandPokerList:onTouchBegin_(event)
    if self.isInReView_ then return end
    self.touchInPokers_ = self:isInPokers_(event.x, event.y)
    if not self.touchInPokers_ then
        return
    end
    self.startTouchX_ = event.x
    self.endTouchX_ = event.x
    self:pickUpPokers_()
end

function HandPokerList:onTouchMoved_(event)
    if self.isInReView_ then return end
    if not self.touchInPokers_ then
        return
    end
    self.endTouchX_ = event.x
    self:pickUpPokers_()
end

function HandPokerList:onTouchEnded_(event)
    if self.isInReView_ then return end
    if not self.touchInPokers_ then
        return
    end
    self.endTouchX_ = event.x
    self:pickUpPokers_()
    self:popUpPokers_()
end

function HandPokerList:popUpPokers_(pokers)
    local nodes = self:getChildren()
    local seconds = 0.1
    for _,v in ipairs(nodes) do
        if v:isHighLight() then
            local y = SELECTED_HEIGHT
            v:setHighLight(false)
            if v:isSelected() then
                v:setSelected(false)
                y = -y
                transition.moveBy(v, {y = y, time = seconds})
            else
                if pokers then
                    if self:isHasPoker_(pokers, v) then
                        v:setSelected(true)
                        transition.moveBy(v, {y = y, time = seconds})
                    else
                        v:setSelected(false)
                    end
                else
                    v:setSelected(true)
                    transition.moveBy(v, {y = y, time = seconds})
                end
            end
        end
    end
end

function HandPokerList:pickUpPokers_()
    local nodes = self:getChildren()
    for i,v in ipairs(nodes) do
        local x1, x2 = self:calcPokerBorder_(v, #nodes, i)
        local flag = self:inTouchRange_(x1, x2)
        v:setHighLight(flag)
    end
end

-- 判断扑克牌是否处于触摸范围内
function HandPokerList:inTouchRange_(leftX, rightX)
    local startX = math.min(self.startTouchX_, self.endTouchX_)
    local endX = math.max(self.startTouchX_, self.endTouchX_)
    return (leftX >= startX and leftX <= endX) or 
            (rightX >= startX and rightX <= endX) or 
            (startX >= leftX and startX <= rightX) or 
            (endX >= leftX and endX <= rightX)
end

-- 计算牌的左右边界
function HandPokerList:calcPokerBorder_(poker, total, index)
    local ccret = poker:getCascadeBoundingBox()
    local leftX = ccret.origin.x
    local rightX = leftX + self.margin_
    if index == total then
        rightX = leftX + POKER_WIDTH
    end
    return leftX, rightX
end

return HandPokerList 
