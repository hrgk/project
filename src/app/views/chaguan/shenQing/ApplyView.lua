local BaseView = import("app.views.BaseView")
local ApplyView = class("ApplyView", BaseView)
local SelectedView = import("app.views.SelectedView")
local ApplyList = import(".ApplyList")
local RecordList = import(".RecordList")

function ApplyView:ctor(redTag)
    ApplyView.super.ctor(self)
    display.getRunningScene():getJoinList(1)
    self.isRefresh_ = true
    self.redTag = redTag
end

function ApplyView:updateView(data)
    if data.type == 1 then
        self.isRefresh_ = true
        self:initApplyList_(data.data)
    else
        self:initRecordList_(data.data)
    end
end

function ApplyView:initApplyList_(data)
    if data == nil then self.redTag:hide() return end
    self.redTag:setVisible(#data > 0)
    if self.appList_ and self.appList_:isVisible() then
        self.appList_:update(data)
        return
    end
    self.appList_ = ApplyList.new(data):addTo(self.csbNode_)
end

function ApplyView:initRecordList_(data)
    if data == nil then return end
    if self.recodList_ and self.recodList_:isVisible() then
        self.recodList_:update(data)
        return
    end
    self.recodList_ = RecordList.new(data):addTo(self.csbNode_)
end

function ApplyView:cksqHandler_()
    self:jieSuanHandler_(1)
end

function ApplyView:sqjlHandler_()
    self:jieSuanHandler_(2)
end

function ApplyView:jieSuanHandler_(index)
    if index == 1 then
        self.top_:show()
        if self.appList_ then
            self.appList_:show()
        end
        if self.recodList_ then
            self.recodList_:hide()
        end
    else
        self.top_:hide()
        if self.appList_ then
            self.appList_:hide()
        end
        if self.isRefresh_ then
            self.isRefresh_ = false
            display.getRunningScene():getJoinList(2)
        end
        if self.recodList_ then
            self.recodList_:show()
        end
    end
end

function ApplyView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/club/memManagement/apply/chengyuanShenQing.csb"):addTo(self)
end

function ApplyView:closeHandler_()
    self:hide()
end

return ApplyView   
