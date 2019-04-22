local BaseView = import("app.views.BaseView")
local ChaGuanData = import("app.data.ChaGuanData")
local RecordView = class("RecordView", BaseView)

function RecordView:ctor()
    RecordView.super.ctor(self)
    self:initElementRecursive_(self.csbNode_)
    self.sort1Order = true
    self.sort2Order = true
    self.sort3Order = true
    self.confList = {
        [1] = {
            spr = {"views/club/memManagement/gameIcon/btn_gameAll_n.png", "views/club/memManagement/gameIcon/btn_gameAll_o.png"},
            gameType = GAME_GAME_ALL,
        },
        [2] = {
            spr = {"views/club/memManagement/gameIcon/btn_pdk_n.png", "views/club/memManagement/gameIcon/btn_pdk_o.png"},
            gameType = GAME_PAODEKUAI,
            switch = CHANNEL_CONFIGS.PAO_DE_KUAI,
        },
        [3] = {
            spr = {"views/club/memManagement/gameIcon/btn_cdphz_n.png", "views/club/memManagement/gameIcon/btn_cdphz_o.png"},
            gameType = GAME_CDPHZ,
            switch = CHANNEL_CONFIGS.CDPHZ,
        },
        [4] = {
            spr = {"views/club/memManagement/gameIcon/btn_csmj_n.png", "views/club/memManagement/gameIcon/btn_csmj_o.png"},
            gameType = GAME_MJCHANGSHA,
            switch = CHANNEL_CONFIGS.CHANG_SHA_MA_JIANG,
        },
        [5] = {
            spr = {"views/club/memManagement/gameIcon/btn_zzmj_n.png", "views/club/memManagement/gameIcon/btn_zzmj_o.png"},
            gameType = GAME_MJZHUANZHUAN,
            switch = CHANNEL_CONFIGS.ZHUAN_ZHUAN_MA_JIANG,
        },
        [6] ={
            spr = {"views/club/memManagement/gameIcon/btn_dtz_n.png", "views/club/memManagement/gameIcon/btn_dtz_o.png"},
            gameType = GAME_DA_TONG_ZI,
            switch = CHANNEL_CONFIGS.DA_TONG_ZI,
        },
        [7] = {
            spr = {"views/club/memManagement/gameIcon/btn_niuniu_n.png", "views/club/memManagement/gameIcon/btn_niuniu_o.png"},
            gameType = GAME_BCNIUNIU,
            switch = CHANNEL_CONFIGS.BING_CHENG_NIU_NIU,
        },
        [8] = {
            spr = {"views/club/memManagement/gameIcon/btn_hzmj_n.png", "views/club/memManagement/gameIcon/btn_hzmj_o.png"},
            gameType = GAME_MJHONGZHONG,
            switch = CHANNEL_CONFIGS.HONG_ZHONG_MA_JIANG,
        },
        [9] = {
            spr = {"views/club/memManagement/gameIcon/btn_13d_n.png", "views/club/memManagement/gameIcon/btn_13d_o.png"},
            gameType = GAME_13DAO,
            switch = CHANNEL_CONFIGS.DAO13,
        },
        [10] = {
            spr = {"views/club/memManagement/gameIcon/btn_sk_n.png", "views/club/memManagement/gameIcon/btn_sk_o.png"},
            gameType = GAME_SHUANGKOU,
            switch = CHANNEL_CONFIGS.SHUANG_KOU,
        },
        [11] = {
            spr = {"views/club/memManagement/gameIcon/btn_yzchz_n.png", "views/club/memManagement/gameIcon/btn_yzchz_o.png"},
            gameType = GAME_YZCHZ,
            switch = CHANNEL_CONFIGS.YZCHZ,
        },
        [12] = {
            spr = {"views/club/memManagement/gameIcon/btn_hsmj_n.png", "views/club/memManagement/gameIcon/btn_hsmj_o.png"},
            gameType = GAME_HSMJ,
            switch = CHANNEL_CONFIGS.HSMJ,
        },
        [13] = {
            spr = {"views/club/memManagement/gameIcon/btn_fhhzmj_n.png", "views/club/memManagement/gameIcon/btn_fhhzmj_o.png"},
            gameType = GAME_FHHZMJ,
            switch = CHANNEL_CONFIGS.FHHZMJ,
        },
    }
    self:addBtnToListView_()
    self:initTime_()
    self:onButtonClick_(self.btnList_[1], 2)
    self:eDay7Handler_()
    self:sDay7Handler_()
    self:getRecordInfo()
    self.gameSelectBg_:setVisible(false)
    self.gameList_:setVisible(false)
end

function RecordView:initListView_()
    if self.tableView_ and not tolua.isnull(self.tableView_) then
        self.tableView_:reloadData()
    else
        self.tableView_ = cc.TableView:create(cc.size(1200, 420))      --列表的显示区域的大小
        self.tableView_:setDirection(1)         --设置列表是竖直方向
        self.tableView_:setPosition(-800+90, -135)
        self.tableView_:registerScriptHandler(handler(self, self.cellSizeForTable_),cc.TABLECELL_SIZE_FOR_INDEX)
        self.tableView_:registerScriptHandler(handler(self, self.tableCellAtIndex_),cc.TABLECELL_SIZE_AT_INDEX)
        self.tableView_:registerScriptHandler(handler(self, self.tableCellTouched_),cc.TABLECELL_TOUCHED)
        self.tableView_:registerScriptHandler(handler(self, self.numberOfCellsInTableView_),cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
        self.showItem_:addChild(self.tableView_)
        self.tableView_:reloadData()
    end
end

function RecordView:cellSizeForTable_()
    return 90, 1068
end

function RecordView:tableCellAtIndex_(table,idx)
    local cell = table:dequeueCell() 
    local index = idx + 1 
    if nil == cell then  
        cell = cc.TableViewCell:new() 
        local item = app:createView("chaguan.memManagement.RecordViewItem")
        item:update(self.data_[index])
        item:setPosition(cc.p(550, -70))  
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

function RecordView:tableCellTouched_(table,cell)
    local index = cell:getIdx() + 1
end

function RecordView:numberOfCellsInTableView_()
    return #self.data_
end

function RecordView:initTime_()
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

function RecordView:getCmpScore(value)
    local maxScore = -9999
    local minScore = 9999
    for i = 1,4 do
        local cmpScore = value["score" .. i]
        if cmpScore > maxScore then
            maxScore = cmpScore
        end
        if cmpScore < minScore then
            minScore = cmpScore
        end
    end
    return maxScore,minScore
end

function RecordView:getOpreteData(data)
    self.opreteDataInfo = {}
    self.opreteDataInfo[GAME_GAME_ALL] = {}
    for i = 1,#data do
        local nowData = data[i]
        self.opreteDataInfo[nowData.game_type] = self.opreteDataInfo[nowData.game_type] or {}
        local maxScore,minScore = self:getCmpScore(nowData)
        print("maxScore_minScore",maxScore,minScore)
        for i = 1,4 do
            if nowData["uid" .. i] > 0 then
                local cmpScore = nowData["score" .. i]
                local aimKey = nowData["uid" .. i]..""
                if not self.opreteDataInfo[nowData.game_type][aimKey] then
                    self.opreteDataInfo[nowData.game_type][aimKey] = {
                        winnerCount = 0,
                        winnerScore = 0,
                        loseCount = 0,
                        loseScore = 0,
                        totalCount = 0,
                        totalScore = 0,
                    }
                end
                if not self.opreteDataInfo[GAME_GAME_ALL][aimKey] then
                    self.opreteDataInfo[GAME_GAME_ALL][aimKey] = {
                        winnerCount = 0,
                        winnerScore = 0,
                        loseCount = 0,
                        loseScore = 0,
                        totalCount = 0,
                        totalScore = 0,
                    }
                end
                local saveData = self.opreteDataInfo[nowData.game_type][aimKey]
                local saveDataAll = self.opreteDataInfo[GAME_GAME_ALL][aimKey]
                if cmpScore ~= 0 then
                    if cmpScore == maxScore then
                        saveData.winnerCount = saveData.winnerCount + 1
                        saveData.winnerScore = saveData.winnerScore + cmpScore
                        saveDataAll.winnerCount = saveDataAll.winnerCount + 1
                        saveDataAll.winnerScore = saveDataAll.winnerScore + cmpScore
                    end
                    if cmpScore == minScore then
                        saveData.loseCount = saveData.loseCount + 1
                        saveData.loseScore = saveData.loseScore + cmpScore
                        saveDataAll.loseCount = saveDataAll.loseCount + 1
                        saveDataAll.loseScore = saveDataAll.loseScore + cmpScore
                    end
                    saveData.totalCount = saveData.totalCount + 1
                    saveData.totalScore = saveData.totalScore + cmpScore
                    saveDataAll.totalCount = saveDataAll.totalCount + 1
                    saveDataAll.totalScore = saveDataAll.totalScore + cmpScore
                end
            end
        end
    end
    dump(self.opreteDataInfo,"self.opreteDataInfo")
end

function RecordView:updateViewByGameType()
    self.myData = {}
    self.oriData_ = {}
    self.data_ = {}
    if self.opreteDataInfo[self.selectGameType] then
        for key,value in pairs(self.opreteDataInfo[self.selectGameType]) do
            local info = {}
            info.avatar,info.name = "",""
            if self.userInfo_[key+0] then
                info.avatar = self.userInfo_[key+0].avatar
                info.name = self.userInfo_[key+0].name
            end
            info.uid = key+0
            info.winnerCount = value.winnerCount  
            info.winnerScore = value.winnerScore  
            info.loseCount = value.loseCount  
            info.loseScore = value.loseScore  
            info.totalCount = value.totalCount  
            info.totalScore = value.totalScore  
            table.insert(self.data_,info)
            if selfData:getUid() == key+0 then
                self.myData[1] = clone(info)
            end
        end 
    end
    self.oriData_ = clone(self.data_)
    self:initListView_()
    self:sort1Handler_()
end

function RecordView:updateView(data,userInfo)
    self:getOpreteData(data)
    self.userInfo_ = userInfo
    self:updateViewByGameType()
end

function RecordView:getRecordInfo()
    local params = {}
    local clubInfo = ChaGuanData.getClubInfo()
    params.clubID = clubInfo.clubID
    params.beginTime = self.beginTime
    params.endTime = self.endTime
    if self.beforeparams then
        if params.clubID == self.beforeparams.clubID and params.beginTime == self.beforeparams.beginTime 
            and params.endTime == self.beforeparams.endTime then
                self.sort1Order = not self.sort1Order
                self:updateViewByGameType()
            return
        end
    end
    self.beforeparams = clone(params)
    httpMessage.requestClubHttp(params, httpMessage.GET_CLUB_GAME_LOGS)
end

function RecordView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/club/memManagement/record/record.csb"):addTo(self)
end

function RecordView:addBtnToListView_()
    self.gameList_:removeAllChildren()
    self.btnList_ = {}
    local gameType = ChaGuanData.getAllGameType()
    local tag = {}
    for key,value in pairs(gameType) do
        tag[value] = true
    end
    for i,v in ipairs(self.confList) do
        if (tag[v.gameType] and v.switch) or (v.gameType == GAME_GAME_ALL) then
            local listItemLayout = ccui.Layout:create()
            listItemLayout:setContentSize(180,52)
            local btn =ccui.Button:create(v.spr[1], v.spr[1], v.spr[2])
            btn:addTouchEventListener(handler(self, self.onButtonClick_))
            btn:pos(86,26)
            listItemLayout:addChild(btn,1,12)
            btn.gameType = v.gameType
            table.insert(self.btnList_, btn)
            self.gameList_:pushBackCustomItem(listItemLayout)
        end 
    end
end

function RecordView:onButtonClick_(sender, eventType)
    if eventType == 0 then
        gameAudio.playSound("sounds/common/sound_button_click.mp3")
    elseif eventType == 2 then
        for i,v in ipairs(self.btnList_) do
            if v == sender then
                v:setEnabled(false)
                v:setBright(false)
                self:updateGame_(v.gameType)
            else
                v:setEnabled(true)
                v:setBright(true)
            end
        end
    end
end

function RecordView:updateGame_(gameType)
    self.gameName_:setString(GAMES_NAME[gameType])
    self.selectGameType = gameType
    self:yxxzHandler_()
end

function RecordView:onExit()

end

function RecordView:yxxzHandler_()
    local isShow = self.gameSelectBg_:isVisible()
    self.gameSelectBg_:setVisible(not isShow)
    self.gameList_:setVisible(not isShow)
end

function RecordView:sTimeHandler_()
    self.sTimeBg_:setVisible(not self.sTimeBg_:isVisible())
end

function RecordView:eTimeHandler_()
    self.eTimeBg_:setVisible(not self.eTimeBg_:isVisible())
end

function RecordView:cxHandler_()
    self:getRecordInfo()
end

function RecordView:qyqzjHandler_()
    if self.data_ and self.oriData_ and #self.data_ ~= #self.oriData_ then
        self.data_ = clone(self.oriData_)
        if self.tableView_ and not tolua.isnull(self.tableView_) then
            self.tableView_:reloadData()
        end
    end
end

function RecordView:myzjHandler_()
    if self.data_ and self.myData then
        self.data_ = clone(self.myData)
        if self.tableView_ and not tolua.isnull(self.tableView_) then
            self.tableView_:reloadData()
        end
    end
end

function RecordView:getAimUser(findKey)
    if self.data_ then
        if findKey == "" then
            self.data_ = clone(self.oriData_)
        else
            local aimUserInfo = {}
            for key,value in pairs(self.data_) do
                if string.find(value.name, findKey) ~= nil then
                    table.insert(aimUserInfo,value)
                end
            end
            self.data_ = clone(aimUserInfo)
        end
        if self.tableView_ and not tolua.isnull(self.tableView_) then
            self.tableView_:reloadData()
        end
    end
end

function RecordView:cxwjHandler_()
    local info = self.inputNumber_:getString()
    self:getAimUser(info)
end

function RecordView:xsqbHandler_()
    self:qyqzjHandler_()
end

function RecordView:sDay1Handler_()
    self:setBeginTime(1)
end

function RecordView:sDay2Handler_()
    self:setBeginTime(2)
end

function RecordView:sDay3Handler_()
    self:setBeginTime(3)
end

function RecordView:sDay4Handler_()
    self:setBeginTime(4)
end

function RecordView:sDay5Handler_()
    self:setBeginTime(5)
end

function RecordView:sDay6Handler_()
    self:setBeginTime(6)
end

function RecordView:sDay7Handler_()
    self:setBeginTime(7)
end


function RecordView:eDay1Handler_()
    self:setEndTime(1)
end

function RecordView:eDay2Handler_()
    self:setEndTime(2)
end

function RecordView:eDay3Handler_()
    self:setEndTime(3)
end

function RecordView:eDay4Handler_()
    self:setEndTime(4)
end

function RecordView:eDay5Handler_()
    self:setEndTime(5)
end

function RecordView:eDay6Handler_()
    self:setEndTime(6)
end

function RecordView:eDay7Handler_()
    self:setEndTime(7)
end

function RecordView:setBeginTime(index)
    local time = os.date("*t",self.timeValue[index])
    time.hour = 0
    time.min = 0
    time.second = 0
    time.sec = 0
    self.beginTime = os.time(time)
    self.sTimeValue_:setString(self["daySV" .. index .. "_"]:getString())
    self:sTimeHandler_()
end

function RecordView:setEndTime(index)
    local time = os.date("*t",self.timeValue[index])
    time.hour = 23
    time.min = 59
    time.second = 59
    time.sec = 59
    self.endTime = os.time(time)
    self.eTimeValue_:setString(self["daySV" .. index .. "_"]:getString())
    self:eTimeHandler_()
end

function RecordView:sort1Handler_()
    local function cmp(a,b)
        return a.winnerScore < b.winnerScore
    end
    local function cmp1(a,b)
        return a.winnerScore > b.winnerScore
    end
    if self.data_ then
        if self.sort1Order then
            table.sort(self.data_, cmp)
        else
            table.sort(self.data_, cmp1)
        end
        self.sortTag1_:setFlippedY(self.sort1Order)
        self.sort1Order = not self.sort1Order
        if self.tableView_ and not tolua.isnull(self.tableView_) then
            self.tableView_:reloadData()
        end
    end
end

function RecordView:sort2Handler_()
    local function cmp(a,b)
        return a.loseScore < b.loseScore
    end
    local function cmp1(a,b)
        return a.loseScore > b.loseScore
    end
    if self.data_ then
        if self.sort2Order then
            table.sort(self.data_, cmp)
        else
            table.sort(self.data_, cmp1)
        end
        self.sortTag2_:setFlippedY(self.sort2Order)
        self.sort2Order = not self.sort2Order
        if self.tableView_ and not tolua.isnull(self.tableView_) then
            self.tableView_:reloadData()
        end
    end
end

function RecordView:sort3Handler_()
    local function cmp(a,b)
        return a.totalScore < b.totalScore
    end
    local function cmp1(a,b)
        return a.totalScore > b.totalScore
    end
    if self.sort3Order then
        table.sort(self.data_, cmp)
    else
        table.sort(self.data_, cmp1)
    end
    if self.data_ then
        self.sortTag3_:setFlippedY(self.sort3Order)
        self.sort3Order = not self.sort3Order
        if self.tableView_ and not tolua.isnull(self.tableView_) then
            self.tableView_:reloadData()
        end
    end
end

return RecordView
