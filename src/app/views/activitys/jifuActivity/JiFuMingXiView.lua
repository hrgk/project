local JiFuMingXiView = class("JiFuMingXiView", gailun.BaseView)

local TYPES = gailun.TYPES
local nodes = {
    type = TYPES.ROOT, children = {
            {type = TYPES.SPRITE, filename = "res/images/jifu/jifu_ditu.png", px = 0.5, py = 0.44 ,scale9 = true, size ={914, 522}},
            {type = TYPES.SPRITE, filename = "res/images/jifu/acivity_black_d.png", px = 0.5, py = 0.5 ,scale9 = true, size ={870, 400}},
            {type = TYPES.SPRITE, filename = "res/images/jifu/jifu_zongji.png", px = 0.67, py = 0.16},
            {type = TYPES.SPRITE, filename = "res/images/jifu/jifu_fu.png", px = 0.8, py = 0.157},
            {type = gailun.TYPES.LABEL_ATLAS, var = "totalJiFu_", filename = "fonts/jifu_mingxi_number.png", options = {w = 26, h = 33, startChar = "0"}, px = 0.78, py = 0.16, ap = {1, 0.5}},
            {type = TYPES.SPRITE, var = "rankBg_", px = 0.5, py = 0.53, ap = {0.5, 0.5},size = {1161, 603},
                children = {
                    {type = TYPES.SPRITE, filename = "res/images/hall/hall_bg9.png", ppx = 0.5, ppy = 0.74 ,scale9 = true, size = {860, 50}},
                    {type = TYPES.LABEL, options = {text = "序号", size = 20, color = cc.c4b(142, 70, 0, 0), font = DEFAULT_FONT}, ppx = 0.16, ppy = 0.74 ,ap = {0.5 ,0.5}},
                    {type = TYPES.LABEL, options = {text = "ID", size = 20, color = cc.c4b(142, 70, 0, 0), font = DEFAULT_FONT}, ppx = 0.25, ppy = 0.74 ,ap = {0.5, 0.5}},
                    {type = TYPES.LABEL, options = {text = "昵称", size = 20, color = cc.c4b(142, 70, 0, 0), font = DEFAULT_FONT}, ppx = 0.37, ppy = 0.74 ,ap = {0.5, 0.5}},
                    {type = TYPES.LABEL, options = {text = "好友注册", size = 20, color = cc.c4b(142, 70, 0, 0), font = DEFAULT_FONT}, ppx = 0.5, ppy = 0.74 ,ap = {0.5, 0.5}},
                    {type = TYPES.LABEL, options = {text = "好友开房", size = 20, font = DEFAULT_FONT, color = cc.c4b(142, 70, 0, 0)} ,ppx = 0.6, ppy = 0.74 ,ap = {0.5, 0.5}},
                    {type = TYPES.LABEL, options = {text = "好友推广", size = 20, font = DEFAULT_FONT, color = cc.c4b(142, 70, 0, 0)} ,ppx = 0.7, ppy = 0.74 ,ap = {0.5, 0.5}},
                    {type = TYPES.LABEL, options = {text = "积福", size = 20, font = DEFAULT_FONT, color = cc.c4b(142, 70, 0, 0)} ,ppx = 0.8, ppy = 0.74 ,ap = {0.5, 0.5}},         
                }

            }

        }
}

function JiFuMingXiView:ctor()
    self.dataList_ = {}
    JiFuMingXiView.super.ctor(self)
    gailun.uihelper.render(self, nodes)
    self.widthScale_ = display.width / DESIGN_WIDTH
    self:initListView_()
    self.totalJiFu_:setString("0")
    self:getMingXi_()
end

function JiFuMingXiView:initListView_()
    self.tableView_ = cc.TableView:create(cc.size(1100, 330))      --列表的显示区域的大小
    self.tableView_:setDirection(1)         --设置列表是竖直方向
    self.tableView_:setPosition(90 * self.widthScale_, 170)
    self.tableView_:registerScriptHandler(handler(self, self.cellSizeForTable_),cc.TABLECELL_SIZE_FOR_INDEX)
    self.tableView_:registerScriptHandler(handler(self, self.tableCellAtIndex_),cc.TABLECELL_SIZE_AT_INDEX)
    self.tableView_:registerScriptHandler(handler(self, self.tableCellTouched_),cc.TABLECELL_TOUCHED)
    self.tableView_:registerScriptHandler(handler(self, self.numberOfCellsInTableView_),cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self:addChild(self.tableView_)
end

function JiFuMingXiView:getMingXi_()
    HttpApi.getJiFuList(handler(self, self.mingXiSucHandler_), handler(self, self.MingXiFailHandler_))
end

function JiFuMingXiView:mingXiSucHandler_(data)
    local jifuMingXi = json.decode(data)
    if jifuMingXi.status == 1 then
        self:update_(jifuMingXi.data)
    end
end

function JiFuMingXiView:MingXiFailHandler_()
    app:showTips("获取积福明细数据失败")
end

function JiFuMingXiView:update_(data)
    self.dataList_ =  data.list
    self.totalJiFu_:setString(data.totalFu)
    self.tableView_:reloadData()
end

function JiFuMingXiView:tableCellTouched_(table,cell) --设置每一个小项的触摸事件
    local index = cell:getIdx() + 1
end
function JiFuMingXiView:numberOfCellsInTableView_()   --设置列表里面小项的个数
    return #self.dataList_
end

function JiFuMingXiView:tableCellAtIndex_(table, idx)
    local cell = table:dequeueCell() 
    local index = idx + 1 
    if nil == cell then  
        cell = cc.TableViewCell:new() 
        local item = app:createView("activitys.jifuActivity.JiFuMingXiViewItem")
        item:update(self.dataList_[index], #self.dataList_ - idx)
        item:setPosition(cc.p(550 * self.widthScale_, 30))  
        item:setTag(123)  
        cell:addChild(item)  
    else  
        local item = cell:getChildByTag(123)
            if nil ~= item then  
                item:update(self.dataList_[index], #self.dataList_ - idx)
            end  
        end
    return cell  
end

function JiFuMingXiView:cellSizeForTable_(table, idx)
    return 60, 1100
end

return JiFuMingXiView 
