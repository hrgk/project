local OperateCardView = class("OperateCardView", function()
    return display.newNode()
end)
local BG_SIZE = {
    {538, 190},
    {338,190},
    {138, 190},
}
-- 构造函数
function OperateCardView:ctor()
    self.width = 700
    self.height = 200
    self.group_items = {}
    self.chiList = {}
    self.curr_level = 0
    self.curr_card = 0
    self.p_choose = {}
    self.curr_level_data = {}
    self.choose_level = 0
    self:draw()
    self:hideSelf()
end

function OperateCardView:onTouchCards(event, x, y, cards, types)

    self:onChooseEnd(cards, types)
end

-- 逐个比较判断两个table是否相等
local function isEqual(a, b)
    table.sort(a)
    table.sort(b)
    if #a ~= #b then
        return false
    end
    for i = 1, #a do
        if a[i] ~= b[i] then
            return false
        end
    end
    return true
end

local function isMatchPath(choosed, chi_path)
    for i = 1, #choosed do
        if not isEqual(choosed[i], chi_path[i]) then
            return false
        end
    end
    return true
end

local function inChoise(curr_list, wait_list)
    dump(curr_list)
    dump(wait_list)
    for i = 1, #curr_list do
        if isEqual(curr_list[i], wait_list) then
            return true
         end
    end
    return false
end

function OperateCardView:hideSelf()
    print("chiview hideself")
    self:removeAllGroup()
    self:setVisible(false)
    -- self.chiBg:setVisible(false)
    self.choose_level = 0
    self:removeAllChildren()
end
function OperateCardView:onChooseEnd(pchoose, types)
    self:hideSelf()
    self.choose_level = 0
    if self.choose_end_handler then
        self.choose_end_handler(pchoose, types)
    end 
end

-- 绘制图像
function OperateCardView:draw()
    -- self.chiBg = display.newScale9Sprite('res/images/game/chiview_bg.png', 0, 0, cc.size(538,190)):addTo(self) 
    -- local icon =  display.newSprite("res/images/game/chiview_chi.png"):pos(0, 0):addTo(self.chiBg)
    return self
end

function OperateCardView:hide()
    self:setVisible(false)
    if self.choose_end_handler then
        self.choose_end_handler(nil)
    end
end

function OperateCardView:showChoise(operateList, func, types)
    self:removeAllChildren()
    self:setVisible(true)
    self.operateList_ = operateList
    self.types = types
    self.choose_end_handler = func
    self:showLevel()
    return self
end

function OperateCardView:removeAllGroup()
    for k, v in pairs(self.group_items) do
        self:removeChild(v)
    end
    self.group_items = {}
end

function OperateCardView:getStringByInt(num)
    return "+" .. num
end
 
function OperateCardView:showLevel()
    local cards = self.operateList_
    dump(self.operateList_)
    local x,y
    local startx, starty = - self.width / 2 - 46, 100
    
    local tmp_cards = cards[1]
    local types = self.types[1]

    x =  display.cx
    local tmp = app:createConcreteView("MaJiangView", tmp_cards, CSMJ_TABLE_DIRECTION.BOTTOM, true):addTo(self):pos(0, 0)

    tmp:setAnchorPoint(cc.p(0.5, 0.5))
    tmp:setTouchEnabled(true)
    tmp:setTouchSwallowEnabled(true) -- 是否吞噬事件，默认值为 true
    tmp:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        local x = event.x
        local y = event.y
        self:onTouchCards(event, x, y, tmp_cards, types)
    end)
    if not cards[2] then
        return
    end
    local tmp_cards1 = cards[2]
    local types = self.types[2 ]

    x =  display.cx
    local tmp = app:createConcreteView("MaJiangView", tmp_cards1, CSMJ_TABLE_DIRECTION.BOTTOM, true):addTo(self):pos(100, 0)

    tmp:setAnchorPoint(cc.p(0.5, 0.5))
    tmp:setTouchEnabled(true)
    tmp:setTouchSwallowEnabled(true) -- 是否吞噬事件，默认值为 true
    tmp:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        local x = event.x
        local y = event.y
        self:onTouchCards(event, x, y, tmp_cards1,types)
    end)
    if not cards[3] then
        return
    end
    local tmp_cards3 = cards[3]
    local types3 = self.types[3 ]

    x =  display.cx
    local tmp = app:createConcreteView("MaJiangView", tmp_cards3, CSMJ_TABLE_DIRECTION.BOTTOM, true):addTo(self):pos(0, 100)

    tmp:setAnchorPoint(cc.p(0.5, 0.5))
    tmp:setTouchEnabled(true)
    tmp:setTouchSwallowEnabled(true) -- 是否吞噬事件，默认值为 true
    tmp:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        local x = event.x
        local y = event.y
        self:onTouchCards(event, x, y, tmp_cards3,types3)
    end)
    if not cards[4] then
        return
    end
    local tmp_cards3 = cards[4]
    local types3 = self.types[4]

    x =  display.cx
    local tmp = app:createConcreteView("MaJiangView", tmp_cards4, CSMJ_TABLE_DIRECTION.BOTTOM, true):addTo(self):pos(0, 100)

    tmp:setAnchorPoint(cc.p(0.5, 0.5))
    tmp:setTouchEnabled(true)
    tmp:setTouchSwallowEnabled(true) -- 是否吞噬事件，默认值为 true
    tmp:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        local x = event.x
        local y = event.y
        self:onTouchCards(event, x, y, tmp_cards4,types4)
    end)

end

function OperateCardView:bgClick()
        self:removeAllGroup()
end

return OperateCardView
