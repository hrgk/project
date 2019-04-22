local BaseView = import(".BaseView")
local TabButton = import("app.views.TabButton")

local GuiZeView = class("GuiZeView", BaseView)
function GuiZeView:ctor()
    GuiZeView.super.ctor(self)
    self.itemList_ = {}
    self:initGamesButton_()
    self:initTabButtonList_()
    self:initScrollview_()
    self:updateView_(#self.iconList_)
   
end

function GuiZeView:initScrollview_()
    self.scrollView_=ccui.ScrollView:create() 
    self.scrollView_:setTouchEnabled(true) 
    self.scrollView_:setBounceEnabled(true) --这句必须要不然就不会滚动噢 
    self.scrollView_:setDirection(ccui.ScrollViewDir.vertical) --设置滚动的方向 
    self.scrollView_:setContentSize(cc.size(950,580)) --设置尺寸 
    self.scrollView_:setAnchorPoint(cc.p(0.5,0.5)) 
    self.scrollView_:setPosition(0, -50)
    self.content_:addChild(self.scrollView_)
end

function GuiZeView:initTabButtonList_()
    self.tableView_ = cc.TableView:create(cc.size(250, 600))      --列表的显示区域的大小
    self.tableView_:setDirection(1)         --设置列表是竖直方向
    self.tableView_:setPosition(-690-58, -350+104)
    self.tableView_:registerScriptHandler(handler(self, self.cellSizeForTable_), cc.TABLECELL_SIZE_FOR_INDEX)
    self.tableView_:registerScriptHandler(handler(self, self.tableCellAtIndex_), cc.TABLECELL_SIZE_AT_INDEX)
    self.tableView_:registerScriptHandler(handler(self, self.tableCellTouched_), cc.TABLECELL_TOUCHED)
    self.tableView_:registerScriptHandler(handler(self, self.numberOfCellsInTableView_), cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.content_:addChild(self.tableView_)
    self.tableView_:zorder(100)
    self.tableView_:reloadData()
end

function GuiZeView:initGamesButton_()
    self.iconList_ = {}
    self.activityList_ = {}
    self:initPdk_()
    self:initHzmj_()
    self:initCsmj_()
    self:initZzmj_()
    self:initSk_()
    self:initHSMJ_()
end

function GuiZeView:initCsmj_()
    print("CHANNEL_CONFIGS.CONFIG_KAI_FANG_JI_QI_REN", CHANNEL_CONFIGS.KAI_FANG_JI_QI_REN)
    self.iconList_[#self.iconList_ + 1] = {"res/images/createRoom/btn_csmj_n.png", "res/images/createRoom/btn_csmj_o.png"}
    self.activityList_[#self.activityList_ + 1] = handler(self, self.initCsmjView_)
end

function GuiZeView:initHzmj_()
    print("CHANNEL_CONFIGS.CONFIG_KAI_FANG_JI_QI_REN", CHANNEL_CONFIGS.KAI_FANG_JI_QI_REN)
    self.iconList_[#self.iconList_ + 1] = {"res/images/createRoom/btn_hzmj_n.png", "res/images/createRoom/btn_hzmj_o.png"}
    self.activityList_[#self.activityList_ + 1] = handler(self, self.initHzmjView_)
end

function GuiZeView:initPdk_()
    print("CHANNEL_CONFIGS.CONFIG_KAI_FANG_JI_QI_REN", CHANNEL_CONFIGS.KAI_FANG_JI_QI_REN)
    self.iconList_[#self.iconList_ + 1] = {"res/images/createRoom/btn_pdk_n.png", "res/images/createRoom/btn_pdk_o.png"}
    self.activityList_[#self.activityList_ + 1] = handler(self, self.initPdkView_)
end

function GuiZeView:initZzmj_()
    print("CHANNEL_CONFIGS.CONFIG_KAI_FANG_JI_QI_REN", CHANNEL_CONFIGS.KAI_FANG_JI_QI_REN)
    self.iconList_[#self.iconList_ + 1] = {"res/images/createRoom/btn_zzmj_n.png", "res/images/createRoom/btn_zzmj_o.png"}
    self.activityList_[#self.activityList_ + 1] = handler(self, self.initZzmjView_)
end

function GuiZeView:initSk_()
    self.iconList_[#self.iconList_ + 1] = {"res/images/createRoom/btn_sk_n.png", "res/images/createRoom/btn_sk_o.png"}
    self.activityList_[#self.activityList_ + 1] = handler(self, self.initSkView_)
end

function GuiZeView:initHSMJ_()
    self.iconList_[#self.iconList_ + 1] = {"res/images/createRoom/btn_hsmj_n.png", "res/images/createRoom/btn_hsmj_o.png"}
    self.activityList_[#self.activityList_ + 1] = handler(self, self.initHsmjView_)
end

function GuiZeView:initHzmjView_()
    self:clearCurrView_()
    self.currView_ = display.newSprite("res/images/guize/hzmj.png"):addTo(self.scrollView_)
    self.currView_:setAnchorPoint(0,0)
    self.scrollView_:setInnerContainerSize(self.currView_:getContentSize()) 
end

function GuiZeView:initCsmjView_()
    self:clearCurrView_()
    self.currView_ = display.newSprite("res/images/guize/csmj.png"):addTo(self.scrollView_)
    self.currView_:setAnchorPoint(0,0)
    self.scrollView_:setInnerContainerSize(self.currView_:getContentSize()) 
end

function GuiZeView:initPdkView_()
    self:clearCurrView_()
    self.currView_ = display.newSprite("res/images/guize/guize_paodekuai.png"):addTo(self.scrollView_)
    self.currView_:setAnchorPoint(0,0)
    self.scrollView_:setInnerContainerSize(self.currView_:getContentSize()) 
end

function GuiZeView:initSkView_()
    self:clearCurrView_()
    self.currView_ = display.newSprite("res/images/guize/sk.png"):addTo(self.scrollView_)
    self.currView_:setAnchorPoint(0,0)
    self.scrollView_:setInnerContainerSize(self.currView_:getContentSize()) 
end

function GuiZeView:initZzmjView_()
    self:clearCurrView_()
    self.currView_ = display.newSprite("res/images/guize/zzmj.png"):addTo(self.scrollView_)
    self.currView_:setAnchorPoint(0,0)
    self.scrollView_:setInnerContainerSize(self.currView_:getContentSize()) 
end

function GuiZeView:initHsmjView_()
    self:clearCurrView_()
    self.currView_ = display.newSprite("res/images/guize/hsmj.png"):addTo(self.scrollView_)
    self.currView_:setAnchorPoint(0,0)
    self.scrollView_:setInnerContainerSize(self.currView_:getContentSize()) 
end

function GuiZeView:clearCurrView_()
    if self.currView_ then
        self.currView_:removeSelf()
        self.currView_ = nil
    end
end

function GuiZeView:cellSizeForTable_(table, idx)
    return 121, 250
end

function GuiZeView:tableCellAtIndex_(table, idx)
    local cell = table:dequeueCell() 
    local index = idx + 1 
    if nil == cell then  
        cell = cc.TableViewCell:new() 
        local item = TabButton.new()
        self.itemList_[index] = item
        item:update(self.iconList_[index], index)
        item:setPosition(cc.p(0, 45+15))  
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

function GuiZeView:updateView_(index)
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

function GuiZeView:tableCellTouched_(table, cell)
end

function GuiZeView:numberOfCellsInTableView_()
    return #self.iconList_
end

function GuiZeView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/guizeView.csb"):addTo(self)
    self.csbNode_:setPosition(display.cx, display.cy)
end

return GuiZeView 
