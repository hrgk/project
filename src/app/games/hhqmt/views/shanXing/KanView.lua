local BaseAlgorithm = require("app.games.hhqmt.utils.BaseAlgorithm")
local PaoHuZiAlgorithm = import("app.games.hhqmt.utils.PaoHuZiAlgorithm")

local PaperCardView = import(".PaperCardView")
local KanView = class("KanView", function()
    return display.newNode()
end)

local max_height = 85 -- 最大行高
local da_xiao_space = 156 -- 大小牌之间的间隔

local KAN_WIDTH = 94
local KAN_HEIGHT = 300

-- 构造函数
function KanView:ctor(cards, func, needFlip,flipBaseTime,mingpai) 
    self.cards_ = cards
    self.cardsNodeList_ = {}
    self:setContentSize(cc.size(KAN_WIDTH, KAN_HEIGHT * 4))
    self.height = self:getContentSize().height
    self.func = func 
    self:draw(cards, needFlip,flipBaseTime,mingpai) 
    self.index = 0
 
end

function KanView:isInKan(x, y)
    local rect = self:getCascadeBoundingBox()
    local rotate = self:getRotation()
    local width, height = rect.width, rect.height
    local in_it = BaseAlgorithm.inRectWithAngle(width, height, x, y, rect, rotate)
    return in_it
end

function KanView:delTarget(obj)
    if not obj or obj:getParent() ~= self then
        return false
    end
    self.cardsNodeList_[obj:getName()] = nil
    self:removeChild(obj)
    if setData:getCDPHZHXTS() then
        self:clacSelfHuXi(self:getCards())
    end
    return true
end

function KanView:delCard(card)
    local array = self:getChildren()
    if not array then
        return false
    end
    for i,v in ipairs(array) do
        if v.card == card then
            self:delTarget(v)
            return true
        end 
    end 

  return false
end

function KanView:removeAll()
    self:removeAllChildren()
    self.cardsNodeList_ = {}
    self.huXiBg_ = nil
end

-- 设置一坎牌
function KanView:setCards(cards)
    self:draw(cards)
end
 
-- 隐藏所有提示界面
function KanView:hideTip()
    self.inKanView:getChildByName("mengceng"):setVisible(false)
    self.inKanView:getChildByName("forbidden"):setVisible(false)
end  

-- 显示正在坎上  根据情况 满4张则禁止，不足则显示半透明
function KanView:showInKans()
    self.inKanView:getChildByName("mengceng"):setVisible(true) 
    local cards = self:getCards() 
    if self:isFixed() or  #cards >= 4  then
        self.inKanView:getChildByName("forbidden"):setVisible(true)
    end
end

-- 获得所有子对象精灵
function KanView:getSprites()
    local ret = {}
    local array = self:getChildren() 

    if not array then
        return ret
    end 
    for i,v in ipairs(array) do 
    --获取精灵的时候要排除蒙层
        if v:getName() ~= "inKanView" 
            and  v:getName() ~= "mengceng"  
            and  v:getName() ~= "forbidden"  
            and  v:getName() ~= "huXiLabel"
            then  
            table.insert(ret, v) 
        end 
    end
  
    return ret
end

-- 一坎之内的所有元素的排序
function KanView:sortCardsByY(inFastMode)
  
    local function sortCompare(c1, c2)
        local x1, y1 = c1:getPosition()
        local x2, y2 = c2:getPosition()
        return y1 > y2
    end

    local cards = self:getSprites()
    
    if not cards or #cards < 1 then
        return
    end

    table.sort(cards, sortCompare)
    for i,v in ipairs(cards) do
        local x, y = self:getCardPos(i, #cards)
        if inFastMode then
            v:setPosition(x, y)
        else
            transition.moveTo(v, {x = x, y = y, time = 0.15})
        end
        v:zorder(i)
    end
 
end

-- 获得一坎牌的值
function KanView:getCards()
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

-- 获得一坎牌的未旋转时的大小, 判断矩形触摸时用的
function KanView:getSize()
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
        multiple = 4
    end
    local total_height = max_height * multiple

    local line_height = total_height / totalCount
    return math.min(line_height, max_height)
end

function KanView:canAddCard()
    return #self:getCards() < 4
end

function KanView:addCard(card, x1, y1)
    local count = #self:getCards() + 1
    local x, y, z = self:getCardPos(count, count)
    if x1 ~= nil and y1 ~= nil then
        x, y = x1, y1
    end
    local cards = self:getCards()
    table.insert(cards,card)
    table.sort(cards, sortCompare)
    self:removeAll()
    self:draw(cards,false)
end

function KanView:getCardPos(index, totalCount)
    local y = self.height - KAN_HEIGHT / 2 - (index - 1) * getLineHeight(totalCount)
    -- if totalCount > 3 then
    --   y = y + max_height * 0.5
    -- end
    return KAN_WIDTH / 2, y
end

-- 坎是否为固定不可移动坎
function KanView:isFixed()
    return self:getIsFixed(self:getCards())
end

-- 固定某些坎不可移动和触摸
function KanView:fixTiOrWei()
    if not self:isFixed() then
        return
    end

    local array = self:getChildren()

    if not array then
        return
    end
    for i,v in ipairs(array) do
        if v:getName() ~= "inKanView" 
            and  v:getName() ~= "mengceng"  
            and  v:getName() ~= "forbidden"  
            and  v:getName() ~= "huXiLabel"
            then  
            v:setFixed(true)
        end
    end
  
end

function KanView:getIsFixed(cards)
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

function KanView:showHightLight(card,isHigh)
    local array = self:getChildren()
    if not array then
        return false
    end 
  
    for i,v in ipairs(array) do
        if v.card == card  and v:getName() ~= "inKanView" 
            and  v:getName() ~= "mengceng"  
            and  v:getName() ~= "forbidden"  
            and  v:getName() ~= "huXiLabel"
            then  
            if isHigh then
                v:highLight()
            else
                v:clearHighLight()
            end 
            return true
        end 
    end  
end

function KanView:getCardsNodeList()
    return table.values(self.cardsNodeList_)
end

function KanView:clearFromBack()
    local array = self:getChildren()
    self:hideTip()
    if not array then
        return false
    end 
  
    for i,v in ipairs(array) do
        if v:getName() ~= "inKanView" 
            and  v:getName() ~= "mengceng"  
            and  v:getName() ~= "forbidden"  
            and  v:getName() ~= "huXiLabel"
            then  
            v:clearHighLight()
        end 
    end  

end

function KanView:draw(cards, needFlip,flipBaseTime,mingpai)
    self:removeAll()
    for k, v in pairs(cards) do
        local x, y = self:getCardPos(k, #cards) 
        local fanpai = mingpai or false
        local tmp = PaperCardView.new(v, 1, mingpai, self.func):addTo(self):pos(x, y) 
        tmp:setName("PaperCardView"..x..y..v)
        self.cardsNodeList_["PaperCardView"..x..y..v] = tmp
        if needFlip then
          tmp:performWithDelay(function ()
          tmp:flip(v, 1)
            end, flipBaseTime + k * 0.05)
        end
    end 
    self.inKanView =  display.newNode():addTo(self):pos(0,0)
    self.inKanView:setColor(cc.c3b(86, 131, 1))
    self.inKanView:setContentSize(cc.size(KAN_WIDTH, KAN_HEIGHT * 4))
    self.inKanView:setName("inKanView") 

    self.mengceng = display.newScale9Sprite("res/images/game/mengceng_bg.png"):addTo(self.inKanView):pos(KAN_WIDTH/2 ,self.height - KAN_HEIGHT + 20 )
    self.mengceng:setContentSize(cc.size(KAN_WIDTH + 5, KAN_HEIGHT*2 ))
    self.mengceng:setName("mengceng")
    self.mengceng:setOpacity(125)
    self.forbiddenView =  display.newSprite("res/images/game/forbidden.png"):addTo(self.inKanView):pos(KAN_WIDTH/2,self.height - 30) 
    self.forbiddenView:setName("forbidden")
    if setData:getCDPHZHXTS() then
        self:clacSelfHuXi(cards)
    end
    self:hideTip()
    return self
end

function KanView:clacSelfHuXi(cards)
    if self.huXiBg_  then
        self.huXiBg_:removeSelf()
        self.huXiBg_ = nil
    end
    self.huXiBg_ = display.newSprite("res/images/paohuzi/game/kanHuXiBg.png")
    self:addChild(self.huXiBg_,120)
    local huxi = 0
    if #cards == 4 then
        huxi = PaoHuZiAlgorithm.calcHuXiTi(cards)
    else
        huxi = PaoHuZiAlgorithm.calcThreeHuXi(cards)
    end
    self.huXilabel_ = gailun.uihelper.createLabel({options = {text = huxi .."胡", font = DEFAULT_FONT, size = 26, color = cc.c4b(255, 255, 255, 255)}})
    self.huXiBg_:setName("huXiLabel")
    self.huXiBg_:addChild(self.huXilabel_)
    self.huXiBg_:pos(47,950)
    self.huXiBg_:setOpacity(100)
    self.huXilabel_:setAnchorPoint(0.5,0.5)
    self.huXilabel_:pos(45,15)
end

function KanView:makeCards(cards, getYFunc)
  
end

function KanView:moveAfterDel()
  
end

return KanView

