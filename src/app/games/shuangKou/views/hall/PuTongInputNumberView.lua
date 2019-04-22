local InputNumberView = import("app.views.hall.InputNumberView")
local PuTongInputNumberView = class("PuTongInputNumberView", InputNumberView)

function PuTongInputNumberView:ctor(msg)
    PuTongInputNumberView.super.ctor(self)
    self.numberBack_:removeFromParent()
    self.numberBack_ = display.newSprite("#input_num_back.png")
    self.numberBack_:setPosition(-70, 120)
    self:addChild(self.numberBack_)
    self.messageLabel_:setPositionX(-70)
    self.messageLabel_:setString(msg)
    self:createQuerenButton_()
end

function PuTongInputNumberView:createQuerenButton_()
    local btn = cc.ui.UIPushButton.new({normal = "#input_queren_btn.png"})
    btn:onButtonClicked(function(event)
            if self.callfunc_ then
                self.callfunc_(self:tableToString_())
            end 
        end)
    btn:onButtonPressed(function(event)
        btn:scale(0.9)
        end)
    btn:onButtonRelease(function(event)
        local btn = event.target 
        btn:setScale(1)
    end)
    btn:setPosition(210, 120)
    self:addChild(btn)
end

function PuTongInputNumberView:clearNumber_()
    self.count_ = 0
    for i=1,13 do
        self.inputNumberList_[i]:setString("")
    end
end

function PuTongInputNumberView:clickButtonHandler_(num)
    if self.numberInput_ then
        self.numberInput_(num)
    end
    if num == 11 then num = 0 end
    if num == 10 then 
        self:clearNumber_() 
        return 
    end
    if num == 12 then 
        self.count_ = self.count_ - 1
        if self.count_ <= 0 then self.count_ = 0 end
        self:delNumber_()  
        return 
    end
    self.count_ = self.count_ + 1
    if self.count_ >= 13 then 
        self.count_ = 13 
    end
    self.inputNumberList_[self.count_]:setString(num)
end

function PuTongInputNumberView:initInputNumberTxt_()
    self.inputNumberList_ = {}
    for i=1,13 do
        local txt = cc.ui.UILabel.new({UILabelType = 2, text = "", size = 40, color = cc.c3b(77, 36, 21)})
        :setAnchorPoint(0.5, 0.5)
        :pos((i - 1) * 25 - 220, 120)
        table.insert(self.inputNumberList_, txt)
        self:addChild(txt, 1)
    end
end

return PuTongInputNumberView 
