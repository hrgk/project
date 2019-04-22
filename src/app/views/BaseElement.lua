local BaseElement = class("BaseElement", function()
        return display.newSprite()
    end)

function BaseElement:ctor()
    self.buttonHandlerList_ = {}
    self:loaderCsb()
    self:initElement_()

    self.itemScale = 1
    self.backScale = 1
end

function BaseElement:loaderCsb()

end

function BaseElement:initElementRecursive_(parent, deep)
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

function BaseElement:initNode(node)
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

function BaseElement:initElement_()
    if self.csbNode_ == nil then return end
    for k,v in pairs(self.csbNode_:getChildren()) do
        local vInfo = string.split(v:getName(), "_")
        local itemName
        if vInfo[2] then
            itemName = vInfo[2] .. "_"
            self[itemName] = v
        end
        local itemType = vInfo[1]
        if itemType == "btn" or itemType == "checkBox"  then
            v.currScale = 1
            local funcName = vInfo[2].."Handler_"
            if self[funcName] then
                self:buttonRegister(v, handler(self, self[funcName]))
            end
            if vInfo[3] == "ns" then
                v.sound = "ns"
                v.offScale = 1
            else
                v.offScale = 0.9
            end
        end
    end
end

function BaseElement:buttonRegister(target, func)
    target:addTouchEventListener(handler(self, self.onTouchHandler_))
    self.buttonHandlerList_[target:getName()] = func
end

function BaseElement:onTouchHandler_(sender, eventType)
    local button = sender
    local position = button:getPosition()
    if eventType == 0 then
        local worldPos = button:getParent():convertToWorldSpace(cc.p(0, 0))
        button.startPos = worldPos
    
        button:scale(button.currScale * button.offScale)
    elseif eventType == 2 then
        button:scale(button.currScale)
        gameAudio.playSound("sounds/common/sound_button_click.mp3")

        if self.buttonHandlerList_[button:getName()] then
            local worldPos = button:getParent():convertToWorldSpace(cc.p(0, 0))
            if button.startPos == nil then
                return
            end

            if gailun.utils.distance(worldPos, button.startPos) > 30 then
                return
            end

            self.buttonHandlerList_[button:getName()](sender)
        end
    elseif eventType == 3 then
        button:scale(button.currScale)
    end
end

function BaseElement:closeHandler_()
    self:removeSelf()
end

return BaseElement 
