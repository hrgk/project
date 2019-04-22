local BaseAlgorithm = require("app.games.hhqmt.utils.BaseAlgorithm")
local TableKanView = class("TableKanView", function()
        return display.newNode()
end)

local max_height = 36 -- 最大行高
local da_xiao_space = 96 -- 大小牌之间的间隔

local KAN_WIDTH = 40
local KAN_HEIGHT = 172
local BIG_KAN_HEIGHT = 100

-- 构造函数
function TableKanView:ctor(cards, mingpai, needFlip, func, isTemp, tableIndex)
    self:setContentSize(cc.size(KAN_WIDTH, KAN_HEIGHT * 4))
    if isTemp then
        self:setContentSize(cc.size(KAN_WIDTH, BIG_KAN_HEIGHT * 4))
    end 
    self.mingpai = mingpai
    self.height = self:getContentSize().height
    self.func = func 
    self.tableIndex = tableIndex
    local isTemp = isTemp or false
    self:draw(cards, mingpai, needFlip, not isTemp) 
    self.index = 0
end

function TableKanView:getTableIndex()
    return self.tableIndex
end

function TableKanView:isInKan(x, y)
    local rect = self:getCascadeBoundingBox()
    local rotate = self:getRotation()
    local width, height = rect.width, rect.height
    local in_it = BaseAlgorithm.inRectWithAngle(width, height, x, y, rect, rotate)
    return in_it
end

function TableKanView:delTarget(obj)
    if not obj or obj:getParent() ~= self then
        return false
    end
    self:removeChild(obj)
    return true
end

function TableKanView:delCard(card)
    local array = self:getChildren()
    if not array then
        return false
    end
    for i,v in ipairs(table_name) do
        if v.card == card then
            self:removeChild(v)
            return true
        end 
    end 

        return false
end

function TableKanView:removeAll()
    self:removeAllChildren()
end

-- 设置一坎牌
function TableKanView:setCards(cards)
    self:draw(cards)
end
-- 设置一坎牌
function TableKanView:reSetCards(cards, mingpai, needFlip, func, isTemp, tableIndex)
    self:removeAll()
    self.mingpai = mingpai 
    self.tableIndex = tableIndex
    local isTemp = isTemp or false
    self:draw(cards, mingpai, needFlip, not isTemp) 
    self.index = 0
    self:draw(cards, mingpai, needFlip, not isTemp) 
end

-- 获得所有子对象精灵
function TableKanView:getSprites()
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

-- 一坎之内的所有元素的排序
function TableKanView:sortCardsByY()
    local function sortCompare(c1, c2)
            local x1, y1 = c1:getPosition()
            local x2, y2 = c2:getPosition()
            return y1 > y2
    end

    self:performWithDelay(function ()
        local cards = self:getSprites()
        
        if not cards or #cards < 1 then
            return
        end

        table.sort(cards, sortCompare)
        for i,v in ipairs(cards) do
            local x, y = self:getCardPos(i, #cards)
            transition.moveTo(v, {x = x, y = y, time = 0.15})
            -- v:setZOrder(i)
        end
 
    end, 0.1)
end


-- 获得一坎牌的值
function TableKanView:canPao(Paocards)
    local ret = {}
    local myCards = self:getCards()
    if BaseAlgorithm.isThree(myCards) and myCards[1] == Paocards[1] then
        return true
    end
    return false
end

-- 获得一坎牌的值
function TableKanView:isIncludeCard(card)
    local ret = {}
    local array = self:getChildren() 
        
    if not array then
        return false
    end
    for i,v in ipairs(array) do 
            if v.card == card then
                return true
            end
    end 
    return false
end

-- 获得一坎牌的值
function TableKanView:getCards()
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


function TableKanView:setCardsType(cardsType)
    self.cardsType_ = cardsType
    local tmpCard = self:getSprites()[1]
    if self.cardsType_[1] == 1 or self.cardsType_[1] == 3 or self.cardsType_[1] == 2 then
        local sp = display.newSprite("res/images/paohuzi/roundOver/chiFlag.png")
        tmpCard:addChild(sp)
    end
end

-- 获得一坎牌的牌型
function TableKanView:getCardsType()
    return self.cardsType_
end

-- 获得一坎牌的未旋转时的大小, 判断矩形触摸时用的
function TableKanView:getSize()
    local array = self:getChildren()
    local count = 0
    if array then
        count = #array
    end

    if count <= 0 then
        return 0, 0
    end

    -- local node1 = tolua.cast(array[1], "CCNode")
    local size1 = array[1]:getSize()
    if count == 1 then
        return size1.width, size1.height
    end
    
    -- local node2 = tolua.cast(array[2], "CCNode")
    local x1, y1 = array[1]:getPosition()
    local x2, y2 = array[2]:getPosition()
    return size1.width, size1.height + (y1 - y2) * (count - 1)
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

function TableKanView:canAddCard()
    return #self:getCards() < 4
end

function TableKanView:addCard(card, mingpai,needflip,small,x1, y1)
    local count = #self:getCards() + 1
    local x, y, z = self:getCardPos(count, count)
    if x1 ~= nil and y1 ~= nil then
        x, y = x1, y1
    end
    local cards = self:getCards()
    table.insert(cards,card)

    table.sort(cards, sortCompare)
    self:removeAll()
    self:draw(cards, mingpai, needflip, small)
end

function TableKanView:getCardPos(index, totalCount)
    local y = self.height - KAN_HEIGHT / 2 - (index - 1) * getLineHeight(totalCount)
    if totalCount > 3 then
        y = y + max_height * 0.5
    end
    return KAN_WIDTH / 2, y
end

-- 坎是否为固定不可移动坎
function TableKanView:isFixed()
    return self:getIsFixed(self:getCards())
end

-- 固定某些坎不可移动和触摸
function TableKanView:fixTiOrWei()
    if not self:isFixed() then
        return
    end

    local array = self:getChildren()
    
    if not array then
        return
    end
    for i,v in ipairs(array) do
        v:setFixed(true)
    end
end

function TableKanView:getIsFixed(cards)
    if #cards < 3 then
        return false
    end
    
    if #cards == 3 and cards[1] == cards[2] and cards[2] == cards[3] then
        return true
    end

    if #cards == 4 and cards[1] == cards[2] and cards[2] == cards[3] and cards[3] == cards[4] then
        return true
    end

    return false
end

--跑胡子触摸事件
function TableKanView:onTouchCards(obj, event, x, y)
 
        local p = self:convertToNodeSpace(cc.p(x, y)) 
        if event.name == 'began' then 

                local array = self:getChildren()
                for i,v in ipairs(array) do
                        v:fanPai()
                end
        elseif event.name == 'ended' then 
                local array = self:getChildren()
                for i,v in ipairs(array) do
                        v:gaiPai()
                end
        end
end


function TableKanView:showHightLight(card,isHigh)
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

function TableKanView:draw(cards, mingpai, needFlip, isSmall)
    self:removeAll()
    local size = 3
    if not isSmall then
        size = 2
    end
    local mingpai = mingpai or 0
    for k, v in pairs(cards) do
        local x, y = self:getCardPos(k, #cards) 
        local pokershowback = true
        if mingpai > 0 then
            pokershowback = false
            mingpai = mingpai - 1
        end
        local tmp
        if self.mingpai == 0 then 
            tmp = app:createConcreteView("PaperCardView", v, size, pokershowback, handler(self, self.onTouchCards)):addTo(self):pos(x, y) 
        else
            tmp = app:createConcreteView("PaperCardView", v, size, pokershowback, self.func):addTo(self):pos(x, y) 
        end 

        tmp:setScale(1.2)
 
        if needFlip then
            tmp:performWithDelay(function ()
                tmp:flip(v, 1)
            end, k * 0.1)
        end
    end
    return self
end

function TableKanView:makeCards(cards, getYFunc)
    
end

function TableKanView:moveAfterDel()
    
end

return TableKanView

