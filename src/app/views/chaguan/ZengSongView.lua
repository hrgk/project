local BaseView = import("app.views.BaseView")
local ZengSongView = class("ZengSongView", BaseView)
function ZengSongView:ctor(data,callback)
    self.data_ = data
    self.callback_ = callback
    ZengSongView.super.ctor(self)
    self.isOpen = false
    -- self.input1_:setReturnType(cc.KEYBOARD_RETURNTYPE_SEND) 
    -- self.input2_:setReturnType(cc.KEYBOARD_RETURNTYPE_SEND) 
end

function ZengSongView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/julebu/zengSongView.csb"):addTo(self)
    self.csbNode_:setPosition(display.cx, display.cy)
end

function ZengSongView:queDingHandler_()
    if self.input1_:getString() == "" then
        return app:showTips("赠送数量不能为空")
    end
    if self.input2_:getString() ~= self.input1_:getString() then
        return app:showTips("确认数量与赠送数量不相等")
    end
    if self.callback_ then
        self.callback_()
    end
    local count = tonumber(self.input1_:getString())
    display.getRunningScene():zengSongDouZi(count,self.data_.uid)
    self:closeHandler_()
end

function ZengSongView:moveToRight()
    transition.moveTo(self.csbNode_, {x=display.cx + 300, time = 0.2})
end

return ZengSongView  
