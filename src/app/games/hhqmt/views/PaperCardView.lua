local PaperCardView = class("PaperCardView", gailun.BaseView)
local BaseAlgorithm = require("app.games.hhqmt.utils.BaseAlgorithm")

--默认翻牌时间
local DEFAULT_FLIP_SECONDS = 0.3

-- 原始的牌宽
local CARD_RAW_WIDTH = 84
local CARD_RAW_HEIGHT = 272
local FIXED_OPACITY = 0.2 * 255
local aCardPath = "res/images/hhqmt/a_cards/"
local bCardPath = "res/images/hhqmt/b_cards/"
local paths = {aCardPath, bCardPath}
function PaperCardView:ctor(card, cardSize, showBack, func)
	self.cardPath_ = paths[setData:getHHQMTCardType()]
	self.isHide = false
	self.card = card
	self.spriteContent_ = nil
	self.cardSize_ = cardSize
	self.flipSeconds_ = DEFAULT_FLIP_SECONDS
	self.isFixed_ = false
	self.aniNode_ = display.newNode():addTo(self)
	self.fixedSprite_ = nil
	self:initCard_(showBack)
	if func then
		self:setListener(func)
	end
end

-- 设置纸牌的值与外观
function PaperCardView:setCard(card)
	self:removeAllChildren()
	self.card = card
	self:initCard_(showBack)
	return self
end

function PaperCardView:getCard()
	return self.card
end

-- 设置纸牌的值与外观
function PaperCardView:showMark(isMo)
	local kuang = nil
	if isMo then
		local sep =  display.newSprite("res/images/game/mo.png"):pos(0, 0):addTo(self)
		kuang = display.newSprite("res/images/hhqmt/a_cards/mopai_bj.png"):pos(0, 0):addTo(self)
	else
		local sep =  display.newSprite("res/images/game/chu.png"):pos(0, 0):addTo(self)
		kuang = display.newSprite("res/images/hhqmt/a_cards/chupai_bj.png"):pos(0, 0):addTo(self)
	end
	self:scale(0.65)
end

function PaperCardView:showTingTag(isShow)
	local sep = self:getChildByName("tingTag")
	if not sep then 
		sep =  display.newSprite("res/images/game/tingTag.png"):pos(-24, 40):addTo(self)
		sep:setName("tingTag")
	end

	sep:setVisible(isShow == true and self.isFixed_ ~= true)
end

function PaperCardView:getSize()
	return self.spriteContent_:getContentSize()
end

function PaperCardView:setFixed(flag)
	self.isFixed_ = flag
	if self.isFixed_ then
		self:setTouchEnabled(false)
	end
	self:doFixed_()
end

function PaperCardView:setGroup(group)
	self.group_ = group
end

function PaperCardView:getGroup(group)
	return self.group_ or 0
end

function PaperCardView:doFixed_()
	if self.isFixed_ then
		if  self.fixedSprite_ then
			self:removeChild(self.fixedSprite_)
		end
		local paiMask = "dp_hd.png"
        if setData:getCDPHZCardLayout() == 1 then
            paiMask = "zp_hd.png"
        end
		self.fixedSprite_ = display.newSprite(self.cardPath_ ..paiMask):addTo(self):pos(0, 0)
		self.fixedSprite_:setName("fixedMask")
		self.fixedSprite_:setVisible(true)
		self.fixedSprite_:setOpacity(FIXED_OPACITY)
	else
		if self.fixedSprite_ then
			self.fixedSprite_:setVisible(false)
		end
	end

	-- self:showTingTag()
	local sep = self:getChildByName("tingTag")
	if sep then 
		sep:setVisible(false)
	end
end

-- 设置翻转时间
function PaperCardView:setFlipSeconds(seconds)
	self.flipSeconds_ = seconds
	return self
end

-- 设置翻牌效果
function PaperCardView:flip(card, index, pop)
	local isPop = pop or false
	self:setCard(card)
	local cardname = BaseAlgorithm.getCardName(self.card, self.cardSize_)
	if not cardname then
		return
	end
	self:fanPai()
	local s = display.newSprite(self.cardPath_ ..cardname)
	local _, rawy = self:getPosition()
	self:setVisible(true)
	transition.scaleTo(self.spriteContent_, {scaleX = -1, time = self.flipSeconds_})
	
	if isPop then -- 牌弹起效果
		transition.moveTo(self, {y = rawy + 16, time = self.flipSeconds_ / 2})
		self:performWithDelay(function ()
			transition.moveTo(self, {y = rawy, time = self.flipSeconds_ / 2})
		end, self.flipSeconds_ / 2)
	end

	self:performWithDelay(function ()
		self.spriteContent_:setFlippedX(true)
	end, self.flipSeconds_ / 2)

	self:performWithDelay(handler(self, self.doAfterFlip_), self.flipSeconds_ * 2)
	return self
end

function PaperCardView:addFaGuang()
	  self.emitterHand_  = cc.ParticleSun:createWithTotalParticles(2000)    --设置粒子数  
    -- local cache = cc.Director:getInstance():getTextureCache():addImage("res/images/faguangtexture.png")
    -- self.emitterHand_:setTexture(cache)
    self.emitterHand_:setAutoRemoveOnFinish(true)    --设置播放完毕之后自动释放内存  
    self.emitterHand_:setLife(0.2)
    self.emitterHand_:setLifeVar(3)
    self.emitterHand_:setPosVar(cc.p(62,170))
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
 
    local locX,locY = 2,2* display.width / DESIGN_WIDTH
    self.emitterHand_:setPosition(cc.p(locX, locY))  
    self.aniNode_:addChild(self.emitterHand_)
	return self
end

function PaperCardView:highLight()
	self.spriteContent_:setFilter(filter.newFilter("RGB", {1, 243/255, 135/255})) 
	return self
end

function PaperCardView:clearHighLight()
	if not self.spriteContent_ then
		return self
	end
	if tolua.isnull(self.spriteContent_) then
		return self
	end
	self.spriteContent_:clearFilter() 
	return self
end

function PaperCardView:reOrderChildren()
	if self.lightSprite then
		self.lightSprite:setZOrder(0)
	end
	self.spriteContent_:setZOrder(1)
	if self.chouSprite then
		self.chouSprite:setZOrder(2)
	end
end

function PaperCardView:setChou(flag)
	if self.chouSprite then
		self:removeChild(self.chouSprite)
		self.chouSprite = nil
	end
	if flag then
		self.chouSprite = display.newSprite(aCardPath .."cz.png"):addTo(self)
		self:reOrderChildren()
	end
end

function PaperCardView:doAfterFlip_()
	self:doFixed_()
end
 

function PaperCardView:callHandler(event, x, y)
	if self.func then
		self.func(self, event, x, y)
	end
end

function PaperCardView:inArea(x, y)
	local rect = self:getCascadeBoundingBox()
	if cc.rectContainsPoint(rect, cc.p(x, y)) then
        return true
    end
    return false
	-- local rotate = self:getParent():getRotation()
	-- return BaseAlgorithm.inRectWithAngle(CARD_RAW_WIDTH, CARD_RAW_HEIGHT, x, y, rect, rotate)
end

function PaperCardView:saveRawPosition()
	self.rawX, self.rawY = self:getPosition()
end

function PaperCardView:setListener(func)
	if self.isFixed_ then -- 固定的牌是不可以触摸的
		return self
	end
	self:saveRawPosition()
	self.func = func 
	self:setTouchEnabled(true)
	self:setTouchSwallowEnabled(false) -- 是否吞噬事件，默认值为 true
	self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
		local x = event.x
		local y = event.y
		local touchInSprite = self:inArea(x, y)
		if event.name == "began" then 
			if not touchInSprite then 
					return false
			end 
			self.x, self.y = self:getPosition()
			self.mx, self.my = x, y
			self:callHandler(event, x, y)
			self:setTouchSwallowEnabled(true) 
			return true
		elseif event.name == "moved" then 
			 self:onTouchMoved(event, x, y)
			 self:callHandler(event, x, y)
		elseif event.name == "ended" then
			self:setTouchSwallowEnabled(false) 
			self:onTouchEnd()
			self:callHandler(event, x, y)
		end
	end)
	return self
end

function PaperCardView:onTouchMoved(event, x, y)
	--self:setPosition(self.x + x - self.mx, self.y + y - self.my)
end

function PaperCardView:onTouchEnd()
	local currX, currY = self:getPosition()
	-- if currY - self.y > 160 then
	--	 -- if self.func then self.func(self) end
	--	 return
	-- end

	--self:setPosition(self.x, self.y)
end

function PaperCardView:initCard_(showBack) 
	local cardname = BaseAlgorithm.getCardName(self.card, self.cardSize_)
	self.spriteContent_ = display.newFilteredSprite(self.cardPath_ ..cardname):addTo(self)
	self.spriteContent_:setVisible(false)
	local bgname = BaseAlgorithm.getCardName(0, self.cardSize_)
	self.bg_ = display.newSprite(self.cardPath_ .. bgname)
	self:addChild(self.bg_) 
	if not showBack then
		self:fanPai()
	end 
end

function PaperCardView:fanPai()
	self.spriteContent_:setVisible(true)
	self.bg_:setVisible(false)
	self:opacity(255)
end

function PaperCardView:gaiPai()
	self.spriteContent_:setVisible(false)
	self.bg_:setVisible(true)
end

return PaperCardView 
