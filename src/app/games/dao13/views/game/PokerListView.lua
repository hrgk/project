local PokerListView = class("PokerListView", gailun.BaseView)
local BaseAlgorithm = require("app.games.dao13.utils.BaseAlgorithm")
local D13Algorithm = import("app.games.dao13.utils.D13Algorithm")
local PokerView = import("app.views.game.PokerView")

local POKER_WIDTH = 154
local SELECTED_HEIGHT = 25

function PokerListView:ctor(needTipCard)
    self.margin_ = 45
    gailun.uihelper.setRawTouchHandler(self, handler(self, self.onTouchEnded_),
        handler(self, self.onTouchBegin_), handler(self, self.onTouchMoved_))
    self.tempCards_ = {}
    self.isInReView_ = false
    self.isChange_ = false
    self.pokerList_ = {}
    self.downCount_ = 0
    self.upCount_ = 0
    self.interval_ = 0 --牌间隔
    self.needTipCard_ = needTipCard
end

function PokerListView:setNeedTipCard(needTipCard)
    self.needTipCard_ = needTipCard
end

function PokerListView:setInReView(bool)
    self.isInReView_ = bool
end

function PokerListView:onTouchBegin_(event)
    dump(self.isInReView_,"self.isInReView_")
    if self.isInReView_ then return end
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
    self:pickUpPokers_()
    self:getSelectedCards_()
    self:popUpPokers_(self:getSelectedCards_())
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
    local nodes = self.pokerList_
    local index = 0
    local total = #nodes
    local tempTotal = 0
    for i,v in ipairs(nodes) do
        index = index + 1
        local x1, x2  = self:calcPokerBorder_(v, total, index)
        local flag = self:inTouchRange_(x1, x2)
        local topY, downY= self:checkPokerY_(v)
        if v:isCanSelected() and flag and self.startTouchY_ > downY and self.startTouchY_ < topY then
            v:setHighLight(flag)
        end
    end
end

function PokerListView:checkPokerY_(poker, ceng, isPiGu)
    local topY = poker:getPositionY() + poker:getHeight() / 2
    local downY = poker:getPositionY() - poker:getHeight() / 2
    topY = topY - 10
    return topY, downY
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
    self:fileterSelectedPokers_(cards,pokers)
    return self.selectedCards_
end

function PokerListView:fileterSelectedPokers_(cards, pokers)
    local list = {}
    local poker = 0
    self.selectedCards_ = pokers
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
                if pokers then
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

function PokerListView:showPokers(cards, isAnima, callback)
    if cards == nil then return end
    if #cards ==0 then return end
    self:showPokersWithoutAnim_(cards,isAnima, callback)
end

function PokerListView:showPokersOnlyBack(cards)
    if cards == nil then return end
    if #cards ==0 then return end
    self:removeAllPokers()
    for i,v in ipairs(cards) do
        local x, y, z = self:calcPokerPos_(#cards, i, 1)
        local poker = PokerView.new(v):addTo(self):pos(x, y)
        poker.posX_ = x
        poker.posY_ = y
        poker:setScale(0.735)
        table.insert(self.pokerList_, poker)
    end
end

function PokerListView:setAllBack()
    for i,v in ipairs(self.pokerList_) do
        v:showBack(true)
    end
end

function PokerListView:getCards_()
    local cards = {}
    for _,v in pairs(self.pokerList_) do
        table.insert(cards, v:getCard())
    end
    return cards
end

--被选起来的牌
function PokerListView:getSelectedCard_()
    local cards = {}
    for _,v in pairs(self.pokerList_) do
        if v:isSelected() then
            table.insert(cards, v:getCard())
        end
    end
    return cards
end

function PokerListView:getPokerByCard_(card)
    -- dump(self.pokerList_)
    for _,v in pairs(self.pokerList_) do
        if v:getCard() == card and v:getPokerFlag() == 0 then
            v:setPokerFlag(1)
            return v
        end
    end
end

function PokerListView:adjustPokerPos_(notAction)
    -- self:updatePokerPos_(self.pokerList1_, #self.pokerList2_, notAction)
    -- self:updatePokerPos_(self.pokerList2_,nil,notAction)
end

function PokerListView:updatePokerPos_(pokerList, diTotal, notAction)
    local seconds = 0.1
    for i,v in ipairs(pokerList) do
        local x, y, z = 0,0,0
        if diTotal then
            x, y, z = self:calcPokerPos_(#pokerList, i, 2, diTotal)
        else
            x, y, z = self:calcPokerPos_(#pokerList, i, 1)
        end
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
    do return end
    for i,v in ipairs(cards) do
        local value = BaseAlgorithm.getValue(v)
        for j,poker in ipairs(self.pokerList_) do
            local cardValue = BaseAlgorithm.getValue(poker:getCard())
            if value == cardValue then
                poker:setCanSelected(false)
            end
        end
    end
    for i,v in pairs(sameCards) do
        for j,poker in ipairs(self.pokerList_) do
            if v == poker:getCard() then
                poker:setCanSelected(false)
            end
        end
    end
end

function PokerListView:removeHuise()
    do return end
    for i,v in ipairs(self.pokerList_) do
        v:setCanSelected(true)
    end
end

function PokerListView:calcPokerPos_(total, index, ceng, diTotal)
    local fixOffset = -95--牌位置默认-95
    local offset = 0
    local interval=0--间距
    -- print(self.margin_)
    if self.margin_ == 38 then--800
        interval = 2
        fixOffset = -117
    elseif self.margin_ >= 40 and self.margin_ <= 41 then--600
        interval = 2
        fixOffset =-135
    elseif self.margin_ >= 39 and self.margin_ <= 40 then--400
        interval = 2
        fixOffset =-125
    elseif self.margin_ >= 42 then--720
        interval = 3
        fixOffset =-155
    end

    local x = 0
    offset = (1 - (14 - 1) / 2 - 1) * self.margin_
    offset = 0
    fixOffset = 0
    interval = 0

    x = (index - 1) * self.margin_ + offset + fixOffset + interval * self.interval_
    local y = 168
    if ceng == 1 then
        y = 85
    else
        offset = (1 - (14 - 1) / 2 - 1) * self.margin_ 
        x = (index - 1) * self.margin_ + offset + fixOffset + interval * self.interval_
    end
    self.interval_ = self.interval_ + 1
    print(x, y, index)
    return x, y, index
end

function PokerListView:showPokersWithoutAnim_(cards, isAnima, callback)
    self:removeAllPokers()
    self.interval_ = 0--重制间隔
    local setup = 0.03
    if isAnima == false or (isAnima == false and self.isInReView_ == true) then
        setup = 0
    end
    local timers = 0
    local actions = {}
    for i,v in ipairs(cards) do
        table.insert(actions, cc.CallFunc:create(function ()
            local x, y, z = self:calcPokerPos_(#cards, i, 1)
            local poker = PokerView.new(v):addTo(self):pos(x, y)
            poker.posX_ = x
            poker.posY_ = y
            poker:setScale(0.735)
            poker:fanPai()
            if self.needTipCard_ == v then
                poker:setBlack()
            end
            gameAudio.playSound("sounds/datongzi/click_poker.mp3")
            table.insert(self.pokerList_, poker)
        end))
        table.insert(actions, cc.DelayTime:create(setup))
    end
    if isAnima then
        if callback then
            table.insert(actions, cc.DelayTime:create(0.5))
            table.insert(actions, cc.CallFunc:create(function ()
                for i,v in ipairs(self.pokerList_) do
                    v:showBack(true)
                end
            end))
            table.insert(actions, cc.DelayTime:create(0.5))
            table.insert(actions, cc.CallFunc:create(function ()
                if callback then
                    callback()
                end
            end))
        end
    end
    self:runAction(transition.sequence(actions))
    -- self:lockTouch_(2)
end

function PokerListView:fanPai()
    for _,v in pairs(self.pokerList_) do
        v:fanPai()
    end
end

function PokerListView:setTipsCards(cards)
    self:resetPopUpPokers()
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

function PokerListView:resetPopUpPokers()
    local seconds = 0.1
    for _,v in pairs(self.pokerList_) do
        if v:isSelected() then
            transition.moveBy(v, {y = -SELECTED_HEIGHT, time = seconds})
        end
        v:setSelected(false)
    end
end

--得到每一张打出去的牌 在手牌中的位置
function PokerListView:getOutPokerPos(card)
    local x , y = 0, 0
    for j,poker in ipairs(self.pokerList_) do
        if card == poker:getCard() then
            if not isOutSelected_ then
                x, y = poker:getPokerPos()
            end
            break
        end
    end
    return x, y
end

--打出去的牌的动画 用手牌执行前一半移动动画
function PokerListView:outPokerAction(card, x, y, moveX_, moveY_, seconds)
    local posx_, posy_ = x, y-15
    local scaleFrom, scaleTo, rotation = 1, 0.7/1.2, 8
    local rotate = math.random(-rotation, rotation)
    local startX_ , startY_ = 0, 0
    local hostPoker_ = nil
    for j,poker in ipairs(self.pokerList_) do
        if card == poker:getCard() then
            if not poker.isOutSelected_ then
                transition.moveBy(poker, {y = -SELECTED_HEIGHT, time = 0})
                poker:setSelected(false)
                hostPoker_ = poker
                startX_ , startY_ = poker:getPokerPos()
                poker.isOutSelected_ = true
                break
            end
        end
    end
    if hostPoker_ then
        local sequence = transition.sequence({
             cc.Spawn:create(cc.MoveTo:create(seconds / 2, cc.p(posx_- moveX_ /2, posy_+ moveY_/ 2)),
                cc.ScaleTo:create(checknumber(seconds / 2), 1.4, 1.4)),
        })
        hostPoker_:scale(scaleFrom)
        hostPoker_:runAction(sequence)
    end
end

function PokerListView:removePokers(cards)
    for i,v in ipairs(cards) do
        for j,poker in ipairs(self.pokerList_) do
            if v == poker:getCard() then
                table.removebyvalue(self.pokerList_, poker)
                poker:removeFromParent()
                break
            end
        end
    end
end

--移除打出去的牌，延时0.1
function PokerListView:removeOutPokers(cards)
    for i,v in ipairs(cards) do
        for j,poker in ipairs(self.pokerList_) do
            if v == poker:getCard() then
                table.removebyvalue(self.pokerList_, poker)
                poker:removeFromParent()
                break
            end
        end
    end
    self:performWithDelay(function()
        self:upDateHanderPokerPos_(self:getCards_())
    end, 0.1)
end

function PokerListView:removePoker(card)
    for j,poker in ipairs(self.pokerList_) do
        if card == poker:getCard() then
            -- self:getOutPokerPos(v)
            table.removebyvalue(self.pokerList_, poker)
            poker:removeFromParent()
            break
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
    local diTotal = 0
    local pokerList = {}
    local actions = {}
    self.interval_ = 0
    if cards then
        for i,v in ipairs(cards) do
            local x, y, z = self:calcPokerPos_(#cards, i, 1)
            local poker = PokerView.new(v):addTo(self):pos(x, y)
            poker.posX_ = x
            poker.posY_ = y
            transition.moveTo(poker, {x = x, y = y, time = setup, easing = "exponentialOut"})
            poker:setScale(0.735)
            poker:fanPai()
            if self.needTipCard_ == v then
                poker:setBlack()
            end
            poker:setColor(cc.c3b(0, 0, 0))
            poker:zorder(z)
            self.pokerList_[#self.pokerList_+1] = poker
        end
    end
end

function PokerListView:setFriendCard(card)
    local team = 0
    for _,v in pairs(self.pokerList_) do
        if v:getCard() == card then
            v:showFriendFlag()
            team = 1
            break
        end
    end
end

function PokerListView:showHuCard()
    for _,v in pairs(self.pokerList_) do
        v:showHunCard()
    end
end

function PokerListView:tishiHuiSe(cards)
    do return end
    for _,v in pairs(self.pokerList_) do
        for i,k in ipairs(cards) do
            if v:getCard() == k then
                if v:isCanSelected() then
                    v:setCanSelected(false)
                end
                break
            end
        end
    end
end

function PokerListView:clearDesk()
    if self.yaobuqiSprite_ then
        self.yaobuqiSprite_:removeSelf()
    end
    self.yaobuqiSprite_ = nil
end

function PokerListView:initTishi(tishiCards)
    self.nowTishiCardsList = tishiCards
    self.nextTishiIndex = 1
end

function PokerListView:tishi()
    local nowTishiCards = self.nowTishiCardsList[self.nextTishiIndex]
    if nowTishiCards == nil then
        if self.nextTishiIndex == 1 then
            self:clearDesk()
            return
        end
        self.nextTishiIndex = 1
        self:resetPopUpPokers()
        return
    end

    self.nextTishiIndex = self.nextTishiIndex + 1
    self:setTipsCards(nowTishiCards)
end

function PokerListView:sort()
    local cards = self:getCards_()
    cards = D13Algorithm.getSortCards(cards, 1)
    self:upDateHanderPokerPos_(cards)
end

function PokerListView:faPaiRank_(cards)
    self:upDateHanderPokerPos_(cards)
end

function PokerListView:upDateHanderPokerPos_(cards,callFunc)
    self.interval_ = 0
    local timers = 0
    local setup = 0
    local diTotal = 0
    local pokerList = {}
    local actions = {}
    if cards then
        for i,v in ipairs(cards) do
            table.insert(actions, cc.CallFunc:create(function ()
                local x, y, z = self:calcPokerPos_(#cards, i, 1)
                local poker = self:getPokerByCard_(v)
                poker.posX_ = x
                poker.posY_ = y
                poker:setSelected(false)
                poker:setScale(0.735)
                transition.moveTo(poker, {x = x, y = y, time = setup, easing = "exponentialOut"})
                poker:fanPai()
                if self.needTipCard_ == v then
                    poker:setBlack()
                end
                poker:zorder(z)
                pokerList[#pokerList+1] = poker
            end))
        table.insert(actions, cc.DelayTime:create(setup))
        end
    end
    table.insert(actions, cc.CallFunc:create(function ()
        self.pokerList_ = pokerList
        self:resetPokerFlagStatus_()
        if callFunc then
            callFunc()
        end
    end))
    self:runAction(transition.sequence(actions))
end

function PokerListView:resetPokerFlagStatus_()
    for i,v in ipairs(self.pokerList_) do
        v:setPokerFlag(0)
    end
end

function PokerListView:removeAllPokers()
    for i,v in ipairs(self.pokerList_) do
        v:removeSelf()
    end
    self.pokerList_ = {}
end

return PokerListView
