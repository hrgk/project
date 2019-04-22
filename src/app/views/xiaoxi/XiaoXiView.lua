local BaseView = import("app.views.BaseView")
local TabButton = import("app.views.TabButton")
local BaiWanXuanShang = import(".BaiWanXuanShang")
local DaiLiZhaoMu = import(".DaiLiZhaoMu")

local XiaoXiView = class("XiaoXiView", BaseView)
function XiaoXiView:ctor()
    XiaoXiView.super.ctor(self)
    self.itemList_ = {}
    self:initGamesButton_()
    self:initTabButtonList_()
    self:updateView_(#self.iconList_)
end

function XiaoXiView:initGamesButton_()
    self.iconList_ = {}
    self.activityList_ = {}
    self:initXinRen_()
    self:initFenXiang_()
end

function XiaoXiView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/xiaoXiView.csb"):addTo(self)
    self.csbNode_:setPosition(display.cx, display.cy)
end

function XiaoXiView:clearCurrView_()
    if self.currView_ then
        self.currView_:removeSelf()
        self.currView_ = nil
    end
end

function XiaoXiView:initXinRen_()
    print("CHANNEL_CONFIGS.CONFIG_KAI_FANG_JI_QI_REN", CHANNEL_CONFIGS.KAI_FANG_JI_QI_REN)
    self.iconList_[#self.iconList_ + 1] = {"res/images/xiaoxi/btn_xuanshang_n.png", "res/images/xiaoxi/btn_xuanshang_o.png"}
    self.activityList_[#self.activityList_ + 1] = handler(self, self.initFenXiangView_)
end

function XiaoXiView:initFenXiang_()
    print("CHANNEL_CONFIGS.CONFIG_KAI_FANG_JI_QI_REN", CHANNEL_CONFIGS.KAI_FANG_JI_QI_REN)
    self.iconList_[#self.iconList_ + 1] = {"res/images/xiaoxi/btn_daili_n.png", "res/images/xiaoxi/btn_daili_o.png"}
    self.activityList_[#self.activityList_ + 1] = handler(self, self.initXinRenView_)
end

function XiaoXiView:initXinRenView_()
    self:clearCurrView_()
    self.currView_ = DaiLiZhaoMu.new():addTo(self.content_)
end

function XiaoXiView:initFenXiangView_()
    self:clearCurrView_()
    self.currView_ = BaiWanXuanShang.new():addTo(self.content_)
end

function XiaoXiView:initTabButtonList_()
    self.tableView_ = cc.TableView:create(cc.size(250*self.itemScale, 490))      --列表的显示区域的大小
    self.tableView_:setDirection(1)         --设置列表是竖直方向
    self.tableView_:setPosition(-550*self.itemScale, -265)
    ---360-8-4
    self.tableView_:registerScriptHandler(handler(self, self.cellSizeForTable_), cc.TABLECELL_SIZE_FOR_INDEX)
    self.tableView_:registerScriptHandler(handler(self, self.tableCellAtIndex_), cc.TABLECELL_SIZE_AT_INDEX)
    self.tableView_:registerScriptHandler(handler(self, self.tableCellTouched_), cc.TABLECELL_TOUCHED)
    self.tableView_:registerScriptHandler(handler(self, self.numberOfCellsInTableView_), cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.csbNode_:addChild(self.tableView_)
    self.tableView_:zorder(100)
    self.tableView_:reloadData()
end

function XiaoXiView:cellSizeForTable_(table, idx)
    return 110, 250*self.itemScale
end

function XiaoXiView:tableCellAtIndex_(table, idx)
    local cell = table:dequeueCell() 
    local index = idx + 1 
    if nil == cell then  
        cell = cc.TableViewCell:new() 
        local item = TabButton.new()
        self.itemList_[index] = item
        item:update(self.iconList_[index], index)
        item:setPosition(cc.p(0, 45+8))  
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

function XiaoXiView:updateView_(index)
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

function XiaoXiView:tableCellTouched_(table, cell)
end

function XiaoXiView:numberOfCellsInTableView_()
    return #self.iconList_
end

function XiaoXiView:xtxxHandler_()
    app:showTips("敬请期待!")
end

function XiaoXiView:lqjlHandler_()
    app:showTips("敬请期待!")
end

return XiaoXiView 
