local BaseView = import("app.views.BaseView")
local FanKuiView = class("FanKuiView", BaseView)
function FanKuiView:ctor()
    FanKuiView.super.ctor(self)
end

function FanKuiView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/fanKuiView.csb"):addTo(self)
    self.csbNode_:setPosition(display.cx, display.cy)
end

function FanKuiView:sendHandler_()
    local params = {}
    if self.inputPhone_:getString() == "" then
        return app:showTips("手机号不能为空")
    end
    if self.inputYJ_:getString() == "" then
        return app:showTips("意见不能为空")
    end
    params.content = self.inputPhone_:getString()
    params.phone = self.inputYJ_:getString()
    httpMessage.requestClubHttp(params, httpMessage.FEED_BACK)
    self:closeHandler_()
end

return FanKuiView 
