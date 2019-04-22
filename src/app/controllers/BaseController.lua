local BaseController = class("BaseController", function()
    local node = display.newNode()
    node:setNodeEventEnabled(true)
    return node
end)

function BaseController:ctor()
    
end

return BaseController