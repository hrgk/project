local BaseView = import("app.views.BaseView")
local ZhuanYiView = class("ZhuanYiView", BaseView)
local ChaGuanData = import("app.data.ChaGuanData")
local ZhuanYiHead = import(".ZhuanYiHead")
local PlayerHead = import("app.views.PlayerHead")

function ZhuanYiView:ctor()
    ZhuanYiView.super.ctor(self)
    self.ptList_ = {}
    self.xuanList_ = {}
    self:initPlayers_()
end

function ZhuanYiView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/club/memManagement/zhuanyi/zhuanYiView.csb"):addTo(self)
    self.csbNode_:setPosition(display.cx, display.cy)
end

function ZhuanYiView:gouXuanClick_(data, isSelected)
    if isSelected then
        self.xuanList_[data.uid] = data.uid
    else
        self.xuanList_[data.uid] = nil
    end
end

function ZhuanYiView:initPlayers_()
    local list = ChaGuanData.getMemberList()
    for i = 1, #list, 6 do
        local listItemLayout = ccui.Layout:create()
        listItemLayout:setContentSize(600,90)
        local count = 0
        for j = i, i+5 do
            if list[j] then
                local item = ZhuanYiHead.new(list[j])
                item:pos((count)*100,0)
                count = count + 1
                item:setGouXuanClick(handler(self, self.gouXuanClick_))
                listItemLayout:addChild(item)
                self.ptList_[#self.ptList_+1] = item
            end
        end 
        self.listView_:pushBackCustomItem(listItemLayout)
    end
end

function ZhuanYiView:chaXunHandler_()
    local params = {}
    params.clubID = self.input_:getString()
    httpMessage.requestClubHttp(params, httpMessage.GET_CLUB_BASE_INFO)
end

function ZhuanYiView:update(data)
    self:initHead_(data)
    self.clubName_:setString("俱乐部："..data.name)
    self.clubID_:setString("ID:"..data.id .. "   人数：".. data.count)
end

function ZhuanYiView:initHead_(data)
    local head = PlayerHead.new(nil, false)
    head:setNode(self.head_)
    head:showWithUrl(data.ownerAvatar)
end

function ZhuanYiView:allXuanZeHandler_()
    self.isAllClick_ = not self.isAllClick_
    self.xuanList_ = {}
    for i,v in ipairs(self.ptList_) do
        v:showGouXuan(self.isAllClick_)
    end
    if self.isAllClick_ == false then
        return
    end
    for i,v in ipairs(ChaGuanData.getMemberList()) do
        self.xuanList_[v.uid] = v.uid
    end
end

function ZhuanYiView:zhuanYiHandler_()
    local list = {}
    for k,v in pairs(self.xuanList_) do
        list[#list+1] = v
    end
    local params = {}
    params.fromClubID  = ChaGuanData.getClubID()
    params.uids = list
    params.toClubID = tonumber(self.input_:getString())
    httpMessage.requestClubHttp(params, httpMessage.TRANSFER_CLUBUSER)
end

return ZhuanYiView 
