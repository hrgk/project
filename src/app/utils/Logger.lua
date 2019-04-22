local _logger = (require "gailun_framework.modules.Log").new(device.writablePath, "xxx.log")
_logger:reset()
Logger = {}

--UnityDebug = CS.UnityEngine.Debuger
--UnityDebug.EnableLog = 2

Logger.enable = true

function logPrint(...)
    local msg = debug.getinfo(3, "S").source .. "(" .. tostring(debug.getinfo(3, "l").currentline) .. "): "
    local function __logPrint(x)
        if type(x) == "table" then
            msg = msg .. "{"
            local largest = 0
            local first = true
            for k, v in ipairs(x) do
                if not first then
                    msg = msg .. ", "
                end
                first = false
                largest = k
                __logPrint(v)
            end

            for k, v in pairs(x) do --> {...} 表示一个由所有变长参数构成的数组
                if type(k) ~= "number" or k < 1 or k > largest or math.floor(k) ~= k then
                    if not first then
                        msg = msg .. ", "
                    end
                    first = false
                    __logPrint(k)
                    msg = msg .. "=>"
                    __logPrint(v)
                end
            end
            msg = msg .. "}"
        else
            msg = msg .. tostring(x)
        end
    end
    for i = 1, select("#", ...) do
        __logPrint(select(i, ...))
    end
    return msg
end

Logger.Debug = function(...)
    --if Debug.enable == true and UnityDebug.EnableLog == 2 then
    if Logger.enable == true  then
        local msg = logPrint(...)
        _logger:log(msg)
        --UnityDebug.Log(msg .. "\n" .. debug.traceback(nil, 2))
    end
end



return Logger
