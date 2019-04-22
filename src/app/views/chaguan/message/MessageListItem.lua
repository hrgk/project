local BaseElement = import("app.views.BaseElement")
local MessageListItem = class("MessageListItem", BaseElement)
local PlayerHead = import("app.views.PlayerHead")
local ChaGuanData = import("app.data.ChaGuanData")


function MessageListItem:ctor()
    MessageListItem.super.ctor(self)
end

function MessageListItem:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/julebu/message/messageItem.csb"):addTo(self)
end

function MessageListItem:chuLiHandler_(event)
    local params = {}
    params.clubID = ChaGuanData.getClubInfo().clubID
    params.msgID = self.data_.id
    httpMessage.requestClubHttp(params, httpMessage.SET_GAME_COUNT_LOGS)
end

function MessageListItem:close_()
    self:hide()
end

function MessageListItem:update(data)
    dump(data)
    self.data_ = data
    local str = string.format("%s(%d)和%s(%d)连续同桌%d局",data.name1,data.uid1,data.name2,data.uid2,data.count)
    self.Info_:setString(str)
end

return MessageListItem  
 
 
