local ActionAnim = class("ActionAnim", gailun.BaseView)

function ActionAnim:ctor(spriteName,params)
	self.params_ = params;
	self:create_(spriteName)
end

function ActionAnim:run()
	if self.params_ then
		self:playMoveAnim_()
	else
		self:playAnim_(0.4)
	end
end

function ActionAnim:create_(frontImage)
	self.sprite_ = display.newSprite(frontImage):addTo(self)
end

function ActionAnim:playAnim_(seconds)
	local scaleSeconds = seconds or 0.4
	self:setOpacity(0)
	transition.fadeIn(self, {time = scaleSeconds, easing = "exponentialOut"})
	local moshuiAction = transition.sequence({
		cc.DelayTime:create(scaleSeconds * 6),
		cc.CallFunc:create(function ()
			transition.fadeOut(self, {time = scaleSeconds / 2, easing = "exponentialOut"})
		end),
		cc.DelayTime:create(scaleSeconds / 2),
		cc.CallFunc:create(function ()
			self:removeFromParent()
		end)
	})
	self:runAction(moshuiAction)
end

function ActionAnim:playMoveAnim_(seconds)
	local scaleSeconds = seconds or 0.4
	self:setOpacity(0)
	local moveAction = cc.MoveTo:create(0.2, cc.p(self.params_.toX, self.params_.toY))
	local scaleAction = cc.ScaleTo:create(0.2, 0.1)
	transition.fadeIn(self, {time = scaleSeconds, easing = "exponentialOut"})
	local moshuiAction = transition.sequence({
		cc.DelayTime:create(scaleSeconds * 3),
		cc.Sequence:create(moveAction,scaleAction),
		cc.CallFunc:create(function ()
			transition.fadeOut(self, {time = scaleSeconds / 2, easing = "exponentialOut"})
			if self.params_.onComplete then
				self.params_.onComplete();
			end
		end),
		cc.DelayTime:create(scaleSeconds / 2),
		cc.CallFunc:create(function ()
			self:removeFromParent()
			
		end)
	})
	self:runAction(moshuiAction)	
end

return ActionAnim
