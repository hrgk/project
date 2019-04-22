local BaseView = import("app.views.BaseView")
local MessageView = class("MessageView", BaseView)
local SelectedView = import("app.views.SelectedView")
local MessageList = import(".MessageList")
local MessageRecordList = import(".MessageRecordList")
local MessageJieChuList = import(".MessageJieChuList")
local JinZhiTongZhuoView = import(".JinZhiTongZhuoView")

function MessageView:ctor()
    MessageView.super.ctor(self)
    self.showPList = {}
    self:type1Handler_()
end

function MessageView:updateView(data)
    if data.status == 0 then
        self:initApplyList_(data.data)
    elseif data.status == 1 then
        self:initRecordList_(data.data)
    elseif data.status == 2 then
        self:initJieChuList_(data.data)
    end
    self.status = data.status
    self:showTop(self.status)
end

function MessageView:initJieChuList_(data)
    if data == nil then return end
    if #data > 0 then
        self.msg_:hide()
    else
        self.msg_:show()
    end
    if self.showPList[3] and self.showPList[3]:isVisible() then
        self.showPList[3]:update(data)
        return
    end
    self.showPList[3] = MessageJieChuList.new(data):addTo(self.csbNode_)
end

function MessageView:initApplyList_(data)
    if data == nil then return end
    if #data > 0 then
        self.msg_:hide()
    else
        self.msg_:show()
    end
    if self.showPList[1] and self.showPList[1]:isVisible() then
        self.showPList[1]:update(data)
        return
    end
    self.showPList[1] = MessageList.new(data):addTo(self.csbNode_)
end

function MessageView:initRecordList_(data)
    if data == nil then return end
    if #data > 0 then
        self.msg_:hide()
    else
        self.msg_:show()
    end
    if self.showPList[2] and self.showPList[2]:isVisible() then
        self.showPList[2]:update(data)
        return
    end
    self.showPList[2] = MessageRecordList.new(data):addTo(self.csbNode_)
end

function MessageView:type1Handler_()
    self:showTop(0)
    display.getRunningScene():getMessageList(0)
end

function MessageView:type2Handler_()
    self:showTop(1)
    display.getRunningScene():getMessageList(1)
end

function MessageView:type3Handler_()
    self:showTop(2)
    display.getRunningScene():queryClubBlock()
end

function MessageView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/julebu/message/message.csb"):addTo(self)
    self.csbNode_:setPosition(display.cx, display.cy)
end

function MessageView:showTop(status)
    self.status = status
    for i = 1,3 do
        self["showType" .. i .. "_"]:setVisible(i == self.status+1)
        if self.showPList[i] then
            self.showPList[i]:setVisible(i == self.status+1)
        end
    end
end

function MessageView:closeHandler_()
    self:hide()
end

function MessageView:jztzHandler_()
    self.jinZhiTongZhuoView_ = JinZhiTongZhuoView.new():addTo(self,999)
    self.jinZhiTongZhuoView_:tanChuang(100) 
end

return MessageView   
