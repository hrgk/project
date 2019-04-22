local DirectorController = class("DirectorController",  function()
    local node = display.newNode()
    node:setNodeEventEnabled(true)
    return node
end)

function DirectorController:ctor()
    --DirectorView Director2DView
    if setData:getMJHMTYPE()+0  == 1 then
        self.view_ = app:createConcreteView("game.Director2DView"):addTo(self)
    else
        self.view_ = app:createConcreteView("game.DirectorView"):addTo(self)
    end
end

function DirectorController:onEnter()
    -- local player = dataCenter:getHostPlayer()
    -- local handlers = {
    --     {player.SIT_DOWN_EVENT, handler(self, self.onPlayerSitDown_)},
    -- }
    -- gailun.EventUtils.create(self, player, self, handlers)

    -- local handlers = {
    --     {self.view_.ON_TICK, handler(self, self.onTickEvent_)},
    -- }
    -- gailun.EventUtils.create(self, self.view_, self, handlers)
end

function DirectorController:onExit()
    gailun.EventUtils.clear(self)
end

function DirectorController:onTickEvent_(event)
    local playNotice = false
    if event and checkint(event.leftSeconds) == 5 then
        -- 当轮到我或者公共牌时间且有选项可做时，才声音提醒自己
        if dataCenter:getHostPlayer():getSeatID() == event.lightIndex then
            playNotice = true
        end
        if self:getParent():getParent():getParent():inShowActions() then
            playNotice = true
        end
    elseif event and checkint(event.leftSeconds) > 5  then
        -- self:stopEffect()
    end

    if playNotice then
        self.timeUpHandle_ = gameAudio.playSound("sounds/common/sound_timeup_alarm.mp3")
        gailun.native.vibrate(400)
        -- dump(self.timeUpHandle_, "onTickEvent_")
    end
end

function DirectorController:onPlayerSitDown_(event)
    self.view_:turnDirection(event.seatID)
end

function DirectorController:startTimeCount(direction, seconds, playerCount)
    self.view_:start(direction, seconds, playerCount)
end

function DirectorController:stopEffect()
    if self.timeUpHandle_ then
        gameAudio.stopEffect(self.timeUpHandle_)
        self.timeUpHandle_ = nil
    end
end

return DirectorController
