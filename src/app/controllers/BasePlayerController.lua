local BasePlayerController = class("BasePlayerController", nil)

function BasePlayerController:ctor()
    
end

function BasePlayerController:setDouzi(...)
    if not self.player_ then
        return
    end
    return self.player_:setDouzi(...)
end

function BasePlayerController:showDouZi(...)
    if not self.player_ then
        return
    end
    return self.player_:showDouZi(...)
end

function BasePlayerController:setOffline(...)
    if not self.player_ then
        return
    end
    return self.player_:setOffline(...)
end

function BasePlayerController:setAnlyScore(...)
    if not self.player_ then
        return
    end
    return self.player_:setAnlyScore(...)
end

function BasePlayerController:playRecordVoice(...)
    if not self.player_ then
        return
    end
    return self.player_:playRecordVoice(...)
end

function BasePlayerController:stopRecordVoice(...)
    if not self.player_ then
        return
    end
    return self.player_:stopRecordVoice(...)
end

function BasePlayerController:playVoice(...)
    if not self.player_ then
        return
    end
    return self.player_:playVoice(...)
end

function BasePlayerController:quickYuYin(...)
    if not self.player_ then
        return
    end
    return self.player_:quickYuYin(...)
end

function BasePlayerController:quickBiaoQing(...)
    if not self.player_ then
        return
    end
    return self.player_:quickBiaoQing(...)
end

function BasePlayerController:levelRoom(...)
    if not self.player_ then
        return
    end
    return self.player_:levelRoom(...)
end

function BasePlayerController:setCards(...)
    if not self.player_ then
        return
    end
    return self.player_:setCards(...)
end

function BasePlayerController:getCards()
    if not self.player_ then
        return
    end
    return self.player_:getCards()
end

function BasePlayerController:setRoomInfo(...)
    if not self.player_ then
        return
    end
    return self.player_:setRoomInfo(...)
end

return BasePlayerController  
