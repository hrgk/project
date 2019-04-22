local BaseView = import("app.views.BaseView")
local ZhanJuListViewItem = import(".ZhanJuListViewItem")
local ZhanJuListView = class("ZhanJuListView", BaseView)

function ZhanJuListView:ctor(data, isHuiFang)
    ZhanJuListView.super.ctor(self)
    if isHuiFang then return end
    self.data_ = data
    self.msg_:hide()
    self.tishi_:hide()
    self.roomID_:setString("房间号：".. data.roomID)
    self.time_:setString("对战时间：".. os.date("%Y-%m-%d  %H:%M:%S", data.time))
    self:getRoundList_(data.recordID)
end

function ZhanJuListView:getRoundList_(recordID)
    HttpApi.onHttpGetRoundList(-1,recordID,handler(self, self.sucHandler_), handler(self, self.failHandler_))
end

function ZhanJuListView:sucHandler_(data)
    local info = json.decode(data)
    if info.status == 1 then
        self.rounds_ = info.data.rounds
        self:initTableList_()
    end
end

function ZhanJuListView:updateList(list)
    self.rounds_ = list
    if self.tableView_ then
        self.tableView_:reloadData()
    else
        self:initTableList_()
    end
end

function ZhanJuListView:failHandler_(data)
end

function ZhanJuListView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/zhanji/zhanjiView.csb"):addTo(self)
    self.csbNode_:setPosition(display.cx, display.cy)
end

function ZhanJuListView:lookOtherHandler_()
    local view = display.getRunningScene():initInputView(2)
    view:setCallback(handler(self,self.huiFangBack_))
end

function ZhanJuListView:huiFangBack_(data)
    self.data_.users = {}
    local scores = {}
    local obj = {}
    for i,v in ipairs(data.users) do
        table.insert(scores, v[2])
        table.insert(self.data_.users, v)
    end
    obj.scores = scores
    obj.roundID = data.roundID
    obj.req = data.seq
    obj.time = data.time
    self.time_:setString("对战时间：".. os.date("%Y-%m-%d  %H:%M:%S", data.time))
    local list = {obj}
    self:updateList(list)
end

function ZhanJuListView:setUsers(users, time)
    self.data_ = {}
    self.data_.users = users
    self.msg_:hide()
    self.tishi_:hide()
    self.roomID_:hide()
    self.time_:setString("对战时间：".. os.date("%Y-%m-%d  %H:%M:%S", time))
end

function ZhanJuListView:pyqHandler_()
end

function ZhanJuListView:initTableList_()
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

function ZhanJuListView:cellSizeForTable_(table, idx)
    return 130, 1100
end

function ZhanJuListView:tableCellAtIndex_(table, idx)
    local cell = table:dequeueCell() 
    local index = idx + 1 
    if nil == cell then  
        cell = cc.TableViewCell:new() 
        local item = ZhanJuListViewItem.new()
        item:setPosition(cc.p(550, 65))
        item:update(self.rounds_[index], self.data_.users,self.data_.gameType)  
        item:setTag(123)  
        cell:addChild(item)  
    else  
        local item = cell:getChildByTag(123)
            if nil ~= item then  
                item:update(self.rounds_[index], self.data_.users,self.data_.gameType)  
            end  
        end
    return cell  
end

function ZhanJuListView:tableCellTouched_(table, cell)
end

function ZhanJuListView:numberOfCellsInTableView_()
    return #self.rounds_
end

return ZhanJuListView  
