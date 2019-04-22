local BaseElement = import("app.views.BaseElement")
local JiLuItem = class("JiLuItem", BaseElement)

function JiLuItem:ctor()
    JiLuItem.super.ctor(self)
end

function JiLuItem:update(data)
    self.id_:setString(data[1])
    self.nick_:setString(data[2])
    self.timer_:setString(os.date("%Y-%m-%d %H:%M:%S", data[3]))
    if data[6] == 1 then
        self.shuliang_:setString("赠送"..data[4])
    else
        self.shuliang_:setString("获赠"..data[4])
        self.shuliang_:setColor(cc.c3b(84, 32, 1))
    end
end

function JiLuItem:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/daili/zuanShiJiLuItem.csb"):addTo(self)
end

return JiLuItem 
