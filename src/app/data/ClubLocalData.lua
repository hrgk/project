local BaseLocalUserData = import(".BaseLocalUserData")
local ClubLocalData = class("ClubLocalData", BaseLocalUserData)

local ChaGuanData = import("app.data.ChaGuanData")

local CLUB_CREATE_TYPE = "CLUB_CREATE_TYPE"
local CLUB_TOP_TAG = "CLUB_TOP_TAG"
local CLUB_LEFT_INDEX = "CLUB_LEFT_INDEX"
local CLUB_MODEL = "CLUB_MODEL"

function ClubLocalData:ctor()
    ClubLocalData.super.ctor(self)
end

function ClubLocalData:setCreateType(num)
    if num == 2 then
        num = 1
    end
    self:setUserLocalData(CLUB_CREATE_TYPE, num)
end

function ClubLocalData:getCreateType()
    local value = self:getUserLocalData(CLUB_CREATE_TYPE)
    if not value or value and value == "" then
        value = 1
    end
    return value + 0
end

function ClubLocalData:setClubTopTag(data)
    self:setUserLocalData(CLUB_TOP_TAG, data)
end

function ClubLocalData:getClubTopTag()
    return tonumber(self:getUserLocalData(CLUB_TOP_TAG) or 0) or 0
end

function ClubLocalData:setClubLeftIndex(data)
    self:setUserLocalData(CLUB_LEFT_INDEX .. self:getClubTopTag() .. ChaGuanData.getClubInfo().clubID, data)
end

function ClubLocalData:getClubLeftIndex()
    return tonumber(self:getUserLocalData(CLUB_LEFT_INDEX .. self:getClubTopTag() .. ChaGuanData.getClubInfo().clubID) or 1) or 1
end

function ClubLocalData:setClubModel(data)
    self:setUserLocalData(CLUB_MODEL .. ChaGuanData.getClubInfo().clubID, data)
end

function ClubLocalData:getClubModel()
    return tonumber(self:getUserLocalData(CLUB_MODEL .. ChaGuanData.getClubInfo().clubID) or 1) or 1
end

return ClubLocalData 
