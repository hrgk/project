local BaseElement = import("app.views.BaseElement")
local ApplyListItem = class("ApplyListItem", BaseElement)
local PlayerHead = import("app.views.PlayerHead")
local ChaGuanData = import("app.data.ChaGuanData")


function ApplyListItem:ctor()
    ApplyListItem.super.ctor(self)
    self:initHead_()
end

function ApplyListItem:initHead_()
    self.playerHead_ = PlayerHead.new(nil, true)
    self.playerHead_:setNode(self.head_)
end

function ApplyListItem:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/club/memManagement/apply/chengYuanItem.csb"):addTo(self)
end

function ApplyListItem:agreeHandler_(event)
    local params = {}
    params.clubID = ChaGuanData.getClubInfo().clubID
    params.uid = self.data_.uid
    params.status = 1
    httpMessage.requestClubHttp(params, httpMessage.VERIFY_CLUB_USER)
end

function ApplyListItem:juJueHandler_(event)
    local params = {}
    params.clubID = ChaGuanData.getClubInfo().clubID
    params.uid = self.data_.uid
    params.status = -1
    httpMessage.requestClubHttp(params, httpMessage.VERIFY_CLUB_USER)
end


function ApplyListItem:onShieldClick_(event)
    local params = {}
    params.clubID = self.data_.clubID
    params.uid = self.data_.uid
    params.status = -2
    display.getRunningScene():pinBiPlayer(params, handler(self, self.close_))
end

function ApplyListItem:close_()
    self:hide()
end

function ApplyListItem:update(data)
    dump(data)
    self.data_ = data
    self.playerHead_:showWithUrl(data.avatar)
    self.nickName_:setString(data.name)
    self.ID_:setString(data.uid)
    self.requestTime_:setString(os.date("%Y-%m-%d  %H:%M:%S", data.requestTime))
end

return ApplyListItem  
 
 
