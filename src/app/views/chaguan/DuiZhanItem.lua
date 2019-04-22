local BaseElement = import("app.views.BaseElement")
local DuiZhanItem = class("DuiZhanItem", BaseElement)
function DuiZhanItem:ctor()
    DuiZhanItem.super.ctor(self)
end

function DuiZhanItem:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/club/memManagement/zhanji/zhanjiItem.csb"):addTo(self)
end

function DuiZhanItem:lookHandler_(event)
    display.getRunningScene():initDuiJuList(self.data_)
end

function DuiZhanItem:webOpenHandler_(event)
    if self.data_.users and self.data_.users[1] and self.data_.users[1][3] then
        display.getRunningScene():gameShareWeiXin(GAMES_NAME[self.data_.gameType],"",callback,self.data_.roomID,selfData:getUid(), self.data_.recordID)
    end
end

function DuiZhanItem:update(data, clubID)
    self.roomID_:setString(data.roomID)
    self.data_ = data
    self.round_:setString(data.roundIndex.."/"..data.totalRound)
    self.time_:setString(os.date("%Y-%m-%d  %H:%M:%S",data.time))
    local count = 0
    for i,v in ipairs(data.users) do
        if v[1] ~= "" then
            count = count + 1
        end
    end
    self.renShu_:setString(count)
end

return DuiZhanItem

