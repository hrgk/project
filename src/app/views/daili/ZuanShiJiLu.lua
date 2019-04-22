local BaseElement = import("app.views.BaseElement")
local ZuanShiJiLu = class("ZuanShiJiLu", BaseElement)
local JiLuItem = import(".JiLuItem")

function ZuanShiJiLu:ctor()
    ZuanShiJiLu.super.ctor(self)
    self:initListView_()
    self:getRecorder()
end

function ZuanShiJiLu:getRecorder()
    self.list_ = {}
    local function sucFunc(data)
        -- dump(data)
        local info = json.decode(data)
        if info.status == 1 then
            -- dump(info.data.list)
            for i,v in ipairs(info.data.list) do
                if v[6] == 1 or v[6] == 2 then
                    table.insert(self.list_, v)
                end 
            end
        end
        self.tableView_:reloadData()
    end
    local function failFunc()
        app:showTips("您的网络异常，请稍后再试")
    end
    HttpApi.getDiamondRecords(sucFunc, failFunc)
end

function ZuanShiJiLu:initListView_()
    self.tableView_ = cc.TableView:create(cc.size(888, 400))      --列表的显示区域的大小
    self.tableView_:setDirection(1)         --设置列表是竖直方向
    self.tableView_:setPosition(-444, -180)
    self.tableView_:registerScriptHandler(handler(self, self.cellSizeForTable_), cc.TABLECELL_SIZE_FOR_INDEX)
    self.tableView_:registerScriptHandler(handler(self, self.tableCellAtIndex_), cc.TABLECELL_SIZE_AT_INDEX)
    self.tableView_:registerScriptHandler(handler(self, self.tableCellTouched_), cc.TABLECELL_TOUCHED)
    self.tableView_:registerScriptHandler(handler(self, self.numberOfCellsInTableView_), cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.csbNode_:addChild(self.tableView_)
    self.tableView_:zorder(100)
end

function ZuanShiJiLu:tableCellAtIndex_(table, idx)
    local cell = table:dequeueCell() 
    local index = idx + 1 
    if nil == cell then  
        cell = cc.TableViewCell:new() 
        local item = JiLuItem.new()
        item:update(self.list_[index], index)
        item:setPosition(cc.p(444, 55))  
        item:setTag(123)  
        cell:addChild(item)  
    else  
        local item = cell:getChildByTag(123)
            if nil ~= item then  
                item:update(self.list_[index], index)
            end  
        end
    return cell  
end

function ZuanShiJiLu:cellSizeForTable_(table, idx)
    return 110, 900
end

function ZuanShiJiLu:tableCellTouched_(table, cell)
end

function ZuanShiJiLu:numberOfCellsInTableView_()
    return #self.list_
end

function ZuanShiJiLu:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/daili/zuanShiJiLuView.csb"):addTo(self)
end

function ZuanShiJiLu:zengSongHandler_()
end

return ZuanShiJiLu 
