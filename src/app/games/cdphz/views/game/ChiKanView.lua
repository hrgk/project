local BaseAlgorithm = require("app.games.cdphz.utils.BaseAlgorithm")
local ChiKanView = class("ChiKanView", function()
        return display.newNode()
end)

local max_height = 40 -- 最大行高
local da_xiao_space = 96 -- 大小牌之间的间隔

local KAN_WIDTH = 40
local KAN_HEIGHT = 150
local BIG_KAN_HEIGHT = 100

-- 构造函数
function ChiKanView:ctor(cards)
    -- self:setContentSize(cc.size(KAN_WIDTH, KAN_HEIGHT ))

    self.mingpai = mingpai
    self.height = self:getContentSize().height
    self.func = func 
    self.tableIndex = tableIndex
    local isTemp = isTemp or false
    self:draw(cards, mingpai, needFlip, not isTemp) 
    self.index = 0
end

function ChiKanView:removeAll()
    self:removeAllChildren()
end

-- 获得所有子对象精灵
function ChiKanView:getSprites()
    local ret = {}
    local array = self:getChildren() 
    
    if not array then
        return ret
    end 
    for i = 0, #array - 1 do 
        table.insert(ret, array[i])
    end
    return ret
end

-- 获得一坎牌的值
function ChiKanView:getCards()
    local ret = {}
    local array = self:getChildren()
        
    if not array then
        return ret
    end
    for i,v in ipairs(array) do 
        table.insert(ret, v.card)
    end 
    return ret
end

local function getLineHeight(totalCount)
    local multiple = 3.0
    if totalCount > 3 then
        multiple = 3.35
    end
    local total_height = max_height * multiple

    local line_height = total_height / totalCount
    return math.min(line_height, max_height)
end

function ChiKanView:getCardPos(index, totalCount)
    if index == 1 then
        return 0,38-3
    elseif index == 2 then
        return 0,0-3
    else
        return 0,-38-3
    end
end

function ChiKanView:showHightLight(card,isHigh)
        local array = self:getChildren()
        if not array then
                return false
        end
        for i,v in ipairs(array) do
            if v.card == card then
                if isHigh then
                    v:highLight()
                else
                    v:clearHighLight()
                end 
            end 
        end    
end

function ChiKanView:draw(cards)
    self:removeAll()
    for i=1,#cards do
        local x, y = self:getCardPos(i, #cards) 
        local tmp = app:createConcreteView("PaperCardView", cards[i], 3, true):addTo(self):pos(x, y) 
        tmp:setScale(1.1)
        tmp:setAnchorPoint(cc.p(0.5, 0.5))
        -- tmp:flip(v, 1)
        tmp:fanPai()
        if i == 1 then
            tmp:highLight()
        end
    end
    return self
end

return ChiKanView

