local TuiGuangView = class("TuiGuangView", gailun.BaseView)

local TYPES = gailun.TYPES
local nodes = {
    type = TYPES.ROOT, children = {
        {type = TYPES.SPRITE, filename = "res/images/sz_bg.png", scale9 = true, size = {920, 530}, capInsets = cc.rect(350, 150, 1, 1), var = "rootLayer_", x = display.cx, y = display.cy,children = {
            {type = TYPES.SPRITE, filename = "res/images/common/grxx_title.png", px = 0.36, py = 0.686},
            {type = TYPES.SPRITE, filename = "res/images/tuiguang/tuiguang_title.png", px = 0.36, py = 0.695},
            {type = TYPES.SPRITE, var = "rankBg_", filename = "res/images/jifu/jifu_ditu.png", ppx = 0.5, ppy = 0.456 ,scale9 = true, size ={870, 440}, children = {
                {type = TYPES.SPRITE, filename = "res/images/jifu/acivity_black_d.png", ppx = 0.5, ppy = 0.59 ,scale9 = true, size ={840, 345}},
                {type = TYPES.SPRITE, filename = "res/images/hall/hall_bg9.png", ppx = 0.5, ppy = 0.92 ,scale9 = true, size = {820, 50}},
                {type = TYPES.SPRITE, filename = "res/images/tuiguang/tuiguang_xvhao.png", ppx = 0.08, ppy =0.92},
                {type = TYPES.SPRITE, filename = "res/images/tuiguang/tuiguang_id.png", ppx = 0.2, ppy =0.92},
                {type = TYPES.SPRITE, filename = "res/images/tuiguang/tuiguang_nicheng.png", ppx = 0.38, ppy =0.92},
                {type = TYPES.SPRITE, filename = "res/images/tuiguang/tuiguang_haoyoutuiguang.png", ppx = 0.6, ppy =0.92},
                {type = TYPES.SPRITE, filename = "res/images/tuiguang/tuiguang_time.png", ppx = 0.85, ppy =0.92},
                {type = TYPES.BUTTON, var = "buttonTuiGuang_", normal = "res/images/jifu/jifu_yaoqing.png", ppx = 0.7, ppy = 0.12},
                {type = TYPES.BUTTON, var = "buttonQueRen_", autoScale = 0.9, normal = "res/images/tuiguang/tuiguang_queren.png", ppx = 0.9, ppy = 0.12},       
                {type = TYPES.LABEL, var = "inputLabel_", options = {text="输入推广ID", size = 18, font = DEFAULT_FONT, color = cc.c4b(143, 143, 143, 255)}, visible = true, ppx = 0.62, ppy = 0.12, ap = {0, 0.5}},
                {type = TYPES.SPRITE, filename = "res/images/jifu/jifu_zongji.png", ppx = 0.06, ppy = 0.12},
                {type = TYPES.SPRITE, filename = "res/images/tuiguang/tuiguang_ren.png", ppx = 0.25, ppy = 0.11},
                {type = gailun.TYPES.LABEL_ATLAS, var = "totalCount_", filename = "fonts/jifu_mingxi_number.png", options = {w = 26, h = 33, startChar = "0"}, ppx = 0.18, ppy = 0.116, ap = {1, 0.5}},
                {type = TYPES.LABEL, var = "inputLabelSuccess_", options = {text="邀朋友一起玩游戏吧", size = 24, font = DEFAULT_FONT, color = cc.c4b(255, 0, 0, 255)}, visible = true, ppx = 0.62, ppy = 0.12, ap = {0, 0.5}},
                }
            },
            }
        }
    }
}


function TuiGuangView:ctor()
    self.dataList_ = {}
    TuiGuangView.super.ctor(self)
    gailun.uihelper.render(self, nodes)
    self.widthScale_ = display.width / DESIGN_WIDTH
    self.totalCount_:setString("0")
    self.numberStr_ = ""
    self.buttonTuiGuang_:onButtonClicked(handler(self, self.inputTuiGuangHandler_))
    self.buttonQueRen_:onButtonClicked(handler(self, self.queRenHandler_))
    self:initListView_()
    self:getMingXi_()
    self.inputLabelSuccess_:hide()
    self.buttonTuiGuang_:hide()
    self.buttonQueRen_:hide()
    self.inputLabel_:hide()
end

function TuiGuangView:initListView_()
    self.tableView_ = cc.TableView:create(cc.size(1100, 280))      --列表的显示区域的大小
    self.tableView_:setDirection(1)         --设置列表是竖直方向
    self.tableView_:setPosition(90 * self.widthScale_, 210)
    self.tableView_:registerScriptHandler(handler(self, self.cellSizeForTable_),cc.TABLECELL_SIZE_FOR_INDEX)
    self.tableView_:registerScriptHandler(handler(self, self.tableCellAtIndex_),cc.TABLECELL_SIZE_AT_INDEX)
    self.tableView_:registerScriptHandler(handler(self, self.tableCellTouched_),cc.TABLECELL_TOUCHED)
    self.tableView_:registerScriptHandler(handler(self, self.numberOfCellsInTableView_),cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self:addChild(self.tableView_)
    self.tableView_:reloadData()
end

function TuiGuangView:getMingXi_()
    HttpApi.getInviteList(handler(self, self.mingXiSucHandler_), handler(self, self.mingXiFailHandler_))
end

function TuiGuangView:mingXiSucHandler_(data)
    local mingXi = json.decode(data)
    if mingXi.status == 1 then
        self:update_(mingXi.data)
    end
    if mingXi.data.isBind then
        self.inputLabelSuccess_:show()
        return
    else
        self.buttonTuiGuang_:show()
        self.buttonQueRen_:show()
        self.inputLabel_:show()
    end
end

function TuiGuangView:mingXiFailHandler_()
    app:showTips("获取推广数据失败")
end

function TuiGuangView:update_(data)
    self.dataList_ =  data.list
    self.totalCount_:setString(data.totalCount)
    self.tableView_:reloadData()
end

function TuiGuangView:tableCellTouched_(table,cell) --设置每一个小项的触摸事件
    local index = cell:getIdx() + 1
end
function TuiGuangView:numberOfCellsInTableView_()   --设置列表里面小项的个数
    return #self.dataList_
end

function TuiGuangView:tableCellAtIndex_(table, idx)
    local cell = table:dequeueCell() 
    local index = idx + 1 
    if nil == cell then  
        cell = cc.TableViewCell:new() 
        local item = app:createView("activitys.tuiguangActivity.TuiGuangViewItem")
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

function TuiGuangView:cellSizeForTable_(table, idx)
    return 60, 1100
end

function TuiGuangView:inputTuiGuangHandler_(event)
    self.numberStr_  = ""
    self.inputLabel_:setString("")
    self.inputView_ = app:createView("hall.PuTongInputNumberView", "输入推广ID"):addTo(self):pos(display.left + 400, display.cy)
    self.inputView_:scale(0.8)
    self.inputView_:setNumberInputCallback(handler(self, self.numberInput))
    self.inputView_:setCallback(handler(self, self.checkID_))
end

function TuiGuangView:numberInput(num)
    if num == 10 then
        self.numberStr_ = ""
    elseif num == 12 then
        local len = string.len(self.numberStr_)
        self.numberStr_ = string.sub(self.numberStr_, 1, len - 1)
    else
        local len = string.len(self.numberStr_)
        if len >=13 then
            self.numberStr_ = string.sub(self.numberStr_, 1, len - 1)
        end
        self.numberStr_ = self.numberStr_ .. num
    end
    self.inputLabel_:setString(self.numberStr_)
end

function TuiGuangView:checkID_()
    if self.numberStr_ == "" then
        app:showTips("ID不能为空!")
        return
    end
    HttpApi.getQueryUid(self.numberStr_, handler(self, self.queryUidHandler_), handler(self, self.queryUidFailHandler_))
end

function TuiGuangView:queryUidHandler_(data)
    local obj = json.decode(data)
    if obj.data.exist == false then
        app:showTips("您输入推广ID不存在!")
    else
        self.inputView_:removeSelf()
    end
    if 1 ~= obj.status then
        printInfo("查询推广ID失败!")
        return
    end
end

function TuiGuangView:queryUidFailHandler_()
    app:showTips("查询推广ID失败!")
end

function TuiGuangView:queRenHandler_(event)
    if self.numberStr_ == "" then
        app:showTips("ID不能为空!")
        return
    end
    HttpApi.setInviter(self.numberStr_, handler(self, self.inviterHandler_), handler(self, self.inviterFailHandler_))
end

function TuiGuangView:inviterHandler_(data)
    local obj = json.decode(data)
    if obj.data.success == 1 then
        app:showTips("推荐成功，邀朋友一起玩游戏吧!")
        self.buttonTuiGuang_:hide()
        self.buttonQueRen_:hide()
        self.inputLabel_:hide()
        self.inputLabelSuccess_:show()
    elseif obj.data.success == 0 then
        app:showTips("绑定失败!")
    elseif obj.data.success == 2 then
        app:showTips("对不起，活动已经结束，感谢关注!")
    elseif obj.data.success == 3 then
        app:showTips("此活动只针对新用户，感谢关注!")
    end
    if 1 ~= obj.status then
        app:showTips("推广ID提交失败!")
        return
    end
end

function TuiGuangView:inviterFailHandler_()
    app:showTips("提交失败!")
end

return TuiGuangView 
