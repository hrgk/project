local DaYingJiaList = class("DaYingJiaList", function()
    return display.newSprite()
end)

function DaYingJiaList:ctor(data)
    self:initListView_()
    self:update(data)
end

function DaYingJiaList:initListView_()
    self.tableView_ = cc.TableView:create(cc.size(920, 450))      --列表的显示区域的大小
    self.tableView_:setDirection(1)         --设置列表是竖直方向
    self.tableView_:registerScriptHandler(handler(self, self.cellSizeForTable_),cc.TABLECELL_SIZE_FOR_INDEX)
    self.tableView_:registerScriptHandler(handler(self, self.tableCellAtIndex_),cc.TABLECELL_SIZE_AT_INDEX)
    self.tableView_:registerScriptHandler(handler(self, self.tableCellTouched_),cc.TABLECELL_TOUCHED)
    self.tableView_:registerScriptHandler(handler(self, self.numberOfCellsInTableView_),cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self:addChild(self.tableView_)
    self.tableView_:setPosition(-450, -205)
end

function DaYingJiaList:update(data, clubID)
    self.data_ = data
    self.clubID_ = clubID
    self.tableView_:reloadData()
end

function DaYingJiaList:cellSizeForTable_()
    return 120, 900
end

function DaYingJiaList:tableCellAtIndex_(table,idx)
    local cell = table:dequeueCell() 
    local index = idx + 1 
    if nil == cell then  
        cell = cc.TableViewCell:new() 
        local item = app:createView("chaguan.DaYingJiaListItem")
        item:update(self.data_[index])
        item:setPosition(cc.p(460, 60))  
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

function DaYingJiaList:tableCellTouched_(table,cell)
    local index = cell:getIdx() + 1
end

function DaYingJiaList:numberOfCellsInTableView_()
    return #self.data_
end

return DaYingJiaList 
