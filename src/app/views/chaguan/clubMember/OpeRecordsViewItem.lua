local BaseElement = import("app.views.BaseElement")
local OpeRecordsViewItem = class("OpeRecordsViewItem", BaseElement)

function OpeRecordsViewItem:ctor(data)
    OpeRecordsViewItem.super.ctor(self)
end

function OpeRecordsViewItem:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/club/members/opeRecordItem.csb"):addTo(self)
    self.csbNode_ = self.csbNode_:getChildByName("Panel_item")
end

function OpeRecordsViewItem:update(data)
    self.data_ = data
    self.name_:setString(data.nickname)
    self.id_:setString(data.uid)
    self.time_:setString(self:getYMD(data.time))
    local str = ""
    if data.reason == 25 then
        str = "增加"
    else
        str = "减少"
    end
    self.cz_:setString(str .. math.abs(data.count) .. "分")
    self.syjf_:setString(data.score)
    self.czz_:setString(data.oper_nickname)
end

function OpeRecordsViewItem:getYMD(time)
    if time then
        local aimTime = os.date("*t",time)
        return aimTime.year .. "/" .. aimTime.month .. "/" .. aimTime.day
    else
        return "无"
    end
end

return OpeRecordsViewItem  
