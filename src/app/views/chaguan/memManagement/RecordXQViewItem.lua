local BaseElement = import("app.views.BaseElement")
local RecordXQViewItem = class("RecordXQViewItem", BaseElement)

function RecordXQViewItem:ctor(data)
    RecordXQViewItem.super.ctor(self)
end

function RecordXQViewItem:setUserName(item, userName)
    local nameLable = item:getChildByName("txt_user")
    nameLable:setString(userName)
end

function RecordXQViewItem:setScore(item, score)
    local scoreLable = item:getChildByName("txt_score")
    scoreLable:setString(score)
end

function RecordXQViewItem:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/club/memManagement/record/recordXQViewItem.csb"):addTo(self)
end

function RecordXQViewItem:update(data)
    self.data_ = data
    for i,v in ipairs(self.data_) do
        if self["item" .. i .."_"] then
            self:setScore(self["item" .. i .. "_"], v[2])
            self:setUserName(self["item" .. i .. "_"], v[1])
        end
    end
end


function RecordXQViewItem:sucHandler_(data)
    local info = json.decode(data)
    if info.status == 1 then
        app:enterReviewScene(info.data.gameType, {info.data.details})
    end
end


return RecordXQViewItem  
