local BaseView = import(".BaseView")
local AlertWindow = class("AlertWindow", BaseView)
function AlertWindow:ctor(message, callback)
    AlertWindow.super.ctor(self)
    if message then
        self.msg_:setString(message)
    end
    self.callback_ = callback
end

function AlertWindow:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/alertView.csb"):addTo(self)
    self.csbNode_:setPosition(display.cx, display.cy)
end

function AlertWindow:agreeHandler_()
    if self.callback_ and 'function' == type(self.callback_) then
        self.callback_(true)
    end
    self:closeHandler_()
end

return AlertWindow 
