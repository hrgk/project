local BaseView = import("app.views.BaseView")
local CuoPokerView = class("CuoPokerView", BaseView)
local CuoPoker = import(".CuoPoker")
function CuoPokerView:ctor(card, callfunc)
    self.card_ = card
    self.callfunc_ = callfunc
    self.poker_ = CuoPoker.new(card):addTo(self):rotation(90)
    :pos(display.cx,display.cy)
    self.maskPoker_ = display.newSprite("res/images/game/cuoCards/card_bg.png"):addTo(self)
    :rotation(90)
    :pos(display.cx,display.cy)
    -- self:tanChuang(100)
    self.oldY_ = self.maskPoker_:getPositionY()
    self.oldX_ = self.maskPoker_:getPositionX()
    self.maskPoker_:setTouchEnabled(true)
    self.maskPoker_:setTouchSwallowEnabled(false)
    self.maskPoker_:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self.onTouch_))
    self:addFaGuang()
end

function CuoPokerView:onTouch_(event)
    -- print("===event.x===event.x",event.x,event.y)
    local p = self:convertToNodeSpace(cc.p(event.x, event.y))
    if event.name == "began" then
        self:onTouchBegin_(p)
    elseif event.name == "moved" then
        self:onTouchMoved_(p)
    elseif event.name == "ended" then
        self:onTouchEnded_(p)
    end
    return true
end

function CuoPokerView:onTouchBegin_(p)
    self.startY_ = p.y
    self.startX_ = p.x
end

function CuoPokerView:onTouchMoved_(p)
    -- print(p.x,p.y)
    self.moveY_ = p.y
    self.moveX_ = p.x
    if self.moveY_ > self.startY_ then
        local distY = self.moveY_ - self.startY_
        self.maskPoker_:setPositionY(self.oldY_+distY)
    end
    if self.moveX_ > self.startX_ then
        local distX = self.moveX_ - self.startX_
        self.maskPoker_:setPositionX(self.oldX_+distX)
    end
end

function CuoPokerView:fanPai()
    self.poker_:showNumber()
    self.maskPoker_:hide()
        self:zhuanQuanAction(self.poker_,0.1)
        self:removeChild(self.emitterHand_)
        transition.scaleTo(self.poker_, {scale = 0.2, time = 0.8, onComplete = function()
            transition.stopTarget(self.poker_)
            self.poker_:rotation(0)
            self:performWithDelay(function()
                if self.callfunc_ then
                    self.callfunc_(self.card_)
                end
            end, 0.5)
        end})
end

function CuoPokerView:addFaGuang()
      self.emitterHand_  = cc.ParticleSun:createWithTotalParticles(2000)    --设置粒子数  
    -- local cache = cc.Director:getInstance():getTextureCache():addImage("res/images/faguangtexture.png")
    -- self.emitterHand_:setTexture(cache)
    self.emitterHand_:setAutoRemoveOnFinish(true)    --设置播放完毕之后自动释放内存  
    self.emitterHand_:setLife(0.2)
    self.emitterHand_:setLifeVar(3)
    self.emitterHand_:setPosVar(cc.p(400,300))
    self.emitterHand_:setStartSize(40)
    -- self.emitterHand_:setStartSizeVar(5)
    -- self.emitterHand_:setEndSize(1)
    self.emitterHand_:setSpeed(0)
    self.emitterHand_:setStartColor(cc.c4b(0.3,0.4,0.7,0))
    -- self.emitterHand_:setEndColor(cc.c4b(1,0,0,1))
    -- self.emitterHand_:setStartColorVar(cc.c4b(1,0,0,1))
    -- self.emitterHand_:setEndColorVar(cc.c4b(0.38,0,0,0))
    self.emitterHand_:setGravity(cc.p(0,0))
    -- self.emitterHand_:setEmitterMode(0)
    -- self.emitterHand_:setEmissionRate(2000)
    self.emitterHand_:setDuration(-1)
    self.emitterHand_:setBlendFunc(gl.ONE,gl.ONE)
 
    self.emitterHand_:setPosition(cc.p(display.cx, display.cy))  
    self:addChild(self.emitterHand_,-1)
end

function CuoPokerView:zhuanQuanAction(target, timer)
    local sequence = transition.sequence({
        cc.RotateTo:create(timer, 180),
        cc.RotateTo:create(timer, 360),
        })
    target:runAction(cc.RepeatForever:create(sequence))
end

function CuoPokerView:onTouchEnded_(p)
    if self.moveY_ > self.startY_ then
        local distY = self.moveY_ - self.startY_
        if distY > 250 then
            self:fanPai()
        end
    end
    if self.moveX_ > self.startX_ then
        local distX = self.moveX_ - self.startX_
        if distX > 250 then
            self:fanPai()
        end
    end
end

return CuoPokerView 
