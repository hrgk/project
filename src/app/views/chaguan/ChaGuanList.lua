local ChaGuanList = class("ChaGuanList", function ( ... )
    return display.newSprite()
end)

function ChaGuanList:ctor()
    self:initListView_()
end

function ChaGuanList:initListView_()
    self.tableView_ = cc.TableView:create(cc.size(1200, 1000))      --列表的显示区域的大小
    self.tableView_:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)         --设置列表是竖直方向
    self.tableView_:registerScriptHandler(handler(self, self.cellSizeForTable_),cc.TABLECELL_SIZE_FOR_INDEX)
    self.tableView_:registerScriptHandler(handler(self, self.tableCellAtIndex_),cc.TABLECELL_SIZE_AT_INDEX)
    self.tableView_:registerScriptHandler(handler(self, self.tableCellTouched_),cc.TABLECELL_TOUCHED)
    self.tableView_:registerScriptHandler(handler(self, self.numberOfCellsInTableView_),cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self:addChild(self.tableView_)
    self.tableView_:setPosition(-800, -200)
end

function ChaGuanList:update(list)
    dump(list)
    self.list_ = list
    self.tableView_:reloadData()
end

function ChaGuanList:cellSizeForTable_()
    return 375, 410
end

function ChaGuanList:tableCellAtIndex_(table,idx)
    local cell = table:dequeueCell() 
    local index = idx + 1 
    if nil == cell then  
        cell = cc.TableViewCell:new() 
        local item = app:createView("chaguan.ChaGuanListItem")
        item:update(self.list_[index])
        item:setPosition(cc.p(210,250))  
        item:setTag(123)  
        cell:addChild(item)  
    else  
        local item = cell:getChildByTag(123)
            if nil ~= item then  
                item:update(self.list_[index])
            end  
        end
    return cell  
end

function ChaGuanList:tableCellTouched_(table,cell)
    local index = cell:getIdx() + 1
end

function ChaGuanList:numberOfCellsInTableView_()
    if self.list_ == nil then return end
    return #self.list_
end

return ChaGuanList 
