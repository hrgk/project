local BaseItem = class("BaseItem", nil)

function BaseItem:ctor()
    self.buttonHandlerList_ = {}
    self.itemScale = 1
    -- self:loaderCsb()
    -- self:initElement_()
end

function BaseItem:setNode(node)
    self.csbNode_ = node
    self:initElement_()
    self:initOtherView_()
end

function BaseItem:initOtherView_()

end

function BaseItem:hideOtherView_()
    
end

function BaseItem:loaderCsb()

end

function BaseItem:initElementRecursive_(parent, deep)
    deep = deep or 1
    if not parent or deep > 5 then
        return
    end
    
    local findNode
    local children = parent:getChildren()
    local childCount = parent:getChildrenCount()
    print("childCount",childCount)
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

function BaseItem:initNode(node)
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
        print("vInfo",vInfo[2])
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

function BaseItem:initElement_()
    if self.csbNode_ == nil then return end
    for k,v in pairs(self.csbNode_:getChildren()) do
        self:initNode(v)
    end
end

function BaseItem:buttonRegister(target, func)
    target:addTouchEventListener(handler(self, self.onTouchHandler_))
    self.buttonHandlerList_[target:getName()] = func
end

function BaseItem:onTouchHandler_(sender, eventType)
    local  button = sender
    if  eventType == 0 then
        gameAudio.playSound("sounds/common/sound_button_click.mp3")
        button:scale(button.currScale * button.offScale)
    elseif eventType == 2 then
        button:scale(button.currScale)
        if self.buttonHandlerList_[button:getName()] then
            self.buttonHandlerList_[button:getName()](sender)
        end
    elseif eventType == 3 then
        button:scale(button.currScale)
    end
end

function BaseItem:closeHandler_()
    self:removeSelf()
end

return BaseItem 
