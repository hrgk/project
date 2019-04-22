local BaseElement = import("app.views.BaseElement")
local ZhuanYiHead = class("ZhuanYiHead", BaseElement)
local PlayerHead = import("app.views.PlayerHead")

function ZhuanYiHead:ctor(data)
    self.data_ = data
    ZhuanYiHead.super.ctor(self)
    self:initBindHead_(data)
end

function ZhuanYiHead:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/club/memManagement/zhuanyi/zhuanyiHead.csb"):addTo(self)
end

function ZhuanYiHead:setGouXuanClick(callback)
    self.gouXuanCallback_ = callback
end

function ZhuanYiHead:showGouXuan(isShow)
    self.isClick_ = isShow
    self.gou_:setVisible(self.isClick_)
end

function ZhuanYiHead:clickHandler_()
    self.isClick_ = not self.isClick_ 
    self.gou_:setVisible(self.isClick_)
    if self.gouXuanCallback_ then
        self.gouXuanCallback_(self.data_, self.isClick_)
    end
end

function ZhuanYiHead:initBindHead_(data)
    local head = PlayerHead.new(data, false)
    head:setNode(self.head_)
    head:showWithUrl(data.avatar)
end

return ZhuanYiHead 
