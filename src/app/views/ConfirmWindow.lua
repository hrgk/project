local BaseView = import(".BaseView")
local ConfirmWindow = class("ConfirmWindow", BaseView)
function ConfirmWindow:ctor(message, callback)
    ConfirmWindow.super.ctor(self)
    if message then
        self.msg_:setString(message)
    end
    self.callback_ = callback
end

function ConfirmWindow:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/confirmWindow.csb"):addTo(self)
    self.csbNode_:setPosition(display.cx, display.cy)
end

function ConfirmWindow:quitGameHandler_()
    if self.callback_ and 'function' == type(self.callback_) then
        self.callback_(true)
    end
    self:onClose_()
end

function ConfirmWindow:playHandler_()
    if self.callback_ and 'function' == type(self.callback_) then
        self.callback_(false)
    end
    self:onClose_()
end

function ConfirmWindow:onClose_(event)
    self.callback_ = nil
    if tolua.isnull(self) then
        return
    end
    self:removeFromParent()
end

return ConfirmWindow
