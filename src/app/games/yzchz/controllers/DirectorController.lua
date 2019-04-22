local BaseController = import("app.controllers.BaseController")
local DirectorController = class("DirectorController", BaseController)

function DirectorController:ctor()
    self.view_ = app:createConcreteView("game.DirectorView"):addTo(self)
end

function DirectorController:onEnter()
	local handlers = {
        {self.view_.ON_TICK, handler(self, self.onTickEvent_)},
        {self.view_.TIMEOUT, handler(self, self.onTimeOutEvent_)},
    }
    gailun.EventUtils.create(self, self.view_, self, handlers)
end

function DirectorController:onExit()
    gailun.EventUtils.clear(self)
end

function DirectorController:onTickEvent_(event)
	local playNotice = false
	-- if event and checkint(event.leftSeconds) == 3 then
	-- 	-- 当轮到我或者公共牌时间且有选项可做时，才声音提醒自己
	-- 	if dataCenter:getHostPlayer():getIndex() == event.lightIndex then
	-- 		playNotice = true
	-- 	end
	-- 	if self:getParent():getParent():inShowActions() then
	-- 		playNotice = true
	-- 	end
	-- end

	if playNotice then
		gameAudio.playSound("sounds/common/sound_timeup_alarm.mp3")
		gailun.native.vibrate(400)
	end
end

function DirectorController:onTimeOutEvent_(event)
	self.view_:stop()
	self:hide()
end

function DirectorController:stop()
	self.view_:stop()
	self:hide()
end

function DirectorController:startTimeCount(seconds)
	self:show()
	self.view_:start(seconds)
end

return DirectorController
