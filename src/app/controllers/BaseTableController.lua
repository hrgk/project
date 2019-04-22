local BaseTableController = class("BaseTableController", nil)

function BaseTableController:ctor()
    
end

function BaseTableController:doBroadcast(data)
    if not data.data then
        return
    end
    local info = data.data
    if info.action == "chat" then
        self:doPlayerAction_(info)
    end
end

function BaseTableController:doOwnerDismiss(data)
    if data.code == 0 then
        app:enterHallScene()
        dataCenter:setRoomID(0)
    end
end

function BaseTableController:getHostPlayer()
    for i,v in ipairs(self.seats_) do
        if v:isHost() then
            return v
        end
    end
end

function BaseTableController:getPlayerBySeatID(seatID)
    return self.seats_[seatID]
end

function BaseTableController:doPlayerAction_(info)
    if info.messageType == 4 then
        local player = self:getPlayerBySeatID(info.seatID)
        player:playVoice(info)
    elseif info.messageType == 5 then
        local fromPlayer = self:getPlayerBySeatID(info.fromSeatID)
        local toPlayer = self:getPlayerBySeatID(info.toSeatID)
        if setData:getJZBQ() and toPlayer:getUid() == selfData:getUid() then
            return 
        end
        info.fromIndex = fromPlayer:getIndex()
        if toPlayer then
            info.toIndex = toPlayer:getIndex()
        else
            info.toIndex = 1
        end
        self.table_:facePlay(info)
    elseif info.messageType == 2 then
        local player = self:getPlayerBySeatID(info.seatID)
        player:quickYuYin(info)
    elseif info.messageType == 6 then
        local player = self:getPlayerBySeatID(info.seatID)
        player:quickBiaoQing(info)
    end
end

function BaseTableController:onPlayerReady(data)
    local player = self:getPlayerBySeatID(data.seatID)
    if not player then
        printError("onPlayerReady with empty player!")
        return
    end
    player:setIsReady(data.isPrepare)
end

function BaseTableController:doRoomInfo(data)
    self.table_:setData(data)
    if data.status == 2 or data.status==3 then
        self.table_:setGameStart(true)
    end
    self:doResumeRoomInfo_(data)
end

function BaseTableController:goldFly(winnerIndex, loses)
    self.table_:goldFly(winnerIndex, loses)
end

function BaseTableController:getTable()
    return self.table_
end

function BaseTableController:isMyTable()
    return self.table_:isMyTable(self.hostSeatID_)
end

return BaseTableController
