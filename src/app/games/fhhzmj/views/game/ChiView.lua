local ChiView = class("ChiView", function()
    return display.newNode()
end)
local BG_SIZE = {
    {538, 190},
    {338,190},
    {138, 190},
}
-- 构造函数
function ChiView:ctor()
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

function ChiView:onTouchCards(event, x, y, cards)

    self:onChooseEnd(cards)
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

function ChiView:hideSelf()
    print("chiview hideself")
    self:removeAllGroup()
    self:setVisible(false)
    -- self.chiBg:setVisible(false)
    self.choose_level = 0
end
function ChiView:onChooseEnd(pchoose)
    self:hideSelf()
    self.choose_level = 0
    if self.choose_end_handler then
        self.choose_end_handler(pchoose)
    end 
end

-- 绘制图像
function ChiView:draw()
    -- self.chiBg = display.newScale9Sprite('res/images/game/chiview_bg.png', 0, 0, cc.size(538,190)):addTo(self) 
    -- local icon =  display.newSprite("res/images/game/chiview_chi.png"):pos(0, 0):addTo(self.chiBg)
    return self
end

function ChiView:hide()
    self:setVisible(false)
    if self.choose_end_handler then
        self.choose_end_handler(nil)
    end
end

function ChiView:showChoise(card, chiList, func)
    self:removeAllChildren()
    self:setVisible(true)
    self.chiList = chiList
    self.curr_level = 1
    self.curr_card = card
    self.p_choose = {}
    self:removeAllGroup()
    self.choose_end_handler = func

    local level1 = {}
    for i = 1, #chiList do
        if 0 == #level1 then
            table.insert(level1, chiList[i])
            dump(level1)
        else
            dump(level1)
            if not inChoise(level1, chiList[i]) then
                table.insert(level1, chiList[i])
                dump(level1)
            end
        end
    end

    self.curr_level_data = level1
    self:showLevel()
    return self
end

function ChiView:removeAllGroup()
    for k, v in pairs(self.group_items) do
        self:removeChild(v)
    end
    self.group_items = {}
end

function ChiView:getStringByInt(num)
    return "+" .. num
end
 
function ChiView:showLevel()
    self:removeAllGroup()
    -- self.chiBg:setVisible(true)
    self.choose_level = 1
    local cards = self.curr_level_data
    local x,y
    local startx, starty = - self.width / 2 - 46, 100
    for i = 1, #cards do
        local tmp_cards = cards[i]

        x =  - (#cards * 290 )/2 + i * 200
        local tmp = app:createConcreteView("game.ChiKanView", tmp_cards, 3, false, nil):addTo(self):pos(x, 0)
        tmp:setAnchorPoint(cc.p(0.5, 0.5))
        tmp:setTouchEnabled(true)
        tmp:setTouchSwallowEnabled(true) -- 是否吞噬事件，默认值为 true
        tmp:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
            local x = event.x
            local y = event.y
            self:onTouchCards(event, x, y, cards[i])
        end)
    end
end

function ChiView:bgClick()
        self:removeAllGroup()
        self.chiBg:setVisible(false)
        self.choose_level = 0
end

return ChiView
