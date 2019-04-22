local BaseElement = import("app.views.BaseElement")
local SetMembersViewItem = class("SetMembersViewItem", BaseElement)

function SetMembersViewItem:ctor(data)
    SetMembersViewItem.super.ctor(self)
end

function SetMembersViewItem:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/club/members/setMembersItem.csb"):addTo(self)
    self.csbNode_ = self.csbNode_:getChildByName("Panel_item")
end

function SetMembersViewItem:update(data)
    self.data_ = data
    self.name_:setString(data.nickName)
    self.id_:setString(data.uid)
    self.js_:setString(data.round)
    self.xhxz_:setString(data.limitScore)
    self.zf_:setString(data.score)
end

function SetMembersViewItem:addHandler_()
    self.data_.type = 1
    display.getRunningScene():initSetMemberInfo(self.data_)
end

function SetMembersViewItem:reduceHandler_()
    self.data_.type = -1
    display.getRunningScene():initSetMemberInfo(self.data_)
end

return SetMembersViewItem  
