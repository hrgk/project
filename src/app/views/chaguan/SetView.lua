local BaseView = import("app.views.BaseView")
local SetView = class("SetView", BaseView)
local ChaGuanData = import("app.data.ChaGuanData")
local JiChuSet = import("app.views.chaguan.JiChuSet")
local GameSet = import("app.views.chaguan.GameSet")
local GongXianList = import("app.views.chaguan.GongXianList")
local GameInputView = import("app.views.GameInputView")

function SetView:ctor(data)
    SetView.super.ctor(self)
    self.data = data
    self.todayConsume_:setString(data.todayDiamond)
    self.yestConsume_:setString(data.yesterdayDiamond)
    self.totalConsume_:setString(data.totalDiamond)
    self.monthConsume_:setString(data.monthDiamond)
    -- self.remain_:setString(data.leftDiamond)

    self.notice_:setString(ChaGuanData.getClubInfo().notice)
end

function SetView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/julebu/setting/clubSettingView.csb"):addTo(self)
    self.csbNode_:setPosition(display.cx, display.cy + 20)
end

function SetView:sureHandler_()
    self:removeSelf()
end

function SetView:editNoticeHandler_()
    if self.notice_:getString() == ChaGuanData.getClubInfo().notice then
        app:showTips("请先编辑公告")
        return
    end
    display.getRunningScene():editChaGuanGongGao(self.notice_:getString())
end

function SetView:updateGongGao_(data)
end

return SetView 
