local BaseView = require("app.views.BaseView")
local SureAddMemberView = class("SureAddMemberView", BaseView)
local ChaGuanHead = import(".ChaGuanHead")

function SureAddMemberView:ctor(data, callback)
    self.callback_ = callback
    self.data_ = data
    SureAddMemberView.super.ctor(self)
    self.nickName_:setString(data.nickName)
    self.ID_:setString("ID：".. data.uid)
    self:initHead_(data)
end

function SureAddMemberView:initHead_(data)
    local head = ChaGuanHead.new(data, true)
    head:setNode(self.head_)
    head:showWithUrl(data.avatar)
end


function SureAddMemberView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/julebu/sureAddMember.csb"):addTo(self)
    self.csbNode_:setPosition(display.cx, display.cy)
end

function SureAddMemberView:quedingHandler_(event)
    if self.callback_ then
        self.callback_(true, self.data_.uid)
    end
    self:removeSelf()
end

function SureAddMemberView:quxiaoHandler_(event)
    if self.callback_ then
        self.callback_(false)
    end
    self:removeSelf()
end

return SureAddMemberView 
