local BaseView = import("app.views.BaseView")
local DuiJuListViewItem = import(".DuiJuListViewItem")
local DuiJuListView = class("DuiJuListView", BaseView)

function DuiJuListView:ctor(data, isHuiFang)
    DuiJuListView.super.ctor(self)
    if isHuiFang then return end
    self.data_ = data
    self:getRoundList_(data.recordID)
end

function DuiJuListView:getRoundList_(recordID)
    HttpApi.onHttpGetRoundList(self.data_.clubID, recordID,handler(self, self.sucHandler_), handler(self, self.failHandler_))
end

function DuiJuListView:sucHandler_(data)
    local info = json.decode(data)
    if info.status == 1 then
        self.rounds_ = info.data.rounds
        self:initTableList_()
    end
end

function DuiJuListView:updateList(list)
    self.rounds_ = list
    if self.tableView_ then
        self.tableView_:reloadData()
    else
        self:initTableList_()
    end
end

function DuiJuListView:failHandler_(data)
end

function DuiJuListView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/club/memManagement/zhanji/zhanjuView.csb"):addTo(self)
    self.csbNode_:setPosition(display.cx, display.cy)
end

function DuiJuListView:setUsers(users, time)
    self.data_ = {}
    self.data_.users = users
    self.msg_:hide()
    self.tishi_:hide()
    self.roomID_:hide()
    self.time_:setString("对战时间：".. os.date("%Y-%m-%d  %H:%M:%S", time))
end

function DuiJuListView:pyqHandler_()
end

function DuiJuListView:initTableList_()
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

function DuiJuListView:cellSizeForTable_(table, idx)
    return 130, 1100
end

function DuiJuListView:tableCellAtIndex_(table, idx)
    local cell = table:dequeueCell() 
    local index = idx + 1 
    if nil == cell then  
        cell = cc.TableViewCell:new() 
        local item = DuiJuListViewItem.new()
        item:setPosition(cc.p(550, 65))
        item:update(self.rounds_[index], self.data_.users)  
        item:setTag(123)  
        cell:addChild(item)  
    else  
        local item = cell:getChildByTag(123)
            if nil ~= item then  
                item:update(self.rounds_[index], self.data_.users)  
            end  
        end
    return cell  
end

function DuiJuListView:tableCellTouched_(table, cell)
end

function DuiJuListView:numberOfCellsInTableView_()
    return #self.rounds_
end

return DuiJuListView  
