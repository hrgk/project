local BaseElement = import("app.views.BaseElement")
local PTMemberItem = class("PTMemberItem", BaseElement)
local ChaGuanHead = import("app.views.chaguan.ChaGuanHead")
local ChaGuanData = import("app.data.ChaGuanData")
local PlayerHead = import("app.views.PlayerHead")

function PTMemberItem:ctor(data)
    self.data_ = data
    PTMemberItem.super.ctor(self)
    local bindData = ChaGuanData.getMemberByUid(data.tagUid)
    self:initBindHead_(bindData)
    local bName = gailun.utf8.formatNickName(bindData.name, 5, '...')
    self.bindName_:setString(bName)
    
    if ChaGuanData.getClubInfo().permission == 99 or self.data_.uid == selfData:getUid() then
        self.bj_:hide()
    end
    if ChaGuanData.getClubInfo().permission == 1 then
        if self.data_.permission == 0 or self.data_.permission == 1 then
            self.bj_:hide()
        end
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
    if ChaGuanData.getClubOwnerID() == self.data_.uid or ChaGuanData.getClubInfo().permission == 99 then 
        self.bindHead_:hide()
        self.bindName_:hide()
        return
    end
    local str = "最近登陆时间:" .. os.date("%Y-%m-%d",data.loginTime)
    self.zjTime_:setString(str)
end

function PTMemberItem:showGouXuan(visible)
    if ChaGuanData.getClubOwnerID() == self.data_.uid then 
        return
    end
    self.gouXuan_:setVisible(visible)
    self.gouXuanCallback_(self.data_,self.gouXuan_:isSelected())
end

function PTMemberItem:setGouXuanClick(callback)
    self.gouXuanCallback_ = callback
end

function PTMemberItem:gouXuanHandler_(item)
    if self.gouXuanCallback_ then
        self.gouXuanCallback_(self.data_, not item:isSelected())
    end
end

function PTMemberItem:initBindHead_(data)
    local head = PlayerHead.new(data, false)
    head:setNode(self.bindHead_)
    head:showWithUrl(data.avatar)
    head.head_:setTouchEnabled(false)
end


function PTMemberItem:initHead_()
    local head = ChaGuanHead.new(self.data_, false)
    head:setNode(self.head_)
    head:showWithUrl(self.data_.avatar)
    head.head_:setTouchEnabled(false)
    head:setOtherViewPos_(-18,8)
end

function PTMemberItem:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/club/memManagement/member/ptmemberItem.csb"):addTo(self)
end

function PTMemberItem:bjHandler_()
    display.getRunningScene():initChaGuanPlayerInfo(self.data_)
end

function PTMemberItem:exitHandler_()
    display.getRunningScene():tuiChuClub()
end

function PTMemberItem:tcHandler_()
    display.getRunningScene():initTiRen(self.data_.name, self.data_.uid)
end

return PTMemberItem