local BaseView = import("app.views.BaseView")
local MembersViewItem = import(".MembersViewItem")
local MembersView = class("MembersView", BaseView)

function MembersView:ctor(data)
    MembersView.super.ctor(self)
    self.data_ = data
    self.players = self.data_ 
    self:initTableList_()
    self.isZRF = true
    self.isZFF = true
    self.isShowAll = true
    self:setOther(self.isShowAll)
end

function MembersView:updateList(list)
    self.data_ = list
    self.players = self.data_
    self:updateShow()
end

function MembersView:updateShow()
    if self.tableView_ and not tolua.isnull(self.tableView_) then
        self.tableView_:reloadData()
    else
        self:initTableList_()
    end
end

function MembersView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/club/members/members.csb"):addTo(self)
    self.csbNode_:setPosition(display.cx, display.cy)
end

function MembersView:pyqHandler_()
end

function MembersView:initTableList_()
    self.itemList_ = {}
    self.tableView_ = cc.TableView:create(cc.size(1250, 440))      --列表的显示区域的大小
    self.tableView_:setDirection(1)         --设置列表是竖直方向
    self.tableView_:setPosition(-570, -250+35)
    self.tableView_:registerScriptHandler(handler(self, self.cellSizeForTable_), cc.TABLECELL_SIZE_FOR_INDEX)
    self.tableView_:registerScriptHandler(handler(self, self.tableCellAtIndex_), cc.TABLECELL_SIZE_AT_INDEX)
    self.tableView_:registerScriptHandler(handler(self, self.tableCellTouched_), cc.TABLECELL_TOUCHED)
    self.tableView_:registerScriptHandler(handler(self, self.numberOfCellsInTableView_), cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.content_:addChild(self.tableView_)
    self.tableView_:reloadData()
end

function MembersView:cellSizeForTable_(table, idx)
    return 80, 1200
end

function MembersView:tableCellAtIndex_(table, idx)
    local cell = table:dequeueCell() 
    local index = idx + 1 
    if nil == cell then  
        cell = cc.TableViewCell:new() 
        local item = MembersViewItem.new()
        item:setPosition(cc.p(570, 45))
        item:update(self.players[index])  
        item:setTag(123)  
        cell:addChild(item)  
    else  
        local item = cell:getChildByTag(123)
            if nil ~= item then  
                item:update(self.players[index])  
            end  
        end
    return cell  
end

function MembersView:tableCellTouched_(table, cell)
end

function MembersView:numberOfCellsInTableView_()
    return #self.players
end

function MembersView:findHandler_()
    local name = self.findFont_:getString()
    if name == "" then
        self.players = self.data_
    else
        self.players = self.data_
        local aimplyers = {}
        for key,value in ipairs(self.players) do
            if string.find(value.nickName, name) ~= nil then
                table.insert(aimplyers,value)
            end
        end
        self.players = aimplyers
    end
    self.showAll_:setSelected(true)
    self:setOther(true)
    self:updateShow()
end

function MembersView:showZRSelect()
    self.zrf_:setSelected(self.isZRF)
    self.zrz_:setSelected(not self.isZRF)
end

function MembersView:showZFSelect()
    self.zff_:setSelected(self.isZFF)
    self.zfz_:setSelected(not self.isZFF)
end

function MembersView:zrfHandler_(item)
    self.isZRF = true
    self:showZRSelect()
    self:findSomeValue()
end

function MembersView:zrzHandler_(item)
    self.isZRF = false
    self:showZRSelect()
    self:findSomeValue()
end

function MembersView:zffHandler_(item)
    self.isZFF = true
    self:showZFSelect()
    self:findSomeValue()
end

function MembersView:zfzHandler_(item)
    self.isZFF = false
    self:showZFSelect()
    self:findSomeValue()
end

function MembersView:showAllHandler_(item)
    self.isShowAll = item:isSelected()
    self:setOther(self.isShowAll)
    self:findSomeValue()
end

function MembersView:setOther(isSelect)
    self.zrf_:setTouchEnabled(not isSelect)
    self.zrz_:setTouchEnabled(not isSelect)
    self.zff_:setTouchEnabled(not isSelect)
    self.zfz_:setTouchEnabled(not isSelect)
    if isSelect then
        self.zrf_:setSelected(not isSelect)
        self.zrz_:setSelected(not isSelect)
        self.zff_:setSelected(not isSelect)
        self.zfz_:setSelected(not isSelect)
    else
        self:showZRSelect()
        self:showZFSelect()
    end
end

function MembersView:cheackIsOk(value)
    if self.isZRF and value.yesterdayScore >= 0 then
        return false
    end
    if not self.isZRF and value.yesterdayScore <= 0 then
        return false
    end
    if self.isZFF and value.score >= 0 then
        return false
    end
    if not self.isZFF and value.score <= 0 then
        return false
    end
    return true
end

function MembersView:findSomeValue()
    self.findFont_:setString("")
    if self.isShowAll then
        self.players = self.data_
    else
        local aimplyers = {}
        self.players = self.data_
        for key,value in ipairs(self.players) do
            if self:cheackIsOk(value) then
                table.insert(aimplyers,value)
            end
        end
        self.players = aimplyers
    end
    self:updateShow()
end

return MembersView  
