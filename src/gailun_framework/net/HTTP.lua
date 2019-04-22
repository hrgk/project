local JWLog = require "gailun_framework.modules.Log"
local HTTP = {}
local httpLogger = JWLog.new(device.writablePath, "http.log")
httpLogger:reset()
local TIMEOUT_SECONDS = 20  -- HTTP 超时时间

-- Content-Type: text/html; charset=utf-8
-- Content-Type: text/html; charset=gb2312
local function isGBK(header)
    local headers = string.split(header, "\r\n")
    for _, v in pairs(checktable(headers)) do
        if nil ~= string.find(string.lower(v), 'content-type') then
            if nil ~= string.find(string.lower(v), 'gb2312') then
                return true
            end
            if nil ~= string.find(string.lower(v), 'gbk') then
                return true
            end
        end
    end
    return false
end

local function onRequestFinished(url, event, sucFunc, failFunc)
    local ok = (event.name == "completed")
    local request = event.request

    if event.name == "progress" then
        return
    end

    if not ok then
        -- 请求失败，显示错误代码和错误消息
        print("HTTP request fail: ", event.name, request:getErrorCode(), request:getErrorMessage())
        if failFunc then failFunc() end
        return
    end

    local code = request:getResponseStatusCode()
    if code ~= 200 then
        -- 请求结束，但没有返回 200 响应代码
        print("HTTP code error: " .. code)
        local response = request:getResponseString()
        if failFunc then failFunc() end
        return
    end

    -- 请求成功
    local response = request:getResponseString()
    print("response==",response)
    if DEBUG > 0 then
        httpLogger:log('recv', url, json.decode(response))
    end
    if sucFunc then
        sucFunc(response)
    end
end

function HTTP.get(url, sucFunc, failFunc, timeoutSeconds)
    printInfo("get by %s", url)
    local seconds = timeoutSeconds or TIMEOUT_SECONDS
    local function handler_func(event)
        onRequestFinished(url, event, sucFunc, failFunc)
    end
    local request = network.createHTTPRequest(handler_func, url, "GET")
    request:addRequestHeader("Content-Type: application/x-www-form-urlencoded")
    request:setTimeout(seconds)
    request:start()
end

function HTTP.post(url, params, sucFunc, failFunc, timeoutSeconds)
    printInfo("post to %s", url)
    local seconds = timeoutSeconds or TIMEOUT_SECONDS
    -- 创建一个请求，并以 POST 方式发送数据到服务端
    local function handler_func(event)
        onRequestFinished(url, event, sucFunc, failFunc)
    end
    local request = network.createHTTPRequest(handler_func, url, "POST")
    request:addRequestHeader("Content-Type: application/x-www-form-urlencoded")
    local postData = ""
    for k, v in pairs(params) do
        postData = postData .. string.format("%s=%s&", k, string.urlencode(v))
    end
    if DEBUG > 0 then
        httpLogger:log('send', url, params)
    end
    postData = string.sub(postData, 1, -2)
    request:setPOSTData(postData)
    request:setTimeout(seconds)
    request:start() -- 开始请求。当请求完成时会调用 callback() 函数
end

local function onDownloaded(event, sucFunc, failFunc, progressFunc, filename)
    local ok = (event.name == "completed")
    local request = event.request

    if event.name == "progress" then
        if progressFunc then
            progressFunc(event.total or 0, event.dltotal or 0)  -- 通知下载进度
        end
    elseif not ok then
        -- 请求失败，显示错误代码和错误消息
        local errorCode = request:getErrorCode()
        local message = request:getErrorMessage()
        printInfo("HTTP download fail: " .. event.name .. " " .. errorCode .. " " .. message)
        if failFunc then
            failFunc(errorCode, message)
        end
    elseif ok then
        -- utils.logFile("before save file: ", filename)
        -- request:saveResponseData(filename) -- 此句在android写不下文件
        io.writefile(filename, request:getResponseData())
        -- utils.logFile("after save file: ", filename)
        if sucFunc then
            sucFunc(filename)
        end
    end
end

-- HTTP下载
function HTTP.download(url, filename, sucFunc, failFunc, timeoutSeconds, progressFunc)
    assert(filename)
    local seconds = timeoutSeconds or TIMEOUT_SECONDS
    local function handler_func(event)
        onDownloaded(event, sucFunc, failFunc, progressFunc, filename)
    end
    local request = network.createHTTPRequest(handler_func, url, "GET")
    request:setTimeout(seconds)
    request:start()
end


local function onUpload(event, sucFunc, failFunc, progressFunc)
    local ok = (event.name == "completed")
    local request = event.request
    if event.name == "progress" then
        if progressFunc then
            progressFunc(event.total or 0, event.dltotal or 0)  -- 通知下载进度
        end
    elseif not ok then
        -- 请求失败，显示错误代码和错误消息
        local errorCode = request:getErrorCode()
        local message = request:getErrorMessage()
        printInfo("HTTP upload fail: " .. event.name .. " " .. errorCode .. " " .. message)
        if failFunc then
            failFunc(errorCode, message)
        end
    elseif ok then
        local response = request:getResponseString()
        if sucFunc then
            sucFunc(response)
        else
            print(response)
        end
    end
end

function HTTP.upload(url, params, extra, sucFunc, failFunc, timeoutSeconds, progressFunc)
    assert(params and params.fieldName and params.fileName and params.contentType)
    local seconds = timeoutSeconds or TIMEOUT_SECONDS
    local function handler_func(event)
        onUpload(event, sucFunc, failFunc, progressFunc)
    end
    local datas = {
        fileFieldName = params.fieldName,
        filePath = params.fileName,
        contentType = params.contentType,
        extra = extra,
    }
    network.uploadFile(handler_func, url, datas)
end

return HTTP