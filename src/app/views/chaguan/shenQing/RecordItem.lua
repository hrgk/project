local BaseElement = import("app.views.BaseElement")
local RecordItem = class("RecordItem", BaseElement)
local PlayerHead = import("app.views.PlayerHead")
local ChaGuanData = import("app.data.ChaGuanData")


function RecordItem:ctor()
    RecordItem.super.ctor(self)
    self:initHead_()
end

function RecordItem:initHead_()
    self.playerHead_ = PlayerHead.new(nil, true)
    self.playerHead_:setNode(self.head_)
end

function RecordItem:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/club/memManagement/apply/shenQingRecod.csb"):addTo(self)
end

function RecordItem:agreeHandler_(event)
    local params = {}
    params.clubID = ChaGuanData.getClubInfo().clubID
    params.uid = self.data_.uid
    params.status = 1
    httpMessage.requsetClubHttp(params, httpMessage.VERIFY_CLUB_USER)
end

function RecordItem:juJueHandler_(event)
    local params = {}
    params.clubID = ChaGuanData.getClubInfo().clubID
    params.uid = self.data_.uid
    params.status = -1
    httpMessage.requsetClubHttp(params, httpMessage.VERIFY_CLUB_USER)
end

function RecordItem:onShieldClick_(event)
    local params = {}
    params.clubID = self.data_.clubID
    params.uid = self.data_.uid
    params.status = -2
    display.getRunningScene():pinBiPlayer(params, handler(self, self.close_))
end

function RecordItem:close_()
    self:hide()
end

function RecordItem:update(data)
    self.data_ = data
    self.nickName_:setString(data.name)
    self.ID_:setString("ID："..data.uid)
    self.info_:setString(os.date("%Y-%m-%d  %H:%M:%S",data.update_time))
    if data.status == 1 then
        self.status_:setString("审批通过")
    else
        self.status_:setString("审批拒绝")
    end
    self.shenPiZhe_:setString(data.operator_user)
end

return RecordItem   
 