local BaseView = class("BaseView", function ()
    local node = display.newNode()
    node:setNodeEventEnabled(true)
    node:setCascadeOpacityEnabled(true)
    return node
end)

return BaseView
