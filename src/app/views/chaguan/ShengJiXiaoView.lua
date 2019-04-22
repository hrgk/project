local BaseView = import("app.views.BaseView")
local PlayerHead = import("app.views.PlayerHead")
local ChaGuanData = import("app.data.ChaGuanData")

local ShengJiXiaoView = class("ShengJiXiaoView", BaseView)
function ShengJiXiaoView:ctor()
    ShengJiXiaoView.super.ctor(self)
    self.douzi_:setString(ChaGuanData.getClubInfo().dou)
    self.input_:setString(ChaGuanData.getClubInfo().dou)
end

function ShengJiXiaoView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/julebu/shengJiXiaoView.csb"):addTo(self)
    self.csbNode_:setPosition(display.cx, display.cy)
end

function ShengJiXiaoView:maxHandler_()
    self.input_:setString(ChaGuanData.getClubInfo().dou)
end

function ShengJiXiaoView:queDingHandler_()
    local count = tonumber(self.input_:getString())
    if count <= 0 then
        app:showTips("输入非法，请重新输入")
        return
    end
    if ChaGuanData.getClubInfo().dou < count then
        app:showTips("捐赠金豆大于拥有金豆")
        return
    end
    ChaGuanData.getClubInfo().dou = ChaGuanData.getClubInfo().dou- count
    display.getRunningScene():upGradeCity(count)
    self:closeHandler_()
end

function ShengJiXiaoView:returnHandler_()
    self:closeHandler_()
end

return ShengJiXiaoView  
