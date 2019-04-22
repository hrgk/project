local BaseAlgorithm = import("app.games.csmj.utils.BaseAlgorithm")
local OperateCards = import(".OperateCards")
local OperateTiShi = class("OperateTiShi", function()
    return display.newSprite()
end)

function OperateTiShi:ctor(info)
    self.card_ = info.card
    self.cards_ = clone(info.cards)
    self.operate_ = info.operate
    table.insert(info.cards, info.card)
    BaseAlgorithm.sort(info.cards)
    for i,v in ipairs(info.cards) do
        local x = (i-1)*(-40) + 10
        local maJiang = OperateCards.new(v, 1):addTo(self)
        maJiang:setPositionX(x)
        if i == 4 then
            local x2 = -40 + 10
            maJiang:setPosition(x2, 10)
        end
    end
    self:setTouchEnabled(true)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self,self.onTouch_))
end

function OperateTiShi:onTouch_(event)
    if event.name == "began" then
        -- self:onTouchBegin_(event)
        return true
    elseif event.name == "moved" then
        -- self:onTouchMoved_(event)
        return true
    elseif event.name == "ended" then
        self:onTouchEnded_(event)
        return true
    end
end

function OperateTiShi:onTouchEnded_(event)
    local data = {card = self.card_, operateCards = self.cards_}
    if self.operate_ == 3 then
        display.getRunningScene():pengPai(data)
    elseif self.operate_ == 2 then
        display.getRunningScene():chiPai(data)
    elseif self.operate_ == 14 or self.operate_ == 13 or self.operate_ == 15 then
        display.getRunningScene():buPai(data, self.operate_)
    elseif self.operate_ == 6 then
        display.getRunningScene():gangPai(data, self.operate_)
    end
end

return OperateTiShi 
