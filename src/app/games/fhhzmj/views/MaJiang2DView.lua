local BaseAlgorithm = require("app.games.fhhzmj.utils.BaseAlgorithm")
local MaJiang2DView = class("MaJiang2DView", gailun.BaseView)

function MaJiang2DView:ctor(card, direction, isDown, isMax)
    local cardTypeFont = {"majiang2D","majiang2DHuang"}
    self.cardType = cardTypeFont[setData:getMJPAITYPE()+0]
    if card and not BaseAlgorithm.isCard(card) then
        card = 0
    end
    assert(card and (0 == card or BaseAlgorithm.isCard(card)), "card is illgle: " .. card)
    assert(direction and 1 <= direction and 4 >= direction)
    self.direction_ = direction
    self.isDown_ = isDown
    self.isMax_ = isMax or false
    self.isLaizi_ = true
    self:setMaJiang(card,isDown)
    self:create_()

    self:setTingTag(false)
end

function MaJiang2DView:setTingTag(isShow)
    if self.tingTag_ == nil then
        self.tingTag_ = display.newSprite("res/images/majiang/game/tingPaiTag.png"):addTo(self):pos(-26+3, 38)
    end
    self.tingTag_:setVisible(isShow and true or false)
end

function MaJiang2DView:setFixed(flag)
    self.isFixed_ = flag
    if self.isFixed_ then
        self:setTouchEnabled(false)
    end
    self:doFixed_()
end

function MaJiang2DView:doFixed_()
    local down = self.isDown_ and self.isDown_ or false
    if self.isFixed_ then
        if  self.fixedSprite_ then
            self:removeChild(self.fixedSprite_)
        end
        self.fixedSprite_ = display.newSprite('#res/images/majiang/majiang/mj_bird_mask.png'):addTo(self):pos(0, 0)
        self.fixedSprite1_ = display.newSprite("res/images/majiang/game/heiPaidi.png"):addTo(self):pos(0, 0)
        self.fixedSprite_:setVisible(not down)
        self.fixedSprite1_:setVisible(down)
        self.fixedSprite_:setScale(1.1)
    else
        if self.fixedSprite_ then
            self.fixedSprite_:setVisible(false)
        end
        if self.fixedSprite1_ then
            self.fixedSprite1_:setVisible(false)
        end
    end
end


function MaJiang2DView:setMaJiang(card, isDown)
    self.isDown_ = isDown
    self.card_ = card
    local suit = BaseAlgorithm.getSuit(card)
    local value = BaseAlgorithm.getValue(card)
    self:setSuitAndValue_(suit, value)
    return self:create_()
end

function MaJiang2DView:getMaJiang()
    return self.card_
end

function MaJiang2DView:getCard()
    return self.card_
end

function MaJiang2DView:isBeOut()
    return self.beOut_
end

function MaJiang2DView:setIsMoPai(flag)
    self.isMoPai_ = flag or false
end

function MaJiang2DView:isDown()
    return self.isDown_
end

function MaJiang2DView:isMoPai()
    return self.isMoPai_ or false
end

function MaJiang2DView:setBeOut(flag)
    self.beOut_ = flag
end

function MaJiang2DView:setSuitAndValue_(suit, value)
    self.suit_ = suit
    self.value_ = value
    return self
end

function MaJiang2DView:create_()
    self:removeAllChildren()
    if 0 == self.suit_ or 0 == self.value_ then
        return self:createBack_()
    end
    print("===========MaJiang2DView:create_============")
    print(self.isDown_, self.direction_)
    if not self.isDown_ and self.direction_ ~= MJ_TABLE_DIRECTION.BOTTOM then
        return self:createBack_()
    end
    return self:createFront_()
end

local directions = {'b', 'r', 't', 'l'}
function MaJiang2DView:getDirectionName_()
    return directions[self.direction_]
end

local suits = {'wan', 'suo', 'tong', 'feng', 'za'}
function MaJiang2DView:getSuitName_()
    return suits[self.suit_]
end

function MaJiang2DView:createFront_()
    local path = "res/images/majiang/%s/%s/%s_%s_%d.png"
    local col1 = self:getSuitName_()
    local col2 = 'mj'
    local col3 = self:getDirectionName_()
    if not self.isDown_ then
        col2 = "mjb"
        col3 = "b"
    end
    local value = self.value_
    if (not self.isLaizi_ ) and self.card_ == 51 then
        print("not lizi")
        value = 11
    end
    path = string.format(path, self.cardType,col1, col2, col3, value)
    
    self.spriteContent_ = display.newFilteredSprite(path):addTo(self)
    return self
end

function MaJiang2DView:createBack_()
    local path = "res/images/majiang/%s/mjbg%s_%s.png"
    local col1 = 'd' -- 倒着的牌
    local col2 = self:getDirectionName_()
    if not self.isDown_ then
        col1 = "s"  -- 竖着的牌
        -- assert(1 ~= self.direction_)
        if MJ_TABLE_DIRECTION.BOTTOM == self.direction_ then   -- 竖着的牌没有背面的
            col2 = directions[#directions]
        end
    end
    if self.isMax_ then
        col1 = "d"
        col2 = "big"
    end
    path = string.format(path, self.cardType,col1, col2)
    self.spriteContent_ = display.newFilteredSprite(path):addTo(self)
    return self
end

function MaJiang2DView:highLight()
    self.spriteContent_:setFilter(filter.newFilter("RGB", {1, 243/255, 135/255})) 
    return self
end

function MaJiang2DView:clearHighLight()
    if not self.spriteContent_ then
        return self
    end
    if tolua.isnull(self.spriteContent_) then
        return self
    end
    self.spriteContent_:clearFilter() 
    return self
end

function MaJiang2DView:turn(card, delay)
    local actions = transition.sequence({
        cc.DelayTime:create(0.1),
        -- cc.CallFunc:create(function ()
        --     -- self.spriteContent_:setSpriteFrame(display.newSpriteFrame("mjturn.png"))
        -- end),
        -- cc.DelayTime:create(0.1),
        cc.CallFunc:create(function ()
            self.isMax_ = false
            self:setMaJiang(card)
            self:maxLowLight()
        end),
    })
    self:runAction(actions)
end

function MaJiang2DView:maxLowLight()
    if self.spriteMaxLowLight_ then
        return
    end
    self.spriteMaxLowLight_ = display.newSprite("res/images/majiang/majiang2D/mj_bird_mask.png"):addTo(self, 1):setScale(1.15)
end

function MaJiang2DView:clearMaxLowLight()
    if self.spriteMaxLowLight_ then
        self.spriteMaxLowLight_:removeFromParent()
        self.spriteMaxLowLight_ = nil
    end
end

function MaJiang2DView:createBreathingAction_()
    local seconds = 1.2
    local a1 = cc.FadeTo:create(seconds, 20)
    local a1 = transition.newEasing(a1, "Out")
    local a2 = cc.FadeTo:create(seconds, 255)
    local a2 = transition.newEasing(a2, "In")
    return cc.RepeatForever:create(transition.sequence({a1, a2, cc.DelayTime:create(seconds / 2)})) --一直重复
end

function MaJiang2DView:focusOn()
    if self.isHighLight_ then
        return self
    end
    
    if self.isLowLight_ then
        self:setOpacity(255)
    end
    if not self.spriteLight_ then
        local s = self.spriteContent_:getContentSize()
        self.spriteLight_ = display.newScale9Sprite("res/images/majiang/majiang2D/mj_light.png", 0, 1, cc.size(s.width + 28, s.height + 28)):addTo(self, -1)
        self.spriteLight_:runAction(self:createBreathingAction_())
    end
    self.isHighLight_ = true
    self.isLowLight_ = false
    return self
end

function MaJiang2DView:slideBy(y)
    transition.moveBy(self, {y = y, time = 0.5, easing = 'Out'})
    return self
end

function MaJiang2DView:fallDown(y)
    transition.moveBy(self, {y = y, time = 0.5, easing = 'bounceOut'})
    return self
end

function MaJiang2DView:focusOff()
    if self.isLowLight_ then
        return self
    end
    if self.spriteLight_ then
        self.spriteLight_:removeFromParent()
        self.spriteLight_ = nil
    end
    self:setOpacity(190)
    self.isLowLight_ = true
    self.isHighLight_ = false
    return self
end

return MaJiang2DView
