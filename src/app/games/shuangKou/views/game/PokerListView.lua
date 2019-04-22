local PokerListView = class("PokerListView", gailun.BaseView)
local BaseAlgorithm = require("app.games.shuangKou.utils.BaseAlgorithm")
local ShuangKouAlgorithm = import("app.games.shuangKou.utils.ShuangKouAlgorithm")
local PokerView = import("app.games.shuangKou.views.game.PokerView")
-- local PokerView = import("app.views.game.PokerView")

local POKER_WIDTH = 154
local SELECTED_HEIGHT = 25

function PokerListView:ctor()
    self.margin_ = 37 * display.width / DESIGN_WIDTH
    gailun.uihelper.setRawTouchHandler(self, handler(self, self.onTouchEnded_),
        handler(self, self.onTouchBegin_), handler(self, self.onTouchMoved_))
    self.tempCards_ = {}
    self.isInReView_ = false
    self.isChange_ = false
    self.pokerList_ = {}
    self.downCount_ = 0
    self.upCount_ = 0
    self.interval_ = 0 --牌间隔

    -- self:showWatchingCards()
end

function PokerListView:setWatchingCardsVisible(isShow)
    if self.friendMask_ == nil then
        local node = display.newSprite("res/images/shuangKou/game/pokerListGamingBg.png"):addTo(self):pos(0, 50)
        node:setLocalZOrder(100)

        local tag = display.newSprite():addTo(node):pos(160, 30)
        tag:setAnchorPoint(cc.p(0, 0.5))

        tag:setTexture("res/images/shuangKou/game/gaming4.png")

        local actions = {}
        for i = 4, 1, -1 do
            table.insert(actions, cc.CallFunc:create(function ()
                tag:setTexture("res/images/shuangKou/game/gaming" .. i .. ".png")
            end))
            table.insert(actions, cc.DelayTime:create(0.5))
        end
        node:runAction(cc.RepeatForever:create(cc.Sequence:create(actions)))

        self.friendMask_ = node
    end

    self.friendMask_:setVisible(isShow or false)
end

function PokerListView:setInReView(bool)
    self.isInReView_ = bool
end

function PokerListView:onTouchBegin_(event)
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
    self:setChuPaiBtnStatus()
end

function PokerListView:setChuPaiBtnStatus()
    local tableData = display:getRunningScene():getTable()
    local config = display:getRunningScene():getTable():getConfigData()
    local isBigger = ShuangKouAlgorithm.isBigger(self:getSelectedCard_(), tableData:getCurCards(),config) --被选起来的牌、打出来的牌
    print(isBigger)
    local runScene = display.getRunningScene()
    if runScene.__cname == "GameScene"  then
        runScene.tableController_:setChuPaiBtnStatus(isBigger)
    end
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
    local ceng = 2
    local index = 0
    local total = #nodes
    local tempTotal = 0
    if total > self.downCount_ then
        tempTotal = total - self.downCount_ + 1
        total = #nodes -self.downCount_
    elseif total <= self.downCount_ then
        tempTotal = 100
        ceng = 1
    end
    for i,v in ipairs(nodes) do
        index = index + 1
        if i == tempTotal then
            index = 1
            total = self.downCount_
            ceng = 1
        end
        local x1, x2  = self:calcPokerBorder_(v, total, index)
        local flag = self:inTouchRange_(x1, x2)
        local topY, downY= self:checkPokerY_(v, ceng, total == index)
        if v:isCanSelected() and flag and self.startTouchY_ > downY and self.startTouchY_ < topY then
            v:setHighLight(flag)
        end
    end
end

function PokerListView:checkPokerY_(poker, ceng, isPiGu)
    local topY = poker:getPositionY() + poker:getHeight() / 2
    local downY = poker:getPositionY() - poker:getHeight() / 2
    if ceng == 2 then
        downY = 85 + poker:getHeight() / 2 - 10
        if isPiGu and self.downCount_ < self.upCount_ then
            downY = 85
        end
    elseif ceng == 1 then
        topY = topY - 10
    end
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
    -- if #cards < 2 then
    --     self.selectedCards_ = pokers
    -- else
    --     if self.startTouchX_ < cards[2]:getPositionX() then
    --         poker = cards[1]:getCard()
    --         self.selectedCards_ = ShuangKouAlgorithm.getSameValue_(pokers, BaseAlgorithm.getValue(poker))
    --     elseif self.startTouchX_ > cards[#cards-1]:getPositionX() then
    --         poker = cards[#cards]:getCard()
    --         self.selectedCards_ = ShuangKouAlgorithm.getSameValue_(pokers, BaseAlgorithm.getValue(poker))
    --     end
    -- end
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
    self.pokerList_ = {}
    self.sortIndex_ = skData:getSort()
    local cards1 = {}
    local cards2 = {}
    cards1, cards2 = ShuangKouAlgorithm.rank(self.sortIndex_, cards)

    self.upCount_ = #cards1
    if cards2 then
        self.downCount_ = #cards2
    end
    self:showPokersWithoutAnim_(cards1, cards2, isAnima, callback)
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

function PokerListView:updatePink(pokerList)
    local cards = {}
    for _, poker in ipairs(pokerList) do
        poker:showPink(false)
        table.insert(cards, poker:getCard())
    end

    for k, card in ipairs(ShuangKouAlgorithm.getPinkCards(cards)) do
        for _,v in ipairs(self.pokerList_) do
            if v:getCard() == card then
                if v:isPink() == false then
                    v:showPink(true)
                    break
                end
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
    local fixOffset = -20
    local offset = 0
    local interval = 0 --间距
    -- print(self.margin_)
    if self.margin_ == 38 then--800
        interval = 2
    elseif self.margin_ >= 40 and self.margin_ <= 41 then--600
        interval = 2
    elseif self.margin_ >= 39 and self.margin_ <= 40 then--400
        interval = 2
    elseif self.margin_ >= 42 then--720
        interval = 3
    end

    interval = (self.margin_ + interval)

    local x = 0
    x = index * interval

    x = x - (total / 2) * interval + fixOffset

    local y = 168
    if ceng == 1 then
        y = 85
        index = 10 + index
    else
        offset = (1 - (14 - 1) / 2 - 1) * self.margin_
        x = (index - 1) * self.margin_ + offset + fixOffset + interval * self.interval_
    end
    self.interval_ = self.interval_ + 1
    return x, y, index
end

function PokerListView:showPokersWithoutAnim_(cards1,cards2, isAnima, callback)
    self:removeAllPokers()
    self.interval_ = 0--重制间隔
    local setup = 0.02
    if isAnima == false or self.isInReView_ == true then
        setup = 0
    end
    local timers = 0
    local actions = {}
    for i,v in ipairs(cards1) do
        table.insert(actions, cc.CallFunc:create(function ()
            local x, y, z = self:calcPokerPos_(#cards1, i, 2)
            local poker = PokerView.new(v):addTo(self):pos(x, y)
            poker.posX_ = x
            poker.posY_ = y
            poker:setScale(0.735)
            poker:fanPai()
            gameAudio.playSound("sounds/datongzi/click_poker.mp3")
            table.insert(self.pokerList_, poker)
            if i == #cards1 then--上层牌循环完重制间隔次数
                self.interval_ = 0
            end
        end))
        table.insert(actions, cc.DelayTime:create(setup))
    end
    for i,v in ipairs(cards2) do
        table.insert(actions, cc.CallFunc:create(function ()
            local x, y, z = self:calcPokerPos_(#cards2, i, 1)
            local poker = PokerView.new(v):addTo(self):pos(x, y)
            poker.posX_ = x
            poker.posY_ = y
            poker:setScale(0.735)
            poker:fanPai()
            gameAudio.playSound("sounds/datongzi/click_poker.mp3")
            table.insert(self.pokerList_, poker)
        end))
        table.insert(actions, cc.DelayTime:create(setup))
    end
    if isAnima then
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

    table.insert(actions, cc.CallFunc:create(function ()
        self:updatePink(self.pokerList_)
    end))
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
    self:setChuPaiBtnStatus()
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
    self:clearDesk()
    for i,v in ipairs(cards) do
        for j,poker in ipairs(self.pokerList_) do
            if v == poker:getCard() then
                table.removebyvalue(self.pokerList_, poker)
                poker:removeFromParent()
                break
            end
        end
    end
    local cards1, cards2 = ShuangKouAlgorithm.rank(self.sortIndex_, self:getCards_())
    if cards2 then
        self.downCount_ = #cards2
    end
    self.upCount_ = #cards1
    if self.isInReView_ then
        self:upDateReViewHanderPokerPos_(cards1, cards2)
    else
        self:updateHandPokerPos_(cards1,cards2)
    end
    if self.isInReView_ then
        self:show()
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
    local cards1, cards2 = ShuangKouAlgorithm.rank(self.sortIndex_, self:getCards_())
    if cards2 then
        self.downCount_ = #cards2
    end
    self.upCount_ = #cards1
    self:performWithDelay(function()
        self:updateHandPokerPos_(cards1,cards2)
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

    local cards1, cards2 = ShuangKouAlgorithm.rank(self.sortIndex_, self:getCards_())
    if cards2 then
        self.downCount_ = #cards2
    end
    self.upCount_ = #cards1
    if self.isInReView_ then
        self:upDateReViewHanderPokerPos_(cards1, cards2)
    else
        self:updateHandPokerPos_(cards1,cards2)
    end
    if self.isInReView_ then
        self:show()
    end
end

function PokerListView:upDateReViewHanderPokerPos_(cards1, cards2)
    self:removeAllPokers()
    local timers = 0
    local setup = 0
    local diTotal = 0
    if cards2 then
        diTotal = #cards2
    end
    local pokerList = {}
    local actions = {}
    self.interval_ = 0
    for i,v in ipairs(cards1) do
        local x, y, z = self:calcPokerPos_(#cards1, i, 2, diTotal)
        local poker = PokerView.new(v):addTo(self):pos(x, y)
        poker.posX_ = x
        poker.posY_ = y
        poker:setScale(0.735)
        transition.moveTo(poker, {x = x, y = y, time = setup, easing = "exponentialOut"})
        poker:fanPai()
        poker:zorder(z)
        -- self.pokerList_[index] = nil
        self.pokerList_[#self.pokerList_+1] = poker
        -- gameAudio.playSound("sounds/common/tipai.mp3")
        if i == #cards1 then--上层牌循环完重制间隔次数
            self.interval_ = 0
        end
    end
    if cards2 then
        for i,v in ipairs(cards2) do
            local x, y, z = self:calcPokerPos_(#cards2, i, 1)
            local poker = PokerView.new(v):addTo(self):pos(x, y)
            poker.posX_ = x
            poker.posY_ = y
            transition.moveTo(poker, {x = x, y = y, time = setup, easing = "exponentialOut"})
            poker:setScale(0.735)
            poker:fanPai()
            poker:zorder(z)
            self.pokerList_[#self.pokerList_+1] = poker
            -- gameAudio.playSound("sounds/common/tipai.mp3")
        end
    end
    self:updatePink(self.pokerList_)
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

function PokerListView:initTishi(clickType_)
    local tableData = display:getRunningScene():getController():getTable()
    local config = display:getRunningScene():getTable():getConfigData()
    local cards = self:getCards_()
    local curCards = tableData:getCurCards()
    local tishiCards = ShuangKouAlgorithm.tishi(curCards, cards,config)
    if not clickType_ then
        self:clearDesk()
        if #tishiCards == 0 and #curCards ~= 0 then
            print("================没有比对方大的牌")
            self.yaobuqiSprite_ = display.newSprite("res/images/shuangKou/game/pztsz.png"):addTo(self:getParent(),"11",1):pos(display.cx, 40)
        end
    end
    self.nowTishiCardsList = tishiCards
    self.nextTishiIndex = 1
end

function PokerListView:tishi()
    local nowTishiCards = self.nowTishiCardsList[self.nextTishiIndex]
    if nowTishiCards == nil then
        if self.nextTishiIndex == 1 then
            dataCenter:sendOverSocket(COMMANDS.SHUANGKOU_PLAYER_PASS)
            self:clearDesk()
            return
        end
        self.nextTishiIndex = 1
        self:tishi()
        return
    end

    self.nextTishiIndex = self.nextTishiIndex + 1
    self:setTipsCards(nowTishiCards)
end

function PokerListView:sort()
    local cards = self:getCards_()
    self.sortIndex_ = self.sortIndex_ + 1
    if self.sortIndex_ > 2 then
        self.sortIndex_ = 1
    end
    skData:setSort(self.sortIndex_)

    local cards1, cards2 = ShuangKouAlgorithm.rank(self.sortIndex_, cards)
    if cards2 then
        self.downCount_ = #cards2
    end
    self.upCount_ = #cards1
    self:updateHandPokerPos_(cards1,cards2)
end

function PokerListView:faPaiRank_(cards)
    local cards1, cards2 = ShuangKouAlgorithm.rank(self.sortIndex_, cards)
    if cards2 then
        self.downCount_ = #cards2
    end
    self.upCount_ = #cards1
    self:updateHandPokerPos_(cards1,cards2)
end

function PokerListView:updateHandPokerPos_(cards1, cards2)
    if self.updatePokerAction ~= nil then
        self:stopAction(self.updatePokerAction)
    end
    self.interval_ = 0
    local timers = 0
    local setup = 0
    local diTotal = 0
    if cards2 then
        diTotal = #cards2
    end
    local pokerList = {}
    local actions = {}
    for i,v in ipairs(cards1) do
        table.insert(actions, cc.CallFunc:create(function ()
            local x, y, z = self:calcPokerPos_(#cards1, i, 2, diTotal)
            local poker = self:getPokerByCard_(v)
            if tolua.isnull(poker) then
                return
            end
            poker.posX_ = x
            poker.posY_ = y
            poker:setSelected(false)
            poker:setScale(0.735)
            -- poker:pos(x,y)
            -- local poker = app:createView("app.views.game.PokerView", v):addTo(self):pos(x, y)
            transition.moveTo(poker, {x = x, y = y, time = setup, easing = "exponentialOut"})
            poker:fanPai()
            poker:zorder(z)
            -- self.pokerList_[index] = nil
            pokerList[#pokerList+1] = poker
            -- gameAudio.playSound("sounds/common/tipai.mp3")
            if i == #cards1 then--上层牌循环完重制间隔次数
                self.interval_ = 0
            end
        end))
        table.insert(actions, cc.DelayTime:create(setup))
    end
    if cards2 then
        for i,v in ipairs(cards2) do
            table.insert(actions, cc.CallFunc:create(function ()
                local x, y, z = self:calcPokerPos_(#cards2, i, 1)
                local poker = self:getPokerByCard_(v)
                poker.posX_ = x
                poker.posY_ = y
                poker:setSelected(false)
                poker:setScale(0.735)
            -- poker:pos(x,y)
                -- local poker = app:createView("app.views.game.PokerView", v):addTo(self):pos(x, y)
                transition.moveTo(poker, {x = x, y = y, time = setup, easing = "exponentialOut"})
                poker:fanPai()
                poker:zorder(z)
                -- self.pokerList_[index] = nil
                pokerList[#pokerList+1] = poker
                -- gameAudio.playSound("sounds/common/tipai.mp3")
            end))
        table.insert(actions, cc.DelayTime:create(setup))
        end
    end
    table.insert(actions, cc.CallFunc:create(function ()
        self.pokerList_ = pokerList
        self:resetPokerFlagStatus_()
        self:updatePink(self.pokerList_)
        self.updatePokerAction = nil
    end))
    self.updatePokerAction = transition.sequence(actions)
    self:runAction(self.updatePokerAction)
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
