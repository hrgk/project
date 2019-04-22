local GongXianList = class("GongXianList", function()
        return display.newSprite()
    end)

function GongXianList:ctor()
    self:initListView_()
end

function GongXianList:initListView_()
    self.tableView_ = cc.TableView:create(cc.size(1000, 500))      --列表的显示区域的大小
    self.tableView_:setDirection(1)         --设置列表是竖直方向
    self.tableView_:registerScriptHandler(handler(self, self.cellSizeForTable_),cc.TABLECELL_SIZE_FOR_INDEX)
    self.tableView_:registerScriptHandler(handler(self, self.tableCellAtIndex_),cc.TABLECELL_SIZE_AT_INDEX)
    self.tableView_:registerScriptHandler(handler(self, self.tableCellTouched_),cc.TABLECELL_TOUCHED)
    self.tableView_:registerScriptHandler(handler(self, self.numberOfCellsInTableView_),cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self:addChild(self.tableView_)
    self.tableView_:setPosition(-510, -300)
end

function GongXianList:update(list)
    self.list_ = list
    self.tableView_:reloadData()
end

function GongXianList:cellSizeForTable_()
    return 110, 980
end

function GongXianList:tableCellAtIndex_(table,idx)
    local cell = table:dequeueCell() 
    local index = idx + 1 
    if nil == cell then  
        cell = cc.TableViewCell:new() 
        local item = app:createView("chaguan.GongXianItem")
        item:update(self.list_[index])
        item:setPosition(cc.p(520, 50))  
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

function GongXianList:tableCellTouched_(table,cell)
    local index = cell:getIdx() + 1
end

function GongXianList:numberOfCellsInTableView_()
    if self.list_ == nil then return end
    return #self.list_
    -- return 10
end

return GongXianList 
