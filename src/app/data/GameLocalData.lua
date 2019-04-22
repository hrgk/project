local BaseLocalUserData = import(".BaseLocalUserData")
local GameLocalData = class("GameLocalData", BaseLocalUserData)

local GAME_RECORD_ID = "GAME_RECORD_ID"

function GameLocalData:ctor()
    GameLocalData.super.ctor(self)
end

function GameLocalData:setGameRecordID(ID)
    -- printError(ID)
    self:setUserLocalData(GAME_RECORD_ID, ID or "")
end

function GameLocalData:getGameRecordID()
    local value = self:getUserLocalData(GAME_RECORD_ID)
    return value or ""
end

return GameLocalData
