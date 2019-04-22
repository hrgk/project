local ChaGuanData = {}

local roomList_ = {}
local chaGuanList = {}
local config_ = {}
local clubInfo_ = {}
local clubList_ = {}
local gameConfig = {}
local memberList = {}
local floorGameInfo_ = {}
local gameType = {}
local allGameType = {}
local isShowRedPoint_ = false

local nowFloorInfo = nil
local matchType = nil
local nowModel = 1
local floorListConfig = {}
local currFloor = 0
local currSubFloor = 0
local floorIndex = 0
local allSubGameConfig = {}

function ChaGuanData.setDaTingFloor(floor)
    currFloor = floor
end

function ChaGuanData.getDaTingFloor()
    return currFloor
end

function ChaGuanData.setDaTingsubFloor(subFloor)
    currSubFloor = subFloor
end

function ChaGuanData.getDaTingsubFloor()
    return currSubFloor
end

function ChaGuanData.setFloorIndex(index)
    floorIndex = index
end

function ChaGuanData.getFloorIndex()
    return floorIndex
end

function ChaGuanData.setAllSubGameConfig(config)
    local result = {}
    for k,v in pairs(config) do
        local gameConfig = json.decode(v.play_config)
        v.play_config = gameConfig
        local gameType = gameConfig.gameType
        result[gameType] = result[gameType] or {}

        table.insert(result[gameType], v)
    end

    allSubGameConfig = result
end

function ChaGuanData.getFloorIndexByGameType(gameType, id)
    if allSubGameConfig[gameType] == nil then
        return 1
    end

    for k, v in pairs(allSubGameConfig[gameType]) do
        if id == v.id then
            return k
        end
    end

    return 1
end

function ChaGuanData.requestRoomList()
    if nowModel ~= 0 then
        return
    end

    if nowFloorInfo == nil then
        return
    end

    local params = {}
    params.clubID = clubInfo_.clubID
    params.floor = nowFloorInfo.id
    httpMessage.requestClubHttp(params, httpMessage.GET_CLUB_ROOMS)
end

function ChaGuanData.requestAllRoomList()
    if nowModel ~= 1 then
        return
    end

    local params = {}
    params.clubID = clubInfo_.clubID
    params.matchType = matchType or 0
    httpMessage.requestClubHttp(params, httpMessage.GET_CLUB_ALL_ROOMS)
end

function ChaGuanData.setSwitchModel(model)
    nowModel = model
    clubData:setClubModel(model)
end

function ChaGuanData.getSwitchModel()
    return nowModel
end

function ChaGuanData.requestAllSubFloor()
    if nowModel ~= 1 then
        return
    end
    local params = {}
    params.clubID = clubInfo_.clubID
    params.matchType = matchType
    httpMessage.requestClubHttp(params, httpMessage.GET_CLUB_ALL_SUB_FLOOR)
end

function ChaGuanData.requestGetSubFloor()
    if nowModel ~= 0 then
        return
    end

    if nowFloorInfo == nil then
        return
    end

    httpMessage.requestClubHttp({
        floor = nowFloorInfo.id,
    }, httpMessage.GET_SUB_FLOOR)
end

function ChaGuanData.requestGetSubFloor2(subFloor,clubId,floor)
    if nowModel ~= 0 then
        return
    end

    if nowFloorInfo == nil then
        return
    end

    local params = {}
    params.clubID = clubId
    params.subFloor = subFloor
    if params.clubID and params.subFloor then
        httpMessage.requestClubHttp(params, httpMessage.GET_SUB_FLOOR2)
    end
end

function ChaGuanData.setFloorGameConfig(floorId, configList)
    floorListConfig[floorId] = configList
end

function ChaGuanData.getFloorGameConfigBySubFloor(subFloor)
    for key, value in pairs(floorListConfig) do
        for k, v in pairs(value) do
            if v.id == subFloor then
                return json.decode(v.play_config)
            end
        end
    end
end

function ChaGuanData.isOpenChampion()
    return clubInfo_.allowMatch == 1
end

function ChaGuanData.getFloorGameConfig(floorId)
    return floorListConfig[floorId]
end

function ChaGuanData.setNowFloorInfo(data)
    nowFloorInfo = data
end

function ChaGuanData.getNowFloorInfo()
    return nowFloorInfo
end

function ChaGuanData.setMatchType(data)
    matchType = data
end

function ChaGuanData.getMatchType()
    return matchType
end

-- owestScore 最低游戏豆数
-- overScore 超过积分
-- reduceScore 超过积分时，扣除积分
-- exp 经验值
-- dou 用户豆数量

function ChaGuanData.getAllGameType()
    return allGameType
end

function ChaGuanData.setAllGameType(gameTypeInfo)
    allGameType = gameTypeInfo
end

function ChaGuanData.getGameType()
    return gameType
end

function ChaGuanData.setGameType(gameTypeInfo)
    gameType = gameTypeInfo
end

function ChaGuanData.setRedPoint(bool)
    isShowRedPoint_ = bool
end

function ChaGuanData.getRedPoint()
    return isShowRedPoint_
end

function ChaGuanData.setClubFloor(matchType, floorList)
    floorGameInfo_[matchType] = floorList
end

function ChaGuanData.getClubFloor(matchType)
    return floorGameInfo_[matchType]
end

function ChaGuanData.isMyClub()
    if #clubList_ == 0 then
        if  clubInfo_.isOwner == 1 then
            return true
        end
    end
    for i,v in ipairs(clubList_) do
        if v.clubID == clubInfo_.clubID and v.uid == selfData:getUid() then
            return true
        end
    end
    return false
end

function ChaGuanData.myClubCount()
    local count = 0
    local playerID = selfData:getUid()
    for i,v in ipairs(clubList_) do
        if v.uid == playerID then
            count = count + 1
        end
    end
    return count
end

function ChaGuanData.setClubList(clubList)
    clubList_ = clubList
end

function ChaGuanData.getClubList()
    return clubList_
end

function ChaGuanData.getClubCount()
    return #clubList_
end

function ChaGuanData.clearRoomList()
    roomList_ = {}
end

function ChaGuanData.setRoomList(roomList)
    roomList_ = {}
    for _, v in ipairs(roomList) do
        roomList_[v.tid] = v
    end
end

function ChaGuanData.getRoomInfoByTid(tid)
    return roomList_[tid]
end

function ChaGuanData.getRoomInfoBySubFloor(subFloor)
    local result = {}
    for _, v in pairs(roomList_) do
        if v.subFloor == subFloor then
            table.insert(result,v)
        end
    end
    return result
end

function ChaGuanData.getRoomInfoByGameType(gameType,matchType)
    local result = {}
    for _, v in pairs(roomList_) do
        if v.gameType == gameType and v.matchType == matchType then
            table.insert(result,v)
        end
    end
    return result
end

function ChaGuanData.updateRoomList(roomInfo)
    if roomInfo == nil or roomList_[roomInfo.tid] == nil then
        return
    end
    roomList_[roomInfo.tid].players = roomInfo.players
    roomList_[roomInfo.tid].roundIndex = roomInfo.roundIndex
    roomList_[roomInfo.tid].playerCount = roomInfo.playerCount
    roomList_[roomInfo.tid].status = roomInfo.status
    roomList_[roomInfo.tid].totalRound = roomInfo.totalRound
end

function ChaGuanData.getRoomList()
    return table.values(roomList_)
end

function ChaGuanData.getRoomCount()
    return #ChaGuanData.getRoomList()
end

function ChaGuanData.getClubOwnerID()
    return clubInfo_.uid
end

function ChaGuanData.getMemberByUid(id)
    if id == 0 then
        id = clubInfo_.uid
    end
    for i,v in ipairs(memberList) do
        if v.uid == id then
            return v
        end
    end
end

function ChaGuanData.setMemberList(list)
    memberList = list
end

function ChaGuanData.getMemberList()
   return memberList
end

function ChaGuanData.setClubInfo(clubInfo)
    clubInfo_ = clubInfo
end

function ChaGuanData.getClubInfo()
    return clubInfo_
end

function ChaGuanData.setQueryWinnerScore(queryWinnerScore)
    clubInfo_.queryWinnerScore = queryWinnerScore
end

function ChaGuanData.getQueryWinnerScore()
    return clubInfo_.queryWinnerScore
end

function ChaGuanData.getClubID()
    return clubInfo_.clubID
end

function ChaGuanData.getClubName()
    return clubInfo_.name
end

function ChaGuanData.setConfig(config)
    config_ = config
end

function ChaGuanData.getConfig()
    return config_
end

function ChaGuanData.getGameConfig()
    return floorGameInfo_
end

function ChaGuanData.setGameConfig(info)
end

-- function ChaGuanData.getFloorGameConfig(floor)
--     if #clubInfo_.gameConfig == 0 then
--         return {}
--     end
--     for i,v in ipairs(clubInfo_.gameConfig) do
--         if v.floor == tonumber(floor) then
--             floorGameInfo_ = json.decode(v.play_config)
--             return floorGameInfo_
--         end
--     end
-- end

function ChaGuanData.addRoomInfo(roomInfo)
    roomList[roomInfo.roomID] = roomInfo 
end

function ChaGuanData.updateRoomInfo(roomInfo)
    roomList[roomInfo.roomID] = roomInfo 
end

function ChaGuanData.deleRoomInfo(roomID)
    roomList[roomID] = nil
end

return ChaGuanData 
