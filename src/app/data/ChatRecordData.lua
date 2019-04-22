local BaseLocalUserData = import(".BaseLocalUserData")
local ChatRecordData = class("ChatRecordData", BaseLocalUserData)

local CHAT_RECORD = "CHAT_RECORD"

function ChatRecordData:ctor()
    ChatRecordData.super.ctor(self)
    self.record = json.decode(self:getUserLocalData(CHAT_RECORD) or json.encode({})) or {}
end

function ChatRecordData:addGameRecord(fileName, params)
    table.insert(self.record, {time = gailun.utils.getTime(), fileName = fileName, params = params})
    self:setUserLocalData(CHAT_RECORD, json.encode(self.record))
end

function ChatRecordData:clearGameRecord()
    for k, v in pairs(self.record) do
        cc.FileUtils:getInstance():removeFile(v.fileName)
    end
    self.record = {}
    self:setUserLocalData(CHAT_RECORD, json.encode(self.record))
end

function ChatRecordData:getGameRecord()
    return self.record
end

return ChatRecordData
