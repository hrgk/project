local BaseController = import(".BaseController")
local ReviewPlayController = class("ReviewPlayController", BaseController)

local FAST_BACK_STEPS = 7
local FAST_FORWARD_STEPS = 8
local TOTAL_SETUP  = 5 

function ReviewPlayController:ctor(data, hostPlayer)
    self.view_ = app:createConcreteView("review.PlayControllerView"):addTo(self)
    self.selfID_ = dataCenter:getHostPlayer():getUid()
    self.hostPlayer_ = hostPlayer
    self.gameData_ = data
    self.commandIndex_ = 1
    self.inPlaying_ = false
    self.view_:showPlay(self.inPlaying_)
    self.deleCommondList_ = {
        COMMANDS.PDK_PLAYER_ENTER_ROOM,
        COMMANDS.PDK_ROUND_FLOW,
        COMMANDS.PDK_DEAL_CARD,
        COMMANDS.PDK_ROUND_OVER,
        COMMANDS.PDK_REQUEST_DISMISS,
        COMMANDS.PDK_ROUND_FLOW,
    }
end

function ReviewPlayController:filterCmd_()
    self.playerList_ = {}
    self.gameConmandList_ ={}
    for i,k in ipairs(self.deleCommondList_) do
        for i,v in ipairs(self.gameData_) do
            if v.cmd == COMMANDS.PDK_PLAYER_ENTER_ROOM then
                self.playerList_[v.msg.seatID] = v
                table.removebyvalue(self.gameData_, v)
            elseif v.cmd == COMMANDS.PDK_DEAL_CARD then
                table.removebyvalue(self.gameData_, v)
            elseif v.cmd == COMMANDS.PDK_REQUEST_DISMISS then
                table.removebyvalue(self.gameData_, v)
            elseif v.cmd == COMMANDS.PDK_ROUND_FLOW then
                table.removebyvalue(self.gameData_, v)
            elseif v.cmd == COMMANDS.PDK_ROOM_INFO then
                table.removebyvalue(self.gameData_, v)
                table.insert(self.gameConmandList_, v)
            end
        end
    end
    self:playersSitdown_()
end

function ReviewPlayController:playersSitdown_()
    local actions = {}
    for i,v in ipairs(self.playerList_) do
        -- table.insert(actions, cc.CallFunc:create(function ()
            self:dispatchCommand(clone(v))
        -- end))
        -- table.insert(actions, cc.DelayTime:create(0.1))
    end
    -- table.insert(actions, cc.CallFunc:create(function ()
        for i,v in ipairs(self.gameConmandList_) do
            self:dispatchCommand(clone(v))
        end
    -- end))
    -- self:runAction(transition.sequence(actions))
end

function ReviewPlayController:setHostPlayer_(list)
    for i,v in ipairs(list) do
        if v.msg.uid == self.selfID_ then
            self.hostPlayer_:setUid(v.msg.uid)
            self.hostPlayer_:setSeatID(v.msg.seatID)
            return
        end
    end
    for i,v in ipairs(list) do
        if v.msg.seatID == 1 then
            self.hostPlayer_:setUid(v.msg.uid)
            self.hostPlayer_:setSeatID(v.msg.seatID)
            return
        end
    end
end

function ReviewPlayController:onEnter()
    gailun.EventUtils.clear(self)
    local handlers = {
        {self.view_.FAST_BACK_EVENT, handler(self, self.onFastBackEvent_)},
        {self.view_.FAST_FORWARD_EVENT, handler(self, self.onFastForwardEvent_)},
        {self.view_.PAUSE_EVENT, handler(self, self.onPauseEvent_)},
        {self.view_.PLAY_EVENT, handler(self, self.onPlayEvent_)},
        {self.view_.RETURN_EVENT, handler(self, self.onReturnEvent_)},
    }
    gailun.EventUtils.create(self, self.view_, self, handlers)

    self:setInPlaying(true)
    -- self:calcTotalSteps_()
    self:filterCmd_()
    self.totalSteps_ = #self.gameData_
    FAST_BACK_STEPS = math.ceil(self.totalSteps_ / TOTAL_SETUP)
    self.currStep_ = 0
    self:setCurrStep_(self.currStep_)
    self:schedule(handler(self, self.onPlaySetup_), 1.5)
end

function ReviewPlayController:onExit()
    gailun.EventUtils.clear(self)
end

function ReviewPlayController:isGameStep_(command)
    if not command then
        return false
    end
    return table.indexof(step_commands, command.cmd) ~= false
end

function ReviewPlayController:calcTotalSteps_()
    local steps = 0
    for i,v in ipairs(self.gameData_) do
        if self:isGameStep_(v) then
            steps = steps + 1
        end
    end
end

function ReviewPlayController:onPlaySetup_()
    if not self.inPlaying_ then
        return
    end
    local command = self.gameData_[self.commandIndex_]
    if command then
        self:dispatchCommand(clone(command))
        self.commandIndex_ = self.commandIndex_ + 1
        self:incrCurrStep_()
    end
end

function ReviewPlayController:resetRoundStartIndex_()
    self.roundStartIndex_ = nil
end

function ReviewPlayController:dispatchCommand(command, dennyAnim)
    command.msg.isReview = true
    dataCenter:dispatchCommand(command)
end

function ReviewPlayController:incrCurrStep_()
    self:setCurrStep_(self.currStep_ + 1)
end

function ReviewPlayController:setCurrStep_(index)
    local index = math.min(self.totalSteps_, index)
    index = math.max(1, index)
    self.currStep_ = index
    self.view_:setProgress(self.totalSteps_, self.currStep_)
end

function ReviewPlayController:setInPlaying(flag)
    self.inPlaying_ = flag
    self.view_:showPlay(self.inPlaying_)
end

function ReviewPlayController:calcCommandIndexByStep_()
    local step = 0
    for i,v in ipairs(self.gameData_) do
        if step >= self.currStep_ then
            return i
        end
        if self:isGameStep_(v) then
            step = step + 1
        end
    end
    return #self.gameData_
end

function ReviewPlayController:updatePlayProgress_()
    self.commandIndex_ = self.currStep_
    local commandList = {}
    for i = 1, self.commandIndex_ - 1 do
        local command = clone(self.gameData_[i])
        if command then
            command.msg.inFastMode = true
            -- self:dispatchCommand(command) 
            commandList[#commandList+1] = command
        end
    end
    local outCards = {}
    for i,v in ipairs(commandList) do
        if v.cmd == COMMANDS.CHU_PAI then
            local key = tostring(v.msg.seatID)
            if outCards[key] == nil then
                outCards[key] = {}
            end
            print(v.msg.seatID)
            outCards[key][#outCards[key]+1] = v.msg.cards
        end
    end
    self:removePlayerHandCards_(outCards)
    self:setInPlaying(true)
end

function ReviewPlayController:removePlayerHandCards_(outCards)
    local list = {}
    for i,v in ipairs(self.playerList_) do
        if outCards[tostring(i)] == nil then
            list[#list+1] = v
        end
    end
    for i,v in pairs(outCards) do
        local player = self:removeCards_(v, tonumber(i))
        self:dispatchCommand(player) 
    end
    for i,v in ipairs(list) do
        self:dispatchCommand(v) 
    end
    for i,v in ipairs(self.gameConmandList_) do
        self:dispatchCommand(clone(v))
    end
end

function ReviewPlayController:removeCards_(cards, seatID)
    local pokers = self:concatPokerTable_(cards)
    local player = self:getPlayerBySeatID_(seatID)
    for _,v in ipairs(pokers) do
        for _,card in ipairs(player.msg.shouPai) do
            if v == card then
                table.removebyvalue(player.msg.shouPai, card)
            end
        end
    end
    return player
end

function ReviewPlayController:concatPokerTable_(cards)
    local list = {}
    for i,v in ipairs(cards) do
        table.insertto(list, v)
    end
    return list
end

function ReviewPlayController:getPlayerBySeatID_(seatID)
    for i,v in ipairs(self.playerList_) do
        if v.msg.seatID == seatID then
            return clone(v)
        end
    end
end

function ReviewPlayController:onFastBackEvent_(event)
    if self.currStep_ <= 1 then 
        self.currStep_ = 1
        return
    end
    self:getParent():resetPlayer()
    self:resetRoundStartIndex_()
    -- self:playersSitdown_()
    self:setCurrStep_(self.currStep_ - FAST_BACK_STEPS)
    self:updatePlayProgress_()
end

function ReviewPlayController:onFastForwardEvent_(event)
    if self.currStep_ >= self.totalSteps_ then 
        self.currStep_ = self.totalSteps_
        return
    end
    self:getParent():resetPlayer()
    self:resetRoundStartIndex_()
    -- self:playersSitdown_()
    self:setCurrStep_(self.currStep_ + FAST_BACK_STEPS)
    self:updatePlayProgress_()
end

function ReviewPlayController:onPauseEvent_(event)
    self:setInPlaying(false)
end

function ReviewPlayController:onPlayEvent_(event)
    self:setInPlaying(true)
end

function ReviewPlayController:onReturnEvent_(event)
    local table = dataCenter:getPokerTable()
    table:doRoundOver()
    self.hostPlayer_:gameOver()
    dataCenter:getHostPlayer():gameOver()
    dataCenter:setRoomID(0)
    transition.stopTarget(self)
    self:getParent():removeFromParent()
end

return ReviewPlayController
