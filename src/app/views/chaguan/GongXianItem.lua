local BaseElement = import("app.views.BaseElement")
local PlayerHead = import("app.views.PlayerHead")

local GongXianItem = class("GongXianItem", BaseElement)

function GongXianItem:ctor(data)
    GongXianItem.super.ctor(self)
end

function GongXianItem:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/julebu/gongXianItem.csb"):addTo(self)
end

function GongXianItem:jieshouHandler_()
    local function callback(bool)
        if bool then
            display.getRunningScene():setUpGradeRedLog(self.data_.id)
        end
    end
    app:confirm("确定接受成员"..self.data_.nick_name .."捐赠么？", callback)
end

function GongXianItem:update(data)
    self.data_ = data
    self.nick_:setString(data.nick_name)
    self.time_:setString("捐赠时间："..os.date("%Y-%m-%d %H:%M:%S",data.time))
    self.ID_:setString("ID:"..data.id)
    local message = data.nick_name .."为社区升级捐赠了" .. data.score .."金豆"
    self.msg_:setString(message)
end

function GongXianItem:initHead_()
    local head = PlayerHead.new(nil, true)
    head:setNode(self.head_)
    head:showWithUrl(self.data_.avatar)
end

return GongXianItem 