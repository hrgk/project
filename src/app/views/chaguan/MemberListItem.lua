local BaseElement = import("app.views.BaseElement")
local MemberListItem = class("MemberListItem", BaseElement)
local ChaGuanData = import("app.data.ChaGuanData")
local ChaGuanHead = import(".ChaGuanHead")

function MemberListItem:ctor(data,type,count)
    self.data_ = data
    self.type = type
    self.count = count
    MemberListItem.super.ctor(self)
    if self.type == 1 then
        self.right_:show()
        self:getElement(self.right_)
        if ChaGuanData.isMyClub() and data.permission > 0 then
            self.bj_:show()
            self.tc_:show()
        elseif ChaGuanData.getClubInfo().permission == 1 and data.permission == 99 then
            self.tc_:show()
        end
    else
        self.left_:show()
        self:getElement(self.left_)
        if ChaGuanData.isMyClub() and data.permission == 0 then
            self.sqjs_:show()
        end
    end
    self:update(data)
    self:setScale(0.9,1)
end


function MemberListItem:getElement(node)
    for k,v in pairs(node:getChildren()) do
        local vInfo = string.split(v:getName(), "_")
        local itemName
        if vInfo[2] then
            itemName = vInfo[2] .. "_"
            self[itemName] = v
        end
        local itemType = vInfo[1]
        if itemType == "btn" or itemType == "checkBox"  then
            v.currScale = 1
            local funcName = vInfo[2].."Handler_"
            if self[funcName] then
                self:buttonRegister(v, handler(self, self[funcName]))
            end
            if vInfo[3] == "ns" then
                v.sound = "ns"
                v.offScale = 1
            else
                v.offScale = 0.9
            end
        end
    end
end

function MemberListItem:initHead_(data)
    local head = ChaGuanHead.new(data, false)
    head:setNode(self.head_)
    head:showWithUrl(data.avatar)
    head.head_:setTouchEnabled(false)
    if self.type ~= 1 and data.permission == 0 then
        head:hideOtherView_()
    end

    if data.permission ~= 0 and selfData:getUid() == data.uid and self.exit_ then
        self.exit_:setVisible(true)
    end
end

function MemberListItem:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/club/memManagement/member/memberItem.csb"):addTo(self)
    if self.type == 1 then
        self.csbNode_:setPosition(70, 30)
    else
        self.csbNode_:setPosition(70, 30)--5个
    end
    
end

function MemberListItem:update(data)
    self:initHead_(data)
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
    self.id_:setString(data.uid)
end


function MemberListItem:bjHandler_()
    display.getRunningScene():initChaGuanPlayerInfo(self.data_)
end

function MemberListItem:exitHandler_()
    display.getRunningScene():tuiChuClub()
end

function MemberListItem:tcHandler_()
    display.getRunningScene():initTiRen(self.data_.name, self.data_.uid)
    --self:closeHandler_()
end

function MemberListItem:sqjsHandler_()
    display.getRunningScene():jieSanClub()
end

return MemberListItem 
 