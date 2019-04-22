local PokerListView = class("PokerListView", function()
    return display.newSprite()
    end)
local PokerView = import("app.views.game.PokerView")

local BaseAlgorithm = require("app.games.nxlmz.utils.BaseAlgorithm")
local ZMZAlgorithm = import("app.games.nxlmz.utils.ZMZAlgorithm")

local POKER_WIDTH = 154
local SELECTED_HEIGHT = 25
local POKER_Y = 20

function PokerListView:ctor(mode)
    self.margin_ = 57
    if setData:getPDKPMTYPE()+0 == 1 then
        self.margin_ = 70
    end
    gailun.uihelper.setRawTouchHandler(self, handler(self, self.onTouchEnded_), 
        handler(self, self.onTouchBegin_), handler(self, self.onTouchMoved_))
    self.player_ = mode
    self.tempCards_ = {}
    self.isInReView_ = false
    self.pokerList_ = {}
    self.isTips_ = false
    self.tipsCount_ = 0
end

function PokerListView:setInReView(bool)
    self.isInReView_ = bool
end

function PokerListView:cheackIsBack_()
    if self.pokerList_ and self.pokerList_[1] then return self.pokerList_[1].isback end
end

function PokerListView:onTouchBegin_(event)
    if self.isInReView_ then return end
    if self.pokerList_ and self.pokerList_[1] and self.pokerList_[1].isback then return end
    self.touchInPokers_ = self:isInPokers_(event.x, event.y)
    if not self.touchInPokers_ then
        return
    end
    self.startTouchX_ = event.x
    self.endTouchX_ = event.x
    self.startTouchY_ = event.y
end

function PokerListView:onTouchMoved_(event)
    if self.isInReView_ then return end
    if not self.touchInPokers_ then
        return
    end
    self.endTouchX_ = event.x
    self:pickUpPokers_()
end

function PokerListView:onTouchEnded_(event)
    if self.isInReView_ then return end
    if not self.touchInPokers_ then
        return
    end
    self.endTouchX_ = event.x
    local selecteds = self:pickUpPokers_()
    self:popUpPokers_(self:fileterSelectedPokers_(selecteds))
end

function PokerListView:isInPokers_(x, y)
    for _,v in ipairs(self.pokerList_) do
        if cc.rectContainsPoint(v:getCascadeBoundingBox(), cc.p(x, y)) then
            return true
        end
    end
    return false
end

function PokerListView:pickUpPokers_()
    local list = {}
    local nodes = self.pokerList_
    local ceng = 2
    local index = 0
    local total = #nodes
    local tempTotal = 0
    for i,v in ipairs(nodes) do
        local x1, x2  = self:calcPokerBorder_(v, total, i)
        local flag = self:inTouchRange_(x1, x2)
        v:setHighLight(flag)
        -- v:setCanSelected(flag)
        if flag then 
            list[#list+1] = v
        end
    end
    return list
end

function PokerListView:lockTouch_(seconds)
    self:runAction(transition.sequence({
        cc.CallFunc:create(function () self:setTouchEnabled(false) end),
        cc.DelayTime:create(seconds),
        cc.CallFunc:create(function () self:setTouchEnabled(true)end),
    }))
end

function PokerListView:getSelectedCards_()
    self.selectedCards_ = {}
    local pokers = {}
    local cards = {}
    for i,v in ipairs(self.pokerList_) do
        if v:isHighLight() then
            if not v:isSelected() then
                table.insert(pokers, v:getCard())
                table.insert(cards, v)
            end
        end
    end
    self:fileterSelectedPokers_(cards)
    return self.selectedCards_
end

function PokerListView:fileterSelectedPokers_(pokers)
    local cards = {}
    for i,v in ipairs(pokers) do
        cards[#cards+1] = v:getCard()
    end
    local list = ZMZAlgorithm.checkPaiXing(cards, display.getRunningScene():getRuleDetails())

    -- if #display.getRunningScene():getCurrCards() == 0 then
    --     return list
    -- end

    -- list = self:getMostCards(cards)
    
    return list
end

function PokerListView:getMostCards(nowCards)
    local cards = display.getRunningScene():getCurrCards()
    if #cards == 0 then
        return nowCards
    end

    self:initTishi()

    if #self.tipsCards_ == 0 then
        return nowCards
    end
    
    local map = {}
    for _, card in ipairs(nowCards) do
        map[card%100] = 1
    end

    for _, cards in ipairs(self.tipsCards_) do
        for _, card in ipairs(cards) do
            if map[card%100] ~= nil then
                return cards
            end
        end
    end

    return nowCards
end

function PokerListView:popUpPokers_(pokers)
    local seconds = 0.1
    self:popUpPokerList_(self.pokerList_, pokers, seconds)
    self:lockTouch_(seconds)
end

function PokerListView:popUpPokerList_(pokerList, pokers, seconds)
    for _,v in ipairs(pokerList) do
        if v:isHighLight() then
            local y = SELECTED_HEIGHT
            if v:isSelected() then
                v:setSelected(false)
                y = -y
                transition.moveBy(v, {y = y, time = seconds})
            else
                if pokers and #pokers > 0 then
                    print(v:getCard())
                    if self:isHasPoker_(pokers, v) then
                        v:setSelected(true)
                        transition.moveBy(v, {y = y, time = seconds})
                    else
                        v:setSelected(false)
                    end
                else
                    v:setSelected(true)
                    transition.moveBy(v, {y = y, time = seconds})
                end
            end
        end
    end
end

function PokerListView:isHasPoker_(pokers, poker)
    for k,v in pairs(pokers) do
        if poker:getCard() == v then
            return true
        end
    end
    return false
end

-- 判断扑克牌是否处于触摸范围内
function PokerListView:inTouchRange_(leftX, rightX)
    local startX = math.min(self.startTouchX_, self.endTouchX_)
    local endX = math.max(self.startTouchX_, self.endTouchX_)
    return (leftX >= startX and leftX <= endX) or 
            (rightX >= startX and rightX <= endX)  or 
            (startX >= leftX and startX <= rightX)  or 
            (endX >= leftX and endX <= rightX)
end

-- 计算牌的左右边界
function PokerListView:calcPokerBorder_(poker, total, index)
    local ccret = poker:getCascadeBoundingBox()
    local height = poker:getHeight()
    local topY = poker:getPositionY() + height / 2
    local downY = poker:getPositionY() - height / 2
    local leftX = ccret.origin.x
    local rightX = leftX + self.margin_
    if index == total then
        rightX = leftX + POKER_WIDTH
    end
    return leftX, rightX,topY, downY
end

function PokerListView:showPokers(cards, isAnima, isBack)
    if cards == nil then return end
    if #cards ==0 then return end
    self:removeAllChildren()
    self.pokerList_ = {}
    self.sortIndex_ = 1
    -- if isAnima then
    --     self:showPokersWithoutAnim_(cards,isAnima,nil,isBack)
    -- else
        local tempCards = ZMZAlgorithm.sort(cards)
        self:showPokersWithoutAnim_(tempCards,false,nil,isBack)
    -- end
end

function PokerListView:getCards_()
    local cards = {}
    for _,v in pairs(self.pokerList_) do
        table.insert(cards, v:getCard())
    end
    return cards
end

function PokerListView:getPokerByCard_(card)
    for _,v in pairs(self.pokerList_) do
        if v:getCard() == card then
            return v
        end
    end
end

function PokerListView:adjustPokerPos_(notAction)
    -- self:updatePokerPos_(self.pokerList1_, #self.pokerList2_, notAction)
    -- self:updatePokerPos_(self.pokerList2_,nil,notAction)
end

function PokerListView:updatePokerPos_(pokerList)
    local seconds = 0.1
    for i,v in ipairs(pokerList) do
        local x, y, z = self:calcPokerPos_(#pokerList, i)
        local poker = pokerList[i]
        if poker then
            if self.isInReView_ or notAction then 
                poker:pos(x, y)
            else
                transition.moveTo(poker, {x = x, y = y, time = seconds, easing = "exponentialOut"})
            end
            poker:zorder(z)
        end
    end
end

function PokerListView:setPokerTohuise(cards, sameCards)
    for i,v in ipairs(cards) do
        local value = BaseAlgorithm.getValue(v)
        for j,poker in ipairs(self.pokerList_) do
            local cardValue = BaseAlgorithm.getValue(poker:getCard())
            if value == cardValue then
            end
        end
    end
    for i,v in pairs(sameCards) do
        for j,poker in ipairs(self.pokerList_) do
            if v == poker:getCard() then
            end
        end
    end
end

function PokerListView:calcPokerPos_(total, index)
    local addMargin = 0
    local offset = (index - (total - 1) / 2 - 1) * self.margin_
    local x = offset
    local y = POKER_Y
    return x, y, index
end

function PokerListView:showPokersWithoutAnim_(cards, isAnima, callback, isback)
    self:stopAllActions()
    self:removeAllPokers()
    -- local setup = 0.05
    -- if isAnima == false or self.isInReView_ == true then
    --     setup = 0
    -- end
    local timers = 0
    local actions = {}
    gameAudio.playSound("sounds/common/sound_fapai.mp3")
    for i,v in ipairs(cards) do
        -- table.insert(actions, cc.CallFunc:create(function ()
            local x, y, z = self:calcPokerPos_(#cards, i)
            local poker = PokerView.new(v,isback):addTo(self):pos(x, y)
            poker:showBack(false)
            poker:fanPai()
            self.pokerList_[#self.pokerList_+1] = poker
        -- end))
        -- table.insert(actions, cc.DelayTime:create(setup))
    end
    local actions = {}
    if isAnima then
        table.insert(actions, cc.DelayTime:create(0.5))
        table.insert(actions, cc.CallFunc:create(function ()
            for i,v in ipairs(self.pokerList_) do
                v:showBack(true)
            end
        end))
        table.insert(actions, cc.DelayTime:create(0.3))
        table.insert(actions, cc.CallFunc:create(function ()
            local tempCards = ZMZAlgorithm.sort(clone(cards))
            self:upDateHanderPokerPos_(tempCards)
        end))
    end
    if #actions > 0 then
        self:runAction(transition.sequence(actions))
    end
end

function PokerListView:fanPai()
    for _,v in pairs(self.pokerList_) do
        v:fanPai()
    end
end

function PokerListView:setTipsCards(cards, isAddTipsCount)
    self:resetPopUpPokers(isAddTipsCount)
    local seconds = 0.1
    for i = 1, #cards do
        for _,v in pairs(self.pokerList_) do
            if v:getCard() == cards[i] then
                if v:isSelected() == false then
                    v:setSelected(true)
                    transition.moveBy(v, {y = SELECTED_HEIGHT, time = seconds})
                    break
                end
            end
        end
    end
end

function PokerListView:getPopUpPokers()
    local cards = {}
    for _,v in pairs(self.pokerList_) do
        if v and v:isSelected() then
            table.insert(cards, v:getCard())
        end
    end
    return cards
end

function PokerListView:getPopPokers(cards)
    local list = {}
    for _,v in pairs(self.pokerList_) do
        if table.indexof(cards, v:getCard()) ~= false then
            list[#list+1] = v
        end
    end
    return list
end

function PokerListView:resetPopUpPokers(isAddTipsCount)
    print("========resetPopUpPokers=========")
    local seconds = 0.1
    for _,v in pairs(self.pokerList_) do
        if v:isSelected() then
            transition.moveBy(v, {y = -SELECTED_HEIGHT, time = seconds})
        end
        v:setSelected(false)
    end
    if not isAddTipsCount then
        self.isTips_ = false
        self.tipsCount_ = 0
    end
end

function PokerListView:removePokers(cards)
    self.isTips_ = false
    self.tipsCount_ = 0
    for i,v in ipairs(cards) do
        for j,poker in ipairs(self.pokerList_) do
            if v == poker:getCard() then
                table.removebyvalue(self.pokerList_, poker)
                poker:removeFromParent()
                break
            end
        end
    end
    if self.isInReView_ then
        self:upDateReViewHanderPokerPos_(self:getCards_())
    else
        self:upDateHanderPokerPos_(self:getCards_())
    end
    if self.isInReView_ then
        self:show()
    end
end

function PokerListView:upDateReViewHanderPokerPos_(cards)
    self:removeAllPokers()
    local timers = 0
    local setup = 0
    local pokerList = {}
    local actions = {}
    for i,v in ipairs(cards) do
            local x, y, z = self:calcPokerPos_(#cards, i)
            local poker = PokerView.new(v):addTo(self):pos(x, y)
            transition.moveTo(poker, {x = x, y = y, time = setup, easing = "exponentialOut"})
            poker:fanPai()
            poker:zorder(z)
            -- self.pokerList_[index] = nil
            self.pokerList_[#self.pokerList_+1] = poker
            gameAudio.playSound("sounds/common/sound_fapai.mp3")
    end
end

function PokerListView:faPaiRank_(cards)
    local cards = ZMZAlgorithm.sort(cards)
    self:upDateHanderPokerPos_(cards,true)
end

function PokerListView:upDateHanderPokerPos_(cards, playYX)
    if self:cheackIsBack_() then
        return
    end
    local timers = 0
    local setup = 0
    local pokerList = {}
    local actions = {}
    for i,v in ipairs(cards) do
        table.insert(actions, cc.CallFunc:create(function ()
            local x, y, z = self:calcPokerPos_(#cards, i)
            local poker = self:getPokerByCard_(v)
            poker:setSelected(false)
            transition.moveTo(poker, {x = x, y = y, time = setup, easing = "exponentialOut"})
            if playYX then
                gameAudio.playSound("sounds/common/sound_fapai.mp3")
            end
            poker:fanPai()
            poker:zorder(z)
            pokerList[#pokerList+1] = poker
        end))
        table.insert(actions, cc.DelayTime:create(setup))
    end
    table.insert(actions, cc.CallFunc:create(function ()
        self.pokerList_ = pokerList
        self:resetPokerFlagStatus_()
    end))
    self:runAction(transition.sequence(actions))
end

function PokerListView:updatePokerStatue()
    local cards = display.getRunningScene():getCurrCards()
    if #cards == 0 then
        return
    end
    self.tipsCount_ = 0
    self:initTishi()

    self:lockCards(BaseAlgorithm.getCardsFromList(self.tipsCards_))
end

function PokerListView:lockCards(cards)
    local cardsMap = {}
    for _, v in ipairs(cards) do
        cardsMap[v] = 1
    end

    for k, v in ipairs(self.pokerList_) do
        if cardsMap[v:getCard()] == nil then
            -- v:setCanSelected(false)
        end
    end
end

function PokerListView:initTishi(isBaoDan)
    if self.isTips_ == false then
        self.tipsCards_ = {}
        local cards = display.getRunningScene():getCurrCards()
        if #cards == 0 then
            cards = {0}
        end
        local list = ZMZAlgorithm.tishi(cards, self:getCards_(), display.getRunningScene():getRuleDetails(),isBaoDan)
        if list and #list > 0 then
            for i,v in ipairs(list) do
                table.insert(self.tipsCards_, v)
            end
        end
        if #self.tipsCards_ == 0 then
            return
        end
        self.isTips_ = true
        self.tipsCount_ = 0
    end
end

function PokerListView:tishi()
    local cards = display.getRunningScene():getCurrCards()
    local playerCount = display.getRunningScene():getRuleDetails().playerCount
    local nextSeatID = self.player_:getNextPlayer()
    local player = display.getRunningScene():getPlayerBySeatID(nextSeatID)
    self:initTishi(player:getWarningType() == 1)
    local total = #self.tipsCards_
    if total == 0 then return {} end
    self.tipsCount_ = self.tipsCount_ + 1
    if self.tipsCount_ > total then
        self.tipsCount_ = 1
    end
    if (playerCount == 3 or playerCount == 2) and player:getWarningType() == 1 and #cards == 1 then
        local function sortRank(a,b)
            return BaseAlgorithm.getValue(a[1]) < BaseAlgorithm.getValue(b[1])
        end
        table.sort(self.tipsCards_, sortRank)
        self:setTipsCards(self.tipsCards_[#self.tipsCards_], true)
    else
        self:setTipsCards(self.tipsCards_[self.tipsCount_], true)
    end

    return self.tipsCards_
end

function PokerListView:resetPokerFlagStatus_()
    for i,v in ipairs(self.pokerList_) do
    end
end

function PokerListView:removeAllPokers()
    for i,v in ipairs(self.pokerList_) do
        v:removeSelf()
    end
    self.pokerList_ = {}
end

return PokerListView 
