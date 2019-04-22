local BaseLayer = require("app.views.base.BaseDialog")
local HallJoinRoomView = class("HallJoinRoomView", BaseLayer)
local TYPES = gailun.TYPES
local nodes = {
    type = TYPES.ROOT, children = {
        {type = TYPES.SPRITE, filename = "res/images/hall.png", x = display.cx, y = display.cy},
        {type = TYPES.SPRITE,var = "fjbg_", filename = "res/images/sz_bg.png", ppx = 0.5, ppy = 0.5},
        {type = TYPES.SPRITE, filename = "res/images/common/grxx_title.png", ppx = 0.5, ppy = 0.88},
        {type = TYPES.SPRITE, filename = "res/images/create_room/jiarufanjian.png", ppx = 0.5, ppy = 0.885},
        {type = TYPES.LABEL, options = {text = "请输入房间号", size = 40, font = DEFAULT_FONT, color = cc.c4b(77, 36, 21, 255)} ,ppx = 0.5, ppy = 0.77 ,ap = {0.5,0.5}},
        {type = TYPES.SPRITE, filename = "res/images/create_room/fj_xk.png", children = {
            {type = TYPES.LABEL, var = "labelInputNum1", options = {text="", size = 58, font = DEFAULT_FONT, color = cc.c3b(181, 194, 196)}, ppx = 0.09, ppy = 0.5, ap = {0.5, 0.5}},
            {type = TYPES.LABEL, var = "labelInputNum2", options = {text="", size = 58, font = DEFAULT_FONT, color = cc.c3b(181, 194, 196)}, ppx = 0.25, ppy = 0.5, ap = {0.5, 0.5}},
            {type = TYPES.LABEL, var = "labelInputNum3", options = {text="", size = 58, font = DEFAULT_FONT, color = cc.c3b(181, 194, 196)}, ppx = 0.42, ppy = 0.5, ap = {0.5, 0.5}},
            {type = TYPES.LABEL, var = "labelInputNum4", options = {text="", size = 58, font = DEFAULT_FONT, color = cc.c3b(181, 194, 196)}, ppx = 0.58, ppy = 0.5, ap = {0.5, 0.5}},
            {type = TYPES.LABEL, var = "labelInputNum5", options = {text="", size = 58, font = DEFAULT_FONT, color = cc.c3b(181, 194, 196)}, ppx = 0.75, ppy = 0.5, ap = {0.5, 0.5}},
            {type = TYPES.LABEL, var = "labelInputNum6", options = {text="", size = 58, font = DEFAULT_FONT, color = cc.c3b(181, 194, 196)}, ppx = 0.91, ppy = 0.5, ap = {0.5, 0.5}},
        },ppx = 0.5, ppy = 0.68},
        {type = TYPES.BUTTON, var = "buttonClosed_", autoScale = 0.9, normal = "res/images/common/closebutton.png", 
        options = {}, ppx = 0.72, ppy = 0.87 },
        
    }
}


local nodeLabelAtlasTree = {
    type = TYPES.ROOT,
    children = {
        {type = TYPES.LABEL_ATLAS, filename = "fonts/jrfj_sz.png", options = {text= "1", w = 38, h = 55, startChar = "0"}, ppx = 0.5, ppy = 0.5, ap = {0.5, 0.5}},
    }
}

local nodeButtonTree = {
    type = TYPES.ROOT,
    children = {
        {type = TYPES.BUTTON, var = "buttonNum_", normal = "", autoScale = 0.9, options = {}, ppx = 1, ppy = 2}
    }
}

function HallJoinRoomView:ctor()
    HallJoinRoomView.super.ctor(self)
    self:addMaskLayer(self)
    gailun.uihelper.render(self,nodes)
    self.inputString_ = ""
    self:addButtonNums()
    self.buttonClosed_:onButtonClicked(handler(self,self.onClose_))
    self:androidBack()
    self.rootLayer:hide()
end

function HallJoinRoomView:addButtonNums()
    for i = 1 ,9 do
        self:createButton_(i)
    end
    self:createButton_(10)
    self:createButton_(11)
    self:createButton_(12)
end

function HallJoinRoomView:createButton_(num)
    nodeButtonTree.children[1].var = "buttonNum" .. num .. "_"
    nodeButtonTree.children[1].normal = self:caclueButtonBg_(num)
    local ppx , ppy = self:caclueButtonPercent_(num)
    nodeButtonTree.children[1].ppx = ppx
    nodeButtonTree.children[1].ppy = ppy
    gailun.uihelper.render(self, nodeButtonTree, self.rootLayer_)
    if num ~= 10 and num ~=12 then
        nodeLabelAtlasTree.children[1].options.text = num == 11 and 0 or num
        gailun.uihelper.render(self, nodeLabelAtlasTree, self["buttonNum" .. num .. "_"])
    end
    local function onTouchedEnded()
        self:onButtonNumClicked_(num)
    end
    gailun.uihelper.setTouchHandler(self["buttonNum" .. num .. "_"], onTouchedEnded)
end

function HallJoinRoomView:onResetAll_()
    self.inputString_ = ""
    self:showAllString_()
end

function HallJoinRoomView:onBackspace_()
    self.inputString_ = string.sub(self.inputString_, 1, string.len(self.inputString_) - 1)
    self:showAllString_()
end

function HallJoinRoomView:appendString_(num)
    self.inputString_ = self.inputString_ .. num
    self.inputString_ = string.sub(self.inputString_, 1, 6)
    self:showAllString_()
end

function HallJoinRoomView:showAllString_()
    assert(string.len(self.inputString_) <= 6)
    for i = 1, 6 do
        local char = string.sub(self.inputString_, i, i)
        self["labelInputNum".. i]:setString(char or '')
    end
end

function HallJoinRoomView:onNumberClicked_(num)
    local num = num == 11 and 0 or num
    self:appendString_(num)
    if string.len(self.inputString_) >= 6 then
        self:onNumberEnterFull_()
    end
end

function HallJoinRoomView:onButtonNumClicked_(num)
    if num == 12 then
        self:onBackspace_()
    elseif num == 10 then
        self:onResetAll_()
    else
        self:onNumberClicked_(num)
    end
end

function HallJoinRoomView:onNumberEnterFull_()
    local roomID = self.inputString_
    app:showLoading("正在进入房间，请稍候...", 0.5)
    dataCenter:sendEnterRoom(roomID)
end

function HallJoinRoomView:caclueButtonPercent_(num)
    local px = 0
    local py = 0
    local offsetX = -0.1
    local offsetY = -0.02
    if num == 10 then
        px = 0.765 + offsetX
        py = 0.56 + offsetY
        return px , py
    elseif num == 11 then
        px = 0.765 + offsetX
        py = 0.435 + offsetY
        return px , py
    elseif num == 12 then
        px = 0.765 + offsetX
        py = 0.31 + offsetY
        return px , py
    end
    if num % 3 == 1 then
        px = 0.435 + offsetX
    elseif num % 3 == 2 then
        px = 0.545 + offsetX
    elseif num% 3 == 0 then
        px = 0.655 + offsetX
    -- elseif num % 4 == 0 then
    --  px = 0.75 + offset
    end
    if math.floor((num - 1)/3) == 0 then
        py = 0.56 + offsetY
    elseif math.floor((num - 1)/3) == 1 then
        py = 0.435 + offsetY
    elseif math.floor((num - 1)/3) == 2 then
        py = 0.31 + offsetY
    end
    return px, py
end

function HallJoinRoomView:caclueButtonBg_(num)
    local buttonSprite = "res/images/create_room/fj_aj.png"
    if num == 12 then
        buttonSprite = "res/images/hall/resetnum.png"
    elseif num ==10 then
        buttonSprite = "res/images/hall/buttonDel.png"
    end
    return buttonSprite
end

function HallJoinRoomView:onClose_(event)
    display.getRunningScene():closeWindow()
    self:removeFromParent(true)
end

return HallJoinRoomView
