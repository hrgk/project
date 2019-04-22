local BaseLocalUserData = import(".BaseLocalUserData")
local GameCommondData = class("GameCommondData ", BaseLocalUserData)
local JULEBU_ID = "XT_JULEBU_ID"
local JULEBU_FLOOR = "XT_JULEBU_FLOOR"
local ROOM_TYPE_INFO = "ROOM_TYPE_INFO"

function GameCommondData:ctor()
    GameCommondData.super.ctor(self)
end

function GameCommondData:setClubID(num)
    self:setUserLocalData(JULEBU_ID, num)
end

function GameCommondData:getClubID()
    return self:getUserLocalData(JULEBU_ID)
end

function GameCommondData:setClubFloor(num)
    local clubID = self:getClubID()
    self:setUserLocalData(JULEBU_FLOOR .. clubID, num)
end

function GameCommondData:getClubFloor()
    local clubID = self:getClubID()
    return self:getUserLocalData(JULEBU_FLOOR .. clubID)
end

function GameCommondData:getRoomTimeConfig()
    return self:getUserLocalData(ROOM_TYPE_INFO)
end

function GameCommondData:getRoomTimeConfig(info)
    return self:setUserLocalData(ROOM_TYPE_INFO, info)
end

return GameCommondData  
