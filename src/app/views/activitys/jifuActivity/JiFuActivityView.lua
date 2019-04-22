local JiFuActivityView = class("JiFuActivityView", gailun.BaseView)

function JiFuActivityView:ctor()
    JiFuActivityView.super.ctor(self)
    self:initGroup_()
end

function JiFuActivityView:initGroup_()
    local btn1 = cc.ui.UICheckBoxButton.new({on = "res/images/jifu/jifu_btn1.png", off = "res/images/jifu/jifu_btn2.png"})
    local btn2 = cc.ui.UICheckBoxButton.new({on = "res/images/jifu/guize_btn1.png", off = "res/images/jifu/guize_btn2.png"})
    local btn3 = cc.ui.UICheckBoxButton.new({on = "res/images/jifu/bangdan_btn1.png", off = "res/images/jifu/bangdan_btn2.png"})
    local btn4 = cc.ui.UICheckBoxButton.new({on = "res/images/jifu/lingjiang_btn1.png", off = "res/images/jifu/lingjiang_btn2.png"})
    local group = app:createView("activitys.GroupView")
    group:setCallback(handler(self, self.groupSelected_))
    group:setDirection(1)
    group:setGap(220)
    group:addButton(btn1)
    group:addButton(btn2)
    group:addButton(btn3)
    group:addButton(btn4)
    group:setPosition(277, 600)
    self:addChild(group)
    self.viewGroup_ = {
        handler(self, self.initJiFuInFoView_),
        handler(self, self.initJiFuXiZeView_),
        handler(self, self.initMingXiView_),
        handler(self, self.initLingJiangView_)
    }
    group:setSelectIndex(1)
    self.startTime_ = ""
    self.endTime_ =  ""
    self:getJiFuInfo_()
end

function JiFuActivityView:getJiFuInfo_()
    self:performWithDelay(function()
        HttpApi.getJiFuInfo(handler(self, self.infoSucHandler_), handler(self, self.infoFailHandler_))
    end, 0.5)
end

function JiFuActivityView:infoSucHandler_(data)
    local jifuInfo = json.decode(data)
    if jifuInfo.data.flag == 0 then
        return
    end
    self:update_(jifuInfo.data)
end

function JiFuActivityView:infoFailHandler_()
    app:showTips("获取积福数据失败")
end

function JiFuActivityView:update_(data)
    self.startTime_ = os.date("%Y-%m-%d", data.startTime)
    self.endTime_ =  os.date("%Y-%m-%d", data.endTime)
    self.infoView:update(data)
end

function JiFuActivityView:groupSelected_(index)
    for i=1,4 do
        self.viewGroup_[i](false)
    end
    self.viewGroup_[index](true)
end

function JiFuActivityView:initJiFuInFoView_(bool)
    if self.infoView == nil and bool == false then
        return
    end
    if self.infoView == nil then
        self.infoView = app:createView("activitys.jifuActivity.JiFuInfoView"):addTo(self)
    end
    self.infoView:setVisible(bool)
end

function JiFuActivityView:initJiFuXiZeView_(bool)
    if self.xizeView == nil and bool == false then
        return
    end
    if self.xizeView == nil then
        self.xizeView = app:createView("activitys.jifuActivity.JiFuXiZeView"):addTo(self)
        self.xizeView:update("活动时间 " .. self.startTime_ .. "--" .. self.endTime_)
    end
    self.xizeView:setVisible(bool)
end

function JiFuActivityView:initMingXiView_(bool)
    if self.mingxiView == nil and bool == false then
        return
    end
    if self.mingxiView == nil then
        self.mingxiView = app:createView("activitys.jifuActivity.JiFuMingXiView"):addTo(self)
    end
    self.mingxiView:setVisible(bool)
end

function JiFuActivityView:initLingJiangView_(bool)
    if self.lingjiangView == nil and bool == false then
        return
    end
    if self.lingjiangView == nil then
        self.lingjiangView = app:createView("activitys.jifuActivity.JiFuLingJiangView"):addTo(self)
    end
    self.lingjiangView:setVisible(bool)
end

return JiFuActivityView 
