local BaseView = import("app.views.BaseView")
local SetMembersViewItem = import(".SetMembersViewItem")
local SetMembersView = class("SetMembersView", BaseView)

function SetMembersView:ctor(data)
    SetMembersView.super.ctor(self)
    self.data_ = data
    self.players = self.data_.players    
    self:initTableList_()
    self.wjzjf_:setString("玩家总积分：" .. self.data_.totalScore)
    self.zrxzxh_:setString("昨日限制消耗：" .. self.data_.totalLimitScore)
end

function SetMembersView:updateList(list)
    self.data_ = list
    self.wjzjf_:setString("玩家总积分：" .. self.data_.totalScore)
    self.zrxzxh_:setString("昨日限制消耗：" .. self.data_.totalLimitScore)
    self.players = self.data_.players
    self:updateShow()
end

function SetMembersView:updateShow()
    if self.tableView_ and not tolua.isnull(self.tableView_) then
        self.tableView_:reloadData()
    else
        self:initTableList_()
    end
end

function SetMembersView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/club/members/setMembers.csb"):addTo(self)
    self.csbNode_:setPosition(display.cx, display.cy)
end

function SetMembersView:pyqHandler_()
end

function SetMembersView:initTableList_()
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

function SetMembersView:cellSizeForTable_(table, idx)
    return 80, 1100
end

function SetMembersView:tableCellAtIndex_(table, idx)
    local cell = table:dequeueCell() 
    local index = idx + 1 
    if nil == cell then  
        cell = cc.TableViewCell:new() 
        local item = SetMembersViewItem.new()
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

function SetMembersView:tableCellTouched_(table, cell)
end

function SetMembersView:numberOfCellsInTableView_()
    return #self.players
end

function SetMembersView:findHandler_()
    local name = self.findFont_:getString()
    if name == "" then
        self.players = self.data_.players
    else
        local aimplyers = {}
        for key,value in ipairs(self.players) do
            if string.find(value.nickName, name) ~= nil then
                table.insert(aimplyers,value)
            end
        end
        self.players = aimplyers
    end
    self:updateShow()
end

function SetMembersView:jlHandler_()
    display.getRunningScene():requestDouOperLogs(self.data_.totalScore,self.data_.totalLimitScore)
end

return SetMembersView  