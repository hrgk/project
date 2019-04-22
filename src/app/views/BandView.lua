local BaseView = import("app.views.BaseView")
local BandView = class("BandView", BaseView)

function BandView:ctor()
    BandView.super.ctor(self)
end

function BandView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/bandView.csb"):addTo(self)
    self.csbNode_:setPosition(display.cx, display.cy)
end

function BandView:inputBgHandler_()
    display.getRunningScene():initGameInput(handler(self,self.setInputString_))
end

function BandView:bangDingHandler_()
    local length = string.len(self.input_:getString())
    local uid = tonumber(self.input_:getString())
    if length ~= 6 then
        app:showTips("无效的用户ID")
        return
    end
    HttpApi.getBindInviter(uid, handler(self, self.sucHandler_), handler(self, self.failHandler_))
end

function BandView:sucHandler_(data)
    local info = json.decode(data)
    if info.status == 1 then
        app:showTips("绑定成功")
        selfData:setFatherId(tonumber(self.input_:getString()))
    elseif info.status == -29 then
        app:showTips("您已绑定过")
    elseif info.status == -28 then
        app:showTips("无效的用户ID")
    end
    self:closeHandler_()
end

function BandView:failHandler_(data)
    app:showTips("无效的用户ID")
end

function BandView:setInputString_(str,isChange)
    if isChange then
        if string.len(str) > 6 then
            app:showTips("无效的用户ID")
            return string.sub(str,1,6)
        end
        return str
    end
    self.input_:setString(str)
end

return BandView 
