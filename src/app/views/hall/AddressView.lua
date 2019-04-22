local BaseView = import("app.views.BaseView")
local AddressView = class("AddressView", BaseView)
function AddressView:ctor()
    AddressView.super.ctor(self)
    self:getAddress()
    self.userId_:setString(selfData:getUid())
    self.userId_:setTouchEnabled(false)
end

function AddressView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/address/addressView.csb"):addTo(self)
    self.csbNode_:setPosition(display.cx, display.cy)
end

function AddressView:getAddress()
    HttpApi.onHttpGetAddress(handler(self, self.sucHandler_), handler(self, self.failHandler_))
end

function AddressView:sucHandler_(data)
    local info = json.decode(data)
    if info.status == 1 then
        if info.data and info.data.address then
            self:setData(info.data)
        end
    else
        
    end
end

function AddressView:setData(info)
    self.name_:setString(info.real_name)
    self.phone_:setString(info.phone)
    self.address_:setString(info.address)
end

function AddressView:failHandler_(data)
end

function AddressView:saveHandler_()
    self:sendAddressInfo()
end

function AddressView:changeHandler_()
    self:sendAddressInfo()
end

function AddressView:sendAddressInfo()
    local params = {}
    local name = self.name_:getString()
    local phone = self.phone_:getString()
    local userId = self.userId_:getString()
    local address = self.address_:getString()
    if name == "" then
        return app:showTips("姓名不能为空")
    end
    if phone == "" then
        return app:showTips("电话不能为空")
    end
    if userId == "" then
        return app:showTips("游戏ID不能为空")
    end
    if address == "" then
        return app:showTips("收货地址不能为空")
    end
    if not tonumber(userId) or tonumber(userId) and tonumber(userId) ~= selfData:getUid() then
        return app:showTips("游戏ID输入错误")
    end
    params.phone = phone
    params.address = address
    params.realName = name
    httpMessage.requestClubHttp(params, httpMessage.MODIFY_ADDRESS)
    self:closeHandler_()
end

return AddressView 
