local MaJiang = import(".MaJiang")
local BaseAlgorithm = import("app.games.zzmj.utils.ZZAlgorithm")

local MaJiangHandList = class("MaJiangHandList", function()
    return display.newSprite()
end)

function MaJiangHandList:ctor(cards, index, isFaPai)
    self.index_ = index
    self.cardList_ = {}
    self:initCards(cards, isFaPai)
end

function MaJiangHandList:setPlayer(player)
    self.player_ = player
end

function MaJiangHandList:initCards(cards, isFaPai)
    if isFaPai then
        self:createMaJiangList_(cards)
    else
        BaseAlgorithm.sort(cards, true)
        for i,v in ipairs(cards) do
            local x,y = self:clacMaJiangPos_(i)
            local maJiang = MaJiang.new(v, self.index_):addTo(self)
            maJiang:setMaJiangPos(x,y)
            maJiang:isShowMoPaiMian(false)
            self.cardList_[i] = maJiang
        end
    end
end

function MaJiangHandList:createMaJiangList_(cards)
    for i,v in ipairs(cards) do
        local x,y = self:clacMaJiangPos_(i)
        local maJiang = MaJiang.new(v, self.index_):addTo(self)
        maJiang:setMaJiangPos(x,y)
        maJiang:isShowMoPaiMian(false)
        self.cardList_[i] = maJiang
    end
    self:performWithDelay(function()
        for i,v in ipairs(self.cardList_) do
            v:isShowMoPaiMian(true)
        end
    end, 0.5)
    self:performWithDelay(function()
        self:updateMaJiangPos_()
    end, 1)
end

function MaJiangHandList:clacMaJiangPos_(index)
    local x = 0
    local y = 0
    if self.index_ == 1 then
        x = (index-1)*(-85) + 10
    elseif self.index_ == 2 then
        y = (index-1)*(-30) + 10
    elseif self.index_ == 3 then
        x = (index-1)*40
    elseif self.index_ == 4 then
        y = (index-1)*(-30)
    end
    return x, y 
end

function MaJiangHandList:removeCards(cards, isMo)
    for k,v in ipairs(cards) do
        self:removeCard_(v, true)
    end
    self:updateMaJiangPos_(isMo)
end

function MaJiangHandList:removeCard_(card)
    for i,v in ipairs(self.cardList_) do
        if card == v:getCard() then
            table.remove(self.cardList_, i)
            self:removeChild(v)
            v = nil
            break
        end
    end
end

function MaJiangHandList:getCards()
    local cards = {}
    for i,v in ipairs(self.cardList_) do
        table.insert(cards, v:getCard())
    end
    return cards
end

function MaJiangHandList:updateMaJiangPos_(isMo)
    local cards = self.player_:getCards()
    local tempCards = {}
    if isMo then
        for i=1,#cards -1 do
            tempCards[i] = cards[i]
        end
        self:removeCard_(cards[#cards])
    else
        tempCards = cards
    end
    BaseAlgorithm.sort(tempCards)
    local tempList = {}
    for i,v in pairs(tempCards) do
        local x,y = self:clacMaJiangPos_(i)
        local isNew = true
        for j,maJiang in ipairs(self.cardList_) do
            maJiang:isShowMoPaiMian(false)
            if v == maJiang:getCard() then
                if maJiang:getFlag() == 0 then
                    maJiang:setFlag(1)
                    isNew = false
                    maJiang:setMaJiangPos(x,y)
                    tempList[i] = maJiang
                    break
                end
            end
        end
        if isNew then
            local maJiang = MaJiang.new(v, self.index_):addTo(self)
            maJiang:setMaJiangPos(x,y)
            maJiang:isShowMoPaiMian(false)
            tempList[i] = maJiang
        end
    end
    self.cardList_ = tempList
    self:resetMaJiangFlag_()
end

function MaJiangHandList:tanPai(cards)
    self:removeAllChildren()
    self.cardList_ = {}
    self:initCards(cards)
end

function MaJiangHandList:qiShouHu(cards)
    if self.player_:isHost() then
        for i,v in ipairs(cards) do
            for j,maJiang in ipairs(self.cardList_) do
                if maJiang:getCard() == v and maJiang:getFlag() == 0 then
                    maJiang:qiShouHu(v)
                    maJiang:setFlag(1)
                    break
                end
            end
        end
    else
        for i,v in ipairs(cards) do
            self.cardList_[i]:qiShouHu(v)
        end
    end
    self:resetMaJiangFlag_()
end

function MaJiangHandList:resetMaJiangFlag_()
    for i,v in ipairs(self.cardList_) do
        v:setFlag(0)
    end
end

function MaJiangHandList:setMaJiangToutch(bool)
    for i,v in ipairs(self.cardList_) do
        v:setTouchEnabled(bool)
    end
end

return MaJiangHandList 
