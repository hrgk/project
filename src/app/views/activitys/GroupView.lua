local GroupView = class("GroupView", gailun.BaseView)
GroupView.VERTICAL = 2
GroupView.HORIZONTAL = 1

function GroupView:ctor()
    self.selectIndex_ = 1
    self.gap_ = 30
    self.btnList_ = {}
end

function GroupView:setDirection(direction)
    self.direction_ = direction or GroupView.HORIZONTAL
end

function GroupView:setGap(gap)
    self.gap_ = gap
end

function GroupView:setSelectIndex(index)
    self:resetBtnState_()
    self.btnList_[index]:setButtonSelected(true)
    self.selectIndex_ = index
    if self.callBack_ then
        self.callBack_(self.selectIndex_)
    end
end

function GroupView:getSelectIndex()
    return self.selectIndex_
end

function GroupView:setCallback(callBack)
    self.callBack_ = callBack
end

function GroupView:resetBtnState_()
    for k,v in pairs(self.btnList_) do
        v:setButtonSelected(false)
    end
end

function GroupView:buttonClickHandler_(event)
    self:resetBtnState_()
    local btn = event.target 
    self.selectIndex_ = btn.index
    btn:setButtonSelected(true)
    if self.callBack_ then
        self.callBack_(self.selectIndex_)
    end
end

function GroupView:addButton(button)
    local offset = #self.btnList_ * self.gap_
    if self.direction_ == GroupView.HORIZONTAL then
        button:setPositionX(offset)
    elseif self.direction_ == GroupView.VERTICAL then
        button:setPositionY(offset)
    end
    button:onButtonClicked(handler(self, self.buttonClickHandler_))
    button.index = #self.btnList_ + 1
    table.insert(self.btnList_, button)
    self:addChild(button)
end

return GroupView 
