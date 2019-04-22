local BaseElement = import("app.views.BaseElement")
local GLMemberItem = class("GLMemberItem", BaseElement)
local ChaGuanHead = import("app.views.chaguan.ChaGuanHead")
local ChaGuanData = import("app.data.ChaGuanData")


function GLMemberItem:ctor(data)
    self.data_ = data
    GLMemberItem.super.ctor(self)
    if ChaGuanData.getClubInfo().permission == 99 then
        self.zhuru_:hide()
        self.look_:hide()
        self.zhuruH_:hide()
    end
    if ChaGuanData.getClubInfo().permission == 1 then
        self.zhuruH_:hide()
    end
    if data.online == false then
        self.offlineTag_:setVisible(true)
    else
        self.offlineTag_:setVisible(false)
    end
    local username = (data.name or "未知") 
    if data.remain ~= nil then
        username = username .. "(" .. data.remark .. ")" 
    end
    local text = gailun.utf8.formatNickName(username, 5, '...')
    self.nickName_:setString(text)
    self.id_:setString("ID:"..data.uid)
    self:initHead_()
end

function GLMemberItem:initHead_()
    local head = ChaGuanHead.new(self.data_, false)
    head:setNode(self.head_)
    head:showWithUrl(self.data_.avatar)
    head.head_:setTouchEnabled(false)
end

function GLMemberItem:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/club/memManagement/member/glmemberItem.csb"):addTo(self)
end

function GLMemberItem:showZhuRu(visible)
    self.zhuru_:setVisible(visible)
    self.zhuruH_:setVisible(not visible)
end

function GLMemberItem:setZhuRuClick(callback)
    self.zhuRuCallback_ = callback
end

function GLMemberItem:setChaKanClick(callback)
    self.chaKanCallback_ = callback
end

function GLMemberItem:setFanHuiClick(callback)
    self.fanHuiCallback_ = callback
end

function GLMemberItem:fanhuiHandler_(item)
    if self.fanHuiCallback_ then
        self.fanHuiCallback_()
    end
    self:fanhuiShow()
end

function GLMemberItem:fanhuiShow()
    self.look_:show()
    self.fanhui_:hide()
end

function GLMemberItem:zhuruHandler_()
    if self.zhuRuCallback_ then
        self.zhuRuCallback_(self.data_.uid)
    end
end

function GLMemberItem:lookHandler_(item)
    if self.chaKanCallback_ then
        self.chaKanCallback_(self.data_.uid,self)
    end
    self.fanhui_:show()
    self.look_:hide()
end

return GLMemberItem