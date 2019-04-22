local BaseView = import("app.views.BaseView")
local FatigueValueViewItem = import(".FatigueValueViewItem")
local FatigueValueView = class("FatigueValueView", BaseView)

function FatigueValueView:ctor(data,totalScore,totalLimitScore)
    FatigueValueView.super.ctor(self)
    self.data_ = data
    self.players = self.data_.data
    self:initTableList_()
    local commissionSum = 0
    for _,v in ipairs(data.data) do
        commissionSum = commissionSum + v.commission
    end
    self.zenSonFen_:setString(tostring(commissionSum))
    self.dayList_ = {[1] = self.oneday_,[2] = self.towday_,[3] = self.Sevenday_}
end

function FatigueValueView:updateList(list,totalScore,totalLimitScore)
    self.data_ = list.data
    self.players = self.data_
    self:updateShow()
end

function FatigueValueView:updateShow()
    if self.tableView_ and not tolua.isnull(self.tableView_) then
        local commissionSum = 0
        for _,v in ipairs(self.data_) do
            commissionSum = commissionSum + v.commission
        end
        self.zenSonFen_:setString(tostring(commissionSum))
        self.tableView_:reloadData()
    else
        self:initTableList_()
    end
end

function FatigueValueView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/club/members/FatigueValuebers.csb"):addTo(self)
    self.csbNode_:setPosition(display.cx, display.cy)
end

function FatigueValueView:pyqHandler_()
end

function FatigueValueView:initTableList_()
    self.itemList_ = {}
    self.tableView_ = cc.TableView:create(cc.size(1250, 440))      --列表的显示区域的大小
    self.tableView_:setDirection(1)         --设置列表是竖直方向
    self.tableView_:setPosition(-570, -250+35)
    self.tableView_:registerScriptHandler(handler(self, self.cellSizeForTable_), cc.TABLECELL_SIZE_FOR_INDEX)
    self.tableView_:registerScriptHandler(handler(self, self.tableCellAtIndex_), cc.TABLECELL_SIZE_AT_INDEX)
    self.tableView_:registerScriptHandler(handler(self, self.tableCellTouched_), cc.TABLECELL_TOUCHED)
    self.tableView_:registerScriptHandler(handler(self, self.numberOfCellsInTableView_), cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.content_:addChild(self.tableView_)
    self.tableView_:reloadData()
end

function FatigueValueView:cellSizeForTable_(table, idx)
    return 80, 1200
end

function FatigueValueView:tableCellAtIndex_(table, idx)
    local cell = table:dequeueCell() 
    local index = idx + 1 
    if nil == cell then  
        cell = cc.TableViewCell:new() 
        local item = FatigueValueViewItem.new()
        item:setPosition(cc.p(570, 45))
        item:update(self.players[index])  
        item:setTag(123)  
        cell:addChild(item)  
    else  
        local item = cell:getChildByTag(123)
            if nil ~= item then  
                item:update(self.players[index])  
            end  
        end
    return cell  
end

function FatigueValueView:tableCellTouched_(table, cell)
end

function FatigueValueView:numberOfCellsInTableView_()
    return #self.players
end

function FatigueValueView:findHandler_()
    local name = self.findFont_:getString()
    if name == "" then
        self.players = self.data_
    else
        local aimplyers = {}
        for key,value in ipairs(self.players) do
            if string.find(value.nickname, name) ~= nil then
                table.insert(aimplyers,value)
            end
        end
        self.players = aimplyers
    end
    self:updateShow()
end

function FatigueValueView:onedayHandler_()
    self:upDateView(1)
end

function FatigueValueView:towdayHandler_()
    self:upDateView(2)
end

function FatigueValueView:SevendayHandler_()
    self:upDateView(3)
end

function FatigueValueView:upDateView(index)
    for i,v in ipairs(self.dayList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
    local dateTodayTime = display.getRunningScene():getTodayTimeStamp()
    local fromTime = nil
    local toTime = nil
    if index == 1 then
        fromTime = dateTodayTime
        toTime = os.time()
    elseif index == 2 then
        fromTime = dateTodayTime -24*3600
        toTime = dateTodayTime
    else
        fromTime = dateTodayTime - 7 * 24 * 3600
        toTime = dateTodayTime
    end
    display.getRunningScene():requestClubFatigValue_(fromTime,toTime)
end


function FatigueValueView:plHandler_()
    self:closeHandler_()
end

return FatigueValueView  
