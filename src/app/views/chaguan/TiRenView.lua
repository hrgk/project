local BaseView = import("app.views.BaseView")
local TiRenView = class("TiRenView", BaseView)

function TiRenView:ctor(name, ID)
    self.ID_ = ID
    TiRenView.super.ctor(self)
    self.msg_:setString("确定要踢掉社区成员" .. name .. "么？")
end

function TiRenView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/julebu/tiRen.csb"):addTo(self)
    self.csbNode_:setPosition(display.cx, display.cy)
end

function TiRenView:queRenHandler_()
    display.getRunningScene():tiPlayer(self.ID_)
    self:closeHandler_()
end

function TiRenView:quXiaoHandler_()
    self:closeHandler_()
end

return TiRenView 
