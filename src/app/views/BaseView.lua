local BaseView = class("BaseView", function()
    return display.newSprite()
end)

function BaseView:ctor()
    self.buttonHandlerList_ = {}
    self:loaderCsb()
    self.scaleY = display.height  / DESIGN_HEIGHT
    self.scaleX = display.width / DESIGN_WIDTH
    self.itemScale = 1
    self.backScale = 1
    self:initElement_()
end

function BaseView:setMask(operate, isSwallow)
    isSwallow = isSwallow == nil or isSwallow == true
    local maskLayer = display.newColorLayer(cc.c4b(0, 0, 0, operate))
    self:addChild(maskLayer, -1)
    self:performWithDelay(function()
        local layout = ccui.Layout:create()
        layout:setContentSize(cc.size(display.width, display.height))
        layout:setTouchEnabled(true)
        layout:setSwallowTouches(isSwallow)
        self:addChild(layout, -1)
        end, 0)
end

function BaseView:loaderCsb()

end

function BaseView:tanChuang(num, isSwallow)
    self:setMask(num or 100)
    -- self.csbNode_:scale(0)
    if self.csbNode_ then
        self.csbNode_:zorder(100)
    end
    -- transition.scaleTo(self.csbNode_, {scale = 1, time = 0.5, easing = "backOut"})
end

function BaseView:initElementRecursive_(parent, deep)
    deep = deep or 1
    if not parent or deep > 5 then
        return
    end
    
    local findNode
    local children = parent:getChildren()
    local childCount = parent:getChildrenCount()
    if childCount < 1 then
        return
    end
    for i=1, childCount do
        if "table" == type(children) then
            parent = children[i]
        elseif "userdata" == type(children) then
            parent = children:objectAtIndex(i - 1)
        end

        self:initNode(parent)
    end

    for i=1, childCount do
        if "table" == type(children) then
            parent = children[i]
        elseif "userdata" == type(children) then
            parent = children:objectAtIndex(i - 1)
        end

        self:initElementRecursive_(parent, deep + 1)
    end

    return
end

function BaseView:initElement_()
    if self.csbNode_ == nil then return end
    if self.scaleX > self.scaleY then
        self.itemScale = self.scaleY
        self.backScale = self.scaleX
    else
        self.itemScale = self.scaleX
        self.backScale = self.scaleY
    end
    for k,v in pairs(self.csbNode_:getChildren()) do
        local x, y = v:getPosition()
        self:initNode(v)
        if itemType == "back" then   
            print("========itemType=========")
            v:setScale(self.backScale)
        else
            v:setScale(self.itemScale)
        end
        v:setPosition(x * self.itemScale, y*self.itemScale)
    end
end

function BaseView:initNode(node)
    local vInfo = string.split(node:getName(), "_")
    local itemName
    if vInfo[2] then
        itemName =  vInfo[2] .. "_"
        self[itemName] = node
    else
        return
    end

    local itemType = vInfo[1]
    if itemType == "btn" or itemType == "checkBox" then
        node.currScale = self.itemScale
        node:setScale(self.itemScale)
        self.buttonScale_ = node:getScale()
        local funcName = vInfo[2].."Handler_"
        if self[funcName] then
            self:buttonRegister(node, handler(self, self[funcName]))
        end
        if vInfo[3] == "ns" then
            node.sound = "ns"
            node.offScale = 1
        else
            node.offScale = 0.9
        end
    end
end

function BaseView:buttonRegister(target, func)
    target:addTouchEventListener(handler(self, self.onTouchHandler_))
    self.buttonHandlerList_[target:getName()] = func
end

function BaseView:onTouchHandler_(sender, eventType)
    local  button = sender
    if  eventType == 0 then
        gameAudio.playSound("sounds/common/sound_button_click.mp3")
        -- button:scale(self.buttonScale_ * button.offScale)
        transition.scaleTo(button, {scale = button.offScale, time = 0.1})
    elseif eventType == 2 then
        -- button:scale(button.currScale)
        self:performWithDelay(function()
            transition.scaleTo(button, {scale = self.buttonScale_, time = 0.1})
            if self.buttonHandlerList_[button:getName()] then
                self.buttonHandlerList_[button:getName()](sender)
            end
            end, 0.1)
    elseif eventType == 3 then
        -- button:scale(self.buttonScale_)
        self:performWithDelay(function()
            transition.scaleTo(button, {scale = self.buttonScale_, time = 0.1})
            end, 0.2)
    end
end

function BaseView:closeHandler_()
    self:removeSelf()
end

return BaseView 
