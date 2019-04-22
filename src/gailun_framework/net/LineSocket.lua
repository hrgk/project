local ByteArray = require "framework.cc.utils.ByteArray"
local BaseSocket = require "gailun_framework.net.BaseSocket"

local LineSocket = class("LineSocket", BaseSocket)

local LINE_END_STRING = "\r\n"

function LineSocket:parseMessages_(__byteString)
    if not __byteString then
        return
    end
    
    self.socketData_ = self.socketData_ or ''
    self.socketData_ = self.socketData_ .. __byteString
    
    local msgs = {}
    local list = string.split(self.socketData_, LINE_END_STRING)
    if not list or #list <= 1 then
        return msgs
    end
    self.socketData_ = list[#list]
    for i = 1, #list - 1 do
        table.insert(msgs, list[i])
    end

    return msgs
end

function LineSocket:decryptData_(str)
    -- return gailun.utils.unzip(str)
    return str
end

function LineSocket:encryptData_(str)
    -- return gailun.utils.zip(str)
    return str
end

function LineSocket:decodeMessage_(message)
    assert(message and type(message) == 'string', "decodeMessage_ fail.")
    local data = self:decryptData_(message)
    return json.decode(data)
end

function LineSocket:encodeMessage_(message)
    assert(message and type(message) == 'table', "encodeMessage_ fail.")
    local data = json.encode(message)
    return self:encryptData_(data) .. LINE_END_STRING
end

return LineSocket
