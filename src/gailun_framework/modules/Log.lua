local Log = class("Log")
local utils = import("..utils.utils")

--[[
日志写入类，仅用作为DEBUG用
]]
function Log:ctor(path, filename)
    assert(path and filename)
    self.path_ = path
    self.fileName_ = filename
    utils.mkdir(self.path_, true)
end

function Log:getFilePath_()
    return self.path_ .. self.fileName_
end

function Log:reset()
    io.writefile(self:getFilePath_(), '', 'w+b')
end

function Log:log(...)
    local data = json.encode({...})
    local time = os.time()
    data = "TIME: " .. time .. " LOG: " .. data .. "\n"
    io.writefile(self:getFilePath_(), data, 'a+b')
    return self
end

return Log
