local PresentDiamondsView = class("PresentDiamondsView", gailun.BaseView)

function PresentDiamondsView:ctor()
    local btn1 = gailun.uihelper.createCheckBox({images = {on = "res/images/songzuan/songzuan_btn1.png", off = "res/images/songzuan/songzuan_btn2.png"}})
    local btn2 = gailun.uihelper.createCheckBox({images = {on = "res/images/jifu/guize_btn1.png", off = "res/images/jifu/guize_btn2.png"}})
    local btn3 = gailun.uihelper.createCheckBox({images = {on = "res/images/songzuan/lingzuan_btn1.png", off = "res/images/songzuan/lingzuan_btn2.png"}})
    local group = app:createView("activitys.GroupView")
    group:setCallback(handler(self, self.groupSelected_))
    group:setDirection(1)
    group:setGap(220)
    group:addButton(btn1)
    group:addButton(btn2)
    group:addButton(btn3)
    group:setPosition(277, 600)
    self:addChild(group)
    self.viewGroup_ = {
        handler(self, self.initPresentDiamondsInfoView_),
        handler(self, self.initPresentDiamondsRuleView_),
        handler(self, self.initMingXiView_),
    }
    group:setSelectIndex(1)
end

function PresentDiamondsView:groupSelected_(index)
    for i=1,#self.viewGroup_ do
        self.viewGroup_[i](false)
    end
    self.viewGroup_[index](true)
end

function PresentDiamondsView:initPresentDiamondsInfoView_(bool)
    if self.infoView == nil and bool == false then
        return
    end
    if self.infoView == nil then
        self.infoView = app:createView("activitys.songzuanActivity.PresentDiamondsInfoView"):addTo(self)
    end
    self.infoView:setVisible(bool)
end

function PresentDiamondsView:initPresentDiamondsRuleView_(bool)
    if self.xizeView == nil and bool == false then
        return
    end
    if self.xizeView == nil then
        self.xizeView = app:createView("activitys.songzuanActivity.PresentDiamondsRuleView"):addTo(self)
    end
    self.xizeView:setVisible(bool)
end

function PresentDiamondsView:initMingXiView_(bool)
    if self.mingxiView == nil and bool == false then
        return
    end
    if self.mingxiView == nil then
        self.mingxiView = app:createView("activitys.songzuanActivity.PresentDiamondsMingXiView"):addTo(self)
    end
    self.mingxiView:setVisible(bool)
end

return PresentDiamondsView 
