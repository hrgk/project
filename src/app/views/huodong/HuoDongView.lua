local BaseView = import("app.views.BaseView")
local TabButton = import("app.views.TabButton")
local XinRenZongZuan = import(".XinRenZongZuan")
local FenXiangSongZuan = import(".FenXiangSongZuan")

local HuoDongView = class("HuoDongView", BaseView)
function HuoDongView:ctor()
    HuoDongView.super.ctor(self)
    self.itemList_ = {}
    self:initGamesButton_()
    self:initTabButtonList_()
    self:updateView_(#self.iconList_)
    self.content_:setPosition(self.content_:getPositionX()+20, self.content_:getPositionY()-10)
end

function HuoDongView:initGamesButton_()
    self.iconList_ = {}
    self.activityList_ = {}
    self:initFenXiang_()
    self:initXinRen_()
end

function HuoDongView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/huoDongView.csb"):addTo(self)
    self.csbNode_:setPosition(display.cx, display.cy)
end

function HuoDongView:clearCurrView_()
    if self.currView_ then
        self.currView_:removeSelf()
        self.currView_ = nil
    end
end

function HuoDongView:initXinRen_()
    print("CHANNEL_CONFIGS.CONFIG_KAI_FANG_JI_QI_REN", CHANNEL_CONFIGS.KAI_FANG_JI_QI_REN)
    self.iconList_[#self.iconList_ + 1] = {"res/images/huodong/btn_xinren_n.png", "res/images/huodong/btn_xinren_o.png"}
    self.activityList_[#self.activityList_ + 1] = handler(self, self.initXinRenView_)
end

function HuoDongView:initFenXiang_()
    print("CHANNEL_CONFIGS.CONFIG_KAI_FANG_JI_QI_REN", CHANNEL_CONFIGS.KAI_FANG_JI_QI_REN)
    self.iconList_[#self.iconList_ + 1] = {"res/images/huodong/btn_fx_n.png", "res/images/huodong/btn_fx_o.png"}
    self.activityList_[#self.activityList_ + 1] = handler(self, self.initFenXiangView_)
end

function HuoDongView:initXinRenView_()
    self:clearCurrView_()
    self.currView_ = XinRenZongZuan.new():addTo(self.content_)
end

function HuoDongView:initFenXiangView_()
    self:clearCurrView_()
    self.currView_ = FenXiangSongZuan.new():addTo(self.content_)
end

function HuoDongView:initTabButtonList_()
    self.tableView_ = cc.TableView:create(cc.size(250*self.itemScale, 600))      --列表的显示区域的大小
    self.tableView_:setDirection(1)         --设置列表是竖直方向
    self.tableView_:setPosition(-550*self.itemScale, -375)
    self.tableView_:registerScriptHandler(handler(self, self.cellSizeForTable_), cc.TABLECELL_SIZE_FOR_INDEX)
    self.tableView_:registerScriptHandler(handler(self, self.tableCellAtIndex_), cc.TABLECELL_SIZE_AT_INDEX)
    self.tableView_:registerScriptHandler(handler(self, self.tableCellTouched_), cc.TABLECELL_TOUCHED)
    self.tableView_:registerScriptHandler(handler(self, self.numberOfCellsInTableView_), cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.csbNode_:addChild(self.tableView_)
    self.tableView_:zorder(100)
    self.tableView_:reloadData()
end

function HuoDongView:cellSizeForTable_(table, idx)
    return 90, 260*self.itemScale
end

function HuoDongView:tableCellAtIndex_(table, idx)
    local cell = table:dequeueCell() 
    local index = idx + 1 
    if nil == cell then  
        cell = cc.TableViewCell:new() 
        local item = TabButton.new()
        self.itemList_[index] = item
        item:update(self.iconList_[index], index)
        item:setPosition(cc.p(0, 45))  
        item:setCallback(handler(self, self.updateView_))
        item:setTag(123)  
        cell:addChild(item)  
    else  
        local item = cell:getChildByTag(123)
            if nil ~= item then  
                item:update(self.iconList_[index], index)
                self.itemList_[index] = item
                item:setCallback(handler(self, self.updateView_))
            end  
        end
    return cell  
end

function HuoDongView:updateView_(index)
    if self.currentIndex_ == index then return end
    self.currentIndex_ = index
    for i,v in pairs(self.itemList_) do
        v:updateState(self.currentIndex_ == i)
    end
    self:clearCurrView_()
    if self.activityList_[self.currentIndex_] then
        self.activityList_[self.currentIndex_](data)
    else
        self:hide()
    end
end

function HuoDongView:tableCellTouched_(table, cell)
end

function HuoDongView:numberOfCellsInTableView_()
    return #self.iconList_
end

return HuoDongView 
