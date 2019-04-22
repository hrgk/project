local RecordList = class("RecordList", function()
    return display.newSprite()
end)

function RecordList:ctor(data)
    self.data_ = data
    self:initListView_()
end

function RecordList:initListView_()
    self.tableView_ = cc.TableView:create(cc.size(1100, 480))      --列表的显示区域的大小
    self.tableView_:setDirection(1)         --设置列表是竖直方向
    self.tableView_:setPosition(-600, -200+40)
    self.tableView_:registerScriptHandler(handler(self, self.cellSizeForTable_),cc.TABLECELL_SIZE_FOR_INDEX)
    self.tableView_:registerScriptHandler(handler(self, self.tableCellAtIndex_),cc.TABLECELL_SIZE_AT_INDEX)
    self.tableView_:registerScriptHandler(handler(self, self.tableCellTouched_),cc.TABLECELL_TOUCHED)
    self.tableView_:registerScriptHandler(handler(self, self.numberOfCellsInTableView_),cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self:addChild(self.tableView_)
    self.tableView_:reloadData()
end

function RecordList:cellSizeForTable_()
    return 90, 1068
end

function RecordList:tableCellAtIndex_(table,idx)
    local cell = table:dequeueCell() 
    local index = idx + 1 
    if nil == cell then  
        cell = cc.TableViewCell:new() 
        local item = app:createView("chaguan.shenQing.RecordItem")
        item:update(self.data_[index])
        item:setPosition(cc.p(550, 55))  
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

function RecordList:update(data)
    self.data_ = data
    self.tableView_:reloadData()
end

function RecordList:tableCellTouched_(table,cell)
    local index = cell:getIdx() + 1
end

function RecordList:numberOfCellsInTableView_()
    return #self.data_
end

return RecordList 
