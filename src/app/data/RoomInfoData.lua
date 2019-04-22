local RoomInfoData = {}
local list = {}

function RoomInfoData.resetData()
    list = {}
end

function RoomInfoData.addRoomData(data)
    list[data.tid] = data
end

function RoomInfoData.delRoomData(roomID)
    list[roomID] = nil
end

function RoomInfoData.updateRoomData(data)
    if data.is_del == 1 then 
        list[data.tid] = nil
    else
        list[data.tid].player_list = data.player_list
        list[data.tid].round_index = data.round_index
        list[data.tid].table_status = data.table_status
        list[data.tid].tid = data.tid
    end
end

function RoomInfoData.getArrList()
    local arr = {}
    for k,v in pairs(list) do
        arr[#arr+1] = v
    end
    return arr
end

function RoomInfoData.getRoomCount()
    local count = 0
    for k,v in pairs(list) do
        count = count + 1
    end
    return count
end

function RoomInfoData.getList()
    return list
end

return RoomInfoData 
