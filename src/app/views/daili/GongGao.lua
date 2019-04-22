local BaseElement = import("app.views.BaseElement")
local GongGao = class("GongGao", BaseElement)

function GongGao:ctor()
    GongGao.super.ctor(self)
end

function GongGao:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/daili/gonggaoView.csb"):addTo(self)
    self.csbNode_:setScale(0.9)
    self.csbNode_:setPositionY(self.csbNode_:getPositionY()+30)
end

return GongGao 
