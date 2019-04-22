local BaseLocalUserData = import(".BaseLocalUserData")
local CreateRoomLocalData = class("CreateRoomLocalData", BaseLocalUserData)
local GAME_INDEX = "XT_GAME_INDEX"
local GAME_VIEW_HISTORY = "GAME_VIEW_HISTORY"
local GAME_OPEN_LIST = "GAME_OPEN_LIST"

function CreateRoomLocalData:ctor()
    CreateRoomLocalData.super.ctor(self)
    if  self:getGameIndex() == "" then
        self:setGameIndex(GAME_PAODEKUAI)
    end
end

function CreateRoomLocalData:setGameIndex(num)
    self:setUserLocalData(GAME_INDEX, num)
end

function CreateRoomLocalData:getGameIndex()
    return self:getUserLocalData(GAME_INDEX)
end

function CreateRoomLocalData:setGameHistory(data)
    self:setUserLocalData(GAME_VIEW_HISTORY, data)
end

function CreateRoomLocalData:getGameHistory()
    return self:getUserLocalData(GAME_VIEW_HISTORY)
end

function CreateRoomLocalData:setOpenGameList(data)
    self:setUserLocalData(GAME_OPEN_LIST, json.encode(data))
end

function CreateRoomLocalData:getOpenGameList()
    local data = self:getUserLocalData(GAME_OPEN_LIST)
    if data == nil or data == "" then
        return nil
    end
    return json.decode(data)
end

return CreateRoomLocalData 
