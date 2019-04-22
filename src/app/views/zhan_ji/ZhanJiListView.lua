local BaseView = import("app.views.BaseView")
local ZhanJiListViewItem = import(".ZhanJiListViewItem")
local ZhanJiListView = class("ZhanJiListView", BaseView)

function ZhanJiListView:ctor()
    ZhanJiListView.super.ctor(self)
    self:getRoomList_()
    self.roomID_:hide()
    self.time_:hide()
end

function ZhanJiListView:getRoomList_()
    HttpApi.onHttpGetRoomRecords(-1,handler(self, self.sucHandler_), handler(self, self.failHandler_))
end

function ZhanJiListView:sucHandler_(data)
    local info = json.decode(data)
    self.data_ = data
    if info.status == 1 then
        self.rooms_ = info.data.rooms
        self:initTableList_()
        if #self.rooms_ > 0 then
            self.msg_:hide()
        end
    end
end

function ZhanJiListView:failHandler_(data)
end

function ZhanJiListView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/zhanji/zhanjiView.csb"):addTo(self)
    self.csbNode_:setPosition(display.cx, display.cy)
end

function ZhanJiListView:lookOtherHandler_()
    local view = display.getRunningScene():initInputView(2)
    view:setCallback(handler(self,self.huiFangBack_))
end

function ZhanJiListView:huiFangBack_(data)
    local scores = {}
    local obj = {}
    local users = {}
    for i,v in ipairs(data.users) do
        table.insert(scores, v[2])
        table.insert(users, v)
    end

    obj.scores = scores
    obj.roundID = data.roundID
    obj.req = data.seq
    obj.time = data.time
    local list = {obj}
    local view = display.getRunningScene():initZhanJuList(nil, true)
    view:setUsers(users, data.time)
    view:updateList(list)
end

function ZhanJiListView:pyqHandler_()
end

function ZhanJiListView:initTableList_()
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

function ZhanJiListView:cellSizeForTable_(table, idx)
    return 130, 1100
end

function ZhanJiListView:tableCellAtIndex_(table, idx)
    local cell = table:dequeueCell() 
    local index = idx + 1 
    local rank = #self.rooms_ - idx
    if nil == cell then  
        cell = cc.TableViewCell:new() 
        local item = ZhanJiListViewItem.new()
        item:update(self.rooms_[index], rank)
        item:setPosition(cc.p(550, 65))  
        item:setTag(123)  
        cell:addChild(item)  
    else  
        local item = cell:getChildByTag(123)
            if nil ~= item then  
                item:update(self.rooms_[index], rank)
            end  
        end
    return cell  
end

function ZhanJiListView:tableCellTouched_(table, cell)
end

function ZhanJiListView:numberOfCellsInTableView_()
    return #self.rooms_
end

return ZhanJiListView  
