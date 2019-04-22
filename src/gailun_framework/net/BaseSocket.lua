local SocketTCP = require "framework.cc.net.SocketTCP"
local JWQueue = require "gailun_framework.modules.Queue"
local JWLog = require "gailun_framework.modules.Log"
local ByteArray = require "framework.cc.utils.ByteArray"
local socketLoger = JWLog.new(device.writablePath, "socket.log")
socketLoger:reset()
local debugReceive = function (...) socketLoger:log('recv', ...) end
local debugSend = function (...) 
    --dump(debug.traceback(),"debugSenddebugSend")
socketLoger:log('send', ...) end
if DEBUG == 0 then
    debugReceive = function (...) end
    debugSend = function (...) end
end

local function printByte(message)
    if not DEBUG or DEBUG < 1 then
        return
    end
    if not message or type(message) ~= "string" then
        printInfo(message)
        return
    end
    local ret = ""
    for i=1, #message do
        ret = ret .. " " .. string.byte(string.sub(message, i, i))
    end
    printInfo(ret)
end


local BaseSocket = class("BaseSocket")
BaseSocket.EVENT_CONNECTED = SocketTCP.EVENT_CONNECTED
BaseSocket.EVENT_CLOSE = SocketTCP.EVENT_CLOSE
BaseSocket.EVENT_CLOSED = SocketTCP.EVENT_CLOSED
BaseSocket.EVENT_CONNECT_FAILURE = SocketTCP.EVENT_CONNECT_FAILURE
BaseSocket.EVENT_DATA = SocketTCP.EVENT_DATA
BaseSocket.EVENT_MESSAGE = "BaseSocket.EVENT_MESSAGE"

function BaseSocket:ctor()
    cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()
    self.endian_ = ByteArray.ENDIAN_BIG  -- 默认endian
    self.parse_buf_ = ByteArray.new(self.endian_)
end

function BaseSocket:setEndian(endian)
    assert(endian == ByteArray.ENDIAN_BIG or endian == ByteArray.ENDIAN_LITTLE)
    self.endian_ = endian
    self.parse_buf_:setEndian(self.endian_)
    return self
end

function BaseSocket:isInConnect()
    if not self.socket_ then
        return false
    end
    return self.socket_.inConnect_
end

function BaseSocket:isConnected()
    if self.socket_ then
        return self.socket_.isConnected
    end
    return false
end

function BaseSocket:onData_(__event)
    if not __event.data then
        return
    end

    local msgs = self:parseMessages_(__event.data)
    for _, data in pairs(msgs) do
        local message = self:decodeMessage_(data)
        if message then
            if DEBUG > 0 then
                debugReceive(message)
            end
            self:onMessage_(message)
        end
    end
end

function BaseSocket:onMessage_(message)
    local flag, err = pcall(function ()
        self:dispatchEvent({name = BaseSocket.EVENT_MESSAGE, data = message})
    end)
    if not flag then
        print(err)
    end
end

local function printStatus(status)
    printInfo(string.format("SOCKET STATUS UPDATE: %s", status))
end

function BaseSocket:onStatus_(__event)
    self:dispatchEvent({name = __event.name})
    printStatus(__event.name)
end

function BaseSocket:getHost()
    if not self.socket_ then
        return
    end
    return self.socket_.host
end

function BaseSocket:getPort()
    if not self.socket_ then
        return 0
    end
    return self.socket_.port
end

function BaseSocket:connect(...)
    if not self.socket_ then
        self.socket_ = SocketTCP.new(...)
        self:addSocketEventListener_(SocketTCP.EVENT_CONNECTED, handler(self, self.onStatus_))
        self:addSocketEventListener_(SocketTCP.EVENT_CLOSE, handler(self, self.onStatus_))
        self:addSocketEventListener_(SocketTCP.EVENT_CLOSED, handler(self, self.onStatus_))
        self:addSocketEventListener_(SocketTCP.EVENT_CONNECT_FAILURE, handler(self, self.onStatus_))
        self:addSocketEventListener_(SocketTCP.EVENT_DATA, handler(self, self.onData_))
    end
    assert(self.socket_ ~= nil, "socket create fail!")
    
    self.socket_:connect(...)
end

function BaseSocket:addSocketEventListener_(eventName, func)
    assert(eventName and func, "add Socket event listener fail!")
    self.socket_:addEventListener(eventName, func)
end

function BaseSocket:close()
    if self.socket_ and self.socket_.tcp then
        self.socket_:close()
        self.socket_ = nil
    end
    return self
end

function BaseSocket:clean()
    if self.socket_ then
        self.socket_:removeAllEventListeners()
    end
    self:removeAllEventListeners()
    return self
end

function BaseSocket:send(message)
    if not self:isConnected() then
        printInfo("BaseSocket:send fail without connect!")
        return false
    end
    debugSend(message)
    local buf = self:encodeMessage_(message)
    self.socket_:send(buf)
    return true
end

function BaseSocket:parseMessages_(__byteString)
    assert(false, "BaseSocket:parseMessages_ MUST BE OVERWRITE!")
end

function BaseSocket:decryptData_(str)
    assert(false, "BaseSocket:decryptData_ MUST BE OVERWRITE!")
end

function BaseSocket:encryptData_(str)
    assert(false, "BaseSocket:encryptData_ MUST BE OVERWRITE!")
end

function BaseSocket:decodeMessage_(message)
    assert(false, "BaseSocket:decodeMessage_ MUST BE OVERWRITE!")
end

function BaseSocket:encodeMessage_(message)
    assert(false, "BaseSocket:encodeMessage_ MUST BE OVERWRITE!")
end

return BaseSocket
