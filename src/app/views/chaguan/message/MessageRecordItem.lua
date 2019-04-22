local BaseElement = import("app.views.BaseElement")
local MessageRecordItem = class("MessageRecordItem", BaseElement)
local PlayerHead = import("app.views.PlayerHead")
local ChaGuanData = import("app.data.ChaGuanData")


function MessageRecordItem:ctor()
    MessageRecordItem.super.ctor(self)
end

function MessageRecordItem:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/julebu/message/messageRecod.csb"):addTo(self)
end

function MessageRecordItem:close_()
    self:hide()
end

function MessageRecordItem:update(data)
    self.data_ = data
    local str = string.format("%s(%d)和%s(%d)连续同桌%d局",data.name1,data.uid1,data.name2,data.uid2,data.count)
    self.info_:setString(str)
end

return MessageRecordItem   
 