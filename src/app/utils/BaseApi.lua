local BaseApi = {}

function BaseApi.makeHttpSign_(fixedParams, paramString, key, token)
    local params = clone(fixedParams)
    params.params = paramString
    local keys = table.keys(params)
    table.sort(keys)
    local list = {}
    for _,k in ipairs(keys) do
        table.insert(list, k .. '=' .. string.urlencode(params[k]))
    end
    local str = table.concat(list, '&') .. "&key=" .. key
    if token and string.len(token) > 0 then
        str = str .. "&token=" .. token
    end
    return crypto.md5(str)
end

function BaseApi.makeURL_(url, api, fixedParams, paramString, token)
    local sign = BaseApi.makeHttpSign_(fixedParams, paramString, HTTP_SIGN_KEY, token)
    fixedParams.sign = sign
    local list = {}
    for k,v in pairs(fixedParams) do
        table.insert(list, k .. "=" .. string.urlencode(v))
    end
    return url .. api .. '?' .. table.concat(list, "&")
end

function BaseApi.makeFixedParams_()
    return {
        uid = selfData:getUid(),
        gameId = GAME_ID,
        platform = PLATFORM_IDS[device.platform] or -1,
        channelId = GAME_CHANNEL_ID,
        ver = VERSION_HOST,
        random = math.random(100000, 1000000),
        time = os.time(),
    }
end

local AUTH_APIS = {"Login", "Register", "WeixinLogin"}
local UPDATE_APIS = {"GetVersionUpdateInfo"}

function BaseApi.makeURLByApi_(api, paramString, token)
    local fixedParams = BaseApi.makeFixedParams_()
    local base_url = API_URL
    if table.indexof(AUTH_APIS, api) ~= false then
        base_url = AUTH_URL
    elseif table.indexof(UPDATE_APIS, api) ~= false then
        base_url = UPDATE_URL
    end
    local url = BaseApi.makeURL_(base_url, api, fixedParams, paramString, token)
    return url
end

function BaseApi.makeURLByApiTaiJiDun_(api, paramString, token)
    local fixedParams = BaseApi.makeFixedParams_()
    local base_url = API_URL
    if table.indexof(AUTH_APIS, api) ~= false then
        base_url = AUTH_URL
    elseif table.indexof(UPDATE_APIS, api) ~= false then
        base_url = UPDATE_URL
    end
    local params = {["host"] = base_url, ["port"] = HTTP_PORT, ["type"] = TYPE_TCP}
    local ret = getIPByTaiJiDun(params)
    local url
    if ret then
        if ret.host and ret.port then
            url = BaseApi.makeURL_(HTTP_HEAD .. ret.host .. ":" .. ret.port .. "/", api, fixedParams, paramString, token)
        end
    end
    base_url = getTaiJiDunName(base_url)
    return ret, url, base_url
end

function BaseApi.doRequest_(api, params, sucHandler, failHandler, token)
    local params = params or {}
    local paramString = json.encode(params)
    paramString = string.gsub(paramString, "%%", "%%%%")
    if token ~= nil then
        token = string.gsub(token, "%%", "%%%%")
    end

    local url = BaseApi.makeURLByApi_(api, paramString, token)
    -- local ret, url1, base_url = BaseApi.makeURLByApiTaiJiDun_(api, paramString, token)
    if ret and ret.host and ret.port then
        gailun.HTTP.post(url1, {params = paramString}, sucHandler, failHandler, 20)
    else
        gailun.HTTP.post(url, {params = paramString}, sucHandler, failHandler, 20)
    end
end

function BaseApi.doUpload_(api, params, extra, sucHandler, failHandler, token)
    local params = params or {}
    local extra = extra or {}
    local paramString = json.encode(extra)
    local url = BaseApi.makeURLByApi_(api, paramString, token)
    printInfo(paramString)
    gailun.HTTP.upload(url, params, {{"params", paramString}}, sucHandler, failHandler, 30)
end

--[[
拿到token前的请求方式
]]
function BaseApi.requestWithoutToken(api, params, sucHandler, failHandler)
    BaseApi.doRequest_(api, params, sucHandler, failHandler)
end

--[[
拿到token之后的请求方式
]]
function BaseApi.request(api, params, sucHandler, failHandler)
    BaseApi.doRequest_(api, params, sucHandler, failHandler, selfData:getToken())
end

function BaseApi.upload(api, params, extra, sucHandler, failHandler)
    BaseApi.doUpload_(api, params, extra, sucHandler, failHandler, selfData:getToken())
end

function BaseApi.download(url, filename, sucFunc, failFunc, timeoutSeconds, progressFunc)
    gailun.HTTP.download(url, filename, sucFunc, failFunc, timeoutSeconds, progressFunc)
end

return BaseApi
