local BaseElement = import("app.views.BaseElement")
local YaoQingView = class("YaoQingView", BaseElement)

function YaoQingView:ctor()
    YaoQingView.super.ctor(self)
    self.ID_:setString(selfData:getUid())
end

function YaoQingView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/daili/yaoQingView.csb"):addTo(self)
end

function YaoQingView:fuZhiHandler_()
    gailun.native.copy(selfData:getUid())
    app:showTips("复制成功!")
end

function YaoQingView:shuJuHandler_()
    app:showTips("暂未开放!")
end

return YaoQingView  
