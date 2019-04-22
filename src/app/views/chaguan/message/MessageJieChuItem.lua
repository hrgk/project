local BaseElement = import("app.views.BaseElement")
local MessageJieChuItem = class("MessageJieChuItem", BaseElement)
local PlayerHead = import("app.views.PlayerHead")
local ChaGuanData = import("app.data.ChaGuanData")


function MessageJieChuItem:ctor()
    MessageJieChuItem.super.ctor(self)
end

function MessageJieChuItem:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/julebu/message/jieChuJInZhiItem.csb"):addTo(self)
end

function MessageJieChuItem:chuLiHandler_(event)
    local clubID = ChaGuanData.getClubInfo().clubID
    httpMessage.requestClubHttp({
        clubID = clubID,
        uid1 = self.data_.uid1,
        uid2 = self.data_.uid2,
        status = 0
    }, httpMessage.SET_CLUB_BLOCK)
end

function MessageJieChuItem:close_()
    self:hide()
end

function MessageJieChuItem:update(data)
    dump(data)
    self.data_ = data
    local str = string.format("%s(%d)和%s(%d)已被禁止同桌",data.name1,data.uid1,data.name2,data.uid2)
    self.Info_:setString(str)
end

return MessageJieChuItem  
 
 
