local BaseView = import("app.views.BaseView")
local ChengYuanList = import(".ChengYuanList")
local ChaGuanData = import("app.data.ChaGuanData")
local GLMemberItem = import("app.views.chaguan.memManagement.GLMemberItem")
local PTMemberItem = import("app.views.chaguan.memManagement.PTMemberItem")
local ChengYuanListView = class("ChengYuanListView", BaseView)

function ChengYuanListView:ctor(data)
    ChengYuanListView.super.ctor(self)
    self:updateMemberList(data)
    if ChaGuanData.getClubInfo().permission == 99 then
        self.tianJia_:hide()
        self.inputNumber_:hide()
        self.find_:hide()
        self.csbNode_:getChildByName("Image_55_Copy"):hide()
    end
end

function ChengYuanListView:gouXuanHandler_()
    self.isShow_ = not self.isShow_
    for i,v in ipairs(self.ptList_) do
        v:showGouXuan(self.isShow_)
    end
    for i,v in ipairs(self.guanLiList_) do
        v:showZhuRu(self.isShow_)
    end
end

function ChengYuanListView:zhuanyiHandler_()
    display.getRunningScene():initZhuanYiView()
end

function ChengYuanListView:jieSanClubHandler_()
    display.getRunningScene():jieSanClub()
end

function ChengYuanListView:tuChuClubHandler_()
    display.getRunningScene():tuiChuClub()
end

function ChengYuanListView:ptGouXuanClick_(data, isBind)
    if isBind then
        self.gouXuanList_[data.uid] = data.uid
    else
        self.gouXuanList_[data.uid] = nil
    end
end

function ChengYuanListView:zhuRuClick_(tagUid)
    local list = {}
    for k,v in pairs(self.gouXuanList_) do
        list[#list+1] = v
    end
    local params = {}
    params.clubID = ChaGuanData.getClubID()
    params.ids = list
    params.tagUid = tagUid
    httpMessage.requestClubHttp(params, httpMessage.TAG_CLUBUSER)
    self.gouXuanList_ = {}
end

function ChengYuanListView:chaKanClick_(uid,aimItem)
    if self.selectAimItem then
        self.selectAimItem:fanhuiShow()
    end
    self.selectAimItem = aimItem
    local findData = self.userDataInfo[self.userInfoTag[uid]]
    if findData then
        local data = {}
        for k,v in ipairs(findData) do
            if v.tagUid == uid and v.permission ~= 0 then
                table.insert(data,v)
            end
        end
        self:showPuTongList_(data)
    end
end

function ChengYuanListView:fanHuiClick_()
    self:initPuTongList_(self.ptData_)
end

function ChengYuanListView:initGuanLiList_()
    self.glListView_:removeAllChildren()
    self.guanLiList_ = {}
    self:sortData_(self.glMembers_)
    for k,v in pairs(self.glMembers_) do
        local listItemLayout = ccui.Layout:create()
        listItemLayout:setContentSize(395,100)
        local item = GLMemberItem.new(v)
        item:setZhuRuClick(handler(self, self.zhuRuClick_))
        item:setChaKanClick(handler(self, self.chaKanClick_))
        item:setFanHuiClick(handler(self, self.fanHuiClick_))
        listItemLayout:addChild(item)
        self.guanLiList_[#self.guanLiList_+1] = item
        self.glListView_:pushBackCustomItem(listItemLayout)
    end
end

function ChengYuanListView:showPuTongList_(data)
    self.pagesSignNum = 10
    self.pagesData_ = clone(data)
    dump(self.pagesData_,"self.pagesData_")
    self.pagesNum_ = math.floor(#self.pagesData_/self.pagesSignNum + 0.5)
    self.nowPagesNum_ = 0
    if self.pagesNum_ == 0 then
        self.pagesNum_ = 1
    end
    print("self.pagesNum_",self.pagesNum_)
    self:changePagesIndex_(true)
end

function ChengYuanListView:changePagesIndex_(add)
    if add then
        if self.nowPagesNum_ < self.pagesNum_ then
            self.nowPagesNum_ = self.nowPagesNum_ + 1
        else
            return
        end
    else
        if self.nowPagesNum_ > 1 then
            self.nowPagesNum_ = self.nowPagesNum_ - 1
        else
            return
        end
    end
    self.ptListView_:removeAllChildren()
    self.ptList_ = {}
    for i = 1,self.pagesSignNum do
        local index = (self.nowPagesNum_-1)*10+i
        if self.pagesData_[index] then
            local listItemLayout = ccui.Layout:create()
            listItemLayout:setContentSize(560,90)
            local item = PTMemberItem.new(self.pagesData_[index])
            item:setGouXuanClick(handler(self, self.ptGouXuanClick_))
            listItemLayout:addChild(item)
            self.ptList_[#self.ptList_+1] = item
            self.ptListView_:pushBackCustomItem(listItemLayout)
        end
    end
    self.pagesFont_:setString(self.nowPagesNum_ .."/" .. self.pagesNum_)
end

function ChengYuanListView:initPuTongList_(data)
    self:showPuTongList_(data)
end

function ChengYuanListView:findTreeData_(list,data)
    local result = {}
    local ptResult = {}
    table.insert(result,clone(data))
    for j = 1,#list do
        local findData = list[j]
        if findData.tagUid == data.uid and findData.tagUid ~= findData.uid then
            table.insert(result,clone(findData))
            if findData.permission == 99 then
                table.insert(ptResult,clone(findData))
            end
        end
    end
    return result,ptResult
end

function ChengYuanListView:sortAllData_(list)
    local function sortByPermission(a, b)
        return a.permission < b.permission
    end
    table.sort(list,sortByPermission)
    local ptResult = nil
    self.userInfoTag = {}
    self.userIndexTag = {}
    self.userDataInfo = {}
    self.userDataInfo[1] = {}
    for i = 1,#list do
        if list[i].permission == 1 then
            table.insert(self.userDataInfo[1],list[i])
        end
    end
    self:sortData_(self.userDataInfo[1])
    local result = {self.rootData}
    for i = 1,#self.userDataInfo[1] do
        if self.userDataInfo[1][i].permission == 1 then
            local len = #self.userDataInfo+1
            self.userDataInfo[len] = {}
            self.userDataInfo[len] = self:findTreeData_(list,self.userDataInfo[1][i])
            self.userInfoTag[self.userDataInfo[1][i].uid] = len
            self.userIndexTag[len] = self.userDataInfo[1][i].uid
            self:sortData_(self.userDataInfo[len])
            table.insertto(result, clone(self.userDataInfo[len]))
        end
    end
    local len = #self.userDataInfo+1
    self.userInfoTag[self.rootData.uid] = len
    self.userIndexTag[len] = self.rootData.uid
    self.userDataInfo[len],ptResult = self:findTreeData_(list,self.rootData)
    table.insertto(result, clone(ptResult))
    local online = {}
    local offOnlineInfo = {}
    local userIdInfo = {}
    for i = 1,#result do
        if not userIdInfo[result[i].uid] then
            if result[i].online then
                table.insert(online,result[i])
            else
                table.insert(offOnlineInfo,result[i])
            end
            userIdInfo[result[i].uid] = true
        end
    end
    table.insertto(online, offOnlineInfo)
    return online
end

function ChengYuanListView:getUserTreeData()
    return self.userIndexTag,self.userDataInfo
end

function ChengYuanListView:sortData_(list)
    local function sortByPermission(a, b)
        local aNum = a.online and 0 or 1
        local bNum = b.online and 0 or 1
        if aNum < bNum then
            return true
        elseif a.online == b.online then
            return a.permission < b.permission
        end
    end
    table.sort(list,sortByPermission)
end

function ChengYuanListView:getUserInfo()
    return self.userInfo 
end

function ChengYuanListView:getPTData(data)
    local ptData_ = {}
    local zxRS = 0
    self.userInfo = {}
    for key,value in pairs(data) do
        if value.online then
            zxRS = zxRS + 1
        end
        if value.permission == 99 then
            table.insert(ptData_,value)
        end
        self.userInfo[value.uid] = {}
        self.userInfo[value.uid].avatar = value.avatar
        self.userInfo[value.uid].name = value.name
    end
    if not self.renShuZX_ or tolua.isnull(self.renShuZX_) then
        self.renShuZX_ = cc.LabelBMFont:create(0, "fonts/dtz_result_sm_score.fnt")
        self.renShuZX_:setPosition(self.zxsrTip_:getPositionX()+50, self.zxsrTip_:getPositionY())
        self.renShuZX_:setAnchorPoint(0,0.5)
        self.csbNode_:addChild(self.renShuZX_)
    end
    self.renShuZX_:setString(zxRS)
    return ptData_
end

function ChengYuanListView:updateMemberList(data)
    ChaGuanData.setMemberList(data)
    self.isShow_ = false
    self.data_ = {}
    self.glMembers_ = {}
    self.gouXuanList_ = {}
    for key,value in pairs(data) do
        if value.name and value.avatar and value.uid then
            table.insert(self.data_,value)
        end
        if value.name and value.avatar and value.uid and value.permission ~= 99 then
            table.insert(self.glMembers_,value)
        end
        if value.name and value.avatar and value.uid and value.permission == 0 then
            self.rootData = value
        end
    end
    self.data_ = self:sortAllData_(self.data_)
    self.orginData_ = clone(self.data_)
    self.ptData_ = self:getPTData(self.data_)
    if ChaGuanData.getClubInfo().permission ~= 99 then
        self:initGuanLiList_()
    end
    self:initPuTongList_(self.ptData_)
    if not self.renShu_ or tolua.isnull(self.renShu_) then
        self.renShu_ = cc.LabelBMFont:create(0, "fonts/dtz_result_sm_score.fnt")
        self.renShu_:setPosition(self.srTip_:getPositionX()+28, self.srTip_:getPositionY())
        self.renShu_:setAnchorPoint(0,0.5)
        self.csbNode_:addChild(self.renShu_)
    end
    self.renShu_:setString(#self.orginData_)
    if  ChaGuanData.getClubInfo().permission == 99 or ChaGuanData.getClubInfo().permission == 1 then
        self.tuChuClub_:show()
        self.jieSanClub_:hide()
        self.zhuanyi_:hide()
        self.gouXuan_:hide()
        if ChaGuanData.getClubInfo().permission == 1 then
            self.tianJia_:show()
        end
    else
        self.tianJia_:show()
        self.tuChuClub_:hide()
        self.jieSanClub_:show()
        self.zhuanyi_:show()
        self.gouXuan_:show()
    end
end


function ChengYuanListView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/club/memManagement/member/chengYuanListView.csb"):addTo(self)
end

function ChengYuanListView:yaoQingHandler_()
    display.getRunningScene():yaoQing()
end

function ChengYuanListView:tianJiaHandler_()
    if  ChaGuanData.getClubInfo().permission == 99 then
        app:showTips("只有群主和管理员可以添加成员！")
        return
    end
    local function callfunc(bool,uid)
        if bool then
            local params = {}
            params.uid = uid
            httpMessage.requestClubHttp(params, httpMessage.GET_USER_INFO)
        end
    end
    display.getRunningScene():initAddMember("请输入玩家ID", callfunc)
end

function ChengYuanListView:closeHandler_()
    self:hide()
end

function ChengYuanListView:getAimUser(findKey)
    local findData  = nil
    if findKey == "" then
        findData = clone(self.ptData_)
    else
        local aimUserInfo = {}
        local userUid = {}
        for key,value in pairs(self.orginData_) do
            if value.name and string.find(value.name, findKey) ~= nil then
                if not userUid[value.uid] then
                    table.insert(aimUserInfo,value)
                end
                userUid[value.uid] = true
            end
            if value.uid and string.find(value.uid .. "", findKey) ~= nil then
                if not userUid[value.uid] then
                    table.insert(aimUserInfo,value)
                end
                userUid[value.uid] = true
            end
        end
        findData = clone(aimUserInfo)
    end
    self:initPuTongList_(findData)
end

function ChengYuanListView:findHandler_()
    local info = self.inputNumber_:getString()
    self:getAimUser(info)
end

function ChengYuanListView:pagesLeftHandler_()
    self:changePagesIndex_(false)
end

function ChengYuanListView:pagesRightHandler_()
    self:changePagesIndex_(true)
end

return ChengYuanListView 
 