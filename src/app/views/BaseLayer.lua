local BaseLayer = class("BaseLayer", function()
    return display.newColorLayer(cc.c4b(0, 0, 0, 0))
end)

BaseLayer.CLOSE_EVENT = "CLOSE_EVENT"

-- 此类不能直接使用，必须继承后，初始化UI相关元素后才可以用
function BaseLayer:ctor()
    self:setNodeEventEnabled(true)
    cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()
end

function BaseLayer:addMaskLayer(parent, opacity)
    assert(parent ~= nil, "maskLayer parent can not be nil!")
    self.maskLayer_ = display.newColorLayer(cc.c4b(0, 0, 0, opacity))
    parent:addChild(self.maskLayer_)
end

function BaseLayer:onClose_(event)
    self:dispatchEvent({name = BaseLayer.CLOSE_EVENT})
end

function BaseLayer:androidBack()
    self:setKeypadEnabled(true)
    self:addNodeEventListener(cc.KEYPAD_EVENT, function (event)
        if event.key == "back" then
            self:onClose_(event)
        end
    end)
end

return BaseLayer
