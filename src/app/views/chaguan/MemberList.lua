 local MemberList = class("MemberList", gailun.BaseView)

function MemberList:ctor()
    self:initListView_()
end

function MemberList:initListView_()
    self.tableView_ = cc.TableView:create(cc.size(820, 460))      --列表的显示区域的大小
    self.tableView_:setDirection(1)         --设置列表是竖直方向
    self.tableView_:registerScriptHandler(handler(self, self.cellSizeForTable_),cc.TABLECELL_SIZE_FOR_INDEX)
    self.tableView_:registerScriptHandler(handler(self, self.tableCellAtIndex_),cc.TABLECELL_SIZE_AT_INDEX)
    self.tableView_:registerScriptHandler(handler(self, self.tableCellTouched_),cc.TABLECELL_TOUCHED)
    self.tableView_:registerScriptHandler(handler(self, self.numberOfCellsInTableView_),cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self:addChild(self.tableView_)
end

function MemberList:cellSizeForTable_()
    return 120, 590
end

function MemberList:tableCellAtIndex_(table,idx)
    local cell = table:dequeueCell() 
    local index = idx + 1 
    if nil == cell then  
        cell = cc.TableViewCell:new() 
        local item = app:createView("chaguan.MemberListItem")
        item:update(self.data_[index], self.clubData_)
        item:setPosition(cc.p(405, 60))  
        item:setTag(123)  
        cell:addChild(item)  
    else  
        local item = cell:getChildByTag(123)
            if nil ~= item then  
                item:update(self.data_[index],self.clubData_)
            end  
        end
    return cell  
end

function MemberList:update(data, clubData)
    dump(data)
    self.data_ = data
    self.clubData_ = clubData
    self.tableView_:reloadData()
end

function MemberList:tableCellTouched_(table,cell)
    local index = cell:getIdx() + 1
end

function MemberList:numberOfCellsInTableView_()
    return #self.data_
end

return MemberList   
