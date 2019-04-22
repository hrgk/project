local BaseElement = import("app.views.BaseElement")
local MembersViewItem = class("MembersViewItem", BaseElement)

function MembersViewItem:ctor(data)
    MembersViewItem.super.ctor(self)
end

function MembersViewItem:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/club/members/membersItem.csb"):addTo(self)
    self.csbNode_ = self.csbNode_:getChildByName("Panel_item")
end

function MembersViewItem:update(data)
    self.data_ = data
    self.name_:setString(data.nickName)
    self.id_:setString(data.uid)
    self.zrjf_:setString(data.yesterdayScore)
    self.zjf_:setString(data.score)
    self.zjiaf_:setString(data.totalAddScore)
    self.zkf_:setString(data.totalMinusScore)

    self.zjjf_:setString(self:getYMD(data.recentAddTime))
    self.zjkf_:setString(self:getYMD(data.recentMinusTime))
end

function MembersViewItem:getYMD(time)
    if time then
        local aimTime = os.date("*t",time)
        return aimTime.year .. "/1" .. aimTime.month .. "/" .. aimTime.day
    else
        return "无"
    end
end

return MembersViewItem  
