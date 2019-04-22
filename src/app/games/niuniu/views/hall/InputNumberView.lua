local BaseLayer = require("app.views.base.BaseDialog")
local InputNumberView = class("InputNumberView", BaseLayer)

function InputNumberView:ctor(msg)
    InputNumberView.super.ctor(self)
    local layer = display.newColorLayer(cc.c4b(0, 0, 0, 0))
    layer:pos(- display.cx, - display.cy)
    layer:setNodeEventEnabled(true)
    self:addChild(layer)
    local back = display.newScale9Sprite("res/images/jrfj_bj.png", 0, 0, cc.size(900,530))
    back:setScaleX(0.75)
    self:addChild(back)
    self.numberBack_ = display.newSprite("res/images/create_room/fj_xk.png")
    self.numberBack_:setPositionY(120)
    self:addChild(self.numberBack_)
    self.messageLabel_ = gailun.uihelper.createLabel({options = {text = msg, size = 40, font = DEFAULT_FONT, color = cc.c4b(77, 36, 21, 0)}, visible = true})
    :addTo(self)
    self.messageLabel_:setAnchorPoint(0.5, 0.5)
    :pos(0, 180)
    self:addButtonNums_()
    self:createCloseButton_()
    self.count_ = 0
    self:initInputNumberTxt_()
    self:androidBack()
    self.rootLayer:hide()
    self.maskLayer_:hide()
end

function InputNumberView:createCloseButton_()
    gailun.uihelper.createButton({autoScale = 0.9, normal = "res/images/common/closebutton.png", options = {}, ppx = 0.065, ppy = 0.93})
    :onButtonPressed(function(event)
        local btn = event.target 
        btn:setScale(0.9)
    end)
    :onButtonClicked(function(event)
        self:removeFromParent(true)
    end)
    :onButtonRelease(function(event)
        local btn = event.target 
        btn:setScale(1)
    end)
    :align(display.LEFT_CENTER)
    :addTo(self)
    :pos(280, 260)
end

function InputNumberView:onClose_()
    self:removeFromParent(true)
    display.getRunningScene():closeWindow()
end

function InputNumberView:initInputNumberTxt_()
    self.inputNumberList_ = {}
    for i=1,6 do
        local txt = cc.ui.UILabel.new({UILabelType = 2, text = "", size = 40, color = cc.c3b(77, 36, 21)})
        :addTo(self)
        :setAnchorPoint(0.5, 0.5)
        :pos((i - 1) * 90 - 220, 120)
        table.insert(self.inputNumberList_, txt)
    end
end

function InputNumberView:clearNumber_()
    self.count_ = 0
    for i=1,6 do
        self.inputNumberList_[i]:setString("")
    end
end

function InputNumberView:delNumber_()
    if self.count_ >= 0 then
        self.inputNumberList_[self.count_ + 1]:setString("")
    end
end

function InputNumberView:creatNumberButton_(num)
    local x, y = self:caclueButtonPercent_(num)
    local numberButtonContent = display.newSprite():addTo(self):pos(x, y)
    local skin = self:caclueButtonBg_(num)
    cc.ui.UIPushButton.new({normal = skin}, {scale9 = true})
        :onButtonPressed(function(event)
            numberButtonContent:setScale(0.9)
        end)
        :onButtonClicked(function(event)
            numberButtonContent:setScale(1)
            self:clickButtonHandler_(num)
        end)
        :align(display.LEFT_CENTER)
        :setAnchorPoint(0.5, 0.5)
        :addTo(numberButtonContent)
    if num == 11 then num = 0 end
    if num == 12 then return end
    if num == 10 then return end
    local txt = cc.LabelAtlas:_create()
    txt:initWithString(num, "fonts/jrfj_sz.png", 38, 56, string.byte("0"))
    txt:setAnchorPoint(0.5, 0.5)
    numberButtonContent:addChild(txt)
end

function InputNumberView:clickButtonHandler_(num)
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
    if self.inputNumberList_[self.count_] then
        self.inputNumberList_[self.count_]:setString(num)
    end
    if self.count_ >= 6 then 
        self.count_ = 6 
        if self.callfunc_ then
            self.callfunc_(self:tableToString_())
        end     
    end
end

function InputNumberView:tableToString_()
    local str = ""
    for i,v in ipairs(self.inputNumberList_) do
        str = str .. v:getString()
    end
    return str
end

function InputNumberView:setCallback(callfunc)
    self.callfunc_ = callfunc
end

function InputNumberView:setNumberInputCallback(callfunc)
    self.numberInput_ = callfunc
end

function InputNumberView:addButtonNums_()
    for i = 1,9 do
        self:creatNumberButton_(i)
    end
    self:creatNumberButton_(10)
    self:creatNumberButton_(11)
    self:creatNumberButton_(12)
end

function InputNumberView:caclueButtonPercent_(num)
    local x = 0
    local y = 0
    local offsetX = -12
    local offsetY = 65
    if num == 10 then
        x = 220 + offsetX
        y = 100 - offsetY
        return x , y
    elseif num == 11 then
        x = 220 + offsetX
        y = 0 - offsetY
        return x , y
    elseif num == 12 then
        x = 220 + offsetX
        y = -100 - offsetY
        return x , y
    end
    if num % 3 == 1 then
        x = -200 + offsetX
    elseif num % 3 == 2 then
        x = -60 + offsetX
    elseif num% 3 == 0 then
        x = 80 + offsetX
    -- elseif num % 4 == 0 then
    --  x = 0.75 + offset
    end
    if math.floor((num - 1) / 3) == 0 then
        y = 100 - offsetY
    elseif math.floor((num - 1) / 3) == 1 then
        y = 0 - offsetY
    elseif math.floor((num - 1) /3 ) == 2 then
        y = -100 - offsetY
    end
    return x, y
end

function InputNumberView:caclueButtonBg_(num)
    local buttonSprite = "res/images/create_room/fj_aj.png"
    if num == 12 then
        buttonSprite = "res/images/hall/resetnum.png"
    elseif num == 10 then
        buttonSprite = "res/images/hall/buttonDel.png"
    end
    return buttonSprite
end

return InputNumberView 
