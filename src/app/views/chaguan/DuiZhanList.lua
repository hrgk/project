local ChaGuanData = import("app.data.ChaGuanData")

local DuiZhanList = class("DuiZhanList", function()
        return display.newSprite()
end)

function DuiZhanList:ctor(data)
    self.isOpen = true
    self:initListView_()
    self:update(data)
end

function DuiZhanList:initListView_()
    self.tableView_ = cc.TableView:create(cc.size(1000, 420))      --列表的显示区域的大小
    self.tableView_:setDirection(1)         --设置列表是竖直方向
    self.tableView_:registerScriptHandler(handler(self, self.cellSizeForTable_),cc.TABLECELL_SIZE_FOR_INDEX)
    self.tableView_:registerScriptHandler(handler(self, self.tableCellAtIndex_),cc.TABLECELL_SIZE_AT_INDEX)
    self.tableView_:registerScriptHandler(handler(self, self.tableCellTouched_),cc.TABLECELL_TOUCHED)
    self.tableView_:registerScriptHandler(handler(self, self.numberOfCellsInTableView_),cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self:addChild(self.tableView_)
    self.tableView_:setPosition(-430-90+20, -220+90)
end

function DuiZhanList:update(data, clubID)
    self.data_ = data
    self.clubID_ = clubID
    local function sortByValue_(a, b)
        return a.time < b.time
    end
    table.sort(self.data_, sortByValue_)
    self.tableView_:reloadData()
end

function DuiZhanList:cellSizeForTable_()
    return 80, 890
end

function DuiZhanList:tableCellAtIndex_(table,idx)
    local cell = table:dequeueCell() 
    local index = idx + 1 
    if nil == cell then  
        cell = cc.TableViewCell:new() 
        local item = app:createView("chaguan.DuiZhanItem")
        item:update(self.data_[index], self.clubID_)
        item:setPosition(cc.p(445, 45))  
        item:setTag(123)  
        cell:addChild(item)  
    else  
        local item = cell:getChildByTag(123)
            if nil ~= item then  
                item:update(self.data_[index], self.clubID_)
            end  
        end
    return cell  
end

function DuiZhanList:tableCellTouched_(table,cell)
    local index = cell:getIdx() + 1
end

function DuiZhanList:numberOfCellsInTableView_()
    return #self.data_
end

return DuiZhanList  
