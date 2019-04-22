local BaseView = import("app.views.BaseView")
local AddMemberView = class("AddMemberView", BaseView)
function AddMemberView:ctor(msg, callback)
    AddMemberView.super.ctor(self)
    self.msg_:setString(msg)
    self.callback_ = callback
end

function AddMemberView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/julebu/yaoQingMember.csb"):addTo(self)
    self.csbNode_:setPosition(display.cx, display.cy)
end

function AddMemberView:sureHandler_(event)
    if self.input_:getString() == "" then
        return app:showTips("输入不能为空")
    end
    if self.callback_ then
        self.callback_(true, self.input_:getString())
    end
    self:removeSelf()
end

function AddMemberView:quXiaoHandler_(event)
    if self.callback_ then
        self.callback_(false)
    end
    self:removeSelf()
end

return AddMemberView 
