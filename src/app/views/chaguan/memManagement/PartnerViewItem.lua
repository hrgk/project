local BaseElement = import("app.views.BaseElement")
local PartnerViewItem = class("PartnerViewItem", BaseElement)
local ChaGuanData = import("app.data.ChaGuanData")


function PartnerViewItem:ctor()
    PartnerViewItem.super.ctor(self)
end

function PartnerViewItem:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/club/memManagement/partner/partnerItem.csb"):addTo(self)
end

function PartnerViewItem:update(data)
    self.data_ = data
    self.nickName_:setString(gailun.utf8.formatNickName(data.nick_name, 8, '..'))
    self.id_:setString(data.tag_uid)
    self.dyjzsNum_:setString(data.winnerCount)
    self.glNum_:setString(data.lessCount)
    self.dyjNum_:setString(data.realWinnerCount)
   
    self.wjNum_:setString(data.club_user_count)
end

return PartnerViewItem  
 
 
