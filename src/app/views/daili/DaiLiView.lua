local BaseView = import("app.views.BaseView")
local DaiLiView = class("DaiLiView", BaseView)
local GongGao = import(".GongGao")
local YaoQingView = import(".YaoQingView")

function DaiLiView:ctor()
    DaiLiView.super.ctor(self)
    self.yaoQingView_ = YaoQingView.new():addTo(self.csbNode_):pos(130,0)
    -- self.gongGao_:setEnabled(true)
    -- self.gongGao_:setBright(false)
end

function DaiLiView:yaoQingHandler_(item)
    item:setEnabled(false)
    item:setBright(false)
    self.gongGao_:setEnabled(true)
    self.gongGao_:setBright(true)
    self.yaoQingView_:setVisible(true)
    if self.gongGaoView_ then
        self.gongGaoView_:setVisible(false)
    end
end

function DaiLiView:gongGaoHandler_(item)
    item:setEnabled(false)
    item:setBright(false)
    self.yaoQing_:setEnabled(true)
    self.yaoQing_:setBright(true)
    self.yaoQingView_:setVisible(false)
    if self.gongGaoView_ == nil then
        self.gongGaoView_ = GongGao.new():addTo(self.csbNode_):pos(130,-60)
    end
    self.gongGaoView_:setVisible(true)
end

function DaiLiView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/daili/dailiView.csb"):addTo(self)
    self.csbNode_:setPosition(display.cx, display.cy)
end

function DaiLiView:returnHandler_()
    self:closeHandler_()
    display.getRunningScene():updateDiamonds()
end

return DaiLiView 
