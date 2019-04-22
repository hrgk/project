local BaseView = import("app.views.BaseView")
local ChaGuanData = import("app.data.ChaGuanData")
local RankView = class("RankView", BaseView)

local RankItemView = import("app.views.chaguan.rank.RankItemView")

function RankView:ctor()
    RankView.super.ctor(self)

    self:initRank()
    self:bindEvent()
    
    self.week_:setVisible(false)
    self:roundBtnHandler_(self.roundBtn_)
end

function RankView:getRank(day, command)
    day = day or 0

    local btn = {self.today_, self.yesterday_, self.beforeYesterday_}
    for k, v in ipairs(btn) do
        v:setOpacity((k - 1) == day and 255 or 0)
    end

    local params = {}
    -- params.clubID = self.data_.clubID
    local clubInfo = ChaGuanData.getClubInfo()
    params.clubID = clubInfo.clubID
    params.beginTime = beginTime
    local time = os.date("*t", gailun.utils.getTime())
    time.day = time.day - 1
    time.hour = 23
    time.min = 59
    time.second = 58
    params.endTime = os.time(time)

    local map = {6, 0, 1, 2, 3, 4, 5}

    time.day = time.day - map[time.wday]
    local beginTime = os.time(time)
    if day == 0 then
        beginTime = -1
    end

    params.beginTime = beginTime

    httpMessage.requestClubHttp(params, command)
end

function RankView:bindEvent()
    cc.EventProxy.new(dataCenter, self, true)
    :addEventListener(httpMessage.CLUB_USER_RANK, handler(self, self.onClubUserRankHandler_))
    :addEventListener(httpMessage.CLUB_SCORE_RANK, handler(self, self.onClubScoreRankHandler_))
end

function RankView:onClubUserRankHandler_(event)
    local data = json.decode(event.data.result)
    if data == nil then
        return
    end
    if data.status ~= 1 then
        return
    end

    data = json.decode(data.data)

    table.sort(data, function(lh, rh)
        if lh.score ~= nil then
            return lh.score < rh.score
        end
        return lh.game_count < rh.game_count
    end)

    self.rankData = data
    self.tableView_:reloadData()

    -- local myRoundCount = 0
    -- for k, v in pairs(data) do
    --     if v.uid == selfData:getUid() then
    --         local myRoundCount = v.game_count
    --         break
    --     end
    -- end

    -- self.myRoundCount_:setString("局数:" .. myRoundCount)
end

function RankView:onClubScoreRankHandler_(event)
    local data = json.decode(event.data.result)
    if data.status ~= 1 then
        return
    end

    data = json.decode(data.data)

    table.sort(data, function(lh, rh)
        return lh.count < rh.count
    end)

    self.rankData = data
    self.tableView_:reloadData()

    -- local myRoundCount = 0
    -- for k, v in pairs(data) do
    --     if v.uid == selfData:getUid() then
    --         local myRoundCount = v.game_count
    --         break
    --     end
    -- end

    -- self.myRoundCount_:setString("局数:" .. myRoundCount)
end

function RankView:todayHandler_()
    self.today_:setVisible(false)
    self.week_:setVisible(true)
    if self.winBtn_ == self.nowTag then
        self:winBtnHandler_()
    else
        self:roundBtnHandler_()
    end
end

function RankView:weekHandler_()
    self.today_:setVisible(true)
    self.week_:setVisible(false)
    if self.winBtn_ == self.nowTag then
        self:winBtnHandler_()
    else
        self:roundBtnHandler_()
    end
end

function RankView:winBtnHandler_()
    self:switchType(self.winBtn_)
    
    self.nowTag = self.winBtn_
    self:getRank(self.week_:isVisible() and 1 or 0, httpMessage.CLUB_SCORE_RANK)
end

function RankView:roundBtnHandler_()
    self:switchType(self.roundBtn_)
    self.nowTag = self.roundBtn_
    self:getRank(self.week_:isVisible() and 1 or 0, httpMessage.CLUB_USER_RANK)
end

function RankView:switchType(sender)
    local list = {
        [self.winBtn_] = "views/julebu/rank/winListBtn%d.png",
        [self.roundBtn_] = "views/julebu/rank/roundListBtn%d.png"
    }

    for btn, path in pairs(list) do
        local isSender = sender == btn
        local realPath = string.format(path, isSender and 2 or 1)
        
        local spr = btn:getChildByTag(1)
        if isSender then
            if spr == nil then
                spr = display.newSprite(realPath):addTo(btn):pos(77, 74)
                spr:setTag(1)
                spr:setAnchorPoint(cc.p(1, 0.5))
            end
            spr:show()
        else
            if spr ~= nil then
                spr:hide()
            end
        end
    end
end

function RankView:initRank()
    self.rankData = {}
    self.tableView_ = cc.TableView:create(cc.size(900, 420))      --列表的显示区域的大小
    self.tableView_:setDirection(1)         --设置列表是竖直方向
    self.tableView_:setPosition(-400, -190)
    self.tableView_:registerScriptHandler(handler(self, self.cellSizeForTable_), cc.TABLECELL_SIZE_FOR_INDEX)
    self.tableView_:registerScriptHandler(handler(self, self.tableCellAtIndex_), cc.TABLECELL_SIZE_AT_INDEX)
    self.tableView_:registerScriptHandler(handler(self, self.tableCellTouched_), cc.TABLECELL_TOUCHED)
    self.tableView_:registerScriptHandler(handler(self, self.numberOfCellsInTableView_), cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.csbNode_:addChild(self.tableView_)
    self.tableView_:zorder(100)
end

function RankView:tableCellAtIndex_(table, idx)
    local cell = table:dequeueCell() 
    local index = idx + 1 
    if nil == cell then  
        cell = cc.TableViewCell:new() 
        local item = RankItemView:new()
        item:updateView(self.rankData[index], #self.rankData - idx)
        item:setPosition(cc.p(400, 30))  
        item:setTag(123)  
        cell:addChild(item)  
    else  
        local item = cell:getChildByTag(123)
            if nil ~= item then  
                item:updateView(self.rankData[index], #self.rankData - idx)
            end  
        end
    return cell  
end

function RankView:cellSizeForTable_(table, idx)
    return 110, 900
end

function RankView:tableCellTouched_(table, cell)
end

function RankView:numberOfCellsInTableView_()
    return #self.rankData
end

function RankView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/julebu/rank/rankView.csb"):addTo(self)
    self.csbNode_:setPosition(display.cx, display.cy)
    self:setMask(80)
end

return RankView 
