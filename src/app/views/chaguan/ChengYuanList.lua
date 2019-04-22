local BaseElement = import("app.views.BaseElement")
local MemberListItem = import("app.views.chaguan.MemberListItem")
local ChengYuanList = class("ChengYuanList", function()
        return display.newSprite()
    end)

function ChengYuanList:ctor(data,type)
    self.data_ = data
    self.type = type
    self:initChengYuanItem_()
    self:setAnchorPoint(cc.p(0, 1))
end

function ChengYuanList:update(data)
    self.data_ = data
    self:removeAllChildren()
    self:initChengYuanItem_()
end

function ChengYuanList:initChengYuanItem_()
    self.chengYuanList_ = {}
    
    local length = #self.data_
    local height = 500
    local width = 800
    local margin = 90

    local length = #self.data_

    local height = length * 100
    local width = 450

    self:setContentSize(cc.size(width, height))

    if self.type == 2 then
        margin = 100
    end
    for i = 0, length - 1 do
        local line, column = math.ceil((i + 1) / 1), i % 1
        local x, y = column * 110 , height - line * margin
        local item = MemberListItem.new(self.data_[i+1], self.type, #self.data_)
        item:setPosition(x, y)
        self:addChild(item)
        table.insert(self.chengYuanList_, item)
    end
end

return ChengYuanList 
