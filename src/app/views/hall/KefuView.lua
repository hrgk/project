local BaseView = import("app.views.BaseView")
local KefuView = class("KefuView", BaseView)

function KefuView:ctor()
    KefuView.super.ctor(self)
    self.tipFont = {"LJQP-666","LJQP-777"}
    for i = 1, 2 do 
        self["tip" .. i .. "_"]:setString(self.tipFont[i])
    end
end

function KefuView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/kefu/kefuView.csb"):addTo(self)
    self.csbNode_:setPosition(display.cx, display.cy)
end

function KefuView:fuzhi1Handler_()
    gailun.native.copy(self.tipFont[1])
    app:showTips("复制成功!")
end

function KefuView:fuzhi2Handler_()
    gailun.native.copy(self.tipFont[2])
    app:showTips("复制成功!")
end

return KefuView 
