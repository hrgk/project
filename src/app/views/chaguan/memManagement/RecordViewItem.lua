local BaseElement = import("app.views.BaseElement")
local RecordViewItem = class("RecordViewItem", BaseElement)
local PlayerHead = import("app.views.PlayerHead")
local ChaGuanData = import("app.data.ChaGuanData")


function RecordViewItem:ctor()
    RecordViewItem.super.ctor(self)
    self:initHead_()
end

function RecordViewItem:initHead_()
    self.playerHead_ = PlayerHead.new(nil, true)
    self.playerHead_:setNode(self.head_)
end

function RecordViewItem:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/club/memManagement/record/recordItem.csb"):addTo(self)
end

function RecordViewItem:update(data)
    self.data_ = data
    self.playerHead_:showWithUrl(data.avatar)
    self.nickName_:setString(gailun.utf8.formatNickName(data.name, 8, '..'))
    self.id_:setString(data.uid)
    self.dyj_:setString(data.winnerCount .. "/" .. data.winnerScore)
    self.thc_:setString(data.loseCount .. "/" .. data.loseScore)
    self.zcc_:setString(data.totalCount .. "/" .. data.totalScore)
end

function RecordViewItem:ckHandler_()
    dump(self.data_.uid,"self.data_.uid")
    display.getRunningScene():getClubRoomList_(self.data_.uid)
end

return RecordViewItem  
 
 
