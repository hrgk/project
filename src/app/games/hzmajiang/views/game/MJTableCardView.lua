local TYPES = gailun.TYPES
local nodes = {
    type = TYPES.ROOT,
    children = {
        {type = TYPES.NODE, var = "bTableCard_"}, -- 玩家1聊天气泡容器
        {type = TYPES.NODE, var = "rTableCard_"}, -- 玩家2聊天气泡容器
        {type = TYPES.NODE, var = "tTableCard_"}, -- 玩家3聊天气泡容器
        {type = TYPES.NODE, var = "lTableCard_"}, -- 玩家4聊天气泡容器
    }
}

local MJTableCardView = class("MJTableCardView", gailun.BaseView)

function MJTableCardView:ctor()
    gailun.uihelper.render(self, nodes)
    self.signNum = {14,14,14,14}
end

function MJTableCardView:initTableCard()
    self:createCard_(MJ_TABLE_DIRECTION.BOTTOM,self.bTableCard_)
    self.bTableCard_:pos(320,-270)
    self.bTableCard_:setRotation(0.3)
    self.rTableCard_:pos(320,180)
    self:createCard_(MJ_TABLE_DIRECTION.RIGHT,self.rTableCard_)
    self.rTableCard_:setRotation(-2)
    self:createCard_(MJ_TABLE_DIRECTION.TOP,self.tTableCard_)
    self.tTableCard_:pos(-250,230)
    self.tTableCard_:setScale(0.7)
    self:createCard_(MJ_TABLE_DIRECTION.LEFT,self.lTableCard_)
    self.lTableCard_:pos(-320,150)
    dump("lllllllllllllllllllllllllllllllllllllllll")
end

function MJTableCardView:faPaiHideCard(zhuangIndex,dice1,dice2,leaftCount)
    self:initTableCard()
    local startIndex = zhuangIndex
    for i = 1,dice1 - 1 do
        startIndex = startIndex - 1
        if startIndex == 0 then
            startIndex = 4
        end
    end
    local diceCard1 = {}
    local diceCard2 = {}
    for i = 1,self.signNum[startIndex]*2 do
        if i <= dice2*2 then
            table.insert(diceCard1,self[startIndex][i])
        else
            table.insert(diceCard2,self[startIndex][i])
        end
    end
    self.aimShowCard = {}
    table.insertto(self.aimShowCard,diceCard2)
    for i = 1,3 do
        startIndex = startIndex - 1
        if startIndex == 0 then
            startIndex = 4
        end
        table.insertto(self.aimShowCard,self[startIndex])
    end
    table.insertto(self.aimShowCard,diceCard1)
    if leaftCount then
        self:setLeftCount(leaftCount)
    end
end

function MJTableCardView:setLeftCount(leftCount)
    if not self.aimShowCard then
        return
    end
    local lengh = #self.aimShowCard
    for i = lengh,1,-1 do
        self.aimShowCard[i]:setVisible(i > lengh - leftCount)
    end
end

function MJTableCardView:createCard_(dir,cardNode)
    self[dir] = {}
    local cardNum = self.signNum[dir]
    local shangNum = 0
    local xiaNum = 0
    local index = 0
    local type = 0
    for j = 1, cardNum*2 do
        if j % 2 == 1 then
            shangNum = shangNum + 1
            index = shangNum
            type = 1
        else
            xiaNum = xiaNum + 1
            index = xiaNum
            type = 2
        end
        local x, y = self:calcCardPos_(index,dir,type)
        local card = 0
        local maJiang = app:createConcreteView("MaJiangView", card, dir, true):addTo(cardNode):pos(x, y)
        if dir == MJ_TABLE_DIRECTION.LEFT then
            self[dir][j] = maJiang
        else
            if type == 1 then
                self[dir][j+1] = maJiang
            else
                self[dir][j-1] = maJiang
            end
        end
       
    end
    if dir == MJ_TABLE_DIRECTION.LEFT then
        local temp = clone(self[dir])
        self[dir] = {}
        for i = #temp,1,-1 do
            table.insert(self[dir],temp[i])
        end
    end
end

function MJTableCardView:calcCardPos_(index,dir,type)
    if MJ_TABLE_DIRECTION.BOTTOM == dir then
        return self:calcCardPosBottom_(index,type)
    elseif MJ_TABLE_DIRECTION.RIGHT == dir then
        return self:calcCardPossRight_(index,type)
    elseif MJ_TABLE_DIRECTION.TOP == dir then
        return self:calcCardPosTop_(index,type)
    else
        return self:calcCardLeftTop_(index,type)
    end
end

function MJTableCardView:calcCardLeftTop_(index,type)
    if type == 2 then
        return (index-1)*-5,-28*(index-1)+16
    else
        return (index-1)*-5,-28*(index-1)
    end
    
end

function MJTableCardView:calcCardPosTop_(index,type)
    if type == 2 then
        return 47*(index-1),20
    else
        return 47*(index-1),0
    end
end

function MJTableCardView:calcCardPosBottom_(index,type)
    if type == 2 then
        return -47*(index-1),20
    else
        return -47*(index-1),0
    end
end

function MJTableCardView:calcCardPossRight_(index,type)
    if type == 2 then
        return index*3+4,-28*(index-1)+16
    else
        return index*3,-28*(index-1)
    end
end

return MJTableCardView
