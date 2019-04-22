local BaseView = import("app.views.BaseView")
local GuanLiView = class("GuanLiView", BaseView)
local ChaGuanData = import("app.data.ChaGuanData")
local JiChuSet = import("app.views.chaguan.JiChuSet")
local GameSet = import("app.views.chaguan.GameSet")
local GongXianList = import("app.views.chaguan.GongXianList")

function GuanLiView:ctor(data)
    self.data_ = data
    GuanLiView.super.ctor(self)
    self.btnList_ = {}
    self.btnList_[1] = self.jiChu_
    if CHANNEL_CONFIGS.DOU then
        self.btnList_[2] = self.gongXian_
        self.btnList_[3] = self.gameSet_
    else
        self.gameSet_:hide()
        self.gongXian_:hide()
    end
    self:updateButtonStatus_(1)
    self.currView_ = JiChuSet.new(self.data_):addTo(self.content_)
    -- self.weekJuShu_:setString(data.weekRound)
    -- self.todayJuShu_:setString(data.dayRound)
    -- self.input1_:setString(ChaGuanData.getClubInfo().name)
    -- self.input2_:setString(ChaGuanData.getClubInfo().notice)
end

function GuanLiView:updateButtonStatus_(index)
    self.currIndex_ = index
    for i,v in ipairs(self.btnList_) do
        if i == index then
            v:setEnabled(false)
            v:setBright(false)
        else
            v:setEnabled(true)
            v:setBright(true)
        end
    end
end

function GuanLiView:updateMingZi_(message)
end

function GuanLiView:updateGongGao_(message)
end

function GuanLiView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/julebu/guanLiView.csb"):addTo(self)
    self.csbNode_:setPosition(display.cx, display.cy)
end

function GuanLiView:removeCurrView_()
    if self.currView_ then
        self.currView_:removeSelf()
        self.currView_ = nil
    end
end

function GuanLiView:jiChuHandler_()
    self:updateButtonStatus_(1)
    self:removeCurrView_()
    self.currView_ = JiChuSet.new(self.data_):addTo(self.content_)
end

function GuanLiView:gongXianHandler_()
    self:removeCurrView_()
    self:updateButtonStatus_(2)
    display.getRunningScene():getUpGradeList()
    -- self.currView_ = GongXianList.new():addTo(self.content_)
end

function GuanLiView:updateGongXianList(data)
    if self.currIndex_ == 2 then
        if self.currView_ then
            self.currView_:update(data)
            return
        end
        self.currView_ = GongXianList.new():addTo(self.content_)
        self.currView_:update(data)
    end
end

function GuanLiView:gameSetHandler_()
    self:removeCurrView_()
    self:updateButtonStatus_(3)
    self.currView_ = GameSet.new():addTo(self.content_)
end

function GuanLiView:jieSanHandler_()
end

return GuanLiView 
