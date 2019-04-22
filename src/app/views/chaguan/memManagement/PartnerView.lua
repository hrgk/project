local BaseView = import("app.views.BaseView")
local ChaGuanData = import("app.data.ChaGuanData")
local PartnerView = class("PartnerView", BaseView)

function PartnerView:ctor(userInfoTag,userDataInfo)
    PartnerView.super.ctor(self)
    self:initElementRecursive_(self.csbNode_)
    self:initTime_()
    self:eDay7Handler_()
    self:sDay7Handler_()
    self:getPartnerInfo()
    self.scoreValue = {5,10,15,20,30}
    self:createUserTree(userDataInfo,userInfoTag)
    local score = ChaGuanData.getQueryWinnerScore()
    if score == 0 then
        self.scoreSelectIndx = 1
    else
        self.scoreSelectIndx = score
    end
    self:upDateByScore(self.scoreSelectIndx)
    if ChaGuanData.getClubInfo().permission ~= 0 then
        self.scoreSelect_:hide()
    end
end

function PartnerView:initListView_()
    if self.tableView_ and not tolua.isnull(self.tableView_) then
        self.tableView_:reloadData()
    else
        self.tableView_ = cc.TableView:create(cc.size(1100, 480))      --列表的显示区域的大小
        self.tableView_:setDirection(1)         --设置列表是竖直方向
        self.tableView_:setPosition(-800+90, -205)
        self.tableView_:registerScriptHandler(handler(self, self.cellSizeForTable_),cc.TABLECELL_SIZE_FOR_INDEX)
        self.tableView_:registerScriptHandler(handler(self, self.tableCellAtIndex_),cc.TABLECELL_SIZE_AT_INDEX)
        self.tableView_:registerScriptHandler(handler(self, self.tableCellTouched_),cc.TABLECELL_TOUCHED)
        self.tableView_:registerScriptHandler(handler(self, self.numberOfCellsInTableView_),cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
        self.showItem_:addChild(self.tableView_)
        self.tableView_:reloadData()
    end
end

function PartnerView:cellSizeForTable_()
    return 90, 1068
end

function PartnerView:tableCellAtIndex_(table,idx)
    local cell = table:dequeueCell() 
    local index = idx + 1 
    if nil == cell then  
        cell = cc.TableViewCell:new() 
        local item = app:createView("chaguan.memManagement.PartnerViewItem")
        item:update(self.data_[index])
        item:setPosition(cc.p(550, -60))  
        item:setTag(123)  
        cell:addChild(item)  
    else  
        local item = cell:getChildByTag(123)
            if nil ~= item then  
                item:update(self.data_[index])
            end  
        end
    return cell  
end

function PartnerView:tableCellTouched_(table,cell)
    local index = cell:getIdx() + 1
end

function PartnerView:numberOfCellsInTableView_()
    return #self.data_
end

function PartnerView:initTime_()
    local time = os.date("*t", gailun.utils.getTime())
    time.day = time.day
    time.hour = 23
    time.min = 59
    time.second = 59
    self.timeValue = {}
    for i = 1,7 do
        if i > 1 then
            time.day = time.day - 1
        end
        local combInfo = os.time(time)
        table.insert(self.timeValue, 1, combInfo)
    end
    for i = 1,7 do
        local str = os.date("%Y.%m.%d", self.timeValue[i])
        self["daySV" .. i .. "_"]:setString(str)
        self["dayEV" .. i .. "_"]:setString(str)
    end
end

function PartnerView:updateView(data)
    self:getOpreteData(data)
    self:upDateByScore(self.scoreSelectIndx)
end

function PartnerView:getPartnerInfo()
    local params = {}
    local clubInfo = ChaGuanData.getClubInfo()
    params.clubID = clubInfo.clubID
    params.beginTime = self.beginTime
    params.endTime = self.endTime
    if self.beforeparams then
        if params.clubID == self.beforeparams.clubID and params.beginTime == self.beforeparams.beginTime 
            and params.endTime == self.beforeparams.endTime then
            return
        end
    end
    self.beforeparams = clone(params)
    httpMessage.requestClubHttp(params, httpMessage.GET_CLUB_GAME_LOGS)
end

function PartnerView:setClubQueryWinnerScore()
    local params = {}
    local clubInfo = ChaGuanData.getClubInfo()
    params.clubID = clubInfo.clubID
    params.score = self.scoreSelectIndx
    ChaGuanData.setQueryWinnerScore(self.scoreSelectIndx)
    httpMessage.requestClubHttp(params, httpMessage.SET_CLUB_QUERY_WINNER_SCORE)
end

function PartnerView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/club/memManagement/partner/partner.csb"):addTo(self)
end

function PartnerView:onExit()

end

function PartnerView:sTimeHandler_()
    self.sTimeBg_:setVisible(not self.sTimeBg_:isVisible())
end

function PartnerView:eTimeHandler_()
    self.eTimeBg_:setVisible(not self.eTimeBg_:isVisible())
end

function PartnerView:cxHandler_()
    self:getPartnerInfo()
end

function PartnerView:xsqbHandler_()
    self:qyqzjHandler_()
end

function PartnerView:sDay1Handler_()
    self:setBeginTime(1)
end

function PartnerView:sDay2Handler_()
    self:setBeginTime(2)
end

function PartnerView:sDay3Handler_()
    self:setBeginTime(3)
end

function PartnerView:sDay4Handler_()
    self:setBeginTime(4)
end

function PartnerView:sDay5Handler_()
    self:setBeginTime(5)
end

function PartnerView:sDay6Handler_()
    self:setBeginTime(6)
end

function PartnerView:sDay7Handler_()
    self:setBeginTime(7)
end


function PartnerView:eDay1Handler_()
    self:setEndTime(1)
end

function PartnerView:eDay2Handler_()
    self:setEndTime(2)
end

function PartnerView:eDay3Handler_()
    self:setEndTime(3)
end

function PartnerView:eDay4Handler_()
    self:setEndTime(4)
end

function PartnerView:eDay5Handler_()
    self:setEndTime(5)
end

function PartnerView:eDay6Handler_()
    self:setEndTime(6)
end

function PartnerView:eDay7Handler_()
    self:setEndTime(7)
end

function PartnerView:setBeginTime(index)
    local time = os.date("*t",self.timeValue[index])
    time.hour = 0
    time.min = 0
    time.second = 0
    time.sec = 0
    self.beginTime = os.time(time)
    self.sTimeValue_:setString(self["daySV" .. index .. "_"]:getString())
    self:sTimeHandler_()
end

function PartnerView:setEndTime(index)
    local time = os.date("*t",self.timeValue[index])
    time.hour = 23
    time.min = 59
    time.second = 59
    time.sec = 59
    self.endTime = os.time(time)
    self.eTimeValue_:setString(self["daySV" .. index .. "_"]:getString())
    self:eTimeHandler_()
end

function PartnerView:scoreSelectHandler_()
    self.scoreSelectP_:setVisible(not self.scoreSelectP_:isVisible())
end

function PartnerView:score1Handler_()
    self:upDateByScore(1)
end

function PartnerView:score2Handler_()
    self:upDateByScore(2)
end

function PartnerView:score3Handler_()
    self:upDateByScore(3)
end

function PartnerView:score4Handler_()
    self:upDateByScore(4)
end

function PartnerView:score5Handler_()
    self:upDateByScore(5)
end

function PartnerView:upDateByScore(index)
    if self.scoreSelectIndx ~= index then
        self.scoreSelectIndx = index
        self:setClubQueryWinnerScore()
    else
        self.scoreSelectIndx = index
    end
    self.scoreSelectP_:setVisible(false)
    self.scoreSelectResult_:loadTexture("views/club/memManagement/partner/" .. index .. ".png")
    self.data_ = {}
    if self.opreteDataInfo then
        for i = 1,#self.opreteDataInfo do
            self.data_[i] = {}
            self.data_[i].nick_name = self.opreteDataInfo[i].nickName
            self.data_[i].tag_uid = self.opreteDataInfo[i].userId
            self.data_[i].winnerCount = self.opreteDataInfo[i].dyjCount
            self.data_[i].club_user_count = self.opreteDataInfo[i].wjCount
            self.data_[i].lessCount = self.opreteDataInfo[i].scoreNum[index]
            self.data_[i].realWinnerCount = self.data_[i].winnerCount - self.data_[i].lessCount
        end
    end
    self:initListView_()
end


function PartnerView:addDyjCount(index,value)
    for i = 1,#self.scoreValue do
        if value <= self.scoreValue[i] then
            self.opreteDataInfo[index].scoreNum[i] = self.opreteDataInfo[index].scoreNum[i] + 1
        end
    end
    self.opreteDataInfo[index].dyjCount = self.opreteDataInfo[index].dyjCount + 1
end

function PartnerView:createUserTree(data,userInfoTag)
    self.userTree_ = {}
    for k,value in ipairs(data) do
        if k > 1 then
            local temp = {}
            temp.nickName = value[1].name
            temp.userId = userInfoTag[k]
            temp.scoreNum = {0,0,0,0,0}
            temp.myPalyer = {}
            temp.dyjCount = 0
            temp.wjCount = 0
            temp.zccCount = 0
            for i = 1,#value do
                if value[i].tagUid == temp.userId then
                    temp.myPalyer[value[i].uid..""] = true 
                    temp.wjCount = temp.wjCount + 1
                end
                if value[i].uid == temp.userId then
                    temp.nickName = value[i].name
                end
            end
            table.insert(self.userTree_,clone(temp))
        end
    end
end

function PartnerView:getMaxScore(value)
    local maxScore = -9999
    for i = 1,4 do
        if value["score" .. i] > maxScore then
            maxScore = value["score" .. i]
        end
    end
    return maxScore
end

function PartnerView:findPrent(uid)
    for i = 1,#self.opreteDataInfo do
        if self.opreteDataInfo[i].myPalyer[uid] then
            return i
        end
    end
end

function PartnerView:getOpreteData(data)
    self.opreteDataInfo = clone(self.userTree_)
    for k,value in ipairs(data) do
        local maxScore = self:getMaxScore(value)
        local indexTag = {}
        for i = 1,4 do
            if value["uid" .. i] > 0 then
                local aimKey = value["uid" .. i]..""
                local index = self:findPrent(aimKey)
                if index then
                    indexTag[index] = true
                end
                if value["score" .. i] == maxScore and maxScore > 0 then
                    if index then
                        self:addDyjCount(index,maxScore)
                    else
                        print("error",aimKey)
                    end
                end
            end
        end
        for i,v in pairs(indexTag) do
            self.opreteDataInfo[i].zccCount = self.opreteDataInfo[i].zccCount + 1
        end
    end
end

return PartnerView
