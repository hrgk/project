local BaseView = import("app.views.BaseView")
local RecordXQViewItem = import(".RecordXQViewItem")
local RecordXQView = class("RecordXQView", BaseView)

function RecordXQView:ctor(data)
    RecordXQView.super.ctor(self)
    if isHuiFang then return end
    self.data_ = data
    self.rounds_ = data.data.rooms
    dump(self.rounds_,"self.rounds_self.rounds_")
    self:initTableList_()
end

function RecordXQView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/club/memManagement/record/recordXQView.csb"):addTo(self)
    self.csbNode_:setPosition(display.cx, display.cy)
end

function RecordXQView:setUsers(users, time)
    self.data_ = {}
    self.data_.users = users
    self.msg_:hide()
    self.tishi_:hide()
    self.roomID_:hide()
    self.time_:setString("对战时间：".. os.date("%Y-%m-%d  %H:%M:%S", time))
end

function RecordXQView:pyqHandler_()
end

function RecordXQView:initTableList_()
    self.itemList_ = {}
    self.tableView_ = cc.TableView:create(cc.size(1250, 520))      --列表的显示区域的大小
    self.tableView_:setDirection(1)         --设置列表是竖直方向
    self.tableView_:setPosition(-550, -250)
    self.tableView_:registerScriptHandler(handler(self, self.cellSizeForTable_), cc.TABLECELL_SIZE_FOR_INDEX)
    self.tableView_:registerScriptHandler(handler(self, self.tableCellAtIndex_), cc.TABLECELL_SIZE_AT_INDEX)
    self.tableView_:registerScriptHandler(handler(self, self.tableCellTouched_), cc.TABLECELL_TOUCHED)
    self.tableView_:registerScriptHandler(handler(self, self.numberOfCellsInTableView_), cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.content_:addChild(self.tableView_)
    self.tableView_:reloadData()
end

function RecordXQView:cellSizeForTable_(table, idx)
    return 130, 1100
end

function RecordXQView:tableCellAtIndex_(table, idx)
    local cell = table:dequeueCell() 
    local index = idx + 1 
    if nil == cell then  
        cell = cc.TableViewCell:new() 
        local item = RecordXQViewItem.new()
        item:setPosition(cc.p(550, 65))
        item:update(self.rounds_[index].users)  
        item:setTag(123)  
        cell:addChild(item)  
    else  
        local item = cell:getChildByTag(123)
            if nil ~= item then  
                item:update(self.rounds_[index].users)  
            end  
        end
    return cell  
end

function RecordXQView:tableCellTouched_(table, cell)
end

function RecordXQView:numberOfCellsInTableView_()
    return #self.rounds_
end

return RecordXQView  
