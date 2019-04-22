local BaseView = import("app.views.BaseView")
local ShengJiView = class("ShengJiView", BaseView)
function ShengJiView:ctor()
    ShengJiView.super.ctor(self)
end

function ShengJiView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/julebu/shengjiView.csb"):addTo(self)
    self.csbNode_:setPosition(display.cx, display.cy)
end

function ShengJiView:shengjiHandler_()
    display.getRunningScene():initShengJiXiaoView()
end
function ShengJiView:returnHandler_()
    self:closeHandler_()
end

return ShengJiView  
